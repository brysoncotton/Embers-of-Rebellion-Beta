require("eawx-plugins/galactic/stability/StabilityManager")
require("deepcore/std/plugintargets")

return {
    target = PluginTargets.weekly(),
    dependencies = {"influence-service"},
    init = function(self, ctx, influence_service)
        return StabilityManager(ctx, influence_service)
    end
}
