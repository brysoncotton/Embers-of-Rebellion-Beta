require("deepcore/std/plugintargets")

return {
    type = "plugin",
    target = PluginTargets.always(),
    init = function(self, ctx)
        Boarding = require("eawx-plugins-gameobject-space/boarding/Boarding")
        return Boarding()
    end
}
