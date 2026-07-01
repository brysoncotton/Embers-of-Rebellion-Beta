require("deepcore/std/plugintargets")

return {
    type = "plugin",
    target = PluginTargets.always(),
    init = function(self, ctx)
        TurnStation = require("eawx-plugins-gameobject-space/turn-station/TurnStation")
        return TurnStation()
    end
}
