require("eawx-util/ChangeOwnerUtilities")
require("eawx-util/RandomDistribution")
require("UnitSpawnerTables")
CONSTANTS = ModContentLoader.get("GameConstants")

-- Changes Planet owner to new Owner and randomly populates with fleet adjusted around inserted combat power value
function ChangePlanetOwnerAndPopulate(planet, newOwner, combat_power, overrideOwner, consider_infrastructure)

	-- Possible spawning units
		-- Arranged as Unit_Table = {{Find_Object_Type("Unit_Name"), weight}}

	local factionString = newOwner.Get_Faction_Name()
	local rosterOverride = DefineRosterOverride(planet.Get_Type().Get_Name())

	if overrideOwner then
		if type(overrideOwner) == "string" then
			if overrideOwner == "RANDOM" then
				if not rosterOverride then
					local num = table.getn(CONSTANTS.ALL_FACTIONS_NOT_NEUTRAL)
					rosterOverride = CONSTANTS.ALL_FACTIONS_NOT_NEUTRAL[GameRandom.Free_Random(1, num)]
				end
			else
				rosterOverride = overrideOwner
			end
		elseif type(overrideOwner) == "userdata" then
			rosterOverride = overrideOwner.Get_Faction_Name()
		end
	end

	-- pick a random unit selection table, could probably use something other than free random
	total_spawn_table = DefineUnitTable(factionString, rosterOverride)

	DebugMessage("%s -- Initializing spawning", tostring(Script))
	if newOwner.Get_Difficulty() == "Easy" then
		Difficulty_Modifier = 0.75
	elseif newOwner.Get_Difficulty() == "Hard" then
		Difficulty_Modifier = 1.2
	else
		Difficulty_Modifier = 1.0
	end

	if combat_power == nil then
		combat_power = 4500
	end

	-- Scaled combat power increased or decreased by difficulty level
	scaled_combat_power = combat_power * Difficulty_Modifier

	DebugMessage("%s -- Attempting to spawn units at %s, from table for %s, combat power %s, difficulty modifier %s", tostring(Script), tostring(planet), tostring(newOwner), tostring(scaled_combat_power), tostring(Difficulty_Modifier))
	-- Spawns random units at the planet for the given faction and combat power per planet
	-- returns additional infrastructure spawned
	return Spawn_Random_Units(total_spawn_table, planet, newOwner, scaled_combat_power, consider_infrastructure)
end

-- Spawns random units at a given planet for a given player, up to a maximum combat power
-- In: unit table to spawn from, planet location, playerobject, combat power to spawn at planet
function Spawn_Random_Units(total_spawn_table, planet, player, total_combat_power, limit_spawn)

	if not total_spawn_table or not planet or not player or not total_combat_power then
		DebugMessage("%s -- Expected arguments: table of spawn tables, planet, playerobject, combat power. Got %s, %s, %s, %s instead", tostring(Script), tostring(total_spawn_table), tostring(planet), tostring(player), tostring(total_combat_power))
		return
	end

	if planet.Get_Owner() ~= player then
		DebugMessage("%s -- Planet owner %s is different to the intended player %s, retreating existing forces", tostring(Script), tostring(planet.Get_Owner()), tostring(player))
		ChangePlanetOwnerAndRetreat(planet, player)
	end

	DebugMessage("%s -- Attempting to spawn units at %s", tostring(Script), tostring(planet))
	-- empty spawn table
	local spawn_table = {}
	-- Create distribution to sample from
	local distribution_space = RandomDistribution()
	local distribution_land = RandomDistribution()

	local year = GlobalValue.Get("GALACTIC_YEAR")
	if year == nil then
		year = 0.0
	end

	-- Add units to distributions
	for _, possible_spawn in pairs(total_spawn_table["Space_Unit_Table"]) do
		--Insert unit into distribution
		local start = possible_spawn["StartYear"]
		local last = possible_spawn["LastYear"]
		if (start == nil or year >= start) and (last == nil or year <= last) then
			distribution_space:Insert(Find_Object_Type(possible_spawn[1]), possible_spawn[2])
		end
	end

	for _, possible_spawn in pairs(total_spawn_table["Land_Unit_Table"]) do
		--Insert unit into distribution
		local start = possible_spawn["StartYear"]
		local last = possible_spawn["LastYear"]
		if (start == nil or year >= start) and (last == nil or year <= last) then
			distribution_land:Insert(Find_Object_Type(possible_spawn[1]), possible_spawn[2])
		end
	end

	local space_combat_power
	local land_combat_power

	--For nonplayable factions during GC setup, RandomSpawnManager sends to ChangePlanetOwnerAndPopulate a combat_power value of -1.
	--This is then multiplied within ChangePlanetOwnerAndPopulate by the difficulty modifier.
	if total_combat_power < 0 then
		difficulty_multiplier = -total_combat_power
		local shipyard_level = EvaluatePerception("Max_Shipyard_Level", player, planet)
		if shipyard_level > 3 then
			shipyard_level = 3
		end
		space_combat_power = (4000 + 2000 * shipyard_level) * difficulty_multiplier
		land_combat_power = 2500 * difficulty_multiplier
	else
		space_combat_power = total_combat_power
		land_combat_power = total_combat_power / 4
	end

	--Add units to the spawn table
	SpawnTableInsert(space_combat_power, distribution_space, spawn_table, false)

	local base_level = EvaluatePerception("MaxGroundbaseLevel", player, planet)
	if base_level > 0 then
		SpawnTableInsert(land_combat_power, distribution_land, spawn_table, true)
	end

	-- spawn the units!
	starbase_level = SpawnStarBase(player, planet, total_spawn_table["Starbase_Table"], limit_spawn)
	groundbase_level = SpawnGroundBase(player, planet, total_spawn_table["Groundbase_Table"], total_spawn_table["Government_Building"], total_spawn_table["GTS_Weapon"], total_spawn_table["Base_Defences"], limit_spawn)
	shipyard_spawned = SpawnShipyard(player, planet, total_spawn_table["Shipyard_Table"], total_spawn_table["Defenses_Table"])

	SpawnListType(spawn_table, planet, player)
	-- return infrastructure added, each structure adds 1 and removes one empty slot
	return 2 * (starbase_level + groundbase_level + shipyard_spawned)
end

-- Insert units into the spawn table
-- In: combat value for the units, number of units, distribution of units,
-- the spawn_table to fill, and boolean for land/space
function SpawnTableInsert(combat_value, distribution, spawn_table, land)

	local total_count = 0

	local combat_value_j = 0

	while combat_value_j <= combat_value do
		if land and total_count > 4 then
			break
		end

		-- Get a unit based on their weighting
		local spawn_unit = distribution:Sample()

		if TestValid(spawn_unit) then
			if not spawn_unit then
				DebugMessage("%s -- Error! unit not found!", tostring(Script))
			end

			table.insert(spawn_table, spawn_unit)

			combat_value_j = combat_value_j + spawn_unit.Get_Combat_Rating()
			total_count = total_count + 1
		else
			combat_value_j = combat_value + 1
		end

	end

	return
end

-- Simple spawn function that can use the found object list instead of the name list
-- In: List of gameobjects, location, playerobject
function SpawnListType(type_list, entry_marker, player)

	for _, unit_type in pairs(type_list) do
		DebugMessage("%s -- Spawning %s", tostring(Script), tostring(unit_type.Get_Name()))
		new_units = Spawn_Unit(unit_type, entry_marker, player)
		for _, unit in pairs(new_units) do
			unit.Prevent_AI_Usage(false)
		end
	end

	new_units = nil
	return
end

-- Spawns groundbase for player
-- In: playerobject, planet to spawn at, table index to get ground bases from
function SpawnGroundBase(player, planet, base_table, government_building, gts_weapon, base_defences, limit_spawn)

	local base_level = EvaluatePerception("MaxGroundbaseLevel", player, planet)
	local starbase_level = EvaluatePerception("MaxStarbaseLevel", player, planet)
	local shipyard_level = EvaluatePerception("Max_Shipyard_Level", player, planet)
	local capital = EvaluatePerception("Planet_Has_Capital_Building", player, planet)
	local base_limit = base_level / 2
	local buildings_spawned = 0

	if base_level == 0 then
		return 0
	end

	-- Check if the planet has a starbase
	local current_base_level = EvaluatePerception("GroundbaseLevel", player, planet)

	if current_base_level > 0 and capital == 0 then
		return 0
	end

	if limit_spawn and capital == 0 then
		base_limit = 2
	end

	if government_building then
		Spawn_Unit(Find_Object_Type(government_building), planet, player)
		buildings_spawned = buildings_spawned + 1
	end

	local base_table_length = table.getn(base_table)


	while buildings_spawned < base_limit do
		building = base_table[GameRandom.Free_Random(1, base_table_length)]
		DebugMessage("%s -- Spawning %s", tostring(Script), building)
		Spawn_Unit(Find_Object_Type(building), planet, player)
		buildings_spawned = buildings_spawned + 1
	end

	local open_slots = base_level - buildings_spawned - current_base_level

	if open_slots > 0 and capital > 0 then
		if not base_defences then
			base_defences = "Galactic_Turbolaser_Tower_Defenses"
		end
		Spawn_Unit(Find_Object_Type(base_defences), planet, player)
	end

	-- if planet's starbase is 5 or has a capital shipyard and it has a free slot, give it a GtS weapon
	if shipyard_level > 2 and open_slots > 1 and gts_weapon ~= nil and EvaluatePerception("Is_Connected_To_Enemy", player, planet) > 0 and not limit_spawn then
		Spawn_Unit(Find_Object_Type(gts_weapon), planet, player)
		buildings_spawned = buildings_spawned + 1
	end

	return buildings_spawned
end

-- Spawns starbase for player
-- In: playerobject, planet to spawn at, table to get star bases from
function SpawnStarBase(player, planet, base_table, limit_spawn, set_level)

	-- Check if the planet has a starbase level
	local base_level = EvaluatePerception("MaxStarbaseLevel", player, planet)
	local capital = EvaluatePerception("Planet_Has_Capital_Building", player, planet)

	if base_level == nil then
		return 0
	end

	if base_level == 0 then
		StoryUtil.ShowScreenText("Starbase level 0 for base level".. tostring(base_level) .. "on" .. tostring(planet), 5)
		return 0
	end

	-- Check if the planet has a starbase
	local current_base_level = EvaluatePerception("StarbaseLevel", player, planet)

	if current_base_level > 0 then
		return 0
	end

	if set_level ~= nil then
		if set_level < base_level then
			base_level = set_level
		end
	elseif limit_spawn and EvaluatePerception("Is_Connected_To_Enemy", player, planet) == 0 and capital == 0 then
		base_level = 2
	end

	Spawn_Unit(Find_Object_Type(base_table[base_level]), planet, player)
	return base_level
end


-- Spawns shipyard for player
-- In: playerobject, planet to spawn at, table to get star bases from
function SpawnShipyard(player, planet, yard_table, defense_table)

	-- Check if the planet has a shipyard level
	local base_level = EvaluatePerception("Max_Shipyard_Level", player, planet)

	-- Check if the planet has a shipyard
	local current_shipyard_level = EvaluatePerception("Planet_Has_Shipyard", player, planet)

	if current_shipyard_level > 0 then
		return 0
	end

	if yard_table[base_level] then
		DebugMessage("%s -- Spawning %s", tostring(Script), tostring(yard_table[base_level]))
		Spawn_Unit(Find_Object_Type(yard_table[base_level]), planet, player)
	else
		StoryUtil.ShowScreenText("No shipyard for base level".. tostring(base_level) .. "on" .. tostring(planet), 5)
	end

	local current_base_level = EvaluatePerception("StarbaseLevel", player, planet)

	if defense_table[current_base_level] then
		Spawn_Unit(Find_Object_Type(defense_table[current_base_level]), planet, player)
	end

	return 1
end

function SpawnTradeStation(player, planet)
	local needs_trade = EvaluatePerception("Needs_Tradestation", player, planet)

	if needs_trade > 1 then
		Spawn_Unit(Find_Object_Type("TradeStation"), planet, player)
		return true
	end

	return false
end

function SaveSpaceStructures(planet)
	local player = planet.Get_Owner()

	local SpaceStructures = {
		["PRIMARY"] = 0,
		["SECONDARY"] = {},
	}

	SpaceStructures["PRIMARY"] = EvaluatePerception("StarbaseLevel", player, planet)

	local structureCategoryLists = require("StructureCategoryLists")
	local allFactionUnitInstances = Find_All_Objects_Of_Type(player) or {}
	for i, unitInstance in pairs(allFactionUnitInstances) do
		if TestValid(unitInstance) then
			local unitPlanet = unitInstance.Get_Planet_Location()
			local unitAction = determine_unit_action(unitInstance, unitPlanet, {planet}, structureCategoryLists)

			--if unitInstance is a secondary space structure insert to table
			if unitAction == 1 then
				table.insert(SpaceStructures["SECONDARY"],unitInstance.Get_Type().Get_Name())
			end
		end
	end

	return SpaceStructures
end

function RestoreSpaceStructures(planet,saved_table)
	local player = planet.Get_Owner()

	local current_table = SaveSpaceStructures(planet)

	if current_table["PRIMARY"] == 0 and saved_table["PRIMARY"] > 0 then
		local total_spawn_table = DefineUnitTable(player)
		SpawnStarBase(player, planet, total_spawn_table["Starbase_Table"], nil, saved_table["PRIMARY"])
	end

	local spawn_table = {}
	
	for _,saved_structure_name in pairs(saved_table["SECONDARY"]) do
		local found = false

		for _,current_structure_name in pairs(current_table["SECONDARY"]) do
			if saved_structure_name == current_structure_name then
				found = true
				break
			end
		end
		
		if found == false then
			table.insert(spawn_table,saved_structure_name)
		end
	end
	
	SpawnList(spawn_table,planet,player,true,false)
end

function SaveGroundStructures(planet)
	local player = planet.Get_Owner()

	local GroundStructures = {}

	local allFactionUnitInstances = Find_All_Objects_Of_Type(player) or {}
	for i, unitInstance in pairs(allFactionUnitInstances) do
		if TestValid(unitInstance) then
			local unitPlanet = unitInstance.Get_Planet_Location()
			local unitAction = determine_unit_action(unitInstance, unitPlanet, {planet}, nil, "groundStructureOnly")

			if unitAction == 2 then
				table.insert(GroundStructures,unitInstance.Get_Type().Get_Name())
			end
		end
	end

	return GroundStructures
end

function RestoreGroundStructures(planet,saved_table)
	local player = planet.Get_Owner()

	local current_table = SaveGroundStructures(planet)

	local spawn_table = {}
	
	for _,saved_structure_name in pairs(saved_table) do
		local found = false

		for i,current_structure_name in pairs(current_table) do
			if saved_structure_name == current_structure_name then
				table.remove(current_table,i)
				found = true
				break
			end
		end

		if found == false then
			table.insert(spawn_table,saved_structure_name)
		end
	end
	
	SpawnList(spawn_table,planet,player,true,false)
end
