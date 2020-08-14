require("core2_0.yk")

require("core2_0.class")
require("core2_0.Dispatcher")
require("core2_0.MsgEntityBase")
require("core2_0.MsgEntity.MsgEntityPublic")

require("core2_0.XProxy")
require("core2_0.EventType")

local RequestMessage = require("core2_0.Interface.RequestMessage")
local BroadcastMessage = require("core2_0.Interface.BroadcastMessage")
return {
	RequestMessage = RequestMessage,
	BroadcastMessage = BroadcastMessage,
	MsgEntity = MsgEntity,
	MSG_ENTITY_TYPE = MSG_ENTITY_TYPE
}