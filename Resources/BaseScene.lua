require "AudioEngine" 
require "sklog"
local Runer = require "Runer"
local Collision = require "Collision" 
local Background = require "Background"
local Weather = require "Weather"

function createBaseLayer()
	local TAG = "BaseScene"
    local visible_size = CCDirector:sharedDirector():getVisibleSize()
    local origin = CCDirector:sharedDirector():getVisibleOrigin()
    local scheduler = CCDirector:sharedDirector():getScheduler()

    local cache = CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("Res.plist")
    CCTextureCache:sharedTextureCache():addImage("move_mg_1.png")
    CCTextureCache:sharedTextureCache():addImage("move_mg_2.png")
    CCTextureCache:sharedTextureCache():addImage("move_mg_3.png")
    CCTextureCache:sharedTextureCache():addImage("move_mg_4.png")
    CCTextureCache:sharedTextureCache():addImage("worldmap_body_0.png")
    CCTextureCache:sharedTextureCache():addImage("worldmap_body_1.png")
    CCTextureCache:sharedTextureCache():addImage("worldmap_body_2.png")

    local base_layer = CCLayer:create()

    local runer = {}
    --local bg = CCSprite:create("texture/game_bg.png")
    --bg:setPosition(origin.x + visible_size.width / 2, origin.y + visible_size.height / 2)
    --base_layer:addChild(bg)

    -- handing touch events
    local touch_begin_point = nil

    local function onTouchBegan(x, y)
		SKLog(SKLOG_INFO, TAG, "onTouchBegan: %0.2f, %0.2f",x,y);
        touch_begin_point = {x = x, y = y}

        if runer:getRunerStatu() ~= Runer.RUNER_STATU.RUNER_JUMP_UP and
            runer:getRunerStatu() ~= Runer.RUNER_STATU.RUNER_JUMP_DOWN then
            runer:changeRunerStatu(Runer.RUNER_STATU.RUNER_JUMP_UP)    
        end
        -- CCTOUCHBEGAN event must return true
        return true
    end

    local function onTouchMoved(x, y)
        SKLog(SKLOG_INFO, TAG, "onTouchMoved: %0.2f, %0.2f", x, y)
        if touch_begin_point then
            local cx, cy = base_layer:getPosition()
        end
    end

    local function onTouchEnded(x, y)
        SKLog(SKLOG_INFO, TAG, "onTouchEnded: %0.2f, %0.2f", x, y)
        touch_begin_point = nil
    end

    local function onTouch(eventType, x, y)
        if eventType == "began" then   
            return onTouchBegan(x, y)
        elseif eventType == "moved" then
            return onTouchMoved(x, y)
        else
            return onTouchEnded(x, y)
        end
    end

    function update(dt)
        runer:updateRuner(dt)
    end

    base_layer:registerScriptTouchHandler(onTouch)
    base_layer:setTouchEnabled(true)
    scheduler:scheduleScriptFunc(update, 0, false)
    
    base_layer:addChild(Background:createBackgroundLayer())
    runer = Runer:createRunerLayer()
    base_layer:addChild(runer)
    base_layer:addChild(Collision:createCollisionLayer())
    base_layer:addChild(Weather:createWeatherLayer())
    return base_layer
end