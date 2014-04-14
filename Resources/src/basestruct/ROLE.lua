local FileManager = require "src/util/FileManager"
require "src/constdef/RunerDef"
local ROLE = {}
function ROLE:create()
	-- body
	_role = {}
	_role._id = ""
	_role._name = ""
	_role._skill = {}
	_role._icon = ""
	_role._type = ""
	_role._runerStatu = ""
	_role._loc = {
		x = 0,
		y = 0
	}
	_role._velocity = 0

	function _role:init()
		
		--初始化
	end
	_role:init()
	return _role

end
return ROLE