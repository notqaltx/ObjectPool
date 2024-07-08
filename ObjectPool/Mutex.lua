local RunService = game:GetService("RunService")

local Mutex = {}
Mutex.__index = Mutex

function Mutex.new()
   local self = setmetatable({}, Mutex)
   self.locked = false
   self.lockingThread = nil
   self.lockCount = 0
   return self
end

function Mutex:lock(timeout)
   local startTime = tick()
   local currentThread = coroutine.running()

   while self.locked and self.lockingThread ~= currentThread do
      if timeout and (tick() - startTime) >= timeout then
         error("Mutex lock timeout")
      end
      RunService.Heartbeat:Wait()
   end
   self.locked = true
   self.lockingThread = currentThread
   self.lockCount += 1
end

function Mutex:unlock()
   local currentThread = coroutine.running()
   if not self.locked or self.lockingThread ~= currentThread then
      error("Mutex unlock attempt by non-locking thread or when mutex is not locked")
   end
   self.lockCount -= 1
   if self.lockCount == 0 then
      self.locked = false
      self.lockingThread = nil
   end
end

function Mutex:isLocked()
	  return self.locked
end

return Mutex
