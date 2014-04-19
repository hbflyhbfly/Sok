local M = {}

--渲染是(小的先画),代理(小的先触发)
M.LAYER_TYPE = 
{  
	LAYER_TYPE_INVAILD = -1,				--无效层
	LAYER_TYPE_BG  	   = -64,				--背景层
	LAYER_TYPE_SCENE   = -8,				--场景层 用于主要逻辑处理的一层
	LAYER_TYPE_MENU    = -4,				--界面UI层
	LAYER_TYPE_TEMP	   = -2,				--临时层
}

--背景场景移动速度
M.SPEED_TABLE = 
    {  
        BACKGROUND_SPEED1 = 5,  
        BACKGROUND_SPEED2 = 10,
        BACKGROUND_SPEED3 = 15,
        BACKGROUND_SPEED4 = 40,
        BACKGROUND_SPEED5 = 45
    }  


local modename = "BaseSceneDef"
local proxy = {}
local mt    = {
    __index = M,
    __newindex =  function (t ,k ,v)
        print("BaseSceneDef attemp to update a read-only table")
    end
} 
setmetatable(proxy,mt)
_G[modename] = proxy
package.loaded[modename] = proxy