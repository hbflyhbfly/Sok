local Runer = {}
Runer.allRunerData = {}
--人物创建
function Runer:create(runerData)

	_runer = CCArmature:create(runerData._icon) 
    _runer:getAnimation():play(runerData._action)
	_runer:setPosition(runerData._loc._x,runerData._loc._y)
    _runer:setAnchorPoint(ccp(0,0))
	_runer:initSkin(_runer,createdRuner.frame_star,createdRuner.frame_num,createdRuner.boneName)

    local index = 1
    function _runer:changeHeadFrame(dt)
        index = index + 1
        if index > createdRuner.frame_num - 1 then
            index = 1
        end
        _runer:getBone(createdRuner.boneName):changeDisplayWithIndex(index, ture)
    end 
    function _runer:initSkin(armture_ , skinName, skinArrayNum , boneName)
        for i = 1,skinArrayNum  do
            local skinName = skinName..i..".png"
            local skin = CCSkin:create(skinName)
            armture_:getBone(boneName):addDisplay(skin, i - 1)
         end   
    end
    function _runer:update(runerData)
        self:setPosition(ccp(runerData._loc._x,runerData._loc._y))
    end
    
	return _runer
end

return Runer
