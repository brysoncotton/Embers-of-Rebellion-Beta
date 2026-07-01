require("deepcore/std/plugintargets")
require("eawx-plugins/ui/abstract-resource-update/ResourceUpdater")

return {
    target = PluginTargets.story_flag("RESOURCE_DISPLAY_CLICKED"),
    init = function(self, ctx) 
        return ResourceUpdater()
    end
}