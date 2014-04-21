require "src/constdef/RunerDef"

local Runer = {}
Runer.allRunerData = {}
--人物创建
function Runer:create(runerData)
	_runer = CCArmature:create(runerData.icon) 
    function _runer:runAnimation(action)
        -- 动画
        self:getAnimation():play(action)
        runerData.action = action
        local head = self:getBone("head")
        head:getWorldInfo()
    end
    _runer:runAnimation(runerData.action)
    _runer:setAnchorPoint(ccp(0,0))
    function _runer:update(runerData)
        if runerData.action ~= runerData.nextAction then
            self:runAnimation(runerData.nextAction)
        end
        self:setPosition(ccp(runerData.locX,runerData.locY))
        self:setAnchorPoint(ccp(0,0))
    end
	return _runer
end

return Runer
