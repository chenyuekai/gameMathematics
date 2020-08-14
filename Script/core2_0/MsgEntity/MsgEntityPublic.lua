local newMsgClass = require("core2_0.MsgEntityBase").newMsgClass
local MSG_ENTITY_TYPE = require("core2_0.MsgEntity.MsgEntityType")

-- newMsgClass( {
-- 	__names = {
-- 		"flag",--0 代表登录成功
-- 		"userInfo",
-- 	},
-- 	__types = {
-- 		MSG_ENTITY_TYPE.INT,
-- 		MSG_ENTITY_TYPE.userInfo,
-- 	},
-- 	__msgType = MSG_ENTITY_TYPE.loginResult
-- })

-- newMsgClass({
-- 	__names = {
-- 		"status",
-- 	},
-- 	__types = {
-- 		MSG_ENTITY_TYPE.INT,
-- 	},
-- 	__msgType = MSG_ENTITY_TYPE.test
-- }):addEnum("status",{
-- 	E_START = 1,
-- 	E_END = 2,
-- 	E_FAILED = 3,
-- })
newMsgClass( {
	__names = {
		"uid",--
		"headimgurl",
		"user_nickname",
		"sex",
	},
	__types = {
		MSG_ENTITY_TYPE.STRING,
		MSG_ENTITY_TYPE.STRING,
		MSG_ENTITY_TYPE.STRING,
		MSG_ENTITY_TYPE.STRING,
	},
	__msgType = MSG_ENTITY_TYPE.agentInfo
})
newMsgClass( {
	__names = {
		"uid",--
		"agentInfo",
		"room_id",
		"channel_id",
		"isAI",
		"newRoom",
	},
	__types = {
		MSG_ENTITY_TYPE.STRING,
		MSG_ENTITY_TYPE.agentInfo,
		MSG_ENTITY_TYPE.STRING,
		MSG_ENTITY_TYPE.STRING,
		MSG_ENTITY_TYPE.BOOL,
		MSG_ENTITY_TYPE.BOOL,	
	},
	__msgType = MSG_ENTITY_TYPE.match
})
newMsgClass( {
	__names = {
		"xm",
		"ym"
	},
	__types = {
		MSG_ENTITY_TYPE.INT,
		MSG_ENTITY_TYPE.INT,
	},
	__msgType = MSG_ENTITY_TYPE.pos
})
newMsgClass( {
	__names = {
		"uid",
		"score",
		"status",
		"pos",
	},
	__types = {
		MSG_ENTITY_TYPE.STRING,
		MSG_ENTITY_TYPE.INT,
		MSG_ENTITY_TYPE.INT,
		MSG_ENTITY_TYPE.pos,
	},
	__msgType = MSG_ENTITY_TYPE.playerInfo
}):addEnum("E_STATUS",{
	WAIT = 1,
	HITTING = 2,
})

newMsgClass( {
	__names = {
		"myInfo",
		"rivalInfo",
		"rivaAgentInfo",
		"mapId",
		"leaveTime",
		-- "gameLength",
	},
	__types = {
		MSG_ENTITY_TYPE.playerInfo,
		MSG_ENTITY_TYPE.playerInfo,
		MSG_ENTITY_TYPE.agentInfo,
		MSG_ENTITY_TYPE.INT,
		MSG_ENTITY_TYPE.INT,
		-- MSG_ENTITY_TYPE.INT,
	},
	__msgType = MSG_ENTITY_TYPE.startGameInfo
})
newMsgClass( {
	__names = {
		"status",
		"uid",
	},
	__types = {
		MSG_ENTITY_TYPE.INT,
		MSG_ENTITY_TYPE.STRING,
	},
	__msgType = MSG_ENTITY_TYPE.statusInfo
})
newMsgClass( {
	__names = {
		"statusInfoList",
		"extInt",
		"leaveTime",
	},
	__types = {
		{MSG_ENTITY_TYPE.statusInfo},
		MSG_ENTITY_TYPE.INT,
		MSG_ENTITY_TYPE.INT,
	},
	__msgType = MSG_ENTITY_TYPE.statusInfoList
})
newMsgClass( {
	__names = {
		"score",
		"uid",
	},
	__types = {
		MSG_ENTITY_TYPE.INT,
		MSG_ENTITY_TYPE.STRING,
	},
	__msgType = MSG_ENTITY_TYPE.scoreInfo
})
newMsgClass( {
	__names = {
		"scoreInfoList",
	},
	__types = {
		{MSG_ENTITY_TYPE.scoreInfo}
	},
	__msgType = MSG_ENTITY_TYPE.scoreInfoList
})
newMsgClass( {
	__names = {
		"pos",
		"uid",
	},
	__types = {
		MSG_ENTITY_TYPE.pos,
		MSG_ENTITY_TYPE.STRING,
	},
	__msgType = MSG_ENTITY_TYPE.ballPosSyncInfo
})
newMsgClass( {
	__names = {
		"myPos",
		"myDirection",
		"rivalPos",
		"rivalDirection",
		"uid",
	},
	__types = {
		MSG_ENTITY_TYPE.pos,
		MSG_ENTITY_TYPE.pos,
		MSG_ENTITY_TYPE.pos,
		MSG_ENTITY_TYPE.pos,
		MSG_ENTITY_TYPE.STRING,
	},
	__msgType = MSG_ENTITY_TYPE.hitInfo
})
newMsgClass( {
	__names = {
		"uid",
		"addScore",
	},
	__types = {
		MSG_ENTITY_TYPE.STRING,
		MSG_ENTITY_TYPE.INT
	},
	__msgType = MSG_ENTITY_TYPE.addScore
})

newMsgClass( {
	__names = {
		"extInt",
		"uid"
	},
	__types = {
		MSG_ENTITY_TYPE.INT,
		MSG_ENTITY_TYPE.STRING,
	},
	__msgType = MSG_ENTITY_TYPE.hitfinishInfo
})

newMsgClass( {
	__names = {
		"uid"
	},
	__types = {
		MSG_ENTITY_TYPE.STRING,
	},
	__msgType = MSG_ENTITY_TYPE.uidInfo
})

newMsgClass( {
	__names = {
		"resultStatus",
		"sign",
		"timestamp",
		"result",
		"nonstr",
		"scoreInfos"
	},
	__types = {
		MSG_ENTITY_TYPE.INT,
		MSG_ENTITY_TYPE.STRING,
		MSG_ENTITY_TYPE.STRING,
		MSG_ENTITY_TYPE.STRING,
		MSG_ENTITY_TYPE.STRING,
		{MSG_ENTITY_TYPE.scoreInfo}
	},
	__msgType = MSG_ENTITY_TYPE.gameResultInfo
}):addEnum("resultStatus",{
	I_failed = -1,
	none_win = 0,
	I_win = 1,
})

newMsgClass( {
	__names = {
		"uid",
		"winUid",
	},
	__types = {
		MSG_ENTITY_TYPE.STRING,
		MSG_ENTITY_TYPE.STRING,
	},
	__msgType = MSG_ENTITY_TYPE.overInfo
})

newMsgClass( {
	__names = {
		"roomId",
	},
	__types = {
		MSG_ENTITY_TYPE.STRING,
	},
	__msgType = MSG_ENTITY_TYPE.roomIdInfo
})
newMsgClass( {
	__names = {
		"mapId",
	},
	__types = {
		MSG_ENTITY_TYPE.INT,
	},
	__msgType = MSG_ENTITY_TYPE.mapInfo
})

newMsgClass( {
	__names = {
		"json",
		"uid",
	},
	__types = {
		MSG_ENTITY_TYPE.STRING,
		MSG_ENTITY_TYPE.STRING,
	},
	__msgType = MSG_ENTITY_TYPE.jsonData
})

newMsgClass( {
	__names = {
		"uid",--
		"room_id",
	},
	__types = {
		MSG_ENTITY_TYPE.STRING,
		MSG_ENTITY_TYPE.STRING,
	},
	__msgType = MSG_ENTITY_TYPE.reconnectInfo
})
