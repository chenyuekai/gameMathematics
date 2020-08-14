local beginId = 10000
local function getUnitId( ... )
	beginId = beginId + 1
	return beginId
end

local EventType = {
	XPROXY_IVALID_REQUSET_ID = getUnitId(),
	XPROXY_CLIENT_REQUEST = getUnitId(),
	CLIENT_DISCONNECT = getUnitId(),
	FORCE_CLOSE_CLIENT = getUnitId(),
	CLEAR_ROOM_ID = getUnitId(),
	GAME_OVER = getUnitId(),
}

_G.EventType = EventType