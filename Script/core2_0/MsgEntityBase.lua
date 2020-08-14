local MSG_ENTITY_TYPE = require("core2_0.MsgEntity.MsgEntityType")
local MsgEntity = {}
local MSG_ENUM = {}
local MsgBase = {}
MsgBase.isNetMsg = true
function MsgBase:getMemberNames()
	return self.__names
end
function MsgBase:getMemberTypes()
	return self.__types
end
function MsgBase:getMsgType()
	return self.__msgType
end

local l_baseType = true
local function newMsgClass(msg)
	setmetatable(msg,{__index = MsgBase})
	local MsgBaseMeta = {
		__index = function ( table,key)
			if msg[key] then
				return msg[key]
			else
				error("table not this member:"..key)
			end 
		end,
		__newindex = function(table,key,val) 
			error("can not assign value:"..key)
		end,
	}
	local M = {}
	M.isBaseType = l_baseType
	function M:create( ... )
		local inst = {}
		local names = msg:getMemberNames()
		local types = msg:getMemberTypes()
		for i,v in ipairs(types) do
			if v == MSG_ENTITY_TYPE.INT then
				inst[names[i]] = 0
			elseif v == MSG_ENTITY_TYPE.STRING then
				inst[names[i]] = ""
			elseif v == MSG_ENTITY_TYPE.BOOL then
				inst[names[i]] = false
			elseif v == MSG_ENTITY_TYPE.INT64 then
				inst[names[i]] = 0
			elseif type(v) == "table" then
				inst[names[i]] = {
					__type = v[0]
				}
			else
				local subMsg = MsgEntity[v]:create()
				inst[names[i]] = subMsg
			end 
		end
		setmetatable(inst,MsgBaseMeta)
		return inst
	end
	function M:addEnum( name ,enum )
		MSG_ENUM[M:getMsgType()] = MSG_ENUM[M:getMsgType()] or {}
		MSG_ENUM[M:getMsgType()][name] = enum
		return M
	end
	function M:getEnum( name )
		if MSG_ENUM[M:getMsgType()] then
			return MSG_ENUM[M:getMsgType()][name]
		end 
	end
	setmetatable(M,MsgBaseMeta)
	MsgEntity[M:getMsgType()] = M
	return M
end

local _preIntMsg = {
	__names = {
		"_int"
	},
	__types = {
		MSG_ENTITY_TYPE.INT,
	},
	__msgType = MSG_ENTITY_TYPE.INT
}
newMsgClass(_preIntMsg)

local _preStringMsg = {
	__names = {
		"_string"
	},
	__types = {
		MSG_ENTITY_TYPE.STRING,
	},
	__msgType = MSG_ENTITY_TYPE.STRING
}
newMsgClass(_preStringMsg)

local _preBoolMsg = {
	__names = {
		"_bool"
	},
	__types = {
		MSG_ENTITY_TYPE.BOOL,
	},
	__msgType = MSG_ENTITY_TYPE.BOOL
}
newMsgClass(_preBoolMsg)

local _preInt64Msg = {
	__names = {
		"_int64"
	},
	__types = {
		MSG_ENTITY_TYPE.INT64,
	},
	__msgType = MSG_ENTITY_TYPE.INT64
}
newMsgClass(_preInt64Msg)
l_baseType = false

_G.MsgEntity = MsgEntity
_G.MSG_ENUM = MSG_ENUM
return {
	newMsgClass = newMsgClass
}