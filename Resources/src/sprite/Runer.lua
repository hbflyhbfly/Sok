require "src/constdef/RunerDef"
local log = require "src/util/log"
local base_util = require "src/util/BaseUtil.lua"
local FileManager = require "src/util/FileManager"
local Runer = {}
local RUNER_DATA_FILE = "runer.json"
local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
local notificationCenter = CCNotificationCenter:sharedNotificationCenter()

--Z轴偏移量
local RUNER_Z_ORDER = 1
--区分
local RUNER_TAG = 11
--帧缓冲
--通知信息
local message = {
    JUMP = RunerDef.RUNER_STATUS.STATUS_JUMP_UP,
    SQUAT = RunerDef.RUNER_STATUS.STATUS_CROUCH
}

local function initSkin(armture_ , skinName, skinArrayNum , boneName)
    for i = 1,skinArrayNum  do
    	local skinName = skinName..i..".png"
    	local skin = CCSkin:create(skinName)
        armture_:getBone(boneName):addDisplay(skin, i - 1)
     end   
end

Runer.allRunerData = {}
--人物创建
function Runer:create( name )
	local _runer = {}
	_runer._id = ""
	_runer._name = ""
	_runer._type = ""
	_runer._runerStatu = ""
	_runer._sprite = nil
	_runer._velocity = 0
	_runer._loc = {
		x = 0,
		y = 0
	}
	_runer._icon = ""
	self.allRunerData = FileManager:readJsonFileToTable(RUNER_DATA_FILE)

	if nil == self.allRunerData then
		log:Debug("Runer:create:数据取得失败")
		return nil
	end
	local createdRuner = self.allRunerData[name]

	if nil == createdRuner then
		log:Debug("Runer:create:该角色不存在")
		return nil
	end

	--loadArm data
	local filenamePng = 
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("res/arm/"..createdRuner.icon..".png","res/arm/"..createdRuner.icon..".plist","res/arm/"..createdRuner.icon..".ExportJson")
	local armature = CCArmature:create(createdRuner.icon)
	_runer._sprite = armature 
    _runer._sprite:getAnimation():play(createdRuner.action)
    _runer._status = RunerDef.RUNER_STATUS[createdRuner.status]
	_runer._id = createdRuner.id
	_runer._name = createdRuner.name
	_runer._type = createdRuner.type
	_runer._loc.x = createdRuner.locX
	_runer._loc.y = createdRuner.locY
	_runer._sprite:setPosition(_runer._loc.x,_runer._loc.y)
	_runer._velocity = 0

	initSkin(_runer._sprite,createdRuner.frame_star,createdRuner.frame_num,createdRuner.boneName)

    local index = 1
    function changeFrame(dt)
        index = index + 1
        if index > createdRuner.frame_num - 1 then
            index = 1
        end
        --print("changeFrame changeFrame is "..index)
        _runer._sprite:getBone(createdRuner.boneName):changeDisplayWithIndex(index, ture)
    end 

    local scheduler = CCDirector:sharedDirector():getScheduler()
    scheduler:scheduleScriptFunc(changeFrame, 0.1, false)
    function _runer:run()
    	if RunerDef.RUNER_STATUS.STATUS_NORMAL == self._status then
            self:normalLogic()
    	elseif RunerDef.RUNER_STATUS.STATUS_JUMP_UP == self._status then
            self:jumpLogic()
        elseif RunerDef.RUNER_STATUS.STATUS_DROP_DOWN == self._status then
            self:dropLogic()
    	elseif RunerDef.RUNER_STATUS._STATUS_SQUAT == self._status then
    		
    	end
    end
    function _runer:jumpLogic()
        local runerSprite = self._sprite
    	self._velocity = self._velocity + RunerDef.ACCELERATION_VALUE.ACCELERATION_G
        local runerSpriteLocY = runerSprite:getPositionY()
        runerSprite:setPositionY(runerSpriteLocY + self._velocity)
    end
    function _runer:dropLogic()
        local runerSprite = self._sprite
        self._velocity = self._velocity + RunerDef.ACCELERATION_VALUE.ACCELERATION_G
        local runerSpriteLocY = runerSprite:getPositionY()
        runerSprite:setPositionY(runerSpriteLocY + self._velocity)
    end
    function _runer:squatLogic()

    end
    function _runer:normalLogic()
        local runerSprite = self._sprite
        runerSprite:setPositionY(self._loc.y)
        print(self._loc.y)
    end
    function _runer:changeStatus(status)
    	if RunerDef.RUNER_STATUS.STATUS_NORMAL == status then
            self._velocity = 0
        elseif RunerDef.RUNER_STATUS.STATUS_DROP_DOWN == status then
            
    	elseif RunerDef.RUNER_STATUS.STATUS_JUMP_UP == status then
            self._velocity = RunerDef.ACCELERATION_VALUE.ACCELERATION_UP
    	elseif RunerDef.RUNER_STATUS._STATUS_SQUAT == status then
    		
    	end
    	self._status = status
    end
    function getMessage(obj)
        _runer:changeStatus(message[obj])
        --notificationCenter:unregisterScriptObserver(_runer._sprite, obj)
    end
    
    notificationCenter:registerScriptObserver(_runer._sprite, getMessage, "JUMP")
    notificationCenter:registerScriptObserver(_runer._sprite, getMessage, "SQUAT")
	return _runer
end

return Runer
