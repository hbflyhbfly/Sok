local CurrentUserInfo = {}
	function CurrentUserInfo:sharedUserInfo()
		if nil == self.instance then
			self.instance = self:new()
		end
		return self.instance
	end
	function CurrentUserInfo:new(o)
		o = o or {}
		setmetatable(o,self)
		self.__index = self
		o.userInfo = {}
		function o:addUserInfo()
			self.userInfo.id = ""
			self.userInfo.name = ""
			self.userInfo.currentRole = "runer2"
		end
		return o
	end
return CurrentUserInfo