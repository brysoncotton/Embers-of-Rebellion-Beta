require("deepcore/std/class")
require("eawx-util/Math")
require("eawx-util/StoryUtil")

---@class EawXMTTHTransitionPolicy : EawXTransitionPolicy
EawXMTTHTransitionPolicy = class()

---@param mean_cycle_to_happen number
---@param transition_function fun(state_context: table<string, any>)
function EawXMTTHTransitionPolicy:new(mean_cycle_to_happen, interval_seconds, transition_function)
    ---@private
    self.mean_cycle_to_happen = mean_cycle_to_happen or 0
	
	---@private
    ---@type number
    self.initial_time = 0
	
	---@private
    ---@type number
	self.interval_seconds = interval_seconds
	
	---@private
    ---@type number
	self.next_update = -1
	
	---@private
    ---@type number
	self.elapsed_cycles = 0
	
	---@private
    ---@type number
	self.min_cycles = 2
	
	---@private
    ---@type number
	self.chance = MeanTimeToHappenChance(1, self.mean_cycle_to_happen)

    ---@public
    self.transition_function = transition_function or function()
        end
		
	---@type fun(): boolean
	self.condition = function()
		return true
	end
end

---@param state_context table<string, any>
function EawXMTTHTransitionPolicy:on_origin_entered(state_context)
	self.initial_time = GetCurrentTime()
end

---@param state_context table<string, any>
function EawXMTTHTransitionPolicy:should_transition(state_context)
	local elapsed_time = GetCurrentTime() - self.initial_time
	
	if self.next_update == -1 or elapsed_time >= self.next_update then
		self.elapsed_cycles = self.elapsed_cycles + 1
		self.next_update = self.elapsed_cycles * self.interval_seconds
	else
		return false
	end
	
	local random_chance = GameRandom.Free_Random() / 65535
	-- StoryUtil.ShowScreenText("MTTH -- Roll: "..tostring(random_chance)..", MTTH chance: "..tostring(self.chance).." Target cycle: "..tostring(self.mean_cycle_to_happen)..", Elapsed cycles: "..tostring(self.elapsed_cycles), 5)
    return self.condition() and random_chance < self.chance and self.elapsed_cycles > self.min_cycles
end

---@param condition fun(): boolean
function EawXMTTHTransitionPolicy:if_(condition)
    self.condition = condition
    return self
end

---@param state_context table<string, any>
function EawXMTTHTransitionPolicy:on_transition(state_context)
    self.transition_function(state_context)
end
