require "src/constdef/BaseSceneDef"
local base_util = require "src/util/BaseUtil.lua"

--这里场景必须唯一不然会出问题
--这个可以视为类名
MainScene = {}


local _visible_size = CCDirector:sharedDirector():getVisibleSize()
local _scheduler = CCDirector:sharedDirector():getScheduler()
MainScene._game_scene = {}
local function MainScene:createMainScene()
	--这些变量可以视为类内成员变量
	self._game_scene = CCScene:create()
	--ui
	_game_layer = CCLayer:create()
	self._game_scene:addChild(_game_layer)
	function _game_layer:init()
		-- init
		self:registerScriptTouchHandler(game_layer.onTouch)
    	self:setTouchEnabled(true)
	end

    --handing touch events
    local touch_begin_point = nil
    --场景初始化
    function _game_layer:onTouchBegan(x, y)
		log.Debugf("GameScene onTouchBegan: %0.2f, %0.2f",x,y);
        touch_begin_point = {x = x, y = y}
        return true
    end

    function _game_layer:onTouchMoved(x, y)
        log.Debugf("GameScene onTouchMoved: %0.2f, %0.2f", x, y)
        if touch_begin_point then
            local cx, cy = game_layer:getPosition()
        end
    end

    function _game_layer:onTouchEnded(x, y)
        log.Debugf("GameScene onTouchEnded: %0.2f, %0.2f", x, y)
        touch_begin_point = nil
    end

    function _game_layer.onTouch(event_type, x, y)
        if event_type == "began" then   
            return self:onTouchBegan(x, y)
        elseif event_type == "moved" then
            return self:onTouchMoved(x, y)
        else
            return self:onTouchEnded(x, y)
        end
    end

    function _game_layer.update(dt)

    end

    _game_layer:init()
    return self._game_scene
end

MainScene.create = function(self) 
    local o = createGameScene() 
    return o; 
end

return MainScene