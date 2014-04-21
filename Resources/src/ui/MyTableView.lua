require "extern"
-- require "src/constdef/BaseSceneDef"
--require "VisibleRect"

local TableViewTestLayer = class("TableViewTestLayer")
TableViewTestLayer.__index = TableViewTestLayer

local tableView = nil

local page = 1
local getOffsetDidScrollX = 0
local getOffsetTouchX = 0
local isTouchBegan = true
local isSetPage = false

local winSize = CCDirector:sharedDirector():getWinSize()

function TableViewTestLayer.extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, TableViewTestLayer)
    return target
end

-- function TableViewTestLayer:onTouchBegan(x, y)
--         -- log.Debugf("MyTableView onTouchBegan: %0.2f, %0.2f",x,y);
--         -- touch_begin_point = {x = x, y = y}
--         -- DataCenter:notifyObservers(DataConstDef.EVENT_MSG_TYPE.EM_SECOND_MSG_TYPE, 100, 111)
--         -- CCTOUCHBEGAN event must return true
--         print("MyTableView onTouchBegan: %0.2f, %0.2f",x,y)
--         return true
--     end

-- function TableViewTestLayer:onTouchMoved(x, y)
--     print("MyTableView onTouchMoved: %0.2f, %0.2f",x,y)
-- end

-- function TableViewTestLayer.onTouchEnded(x, y)
--     print("MyTableView fdfddffonTouchEnded")
-- end

-- --这里没有:是因为回调的时候只能用.没法传self
-- function TableViewTestLayer.onTouch(event_type, x, y)
--     if event_type == "began" then   
--         return TableViewTestLayer:onTouchBegan(x, y)
--     elseif event_type == "moved" then
--         return TableViewTestLayer:onTouchMoved(x, y)
--     else
--         return TableViewTestLayer:onTouchEnded(x, y)
--     end
-- end


function TableViewTestLayer.scrollViewDidScroll(view)
    -- print("scrollViewDidScroll-------"..tableView:getContentOffset().x)
    if isTouchBegan then
        getOffsetDidScrollX = tableView:getContentOffset().x
        isTouchBegan = false
        isSetPage =false
    end
    -- if isSetPage then 
    --     tableView:setContentOffset(CCPointMake(0,0),true)
    -- end
end

function TableViewTestLayer.scrollViewDidZoom(view)
    print("scrollViewDidZoom")
end

function TableViewTestLayer.tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
    print(tostring(cell))
    print("\n" .. tableView:getContentOffset().x .. "--------------------TableViewTestLayer.tableCellTOuched") 
    -- local tempValue = tableView:getContentOffset().x - getOffsetDidScrollX
    -- if math.abs(tempValue) > 100 then
    --     if tempValue > 0 then
    --         print("iiiiiiiiiiiiiiiiiiiii")
    --         TableViewTestLayer:setPage(false)
    --     else
    --         print("444444444444444444444444444444")
    --         TableViewTestLayer:setPage(true)
    --     end
    -- isTouchBegan = true
    -- else
    --     TableViewTestLayer:setPageOffSet(page)
    -- end
    -- tableView:setContentOffsetInDuration(CCPointMake(0,0),0.5)
    -- isSetPage = true
end

function TableViewTestLayer:setPage(isAddPage)
   if isAddPage then 
        page = page + 1
   else
        page = page - 1 
   end

   if page < 1 then
        page = 1
   elseif page > 12 then
        page = 12
   end
   print("$$$$$$$64646 ------------" .. page)
   TableViewTestLayer:setPageOffSet(page)
end

function TableViewTestLayer:setPageOffSet(page)
    -- CCScrollView *scroll = CCScrollView::create();
    -- scroll->setContentOffset(CCPointMake(0, 0),true);
    tableView:setContentOffsetInDuration(CCPointMake(winSize.width*(page - 1),0),0.5)
    print("getContentOffset.x-------" .. tableView:getContentOffset().x)
end

function TableViewTestLayer.cellSizeForTable(table,idx) 
    return winSize.height,winSize.width
end

function TableViewTestLayer.tableCellAtIndex(table, idx)
    local strValue = string.format("%d",idx)
    local cell = table:dequeueCell()
    local label = nil
    if nil == cell then
        cell = CCTableViewCell:new()
        local main_bg = CCSprite:create("Default@2x.png")
        main_bg:setAnchorPoint(CCPointMake(0.5,0.5))
        main_bg:setPosition(CCPointMake(winSize.width/2, winSize.height/2))
        cell:addChild(main_bg,0)

        local bg = CCSprite:create("dog.png")
        bg:setAnchorPoint(CCPointMake(0.5,0.5))
        bg:setPosition(CCPointMake(winSize.width/2, winSize.height/2))
        cell:addChild(bg,1)

        local sprite = CCSprite:create("Icon-72.png")
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

function TableViewTestLayer.numberOfCellsInTableView(table)
   return 12
end

function TableViewTestLayer:init()
    print("TableViewTestLayer mehode began")
    tableView = CCTableView:create(CCSizeMake(winSize.width, winSize.height))
    tableView:setDirection(kCCScrollViewDirectionHorizontal)
    tableView:setAnchorPoint(CCPointMake(0,0))
    tableView:setPosition(CCPointMake(0, 0))
    -- tableView:setVerticalFillOrder(kCCTableViewFillTopDown)
    self:addChild(tableView)
    tableView:registerScriptHandler(TableViewTestLayer.scrollViewDidScroll,CCTableView.kTableViewScroll)
    --tableView:registerScriptHandler(TableViewTestLayer.scrollViewDidZoom,CCTableView.kTableViewZoom)
    tableView:registerScriptHandler(TableViewTestLayer.tableCellTouched,CCTableView.kTableCellTouched)
    tableView:registerScriptHandler(TableViewTestLayer.cellSizeForTable,CCTableView.kTableCellSizeForIndex)
    tableView:registerScriptHandler(TableViewTestLayer.tableCellAtIndex,CCTableView.kTableCellSizeAtIndex)
    tableView:registerScriptHandler(TableViewTestLayer.numberOfCellsInTableView,CCTableView.kNumberOfCellsInTableView)
    -- tableView:registerScriptHandler(TableViewTestLayer.onTouchEnded,CCTableView.kTableCellTouchEnded)
    -- tableView:relocateContainer(true)
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

function runTableView()
    -- local newScene = CCScene:create()
    local newLayer = TableViewTestLayer.create()
    -- newScene:addChild(newLayer)
    -- return newScene
    return newLayer
end