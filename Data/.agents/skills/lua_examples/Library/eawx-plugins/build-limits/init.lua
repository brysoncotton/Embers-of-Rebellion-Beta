require("deepcore/std/plugintargets")
require("eawx-plugins/build-limits/BuildLimits")

return {
    target = PluginTargets.weekly(),
    init = function(self, ctx)
        return BuildLimits(ctx.galactic_conquest)
    end
}
