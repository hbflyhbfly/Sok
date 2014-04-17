require "src/constdef/RunerDef"

local Runer = {}
Runer.allRunerData = {}
--人物创建
function Runer:create(runerData)
	_runer = CCArmature:create(runerData._icon) 
    function _runer:initSkin(armture_ , skinName, skinArrayNum , boneName)
        for i = 1,skinArrayNum  do
            local skinName = skinName..i..".png"
            local skin = CCSkin:create(skinName)
            armture_:getBone(boneName):addDisplay(skin, i - 1)
         end   
    end
    function _runer:runAnimation(action)
        -- 动画
        self:getAnimation():play(action)
        self._action = action
    end
    _runer:runAnimation(runerData._action)
    _runer._action = RunerDef.ACTION_TYPE[runerData._action]
    _runer:setAnchorPoint(ccp(0,0))
	_runer:initSkin(_runer,runerData._frame_star,runerData._frame_num,runerData._boneName)

    local index = 1
    function _runer:changeHeadFrame(runerData)
        index = index + 1
        if index > runerData._frame_num - 1 then
            index = 1
        end
        _runer:getBone(runerData._boneName):changeDisplayWithIndex(index, ture)
    end

    function _runer:update(runerData)
        if runerData._action ~= action then
            
        end
        
        self:changeHeadFrame(runerData)
        self:setPosition(ccp(runerData._loc._x,runerData._loc._y))
    end
    
	return _runer
end

return Runer
