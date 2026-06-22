-- timer.lua
-- Simple timer/scheduler for delayed and repeating callbacks.
-- Usage:
--   local Timer = require("timer")
--   local t = Timer.new()
--   t:after(2, function() print("2s passed") end)
--   t:every(1, function() print("tick") end, 5) -- repeat 5 times
--   -- in your main loop:
--   t:update(dt)

local Timer = {}
Timer.__index = Timer

function Timer.new()
    return setmetatable({ tasks = {}, nextId = 1 }, Timer)
end

local function addTask(self, delay, fn, repeatCount)
    local id = self.nextId
    self.nextId = id + 1
    self.tasks[id] = {
        delay = delay,
        remaining = delay,
        fn = fn,
        repeatCount = repeatCount, -- nil = once, -1 = infinite, n = n times
        cancelled = false,
    }
    return id
end

-- Run fn once after `delay` seconds
function Timer:after(delay, fn)
    return addTask(self, delay, fn, nil)
end

-- Run fn every `delay` seconds. count = nil means infinite.
function Timer:every(delay, fn, count)
    return addTask(self, delay, fn, count or -1)
end

-- Cancel a scheduled task by id
function Timer:cancel(id)
    if self.tasks[id] then
        self.tasks[id].cancelled = true
    end
end

function Timer:clear()
    self.tasks = {}
end

-- Call this once per frame/tick with delta time in seconds
function Timer:update(dt)
    for id, task in pairs(self.tasks) do
        if task.cancelled then
            self.tasks[id] = nil
        else
            task.remaining = task.remaining - dt
            if task.remaining <= 0 then
                task.fn()

                if task.repeatCount == nil then
                    self.tasks[id] = nil
                else
                    task.remaining = task.remaining + task.delay
                    if task.repeatCount > 0 then
                        task.repeatCount = task.repeatCount - 1
                        if task.repeatCount == 0 then
                            self.tasks[id] = nil
                        end
                    end
                    -- repeatCount == -1 keeps going forever
                end
            end
        end
    end
end

return Timer
