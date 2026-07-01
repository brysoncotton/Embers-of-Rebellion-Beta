require("deepcore/std/plugintargets")

return {
    type = "plugin",
    target = PluginTargets.always(),
    init = function(self, ctx)
        Microjump = require("eawx-plugins-gameobject-space/microjump/Microjump")
        return Microjump()
    end
}
