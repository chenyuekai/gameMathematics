require("core2_0.Serialize")
require("core2_0.Dispatcher")
local MSG_ENTITY_TYPE = require("core2_0.MsgEntity.MsgEntityType")
local RequestMessage = require("core2_0.Interface.RequestMessage")
local BroadcastMessage = require("core2_0.Interface.BroadcastMessage")

local function syncObj(obj,param)
	local names = obj:getMemberNames()
	local types = obj:getMemberTypes()
	local function makeArray(arrayType,param)
		local arr = {}
		if type(arrayType) == "table" then
			local subArrayType = arrayType[1]
			for i,v in ipairs(param) do
				arr[i] = makeArray(subArrayType,v)
			end
		else
			if arrayType == MSG_ENTITY_TYPE.INT or arrayType == MSG_ENTITY_TYPE.STRING
			or arrayType == MSG_ENTITY_TYPE.BOOL or arrayType == MSG_ENTITY_TYPE.INT64 then
				for i,v in ipairs(param) do
					arr[i] = v
				end 
			else
				for i,v in pairs(param) do
					local msgClass =  MsgEntity[arrayType]
					local obj = msgClass:create()
					syncObj(obj,v)
					arr[i] = obj
				end
			end
		end  
		return arr
	end
	for i,v in ipairs(names) do
		if param[v] then
			local curType = types[i]
			if curType == MSG_ENTITY_TYPE.INT or curType == MSG_ENTITY_TYPE.STRING
			or curType == MSG_ENTITY_TYPE.BOOL or curType == MSG_ENTITY_TYPE.INT64 then
				obj[v] = param[v]
			elseif type(curType) == "table" then
				local arrayType = curType[1]
				obj[v] = makeArray(arrayType,param[v])
			else
				syncObj(obj[v],param[v])
			end 
		end 
	end
end

local XProxy = {}
local print = print
local __dataSendFunc = function ( ... )
	print(...)
end
function XProxy:__init( dataSendFunc,printFunc)
	if type(dataSendFunc) == "function" then
		__dataSendFunc = dataSendFunc
	end 
	if printFunc then
		print = printFunc
	end 
end
for k,v in pairs(BroadcastMessage) do
	local name = v.name
	XProxy["_make_"..name] = function (self,msg,sessionId)	
		local function real( )
			sessionId = sessionId or 0
			local interfaceId = k
			local writer = WriteSerialize:create()
			writer:writeUInt32(interfaceId)
			writer:writeUInt32(sessionId)
			if v.msgType >=0 then
				if not msg.isNetMsg then
					local msgClass = MsgEntity[v.msgType]
					local obj = msgClass:create()
					syncObj(obj,msg)
					writer:writeObj(obj)
				else
					writer:writeObj(msg)
				end
			end 
			local data = writer:getBuffer()
			return data
		end
		local f,msg = xpcall(real,debug.traceback)
		if not f then
			print("xproxy error :"..name)
			print(msg)	
		end
		return msg
	end
	XProxy[name] = function (self,wsId,msg,sessionId,...)
		if yk_test then
			if name ~= "countDownPush" then
				print("broadcast:"..name,wsId)
			end 
		end 
		local function real(...)
			local data = XProxy["_make_"..name](self,msg,sessionId)
			__dataSendFunc(wsId,data,...)
		end
		local f,msg = xpcall(real,debug.traceback,...)
		if not f then
			print("xproxy error:"..name)
			print(msg)	
		end
		return msg
	end
end

local waitForResponse = {}


local function __parse( buff )
	local reader = ReadSerialize:create(buff)
	local interfaceId = reader:readUInt32()
	local sessionId = reader:readUInt32()
	local interfaceInfo = RequestMessage[interfaceId]
	if not interfaceInfo then
		return 
	end
	local msgType = interfaceInfo.param
	local obj = nil
	if msgType ~= MSG_ENTITY_TYPE.NONE then
		obj = reader:readObj(msgType)
	end
	return {
		msg = obj,
		sessionId = sessionId,
		interfaceInfo = interfaceInfo,
	}
end
function XProxy:__rpcUnpack( buff )
	local f,result = pcall(__parse,buff)
	if f then
		return result
	else 
		error(result)
		return nil
	end

end

function XProxy:__onMessage( buff , ws)
	local reader = ReadSerialize:create(buff)
	local interfaceId = reader:readUInt32()
	local sessionId = reader:readUInt32()
	local interfaceInfo = RequestMessage[interfaceId]
	if not interfaceInfo then
		Dispatcher:dispatchEvent(EventType.XPROXY_IVALID_REQUSET_ID,{
			interfaceId = interfaceId,
			sessionId = sessionId,
		})
		return 
	end 
	local msgType = interfaceInfo.param
	local obj = nil
	if msgType ~= MSG_ENTITY_TYPE.NONE then
		obj = reader:readObj(msgType)
	end 
	if sessionId ~= 0 then
		waitForResponse[sessionId] = interfaceInfo
	end
	local response = function ( param,isError )
		if sessionId ~= 0 then
			XProxy:__onResponse(ws,sessionId,param,isError)
		end
	end
	local msgName = interfaceInfo.name	
	Dispatcher:dispatchEvent(EventType.XPROXY_CLIENT_REQUEST,{
		name = msgName,
		interfaceInfo = interfaceInfo,
		sessionId = sessionId,
		msg = obj,
		ws = ws,
		response = response,
	})	
end
function XProxy:decodeRequire( buff )
	local reader = ReadSerialize:create(buff)
	local interfaceId = reader:readUInt32()
	local sessionId = reader:readUInt32()
	local interfaceInfo = RequestMessage[interfaceId]
	if not interfaceInfo then
		return 
	end 
	local msgType = interfaceInfo.param
	local obj = nil
	if msgType ~= MSG_ENTITY_TYPE.NONE then
		obj = reader:readObj(msgType)
	end 
	return {
		interfaceInfo = interfaceInfo,
		msg = obj,
		sessionId = sessionId,
	}
end

function XProxy:__onResponse(ws,sessionId,param,isError)
	if waitForResponse[sessionId] then
		if isError then
			self:errorPush(ws,param,sessionId)
		else
			local interfaceInfo = waitForResponse[sessionId]
			local interfaceId = interfaceInfo.id
			local writer = WriteSerialize:create()
			writer:writeUInt32(interfaceId)
			writer:writeUInt32(sessionId)
			if not param.isNetMsg then
				local msgClass = MsgEntity[interfaceInfo.response]
				local obj = msgClass:create()
				syncObj(obj,param)
				writer:writeObj(obj)
				ws:send_binary(writer:getBuffer())
			else
				writer:writeObj(param)
				ws:send_binary(writer:getBuffer())
			end
		end
		waitForResponse[sessionId] = nil
	end
end
function XProxy:__makeSendData( interfaceInfo,sessionId,msg )
	local writer = WriteSerialize:create()
	writer:writeUInt32(interfaceInfo.id)
	writer:writeUInt32(sessionId)
	if not msg.isNetMsg then
		local msgClass = MsgEntity[interfaceInfo.response]
		local obj = msgClass:create()
		syncObj(obj,msg)
		writer:writeObj(obj)
		
	else
		writer:writeObj(msg)
	end
	return writer:getBuffer()
end
function XProxy:__makeMsg( msgType,msg)
	local msgClass = MsgEntity[msgType]
	local obj = msgClass:create()
	syncObj(obj,msg)
	return obj
end
_G.XProxy = XProxy
return XProxy