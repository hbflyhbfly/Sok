local log = require "src/util/log"
local FileManager = require "src/util/FileManager"
local CollisionPool = require "src/logic/CollisionPool"
require "src/util/json"
local LEVELS = {
	level1 = "level1",
	level2 = "level2",
	level3 = "level3",
	level4 = "level4",
	level5 = "level5",
}
local FILE_TYPE = ".json"

local fileUtils = CCFileUtils:sharedFileUtils()
local visible_size = CCDirector:sharedDirector():getVisibleSize()

local CollisionMap = {}

	function CollisionMap:createWithLevel(level)
		--地图
		local collisionMap = {}
		--地图块
		collisionMap.tiles = {}
		--地图的尺寸
		collisionMap.height = {}
		collisionMap.width = {}
		--瓦片大小和类型
		collisionMap.tileHeight = {}
		collisionMap.tileWidth = {}
		collisionMap.velocity = 0
		cp = CollisionPool:sharedCollisionPool()
		cp:addCollisions("collision.json")
		local fileName = LEVELS[level]..FILE_TYPE
		local _collision_map_data = FileManager:readJsonFileToTable(fileName)
		if _collision_map_data then

			collisionMap.height = _collision_map_data.height
			collisionMap.width = _collision_map_data.width

			collisionMap.tileWidth = _collision_map_data.tilewidth
			collisionMap.tileHeight = _collision_map_data.tileheight
			--地图速度
			collisionMap.velocity = _collision_map_data.velocity
			--瓦片位置和类型
			local tileData = _collision_map_data.layers[1].data
			for i=0,collisionMap.width-1 do
				for j=0,collisionMap.height-1 do
					local n = j*collisionMap.width+i+1
					if 0 ~= tileData[n] then 
						local temp = cp:getCollision(tileData[n])
						local tile = {}
						setmetatable(tile, temp)
    					temp.__index = temp;
						if tile.id then tile.id = n end
						if tile.locX then tile.locX = i * collisionMap.tileWidth end
						if tile.locY then tile.locY = visible_size.height - (j * collisionMap.tileHeight) end
						table.insert(collisionMap.tiles,tile)
					end
				end
			end
		end

		return collisionMap
	end
return CollisionMap
