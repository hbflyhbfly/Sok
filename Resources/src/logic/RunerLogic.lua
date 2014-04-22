require "src/constdef/RunerDef"
local ROLE = require "src/basestruct/ROLE"
local log = require "src/util/log"
local FileManager = require "src/util/FileManager"
local RUNER_DATA_FILE = "runer.json"

local RunerLogic = {}

RunerLogic.allRunerData = {}
--人物创建
function RunerLogic:create( name )
    local createdRuner = {}
	self.allRunerData = FileManager:readJsonFileToTable(RUNER_DATA_FILE)

	if nil == self.allRunerData then
		log:Debug("Runer:create:数据取得失败")
		return nil
	end
	createdRuner = self.allRunerData[name]
	if nil == createdRuner then
		log:Debug("Runer:create:该角色不存在")
		return nil
	end

    function createdRuner:update(dt)
    	self:runerLogic(dt)
    end
    --人物位移
    function createdRuner:runerLogic(dt)
        self.locY = self.locY + self.velocityY
        self.locX = self.locX + self.velocity
        self.velocityY = self.velocityY + RunerDef.ACCELERATION_VALUE.ACCELERATION_G
        if RunerDef.RUNER_STATUS.STATUS_JUMP_UP == self.status then
            if self.velocityY <= 0 then
                self:changeStatus(RunerDef.RUNER_STATUS.STATUS_DROP_DOWN)
            end
        elseif RunerDef.RUNER_STATUS.STATUS_DROP_DOWN == self.status then
            if self.locY < self.ground then
                self:changeStatus(RunerDef.RUNER_STATUS.STATUS_RUN)
            end
        elseif RunerDef.RUNER_STATUS.STATUS_RUN == self.status then
            if self.locY < self.ground then
                self.locY = self.ground
            end
        end

    end

    --人物移动状态
    function createdRuner:changeStatus(status)
        if status ~= self.status then
        	if RunerDef.RUNER_STATUS.STATUS_DROP_DOWN == status then
                
        	elseif RunerDef.RUNER_STATUS.STATUS_JUMP_UP == status then
                self.velocityY = RunerDef.ACCELERATION_VALUE.ACCELERATION_UP
                self.nextAction = RunerDef.ACTION_TYPE.JUMP1
            elseif RunerDef.RUNER_STATUS.STATUS_RUN == status then
                self.velocityY = 0
                self.nextAction = RunerDef.ACTION_TYPE.RUN1
        	end
        	self.status = status
        end
    end
    --取得人物状态
    function createdRuner:getStatus()
        return self.status
    end
	return createdRuner
end

return RunerLogic
