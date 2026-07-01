require("deepcore/std/class")
require("deepcore/statemachine/dsl/TransitionPolicyFactory")
require("eawx-statemachine/transition-policies/EawXGlobalEraCheckTransitionPolicy")
require("eawx-statemachine/transition-policies/EawXRegimeCheckTransitionPolicy")
require("eawx-statemachine/transition-policies/EawXPlanetLostTransitionPolicy")
require("eawx-statemachine/transition-policies/EawXMTTHTransitionPolicy")
require("eawx-statemachine/transition-policies/EawXTimedTransitionPolicy")

---@class EawXTransitionPolicyFactory
EawXTransitionPolicyFactory = class(TransitionPolicyFactory)

function EawXTransitionPolicyFactory:new(plugin_ctx)
    self.ctx = plugin_ctx
end

---@param current_tech number
function EawXTransitionPolicyFactory:global_era(current_tech)
    return EawXGlobalEraCheckTransitionPolicy(current_tech)
end

---@param selected_regime number
function EawXTransitionPolicyFactory:selected_regime_index(selected_regime)
    return EawXRegimeCheckTransitionPolicy(selected_regime)
end


---@param planet_name string
function EawXTransitionPolicyFactory:planet_lost(planet_name)
    ---@type GalacticConquest
    local gc = self.ctx.galactic_conquest
    return EawXPlanetLostTransitionPolicy(gc.Events.PlanetOwnerChanged, planet_name)
end

---@param time number
function EawXTransitionPolicyFactory:mtth(mean_cycle_to_happen, check_interval_seconds)
    return EawXMTTHTransitionPolicy(mean_cycle_to_happen, check_interval_seconds)
end

---@param time number
function EawXTransitionPolicyFactory:conditional_timed(time)
    return EawXTimedTransitionPolicy(time)
end


return EawXTransitionPolicyFactory
