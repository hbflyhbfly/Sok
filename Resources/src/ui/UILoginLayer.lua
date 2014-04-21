
require "src/logic/IDataObserver"
require "src/logic/DataCenter"
UIBase = require "src/ui/UIBase"
local log = require "src/util/log"

local platform = CCApplication:sharedApplication():getTargetPlatform()
if GlobalDef.TARGET_PLATFORM.kTargetAndroid == platform or 
    GlobalDef.TARGET_PLATFORM.kTargetIphone == platform or
    GlobalDef.TARGET_PLATFORM.kTargetIpad == platform then
    luaj = require "src/util/luaj" 
end

--继承IDataObserver接口
UILoginLayer = IDataObserver:new()
UILoginLayer = UIBase.new(UILoginLayer)

--TODO: make by ccb
function createLoginLayer()

	local function sinaLogin()
        
        local args = nil
        local class_name = nil
        local function_name = nil
         if GlobalDef.TARGET_PLATFORM.kTargetIphone == platform or
            GlobalDef.TARGET_PLATFORM.kTargetIpad == platform then
            args = 
            {
                name = 20,
            }
            class_name = "WeiboIOS"
            function_name = "registerAppInfo"        
        end
        local ok, ret = luaj.callStaticMethod(class_name, function_name, args)
        if not ok then
            print(string.format("failure, error code: %s", tostring(ret)))
        end
    end

	local function oneKeyLogin()
        --        
	end

	local pause_layer = CCLayer:create()
    local menupauseItem = CCMenuItemImage:create("Icon-72.png", "Icon-72.png")
    menupauseItem:setPosition(0, 0)
    menupauseItem:registerScriptTapHandler(sinaLogin)
    menuPause = CCMenu:createWithItem(menupauseItem)
    menuPause:setPosition(200, 300)
    pause_layer:addChild(menuPause)

    local menucontinueItem = CCMenuItemImage:create("Icon-72.png", "Icon-72.png")
    menucontinueItem:setPosition(0, 0)
    menucontinueItem:registerScriptTapHandler(oneKeyLogin)
    menuContinue = CCMenu:createWithItem(menucontinueItem)
    menuContinue:setPosition(300,300)
    pause_layer:addChild(menuContinue)

	return pause_layer
end

function UILoginLayer:OnDataChange(param1, param2, param3)
	log.Info("UILoginLayer:OnDataChange param1 ＝ " .. param1 .. "param2 = " .. param2 .. "param3 = " .. param3)
end

function UILoginLayer:create() 
    local layer = createLoginLayer()
    DataCenter:RegisterObserver(UILoginLayer)
    return layer
end

function UILoginLayer:destroy()
	DataCenter:unRegisterObserver(UILoginLayer)
end

function  UILoginLayer:update(dt)
end

return UILoginLayer