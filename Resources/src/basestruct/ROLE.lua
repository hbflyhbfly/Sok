require "src/constdef/RunerDef"
local ROLE = {}
	ROLE._id = ""
	ROLE._name = ""
	ROLE._skill = {}
	ROLE._icon = ""
	ROLE._type = ""
	ROLE._level = 1
	ROLE._EXP = 0
	ROLE._HP = 3
	ROLE._power = 0
	ROLE._statu = RunerDef.STATUS_NORMAL
	ROLE._velocity = 0
	ROLE._loc = {
		_x = 0,
		_y = 0
	}
	ROLE._action = ""
	ROLE._ground = 0
return ROLE
