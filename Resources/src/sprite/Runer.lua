require "src/constdef/RunerDef"

local Runer = {}
Runer.allRunerData = {}
--人物创建
function Runer:create(runerData)
	_runer = CCArmature:create(runerData.icon)
    _runer:setAnchorPoint(ccp(0,0))
    function _runer:runAnimation(action)
        -- 动画
        self:getAnimation():play(action)
        self:getAnimation():setMovementEventCallFunc(
            function ()
                local currentID = self:getAnimation():getCurrentMovementID()
                if currentID ~= 6 then
                    --self:getAnimation():play(runerData.action)
                else
                    
                end
            end)
        runerData.action = action
    end

    function _runer:update(runerData)
        if runerData.action ~= runerData.nextAction then
            self:runAnimation(runerData.nextAction)
        end
        self:setPosition(ccp(runerData.locX,runerData.locY))
    end
	return _runer
end
return Runer
