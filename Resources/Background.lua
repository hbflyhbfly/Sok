require "header"
local Background = {}
local scheduler = CCDirector:sharedDirector():getScheduler()
local textureCache = CCTextureCache:sharedTextureCache()
local spriteCache = CCSpriteFrameCache:sharedSpriteFrameCache();
local _visibleSize = CCDirector:sharedDirector():getWinSize()


local SPEED_TABLE = 
    {  
        BACKGROUND_SPEED1 = 5,  
        BACKGROUND_SPEED2 = 10,
        BACKGROUND_SPEED3 = 15
    }  
local CONST = newConst(SPEED_TABLE)


function Background:createBackgroundLayer()
	local _backGroundLayer = CCLayer:create()

	function initContent( )
		--local bgObject = CCSprite:createWithTexture(textureCache:textureForKey("move_mg_2.png"))
		createbgObject("texture/move_mg_2.png","texture/move_mg_2.png",CONST.BACKGROUND_SPEED1,_visibleSize.height)
		createbgObject("texture/move_mg_1.png","texture/move_mg_1.png",CONST.BACKGROUND_SPEED1,_visibleSize.height*0.7)
		createbgObject("texture/move_mg_3.png","texture/move_mg_4.png",CONST.BACKGROUND_SPEED3,_visibleSize.height*0.65)

		-- local _ground = CCSprite:createWithSpriteFrame(spriteCache:spriteFrameByName("ground.png"))
		--      	local groundSize = _ground:boundingBox().size
		--      	_ground:setAnchorPoint(ccp(0,0))
		--      	_ground:setScale(_visibleSize.width/groundSize.width)
		--      	_ground:setPosition(ccp(0,200-groundSize.height))
		--     	_backGroundLayer:addChild(_ground)
	end
     
    function updatebackGround(node)
    	if node:getPositionX() <= -_visibleSize.width then
    		node:setPositionX(_visibleSize.width)
    	end
    end
    function createbgObject( bgObject1,bgObject2,speed,offsetY )
    	-- body
    	if not bgObject1 or not bgObject2 then
    		return
    	end
    	for i=0,1 do
    		local bgObject
    		if i == 0 then
    			bgObject = CCSprite:createWithTexture(textureCache:textureForKey(bgObject1))
    		else
    			bgObject = CCSprite:createWithTexture(textureCache:textureForKey(bgObject2))
    		end
			local bgObjectSize = bgObject:boundingBox().size;
			bgObject:setScaleX(_visibleSize.width/bgObjectSize.width)
			bgObject:setAnchorPoint(ccp(0,1))
			bgObject:setPosition(ccp(_visibleSize.width*i,offsetY))
			local actions = CCArray:create()
    		actions:addObject(CCMoveBy:create(1, ccp(-speed,0)))
    		actions:addObject(CCCallFuncN:create(updatebackGround))
    		bgObject:runAction( CCRepeatForever:create(CCSequence:create(actions)))
			_backGroundLayer:addChild(bgObject)
    	end
    end
    initContent()
	return _backGroundLayer
end

return Background
-- local background = {}

-- gInfo = 10 * 1000


-- function background:create()
-- 	local m = {}
-- 	slef:createInnerClass()

-- 	m.fun( m, param )

-- 	m:fun( param )

-- 	local n = 10

-- 	self.m = m
-- 	self.n = n
-- end

-- function background:removeSelf()
-- 	self.m:removeSelf()
-- 	self.m = nil

-- 	self.n:removeSelf()
-- 	self.n = nil

-- end

-- function background:createInnerClass()
-- 	local innerObj = {}
-- 	function innerObj:create()
-- 		local bg = background
-- 		bg.m.fun()

-- 		self.innerM = {}
-- 	end
-- 	function innerObj:removeSelf()
-- 		-- body
-- 		self.innerM:removeSelf()
-- 	end
-- 	return innerObj
-- end

-- return background

-- local bg = require( "background" )
-- bg:init()
-- bg:removeSelf()

-- local innerClass = bg:createInnerClass()
-- innerClass:init()
-- innerClass:removeSelf()



