require("deepcore/std/class")

---@class EawXTimedTransitionPolicy : EawXTransitionPolicy
EawXTimedTransitionPolicy = class()

---@param time_until_transition number
---@param transition_function fun(state_context: table<string, any>)
function EawXTimedTransitionPolicy:new(time_until_transition, transition_function)
    ---@private
    self.time_until_transition = time_until_transition or 0

    ---@private
    ---@type number
    self.time_origin_entered = nil

    ---@public
    self.transition_function = transition_function or function()
        end
	
	---@type fun(): boolean
	self.condition = function()
		return true
	end
end

---@param state_context table<string, any>
function EawXTimedTransitionPolicy:on_origin_entered(state_context)
    self.time_origin_entered = GetCurrentTime()
end

---@param condition fun(): boolean
function EawXTimedTransitionPolicy:if_(condition)
    self.condition = condition
    return self
end


---@param state_context table<string, any>
function EawXTimedTransitionPolicy:should_transition(state_context)
    return self.condition() and GetCurrentTime() >= self.time_origin_entered + self.time_until_transition
end

---@param state_context table<string, any>
function EawXTimedTransitionPolicy:on_transition(state_context)
    self.transition_function(state_context)
end
