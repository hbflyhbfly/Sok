
require "CCBReaderLoad"
require "src/logic/IDataObserver"
require "src/logic/DataCenter"
local notificationCenter = CCNotificationCenter:sharedNotificationCenter()
local log = require "src/util/log"
--¼Ì³ÐIDataObserver½Ó¿Ú 
local ViewGameScene = IDataObserver:new()

OpertaionLayer = OpertaionLayer or {}
ccb["OpertaionLayer"] = OpertaionLayer

function ViewGameScene.onJumpClick()
	notificationCenter:postNotification("JUMP",CCSprite:create())
	log.Info("this onJumpClick method")
end

function ViewGameScene.onPauseClick()
	log.Info("this onJumpClick2 method")
end

function ViewGameScene.onSquatClick()
	notificationCenter:postNotification("SQUAT",CCSprite:create())
	log.Info("this onJumpClick3 method")
end

OpertaionLayer["btn_jump"] = ViewGameScene.onJumpClick
OpertaionLayer["btn_pause"] = ViewGameScene.onPauseClick
OpertaionLayer["btn_squat"] = ViewGameScene.onSquatClick

local function HelloCCBTestMainLayer()
	log.Info("this is motherfucker")
	local  proxy = CCBProxy:create()
	local  node  = CCBuilderReaderLoad("res/ccbi/opertaion.ccbi",proxy,OpertaionLayer)
	local  layer = tolua.cast(node,"CCLayer")
	return layer
end

-- override
-- param1 Í¨ÖªÀàÐÍ
-- param2 ±£Áô×Ö¶Î
-- param3 Í¨ÖªÊý¾Ý
function ViewGameScene:OnDataChange(param1, param2, param3)
	log.Info("ViewGameScene:OnDataChange param1 £½ " .. param1 .. "param2 = " .. param2 .. "param3 = " .. param3)
end

ViewGameScene.create = function(self) 
    ViewGameScene._layer = HelloCCBTestMainLayer()
    DataCenter:RegisterObserver(ViewGameScene)
    return ViewGameScene._layer; 
end

return ViewGameScene