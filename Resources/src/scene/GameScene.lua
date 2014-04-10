require "AudioEngine"
local Runer = require "src/scene/Runer"
local Collision = require "src/scene/Collision" 
local Background = require "src/scene/Background"
local Weather = require "src/scene/Weather"
local log = require "src/util/log"
require "src/ui/ViewGameScene"

function createGameScene()
    --定义
    local visible_size = CCDirector:sharedDirector():getVisibleSize()
    local origin = CCDirector:sharedDirector():getVisibleOrigin()
    local scheduler = CCDirector:sharedDirector():getScheduler()
    local game_scene = CCScene:create()
    local game_layer = CCLayer:create()

    local runer = nil
    --背景层
    local background_layer = nil
    --人物场景层
    local collision_layer = nil 
    --ui层
    local view_layer = nil 
    -- handing touch events
    local touch_begin_point = nil


    --场景初始化
    local function init()
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("res/texture/Res.plist")
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("res/texture/collisions.plist")
        CCTextureCache:sharedTextureCache():addImage("res/texture/move_mg_1.png")
        CCTextureCache:sharedTextureCache():addImage("res/texture/move_mg_2.png")
        CCTextureCache:sharedTextureCache():addImage("res/texture/move_mg_3.png")
        CCTextureCache:sharedTextureCache():addImage("res/texture/move_mg_4.png")

        background_layer = Background:createBackgroundLayer()
        runer = Runer:createRunerLayer()
        collision_layer = Collision:createCollisionLayer()
        view_layer = runCocosBuilder()
    end

    local function onTouchBegan(x, y)
		log.Debugf("BaseScene onTouchBegan: %0.2f, %0.2f",x,y);
        touch_begin_point = {x = x, y = y}

        if runer:getRunerStatu() ~= Runer.ENUM_RUNER_STATUS.STATUS_JUMP_UP and
            runer:getRunerStatu() ~= Runer.ENUM_RUNER_STATUS.STATUS_JUMP_DOWN then
            runer:changeRunerStatu(Runer.ENUM_RUNER_STATUS.STATUS_JUMP_UP)    
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
        local collisions = collision_layer:getCollisions()
        if collisions then
            for i=0,collisions:count()-1 do
                runer:checkCollision(collisions:objectAtIndex(i))
            end
        end
        -- body
    end

    init()
    game_layer:registerScriptTouchHandler(onTouch)
    game_layer:setTouchEnabled(true)
    --游戏场景主线程
    scheduler:scheduleScriptFunc(update, 0, false)
    
    game_layer:addChild(background_layer)
    game_layer:addChild(runer)
    game_layer:addChild(collision_layer)
    game_layer:addChild(view_layer)

    game_scene:addChild(game_layer)
    return game_scene
end