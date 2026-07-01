require("deepcore/std/plugintargets")

return {
    type = "plugin",
    target = PluginTargets.always(),
    init = function(self, ctx)
        InterdictorAi = require("eawx-plugins-gameobject-space/interdictor-ai/InterdictorAI")
        return InterdictorAi()
    end
}
