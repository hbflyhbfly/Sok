-- unTableView code begin ==================================================================================================
require "src/constdef/BaseSceneDef"
-- unTableView code end ==================================================================================================
require "extern"
-- local GameScene = require "src/scene/GameScene"

local CHCEK_POINT_TOTAL_DATA = 0
local MAIN_CP_DATA = 1
local SUB_CP_DATA = 2
-- unTableView code begin ==================================================================================================
local MainCpLayer = class("MainCpLayer")
MainCpLayer.__index = MainCpLayer

MainCpLayer[MAIN_CP_DATA] = {}
MainCpLayer[SUB_CP_DATA] = {}

-- local MainCpLayer._checkPointData = {}
-- local MainCpLayer._mainCpData = {}
-- local MainCpLayer._subCpData = {}
-- unTableView code end ==================================================================================================
local cellNumber = 1
local winSize = CCDirector:sharedDirector():getWinSize()

function MainCpLayer.extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, MainCpLayer)
    return target
end


function MainCpLayer.scrollViewDidScroll(view)
 --    if isTouchBegan then
 --        getOffsetDidScrollX = tableView:getContentOffset().x
 --        isTouchBegan = false
 --        isSetPage =false
	-- end
end

function MainCpLayer.tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
    local level = cell:getIdx() + 1
    scene_game22 = GameScene:create(level)
    -- scene_game:createGameScene(level)
    CCDirector:sharedDirector():replaceScene(scene_game22)
end

function MainCpLayer.cellSizeForTable(table,idx) 
    return winSize.height,winSize.width
end

function MainCpLayer.tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local label = nil
    if nil == cell then
        cell = CCTableViewCell:new()
        -- local main_bg = CCSprite:create("Default@2x.png")
        -- main_bg:setAnchorPoint(CCPointMake(0.5,0.5))
        -- main_bg:setPosition(CCPointMake(winSize.width/2, winSize.height/2))
        -- cell:addChild(main_bg,0)

        local bg = CCSprite:create("res/texture/shop_hotsale_bg.png")
        bg:setAnchorPoint(CCPointMake(0.5,0.5))
        bg:setPosition(CCPointMake(winSize.width/2, winSize.height/2))
        cell:addChild(bg,1)

        local sprite = CCSprite:create("res/texture/Icon.png")
        -- sprite:setAnchorPoint(CCPointMake(0.5,0.5))
        -- sprite:setPosition(ccp(bg->getPositionX(),bg->getPositionY())
        sprite:setAnchorPoint(CCPointMake(0.5,0.5))
        sprite:setPosition(CCPointMake(bg:getPositionX(),bg:getPositionY()))
        cell:addChild(sprite,2)

        label = CCLabelTTF:create(strValue, "Helvetica", 20.0)
        label:setPosition(CCPointMake(0,0))
        label:setAnchorPoint(CCPointMake(0,0))
        label:setTag(123)
        cell:addChild(label,3)

    else
        label = tolua.cast(cell:getChildByTag(123),"CCLabelTTF")
        if nil ~= label then
            label:setString(strValue)
        end
    end

    return cell
end

function MainCpLayer.numberOfCellsInTableView(table)
   --print("MainCpLayer.numberOfCellsInTableView --------- cellNumber=====" .. cellNumber)
   return cellNumber
end

function MainCpLayer:init()
	print("-------------this is method MainCpLayer:init() =================")
    tableView = CCTableView:create(CCSizeMake(winSize.width, winSize.height))
    tableView:setDirection(kCCScrollViewDirectionHorizontal)
    tableView:setAnchorPoint(CCPointMake(0,0))
    tableView:setPosition(CCPointMake(0, 0))
    self:addChild(tableView)
    tableView:registerScriptHandler(MainCpLayer.scrollViewDidScroll,CCTableView.kTableViewScroll)
    tableView:registerScriptHandler(MainCpLayer.tableCellTouched,CCTableView.kTableCellTouched)
    tableView:registerScriptHandler(MainCpLayer.cellSizeForTable,CCTableView.kTableCellSizeForIndex)
    tableView:registerScriptHandler(MainCpLayer.tableCellAtIndex,CCTableView.kTableCellSizeAtIndex)
    tableView:registerScriptHandler(MainCpLayer.numberOfCellsInTableView,CCTableView.kNumberOfCellsInTableView)
    tableView:reloadData()
    return true
end

function MainCpLayer:create(table)
    local layer = MainCpLayer.extend(CCLayer:create())
    if nil ~= layer then
        
        MainCpLayer[MAIN_CP_DATA] = table 
        local mainCpData = MainCpLayer[MAIN_CP_DATA]
        cellNumber = #mainCpData
        for i=1,cellNumber do
        	--print(mainCpData[i])
        end
        layer:init()
    end
    return layer
end
return MainCpLayer
-- unTableView code end ==================================================================================================