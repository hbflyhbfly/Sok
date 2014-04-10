require "AudioEngine"
local Runer = require "src/scene/Runer"
local Collision = require "src/scene/Collision" 
local Background = require "src/scene/Background"
local Weather = require "src/scene/Weather"
local log = require "src/util/log"
require "src/UI/ViewGameScene"

function createBaseLayer()
    local visible_size = CCDirector:sharedDirector():getVisibleSize()
    local origin = CCDirector:sharedDirector():getVisibleOrigin()
    local scheduler = CCDirector:sharedDirector():getScheduler()

    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("res/texture/Res.plist")
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("res/texture/collisions.plist")
    CCTextureCache:sharedTextureCache():addImage("res/texture/move_1.png")
    CCTextureCache:sharedTextureCache():addImage("res/texture/move_2.png")
    --CCTextureCache:sharedTextureCache():addImage("res/texture/move_mg_3.png")
    --CCTextureCache:sharedTextureCache():addImage("res/texture/move_mg_4.png")

    local base_layer = CCLayer:create()

    local runer = {}
    local collision = {}
    --local bg = CCSprite:create("res/texture/game_bg.png")
    --bg:setPosition(origin.x + visible_size.width / 2, origin.y + visible_size.height / 2)
    --base_layer:addChild(bg)

    -- handing touch events
    local touch_begin_point = nil

    local function onTouchBegan(x, y)
		--log.Debugf("BaseScene onTouchBegan: %0.2f, %0.2f",x,y);
        touch_begin_point = {x = x, y = y}
        if runer:getRunerStatu() ~= Runer.ENUM_RUNER_STATUS.STATUS_JUMP_UP and
            runer:getRunerStatu() ~= Runer.ENUM_RUNER_STATUS.STATUS_JUMP_DOWN then
            runer:changeRunerStatu(Runer.ENUM_RUNER_STATUS.STATUS_JUMP_UP)    
        end
        return true
    end

    local function onTouchMoved(x, y)
        --log.Debugf("BaseScene onTouchMoved: %0.2f, %0.2f", x, y)
        if touch_begin_point then
            local cx, cy = base_layer:getPosition()
        end
    end

    local function onTouchEnded(x, y)
        --log.Debugf("BaseScene onTouchEnded: %0.2f, %0.2f", x, y)
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
        check()
    end

    function check()
        local collisions = collision:getCollisions()
        if collisions then
            for i,v in ipairs(collisions) do
                if v then
                    runer:checkCollision(v)
                end
            end
        end
    end
    base_layer:registerScriptTouchHandler(onTouch)
    base_layer:setTouchEnabled(true)
    --游戏场景主线程
    scheduler:scheduleScriptFunc(update, 0, false)

    base_layer:addChild(Background:createBackgroundLayer())
    runer = Runer:createRunerLayer()
    base_layer:addChild(runer)
    collision = Collision:createCollisionLayer()
    base_layer:addChild(collision)
    --base_layer:addChild(Weather:createWeatherLayer())
    base_layer:addChild(runCocosBuilder())
    return base_layer
end