local FileManager = require "src/util/FileManager"
local SkillOrigin = require "src/basestruct/Skill"
local SKILL_JSON_FILE = "skill.json"

SkillManager = {}

SkillManager._vecSkillPool = {}

function SkillManager:Close()
	for k,v in pairs(self._vecSkillPool) do
		self._vecSkillPool[k] = nil
	end
end

function SkillManager:GetCount()
	return #SkillManager._vecSkillPool
end

function SkillManager:GetIndex(index)
	if index < 1 or index > #SkillManager._vecSkillPool then
		return nil
	end	
	return SkillManager._vecSkillPool[index]
end

function SkillManager:GetSkillByName(pSkillName)
	for i=1,#SkillManager._vecSkillPool do
		if nil ~= SkillManager._vecSkillPool[i] then
			if pSkillName == SkillManager._vecSkillPool[i]._skillName then 
				return SkillManager._vecSkillPool[i]
			end	
		end	
	end

	return nil
end

function SkillManager:GetSkillByID(ID)
	for i=1,#SkillManager._vecSkillPool do
		if nil ~= SkillManager._vecSkillPool[i] then
			if ID == SkillManager._vecSkillPool[i]._skillID then 
				return SkillManager._vecSkillPool[i]
			end	
		end	
	end

	return nil
end

function SkillManager:AddSkill(pSkill)
	if nil ~= pSkill then
		table.insert(self._vecSkillPool,pSkill)
		return true
	end
	return false
end

function SkillManager:GetStream()
	local table = FileManager:readJsonFileToTable(SKILL_JSON_FILE)
	for k,v in pairs(table.skill) do
		local Skill = {}
		setmetatable(Skill, SkillOrigin)
    	SkillOrigin.__index = SkillOrigin;
		Skill._skillID               =  v._skillID  			--技能ID
	    Skill._skillName             =  v._skillName  			--技能名称
	    Skill._skillDegree           =  v._skillDegree  		--技能等级
	    Skill._skillIsActive         =  v._skillIsActive  		--是否为主动攻击(1主动，2被动)
	    Skill._skillCost             =  v._skillCost  			--消耗
	    Skill._skillAttr             =  v._skillAttr  			--攻击力
	    Skill._skillAnimRes          =  v._skillAnimRes  		--技能动画资源
	    Skill._skillEffectRes        =  v._skillEffectRes  		--技能特效资源
	    Skill._skillResult           =  v._skillResult  		--效果
	    Skill._skillHighSpeedTime    =  v._skillHighSpeedTime  	--加速时间
	    Skill._skillDes              =  v._skillDes  			--技能描述
		self:AddSkill(Skill)
	end
end

return SkillManager