require "src/constdef/CollisionDef"
local base_util = require "src/util/BaseUtil.lua"
local CollisionMap = require "src/logic/CollisionMap"
local Collision = {}
local visibleSize = CCDirector:sharedDirector():getWinSize()
local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
local scheduler = CCDirector:sharedDirector():getScheduler()

--移动速度
Collision.ACCELERATION = base_util:tableReadOnly(CollisionDef.ACCELERATION_TABLE)
--障碍物类型
Collision.COLLISION_TYPE = base_util:tableReadOnly(CollisionDef.COLLISION_TYPE)

local COLLISION_Z_ORDER_BARPIE = 1

function Collision:createCollisionLayer()
	local _layer = CCLayer:create()
    --运行的障碍物
	_layer._a_collisions = {}
    --飞出屏幕，击毁，使用，需要移除的障碍物
    _layer._a_del_collisions = {}
    function init()
        --更具级别生成地图
        local collisionMap = CollisionMap:createWithLevel("level1")
            for i,v in ipairs(collisionMap.tiles) do
            if 0 ~= v.type then
                --添加障碍物
                local collision = Collision:createCollision(v.type,v.id,v.locX,v.locY)
                _layer:addChild(collision.sprite,COLLISION_Z_ORDER_BARPIE,v.type)
                table.insert(_layer._a_collisions,collision)
            end
        end
        scheduler:scheduleScriptFunc(updateCollision, 0, false)
    end
    function _layer:getCollisions()
        return self._a_collisions
    end
    --移动障碍物
    function updateCollision(dt)
    	if #_layer._a_collisions <= 0 then
            return
        end
        for i,v in ipairs(_layer._a_collisions) do
            if nil ~= v then
                local collisionSprite = v.sprite
                collisionSprite:setPositionX(collisionSprite:getPositionX()-Collision.ACCELERATION.ACCELERATION_3)
                if collisionSprite:getPositionX()<=-70 then
                    table.insert(_layer._a_del_collisions,v)
                end
            end
        end
        _layer:deleteCollision()
    end
    
    --删除障碍物
    function _layer:deleteCollision()
        for i,delColl in ipairs(self._a_del_collisions) do
            local delID = delColl.id
            for j,v in ipairs(self._a_collisions) do
                if v then
                    if v.id == delID then
                        print(v.id)
                        self:removeChild(v.sprite,true)
                        table.remove(self._a_collisions,j)
                        table.remove(self._a_del_collisions,i)

                    end
                end
            end
        end
    end
    init()
    return _layer
end
--按类型，位置，id生成障碍物
function Collision:createCollision( type,id,locX,locY )
    local collision = {}
    collision.type = type
    collision.id = id
    collision.name = ""
    local collisionSprite = CCSprite:createWithSpriteFrame(cache:spriteFrameByName("tile"..type..".png"))
    collisionSprite:setPosition(ccp(locX,locY))
    --collisionSprite:setAnchorPoint(ccp(0,0))
    collision.sprite = collisionSprite
    return collision
end

return Collision