local base_util = {}

--判断表是否为空
function base_util.tableIsEmpty(self, t)
    return _G.next(t) == nil
end

function base_util.test(self)
    print("dddddfdfin")
end
--生成枚举
function base_util.creatEnumTable(self, tbl)
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
function base_util.tableReadOnly(self,const_table)
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