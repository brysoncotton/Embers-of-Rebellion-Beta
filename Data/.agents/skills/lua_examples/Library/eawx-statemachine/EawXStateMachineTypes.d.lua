---@class EawXStatePolicy
local EawXStatePolicy = {}

---@param previous_state_context table<string, any>
---@return table<string, any>
function EawXStatePolicy:on_enter(previous_state_context)
end

---@param state_context table<string, any>
function EawXStatePolicy:on_update(state_context)
end

---@param state_context table<string, any>
function EawXStatePolicy:on_exit(state_context)
end

---@class EawXTransitionPolicy
local EawXTransitionPolicy = {}

---@type fun() : nil
EawXTransitionPolicy.transition_function = nil

---@param state_context table<string, any>
function EawXTransitionPolicy:on_origin_entered(state_context)
end

---@param state_context table<string, any>
---@return boolean
function EawXTransitionPolicy:should_transition(state_context)
end

---@param state_context table<string, any>
function EawXTransitionPolicy:on_transition(state_context)
end