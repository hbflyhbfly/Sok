require "BaseScene"
require "armTest"
-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------")
end


local log = require "log"

local function main()
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
	log.Info("hello world1")
	log.Info("hello world2")
	log.Error("hello world3")
	log.Error("hello world4")
    local scene_game = CCScene:create()
    scene_game:addChild(createBaseLayer())
    --scene_game:addChild(cretateArmTestLayer()) --骨骼动画layer加载
    CCDirector:sharedDirector():runWithScene(scene_game)
end

xpcall(main, __G__TRACKBACK__)
