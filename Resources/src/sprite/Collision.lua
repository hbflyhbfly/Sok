
local log = require "src/util/log"
require "src/constdef/CollisionDef"
local Collision = {}
local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
--物体创建
function Collision:create( collisionData )
	local _collision = {}
	_collision = CCSprite:createWithSpriteFrame(cache:spriteFrameByName(collisionData.icon))
	_collision:setPosition(ccp(collisionData.locX,collisionData.locY))
	function _collision:destroy()
		-- 死亡动画
	end
	--更新物体位置，动画等
	function _collision:update(collisionData)
		self:setPositionX(collisionData.locX)

	end
	return _collision
end

return Collision
