require("PGBase")
require("PGSpawnUnits")
require("deepcore/std/class")
require("deepcore/crossplot/crossplot")
require("eawx-util/StoryUtil")
require("eawx-util/UnitUtil")

---@class BootanaHutta
BootanaHutta = class()

function BootanaHutta:new()

    self.player_name = "Hutt_Cartels"
    self.player = Find_Player("Hutt_Cartels")
	self.ai_hutts = self.player.Is_Human() == false
    self.has_valid_spawner = false
    self.GardenForces = require("roster-sets/BOOTANA_HUTTA_UNITS")

    self.called_unit_table = {}
    self.surviving_unit_table = {}
    self.Active_Planets = StoryUtil.GetSafePlanetTable()
    self.spawn_marker = nil
    self.bootana_empty = false
    
    self.last_access = 0
    self.is_tactical = false

    crossplot:subscribe("GAME_MODE_STARTING", self.mode_start, self)
    crossplot:subscribe("PROCESS_BOARDING", self.spawn_survivors, self)
    crossplot:subscribe("GAME_MODE_ENDING", self.battle_end, self)
    crossplot:subscribe("ADD_TO_BOOTANA", self.add_to_list, self)
    crossplot:subscribe("TACTICAL_PRODUCTION_FINISHED", self.tactical_construction_finished, self)
end

function BootanaHutta:update()
    if self.is_tactical then
		if self.ai_hutts and not self.bootana_empty and (GetCurrentTime() - self.last_access) > 30 then
            self.has_valid_spawner = self:check_hutt_shipyards()
            if self.has_valid_spawner then
                local desire = EvaluatePerception("Need_Bootana_Unit", self.player)
                            
                if desire == nil then
                    return
                end
                
                if desire > 0 then
                    local random_table = {}
                    for ship, entry in pairs(self.GardenForces) do
                        if entry.amount > 0 then
                            table.insert(random_table, ship)
                        end
                    end
                    if table.getn(random_table) > 0 then
                        self.last_access = GetCurrentTime()
                        local random_index = GameRandom.Free_Random(0, table.getn(random_table))
                        self:tactical_construction_finished(random_table[random_index])
                    else
                        self.bootana_empty = true
                    end
                end
            end
        end
    end
end

function BootanaHutta:add_to_list(object_name)
    self.GardenForces[object_name].amount = self.GardenForces[object_name].amount  + 1
    if self.player.Is_Human() then
        StoryUtil.ShowScreenText("Added " .. self.GardenForces[object_name].name .. " to Bootana Hutta forces.", 10)
    end
    crossplot:publish("UPDATE_GARDEN_FORCES", self.GardenForces)
end

function BootanaHutta:mode_start(mode)

    if mode == "Space" then
        self.has_valid_spawner = self:check_hutt_shipyards()
        self.is_tactical = true
        self.bootana_empty = false
        local object = Find_First_Object("BH_GARDEN_ACCESS")
        if TestValid(object) then
            object.Despawn()
        end
        self.spawn_marker = Find_First_Object("Map_Corner")

        for ship, entry in pairs(self.GardenForces) do
            if entry.amount > 0 then
                UnitUtil.TacticalUnlock(ship, "Hutt_Cartels")
            end
        end
    else
        self.is_tactical = false
    end

end

function BootanaHutta:check_hutt_shipyards()
    local list_of_structures = {"Hutt_Shipyard_Level_One", "Hutt_Shipyard_Level_Two", "Hutt_Shipyard_Level_Three", "Hutt_Shipyard_Level_Four", "Pirate_Base"}
    local present = false
    for _, structure in pairs(list_of_structures) do
        if Find_First_Object(structure) then
            present = true
        end
    end

    return present

end

function BootanaHutta:spawn_survivors()
	-- Make this prefer the last battle location if possible
	StoryUtil.SpawnAtSafePlanet("NAL_HUTTA", self.player, self.Active_Planets, self.surviving_unit_table)
	self.surviving_unit_table = {}
	crossplot:publish("UPDATE_GARDEN_FORCES", self.GardenForces)
end

function BootanaHutta:battle_end(mode)

    if mode == "Space" then 
        for _, unit in pairs(self.called_unit_table) do
            if TestValid(unit) then
                local unit_name = unit.Get_Type().Get_Name()
                table.insert(self.surviving_unit_table, unit_name)
            end
        end

        self.is_tactical = false
        self.called_unit_table = {}
    end
  
end

function BootanaHutta:tactical_construction_finished(object_name, player)

        for ship_name, entry in pairs(self.GardenForces) do
	 		if ship_name == object_name then
                local unit_name = string.gsub(ship_name, "BH_", "")

                if self.GardenForces[object_name].amount > 0 then
                    local spawned_units = SpawnList({unit_name}, self.spawn_marker, self.player, true, false)
                    --local unit_type = Find_Object_Type(unit_name)
                    --local spawned_unit = Reinforce_Unit(unit_type,Find_First_Object("Defending Forces Position"),self.player,true,false)
                    self.GardenForces[object_name].amount = self.GardenForces[object_name].amount - 1
                    if self.GardenForces[object_name].amount <= 0 then
                        self.GardenForces[object_name].amount = 0
                        UnitUtil.TacticalLock(object_name)
                    end
                    --table.insert(self.called_unit_table, spawned_unit)
                    for _, unit in pairs(spawned_units) do
                        table.insert(self.called_unit_table, unit)
                    end
                    if self.player.Is_Human() then
                        StoryUtil.ShowScreenText(entry.name .." called. ".. tostring(entry.amount) .. " remaining in Bootana Hutta", 10)
                    else
                        self.player.Give_Money(0-self.GardenForces[object_name].cost)
                    end
                end
                
			end
			
		end
  
end

return BootanaHutta