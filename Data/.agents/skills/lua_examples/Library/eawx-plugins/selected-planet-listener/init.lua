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
--*       File Created:      Sunday, 23rd February 2020 05:33                                      *
--*       Author:            [TR] Pox                                                              *
--*       Last Modified:     Sunday, 23rd February 2020 11:39                                      *
--*       Modified By:       [TR] Pox                                                              *
--*       Copyright:         Thrawns Revenge Development Team                                      *
--*       License:           This code may not be used without the author's explicit permission    *
--**************************************************************************************************

require("deepcore/std/plugintargets")
require("eawx-plugins/selected-planet-listener/SelectedPlanetChangedEvent")

return {
    type = "plugin",
    target = PluginTargets.always(),
    requires_planets = true,
    init = function(self, ctx)
        local planets = ctx.galactic_conquest.Planets
        local human_player = ctx.galactic_conquest.HumanPlayer

        for _, planet in pairs(planets) do
            local planetName = planet:get_name()
            local event = ctx.plot.Get_Event("Zoom_Into_" .. planetName)
            if event then
                event.Set_Reward_Parameter(1, human_player.Get_Faction_Name())
            end
        end
        return SelectedPlanetChangedEvent(ctx.galactic_conquest.HumanPlayer, ctx.galactic_conquest.Planets)
    end
}
