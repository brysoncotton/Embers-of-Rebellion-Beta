require("deepcore/std/plugintargets")

return {
    type = "plugin",
    target = PluginTargets.interval(1),
    init = function(self, ctx)
        TacticalSuperlaser = require("eawx-plugins-gameobject-space/tactical-superlaser/TacticalSuperlaser")
        return TacticalSuperlaser()
    end
}
