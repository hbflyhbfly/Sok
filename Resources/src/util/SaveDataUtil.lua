
saveDataUtils = CCUserDefault:sharedUserDefault()

local  SaveDataUtil = {}

    function SaveDataUtil:saveText(key, value)
        saveDataUtils:setStringForKey(key,value)
    end

    function SaveDataUtil:saveInterger(key, value)
        saveDataUtils:setIntegerForKey(key,value)
    end

    function SaveDataUtil:saveFloat(key, value)
        saveDataUtils:setFloatForKey(key,value)
    end

    function SaveDataUtil:saveDouble(key, value)
        saveDataUtils:setDoubleForKey(key,value)
    end

    function SaveDataUtil:saveBool(key, value)
        saveDataUtils:setBoolForKey(key,value)
    end

    function SaveDataUtil:getTextForKey(key)
        return saveDataUtils:getStringForKey(key)
    end

    function SaveDataUtil:getIntegerForKey(key)
        return saveDataUtils:getIntegerForKey(key)
    end

    function SaveDataUtil:getFloatForKey(key)
        return saveDataUtils:getFloatForKey(key)
    end

    function SaveDataUtil:getDoubleForKey(key)
        return saveDataUtils:getDoubleForKey(key)
    end

    function SaveDataUtil:getBoolForKey(key)
        return saveDataUtils:getBoolForKey(key)
    end

return SaveDataUtil