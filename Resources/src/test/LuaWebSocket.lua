local LuaWebSocket = {}

function LuaWebSocket:send()
	local res = CCLuaHttpRequest:create()
	res:setUrl("www.baidu.com")
	res:setTag(1)
	res:setResponseScriptCallback(
		callback)
	res:setRequestType(CCHttpRequest.kHttpGet)
	res:setRequestData("123",3)
	local client = CCHttpClient:getInstance()
	client:send(res)
	res:release()

end
function callback(request,isSucceed,body,head,status,error)
	print(request)
	print(isSucceed)
	print(body)
	print(head)
	print(status)
	print(error)
end
return LuaWebSocket