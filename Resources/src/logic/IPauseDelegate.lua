--在暂停界面中（主动调用中断处理）

IPauseDelegate = {}

function IPauseDelegate:OnBack()
end

function IPauseDelegate:onContinueGame()
end

function IPauseDelegate:new(o)
 	o = o or {}
    setmetatable(o, self)
    self.__index = self;
    return o
end
