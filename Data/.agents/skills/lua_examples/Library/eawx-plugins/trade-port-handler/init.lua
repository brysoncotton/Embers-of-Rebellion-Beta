require("deepcore/std/plugintargets")
require("eawx-plugins/trade-port-handler/TradePortHandler")

return {
    type = "plugin",
    target = PluginTargets.weekly(),
    requires_planets = true,
    dependencies = {"key-dummy-lifecycle-handler"},
    init = function(self, ctx, dummy_lifecycle_handler)
        return TradePortHandler(ctx.galactic_conquest.HumanPlayer, ctx.galactic_conquest.Planets, ctx.maxroutes, ctx.galactic_conquest.Events.GalacticProductionFinished, dummy_lifecycle_handler)
    end
}