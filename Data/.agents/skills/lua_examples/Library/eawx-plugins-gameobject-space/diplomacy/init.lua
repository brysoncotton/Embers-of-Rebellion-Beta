require("deepcore/std/plugintargets")

return {
    type = "plugin",
    target = PluginTargets.always(),
    init = function(self, ctx)
        Diplomacy = require("eawx-plugins-gameobject-space/diplomacy/Diplomacy")
        return Diplomacy()
    end
}
