require "src/constdef/GlobalDef"
local base_util = {}

--判断表是否为空
function base_util:tableIsEmpty(t)
    return _G.next(t) == nil
end

--生成枚举
function base_util:creatEnumTable(tbl)
    --assert(IsTable(tbl)) 
    local enum_tbl = {} 
    local enum_index = 0 
    for i, v in ipairs(tbl) do 
        print("key = " .. i .. " value = " .. v)
        enum_tbl[v] = enum_index + i 
    end 
    return enumtbl 
end 

--生成常量表功能
function base_util:tableReadOnly(const_table)
    function Const(const_table)  
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


--获取动画文件名
function base_util:getAniFileName(ani_id, action_id, ani_type, ani_part, suffix_name)
    local file_name = GlobalDef.BASE_SRC_NAME.PRE_ANI
    file_name = file_name .. "_" .. ani_id
    file_name = file_name .. "_" .. ani_type
    if ani_part then
        file_name = file_name .. "_" .. ani_part
    end

    file_name = file_name .. suffix_name

    return file_name
end

--local modename = "BaseUtil"
--local proxy = {}
--local mt    = {
--    __index = base_util,
--    __newindex =  function (t ,k ,v)
--        print("attemp to update a read-only table")
--    end
--} 
--setmetatable(proxy,mt)
--_G[modename] = proxy
--package.loaded[modename] = proxy

return base_util