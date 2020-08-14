local MSG_ENTITY_TYPE = require("core2_0.MsgEntity.MsgEntityType")

local ReadSerialize = {}
function ReadSerialize:create(buffer,currentP)
	local M = {}
	currentP = currentP or 1
	function M:readInt32( )
		local val = string.unpack(">i4",buffer,currentP)
		currentP = currentP + 4
		return val
	end
	function M:readUInt32( )
		local val = string.unpack(">I4",buffer,currentP)
		currentP = currentP + 4
		return val
	end
	function M:readUInt16( )
		local val = string.unpack(">I2",buffer,currentP)
		currentP = currentP + 2
		return val
	end
	function M:readString()
		local str,p = string.unpack(">s2",buffer,currentP)
		currentP = p
		return str
	end
	function M:readBool()
		local bool ,p = string.unpack("B",buffer,currentP)
		currentP = p
		return not (bool == 0) 
	end
	function M:readInt64( )
		local val,p = string.unpack(">i8",buffer,currentP)
		currentP = p
		return val
	end
	function M:readArray(array,arrayType)
		local size = self:readUInt16()
		if arrayType == MSG_ENTITY_TYPE.INT then
			for i=1,size do
				array[i] = self:readInt32()
			end
		elseif arrayType == MSG_ENTITY_TYPE.STRING then
			for i=1,size do
				array[i] = self:readString()
			end
		elseif arrayType == MSG_ENTITY_TYPE.BOOL then
			for i=1,size do
				array[i] = self:readBool()
			end
		elseif arrayType == MSG_ENTITY_TYPE.INT64 then
			for i=1,size do
				array[i] = self:readInt64()
			end
		elseif type(arrayType) == "table" then
			for i=1,size do
				local subArrayType = arrayType[0]
				local tmp = {}
				self:readArray(tmp,arrayType[1])
				array[i] = tmp
			end
		else
			for i=1,size do
				array[i] = self:readObj(arrayType)
			end
		end
		return array
	end 
	function M:readObj(msgType)
		local msgClass = MsgEntity[msgType]
		local obj = msgClass:create()
		local names = obj:getMemberNames()
		local types = obj:getMemberTypes()
		for i,v in ipairs(names) do
			local curType = types[i]
			if curType == MSG_ENTITY_TYPE.INT then
				obj[v] = self:readInt32()
			elseif curType == MSG_ENTITY_TYPE.STRING then
				obj[v] = self:readString()
			elseif curType == MSG_ENTITY_TYPE.BOOL then
				obj[v] = self:readBool()
			elseif curType == MSG_ENTITY_TYPE.INT64 then
				obj[v] = self:readInt64()
			elseif type(curType) == "table" then
				self:readArray(obj[v],curType[1]);
			else
				obj[v] = self:readObj(curType)
			end 
		end
		return obj
	end
	return M;
end

_G.ReadSerialize = ReadSerialize

local WriteSerialize = {}
function WriteSerialize:create()
	local buffer = ""
	local M = {}
	function M:writeInt32(val) 
		val = math.floor(val)
		local str = string.pack(">i4",val)
		buffer = buffer .. str
	end
	function M:writeUInt32(val)
		val = math.floor(val)
		local str = string.pack(">I4",val)
		buffer = buffer .. str
	end
	function M:writeUInt16(val)
		val = math.floor(val)
		local str = string.pack(">I2",val)
		buffer = buffer .. str
	end
	function M:writeString(val)
		local str = string.pack(">s2",val)
		buffer = buffer .. str
	end
	function M:writeBool(val)
		if val then
			local b = string.pack("B",1)
			buffer = buffer .. b
		else
			local b = string.pack("B",0)
			buffer = buffer .. b
		end 
	end
	function M:writeInt64( val )
		val = math.floor(val)
		local str = string.pack(">i8",val)
		buffer = buffer .. str
	end
	function M:writeArray(array,arrayType)
		local size = #array
		self:writeUInt16(size)
		if size == 0 then return end 
		if arrayType == MSG_ENTITY_TYPE.INT then
			for i,v in ipairs(array) do
				self:writeInt32(v)
			end
		elseif arrayType == MSG_ENTITY_TYPE.STRING then
			for i,v in ipairs(array) do
				self:writeString(v)
			end
		elseif arrayType == MSG_ENTITY_TYPE.BOOL then
			for i,v in ipairs(array) do
				self:writeBool(v)
			end
		elseif arrayType == MSG_ENTITY_TYPE.INT64 then
			for i,v in ipairs(array) do
				self:writeInt64(v)
			end
		elseif type(arrayType) == "table" then
			local subArrayType = arrayType[1]
			for i,v in ipairs(array) do
				self:writeArray(v,subArrayType)
			end
		else
			for i,v in ipairs(array) do
				self:writeObj(v)
			end
		end 
	end 
	function M:writeObj(obj)
		local names = obj:getMemberNames()
		local types = obj:getMemberTypes()
		for i,v in ipairs(names) do
			local val = obj[v]
			local curType = types[i]
			if curType == MSG_ENTITY_TYPE.INT then
				self:writeInt32(val)
			elseif curType == MSG_ENTITY_TYPE.STRING then
				self:writeString(val)
			elseif curType == MSG_ENTITY_TYPE.BOOL then
				self:writeBool(val)
			elseif curType == MSG_ENTITY_TYPE.INT64 then
				self:writeInt64(val)
			elseif type(curType) == "table" then
				self:writeArray(val,curType[1])
			else
				self:writeObj(val)
			end 
		end
	end
	function M:getBuffer( ... )
		return buffer
	end

	function M:dump()
		print("size:",buffer:len())
		print(buffer:byte(1,buffer:len()))
	end
	return M
end
_G.WriteSerialize = WriteSerialize
_G.ReadSerialize = ReadSerialize
return {
	WriteSerialize = WriteSerialize,
	ReadSerialize = ReadSerialize
}
