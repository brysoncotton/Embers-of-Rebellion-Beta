require("deepcore/std/class")
require("deepcore/crossplot/crossplot")
require("PGStoryMode")
require("eawx-util/Sort")

require("eawx-util/StoryUtil")
require("eawx-util/UnitUtil")

---@class GovernmentHutts
GovernmentHutts = class()

function GovernmentHutts:new(gc, id)
    self.HuttPlayer = Find_Player("Hutt_cartels")
    self.id = id
    self.planets = {}
    --This will be a library file per mod, and gets overwritten on first build from the gamescoring plugin.
    self.GardenForces = require("roster-sets/BOOTANA_HUTTA_UNITS")
    self.smuggling_income = 0
    self.smuggler_limit = (10 * EvaluatePerception("Smuggler_Limit_Structures_Count", self.HuttPlayer))
    self.deployed_smugglers = 0
    self.smuggling_initialized = false

    gc.Events.GalacticProductionFinished:attach_listener(self.on_production_finished, self)
    gc.Events.PlanetOwnerChanged:attach_listener(self.on_planet_owner_changed, self)

    for _, planet in pairs(gc.Planets) do
        self.planets[planet] = {
            criminal_network_level = 0,
            cycle_starting_criminal_network_level = 0,
            name = planet:get_readable_name(),
            base_income = EvaluatePerception("PlanetTrueBaseIncome", self.HuttPlayer, planet:get_game_object())
        }
        GlobalValue.Set(planet:get_name().."_SMUGGLING_LEVEL", 0)
    end

    crossplot:subscribe("UPDATE_GARDEN_FORCES", self.UpdateTable, self)
end

function GovernmentHutts:update()
    DebugMessage("In GovernmentHutts:update")
    local smuggler_list = Find_All_Objects_Of_Type("Smuggler")
    self.smuggler_limit = (10 * EvaluatePerception("Smuggler_Limit_Structures_Count", self.HuttPlayer))
	
	GlobalValue.Set("HUTT_SMUGGLING_CAPACITY", self.smuggler_limit - self.deployed_smugglers)

    for planet, planet_stats in pairs(self.planets) do
        self.planets[planet].cycle_starting_criminal_network_level = self.planets[planet].criminal_network_level
    end

    if self.smuggling_initialized == false then
        self.smuggling_initialized = true
        return
    end
 
    local running_total_scum = 0
    
    for _, smuggler in pairs(smuggler_list) do
        local location = smuggler.Get_Planet_Location()
        if TestValid(location) then
            if location.Get_Owner() ~= self.HuttPlayer then
                for planet, planet_stats in pairs(self.planets) do
                    if planet:get_game_object() == location then
                        if self.planets[planet].criminal_network_level < 5 
                        and (self.planets[planet].criminal_network_level < (self.planets[planet].cycle_starting_criminal_network_level + 1 )) then
                            if self.smuggler_limit > self.deployed_smugglers then 
                                running_total_scum = running_total_scum + 1
                                self.deployed_smugglers = self.deployed_smugglers + 1
                                self.planets[planet].criminal_network_level = self.planets[planet].criminal_network_level + 1
                                GlobalValue.Set(planet:get_name().."_SMUGGLING_LEVEL",  self.planets[planet].criminal_network_level)
                                smuggler.Despawn()
                            else
                                if self.HuttPlayer == Find_Player("local") then
                                    StoryUtil.ShowScreenText("More cantinas are required to continue deploying Smugglers.", 10)
                                end
                            end
                        end
                        break
                    end
                end
            end
        end
    end

    crossplot:publish("INCREASE_FAVOUR", "SCUM", running_total_scum)
    
    self.smuggling_income = 0
    for planet, planet_stats in pairs(self.planets) do
        if self.planets[planet].criminal_network_level > 0 then 
            planet:get_game_object().Attach_Particle_Effect("Display_Smuggler_"..tostring(planet_stats.criminal_network_level)) 
            self.smuggling_income = self.smuggling_income + (planet_stats.criminal_network_level * 0.2 * planet_stats.base_income)
            self.smuggling_income = tonumber(Dirty_Floor(self.smuggling_income))
        end
    end

    self.HuttPlayer.Give_Money(self.smuggling_income)
    GlobalValue.Set("HUTT_SMUGGLING_INCOME",self.smuggling_income)
    if self.HuttPlayer.Is_Human() then
        crossplot:publish("SMUGGLING_INCOME", self.smuggling_income)
    end
end

function GovernmentHutts:on_planet_owner_changed(planet, new_owner_name, old_owner_name)
    --Logger:trace("entering GovernmentHutts:on_planet_owner_changed")
    if new_owner_name == "HUTT_CARTELS" then
        self.deployed_smugglers = self.deployed_smugglers - self.planets[planet].criminal_network_level
        self.planets[planet].criminal_network_level = 0
    else
        if self.planets[planet].criminal_network_level > 0 then
            self.planets[planet].criminal_network_level = self.planets[planet].criminal_network_level - 1
            GlobalValue.Set(planet:get_name().."_SMUGGLING_LEVEL",  self.planets[planet].criminal_network_level)
            self.deployed_smugglers = self.deployed_smugglers - 1
        end
    end
end

function GovernmentHutts:on_production_finished(planet, game_object_type_name)
    DebugMessage("In GovernmentHutts:on_production_finished")
    if planet:get_owner() ~= self.HuttPlayer then
        return
    end
    if string.find(game_object_type_name, "BH_GALACTIC_") then
        local planet_object = planet:get_game_object()
        local target_object = string.gsub(game_object_type_name, "BH_GALACTIC_", "")
        local target_dummy = string.gsub(game_object_type_name, "GALACTIC_", "")
	
		if not self.HuttPlayer.Is_Human() then
			target_dummy = string.gsub(target_dummy, "_AI", "")
			crossplot:publish("ADD_TO_BOOTANA", target_dummy)
			self.table_setup = true
		else
			for _, ship in pairs(Find_All_Objects_Of_Type(target_object)) do
				if planet_object == ship.Get_Planet_Location() then
					crossplot:publish("ADD_TO_BOOTANA", target_dummy)
					ship.Despawn()
					self.table_setup = true
					break
				end
			end
		end
    end
end

function GovernmentHutts:UpdateTable(bootana_table)
    --Logger:trace("entering GovernmentHutts:UpdateDisplay")
    self.GardenForces = bootana_table
end

function GovernmentHutts:UpdateDisplay(favour)
    local plot = Get_Story_Plot("Conquests\\Player_Agnostic_Plot.xml")
    local government_display_event = plot.Get_Event("Government_Display")

    self.smuggler_limit = (10 * EvaluatePerception("Smuggler_Limit_Structures_Count", self.HuttPlayer))

    government_display_event.Set_Reward_Parameter(1, "HUTT_CARTELS")

    government_display_event.Clear_Dialog_Text()

    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HUTTS")
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")

    government_display_event.Add_Dialog_Text("TEXT_NONE")
    
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HUTTS_OVERVIEW_HEADER")
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HUTTS_OVERVIEW") -- Add variable for Bootana Hutta entrance location when it exists
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")

    for i, ship in ipairs(SortKeysByElement(self.GardenForces,"order","asc")) do
        local entry = self.GardenForces[ship]
        government_display_event.Add_Dialog_Text(
           "- "..entry.name..": "..tostring(entry.amount)
        )
    end
    
    government_display_event.Add_Dialog_Text("TEXT_NONE")

    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HUTTS_EMPIRE_HEADER")
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HUTTS_EMPIRE_OVERVIEW") -- Add variable for Bootana Hutta entrance location when it exists
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")

    government_display_event.Add_Dialog_Text("Hutt Mobilization Support: ".. tostring(favour["HUTT_MOBILIZATION"].favour).." / "..tostring(favour["HUTT_MOBILIZATION"].max_value))
    government_display_event.Add_Dialog_Text("TEXT_NONE")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HUTTS_MOBLIZATION_REWARDS")

    local empire_rewards = {}

    for _, reward in pairs(favour["HUTT_MOBILIZATION"].reward_list) do
        table.insert(empire_rewards,reward)
    end

    for _, reward in pairs(favour["HUTT_MOBILIZATION"].spawned_rewards) do
        table.insert(empire_rewards,reward)
    end

    for i, reward in ipairs(SortKeysByElement(empire_rewards,"threshold","asc")) do
        local entry = empire_rewards[reward]
        
        local autospawn = ""    
        if empire_rewards[reward].unique == true then
            autospawn = " (Automatic Spawn)"
        end
        
        government_display_event.Add_Dialog_Text(
           "- "..entry.tag.." - Support Requirement: "..tostring(entry.threshold)..autospawn
        )
    end

    government_display_event.Add_Dialog_Text("TEXT_NONE")
    
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HUTTS_SCUM_HEADER")
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HUTTS_SCUM_OVERVIEW")
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")

    government_display_event.Add_Dialog_Text("Criminal Underworld Support: ".. tostring(favour["SCUM"].favour).." / "..tostring(favour["SCUM"].max_value))
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HUTT_SMUGGLING_INCOME", self.smuggling_income)
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HUTT_SMUGGLING_DEPLOYED", self.deployed_smugglers)
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HUTT_SMUGGLING_LIMIT", self.smuggler_limit)
    government_display_event.Add_Dialog_Text("TEXT_NONE")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HUTTS_SCUM_REWARDS")

    local scum_rewards = {}

    for _, reward in pairs(favour["SCUM"].reward_list) do
        table.insert(scum_rewards,reward)
    end

    for _, reward in pairs(favour["SCUM"].spawned_rewards) do
        table.insert(scum_rewards,reward)
    end

    for i, reward in ipairs(SortKeysByElement(scum_rewards,"threshold","asc")) do
        local entry = scum_rewards[reward]
        
        local autospawn = ""    
        if scum_rewards[reward].unique == true then
            autospawn = " (Automatic Spawn)"
        end
        
        government_display_event.Add_Dialog_Text(
           "- "..entry.tag.." - Support Requirement: "..tostring(entry.threshold)..autospawn
        )
    end

    government_display_event.Add_Dialog_Text("TEXT_NONE")
    government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HUTTS_SCUM_AMOUNTS")

    local num_networks = 0

    for i, planet in ipairs(SortKeysByElement(self.planets,"name","asc")) do
        local planet_entry = self.planets[planet]
        if planet_entry.criminal_network_level > 0 then
            num_networks = num_networks + 1
            government_display_event.Add_Dialog_Text(planet_entry.name .. " - Level: ".. tostring(planet_entry.criminal_network_level) .. " Income: ".. tostring(Dirty_Floor(planet_entry.criminal_network_level * 0.2 * planet_entry.base_income)))
        end
    end

    if num_networks == 0 then
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HUTT_SMUGGLING_NONE_DEPLOYED")
    end

    Story_Event("GOVERNMENT_DISPLAY")
end

return GovernmentHutts