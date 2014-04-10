local Weather = {}
local visibleSize = CCDirector:sharedDirector():getWinSize()
local textureCache = CCTextureCache:sharedTextureCache()

function Weather:getBaseLayer()
	-- body
	textureCache:addImage("ccbParticleSnow.png")
	local layer = CCLayerColor:create(ccc4(255,255,255,255))
	layer:setOpacity(0)
	return layer
end

function Weather:createWeatherLayer()
	-- body
	local layer = self:getBaseLayer()
	emitter = CCParticleSnow:create()
	layer:addChild(emitter,10)
	emitter:setLife(8)
	emitter:setLifeVar(1)
	emitter:setGravity(ccp(-15,-10))
	emitter:setSpeed(60)
	emitter:setSpeedVar(5)
	emitter:setTotalParticles(300)
	local startColor = emitter:getStartColor()
	emitter:setEmissionRate(emitter:getTotalParticles()/emitter:getLife())
	emitter:setTexture(textureCache:textureForKey("ccbParticleSnow.png"))
	return layer
end
return Weather