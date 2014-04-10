require "header"
CollisionMap = require "CollisionMap"
local Collision = {}
local visibleSize = CCDirector:sharedDirector():getWinSize()
local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
local scheduler = CCDirector:sharedDirector():getScheduler()

local PAR_TABLE = 
    {  
        INTERVAL_COLLISION = 300,  
        WIDTH_COLLISION = 50,
        SPEED_COSSISION = 1
    }  
local CONST = newConst(PAR_TABLE)

--障碍物类型
local COLLISION_TYPE_TABLE = {
    COLLISION_BARPIE = 1
}
local COLLISION_TYPE = newConst(COLLISION_TYPE_TABLE)

local COLLISION_Z_ORDER_BARPIE = 1

function Collision:createCollisionLayer()
	local _layer = CCLayer:create()

	local _a_collisions = {}
    --飞出屏幕，击毁，使用，需要移除的障碍物
    local _a_del_collisions = {}
    function init()
        --更具级别生成地图
        local collisionMap = CollisionMap:createWithLevel("level1")
            for i,v in ipairs(collisionMap.tiles) do
            if 0 ~= v.type then
                --生成障碍物
                local collision = Collision:createCollision(v.type,v.id,v.locX,v.locY)
                _layer:addChild(collision.sprite,COLLISION_Z_ORDER_BARPIE,v.type)
                table.insert(_a_collisions,collision)
            end
        end
        scheduler:scheduleScriptFunc(updateCollision, 0, false)
    end
    --移动障碍物
    function updateCollision(dt)
    	if #_a_collisions <= 0 then
            return
        end
        for i,v in ipairs(_a_collisions) do
            if nil ~= v then
                local collisionSprite = v.sprite
                collisionSprite:setPositionX(collisionSprite:getPositionX()-CONST.SPEED_COSSISION)
                if collisionSprite:getPositionX()<=-70 then
                    table.insert(_a_del_collisions,v)
                end
            end
        end
    end
    local function getCollisions()
    	return _a_collisions
    end
    function deleteCollision()
        for i,delColl in ipairs(_a_del_collisions) do
            local delID = delCol.id
            for j,coll in ipairs(_a_collisions) do
                if nil ~= coll then
                    coll = nil
                end
            end

        end
    end
    init()
    return _layer
end
function Collision:createCollision( type,id,locX,locY )
    local collision = {}
    collision.type = type
    collision.id = id
    collision.name = ""
    local collisionSprite = CCSprite:createWithSpriteFrame(cache:spriteFrameByName("tile"..type..".png"))
    collisionSprite:setPosition(ccp(locX,locY))
    collisionSprite:setAnchorPoint(ccp(0,1))
    collision.sprite = collisionSprite
    return collision
end



return Collision