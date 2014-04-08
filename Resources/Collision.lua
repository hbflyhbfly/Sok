require "header"
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

function Collision:createCollisionLayer()
	local _layer = CCLayer:create()
	local lenth = CONST.INTERVAL_COLLISION+CONST.WIDTH_COLLISION
    local count = math.ceil(visibleSize.width/lenth)
    local _m_barPies = CCArray:create()
    function _layer:initContent()
    	for i=1,count do
			local collision = CCSprite:createWithSpriteFrame(cache:spriteFrameByName("down_bar.png"))
    		collision:setPosition(ccp(visibleSize.width+lenth*i,200))
    		_m_barPies:addObject(collision)
    		_layer:addChild(collision)
    	end
    	_m_barPies:retain()

        scheduler:scheduleScriptFunc(updateCollision, 0, false)
    end

    function updateCollision(dt)
    	if _m_barPies:count() == 0 then
    	 	return;
    	end
    	local barPie = {}
    	for i=0,_m_barPies:count()-1 do
    		barPie = _m_barPies:objectAtIndex(i)
    		barPie:setPositionX(barPie:getPositionX()-CONST.SPEED_COSSISION)
    	end
    	barPie = _m_barPies:objectAtIndex(0)
    	if barPie:getPositionX() <= -CONST.WIDTH_COLLISION then
    		barPie:retain()
    		local lastBarPie = _m_barPies:lastObject()
    		barPie:setPositionX(lastBarPie:getPositionX()+lenth)
    		_m_barPies:removeObjectAtIndex(0)
    		_m_barPies:addObject(barPie)
    		barPie:release()
    	end
    	-- body
    end
    function _layer:getCollisions()
    	return _m_barPies
    end
    _layer:initContent()
    return _layer
end

return Collision