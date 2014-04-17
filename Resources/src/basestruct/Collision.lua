require "src/constdef/CollisionDef"
local Collision = {}
	Collision._id = ""                           --物体ID
	Collision._name = ""						--物体名称
	Collision._icon = ""						--资源图
	Collision._type = ""						--类型
	Collision._HP = 3							--当前HP
	Collision._status = 1	      				--状态
	Collision._loc = {							--当前位置
		_x = 0,									--x坐标
		_y = 0									--y坐标
	}
	Collision._action = ""						--当前执行的动作
return Collision
