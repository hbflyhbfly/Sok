--逻辑层场景层通用
local M = {}
-------------------------------------ENUM START-----------------------------------
-- 人物状态
M.BASE_RUNER_STATUS = 
{  
    STATUS_NORMAL = 0, 
    STATUS_JUMP_UP = 1,
    STATUS_JUMP_DOWN = 2,
    STATUS_CROUCH = 3,
}
-------------------------------------ENUM END-----------------------------------



-------------------------------------CONST START-----------------------------------
--角色下落重力加速度/跳跃上升的初始速度
M.ACCELERATION_TABLE = 
{
    ACCELERATION_G = 0.9,
    ACCELERATION_UP = 9
}
-------------------------------------CONST END-----------------------------------


local modename = "RunerStatus"
local proxy = {}
local mt    = {
    __index = M,
    __newindex =  function (t ,k ,v)
        print("RunerStatus attemp to update a read-only table")
    end
} 
setmetatable(proxy,mt)
_G[modename] = proxy
package.loaded[modename] = proxy