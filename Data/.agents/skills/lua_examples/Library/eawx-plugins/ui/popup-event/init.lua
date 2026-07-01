require("deepcore/std/plugintargets")
require("eawx-plugins/ui/popup-event/PopupEvent")

return {
    target = PluginTargets.story_flag("EVENT_BUTTON_CLICKED"),
    init = function(self, ctx) 
        return PopupEvent()
    end
}