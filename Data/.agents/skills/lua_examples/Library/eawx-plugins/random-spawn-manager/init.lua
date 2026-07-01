require("deepcore/std/plugintargets")
require("eawx-plugins/random-spawn-manager/RandomSpawnManager")

return {
    type = "plugin",
    target = PluginTargets.never(),
    init = function(self, ctx)
        return RandomSpawnManager(ctx.galactic_conquest, ctx.is_generated, ctx.id)
    end
}
