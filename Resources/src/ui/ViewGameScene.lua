require "CCBReaderLoad"
require "src/logic/IDataObserver"
require "src/logic/DataCenter"
UIBase = require "src/ui/UIBase"
local notificationCenter = CCNotificationCenter:sharedNotificationCenter()
local log = require "src/util/log"
--继承IDataObserver接口
ViewGameScene = IDataObserver:new()
ViewGameScene = UIBase.new(ViewGameScene)

OpertaionLayer = OpertaionLayer or {}
ccb["OpertaionLayer"] = OpertaionLayer

function ViewGameScene.onJumpClick()
	notificationCenter:postNotification("JUMP",CCArmature:create())
	--log.Info("this onJumpClick method")
end

function ViewGameScene.onPauseClick()
	--log.Info("this onJumpClick2 method")
	notificationCenter:postNotification("RESET",CCLayer:create())
end

function ViewGameScene.onSquatClick()
	notificationCenter:postNotification("SQUAT",CCArmature:create())
	--log.Info("this onJumpClick3 method")
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
-- param1 通知类型
-- param2 保留字段
-- param3 通知数据
function ViewGameScene:OnDataChange(param1, param2, param3)
	log.Info("ViewGameScene:OnDataChange param1 ＝ " .. param1 .. "param2 = " .. param2 .. "param3 = " .. param3)
end

-- ViewGameScene:create = function(self) 
--     ViewGameScene._layer = HelloCCBTestMainLayer()
--     log.Info("this is ViewGameScene.create --- - - - - - -88888")
--     DataCenter:RegisterObserver(ViewGameScene)
--     return ViewGameScene._layer; 
-- end

-- ViewGameScene:destroy = function(self)
-- 	DataCenter:unRegisterObserver(ViewGameScene)
-- end

-- ViewGameScene:update = function(dt)
-- 	log.Info("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ ViewGameScene.update 888888")
-- end

function ViewGameScene:create() 
    self._layer = HelloCCBTestMainLayer()
    DataCenter:RegisterObserver(ViewGameScene)
    return self

end

function ViewGameScene:destroy()
	DataCenter:unRegisterObserver(ViewGameScene)
end

function  ViewGameScene:update(dt)
end
