require("deepcore/std/plugintargets")

return {
    type = "plugin",
    target = PluginTargets.never(),
    init = function(self, ctx)
        MultiLayer = require("eawx-plugins-gameobject-space/multilayer/MultiLayer")
        return MultiLayer()
    end
}
