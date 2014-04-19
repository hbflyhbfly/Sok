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

-- 碰撞部位
M.RUNER_COLLISION_AREA =
{
    AREA_NONE = 0x0001,
    AREA_HEAD = 0x0002,
    AREA_FOOT = 0x0003,
    AREA_LEFT = 0x0004,
    AREA_RIGHT = 0x0005
}

M.ACTION_TYPE = 
{

    STAND = 0,                          --站立
    ONWATER = 1,                        --水上漂
    JUMP1 = 2,                          --跳跃1
    JUMP2 = 3,                          --跳跃2
    RUN1 = 4,                           --跑动1
    RUN2 = 5,                           --跑动2
    ATTACK = 6,                         --攻击
    TODEAD = 7,                         --必杀
    ONGRASS1 = 8,                       --草上飞1
    ONGRASS2 = 9,                       --草上飞2
    FLY = 10,                           --梯云纵
    MOUNT = 11,                         --坐骑
    SPECIAL_EFFECT1 = 128,              --可能是降龙十八掌等特效动画
    SPECIAL_EFFECT2 = 256

}

M.ANI_TYPE = 
{
    BONE = "bone",                      --骨骼动画
    FRAME = "frame"                     --帧动画
}

M.ANI_PART = 
{
    HEAD = "head",                      --头
    BODY = "body",                      --身体
    LEGL1 = "legl1",                    --左腿1
    LEGL2 = "legl2",                    --左腿2
    LEGR1 = "legr1",                    --右腿1
    LEGR2 = "legr2"                     --右腿2
}

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
    RUNER_Z_ORDER_1 = 100
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