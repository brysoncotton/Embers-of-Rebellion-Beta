require("deepcore/std/class")
require("deepcore/std/callable")
require("eawx-statemachine/EawXStateTransition")

---@class StateTransitionBuilder
StateTransitionBuilder = class()

---@param origin_state EawXState
function StateTransitionBuilder:new(origin_state)
    self.origin = origin_state

    ---@private
    ---@type EawXState
    self.next = nil

    ---@type EawXTransitionPolicy
    self.transition_policy = nil

    ---@type table<number, fun(): nil>
    self.effects = {}
end

---@param next_state EawXState
function StateTransitionBuilder:to(next_state)
    self.next = next_state
    return self
end

---@param transition_policy EawXTransitionPolicy
function StateTransitionBuilder:when(transition_policy)
    self.transition_policy = transition_policy
    return self
end

function StateTransitionBuilder:with_effects(...)
    for _, effect in ipairs(arg) do
        table.insert(self.effects, effect:build())
    end

    return self
end

function StateTransitionBuilder:end_()
    local composed_effects =
        callable {
        effects = self.effects,
        call = function(self)
            for _, effect in ipairs(self.effects) do
                effect()
            end
        end
    }

    self.transition_policy.transition_function = composed_effects
    return EawXStateTransition(self.origin, self.next, self.transition_policy)
end


return StateTransitionBuilder