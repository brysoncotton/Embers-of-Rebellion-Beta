require("deepcore/std/plugintargets")

return {
    type = "plugin",
    target = PluginTargets.never(),
    init = function(self, ctx)
        TacticalCrewHandler = require("eawx-plugins-gamescoring/tactical-crew-handler/TacticalCrewHandler")
        return TacticalCrewHandler()
    end
}
