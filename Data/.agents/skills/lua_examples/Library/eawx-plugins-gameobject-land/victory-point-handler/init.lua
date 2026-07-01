require("deepcore/std/plugintargets")

return {
    type = "plugin",
    target = PluginTargets.always(),
    init = function(self, ctx)
        VictoryPointHandler = require("eawx-plugins-gameobject-land/victory-point-handler/VictoryPointHandler")
        return VictoryPointHandler()
    end
}
