--逻辑层场景层通用
local M = {}
-------------------------------------ENUM START-----------------------------------
-- 人物状态
M.RUNER_STATUS = 
{  
    STATUS_DROP_DOWN = 3,
    STATUS_NORMAL = 0, 
    STATUS_JUMP_UP = 1,
    STATUS_CROUCH = 2,
}
-------------------------------------ENUM END-----------------------------------



-------------------------------------CONST START-----------------------------------
--角色下落重力加速度/跳跃上升的初始速度
M.ACCELERATION_VALUE = 
{
    ACCELERATION_G = -3,
    ACCELERATION_UP = 30
}

M.RUNER_TAG = 
{
    RUNER_TAG_1 = 1
}

M.RUNER_Z_ORDER = 
{
    RUNER_Z_ORDER_1 = 1
}
-------------------------------------CONST END-----------------------------------


local modename = "RunerDef"
local proxy = {}
local mt    = {
    __index = M,
    __newindex =  function (t ,k ,v)
        print("RunerDef attemp to update a read-only table")
    end
} 
setmetatable(proxy,mt)
_G[modename] = proxy
package.loaded[modename] = proxy