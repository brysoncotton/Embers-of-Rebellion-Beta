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
--*       File:              DummyBasedResourceManager.lua                                         *
--*       File Created:      Sunday, 23rd February 2020 05:01                                      *
--*       Author:            [TR] Pox                                                              *
--*       Last Modified:     Monday, 24th February 2020 12:45                                      *
--*       Modified By:       [TR] Pox                                                              *
--*       Copyright:         Thrawns Revenge Development Team                                      *
--*       License:           This code may not be used without the author's explicit permission    *
--**************************************************************************************************

require("deepcore/std/class")
require("deepcore/std/Observable")
require("eawx-util/GalacticUtil")
require("eawx-util/StoryUtil")

---@class DummyBasedResourceManager
DummyBasedResourceManager = class()

---@param gc GalacticConquest
---@param ai_dummy_handler KeyDummyLifeCycleHandler
function DummyBasedResourceManager:new(gc, ai_dummy_handler, selected_planet_changed_event)
    ---@private
    self.crew_resource_dummy_name = "Crew_Resource_Dummy"

    ---@private
    self.crew_resource_dummy_type = Find_Object_Type("Crew_Resource_Dummy")

    ---@private
    self.placeholder_dummy_type_name = "Placeholder_Category_Dummy"

    ---@private
    ---@type GameObject[]
    self.player_dummies = {}

    self.ship_crews = 50

    self.ship_crew_tiers = {
        Ship_Crew_Tier_12 = 300,
        Ship_Crew_Tier_11 = 150,
        Ship_Crew_Tier_10 = 50,
        Ship_Crew_Tier_9 = 40,
        Ship_Crew_Tier_8 = 35,
        Ship_Crew_Tier_7 = 30,
        Ship_Crew_Tier_6 = 25,
        Ship_Crew_Tier_5 = 20,
        Ship_Crew_Tier_4 = 15,
        Ship_Crew_Tier_3 = 10,
        Ship_Crew_Tier_2 = 5,
        Ship_Crew_Tier_1 = 1
    }

    selected_planet_changed_event:attach_listener(self.on_selected_planet_changed, self)
    gc.Events.GalacticProductionStarted:attach_listener(self.on_production_queued, self)
    gc.Events.GalacticProductionCanceled:attach_listener(self.on_production_canceled, self)

    ai_dummy_handler:add_to_dummy_set("AI_PLANET", self:get_ai_dummy_table())

    self.resources_changed_event = Observable()
end

---@private
function DummyBasedResourceManager:get_ai_dummy_table()
    return {
    }
end

---@param planet Planet
function DummyBasedResourceManager:on_selected_planet_changed(planet)
    if not planet:get_owner().Is_Human() then
        return
    end

    self:refresh_player_dummies(planet)
end

---@param planet Planet
---@param game_object_type_name string
function DummyBasedResourceManager:on_production_queued(planet, game_object_type_name)
    DebugMessage("In ResourceManager:on_production_queued")
    if not planet:get_owner().Is_Human() then
        return
    end

    local removed_resources = self:remove_resources(game_object_type_name)

    if not removed_resources then
        return
    end

    self:refresh_player_dummies(planet)
    self.resources_changed_event:notify(self.ship_crews)
end

---@private
---@param game_object_type_name string
function DummyBasedResourceManager:remove_resources(game_object_type_name)
    if not GameObjectLibrary.Units[game_object_type_name] then
        DebugMessage("Did not find GameObjectLibrary entry for %s. Returning.", tostring(game_object_type_name))
        return false
    end

    local resource = GameObjectLibrary.Units[game_object_type_name].Ship_Crew_Requirement

    if not resource then
        DebugMessage(
            "Did not find GameObjectLibrary Ship Crew Requirement for %s. Returning.",
            tostring(game_object_type_name)
        )
        return false
    end

    self.ship_crews = self.ship_crews - resource

    return true
end

function DummyBasedResourceManager:add_resources(income)

    self.ship_crews = self.ship_crews + income

    self.resources_changed_event:notify(self.ship_crews)

end

---@param planet Planet
function DummyBasedResourceManager:on_production_canceled(planet, game_object_type_name)
    DebugMessage("In ResourceManager:on_production_canceled")
    if not planet:get_owner().Is_Human() then
        return
    end

    if not GameObjectLibrary.Units[game_object_type_name] then
        DebugMessage("Did not find GameObjectLibrary entry for %s. Returning.", tostring(game_object_type_name))
        return
    end

    local resource = GameObjectLibrary.Units[game_object_type_name].Ship_Crew_Requirement

    if not resource then
        DebugMessage(
            "Did not find GameObjectLibrary Ship Crew Requirement for %s. Returning.",
            tostring(game_object_type_name)
        )
        return
    end

    self.ship_crews = self.ship_crews + resource

    self:refresh_player_dummies(planet)
    self.resources_changed_event:notify(self.ship_crews)
end

---@private
function DummyBasedResourceManager:refresh_player_dummies(planet)
    for _, dummy in pairs(self.player_dummies) do
        if TestValid(dummy) then
            dummy.Despawn()
        end
    end

    self.player_dummies =
        GalacticUtil.spawn {
        objects = self:get_required_dummy_types(),
        owner = planet:get_owner(),
        location = planet:get_game_object()
    }
end

function DummyBasedResourceManager:get_required_dummy_types()
    local required_dummies = {}

    for dummy_type_name, tier_limit in pairs(self.ship_crew_tiers) do
        if self.ship_crews >= tier_limit then
            required_dummies[dummy_type_name] = 1
        else
            if not required_dummies[self.placeholder_dummy_type_name] then
                required_dummies[self.placeholder_dummy_type_name] = 0
            end

            required_dummies[self.placeholder_dummy_type_name] = required_dummies[self.placeholder_dummy_type_name] + 1
        end
    end

    return required_dummies
end
