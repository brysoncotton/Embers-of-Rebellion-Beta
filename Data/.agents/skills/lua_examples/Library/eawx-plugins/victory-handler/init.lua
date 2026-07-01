require("deepcore/std/plugintargets")
require("eawx-plugins/victory-handler/VictoryHandler")

return {
    type = "plugin",
    target = PluginTargets.never(),
    init = function(self, ctx)
        return VictoryHandler(ctx.galactic_conquest.Events)
    end
}
