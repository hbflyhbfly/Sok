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
        SPEED_COSSISION = 5
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
	local lenth = CONST.INTERVAL_COLLISION+CONST.WIDTH_COLLISION
	local _m_barPies = CCArray:create()
    _m_barPies:retain()
    --local count = math.ceil(visibleSize.width/lenth)
    --print(count)
    function init()
        local collisionMap = CollisionMap:createWithLevel("level1")
            for i,v in ipairs(collisionMap.tiles) do
            --print(i,v.type)
            if 0 ~= v.type then
                local collision = Collision:createCollision(v.type,v.locX,v.locY)
                _layer:addChild(collision.sprite,COLLISION_Z_ORDER_BARPIE,v.type)
                _m_barPies:addObject(collision.sprite)
            end
        end
    	
        scheduler:scheduleScriptFunc(updateCollision, 0, false)
    end

    function updateCollision(dt)
    	print(_m_barPies:count())
    	if _m_barPies:count() == 0 then
    	 	return;
    	end
    	local barPie
    	for i=0,_m_barPies:count()-1 do
    		barPie = _m_barPies:objectAtIndex(i)
    		barPie:setPositionX(barPie:getPositionX()-CONST.SPEED_COSSISION)
            if barPie:getPositionX()<=-70 then
                _layer:removeChild(barPie)
                _m_barPies:removeObject(barPie)
            end
    	end
    	-- body
    end
    local function getCollisions()
    	-- body
    	return _m_barPies
    end
    init()
    --local _runer = CCSprite:createWithSpriteFrame(cache:spriteFrameByName("down_bar.png"))
    return _layer
end
function Collision:createCollision( type,locX,locY )
    -- body
    local collision = {}
    collision.type = type
    collision.id = ""
    collision.name = ""
    local collisionSprite = CCSprite:createWithSpriteFrame(cache:spriteFrameByName("tile"..type..".png"))
    collisionSprite:setPosition(ccp(locX,locY))
    collisionSprite:setAnchorPoint(ccp(0,1))
    collision.sprite = collisionSprite
    return collision
end



return Collision