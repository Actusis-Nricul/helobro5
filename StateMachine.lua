-- statemachine.lua
-- A lightweight finite state machine for games.
-- Usage:
--   local sm = StateMachine.new("idle")
--   sm:addState("idle", { enter = fn, update = fn, exit = fn })
--   sm:addTransition("idle", "run", "walking")
--   sm:fire("walking") or sm:update(dt)

local StateMachine = {}
StateMachine.__index = StateMachine

function StateMachine.new(initialState)
    local self = setmetatable({}, StateMachine)
    self.states = {}
    self.current = initialState
    self.previous = nil
    self.timeInState = 0
    return self
end

-- callbacks: { enter, update, exit } each optional function(self, ...)
function StateMachine:addState(name, callbacks)
    self.states[name] = callbacks or {}
end

function StateMachine:canChangeTo(name)
    return self.states[name] ~= nil
end

function StateMachine:change(name, ...)
    if not self:canChangeTo(name) then
        error(("StateMachine: unknown state '%s'"):format(tostring(name)))
    end

    local oldState = self.states[self.current]
    if oldState and oldState.exit then
        oldState.exit(self, ...)
    end

    self.previous = self.current
    self.current = name
    self.timeInState = 0

    local newState = self.states[name]
    if newState and newState.enter then
        newState.enter(self, ...)
    end
end

function StateMachine:update(dt, ...)
    self.timeInState = self.timeInState + dt
    local state = self.states[self.current]
    if state and state.update then
        state.update(self, dt, ...)
    end
end

function StateMachine:is(name)
    return self.current == name
end

function StateMachine:getState()
    return self.current
end

return StateMachine
