require "src/constdef/RunerDef"
local ROLE = {}
	ROLE._id = ""                           --角色ID
	ROLE._name = ""							--角色名称
	ROLE._skill = {}						--技能
	ROLE._icon = ""							--资源图
	ROLE._type = ""							--类型（npc/玩家）
	ROLE._level = 1							--角色等级
	ROLE._EXP = 0							--当前经验
	ROLE._HP = 3							--当前HP
	ROLE._power = 0							--内力值
	ROLE._statu = RunerDef.STATUS_NORMAL	--移动状态
	ROLE._velocity = 0						--跳跃的纵向速度
	ROLE._loc = {							--当前位置
		_x = 0,								--x坐标
		_y = 0								--y坐标
	}
	ROLE._action = ""						--当前执行的动作
	ROLE._ground = 0						--所在地面高度
	ROLE._buff = ""							--当前所受buff
return ROLE