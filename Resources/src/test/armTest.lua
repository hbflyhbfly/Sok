
function cretateArmTestLayer()
	local visible_size = CCDirector:sharedDirector():getVisibleSize()
    local origin = CCDirector:sharedDirector():getVisibleOrigin()
    local arm_layer = CCLayer:create()

    local armature = CCArmature:create("ani_1001_bone")
    armature:setPosition(300,400)

    arm_layer:addChild(armature,2,2)

    local ACTION_COUNT = 10

    local function changeArmAction(fileName, x, y)    
        armature:setPosition(x, y)
        armature:getAnimation():play(fileName)
    end

    local index = 1
    local function changeCallback()
        index = index + 1
        if index >ACTION_COUNT then
            index = 1
        end
        changeArmAction(index, 100, 100)
        currentAction = index
    end

    local changeMenuItem = CCMenuItemImage:create("res/texture/Icon.png", "res/texture/Icon.png")
    changeMenuItem:registerScriptTapHandler(changeCallback)
    changeMenuItem:setPosition(400, 300)
    
    local changeMenu = CCMenu:create()
    changeMenu:setPosition(0, 0)
    changeMenu:addChild(changeMenuItem)
    arm_layer:addChild(changeMenu)


    return arm_layer
end