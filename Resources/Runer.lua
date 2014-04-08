
require "header"

local Runer = {}
-- 人物状态
local STATU_TABLE = {  
    RUNER_NORMAL_RUN = 0,  
    RUNER_JUMP_UP = 1,
    RUNER_JUMP_DOWN = 2,
    RUNER_CROUCH = 3
}
--生成状态的静态变量
Runer.RUNER_STATU = newConst(STATU_TABLE)

--重力加速度
local ACCELERATION_TABLE = {
	ACCELERATION_G = 0.9,
    ACCELERATION_UP = 9
}
--生成状态的静态变量
local ACCELERATION_VALUE = newConst(ACCELERATION_TABLE)
--Z轴偏移量
local RUNER_Z_ORDER = 1
--区分
local RUNER_TAG = 1
--帧缓冲
local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
function Runer:createRunerLayer()
	local _layer = CCLayer:create()

	local runer = self:createRuner("loading_01",0,self.RUNER_STATU.RUNER_NORMAL_RUN)
	_layer:addChild(runer._runerSprite,RUNER_Z_ORDER,RUNER_TAG)
	function Runer:reSetRuner()
	-- body
		_layer:removeChildByTag(RUNER_TAG)
		local runer = self:createRuner("loading_01",0,self.RUNER_STATU.RUNER_NORMAL_RUN)
		_layer:addChild(runer._runerSprite,RUNER_Z_ORDER,RUNER_TAG)
	end
	function _layer:runerJump()
		if runer:getRunerStatu() ~= Runer.RUNER_STATU.RUNER_JUMP_UP then
            self:changeRunerStatu(Runer.RUNER_STATU.RUNER_JUMP_UP)   
        end

	end
		function _layer:runerCrouch()
		if runer:getRunerStatu() ~= Runer.RUNER_STATU.RUNER_JUMP_UP and
		runer:getRunerStatu() ~= Runer.RUNER_STATU.RUNER_CROUCH then
            self:changeRunerStatu(Runer.RUNER_STATU.RUNER_JUMP_UP)   
        end
	end
	function _layer:changeRunerStatu(statu)
		-- body
		if statu == Runer.RUNER_STATU.RUNER_JUMP_UP then
			self:setVelocity(ACCELERATION_VALUE.ACCELERATION_UP)
		elseif statu == Runer.RUNER_STATU.RUNER_JUMP_DOWN then
			self:setVelocity(0)
		elseif statu == Runer.RUNER_STATU.RUNER_NORMAL_RUN then
			self:setVelocity(0)
		elseif statu == Runer.RUNER_STATU.RUNER_CROUCH then
			self:setVelocity(0)
		end
		runer._runerStatu = statu
		self:changeAnimate(statu.."animate")
		--todo 人物动画更新
		print(statu)
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
		print("action :"..animateName)
	end
	function _layer:runerJumpUpLogic()
		-- body
		--print(self:getVelocity())
		local locY = self:getRuner():getPositionY()
		locY = locY + self:getVelocity()
		self:getRuner():setPositionY(locY)
		self:setVelocity(self:getVelocity() - ACCELERATION_VALUE.ACCELERATION_G)
		if self:getVelocity() <= 0 then
			self:changeRunerStatu(Runer.RUNER_STATU.RUNER_JUMP_DOWN)
		end
	end
	function _layer:runerJumpDownLogic()
		-- body
		local locY = self:getRuner():getPositionY()
		locY = locY + self:getVelocity()
		self:getRuner():setPositionY(locY)
		self:setVelocity(self:getVelocity() - ACCELERATION_VALUE.ACCELERATION_G)
		if locY <= 200 then
			self:getRuner():setPositionY(200)
			self:changeRunerStatu(Runer.RUNER_STATU.RUNER_NORMAL_RUN)
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
		if self:getRunerStatu() == Runer.RUNER_STATU.RUNER_JUMP_UP then
			self:runerJumpUpLogic()
		elseif self:getRunerStatu() == Runer.RUNER_STATU.RUNER_JUMP_DOWN then
			self:runerJumpDownLogic()
		elseif self:getRunerStatu() == Runer.RUNER_STATU.RUNER_NORMAL_RUN then
			self:runerNormalRunLogic()
		elseif self:getRunerStatu() == Runer.RUNER_STATU.RUNER_CROUCH then
			self:runerCrouchLogic()
		end
	end
	return _layer
end

--人物创建
function Runer:createRuner( name,vel,statu )
	local runer = {}
	runer._runerStatu = statu
	runer._runerSprite = CCSprite:createWithSpriteFrame(cache:spriteFrameByName(name..".png"))
	runer._velocity = vel
	local actionFrames = CCArray:create()
	for i=1,12 do
		actionFrames:addObject(cache:spriteFrameByName(string.format("loading_%02d.png",i)))
	end

	local _animation = CCAnimation:createWithSpriteFrames(actionFrames,0.05)
	local  _animate = CCAnimate:create(_animation)
	runer._runerSprite:runAction(CCRepeatForever:create(_animate))
	runer._runerSprite:setScale(0.5)
	runer._runerSprite:setPosition(ccp(200,200))
	return runer
end

return Runer
