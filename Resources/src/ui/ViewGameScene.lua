
require "CCBReaderLoad"
local log = require "src/util/log"

OpertaionLayer = OpertaionLayer or {}
ccb["OpertaionLayer"] = OpertaionLayer

local function onJumpClick()
log.Info("this onJumpClick method")
end
local function onPauseClick()
log.Info("this onJumpClick2 method")
end
local function onSquatClick()
log.Info("this onJumpClick3 method")
end

OpertaionLayer["btn_jump"] = onJumpClick
OpertaionLayer["btn_pause"] = onPauseClick
OpertaionLayer["btn_squat"] = onSquatClick

local function HelloCCBTestMainLayer()
log.Info("this is motherfucker")
local  proxy = CCBProxy:create()
local  node  = CCBuilderReaderLoad("res/ccbi/opertaion.ccbi",proxy,OpertaionLayer)
local  layer = tolua.cast(node,"CCLayer")
return layer
end

function runCocosBuilder()
log.Info("HelloCCBSceneTestMain")
local layer = CCLayer:create()
layer:addChild(HelloCCBTestMainLayer())
return layer
end

