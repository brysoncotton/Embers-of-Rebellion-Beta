require("deepcore/std/class")

---@class EawXStateTransition
EawXStateTransition = class()

---@param origin EawXState
---@param next EawXState
---@param transition_policy EawXTransitionPolicy
function EawXStateTransition:new(origin, next, transition_policy)
    ---@private
    self.origin = origin
    self.origin.on_enter:attach_listener(self.on_origin_entered, self)
    table.insert(self.origin.transitions, self)

    ---@private
    self.next = next

    ---@private
    self.transition_policy = transition_policy

end

---@private
---@param state_context table<string, any>
function EawXStateTransition:on_origin_entered(state_context)
    self.transition_policy:on_origin_entered(state_context)
end

---@param state_context table<string, any>
---@return boolean
function EawXStateTransition:should_transition(state_context)
    return self.transition_policy:should_transition(state_context)
end

---@param state_context table<string, any>
function EawXStateTransition:transition(state_context)
    self.transition_policy:on_transition(state_context)
end

---@return EawXState
function EawXStateTransition:get_next_state()
    return self.next
end
