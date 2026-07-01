require("deepcore/std/plugintargets")

return {
    type = "plugin",
    target = PluginTargets.always(),
    init = function(self, ctx)
        BootanaHutta = require("eawx-plugins-gamescoring/bootana-hutta/BootanaHutta")
        return BootanaHutta()
    end
}
