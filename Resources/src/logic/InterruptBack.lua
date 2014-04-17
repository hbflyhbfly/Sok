
local SaveDataUtil = require "src/util/SaveDataUtil"

function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------")
end

local function onBack()
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    SaveDataUtil:saveText("playerName", "屎云姐")
	SaveDataUtil:getIntegerForKey("playerLevel", "11")
    
end

xpcall(onBack, __G__TRACKBACK__)
