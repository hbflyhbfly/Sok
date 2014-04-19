require "src/constdef/CollisionDef"
require "src/constdef/BaseSceneDef"
require "src/constdef/RunerDef"
require "src/logic/DataCenter"
require "src/constdef/DataConstDef"
local log = require "src/util/log"
local base_util = require "src/util/BaseUtil.lua"
local CollisionMap = require "src/logic/CollisionMap"
local Collision = require "src/sprite/Collision"
local Runer = require "src/sprite/Runer"
local GameMainLogic = require "src/logic/GameMainLogic"
local RunerLogic = require "src/logic/RunerLogic"
local CurrentUserInfo = require "src/logic/CurrentUserInfo"
local GameOverScene = require "src/scene/GameOverScene"
--这个可以视为类名
local GameSceneLayer = {}
GameSceneLayer.isOver = false
--这些变量可以视为类内成员变量
local _scheduler = CCDirector:sharedDirector():getScheduler()
local _visible_size = CCDirector:sharedDirector():getWinSize()
local notificationCenter = CCNotificationCenter:sharedNotificationCenter()
local currentUserInfo = CurrentUserInfo:sharedUserInfo()
local function createGameSceneLayer(level)
	local layer = CCLayer:create()
    layer._collision_map = {}
    layer.runerData = {}
    layer._runer = {}
    currentUserInfo:addUserInfo()
    function layer:initWithLevel(level)
        --根据关卡生成物体地图
        self._collision_map = CollisionMap:createWithLevel(level)
        for i,v in pairs(self._collision_map.tiles) do
            if v.locX < _visible_size.width*2 then
                local collision = Collision:create(v)
                collision:setAnchorPoint(ccp(0,0))
                self:addChild(collision,1,v.id)
                v.visible = true
            end
        end
        
        --生成角色
        self.runerData = RunerLogic:create(currentUserInfo.userInfo.currentRole)
        self._runer = Runer:create(self.runerData)
        self:addChild(self._runer,
            RunerDef.RUNER_Z_ORDER.RUNER_Z_ORDER_1,
            RunerDef.RUNER_TAG.RUNER_TAG_1)
    end
    --重置场景
    function layer:reset()
        self:removeAllChildrenWithCleanup(true)
        self._runer = {}
        self:initWithLevel("level3")
    end
    --场景内容更新
    function layer:update(dt)
    	self:updateCollisions(dt)
        self:updateRuner(dt)
        self:checkCollision(dt)
        if GameSceneLayer.isOver then
            _scheduler:unScheduleScriptFunc(GameScene._game_layer.update, 0, false)
            CCDirector:sharedDirector():replaceScene(GameOverScene:create())
        end
    end
    --移动物体，看做人物跑动
    function layer:moveCollision(collision)
        collision.locX = collision.locX - self._collision_map.velocity
        if collision.visible then
            self:getChildByTag(collision.id):update(collision)
            if collision.locX <= -_visible_size.width/2 then
                collision.status = CollisionDef.COLLISION_STATUS.COLLISION_DEAD
                for i,v in pairs(self._collision_map.tiles) do
                    --加载地图
                    if v.locX >= _visible_size.width*1.5 and
                    v.locX < _visible_size.width*2 and not v.visible then
                        local collision = Collision:create(v)
                        collision:setAnchorPoint(ccp(0,0))
                        self:addChild(collision,1,v.id)
                        v.visible = true
                    end
                end
            end
        end
        
    end
    --物体更新
    function layer:updateCollisions(dt)
        if #self._collision_map.tiles <= 0 then
            GameSceneLayer.isOver = true
            return
        end

        for i,v in pairs(self._collision_map.tiles) do
            local collision = v
            self:moveCollision(collision)
            --删除障碍物
            if collision.status == CollisionDef.COLLISION_STATUS.COLLISION_DEAD then
                self:getChildByTag(collision.id):update(collision)
                self:removeChildByTag(collision.id,true)
                table.remove(self._collision_map.tiles,i)
            end
        end
    end
    --更新玩家
    function layer:updateRuner(dt)
        self.runerData:update()
        self._runer:update(self.runerData)
    end
    --碰撞检测
    function layer:checkCollision(dt)
        self.runerData._ground = 0
        local runerSprite = self._runer
        local collisions = self._collision_map.tiles
        local runerRect = runerSprite:boundingBox()
        local runerSize = runerRect.size

        local foot = CCRectMake(runerRect:getMidX()-runerSize.width/4,runerRect:getMinY(),
        runerSize.width/2,5)
        local head = CCRectMake(runerRect:getMidX()-runerSize.width/4,runerRect:getMaxY()-20,
        runerSize.width/2,20)
        local left = CCRectMake(runerRect:getMinX(),runerRect:getMidY()-runerSize.height/4,
        5,runerSize.height/2)
        local right = CCRectMake(runerRect:getMaxX()-5,runerRect:getMidY()-runerSize.height/4,
        5,runerSize.height/2)
        for k,v in pairs(collisions) do
            if not v.visible then
                return
            end
            local isCollision = RunerDef.RUNER_COLLISION_AREA.AREA_NONE
            local collisionRect = self:getChildByTag(v.id):boundingBox()
            local ground = CCRectMake(collisionRect:getMinX(),collisionRect:getMaxY()-50,collisionRect:getMaxX()-collisionRect:getMinX(),50)
            if ground:intersectsRect(foot) then
                isCollision = RunerDef.RUNER_COLLISION_AREA.AREA_FOOT
            elseif collisionRect:intersectsRect(head) then
                isCollision = RunerDef.RUNER_COLLISION_AREA.AREA_HEAD
            elseif collisionRect:intersectsRect(left) then
                isCollision = RunerDef.RUNER_COLLISION_AREA.AREA_LEFT
            elseif collisionRect:intersectsRect(right) then
                isCollision = RunerDef.RUNER_COLLISION_AREA.AREA_RIGHT
            end
            --地面
            if CollisionDef.COLLISION_TYPE[v.type] == CollisionDef.COLLISION_TYPE.COLLISION_GROUND and 
                isCollision == RunerDef.RUNER_COLLISION_AREA.AREA_FOOT and 
                (RunerDef.RUNER_STATUS.STATUS_DROP_DOWN == self.runerData:getStatus() or
                  RunerDef.RUNER_STATUS.STATUS_NORMAL == self.runerData:getStatus()) then
                self.runerData._ground = runerRect:getMinY()
                self.runerData:changeStatus(RunerDef.RUNER_STATUS.STATUS_NORMAL)
                return
            end
            --可穿透可使用
            if CollisionDef.COLLISION_TYPE[v.type] == CollisionDef.COLLISION_TYPE.COLLISION_GOLD and 
                isCollision ~= RunerDef.RUNER_COLLISION_AREA.AREA_NONE then
                v.status = CollisionDef.COLLISION_STATUS.COLLISION_DEAD
                return
            end
            --陷阱
            if CollisionDef.COLLISION_TYPE[v.type] == CollisionDef.COLLISION_TYPE.COLLISION_SNARE and 
                isCollision ~= RunerDef.RUNER_COLLISION_AREA.AREA_NONE then
                --v.status = CollisionDef.COLLISION_STATUS.COLLISION_DEAD
                self.runerData._ground = runerRect:getMinY()
                self.runerData:changeStatus(RunerDef.RUNER_STATUS.STATUS_NORMAL)
                print("中陷阱")
                return
            end
            --不可穿透
            if CollisionDef.COLLISION_TYPE[v.type] == CollisionDef.COLLISION_TYPE.COLLISION_NOWAY and
                isCollision == RunerDef.RUNER_COLLISION_AREA.AREA_RIGHT then
                self.runerData._loc._x = collisionRect:getMinX() - runerSize.width
                self._collision_map.velocity = 0
                return
            else
                self._collision_map.velocity = CollisionDef.ACCELERATION_VALUE.ACCELERATION_3
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
        elseif "ATTACK" == obj then
            --layer.runerData:changeStatus(RunerDef.RUNER_STATUS.STATUS_JUMP_UP)
            layer.runerData._nextAction = RunerDef.ACTION_TYPE.ATTACK 
        end
    end

    layer:initWithLevel(level)
    notificationCenter:registerScriptObserver(layer, responseForUI, "RESET")
    notificationCenter:registerScriptObserver(layer._runer, responseForUI, "JUMP")
    notificationCenter:registerScriptObserver(layer._runer, responseForUI, "ATTACK")

    layer:registerScriptTouchHandler(layer.onTouch,false, 0 - BaseSceneDef.LAYER_TYPE.LAYER_TYPE_SCENE,true)
    layer:setTouchEnabled(true)

    return layer
end

GameSceneLayer.create = function(self,level) 
    local o = createGameSceneLayer(level) 
    return o; 
end

return GameSceneLayer