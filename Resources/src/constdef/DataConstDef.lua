local M = {}

M.EVENT_MSG_TYPE = 
{  
	EM_FIRST_MSG_TYPE = 0x0001,
    EM_SECOND_MSG_TYPE = 0x0002
}


local modename = "DataConstDef"
local proxy = {}
local mt    = {
    __index = M,
    __newindex =  function (t ,k ,v)
        print("CollisionDef attemp to update a read-only table")
    end
} 
setmetatable(proxy,mt)
_G[modename] = proxy
package.loaded[modename] = proxy