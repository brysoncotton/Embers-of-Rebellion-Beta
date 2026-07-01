require("deepcore/std/class")
require("eawx-util/StoryUtil")
CONSTANTS = ModContentLoader.get("GameConstants")
require("deepcore/crossplot/crossplot")

PatronHandler = class()

function PatronHandler:new(galactic_conquest, human_player)
    self.patron_playthrough = false
    self.need_initial_swaps = false

    if not self.patron_playthrough then
        return
    end

    self.need_initial_swaps = true

    self.galactic_conquest = galactic_conquest
    self.human_player = human_player

    self.table_added = 0

    self.patron_list = require("PatronList")
    GlobalValue.Set("PATRON_PLAYTHROUGH", true)

    galactic_conquest.Events.GalacticProductionFinished:attach_listener(self.on_construction_finished, self)
    galactic_conquest.Events.GalacticProductionStarted:attach_listener(self.on_production_queued, self)

    crossplot:subscribe("LIMITED_UNIT_KILLED", self.patron_killed, self)
    crossplot:subscribe("UPDATE_GOVERNMENT", self.patron_swaps, self)
end

function PatronHandler:update()
    --Logger:trace("entering PatronHandler:update")
    if not self.need_initial_swaps then
        return
    end

    if not self.patron_playthrough then
        return
    end

    for unit, data in pairs(self.patron_list) do
        if data.existing == false then
            if TestValid(Find_Object_Type(unit)) then
                self.patron_list[unit].existing = true
            end
        end
    end

    local allUnitInstances = Find_All_Objects_Of_Type(self.human_player) 
    for i, unitInstance in pairs(allUnitInstances) do
        if TestValid(unitInstance) then
            local type = unitInstance.Get_Type().Get_Name()
            for unit, data in pairs(self.patron_list) do
                if data.existing == true then
                    if data.unit_name == type and self.patron_list[unit].alive == false then
                        UnitUtil.ReplaceAtLocation(unitInstance, unit)
                        self.patron_list[unit].alive = true
                        StoryUtil.ShowScreenText(self.patron_list[unit].custom_name .." has entered service", 10)
                        break
                    end
                end
            end
        end
    end

    self.need_initial_swaps = false
end

function PatronHandler:on_production_queued(planet, game_object_type_name)
    --Logger:trace("entering PatronHandler:on_production_queued")
    if planet:get_owner() ~= self.human_player then
        return
    end

    local number = 0
    for unit, data in pairs(self.patron_list) do
        if data.unit_name == game_object_type_name and data.deaths < 3 and data.alive == false and data.existing == true then
            number = number + 1
        end
    end

    if number == 0 then
        return
    end

    StoryUtil.ShowScreenText("Patrons in category: "..tostring(number), 10)
end

function PatronHandler:on_construction_finished(planet, game_object_type_name)
    --Logger:trace("entering PatronHandler:on_construction_finished")
    if planet:get_owner() ~= self.human_player then
        return
    end

    local planet_object = planet:get_game_object()
    if game_object_type_name == "PATRON_LIST_UPDATE" then
        self.table_added = self.table_added + 1
        local added_patron_list = require("PatronList"..tostring(self.table_added))
        for new_unit_name, new_unit_stats in pairs(added_patron_list) do
            self.patron_list[new_unit_name] = new_unit_stats
        end
    end

    for unit, data in pairs(self.patron_list) do
        if data.unit_name == game_object_type_name and data.deaths < 3 and data.alive == false and data.existing == true then
            local unit_to_replace = nil
            local allUnitInstances = Find_All_Objects_Of_Type(self.human_player, game_object_type_name) or {}
            for i, unitInstance in pairs(allUnitInstances) do
                if TestValid(unitInstance) then
                    local unitPlanet = unitInstance.Get_Planet_Location()
                    if unitPlanet == planet_object then
                        unit_to_replace = unitInstance
                        break
                    end
                end
            end
            if unit_to_replace ~= nil then
                UnitUtil.ReplaceAtLocation(unit_to_replace, unit)
                self.patron_list[unit].alive = true
                StoryUtil.ShowScreenText(self.patron_list[unit].custom_name .." has entered service", 10)
                break
            end
        end
    end
end

function PatronHandler:patron_killed(object_name, owner_name)
    --Logger:trace("entering PatronHandler:patron_killed")
    if not self.patron_list[object_name] then
        return
    end

    self.patron_list[object_name].alive = false
    self.patron_list[object_name].deaths = self.patron_list[object_name].deaths + 1
    StoryUtil.ShowScreenText(self.patron_list[object_name].custom_name .." has been destroyed", 10)
end

return PatronHandler
