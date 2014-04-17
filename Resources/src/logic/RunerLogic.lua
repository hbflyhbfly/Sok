require "src/constdef/RunerDef"
local ROLE = require "src/basestruct/ROLE"
local log = require "src/util/log"
local FileManager = require "src/util/FileManager"
local RUNER_DATA_FILE = "runer.json"

local RunerLogic = {}

RunerLogic.allRunerData = {}
--人物创建
function RunerLogic:create( name )
    
	_runer = ROLE

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
    _runer._status = RunerDef.RUNER_STATUS[createdRuner.status]
	_runer._id = createdRuner.id
	_runer._name = createdRuner.name
	_runer._type = createdRuner.type
	_runer._loc._x = createdRuner.locX
	_runer._loc._y = createdRuner.locY
	_runer._velocity = 0
	_runer._ground = 0
	_runer._action = createdRuner.action
    _runer._icon = createdRuner.icon
    _runer._frame_star = createdRuner.frame_star
    _runer._frame_num = createdRuner.frame_num
    _runer._boneName = createdRuner.boneName

    function _runer:update()
    	if RunerDef.RUNER_STATUS.STATUS_NORMAL == self._status then
            self:normalLogic()
    	elseif RunerDef.RUNER_STATUS.STATUS_JUMP_UP == self._status then
            self:jumpLogic()
        elseif RunerDef.RUNER_STATUS.STATUS_DROP_DOWN == self._status then
            self:dropLogic()
    	elseif RunerDef.RUNER_STATUS._STATUS_SQUAT == self._status then
    		
    	end
    end
    --跳跃
    function _runer:jumpLogic()
        self._loc._y = self._loc._y + self._velocity
    	self._velocity = self._velocity + RunerDef.ACCELERATION_VALUE.ACCELERATION_G
        if self._velocity <= 0 then
            self:changeStatus(RunerDef.RUNER_STATUS.STATUS_DROP_DOWN)
        end
    end
    --自由落体
    function _runer:dropLogic()
        self._loc._y = self._loc._y + self._velocity
        self._velocity = self._velocity + RunerDef.ACCELERATION_VALUE.ACCELERATION_G
        if self._loc._y <= self._ground then
            self:changeStatus(RunerDef.RUNER_STATUS.STATUS_NORMAL)
        end
    end
    --蹲下
    function _runer:squatLogic()
        
    end
    --跑动
    function _runer:normalLogic()
        self._loc._y = self._loc._y + self._velocity
        self._velocity = self._velocity + RunerDef.ACCELERATION_VALUE.ACCELERATION_G
        if self._loc._y <= self._ground then
        	self._loc._y = self._ground
        end
    end
    --人物移动状态
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
    --取得人物状态
    function _runer:getStatus()
        return self._status
    end
	return _runer
end

return RunerLogic
