require("deepcore/std/class")

---@class EawXStateMachine
EawXStateMachine = class()

---@param script_name string
---@param ctx table
---@return EawXStateMachine
function EawXStateMachine.from_script(script_name, dsl, ctx)
    local state_factory = require(script_name)
    local initial_state = state_factory(dsl, ctx)
    return EawXStateMachine(initial_state)
end

---@param initial_state EawXState
---@param initial_context table<string, any> | nil
function EawXStateMachine:new(initial_state, initial_context)
    ---@private
    ---@type EawXState
    self.active_state = initial_state
    self.active_state.on_exit:attach_listener(self.on_state_exit, self)
    self.active_state:initialise(initial_context or {})
end

function EawXStateMachine:update()
    self.active_state:update()
end

---@private
---@param new_state EawXState
function EawXStateMachine:on_state_exit(new_state, state_context)
    self.active_state.on_exit:detach_listener(self.on_state_exit)
    self.active_state = new_state
    self.active_state.on_exit:attach_listener(self.on_state_exit, self)
    self.active_state:initialise(state_context)
end
