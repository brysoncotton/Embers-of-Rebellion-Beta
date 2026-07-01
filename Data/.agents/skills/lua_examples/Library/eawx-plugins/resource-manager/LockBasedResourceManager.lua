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
--*       File:              LockBasedResourceManager.lua                                          *
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
require("PGStoryMode")

require("eawx-util/UnitUtil")
ModContentLoader = require("eawx-std/ModContentLoader")

---@class LockBasedResourceManager
LockBasedResourceManager = class()

---@param gc GalacticConquest
function LockBasedResourceManager:new(gc, options_handler)
    self.options_handler = options_handler

    self.human = Find_Player("local")
    self.player_id = string.upper(self.human.Get_Faction_Name())

    self.starting_ship_crews = 250
    self.ship_crews = self.starting_ship_crews
    self.ship_crew_income = "Pending"
    self.ship_crew_income_display_initialized = false

    self.player_unit_list = self:build_costed_roster()
    self:update_availability()

    gc.Events.GalacticProductionStarted:attach_listener(self.on_production_queued, self)
    gc.Events.GalacticProductionCanceled:attach_listener(self.on_production_canceled, self)
    gc.Events.TacticalBattleEnded:attach_listener(self.on_battle_end, self)
    crossplot:subscribe("UPDATE_AVAILABILITY", self.update_availability, self)
    crossplot:subscribe("TACTICAL_CREW_UPDATE", self.tactical_crew_update, self)

    self.resources_changed_event = Observable()
end

function LockBasedResourceManager:build_costed_roster()
    --Logger:trace("entering LockBasedResourceManager:build_costed_roster")
    local roster = require("roster-sets/"..self.player_id)
    local influence_roster = require("roster-sets/INFLUENCE")

    for unit, cost in pairs(influence_roster) do
        roster[unit] = 0
    end

    for unit, cost in pairs(roster) do
        local updated_cost = 0

        updated_cost = ModContentLoader.get_object_script(unit).Ship_Crew_Requirement
        if updated_cost == nil then
            updated_cost = 0
        end

        roster[unit] = updated_cost
    end

    return roster
end

---@private
---@param game_object_type_name string
function LockBasedResourceManager:remove_resources(game_object_type_name)
    if not self.player_unit_list[game_object_type_name] then
        DebugMessage("Did not find roster entry for %s. Returning.", tostring(game_object_type_name))
        return false
    end
    --Logger:trace("entering LockBasedResourceManager:remove_resources")
    local resource = self.player_unit_list[game_object_type_name]

    if not resource then
        DebugMessage(
            "Did not find Ship Crew Requirement for %s. Returning.",
            tostring(game_object_type_name)
        )
        return false
    end

    self.ship_crews = self.ship_crews - resource
    crossplot:publish("UPDATE_CREWS", self.ship_crews)

    return true
end

function LockBasedResourceManager:set_ship_crew_income(ship_crew_income,initialize_display)
    --Logger:trace("entering LockBasedResourceManager:set_ship_crew_income")

    if initialize_display == true then
        self.ship_crew_income_display_initialized = true
    end

    if self.ship_crew_income_display_initialized == true then
        self.ship_crew_income = ship_crew_income
    end

    if initialize_display == true then
        self.resources_changed_event:notify(self.ship_crews, self.ship_crew_income)
    end
end

function LockBasedResourceManager:add_ship_crews(change_amount)
    --Logger:trace("entering LockBasedResourceManager:add_resources")
    self.ship_crews = self.ship_crews + change_amount
    self:update_availability()

    self.resources_changed_event:notify(self.ship_crews, self.ship_crew_income)
    crossplot:publish("UPDATE_CREWS", self.ship_crews)
end

function LockBasedResourceManager:tactical_crew_update(ship_crews)
    --Logger:trace("entering LockBasedResourceManager:tactical_crew_update")
    self.ship_crews = ship_crews
    self:update_availability()
    self.resources_changed_event:notify(self.ship_crews, self.ship_crew_income)
end

---@param planet Planet
---@param game_object_type_name string
function LockBasedResourceManager:on_production_queued(planet, game_object_type_name)
    DebugMessage("In ResourceManager:on_production_queued")
    if not planet:get_owner().Is_Human() then
        return
    end
    --Logger:trace("entering LockBasedResourceManager:on_production_queued")
    local removed_resources = self:remove_resources(game_object_type_name)

    if not removed_resources then
        return
    end

    self:update_availability()
    self.resources_changed_event:notify(self.ship_crews, self.ship_crew_income)
end

---@param planet Planet
function LockBasedResourceManager:on_production_canceled(planet, game_object_type_name)
    DebugMessage("In ResourceManager:on_production_canceled")
    if not planet:get_owner().Is_Human() then
        return
    end
    --Logger:trace("entering LockBasedResourceManager:on_production_canceled")
    if not self.player_unit_list[game_object_type_name] then
        DebugMessage("Did not find GameObjectLibrary entry for %s. Returning.", tostring(game_object_type_name))
        return
    end

    local resource = self.player_unit_list[game_object_type_name]

    if not resource then
        DebugMessage(
            "Did not find GameObjectLibrary Ship Crew Requirement for %s. Returning.",
            tostring(game_object_type_name)
        )
        return
    end

    self.ship_crews = self.ship_crews + resource

    self:update_availability()
    self.resources_changed_event:notify(self.ship_crews, self.ship_crew_income)
end

function LockBasedResourceManager:update_availability()
    --Logger:trace("entering LockBasedResourceManager:update_availability")
    for unit_type_name, ship_cost in pairs(self.player_unit_list) do
        if self.options_handler.cheat_crews_on == true then
            UnitUtil.SetBuildable(self.human, unit_type_name, true)
        elseif self.ship_crews >= ship_cost then
            UnitUtil.SetBuildable(self.human, unit_type_name, true)
        else
            UnitUtil.SetBuildable(self.human, unit_type_name, false)
        end
    end

    -- crossplot:publish("UPDATED_AVAILABILITY", "empty")
end

function LockBasedResourceManager:on_battle_end()
    --Logger:trace("entering LockBasedResourceManager:on_battle_end")

    crossplot:publish("CREW_BATTLE_ENDED", "empty")

end

return LockBasedResourceManager
