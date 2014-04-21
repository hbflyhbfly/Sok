require "src/scene/GameScene"
local log = require "src/util/log"-- for CCLuaEngine traceback

-- local GameScene = require "src/scene/GameScene"
local CheckPointsScene = require "src/scene/CheckPointsScene"
require "src/constdef/GlobalDef"
-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------")
end



local function main()
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
	log.Info("Game start-------")
    local scene_game = CheckPointsScene:create()
    -- local scene_game = GameScene:create()
    --log.Info("main " .. tostring(scene_game))
    --log.Info("main" .. tostring(scene_game2))
    CCDirector:sharedDirector():runWithScene(scene_game)

end

xpcall(main, __G__TRACKBACK__)
