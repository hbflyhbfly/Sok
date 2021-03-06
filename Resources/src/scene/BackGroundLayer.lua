require "src/constdef/BaseSceneDef"
--这个可以视为类名
local BackGroundLayer = {}

--这些变量可以视为类内成员变量
local _base_util = require "src/util/BaseUtil.lua"
local _texture_cache = CCTextureCache:sharedTextureCache()
local _visible_size = CCDirector:sharedDirector():getWinSize()

local function createBackgroundLayer()
	local background_layer = CCLayer:create()
     
    local function updatebackGround(node)
        local bg_object_size = node:boundingBox().size;
    	if node:getPositionX() <= -bg_object_size.width then
    		node:setPositionX(bg_object_size.width)
    	end
    end

    local function createbgObject(bg_res1,bg_res2,speed,offset_y)
    	-- body
    	if not bg_res1 or not bg_res2 then
    		return
    	end
    	for i=0,1 do
    		local bg_obj
    		if i == 0 then
    			bg_obj = CCSprite:createWithTexture(_texture_cache:textureForKey(bg_res1))
    		else
    			bg_obj = CCSprite:createWithTexture(_texture_cache:textureForKey(bg_res2))
    		end
			local bg_object_size = bg_obj:boundingBox().size;
			bg_obj:setAnchorPoint(ccp(0,0))
			bg_obj:setPosition(ccp(bg_object_size.width * i,offset_y))
			local actions = CCArray:create()
    		actions:addObject(CCMoveBy:create(1, ccp(-speed , 0)))
    		actions:addObject(CCCallFuncN:create(updatebackGround))
    		bg_obj:runAction(CCRepeatForever:create(CCSequence:create(actions)))
			background_layer:addChild(bg_obj)
    	end
    end

    local function initContent( )
        createbgObject("res/texture/scene_2_bg_002.png","res/texture/scene_2_bg_002.png",0,0)
        createbgObject("res/texture/scene_2_bg_001.png","res/texture/scene_2_bg_001.png",BaseSceneDef.SPEED_TABLE.BACKGROUND_SPEED1,0)
        createbgObject("res/texture/scene_2_bg_007.png","res/texture/scene_2_bg_007.png",BaseSceneDef.SPEED_TABLE.BACKGROUND_SPEED3,_visible_size.height/4)
        createbgObject("res/texture/scene_2_bg_004.png","res/texture/scene_2_bg_004.png",BaseSceneDef.SPEED_TABLE.BACKGROUND_SPEED4,_visible_size.height/20)
        
        createbgObject("res/texture/scene_2_bg_005.png","res/texture/scene_2_bg_005.png",BaseSceneDef.SPEED_TABLE.BACKGROUND_SPEED4,_visible_size.height/30)
        createbgObject("res/texture/scene_2_bg_006.png","res/texture/scene_2_bg_006.png",BaseSceneDef.SPEED_TABLE.BACKGROUND_SPEED5,0)
    end
    
    initContent()
    
	return background_layer
end

BackGroundLayer.create = function(self) 
    local o = createBackgroundLayer() 
    return o; 
end

return BackGroundLayer