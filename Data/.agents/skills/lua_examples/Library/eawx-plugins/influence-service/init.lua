--**************************************************************************************************
--*    _______ __                                                                                  *
--*   |_     _|  |--.----.---.-.--.--.--.-----.-----.                                              *
--*     |   | |     |   _|  _  |  |  |  |     |__ --|                                              *
--*     |___| |__|__|__| |___._|________|__|__|_____|                                              *
--*    ______                                                                                      *
--*   |   __ \.-----.--.--.-----.-----.-----.-----.                                                *
--*   |      <|  -__|  |  |  -__|     |  _  |  -__|                                                *
--*   |___|__||_____|\___/|_____|__|__|___  |_____|                                                *
--*                                   |_____|                                                      *
--*                                                                                                *
--*                                                                                                *
--*       File:              init.lua                                                              *
--*       File Created:      Sunday, 23rd February 2020 08:24                                      *
--*       Author:            [TR] Pox                                                              *
--*       Last Modified:     Sunday, 23rd February 2020 09:12                                      *
--*       Modified By:       [TR] Pox                                                              *
--*       Copyright:         Thrawns Revenge Development Team                                      *
--*       License:           This code may not be used without the author's explicit permission    *
--**************************************************************************************************

require("deepcore/std/plugintargets")
require("eawx-plugins/influence-service/InfluenceService")

return {
    type = "plugin",
    target = PluginTargets.weekly(),
    requires_planets = true,
    dependencies = {"key-dummy-lifecycle-handler", "blockade-attrition", "options-handler"},
    init = function(self, ctx, dummy_lifecycle_handler, blockade_attrition, options_handler)
        return InfluenceService(ctx.galactic_conquest.HumanPlayer, ctx.galactic_conquest.Planets, dummy_lifecycle_handler, blockade_attrition, options_handler)
    end
}
