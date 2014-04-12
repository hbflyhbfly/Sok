require "extern"
--require "VisibleRect"

local TableViewTestLayer = class("TableViewTestLayer")
TableViewTestLayer.__index = TableViewTestLayer

function TableViewTestLayer.extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, TableViewTestLayer)
    return target
end

function TableViewTestLayer.scrollViewDidScroll(view)
    print("scrollViewDidScroll")
end

function TableViewTestLayer.scrollViewDidZoom(view)
    print("scrollViewDidZoom")
end

function TableViewTestLayer.tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
    print(tostring(cell))
end

function TableViewTestLayer.cellSizeForTable(table,idx) 
    return 151,293
end

function TableViewTestLayer.tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local label = nil
    if nil == cell then
        cell = CCTableViewCell:new()
        local bg = CCSprite:create("res/texture/shop_hotsale_bg.png")
        bg:setAnchorPoint(CCPointMake(0,0))
        bg:setPosition(CCPointMake(0, 0))
        cell:addChild(bg)

        local sprite = CCSprite:create("res/texture/Icon.png")
        -- sprite:setAnchorPoint(CCPointMake(0.5,0.5))
        -- sprite:setPosition(ccp(bg->getPositionX(),bg->getPositionY())
        sprite:setAnchorPoint(CCPointMake(0,0))
        sprite:setPosition(CCPointMake(bg:getPositionX(),bg:getPositionY()))
        cell:addChild(sprite)

    else
        label = tolua.cast(cell:getChildByTag(123),"CCLabelTTF")
        if nil ~= label then
            label:setString(strValue)
        end
    end

    return cell
end

function TableViewTestLayer.numberOfCellsInTableView(table)
   return 25
end

function TableViewTestLayer:init()

    local winSize = CCDirector:sharedDirector():getWinSize()

    tableView = CCTableView:create(CCSizeMake(293, 900))
    tableView:setDirection(kCCScrollViewDirectionVertical)
    tableView:setPosition(CCPointMake(winSize.width - 500, winSize.height / 2 - 500))
    tableView:setVerticalFillOrder(kCCTableViewFillTopDown)
    self:addChild(tableView)
    tableView:registerScriptHandler(TableViewTestLayer.scrollViewDidScroll,CCTableView.kTableViewScroll)
    tableView:registerScriptHandler(TableViewTestLayer.scrollViewDidZoom,CCTableView.kTableViewZoom)
    tableView:registerScriptHandler(TableViewTestLayer.tableCellTouched,CCTableView.kTableCellTouched)
    tableView:registerScriptHandler(TableViewTestLayer.cellSizeForTable,CCTableView.kTableCellSizeForIndex)
    tableView:registerScriptHandler(TableViewTestLayer.tableCellAtIndex,CCTableView.kTableCellSizeAtIndex)
    tableView:registerScriptHandler(TableViewTestLayer.numberOfCellsInTableView,CCTableView.kNumberOfCellsInTableView)
    tableView:reloadData()

    return true
end

function TableViewTestLayer.create()
    local layer = TableViewTestLayer.extend(CCLayer:create())
    if nil ~= layer then
        layer:init()
    end

    return layer
end

function runTableViewTest()
    -- local newScene = CCScene:create()
    local newLayer = TableViewTestLayer.create()
    -- newScene:addChild(newLayer)
    -- return newScene
    return newLayer
end