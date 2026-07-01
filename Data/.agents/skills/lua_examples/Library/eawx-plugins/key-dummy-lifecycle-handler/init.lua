require("deepcore/std/plugintargets")
require("eawx-plugins/key-dummy-lifecycle-handler/KeyDummyLifeCycleHandler")

return {
    type = "plugin",
    target = PluginTargets.always(),
    requires_planets = true,
    init = function(self, ctx)
        return KeyDummyLifeCycleHandler(ctx.galactic_conquest.Planets, ctx.galactic_conquest.Events.PlanetOwnerChanged)
    end
}
