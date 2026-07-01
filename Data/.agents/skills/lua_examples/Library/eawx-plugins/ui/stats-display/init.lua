require("deepcore/std/plugintargets")
require("eawx-plugins/ui/stats-display/GalacticStatDisplay")

return {
    target = PluginTargets.story_flag("STAT_DISPLAY_CLICKED"),
    init = function(self, ctx) 
        return GalacticStatDisplay(ctx.galactic_conquest)
    end
}