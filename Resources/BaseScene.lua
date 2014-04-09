require "AudioEngine" 
local Runer = require "Runer"
local Collision = require "Collision" 
local Background = require "Background"
local Weather = require "Weather"
local log = require "log"

function createBaseLayer()
    local visible_size = CCDirector:sharedDirector():getVisibleSize()
    local origin = CCDirector:sharedDirector():getVisibleOrigin()
    local scheduler = CCDirector:sharedDirector():getScheduler()

    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("texture/Res.plist")
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("texture/collisions.plist")
    log.Debugf("plist")
    CCTextureCache:sharedTextureCache():addImage("texture/move_mg_1.png")
    CCTextureCache:sharedTextureCache():addImage("texture/move_mg_2.png")
    CCTextureCache:sharedTextureCache():addImage("texture/move_mg_3.png")
    CCTextureCache:sharedTextureCache():addImage("texture/move_mg_4.png")
    --CCTextureCache:sharedTextureCache():addImage("texture/worldmap_body_0.png")
    --CCTextureCache:sharedTextureCache():addImage("texture/worldmap_body_1.png")
    --CCTextureCache:sharedTextureCache():addImage("texture/worldmap_body_2.png")

    local base_layer = CCLayer:create()

    local runer = {}
    local collision = {}
    --local bg = CCSprite:create("texture/game_bg.png")
    --bg:setPosition(origin.x + visible_size.width / 2, origin.y + visible_size.height / 2)
    --base_layer:addChild(bg)

    -- handing touch events
    local touch_begin_point = nil

    local function onTouchBegan(x, y)
		log.Debugf("BaseScene onTouchBegan: %0.2f, %0.2f",x,y);
        touch_begin_point = {x = x, y = y}

        if runer:getRunerStatu() ~= Runer.RUNER_STATU.RUNER_JUMP_UP and
            runer:getRunerStatu() ~= Runer.RUNER_STATU.RUNER_JUMP_DOWN then
            runer:changeRunerStatu(Runer.RUNER_STATU.RUNER_JUMP_UP)    
        end
        -- CCTOUCHBEGAN event must return true
        return true
    end

    local function onTouchMoved(x, y)
        log.Debugf("BaseScene onTouchMoved: %0.2f, %0.2f", x, y)
        if touch_begin_point then
            local cx, cy = base_layer:getPosition()
        end
    end

    local function onTouchEnded(x, y)
        log.Debugf("BaseScene onTouchEnded: %0.2f, %0.2f", x, y)
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
        --check()
    end

    function check()
        local collisions = collision:getCollisions()
        if collisions then
            for i=0,collisions:count()-1 do
                runer:checkCollision(collisions:objectAtIndex(i))
            end
        end
        -- body
    end
    base_layer:registerScriptTouchHandler(onTouch)
    base_layer:setTouchEnabled(true)
    scheduler:scheduleScriptFunc(update, 0, false)
    
    base_layer:addChild(Background:createBackgroundLayer())
    runer = Runer:createRunerLayer()
    base_layer:addChild(runer)
    collision = Collision:createCollisionLayer()
    base_layer:addChild(collision)
    --base_layer:addChild(Weather:createWeatherLayer())
    return base_layer
end