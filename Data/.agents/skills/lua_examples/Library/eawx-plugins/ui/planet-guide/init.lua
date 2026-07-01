require("deepcore/std/plugintargets")
require("eawx-plugins/ui/planet-guide/PlanetGuide")

return {
    target = PluginTargets.story_flag("INFLUENCE_DOC_TRIGGER"),
    init = function(self, ctx) 
        return PlanetGuide(ctx.galactic_conquest)
    end
}