require("deepcore/std/plugintargets")
require("eawx-plugins/ui/government-update/GovernmentUpdater")

return {
    target = PluginTargets.story_flag("GOVERNMENT_DISPLAY_CLICKED"),
    init = function(self, ctx) 
        return GovernmentUpdater()
    end
}