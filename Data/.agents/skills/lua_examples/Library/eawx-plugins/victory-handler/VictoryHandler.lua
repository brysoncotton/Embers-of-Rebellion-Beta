require("deepcore/std/class")
require("eawx-util/GalacticUtil")
require("eawx-util/StoryUtil")
CONSTANTS = ModContentLoader.get("GameConstants")

---@class VictoryHandler
VictoryHandler = class()

function VictoryHandler:new(gc_events)
    self.human_player = Find_Player("local")
    self.human_player_name = self.human_player.Get_Faction_Name()

    self.human_team_alias = nil
    if Find_Object_Type("fotr") ~= nil then
        if self.human_player_name ~= "HUTT_CARTELS" then
            if self.human_player_name == "REBEL" then
                self.human_team_alias = "CIS"
            else
                self.human_team_alias = "REPUBLIC"
            end
        end
    end

    self.all_planet_names = {}
    self.shipyard_planet_names = {}
    self.ShipyardVictoryObjectUnlocked = false
    self.ConquestVictoryObjectUnlocked = false

    for planet_name, _ in pairs(StoryUtil.GetSafePlanetTable()) do
        table.insert(self.all_planet_names, planet_name)
        if EvaluatePerception("Max_Shipyard_Level", self.human_player, FindPlanet(planet_name)) >= 3 then
            table.insert(self.shipyard_planet_names, planet_name)
        end
    end

    gc_events.PlanetOwnerChanged:attach_listener(self.on_planet_owner_changed, self)
    gc_events.GalacticProductionFinished:attach_listener(self.on_production_finished, self)

    self.victory_handler_shipyards_available = Observable()
    self.victory_handler_conquest_available = Observable()
end

function VictoryHandler:on_planet_owner_changed(planet, new_owner_name, old_owner_name)
    --Logger:trace("entering VictoryHandler:on_planet_owner_changed")
    if new_owner_name ~= self.human_player_name then
        return
    end

    local locked_planet_names = GlobalValue.Get("LOCKED_PLANETS")
    if locked_planet_names == nil then
        locked_planet_names = {}
    end

    if self.ShipyardVictoryObjectUnlocked == false then
        self:shipyard_victory_check(locked_planet_names)
    end

    if self.ConquestVictoryObjectUnlocked == false then
        self:conquest_victory_check(locked_planet_names)
    end
end

function VictoryHandler:shipyard_victory_check(locked_planet_names)
    local should_unlock_victory_object = self:planet_ownership_checker(locked_planet_names,self.shipyard_planet_names)

    if should_unlock_victory_object == true then
        UnitUtil.SetLockList(self.human_player_name, {"Shipyard_Victory_Object"})
        self.ShipyardVictoryObjectUnlocked = true
        self.victory_handler_shipyards_available:notify(self.human_player_name)
    end
end

function VictoryHandler:conquest_victory_check(locked_planet_names)
    local should_unlock_victory_object = self:planet_ownership_checker(locked_planet_names,self.all_planet_names)

    if should_unlock_victory_object == true then
        UnitUtil.SetLockList(self.human_player_name, {"Conquest_Victory_Object"})
        self.ConquestVictoryObjectUnlocked = true
        self.victory_handler_conquest_available:notify(self.human_player_name)
    end
end

function VictoryHandler:planet_ownership_checker(locked_planet_names,all_relevant_planet_names)
    for _, planet_name in pairs(all_relevant_planet_names) do
        local locked_planet = false
        for i,locked_planet_name in pairs(locked_planet_names) do
            if locked_planet_name == planet_name then
                locked_planet = true
                table.remove(locked_planet_names,i)
                break
            end
        end

        if locked_planet == false then
            local planet_owner = FindPlanet(planet_name).Get_Owner()

            if self.human_team_alias ~= nil then
                if self.human_team_alias ~= CONSTANTS.ALIASES[planet_owner.Get_Faction_Name()] then
                    return false
                end
            else
                if self.human_player ~= planet_owner then
                    return false
                end
            end
        end
    end

    return true
end

function VictoryHandler:on_production_finished(planet, game_object_type_name)
    --Logger:trace("entering VictoryHandler:on_production_finished")
    --DebugMessage("In VictoryHandler:on_production_finished")
    if game_object_type_name ~= "SHIPYARD_VICTORY_OBJECT" and game_object_type_name ~= "CONQUEST_VICTORY_OBJECT" then
        return
    end

    if GlobalValue.Get("ENDING") == nil and game_object_type_name == "SHIPYARD_VICTORY_OBJECT" then
        GlobalValue.Set("ENDING","SHIPYARD")
    end

    StoryUtil.DeclareVictory(self.human_player, true)
end

return VictoryHandler
