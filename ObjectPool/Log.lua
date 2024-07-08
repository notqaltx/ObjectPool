local LogService = {}
LogService.__index = LogService

LogService.Level = {
   INFO = "Info",
   WARNING = "Warning",
   ERROR = "Error"
}
function LogService.new()
   local self = setmetatable({}, LogService)
   self.logs = {}
   return self
end

function LogService:log(level, message)
   table.insert(self.logs, {level = level, message = message, timestamp = os.time()})
   print(string.format("[%s] %s: %s", os.date("%X", os.time()), level, message))
end

function LogService:getLogs()
	  return self.logs
end

return LogService
