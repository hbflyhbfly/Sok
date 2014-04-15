-- local GameViewLayer = require "src/scene/GameViewLayer"
local ViewBase = require "src/ui/UIBase"
local log = require "src/util/log"
local IUIManager = require "src/ui/IUIManager"

local ViewManager = IUIManager:new()
	ViewManager.DestoryList = {}
	ViewManager.ContainerDictionary = {}
	ViewManager.UpdateList = {}

	function ViewManager:ShowLayer(menuName,isVisible)

		local layer = ViewManager.ContainerDictionary[menuName]

		if layer ~= nil then
			
			if layer:isVisible() == isVisible then
				return
			end
			layer:setVisible(isVisible)
		end
	end

	function ViewManager:DestoryLayer(menuName,isCleanUp)

		local layer = ViewManager.ContainerDictionary[menuName]
		local i = 0
		for k,v in pairs(ViewManager.ContainerDictionary) do
			if v == layer then
				break
			end
			i = i + 1
		end
		if i == #ViewManager.DestoryList then
			local STRU_DESTORY_UI = {}
			STRU_DESTORY_UI._ui_base = layer
			STRU_DESTORY_UI._is_clean_up = isCleanUp
			table.insert(ViewManager.DestoryList, STRU_DESTORY_UI)
			ViewManager.ContainerDictionary[menuName] = nil
		end
	end

	function ViewManager:AddLayer(parentLayer,menuName,menuLayer,zOrder)
		local layer = ViewManager.ContainerDictionary[menuName]
		if  layer ~= nil then
			ViewManager.ShowLayer(menuName,true)
			return
		end
		parentLayer:addChild(menuLayer._layer,zOrder)
		ViewManager.ContainerDictionary[menuName] = menuLayer
		for k,v in pairs(ViewManager.ContainerDictionary) do
			log.Info("k===" .. k)
		end
	end

	function ViewManager:Update(dt)
		for i=1,#self.DestoryList do
			self.DestoryList[i]._ui_base:removeFromParentAndCleanup(self.DestoryList[i]._is_clean_up)
			table.remove(self.DestoryList, i)
		end
		for i=1,#self.UpdateList do
			local name  = self.UpdateList[i]
			if self.ContainerDictionary[name] then
				self.ContainerDictionary[name]:update(dt)
			end
		end
	end

	function ViewManager:GetLayerCount(self)
		local x = 0
		for k,v in pairs(ViewManager.ContainerDictionary) do
			if nil ~= v then
				x = x + 1
			end
		end
		return x
	end

	function ViewManager:RegisterUpdate(menuName)
		if nil ~= self.ContainerDictionary[menuName] then
			local x = 0
			for i=1,#self.UpdateList do
				if menuName == self.UpdateList[i] then
					return
				end
			end

			table.insert(self.UpdateList,menuName)
		end

		return false	
	end

	function ViewManager:UnRegisterUpdate(menuName)
		for i=1,#self.UpdateList do
			if menuName == self.UpdateList[i] then
				table.remove(self.UpdateList, i)
			end
		end
		return false
	end

	function ViewManager:ClearAllLayer(self)
		-- for k,v in pairs(ViewManager.DestoryList) do
		-- 	ViewManager.DestoryList[k] = nil
		-- end	
		-- for k,v in pairs(ViewManager.ContainerDictionary) do
		-- 	ViewManager.ContainerDictionary[k] = nil
		-- end
		-- for k,v in pairs(ViewManager.UpdateList) do
		-- 	ViewManager.UpdateList = nil
		-- end
		for i=1,#self.DestoryList do
			table.remove(self.DestoryList, i)
		end
		for i=1,#self.ContainerDictionary do
			table.remove(self.ContainerDictionary, i)
		end
		for i=1,#self.UpdateList do
			table.remove(self.UpdateList, i)
		end
	end
return ViewManager	