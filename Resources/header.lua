
function newConst( const_table )    --生成常量表功能  
    function Const( const_table )  
        local mt =  
        {  
            __index = function (t,k)  
                return const_table[k]  
            end,  
            __newindex = function (t,k,v)  
                print("*can't update " .. tostring(const_table) .."[" .. tostring(k) .."] = " .. tostring(v))  
            end  
        }  
        return mt  
    end  
  
    local t = {}  
    setmetatable(t, Const(const_table))  
    return t  
end  

-- function NEW_CONST_DEFINE() --生成自定义常量表  
--     local PAR_TABLE = 
--     {  
--         MAPNAME = "冰星",  
--         MAPID = 999,  
--         MONSTER1 = newConst({"哥斯拉", 1, 1}), --表项为常量的也需声明为常量表  
--         MONSTER2 = newConst({"小强",2,2}),  
--         MONSTER3 = newConst({"史锐克",3,3})  
--     }  
--     local t = newConst(PAR_TABLE)  
--     return t  
-- end  

--获得自定义常量表  
-- CONST_MAP = NEW_CONST_DEFINE()
-- print(CONST_MAP.MAPNAME)
-- print(CONST_MAP.MAPID)
-- print(CONST_MAP.MONSTER1[1])
-- print(CONST_MAP.MONSTER2[1])
-- print(CONST_MAP.MONSTER3[1])

--package.path = package.path .. ";?.lua"
-- print(package.path.."－－－－－－－－－－")
-- local packMap = require "gameMap"
-- local map = packMap:newCollisionMap(CONST_MAP.MAPNAME,CONST_MAP.MAPID)
-- map:buildCollision(CONST_MAP.MONSTER1[1],CONST_MAP.MONSTER1[2],CONST_MAP.MONSTER1[3])
-- map:showMap()
