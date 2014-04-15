--逻辑层场景层通用
local M = {}
-------------------------------------ENUM START-----------------------------------
-- 障碍物类型
M.COLLISION_TYPE = 
{  

    COLLISION_GROUND = 1,
   	COLLISION_GOLD = 2,
    COLLISION_3 = 3,
}

-------------------------------------ENUM END-----------------------------------
M.ACCELERATION_VALUE = 
{  
    ACCELERATION_1 = 300,  
    ACCELERATION_2 = 50,
    ACCELERATION_3 = 5
}  


-------------------------------------CONST START-----------------------------------
M.COLLISION_TAG = 
{
    COLLISION_TAG_1 = 1
}

M.COLLISION_Z_ORDER = 
{
    COLLISION_Z_ORDER_1 = 1
}
-------------------------------------CONST END-----------------------------------


local modename = "CollisionDef"
local proxy = {}
local mt    = {
    __index = M,
    __newindex =  function (t ,k ,v)
        print("CollisionDef attemp to update a read-only table")
    end
} 
setmetatable(proxy,mt)
_G[modename] = proxy
package.loaded[modename] = proxy