local FileManager = require "src/util/FileManager"
local BuffOrigin = require "src/basestruct/Buff"
local BUFF_JSON_FILE = "buff.json"

BuffManager = {}

BuffManager._vecBuffPool = {}

function BuffManager:Close()
	for k,v in pairs(self._vecBuffPool) do
		self._vecBuffPool[k] = nil
	end
end

function BuffManager:GetCount()
	return #BuffManager._vecBuffPool
end

function BuffManager:GetIndex(index)
	if index < 1 or index > #BuffManager._vecBuffPool then
		return nil
	end	
	return BuffManager._vecBuffPool[index]
end

function BuffManager:GetBuffByName(pBuffName)
	for i=1,#BuffManager._vecBuffPool do
		if nil ~= BuffManager._vecBuffPool[i] then
			if pBuffName == BuffManager._vecBuffPool[i]._buffName then 
				return BuffManager._vecBuffPool[i]
			end	
		end	
	end

	return nil
end

function BuffManager:GetBuffByID(ID)
	for i=1,#BuffManager._vecBuffPool do
		if nil ~= BuffManager._vecBuffPool[i] then
			if ID == BuffManager._vecBuffPool[i]._buffID then 
				return BuffManager._vecBuffPool[i]
			end	
		end	
	end

	return nil
end

function BuffManager:AddBuff(pBuff)
	if nil ~= pBuff then
		table.insert(self._vecBuffPool,pBuff)
		print("\n" .. "----" .. BuffManager:GetCount() .. "-------" .. "\n")
		return true
	end
	return false
end

function BuffManager:GetStream()
	local table = FileManager:readJsonFileToTable(BUFF_JSON_FILE)
	for k,v in pairs(table.buff) do
		Buff = {}
		setmetatable(Buff, BuffOrigin)
    	BuffOrigin.__index = BuffOrigin;
		Buff._buffID            =   v._buffID
	    Buff._buffName			= 	v._buffName	
	    Buff._buffType			= 	v._buffType
	    Buff._buffLastTime		= 	v._buffLastTime
	    Buff._buffSpeedUp		= 	v._buffSpeedUp
	    Buff._buffReducedLife	= 	v._buffReducedLife	
	    Buff._buffEffectRes		= 	v._buffEffectRes	
	    Buff._buffDes			= 	v._buffDes
		self:AddBuff(Buff)
	end
end

return BuffManager