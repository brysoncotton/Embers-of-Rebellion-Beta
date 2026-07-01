require("deepcore/std/class")
require("deepcore/statemachine/dsl/TransitionEffectBuilderFactory")
require("eawx-statemachine/dsl/transition-effect-builders/PlanetTransferBuilder")
require("eawx-statemachine/dsl/transition-effect-builders/SetTechLevelBuilder")
require("eawx-statemachine/dsl/transition-effect-builders/SpawnHeroBuilder")

---@class EawXTransitionEffectBuilderFactory
EawXTransitionEffectBuilderFactory = class(TransitionEffectBuilderFactory)

function EawXTransitionEffectBuilderFactory:new(plugin_ctx)
    self.ctx = plugin_ctx
end

function EawXTransitionEffectBuilderFactory:eawx_set_tech_level(level)
    return EawXSetTechLevelBuilder(level)
end

return EawXTransitionEffectBuilderFactory