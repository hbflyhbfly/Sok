--逻辑层场景层通用
local M = {}
-------------------------------------ENUM START-----------------------------------
-- 障碍物类型
M.COLLISION_TYPE = 
{  

    COLLISION_1 = 1,
   	COLLISION_2 = 2,
    COLLISION_3 = 3,
}
-------------------------------------ENUM END-----------------------------------
M.ACCELERATION_TABLE = 
{  
    ACCELERATION_1 = 300,  
    ACCELERATION_2 = 50,
    ACCELERATION_3 = 1
}  


-------------------------------------CONST START-----------------------------------

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