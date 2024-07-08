-- Signal.lua
--[[
	Basic Custom Signal wrote for ObjectPool module :)
	-- Programmed by notqaltx (@qaltx)
]]

local Signal = {}
Signal.__index = Signal

--- Creates a new signal.
---@return Signal
function Signal.new()
   local self = setmetatable({
      _listeners = {},
      _onceListeners = {},
   }, Signal)
   return self
end

--- Connects a callback to the signal.
---@param callback fun(...)
---@return table
function Signal:Connect(callback)
   local listener = {
      callback = callback,
      connected = true,
   }
   table.insert(self._listeners, listener)
   return {
      Disconnect = function()
         listener.connected = false
      end
   }
end

--- Connects a callback to the signal, which will fire only once.
---@param callback fun(...)
---@return table
function Signal:Once(callback)
   local listener = {
      callback = callback,
      connected = true,
   }
   table.insert(self._onceListeners, listener)
   return {
      Disconnect = function()
         listener.connected = false
      end
   }
end

--- Fires the signal.
function Signal:Fire(...)
   for _, listener in ipairs(self._listeners) do
      if listener.connected then
         listener.callback(...)
      end
   end
   for i = #self._onceListeners, 1, -1 do
      local listener = self._onceListeners[i]
      if listener.connected then
         listener.callback(...)
         table.remove(self._onceListeners, i)
      end
   end
end

--- Waits for the signal to fire, resolving with the arguments passed to Fire().
---@return table
function Signal:Wait()
   local promise = {}
   promise.event = Signal.new()
   promise.connect = self:Connect(function(...)
      promise.event:Fire(...)
   end)
   promise.disconnect = function()
      promise.connect:Disconnect()
   end
   return promise
end

--- Throttles the signal firing rate to a specified interval (in seconds).
---@param interval number
function Signal:Throttle(interval)
   local lastFired = 0
   local throttledSignal = Signal.new()
   self:Connect(function(...)
      local now = os.clock()
      if now - lastFired >= interval then
         lastFired = now
         throttledSignal:Fire(...)
      end
   end)
   return throttledSignal
end

return Signal
