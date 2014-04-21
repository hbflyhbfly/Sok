require "src/constdef/BaseSceneDef"
local base_util = require "src/util/BaseUtil.lua"

--这里场景必须唯一不然会出问题
--这个可以视为类名
GamenOverScene = {}


local _visible_size = CCDirector:sharedDirector():getVisibleSize()
local _scheduler = CCDirector:sharedDirector():getScheduler()
GamenOverScene._game_scene = {}
function GamenOverScene:createGameOverScene()
	self._game_scene = CCScene:create()
	_game_layer = CCLayer:create()
	self._game_scene:addChild(_game_layer)
	function _game_layer:init()

        -- local label = CCLabelBMFont:create("GameOver")
        -- self:addChild(label)
        -- label:setPosition( ccp(10,300) )
	end

    _game_layer:init()
    return self._game_scene
end

GamenOverScene.create = function(self) 
    local o = self:createGameOverScene() 
    return o; 
end

return GamenOverScene