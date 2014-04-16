local M = {}

M.CURRENCY_TYPE = 
{  
	CURRENCY_GAME_TYPE = 0x0001,		--游戏币
    CURRENCY_GOLD_TYPE = 0x0002,		--代金券
    CURRENCY_YUAN_TYPE = 0x0003			--人民币
}


local modename = "ItemDef"
local proxy = {}
local mt    = {
    __index = M,
    __newindex =  function (t ,k ,v)
        print("ItemDef attemp to update a read-only table")
    end
} 
setmetatable(proxy,mt)
_G[modename] = proxy
package.loaded[modename] = proxy