require "AudioEngine"
require "src/constdef/BaseSceneDef"
require "src/ui/MyTableView"
local FileManager = require "src/util/FileManager"
local MainCpOrigin = require "src/basestruct/CheckPoint"
local SubCpOrigin  = require "src/basestruct/SubCheckPoint"
local CHECKPOINT_JSON_FILE = "checkpoints.json"

local log = require "src/util/log"
local MainCpLayer = require "src/scene/MainCpLayer" 
-- local SubCpLayer = require "src/scene/SubCpLayer"

CheckPointsScene = {}

CheckPointsScene._MainCpData = {}

-- CheckPointsScene._CheckPointsScene = CCScene:create()
CheckPointsScene._CheckPointsLayer = CCLayer:create()
-- CheckPointsScene._MainCpLayer = nil
-- CheckPoint._SubCpLayer = nil

local function getCpData()
	local got_table = FileManager:readJsonFileToTable(CHECKPOINT_JSON_FILE)
	for k,v in pairs(got_table._mainCheckPoint) do
		local CheckPoint = {}
		setmetatable(CheckPoint, MainCpOrigin)
    	MainCpOrigin.__index = CheckPoint
		CheckPoint._mainId = v._mainCpId
		CheckPoint._mainName = v._mainCpName
		CheckPoint._mainLevel = v._mainCpLevel
		CheckPoint._mainIsLocked = v._mainCpIsLocked
		CheckPoint._mainRewardCoin = v._mainCpRewardCoin
		CheckPoint._mainRewardExp = v._mainCpRewardExp
		CheckPoint._mainRewardedId = v._mainCpRewardedId
		CheckPoint._mainCpSubCheckPoints = v._mainCpSubCheckPoints
		local x = 0
		for key,value in pairs(v._mainCpSubCheckPoints) do

			SubCheckPoint = {}
			setmetatable(SubCheckPoint, SubCpOrigin)
    		SubCpOrigin.__index = SubCheckPoint

			SubCheckPoint._subId = value._subCpId
			SubCheckPoint._subName = value._subCpName
			SubCheckPoint._subLevel = value._subCpLevel
			SubCheckPoint._subIsLocked = value._subCpIsLocked
			SubCheckPoint._subRewardCoin = value._subCpRewardCoin
			SubCheckPoint._subRewardExp = value._subCpRewardExp
			SubCheckPoint._subRewardedId = value._subCpRewardedId
			CheckPoint._mainCpSubCheckPoints[x] = SubCheckPoint
			x = x + 1
		end
		table.insert(CheckPointsScene._MainCpData,CheckPoint)
	end
end

local function createCheckPointsScene()

	getCpData()

	local newScene = CCScene:create()
	local newLayer = CCLayer:create()

	local mainCpLayer = MainCpLayer:create(CheckPointsScene._MainCpData)
	newLayer:addChild(mainCpLayer,BaseSceneDef.LAYER_TYPE.LAYER_TYPE_SCENE)
	newScene:addChild(newLayer)
	return newScene
end

CheckPointsScene.create = function(self) 
    local o = createCheckPointsScene() 
    return o
end

function release()
	-- body
	FileManager = nil
	MainCpOrigin = nil
	SubCpOrigin  = nil
	CHECKPOINT_JSON_FILE = nil

	log = nil
	MainCpLayer = nil

	CheckPointsScene._MainCpData = nil
	CheckPointsScene._CheckPointsLayer = nil
	CheckPointsScene = nil
end

return CheckPointsScene