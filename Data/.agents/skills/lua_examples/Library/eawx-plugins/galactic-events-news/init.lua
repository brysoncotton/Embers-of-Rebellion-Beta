require("deepcore/std/plugintargets")
require("eawx-plugins/galactic-events-news/GalacticEventsNewsSource")

return {
    type = "plugin",
    target = PluginTargets.never(),
    dependencies = { "ui/galactic-display",  "invading-fleet-listener", "blockade-attrition", "influence-service", "orbital-structure-handler", "abstract-resources", "victory-handler" },
    ---@param ctx table<string, any>
    ---@param galactic_display DisplayComponentContainer
    ---@param incoming_fleet_event IncomingFleetEvent
    init = function(self, ctx, galactic_display, incoming_fleet_event, blockade_attrition, influence_service, orbital_structure_handler, abstract_resource_handler, victory_handler)
        ---@type GalacticConquest
        local galactic_conquest = ctx.galactic_conquest

        local gc_event_news_source =
            GalacticEventsNewsSource(
            ctx.galactic_conquest.Events.PlanetOwnerChanged,
            ctx.galactic_conquest.Events.GalacticHeroKilled,
            ctx.galactic_conquest.Events.GalacticSSDKilled,
            ctx.galactic_conquest.Events.GalacticSSDDamaged,
            ctx.galactic_conquest.Events.GalacticSSDRepaired,
            incoming_fleet_event,
            blockade_attrition.blockade_attrition_unit_killed,
            influence_service.influence_unrest_growing,
            influence_service.influence_revolt_occured,
            orbital_structure_handler.structure_swap_warning,
            orbital_structure_handler.structure_swapped,
            orbital_structure_handler.no_taxes_warning,
            abstract_resource_handler.infrastructure_event,
            victory_handler.victory_handler_shipyards_available,
            victory_handler.victory_handler_conquest_available
        )

        ---@type NewsFeedDisplayComponent
        local news_feed = galactic_display:get_component("news_feed")
        news_feed:add_news_source(gc_event_news_source)

        return gc_event_news_source
    end
}