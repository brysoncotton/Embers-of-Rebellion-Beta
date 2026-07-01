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
--*       File Created:      Sunday, 23rd February 2020 02:24                                      *
--*       Author:            [TR] Pox                                                              *
--*       Last Modified:     Wednesday, 8th July 2020 12:12                                        *
--*       Modified By:       [TR] Pox                                                              *
--*       Copyright:         Thrawns Revenge Development Team                                      *
--*       License:           This code may not be used without the author's explicit permission    *
--**************************************************************************************************

require("deepcore/std/plugintargets")
require("eawx-plugins/ui/galactic-display/NewsFeedDisplayComponent")
require("eawx-plugins/ui/galactic-display/PlanetInformationDisplayComponent")
require("eawx-plugins/ui/galactic-display/ShipCrewDisplayComponent")
require("eawx-plugins/ui/galactic-display/EraDisplayComponent")
require("eawx-plugins/ui/galactic-display/DisplayComponentContainer")

return {
    type = "plugin",
    target = PluginTargets.always(),
    dependencies = {"selected-planet-listener", "influence-service", "resource-manager", "abstract-resources", "year-handler", "options-handler"},
    init = function(self, ctx, selected_planet_changed_event, influence_service, resource_manager, abstract_resources, year_handler, options_handler)

        local galactic_news_feed = NewsFeedDisplayComponent()

        local structure_display =
            PlanetInformationDisplayComponent(
            influence_service,
            selected_planet_changed_event,
            ctx.galactic_conquest.Events.GalacticProductionFinished,
            options_handler
        )

        local galactic_display = DisplayComponentContainer()
        galactic_display:add_display_component("era_display", EraDisplayComponent(selected_planet_changed_event, year_handler, options_handler), 1)
        galactic_display:add_display_component("ship_crew_display", ShipCrewDisplayComponent(resource_manager, abstract_resources, selected_planet_changed_event, ctx.galactic_conquest.Events.TacticalBattleEnding), 1)
        galactic_display:add_display_component("planet_info", structure_display, 1)
        galactic_display:add_display_component("news_feed", galactic_news_feed, 1)

        return galactic_display
    end
}
