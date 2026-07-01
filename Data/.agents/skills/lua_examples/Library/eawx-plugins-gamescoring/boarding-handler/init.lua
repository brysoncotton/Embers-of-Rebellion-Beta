require("deepcore/std/plugintargets")

return {
    type = "plugin",
    target = PluginTargets.never(),
    init = function(self, ctx)
        BoardingHandler = require("eawx-plugins-gamescoring/boarding-handler/BoardingHandler")
        return BoardingHandler()
    end
}
