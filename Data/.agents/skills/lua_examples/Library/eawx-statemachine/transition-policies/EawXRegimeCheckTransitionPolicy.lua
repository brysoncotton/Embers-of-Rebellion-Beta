require("deepcore/std/class")

---@class EawXRegimeCheckTransitionPolicy : EawXTransitionPolicy
EawXRegimeCheckTransitionPolicy = class()

---@param target_regime number
---@param transition_function fun(state_context: table<string, any>)
function EawXRegimeCheckTransitionPolicy:new(target_regime, transition_function)
    ---@private
    self.target_regime = target_regime

    ---@private
    ---@type number
    self.regime_on_enter = nil

    ---@private
    self.transition_function = transition_function or function()
        end
end

---@param state_context table<string, any>
function EawXRegimeCheckTransitionPolicy:on_origin_entered(state_context)
    self.regime_on_enter = Find_Player("Empire").Get_Tech_Level()
end

---@param state_context table<string, any>
function EawXRegimeCheckTransitionPolicy:should_transition(state_context)
    return GlobalValue.Get("SELECTED_REGIME") == self.target_regime
end

---@param state_context table<string, any>
function EawXRegimeCheckTransitionPolicy:on_transition(state_context)
    self.transition_function(state_context)
end