local MSG_ENTITY_TYPE = {
	NONE = -1,
	INT = 0,
	STRING = 1,
	ARRAY = 2,
	BOOL = 3,
	INT64 = 4,-- unuse
	
	agentInfo = 7,
	match = 8,
	pos = 9,
	playerInfo = 10,
	startGameInfo = 11,
	statusInfo = 12,
	scoreInfo = 13,
	ballPosSyncInfo = 14,
	hitInfo = 15,
	statusInfoList = 16,
	scoreInfoList = 17,
	addScore = 18,
	hitfinishInfo = 19,
	uidInfo = 20,
	gameResultInfo = 21,
	overInfo = 22,
	roomIdInfo = 23,
	mapInfo = 24,
	jsonData = 25,
	reconnectInfo = 26,
}

_G.MSG_ENTITY_TYPE = MSG_ENTITY_TYPE
return MSG_ENTITY_TYPE