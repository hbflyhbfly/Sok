
local log = require "src/util/log"
require "src/constdef/CollisionDef"
local base_util = require "src/util/BaseUtil.lua"
local FileManager = require "src/util/FileManager"
local Collision = {}
local COLLISION_DATA_FILE = "collision.json"
local cache = CCSpriteFrameCache:sharedSpriteFrameCache()

--Z轴偏移量
local RUNER_Z_ORDER = 1
--区分
local RUNER_TAG = 11

--物体数据
Collision.allCollisionData = {}
--物体创建
function Collision:create( id,locX,locY )
	local _collision = {}
	_collision._id = ""
	_collision._name = ""
	_collision._type = nil
	_collision._sprite = nil
	_collision._velocity = 0
	_collision._loc = {
		x = 0,
		y = 0
	}
	_collision._icon = ""
	_collision._activity = true

	self.allCollisionData = FileManager:readJsonFileToTable(COLLISION_DATA_FILE)

	if nil == self.allCollisionData then
		log.Debug("collision:create:数据取得失败")
		return nil
	end
	local createdCollision = self.allCollisionData["collision"..id]
	if nil == createdCollision then
		log.Debug("collision:create:该物体不存在")
		return nil
	end

	_collision._name = createdCollision.name
	_collision._type = CollisionDef.COLLISION_TYPE[createdCollision.type]
	_collision._loc.x = locX
	_collision._loc.y = locY
	_collision._sprite = CCSprite:createWithSpriteFrame(cache:spriteFrameByName(createdCollision.icon))
	_collision._sprite:setPosition(_collision._loc.x,_collision._loc.y)
	_collision._velocity = CollisionDef.ACCELERATION_VALUE.ACCELERATION_3
	_collision._activity = true
	function _collision:destroy()
		-- 死亡动画
	end
	return _collision
end

return Collision
