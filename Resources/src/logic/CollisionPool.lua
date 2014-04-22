
local log = require "src/util/log"
require "src/constdef/CollisionDef"
local base_util = require "src/util/BaseUtil.lua"
local FileManager = require "src/util/FileManager"
local Collision = require "src/basestruct/Collision"
local CollisionPool = {}

local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
local COLLISION_DATA_FILE = "collision.json"

--Z轴偏移量
local RUNER_Z_ORDER = 1
--区分
local RUNER_TAG = 11

--物体创建
function CollisionPool:sharedCollisionPool()
	if nil == self.instance then
		self.instance = self:new()
	end
	return self.instance
	-- body
end

function CollisionPool:new(o)
	o = o or {}
	setmetatable(o,self)
	self.__index = self

	o.allCollisionData = {}
	function o:addCollisions(fileName)
		self.allCollisionData = FileManager:readJsonFileToTable(fileName)
		if nil == self.allCollisionData then
			log.Debug("collision:create:数据取得失败")
			return nil
		end
	end

	function o:getCollision(level,id)
		print(level)
		local currentCollisions = self.allCollisionData["level"..level]
		if currentCollisions then
			if currentCollisions["collision"..id] then
				return currentCollisions["collision"..id]
			end
		end
		return nil
	end
	return o
end
return CollisionPool