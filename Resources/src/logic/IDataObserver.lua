IDataObserver = {}

-- 事件通知
-- param1 通知类型
-- param2 保留字段
-- param3 通知数据
function IDataObserver:OnDataChange(param1, param2, param3)
end

function IDataObserver:new(o)
 	o = o or {}
    setmetatable(o, self)
    self.__index = self;
    return o
end
