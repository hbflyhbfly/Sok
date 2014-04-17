local Item  = require "src/basestruct/Item"
local FileManager = require "src/util/FileManager"
local ITEM_DADA_FILE = "item.json"
local itemkey = "item"
local ItemPool = {}

	ItemPool._vecItemPool = {}

	function ItemPool:Close()
		
		for k,v in pairs(ItemPool._vecItemPool) do
            ItemPool._vecItemPool[v] = nil
        end

	end

	function ItemPool:GetCount()
		return #ItemPool._vecItemPool
	end

	function ItemPool:GetIndex(itemIndex)
		if itemIndex < 1  or itemIndex > ItemPool:GetCount() then
			return nil
		end

		-- for k,v in ipairs(ItemPool._vecItemPool) do
		-- 	local pairs = v
		-- 	if item._itemIndex == itemIndex then
		-- 		return item
		-- 	end
		-- end
		for i=1,#ItemPool._vecItemPool do
			if itemIndex == ItemPool._vecItemPool[i]._itemIndex then 
				return ItemPool._vecItemPool[i]
			end
		end

	end

	function ItemPool:GetItemByName(itemname)

		if itemname == nil then
			return nil
		end

		-- for k,v in pairs(ItemPool._vecItemPool) do
		-- 	local  item = v
		-- 	if item ~= nil and item._itemName == itemname then 
		-- 		return item
		-- 	end
		-- end
		for i=1,#ItemPool._vecItemPool do
			if itemname == ItemPool._vecItemPool[i]._itemName then 
				return ItemPool._vecItemPool[i]
			end
		end

		return nil
	end

	function ItemPool:GetItemByID(itemID)

		-- for k,v in pairs(ItemPool._vecItemPool) do
		-- 	local  item = v
		-- 	if item ~= nil and item._itemID == itemID  then
		-- 		return item
		-- 	end
		-- end
		for i=1,#ItemPool._vecItemPool do
			if itemID == ItemPool._vecItemPool[i]._itemID then 
				return ItemPool._vecItemPool[i]
			end
		end

	end

	function ItemPool:AddItem(item)
		if item ~= nil then
			table.insert(ItemPool._vecItemPool, item)
		end
	end

	function ItemPool:DelItem(itemName)

		for i=1,#ItemPool._vecItemPool do
			if itemName == ItemPool._vecItemPool[i]._itemName then 
				table.remove(ItemPool._vecItemPool,i)
			end
		end
		-- for k,v in pairs(ItemPool._vecItemPool) do
		-- 	local  item = v
		-- 	if itemName == v._itemName then
		-- 		table.remove(ItemPool._vecItemPool,v)
		-- 	end
		-- end
	end

	function ItemPool:GetStream(filename)
		local vecItemPool = FileManager:readJsonFileToTable(filename)
        local vecItemPools = vecItemPool[itemkey]
		for k,v in pairs(vecItemPools) do
			local item = v
			ItemPool:AddItem(item)			--读到内存
		end
	end

return ItemPool