require("deepcore/std/plugintargets")

return {
    type = "plugin",
    target = PluginTargets.always(),
    init = function(self, ctx)
        Bloodlust = require("eawx-plugins-gamescoring/bloodlust/Bloodlust")
        return Bloodlust()
    end
}
