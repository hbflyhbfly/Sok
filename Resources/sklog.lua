local SKLogTYPE = {}
SKLOG_INFO = "INFO";
local logger = function(level,tag,...)
	print(level,tag,string.format(...))
end

function SKLog(level,tag,...)
	logger(level,tag,...)
end
