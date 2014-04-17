
local base_util = require "src/util/BaseUtil.lua"


DataCenter = {}
DataCenter._notify_observers = {}

--注册观察者
function DataCenter:RegisterObserver(iobserver)
	if  self._notify_observers  == nil then  
		return;
	end

	if iobserver == nil then
		return;
	end
	table.insert(self._notify_observers, iobserver);
end

function DataCenter:unRegisterObserver(iobserver)
	if  self._notify_observers  == nil then  
		return;
	end

	if iobserver == nil then
		return;
	end

	for i=1,#self._notify_observers do
		if self._notify_observers[i] == iobserver then
			table.remove(self._notify_observers, iobserver)
			break
		end
	end

end

function DataCenter:isObserversEmpty()
	return base_util:tableIsEmpty(self._notify_observers)
end
	
function DataCenter:notifyObservers(param1, param2, param3)
	if self:isObserversEmpty() then
		return
	end

	for i=1,#self._notify_observers do
		self._notify_observers[i]:OnDataChange(param1, param2, param3)
	end
end