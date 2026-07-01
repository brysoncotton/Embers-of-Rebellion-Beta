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
--*       File:              BoardingListener.lua                                                  *
--*       File Created:      Monday, 2nd March 2020 13:51                                          *
--*       Author:            [TR] Pox                                                              *
--*       Last Modified:     Tuesday, 5th May 2020 01:41                                           *
--*       Modified By:       [TR] Pox                                                              *
--*       Copyright:         Thrawns Revenge Development Team                                      *
--*       License:           This code may not be used without the author's explicit permission    *
--**************************************************************************************************

require("deepcore/std/class")
require("deepcore/crossplot/crossplot")
require("eawx-util/GalacticUtil")

---@class BoardingListener
BoardingListener = class()

---@param galactic_display DisplayComponentContainer
function BoardingListener:new(galactic_display, gc)
    ---@private
    ---@type NewsFeedDisplayComponent
    self.news_feed = galactic_display:get_component("news_feed")

    crossplot:subscribe("TACTICAL_BOARDED_UNITS", self.process_boarded_units, self)
    gc.Events.TacticalBattleEnded:attach_listener(self.on_battle_end, self)
end

function BoardingListener:on_battle_end()
    --Logger:trace("entering BoardingListener:on_battle_end")
    crossplot:publish("PROCESS_BOARDING", "empty")
end

function BoardingListener:process_boarded_units(boarded_units)
    --Logger:trace("entering BoardingListener:process_boarded_units")
    DebugMessage("BoardingListener process_boarded_units Started")
    local friendly_planet_by_owner = {}
    local human_owner = nil
    for _, boarding_data in pairs(boarded_units) do
        local owner = Find_Player(boarding_data.owner_name)
        if owner.Is_Human() then
            human_owner = owner
        end

        if not friendly_planet_by_owner[boarding_data.owner_name] then
            friendly_planet_by_owner[boarding_data.owner_name] = GalacticUtil.find_friendly_planet(owner)
        end

        local friendly_planet = friendly_planet_by_owner[boarding_data.owner_name]
        if friendly_planet then
            local object_type = Find_Object_Type(boarding_data.unit_type_name)
            DebugMessage(
                "BoardingListener -- Spawning boarded units. Object Type: %s, New Owner: %s",
                boarding_data.unit_type_name,
                boarding_data.owner_name
            )
            Spawn_Unit(object_type, friendly_planet, owner)
        end
    end

    self:post_to_news_feed(human_owner, friendly_planet_by_owner)
    DebugMessage("BoardingListener process_boarded_units Finished")
end

function BoardingListener:post_to_news_feed(human_owner, friendly_planet_by_owner)
    --Logger:trace("entering BoardingListener:post_to_news_feed")
    DebugMessage("BoardingListener post_to_news_feed Started")
    if not human_owner then
        return
    end

    local friendly_planet = friendly_planet_by_owner[human_owner.Get_Faction_Name()]
    if not friendly_planet then
        return
    end

    self.news_feed:post {
        headline = "TEXT_SINGLE_UNIT_RETREAT_PLANET",
        var = friendly_planet
    }
    DebugMessage("BoardingListener post_to_news_feed Finished")
end
