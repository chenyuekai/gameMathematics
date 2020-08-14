local MSG_ENTITY_TYPE = require("core2_0.MsgEntity.MsgEntityType")
local __uid = -1
local function getUnitId( ... )
	__uid = __uid + 2
	return __uid
end

local RequestMessage = {
	
	-- [getUnitId()] = {
	-- 	name = "login",
	-- 	param = MSG_ENTITY_TYPE.loginMsg,
	-- 	response = MSG_ENTITY_TYPE.loginResult,
	-- },
}
for k,v in pairs(RequestMessage) do
	v.id = k
end
if not _G.inTool then
	local tmp = {}
	for k,v in pairs(RequestMessage) do
		tmp[k] = v
		tmp[v.name] = v
	end
	RequestMessage = tmp
end
return RequestMessage