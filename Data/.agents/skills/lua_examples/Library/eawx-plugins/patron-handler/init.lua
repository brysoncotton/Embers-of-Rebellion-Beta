require("deepcore/std/plugintargets")
require("eawx-plugins/Patron-handler/PatronHandler")

return {
    type = "plugin",
    target = PluginTargets.weekly(),
    init = function(self, ctx)
        local galactic_conquest = ctx.galactic_conquest
        return PatronHandler(galactic_conquest, galactic_conquest.HumanPlayer)
    end
}
 