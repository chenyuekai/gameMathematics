
local DispatcherCls = class("Dispatcher")
function DispatcherCls:ctor()
    self._eventDispatcher = {}
end

function DispatcherCls:addEventListener(eventName,func,obj)
    self._eventDispatcher[eventName] = self._eventDispatcher[eventName] or {}
    local listener = {func=func ,obj = obj}
    self._eventDispatcher[eventName][listener] = listener
end

function DispatcherCls:dispatchEvent(eventName,...)
    local lst = self._eventDispatcher[eventName]
    if lst then
        for k,v in pairs(lst) do
            if v.obj then
                v.func(v.obj,eventName,...)
            else
                v.func(eventName,...)
            end 
        end
    else 
        print("this event is not regist :" .. eventName)
    end 
end

function DispatcherCls:removeEventListener(eventName,func,obj)
    local lst = self._eventDispatcher[eventName]
    if lst then
        for k,v in pairs(lst) do
            if v.func == func and v.obj == obj then
                lst[v] = nil
            end 
        end
    end 
end
_G.Dispatcher = DispatcherCls.new()
return DispatcherCls