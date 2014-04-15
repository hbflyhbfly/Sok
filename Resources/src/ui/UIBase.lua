
local UIBase = {}

function UIBase:new(o)
     o = o or {}
    setmetatable(o, self)
    self.__index = self;
    return o
end

function UIBase:create(self)   
end

function UIBase:destroy(self)
end

function UIBase:update(dt)
end

return UIBase