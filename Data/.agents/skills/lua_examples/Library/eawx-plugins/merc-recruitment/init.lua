require("deepcore/std/plugintargets")
require("eawx-plugins/merc-recruitment/MercRecruitment")

return {
    target = PluginTargets.weekly(),
    init = function(self, ctx)
        return MercRecruitment(ctx.galactic_conquest)
    end
}
