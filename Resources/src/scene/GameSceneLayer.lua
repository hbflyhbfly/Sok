require "src/constdef/CollisionDef"
require "src/constdef/RunerDef"
local log = require "src/util/log"
local base_util = require "src/util/BaseUtil.lua"
local CollisionMap = require "src/logic/CollisionMap"
local Collision = require "src/sprite/Collision"
local Runer = require "src/sprite/Runer"
require "src/logic/DataCenter"
require "src/constdef/DataConstDef"

--这个可以视为类名
local GameSceneLayer = {}

--这些变量可以视为类内成员变量
local _visible_size = CCDirector:sharedDirector():getWinSize()
local _scheduler = CCDirector:sharedDirector():getScheduler()

local function createGameSceneLayer()
	local layer = CCLayer:create()
    --运行的障碍物
	layer._a_collisions = {}
    layer._runer = {}
    function layer:init()
        --根据级别生成物体地图
        local collision_map = CollisionMap:createWithLevel("level1")
        --for i,v in ipairs(collision_map.tiles) do
        --pairs不会加载nil的value，ipairs全部遍历效率没有pairs高
        for i,v in pairs(collision_map.tiles) do
            if 0 ~= v.id then
                --添加物体
                local _collision = Collision:create(v.id,v.locX,v.locY)
                if not _collision then
                    break
                end
                self:addChild(_collision._sprite,
                    CollisionDef.COLLISION_Z_ORDER.COLLISION_Z_ORDER_1,
                    CollisionDef.COLLISION_TAG.COLLISION_TAG_1)
                table.insert(self._a_collisions,_collision)
            end
        end
        --生成角色
        self._runer = Runer:create("runer1")
        self:addChild(self._runer._sprite,
            RunerDef.RUNER_Z_ORDER.RUNER_Z_ORDER_1,
            RunerDef.RUNER_TAG.RUNER_TAG_1)
    end

    function layer:getCollisions()
        return self._a_collisions
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
        for i,v in pairs(self._a_collisions) do
            if nil ~= v then
                local collision = v
                collision:move()
            end
        end
        --删除障碍物
        function deleteCollision()
            for i,v in pairs(self._a_collisions) do
                if v then
                    if not v._activity then
                        self:removeChild(v._sprite,true)
                        table.remove(self._a_collisions,i)
                    end
                end
            end
        end
        deleteCollision()
    end

    function layer:updateRuner(dt)
        self._runer:run()
    end

    function layer:checkCollision(collisions)
        local isCollision = false
        local runer = self._runer
        local collisions = self._a_collisions
        local runerRect = runer._sprite:boundingBox()
        local runerSize = runerRect.size
        for k,v in pairs(collisions) do
            --print(collisionRect:getMaxY())

            local collisionRect = v._sprite:boundingBox()
            local foot = CCRectMake(runerRect:getMidX()-runerSize.width/4,runerRect:getMinY(),
            runerSize.width/2,5)
            local head = CCRectMake(runerRect:getMidX()-runerSize.width/4,runerRect:getMaxY()-5,
            runerSize.width/2,5)
            local left = CCRectMake(runerRect:getMinX(),runerRect:getMidY()-runerSize.height/4,
            5,runerSize.height/2)
            local right = CCRectMake(runerRect:getMaxX()-5,runerRect:getMidY()-runerSize.height/4,
            5,runerSize.height/2)
            --runer._loc.y = 0
            -- if collisionRect:containsPoint(ccp(runerRect:getMidX(),runerRect:getMinY())) then
            --     --print("x:"..collisionRect:getMinX().."y:"..collisionRect:getMinY().."sx"..collisionRect:getMaxX().."sy:"..collisionRect:getMaxY())
            --     --print(runerRect:getMinY().."yibanban"..collisionRect:getMaxY())
            --     runer._loc.y = collisionRect:getMaxY()
            --     --runer:changeStatus(RunerDef.RUNER_STATUS.STATUS_NORMAL)
            -- end

            local ground = CCRectMake(collisionRect:getMinX(),collisionRect:getMaxY()-70,collisionRect:getMaxX()-collisionRect:getMinX(),40)
            if ground:intersectsRect(foot) then
                runer._loc.y = runerRect:getMinY()-40
                runer:changeStatus(RunerDef.RUNER_STATUS.STATUS_NORMAL)
            else
                runer._loc.y = 0
            end

            if collisionRect:intersectsRect(head) then
                isCollision = true
            elseif collisionRect:intersectsRect(left) then

            elseif collisionRect:intersectsRect(right) then
                
            end
            if isCollision then
                --可穿透可使用
                if CollisionDef.COLLISION_TYPE[v._type] == CollisionDef.COLLISION_TYPE.COLLISION_GOLD then
                    v._activity = false
                --阻挡
                elseif CollisionDef.COLLISION_TYPE[v._type] == CollisionDef.COLLISION_TYPE.COLLISION_GROUND then

                --可穿透不可使用
                elseif CollisionDef.COLLISION_TYPE[v._type] == CollisionDef.COLLISION_TYPE.COLLISION_2 then

                end
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

    layer:registerScriptTouchHandler(layer.onTouch,false, 0 - BaseSceneDef.LAYER_TYPE.LAYER_TYPE_SCENE,true)
    layer:setTouchEnabled(true)

    layer:init()
    return layer
end

GameSceneLayer.create = function(self) 
    local o = createGameSceneLayer() 
    return o; 
end


return GameSceneLayer