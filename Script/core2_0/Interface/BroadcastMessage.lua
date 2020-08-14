local MSG_ENTITY_TYPE = require("core2_0.MsgEntity.MsgEntityType")
local __uid = 0
local function getUnitId( ... )
	__uid = __uid + 2
	return __uid
end

local BroadcastMessage = {
	
	-- [getUnitId()] = {
	-- 	name = "pustServerTime",
	-- 	msgType = MSG_ENTITY_TYPE.ServerTimeData,
	-- },
	
}

return BroadcastMessage