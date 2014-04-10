require "src/scene/GameScene"
local log = require "src/util/log"

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
    local scene_game = createGameScene()
    CCDirector:sharedDirector():runWithScene(scene_game)
end

xpcall(main, __G__TRACKBACK__)
