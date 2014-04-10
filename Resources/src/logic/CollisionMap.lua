local log = require "src/util/log"
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
		--地图的大小
		collisionMap.height = {}
		collisionMap.width = {}
		--瓦片位置和类型
		collisionMap.tileHeight = {}
		collisionMap.tileWidth = {}
		--print(level)
		local fileName = LEVELS[level]..FILE_TYPE
		local _collision_map_data = self:readJsonFile(fileName)
		if _collision_map_data then

			collisionMap.height = _collision_map_data.height
			collisionMap.width = _collision_map_data.width

			--瓦片的大小
			collisionMap.tileHeight = visible_size.height/collisionMap.height
			collisionMap.tileWidth = visible_size.width/collisionMap.width
			--瓦片位置和类型
			local tileData = _collision_map_data.layers[1].data
			for i=0,collisionMap.width-1 do
				for j=0,collisionMap.height-1 do
					local id = j*collisionMap.width+i+1
					local mapTile = {}
					mapTile.type = tileData[id]
					mapTile.id = id
					mapTile.locX = i * collisionMap.tileWidth
					mapTile.locY = visible_size.height - (j * collisionMap.tileHeight)
					table.insert(collisionMap.tiles,mapTile)
					--print(j)
				end
			end
			--tileData = _collision_map_data.layers
		end
		return collisionMap
	end
	function CollisionMap:readJsonFile(file)
		local _fileName = file
		local _fileData = {}
		local _tableData = {}
		if nil == _fileName or "" == _fileName then
			log:Error("File'name doesn't exist")
			return nil
		end

		_fileData = fileUtils:getFileData(_fileName,"r",0)
		if not _fileData then

			log:Error("Data obtained failure")
			return nil
		end

		local _tableData = json.decode(_fileData) --json->table数据
	
		return _tableData
	end
return CollisionMap
