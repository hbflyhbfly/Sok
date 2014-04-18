
require "src/logic/IDataObserver"
require "src/logic/DataCenter"
UIBase = require "src/ui/UIBase"
local log = require "src/util/log"

--继承IDataObserver接口
UIPauseLayer = IDataObserver:new()
UIPauseLayer = UIBase.new(UIPauseLayer)


--TODO: make by ccb
function createPauseLayer()

	local function OnBack()
		print("function OnBack()")
	end

	local function onContinueGame()
		print("function onContinueGame()")

        CCDirector:sharedDirector():startAnimation()
        SimpleAudioEngine:sharedEngine():resumeBackgroundMusic()  
        SimpleAudioEngine:sharedEngine():pauseBackgroundMusic()

	end

	local pause_layer = CCLayer:create()
    local menupauseItem = CCMenuItemImage:create("Icon-72.png", "Icon-72.png")
    menupauseItem:setPosition(0, 0)
    menupauseItem:registerScriptTapHandler(OnBack)
    menuPause = CCMenu:createWithItem(menupauseItem)
    menuPause:setPosition(200, 300)
    pause_layer:addChild(menuPause)

    local menucontinueItem = CCMenuItemImage:create("Icon-72.png", "Icon-72.png")
    menucontinueItem:setPosition(0, 0)
    menucontinueItem:registerScriptTapHandler(onContinueGame)
    menuContinue = CCMenu:createWithItem(menucontinueItem)
    menuContinue:setPosition(300,300)
    pause_layer:addChild(menuContinue)

	return pause_layer
end

function UIPauseLayer:OnDataChange(param1, param2, param3)
	log.Info("UIPauseLayer:OnDataChange param1 ＝ " .. param1 .. "param2 = " .. param2 .. "param3 = " .. param3)
end

function UIPauseLayer:create() 
    local layer = createPauseLayer()
    DataCenter:RegisterObserver(UIPauseLayer)
    return layer
end

function UIPauseLayer:destroy()
	DataCenter:unRegisterObserver(UIPauseLayer)
end

function  UIPauseLayer:update(dt)
end

return UIPauseLayer