require "src/constdef/BaseSceneDef"

--这个可以视为类名
local SubCpLayer = {}

--这些变量可以视为类内成员变量
local _visible_size = CCDirector:sharedDirector():getWinSize()

--常量
-- local CONST_SPEED = _base_util:tableReadOnly(BaseSceneDef.SPEED_TABLE)

local function createSubCpLayer()
	local sub_checkpoint_layer = CCLayer:create()
    
	return sub_checkpoint_layer
end

SubCpLayer.create = function(self) 
    local o = createSubCpLayer() 
    return o; 
end

return SubCpLayer