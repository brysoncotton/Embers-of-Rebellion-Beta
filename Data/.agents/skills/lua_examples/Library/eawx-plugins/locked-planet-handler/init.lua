require("deepcore/std/plugintargets")
require("eawx-plugins/locked-planet-handler/LockedPlanetHandler")

return {
    type = "plugin",
    target = PluginTargets.interval(10),
    init = function(self)
        return LockedPlanetHandler()
	end
}
