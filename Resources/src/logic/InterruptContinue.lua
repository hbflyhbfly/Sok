
local SaveDataUtil = require "src/util/SaveDataUtil"
require "src/ui/ViewGameScene"
require "src/ui/UIPauseLayer"
local UIManager = require "src/ui/UIManager"

function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------")
end

local function onContinue()
    -- avoid memory leak
    --  local testname = SaveDataUtil:getTextForKey("playerName")
    -- print("Interrupt:onContinue"..testname)
    -- local testlevel = SaveDataUtil:getIntegerForKey("playerLevel")
    -- print("playerLevel  playerLevel  playerLevel"..testlevel)

    local currentScene = CCDirector:sharedDirector():getRunningScene()
    tolua.cast(currentScene,"CCScene")  

    local view_pause_scene = UIPauseLayer:create()
    tolua.cast(view_pause_scene,"CCLayer")  

	view_pause_scene:setPosition(500, 500)   	
   	currentScene:addChild(view_pause_scene,1000)		

    -- UIManager:AddLayer(currentScene,"view_pause_scene",view_pause_scene,1001)
    -- UIManager:RegisterUpdate("view_pause_scene")
    --currentScene:addChild(view_pause_scene,1000000)
    --	currentScene:addChild(view_pause_scene,10000)
end
xpcall(onContinue, __G__TRACKBACK__)
