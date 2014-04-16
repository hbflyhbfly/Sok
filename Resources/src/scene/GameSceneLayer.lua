require "src/constdef/CollisionDef"
require "src/constdef/BaseSceneDef"
require "src/constdef/RunerDef"
local log = require "src/util/log"
local base_util = require "src/util/BaseUtil.lua"
local CollisionMap = require "src/logic/CollisionMap"
local Collision = require "src/sprite/Collision"
local Runer = require "src/sprite/Runer"
local GameMainLogic = require "src/logic/GameMainLogic"
local RunerLogic = require "src/logic/RunerLogic"
require "src/logic/DataCenter"
require "src/constdef/DataConstDef"

--这个可以视为类名
local GameSceneLayer = {}

--这些变量可以视为类内成员变量
local _visible_size = CCDirector:sharedDirector():getWinSize()
local _scheduler = CCDirector:sharedDirector():getScheduler()
local textureCache = CCTextureCache:sharedTextureCache()
local notificationCenter = CCNotificationCenter:sharedNotificationCenter()

local function createGameSceneLayer()
	local layer = CCLayer:create()
    local _collision_map = {}
    --运行的障碍物
	layer._a_collisions = {}
    layer.runerData = {}
    layer._runer = {}
    _batchNode = CCSpriteBatchNode:createWithTexture(textureCache:textureForKey("res/texture/collisions.png"))
    _batchNode:setPosition(ccp(0,0))
    layer:addChild(_batchNode)
    function _batchNode:move()
        self:setPositionX(self:getPositionX() - CollisionDef.ACCELERATION_VALUE.ACCELERATION_3)
    end
    --layer._batchNode:setPosition(ccp(0,0))
    function layer:init()
        --根据级别生成物体地图
        _collision_map = CollisionMap:createWithLevel("level2")
        for i,v in pairs(_collision_map.tiles) do
            if 0 ~= v.id then
                --添加物体
                local _collision = Collision:create(v.id,v.locX,v.locY)
                if _collision then
                    _batchNode:addChild(_collision._sprite)
                    table.insert(self._a_collisions,_collision)
                end
                
            end
        end

        --生成角色
        self.runerData = RunerLogic:create("runer1")
        self._runer = Runer:create(self.runerData)
        self:addChild(self._runer,
            RunerDef.RUNER_Z_ORDER.RUNER_Z_ORDER_1,
            RunerDef.RUNER_TAG.RUNER_TAG_1)
    end

    function layer:reset()
        --self:removeAllChildrenWithCleanup(true)
        self._batchNode:removeAllChildrenWithCleanup(true)
        self._a_collisions = {}
        self._runer = {}
        self:init()
    end
    --场景内容更新
    function layer:update(dt)
    	self:updateCollisions(dt)
        self:updateRuner(dt)
        self:checkCollision(dt)
    end
    --物体更新
    function layer:updateCollisions(dt)
        if #self._a_collisions <= 0 then
            return
        end
        _batchNode:move()
        for i,v in pairs(self._a_collisions) do
            if v then
                local collision = v
                
                if _batchNode:getPositionX()+collision._sprite:getPositionX() <= -collision._sprite:getContentSize().width then
                    print(collision._sprite:getPositionX())
                    collision._activity = false
                end
                --删除障碍物
                if not collision._activity then
                    _batchNode:removeChild(collision._sprite,true)
                    table.remove(self._a_collisions,i)
                end
            end
        end
        
    end

    function layer:updateRuner(dt)
        self.runerData:run()
        self._runer:update(self.runerData)
    end

    function layer:checkCollision(dt)

        local runerSprite = self._runer
        local collisions = self._a_collisions
        local runerRect = runerSprite:boundingBox()
        local runerSize = runerRect.size

        local foot = CCRectMake(runerRect:getMidX()-runerSize.width/4,runerRect:getMinY(),
        runerSize.width/2,5)
        local head = CCRectMake(runerRect:getMidX()-runerSize.width/4,runerRect:getMaxY()-20,
        runerSize.width/2,20)
        --local head = runerSprite:getBone("head"):getDisplayRenderNode():boundingBox()
        local left = CCRectMake(runerRect:getMinX(),runerRect:getMidY()-runerSize.height/4,
        5,runerSize.height/2)
        local right = CCRectMake(runerRect:getMaxX()-5,runerRect:getMidY()-runerSize.height/4,
        5,runerSize.height/2)
        for k,v in pairs(collisions) do
            --print(collisionRect:getMaxY())
            local isCollision = RunerDef.RUNER_COLLISION_AREA.AREA_NONE
            local collisionRect = v._sprite:boundingBox()
            local ground = CCRectMake(collisionRect:getMinX(),collisionRect:getMaxY()-90,collisionRect:getMaxX()-collisionRect:getMinX(),50)
            if ground:intersectsRect(foot) then
                isCollision = RunerDef.RUNER_COLLISION_AREA.AREA_FOOT
            elseif collisionRect:intersectsRect(head) then
                isCollision = RunerDef.RUNER_COLLISION_AREA.AREA_HEAD
            elseif collisionRect:intersectsRect(left) then
                isCollision = RunerDef.RUNER_COLLISION_AREA.AREA_LEFT
            elseif collisionRect:intersectsRect(right) then
                isCollision = RunerDef.RUNER_COLLISION_AREA.AREA_RIGHT
            end
            self.runerData._ground = 0
            --不可穿透
            if v._type == CollisionDef.COLLISION_TYPE.COLLISION_GROUND and 
                isCollision == RunerDef.RUNER_COLLISION_AREA.AREA_FOOT and 
                (RunerDef.RUNER_STATUS.STATUS_DROP_DOWN == self.runerData:getStatus() or
                  RunerDef.RUNER_STATUS.STATUS_NORMAL == self.runerData:getStatus()) then
                self.runerData._ground = runerRect:getMinY()-50
                self.runerData:changeStatus(RunerDef.RUNER_STATUS.STATUS_NORMAL)
                return
            end
            --可穿透可使用
            if v._type == CollisionDef.COLLISION_TYPE.COLLISION_GOLD and 
                isCollision ~= RunerDef.RUNER_COLLISION_AREA.AREA_NONE then
                v._activity = false
                return
            end

        end
    end
    function layer:onTouchBegan(x, y)
        log.Debugf("GameSceneLayer onTouchBegan: %0.2f, %0.2f",x,y);
        touch_begin_point = {x = x, y = y}
        DataCenter:notifyObservers(DataConstDef.EVENT_MSG_TYPE.EM_SECOND_MSG_TYPE, 100, 111)
        -- CCTOUCHBEGAN event must return true
        return true
    end

    function layer:onTouchMoved(x, y)
        log.Debugf("GameSceneLayer onTouchMoved: %0.2f, %0.2f", x, y)
    end

    function layer:onTouchEnded(x, y)
        log.Debugf("GameSceneLayer onTouchEnded: %0.2f, %0.2f",x,y);
        touch_begin_point = nil
    end

    --这里没有:是因为回调的时候只能用.没法传self
    function layer.onTouch(event_type, x, y)
        if event_type == "began" then   
            return layer:onTouchBegan(x, y)
        elseif event_type == "moved" then
            return layer:onTouchMoved(x, y)
        else
            return layer:onTouchEnded(x, y)
        end 
    end

    function responseForUI(obj)
        if "RESET" == obj then
            layer:reset()
        elseif "JUMP" == obj then
            layer.runerData:changeStatus(RunerDef.RUNER_STATUS.STATUS_JUMP_UP)
        elseif "SQUAT" == obj then
        end
    end

    layer:init()
    
    notificationCenter:registerScriptObserver(layer, responseForUI, "RESET")
    notificationCenter:registerScriptObserver(layer._runer, responseForUI, "JUMP")
    notificationCenter:registerScriptObserver(layer._runer, responseForUI, "SQUAT")

    layer:registerScriptTouchHandler(layer.onTouch,false, 0 - BaseSceneDef.LAYER_TYPE.LAYER_TYPE_SCENE,true)
    layer:setTouchEnabled(true)

    return layer
end

GameSceneLayer.create = function(self) 
    local o = createGameSceneLayer() 
    return o; 
end

return GameSceneLayer