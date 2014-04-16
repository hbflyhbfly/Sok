local Item  = require "src/basestruct/Item"
local FileManager = require "src/util/FileManager"
local ITEM_DADA_FILE = "item.json"
local itemkey = "item"
local ItemPool = {}

	ItemPool._vecItemPool = {}

	function ItemPool:Close()
		
		for k,v in pairs(ItemPool._vecItemPool[itemkey]) do
            ItemPool._vecItemPool[itemkey] = nil
        end

	end

	function ItemPool:GetCount()
		return #ItemPool._vecItemPool[itemkey]
	end

	function ItemPool:GetIndex(itemIndex)
		if itemIndex < 1  or itemIndex > ItemPool:GetCount() then
			return nil
		end

		for k,v in ipairs(ItemPool._vecItemPool[itemkey]) do
			local item = v
			if item._itemIndex == itemIndex then
				return item
			end
		end

	end

	function ItemPool:GetItemByName(itemname)

		if itemname == nil then
			return nil
		end

		for k,v in pairs(ItemPool._vecItemPool[itemkey]) do
			local  item = v
			if item ~= nil and item._itemName == itemname then 
				return item
			end
		end

		return nil
	end

	function ItemPool:GetItemByID(itemID)

		for k,v in pairs(ItemPool._vecItemPool[itemkey]) do
			local  item = v
			if item ~= nil and item._itemID == itemID  then
				return item
			end
		end

	end

	function ItemPool:AddItem(item)
		if item ~= nil then
			table.insert(ItemPool._vecItemPool[itemkey], item)
		end
	end

	function ItemPool:DelItem(itemName)
		for k,v in pairs(ItemPool._vecItemPool[itemkey]) do
			local  item = v
			if item ~= nil and itemname == item._itemName then
				table.remove(ItemPool._vecItemPool[itemkey], item)
			end
		end
	end

	function ItemPool:GetStream(filename)
		ItemPool._vecItemPool = FileManager:readJsonFileToTable(filename)
	end

return ItemPool