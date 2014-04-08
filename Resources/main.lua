require "BaseScene"
require "armTest"
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
	SKLog(SKLOG_INFO,"TAG", "FRIRST");
	
    local scene_game = CCScene:create()
    scene_game:addChild(createBaseLayer())
    --scene_game:addChild(createBaseLayer())
    --scene_game:addChild(cretateArmTestLayer()) --骨骼动画layer加载
    CCDirector:sharedDirector():runWithScene(scene_game)
end

xpcall(main, __G__TRACKBACK__)
