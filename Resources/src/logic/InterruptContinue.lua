
local SaveDataUtil = require "src/util/SaveDataUtil"

function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------")
end

local function onContinue()
    -- avoid memory leak
     local testname = SaveDataUtil:getTextForKey("playerName")
    print("Interrupt:onContinue"..testname)

    local testlevel = SaveDataUtil:getIntegerForKey("playerLevel")
    print("playerLevel  playerLevel  playerLevel"..testlevel)
end
xpcall(onContinue, __G__TRACKBACK__)
