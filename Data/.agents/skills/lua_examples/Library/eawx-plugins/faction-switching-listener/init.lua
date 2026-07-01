require("deepcore/std/plugintargets")
require("eawx-plugins/faction-switching-listener/FactionSwitchingListener")

return {
    target = PluginTargets.story_flag("SWITCH_SIDES_LISTENER"),
    init = function(self, ctx) 
        return FactionSwitching(ctx.galactic_conquest)
    end
}