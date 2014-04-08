require "AudioEngine"

function cretateArmTestLayer()
	local visible_size = CCDirector:sharedDirector():getVisibleSize()
    local origin = CCDirector:sharedDirector():getVisibleOrigin()
    local arm_layer = CCLayer:create()

    CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("arm/jujian_a0.png","arm/jujian_a0.plist","arm/jujian_a.ExportJson")
    CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("arm/jujian_a1.png","arm/jujian_a1.plist","arm/jujian_a.ExportJson")

 	local armature = CCArmature:create("jujian_a")
    armature:setPosition(300,400)
    arm_layer:addChild(armature,2,2)


	local _actions = {
        {name = "dengdai"},
        {name = "beizhan"},
        {name = "qianjin"},
        {name = "houtui"},
        {name = "ggg"},
        {name = "shoushang"},
        {name = "fukong"},
        {name = "bajian"},
        {name = "si"},
        {name = "gongji_c"},
        {name = "gongji_b"},
        {name = "gongji_a"}
    }
    local currentAction = "dengdai"
    local ACTION_COUNT = table.getn(_actions)

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
        changeArmAction(_actions[index].name, 100, 100)
        currentAction = _actions[index].name
    end

    local changeMenuItem = CCMenuItemImage:create("./Icon-72.png", "./Icon-72.png")
    changeMenuItem:registerScriptTapHandler(changeCallback)
    changeMenuItem:setPosition(400, 100)
    
    local changeMenu = CCMenu:create()
    changeMenu:setPosition(0, 0)
    changeMenu:addChild(changeMenuItem)
    arm_layer:addChild(changeMenu)

    return arm_layer
end