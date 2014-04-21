local log = require "src/util/log"
require "src/ui/ViewGameScene"
require "src/ui/UILoginLayer"
local UIManager = require "src/ui/UIManager"
local LuaWebSocket = require "src/test/LuaWebSocket"
--这个可以视为类名
local GameViewLayer = {}

--这些变量可以视为类内成员变量
local _visible_size = CCDirector:sharedDirector():getVisibleSize()
local _origin = CCDirector:sharedDirector():getVisibleOrigin()

local function createGameViewLayer()
	local game_view_layer = CCLayer:create()
	--handing touch events
    local touch_begin_point = nil

    local view_game_scene = nil

    --是否吞噬这一层
    game_view_layer.swallow = false

    local function init()   
    	view_game_scene = ViewGameScene:create()
        UIManager:AddLayer(game_view_layer,"game_layer",view_game_scene,1000)
        UIManager:RegisterUpdate("game_layer")
     
        -- view_game_scene =UILoginLayer:create()
        -- game_view_layer:addChild(view_game_scene)
        -- UIManager:AddLayer(game_view_layer,"game_layer",view_game_scene,1000)
        -- UIManager:RegisterUpdate("game_layer")
        --网络
        --local a = LuaWebSocket:send()
    end

    function game_view_layer:onTouchBegan(x, y)
    	log.Debugf("GameViewLayer onTouchBegan: %0.2f, %0.2f",x,y);
    	touch_begin_point = {x = x, y = y}
    	-- CCTOUCHBEGAN event must return true
        return self.swallow
    end

    function game_view_layer:onTouchMoved(x, y)
        log.Debugf("GameScene onTouchMoved: %0.2f, %0.2f", x, y)
    end

    function game_view_layer:onTouchEnded(x, y)
    	log.Debugf("GameViewLayer onTouchEnded: %0.2f, %0.2f",x,y);
    	touch_begin_point = nil
    end

	--这里没有:是因为回调的时候只能用.没法传self
    function game_view_layer.onTouch(event_type, x, y)
        if event_type == "began" then   
            return game_view_layer:onTouchBegan(x, y)
        elseif event_type == "moved" then
            return game_view_layer:onTouchMoved(x, y)
        else
            return game_view_layer:onTouchEnded(x, y)
        end
    end

    function game_view_layer:update(dt)
        --log.Info("game_view_layer update" .. dt)
        UIManager:Update(dt)
    end

    init()

	game_view_layer:registerScriptTouchHandler(game_view_layer.onTouch,false,0 - BaseSceneDef.LAYER_TYPE.LAYER_TYPE_MENU,true)
    game_view_layer:setTouchEnabled(true)

    return game_view_layer
end


GameViewLayer.create = function(self) 
    local o = createGameViewLayer() 
    return o; 
end

return GameViewLayer