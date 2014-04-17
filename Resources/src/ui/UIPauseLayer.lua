
-- require "src/logic/IPauseDelegate.lua"
--继承IPauseDelegate接口
-- UIPauseLayer = IPauseDelegate:new()
UIPauseLayer = {}

function UIPauseLayer:createPauseLayer()
	local pause_layer = CCLayer:create()

	local function initTexture()
		--load texture
	end 

	local function initUI()
		-- load ui : button ,sprite

	end
	
	initTexture()	

	initUI()

	return pause_layer
end

function UIPauseLayer:OnBack(self)

end

function UIPauseLayer:onContinueGame(self)

end

function UIPauseLayer:init()
	-- body
end

UIPauseLayer.create = function(self)
	local o = createPauseLayer() 
    return o; 
end

return UIPauseLayer