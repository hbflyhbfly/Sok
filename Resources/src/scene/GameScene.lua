require "AudioEngine"
require "src/constdef/BaseSceneDef"
local log = require "src/util/log"
local GameSceneLayer = require "src/scene/GameSceneLayer" 
local BackGroundLayer = require "src/scene/BackGroundLayer"
local GameViewLayer = require "src/scene/GameViewLayer"
local Weather = require "src/scene/Weather"
local base_util = require "src/util/BaseUtil.lua"
require "src/test/armTest"

--这里场景必须唯一不然会出问题
--这个可以视为类名
GameScene = {}
--这些变量可以视为类内成员变量
GameScene._game_scene = nil
GameScene._game_layer = nil
--背景层
GameScene._background_layer = nil
--人物场景层
GameScene._game_scene_layer = nil 
--ui层
GameScene._game_view_layer = nil

local _visible_size = CCDirector:sharedDirector():getVisibleSize()
local _origin = CCDirector:sharedDirector():getVisibleOrigin()
local _scheduler = CCDirector:sharedDirector():getScheduler()

function createGameScene(level)
    --handing touch events
    local touch_begin_point = nil
    --场景初始化
    local function init()
        CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("res/arm/ani_1001_bone0.png","res/arm/ani_1001_bone0.plist","res/arm/ani_1001_bone.ExportJson")
        CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("res/arm/ani_1001_bone1.png","res/arm/ani_1001_bone1.plist","res/arm/ani_1001_bone.ExportJson")
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("res/texture/collisions.plist")
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("res/texture/ui_zhedang.plist")
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("res/texture/object.plist")
        CCTextureCache:sharedTextureCache():addImage("res/texture/scene_2_bg_001.png")
        CCTextureCache:sharedTextureCache():addImage("res/texture/scene_2_bg_002.png")
        CCTextureCache:sharedTextureCache():addImage("res/texture/scene_2_bg_003.png")
        CCTextureCache:sharedTextureCache():addImage("res/texture/scene_2_bg_004.png")
        CCTextureCache:sharedTextureCache():addImage("res/texture/scene_2_bg_005.png")
        CCTextureCache:sharedTextureCache():addImage("res/texture/scene_2_bg_006.png")
        CCTextureCache:sharedTextureCache():addImage("res/texture/scene_2_bg_007.png")

        GameScene._game_scene = CCScene:create()
        GameScene._game_layer = CCLayer:create()

        GameScene._background_layer = BackGroundLayer:create()
        GameScene._game_scene_layer = GameSceneLayer:create(level)
        GameScene._game_view_layer = GameViewLayer:create()
    end

    init()

    function GameScene._game_layer:onTouchBegan(x, y)
		log.Debugf("GameScene onTouchBegan: %0.2f, %0.2f",x,y);
        touch_begin_point = {x = x, y = y}

        -- if runer:getRunerStatu() ~= Runer.ENUM_RUNER_STATUS.STATUS_JUMP_UP and
        --     runer:getRunerStatu() ~= Runer.ENUM_RUNER_STATUS.STATUS_JUMP_DOWN then
        --     runer:changeRunerStatu(Runer.ENUM_RUNER_STATUS.STATUS_JUMP_UP)    
        -- end

        return true
    end

    function GameScene._game_layer:onTouchMoved(x, y)
        log.Debugf("GameScene onTouchMoved: %0.2f, %0.2f", x, y)
        if touch_begin_point then
            local cx, cy = game_layer:getPosition()
        end
    end

    function GameScene._game_layer:onTouchEnded(x, y)
        log.Debugf("GameScene onTouchEnded: %0.2f, %0.2f", x, y)
        touch_begin_point = nil
    end

    --这里没有:是因为回调的时候只能用.没法传self
    function GameScene._game_layer.onTouch(event_type, x, y)
        if event_type == "began" then   
            return GameScene._game_layer:onTouchBegan(x, y)
        elseif event_type == "moved" then
            return GameScene._game_layer:onTouchMoved(x, y)
        else
            return GameScene._game_layer:onTouchEnded(x, y)
        end
    end

 

    --这里没有:是因为回调的时候只能用.没法传self
    function GameScene._game_layer.update(dt)
        --runer:updateRuner(dt)
        GameScene._game_scene_layer:update(dt)
        GameScene._game_view_layer:update(dt)
        --check()
    end

    -- function game_layer:check()
    --     local collisions = game_scene_layer:getCollisions()
    --     if collisions then
    --         for i,v in ipairs(collisions) do
    --             if v then
    --                 --print("sssss"..v.type)
    --                 local isCollision = runer:checkCollision(v)
    --                 if isCollision and v.type == 1 then
    --                     table.insert(collision_layer._a_del_collisions,v)
    --                     print("sssss"..v.type)
    --                 end
    --             end
    --         end
    --     end
    --     -- body
    -- end

    

    --game_layer不需要处理点击事件
    --game_layer:registerScriptTouchHandler(game_layer.onTouch)
    --game_layer:setTouchEnabled(true)

    --游戏场景主线程
    _scheduler:scheduleScriptFunc(GameScene._game_layer.update, 0, false)
    GameScene._game_layer:addChild(GameScene._background_layer, BaseSceneDef.LAYER_TYPE.LAYER_TYPE_BG)
    GameScene._game_layer:addChild(GameScene._game_scene_layer, BaseSceneDef.LAYER_TYPE.LAYER_TYPE_SCENE)
    GameScene._game_layer:addChild(GameScene._game_view_layer, BaseSceneDef.LAYER_TYPE.LAYER_TYPE_MENU)

    --GameScene._game_layer:addChild(cretateArmTestLayer(), BaseSceneDef.LAYER_TYPE.LAYER_TYPE_MENU)
    GameScene._game_scene:addChild(GameScene._game_layer)


    return GameScene._game_scene
end

function release()
    _scheduler:unscheduleUpdateForTarget(GameScene._game_layer)
    
    GameScene._game_scene = nil
    GameScene._game_layer = nil
    GameScene._background_layer = nil
    GameScene._game_scene_layer = nil
    GameScene._game_view_layer = nil
    GameScene = nil

    _visible_size = nil
    _origin = nil
    _scheduler = nil

    log = nil
    GameSceneLayer = nil 
    GameViewLayer = nil
    Weather = nil
    base_util = nil
end


GameScene.create = function(self,level) 
    local o = createGameScene(level) 
    return o; 
end

return GameScene