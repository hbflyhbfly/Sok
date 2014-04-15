
local IUIManager = {}

function IUIManager:new(o)
     o = o or {}
    setmetatable(o, self)
    self.__index = self;
    return o
end

function IUIManager:update(dt)
end

return IUIManager