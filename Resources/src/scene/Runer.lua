require "src/constdef/RunerStatus"
local log = require "src/util/log"
local base_util = require "src/util/BaseUtil.lua"

local Runer = {}
--生成状态的静态变量
--人物状态
Runer.ENUM_RUNER_STATUS = base_util:tableReadOnly(RunerStatus.BASE_RUNER_STATUS)
--人物上下运动速度/加速度
Runer.ACCELERATION_VALUE = base_util:tableReadOnly(RunerStatus.ACCELERATION_TABLE)
--Z轴偏移量
local RUNER_Z_ORDER = 1
--区分
local RUNER_TAG = 11
--帧缓冲
local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
function Runer:createRunerLayer()
	local _layer = CCLayer:create()
	local runer = Runer:createRuner("loading_01",0,self.ENUM_RUNER_STATUS.STATUS_NORMAL)
	_layer:addChild(runer._runerSprite,RUNER_Z_ORDER,RUNER_TAG)
	--重置
	function _layer:reSetRuner()
		self:removeChildByTag(RUNER_TAG)
		local runer = Runer:createRuner("loading_01",0,self.ENUM_RUNER_STATUS.STATUS_NORMAL)
		self:addChild(runer._runerSprite,RUNER_Z_ORDER,RUNER_TAG)
	end
	--跳
	function _layer:runerJump()
		if runer:getRunerStatu() ~= Runer.ENUM_RUNER_STATUS.STATUS_JUMP_UP then
            self:changeRunerStatu(Runer.ENUM_RUNER_STATUS.STATUS_JUMP_UP)   
        end

	end
	--蹲
	function _layer:runerCrouch()
		if runer:getRunerStatu() ~= Runer.ENUM_RUNER_STATUS.STATUS_JUMP_UP and
		runer:getRunerStatu() ~= Runer.ENUM_RUNER_STATUS.STATUS_CROUCH then
            self:changeRunerStatu(Runer.ENUM_RUNER_STATUS.STATUS_JUMP_UP)   
        end
	end
	function _layer:changeRunerStatu(statu)
		-- body
		if statu == Runer.ENUM_RUNER_STATUS.STATUS_JUMP_UP then
			self:setVelocity(Runer.ACCELERATION_VALUE.ACCELERATION_UP)
		elseif statu == Runer.ENUM_RUNER_STATUS.STATUS_JUMP_DOWN then
			self:setVelocity(0)
		elseif statu == Runer.ENUM_RUNER_STATUS.STATUS_NORMAL then
			self:setVelocity(0)
		elseif statu == Runer.ENUM_RUNER_STATUS.STATUS_CROUCH then
			self:setVelocity(0)
		end
		runer._runerStatu = statu
		self:changeAnimate(statu.."animate")
		--todo 人物动画更新
	end
	function _layer:getRunerStatu()
		-- body
		return runer._runerStatu
	end
	function _layer:setVelocity( vel )
		runer._velocity = vel
		-- body
	end
	function _layer:getVelocity()
		return runer._velocity
		-- body
	end
	function _layer:getRuner()
		return runer._runerSprite
	end

	function _layer:changeAnimate(animateName)
	-- body
	--_armature:getAnimation():play(animateName)
		--log.Info("action :"..animateName)
	end
	function _layer:runerJumpUpLogic()
		local locY = self:getRuner():getPositionY()
		locY = locY + self:getVelocity()
		self:getRuner():setPositionY(locY)
		self:setVelocity(self:getVelocity() - Runer.ACCELERATION_VALUE.ACCELERATION_G)
		if self:getVelocity() <= 0 then
			self:changeRunerStatu(Runer.ENUM_RUNER_STATUS.STATUS_JUMP_DOWN)
		end
	end
	function _layer:runerJumpDownLogic()
		-- body
		local locY = self:getRuner():getPositionY()
		locY = locY + self:getVelocity()
		self:getRuner():setPositionY(locY)
		self:setVelocity(self:getVelocity() - Runer.ACCELERATION_VALUE.ACCELERATION_G)
		if locY <= 300 then
			self:getRuner():setPositionY(300)
			self:changeRunerStatu(Runer.ENUM_RUNER_STATUS.STATUS_NORMAL)
		end
	end
	function _layer:runerNormalRunLogic()
		-- body
	end
	function _layer:runerCrouchLogic()
		-- body
	end
	function _layer:updateRuner(dt)
		-- body
		if self:getRunerStatu() == Runer.ENUM_RUNER_STATUS.STATUS_JUMP_UP then
			self:runerJumpUpLogic()
		elseif self:getRunerStatu() == Runer.ENUM_RUNER_STATUS.STATUS_JUMP_DOWN then
			self:runerJumpDownLogic()
		elseif self:getRunerStatu() == Runer.ENUM_RUNER_STATUS.STATUS_NORMAL then
			self:runerNormalRunLogic()
		elseif self:getRunerStatu() == Runer.ENUM_RUNER_STATUS.STATUS_CROUCH then
			self:runerCrouchLogic()
		end
	end

	--碰撞检测
	function _layer:checkCollision( collision )
		local runer = self:getChildByTag(RUNER_TAG)
		if nil == collision or nil == runer then
			return false
		end
		local runerRect = runer:boundingBox()
		local collisionSprite = collision.sprite
		local collisionRect = collisionSprite:boundingBox()
		local collisionLoc = collisionSprite:getPosition()
		--left
		if collisionRect:containsPoint(ccp(runerRect:getMinX(),runerRect:getMaxY()/2)) then
			print("left")
			runer:setPositionX(collisionSprite:getPositionX()+collisionRect:getMaxX())
		end
		--right
		if collisionRect:containsPoint(ccp(runerRect:getMaxX(),runerRect:getMaxY()/2)) then
			print("right")

			runer:setPositionX(collisionSprite:getPositionX()-runerRect:getMaxX())
		end
		--up
		if collisionRect:containsPoint(ccp(runerRect:getMaxX()/2,runerRect:getMaxY())) then
			runer:setPositionY(collisionSprite:getPositionY()-runerRect:getMaxY()-collisionRect:getMaxY())
			print("up")
		end
		--bottom
		if collisionRect:containsPoint(ccp(runerRect:getMaxX()/2,runerRect:getMinY())) then
			runer:setPositionY(collisionSprite:getPositionY())
			print("bottom")
		end

		--local collisionSprite
	end
	return _layer
end


local i = 1
local function initSkin(armture_ , skinArray , boneName)
    for i = 1,table.getn(skinArray) do
    	local skin = CCSkin:create(skinArray[i])
        armture_:getBone(boneName):addDisplay(skin, i - 1)
     end   
end

--人物创建
function Runer:createRuner( name,vel,statu )
	local runer = {}

	runer._runerStatu = statu
	runer._runerSprite = CCSprite:createWithSpriteFrame(cache:spriteFrameByName(name..".png"))
	runer._velocity = vel

	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("res/arm/NewAnimation0.png","res/arm/NewAnimation0.plist","res/arm/NewAnimation.ExportJson")
	local armature = CCArmature:create("NewAnimation")
    armature:setPosition(200,300)
    runer._runerSprite = armature

    -- TODO: 初始化时动态传入的角色table
     local head = 
    {
        "res/arm/loading_01.png", 
        "res/arm/loading_02.png", 
        "res/arm/loading_03.png", 
        "res/arm/loading_04.png", 
        "res/arm/loading_05.png", 
        "res/arm/loading_06.png",
        "res/arm/loading_07.png", 
        "res/arm/loading_08.png", 
        "res/arm/loading_09.png",
        "res/arm/loading_10.png",
        "res/arm/loading_11.png",
        "res/arm/loading_12.png"
    }

    initSkin(armature,head,"tou")

    armature:getAnimation():play("Animation2")

    local index = 1
    function changeFrame(dt)
        index = index + 1
        if index > 12 then
            index = 1
        end
        armature:getBone("tou"):changeDisplayWithIndex(index, ture)
    end 

    local scheduler = CCDirector:sharedDirector():getScheduler()
    scheduler:scheduleScriptFunc(changeFrame, 0.1, false)

	return runer
end

return Runer
