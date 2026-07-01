--******************************************************************************
--     _______ __
--    |_     _|  |--.----.---.-.--.--.--.-----.-----.
--      |   | |     |   _|  _  |  |  |  |     |__ --|
--      |___| |__|__|__| |___._|________|__|__|_____|
--     ______
--    |   __ \.-----.--.--.-----.-----.-----.-----.
--    |      <|  -__|  |  |  -__|     |  _  |  -__|
--    |___|__||_____|\___/|_____|__|__|___  |_____|
--                                    |_____|
--*   @Author:              [TR]Pox
--*   @Date:                2017-12-18T14:01:25+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            ChangeOwnerUtilities.lua
--*   @Last modified by:    Mord
--*   @Last modified time:  2022-08-29T01:36:27-05:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************

require("PGBase")
require("PGStateMachine")
require("eawx-util/StoryUtil")
CONSTANTS = ModContentLoader.get("GameConstants")

---Changes the owner of a given list of planets or a single planet.
---Units belonging to the new owner are not moved.
---Units belonging to the old owner are transferred to the specified destination (if provided and valid) or an allied planet (capital location preferred).
---Units belonging to any other faction are moved to an allied planet (capital location preferred).
---@param planets PlanetObject|PlanetObject[]
---@param newOwner PlayerObject
---@param destinationPlanet PlanetObject
---@param newBuildingsMode int (optional)
function ChangePlanetOwnerAndRetreat(planets, newOwner, destinationPlanet, newBuildingsMode)
    --DebugMessage("ChangePlanetOwnerAndRetreat STARTED")
    ChangePlanetOwnerAnd(0, planets, newOwner, destinationPlanet, newBuildingsMode)
end

---Changes the owner of a given list of planets or a single planet.
---Units belonging to the new owner are not moved.
---Units belonging to the old owner are given to the new owner.
---Units belonging to any other faction are moved to an allied planet (capital location preferred).
---@param planets PlanetObject|PlanetObject[]
---@param newOwner PlayerObject
---@param newBuildingsMode int (optional)
function ChangePlanetOwnerAndReplace(planets, newOwner, newBuildingsMode)
    --DebugMessage("ChangePlanetOwnerAndReplace STARTED")
    ChangePlanetOwnerAnd(1, planets, newOwner, nil, newBuildingsMode)
end

---Executes planet ownership change
---@param mode integer (0 == retreat, 1 == replace)
---@param transferPlanetObjects PlanetObject|PlanetObject[]
---@param newOwnerPlayer PlayerObject
---@param destinationPlanet PlanetObject (optional)
---@param newBuildingsMode int (optional) (1 == basic structures per CONSTANTS, 2 == random structures from ChangePlanetOwnerAndPopulate, 3 == keep ground structures, nil and all other values == nothing)
function ChangePlanetOwnerAnd(mode, transferPlanetObjects, newOwnerPlayer, destinationPlanet, newBuildingsMode)
    if type(transferPlanetObjects) ~= "table" then
        transferPlanetObjects = {transferPlanetObjects}
    end

	local newOwnerPlayerHumanFlag = newOwnerPlayer.Is_Human()

	local actionMode = nil
	if newBuildingsMode == 3 then
		actionMode = "keepGround"
	end

    ---@type PlayerObject[]
	local transferPlanetOwners = {}
    ---@type GameObject[]
    local queuedSpawns = {}

    local spaceStructures = require("StructureCategoryLists")

	for _, transferPlanetObject in pairs(transferPlanetObjects) do
		transferPlanetOwners[transferPlanetObject] = transferPlanetObject.Get_Owner()
	end

	for _, factionName in pairs(CONSTANTS.ALL_FACTIONS) do
		local factionPlayer = Find_Player(factionName)

		if factionPlayer ~= newOwnerPlayer then
			local allFactionUnitInstances = Find_All_Objects_Of_Type(factionPlayer) or {}
			for i, unitInstance in pairs(allFactionUnitInstances) do
				if TestValid(unitInstance) then
					local unitPlanet = unitInstance.Get_Planet_Location()
					local unitAction = determine_unit_action(unitInstance, unitPlanet, transferPlanetObjects, spaceStructures, actionMode)

					--if unitInstance is a secondary space structure despawn it
					if unitAction == 1 then
						unitInstance.Despawn()
					--if unitInstance meets conditions, add unitInstanceRelevantObject to queuedSpawns[spawnPlayer][spawnPlanet], then despawn unitInstanceRelevantObject
					elseif unitAction == 2 then
						local unitInstanceRelevantObject = get_relevant_object(unitInstance)
						if TestValid(unitInstanceRelevantObject) then
							--if replace and unitInstance belongs to transferPlanetOwners[unitPlanet] give to newOwnerPlayer
							local spawnPlayer = nil
							if mode == 1 and factionPlayer == transferPlanetOwners[unitPlanet] then
								spawnPlayer = newOwnerPlayer
							--else retain original ownership
							else
								spawnPlayer = factionPlayer
							end

							if not queuedSpawns[spawnPlayer] then
								queuedSpawns[spawnPlayer] = {}
							end

							local spawnPlanet = nil
							--if replace and unitInstance owner is old planet owner, then spawn on same planet
							if mode == 1 and factionPlayer == transferPlanetOwners[unitPlanet] then
								spawnPlanet = unitPlanet
							--if retreat and destinationPlanet is friendly, then spawn on destinationPlanet
							elseif mode == 0 and destinationPlanet then
								if StoryUtil.CheckFriendlyPlanet(destinationPlanet, factionPlayer) then
									spawnPlanet = destinationPlanet
								end
							end
							--else placeholder (selection made after all ownership transfers in batch)
							if not spawnPlanet then
								spawnPlanet = "placeholder"
							end

							if not queuedSpawns[spawnPlayer][spawnPlanet] then
								queuedSpawns[spawnPlayer][spawnPlanet] = {}
							end

							table.insert(queuedSpawns[spawnPlayer][spawnPlanet], unitInstanceRelevantObject.Get_Type())
							--NB: despawn the relevant object, not the unit, to ensure only 1 object for each company causes that company to be added to queuedSpawns
							unitInstanceRelevantObject.Despawn()
						end
					end
				end
			end
		end
	end

	for _, transferPlanetObject in pairs(transferPlanetObjects) do
		transferPlanetObject.Change_Owner(newOwnerPlayer)

		--basic structures
		if newBuildingsMode == 1 then
			SpawnList(CONSTANTS.ALL_FACTIONS_BASIC_STRUCTURES[newOwnerPlayer.Get_Faction_Name()], transferPlanetObject, newOwnerPlayer, true, false)
		end

		--random structures
		if newBuildingsMode == 2 then
			ChangePlanetOwnerAndPopulate(transferPlanetObject, newOwnerPlayer, 0, nil, true)
		end
	end

	for spawnPlayer, spawnPlanetTable in pairs(queuedSpawns) do
		local spawnPlanetOut = nil
		for spawnPlanetIn, unitTypeTable in pairs(spawnPlanetTable) do
			--replace placeholder with friendly planet, prefer capital
			if type(spawnPlanetIn) == "string" then
				spawnPlanetOut = StoryUtil.FindFriendlyPlanet(spawnPlayer, true)

				--if there's nowhere to go, just disappear
				if not spawnPlanetOut then
					break
				end
			else
				spawnPlanetOut = spawnPlanetIn
			end

			for _, unitType in pairs(unitTypeTable) do
				spawnedUnit = Spawn_Unit(unitType, spawnPlanetOut, spawnPlayer)
				spawnedUnit[1].Prevent_AI_Usage(false)
			end
		end

		if spawnPlayer.Is_Human() and not newOwnerPlayerHumanFlag and spawnPlanetOut then
			StoryUtil.ShowScreenText("TEXT_SINGLE_UNIT_RETREAT_PLANET", 15, spawnPlanetOut, {r = 255, g = 255, b = 100})
		end
	end
end

function determine_unit_action(unitInstance, unitPlanet, transferPlanetObjects, spaceStructures, actionMode)
	if transferPlanetObjects ~= nil then
		local unitOnTransferredPlanet = false
		for _, transferPlanetObject in pairs(transferPlanetObjects) do
			if unitPlanet == transferPlanetObject then
				unitOnTransferredPlanet = true
				break
			end
		end

		if not unitOnTransferredPlanet then
			return 0
		end
	end

	if is_valid_category(unitInstance, actionMode) then
		return 2
	end

	if spaceStructures ~= nil then
		if is_secondary_space_structure(unitInstance, spaceStructures) then
			return 1
		end
	end

	return 0
end

---Returns true if the unit has the right category
---@param unit GameObject
---@param actionMode string
function is_valid_category(unit, actionMode)
    local validCategories = {}

	if actionMode == "spaceOnly" then
	--used when forcing a space-only retreat from a planet to be blockaded: must be movable space unit or noncombat hero
		validCategories = {
			"Fighter",
			"Bomber",
			"Gunship",
			"Corvette",
			"Frigate",
			"Capital",
			"SuperCapital",
			"SpaceHero",

			"NonCombatHero",
		}
	elseif actionMode == "keepGround" then
	--used when transferring all existing ground assets between factions: must be ground unit or structure
		validCategories = {
			"Infantry",
			"Vehicle",
			"AirGunship",
			"AirSpeeder",
			"InfantryHero",
			"VehicleHero",
			"Structure",
		}
	elseif actionMode == "groundStructureOnly" then
	--used when saving ground structure snapshots for tactical missions
		validCategories = {
			"Structure",
		}
	elseif actionMode == "killAll" then
	--used for debug cheat kill all; must not be hero
		validCategories = {
			"Fighter",
			"Bomber",
			"Gunship",
			"Corvette",
			"Frigate",
			"Capital",
			"SuperCapital",
			"SpaceStructure",

			"Infantry",
			"Vehicle",
			"AirGunship",
			"AirSpeeder",
			"Structure",
		}
	else
	--otherwise; must be movable unit of any kind
		validCategories = {
			"Fighter",
			"Bomber",
			"Gunship",
			"Corvette",
			"Frigate",
			"Capital",
			"SuperCapital",
			"SpaceHero",

			"Infantry",
			"Vehicle",
			"AirGunship",
			"AirSpeeder",
			"InfantryHero",
			"VehicleHero",

			"NonCombatHero",
		}
	end

    if not unit.Is_Category then
        return false
    end

    for _, category in pairs(validCategories) do
        if unit.Is_Category(category) then
            return true
        end
    end

    return false
end

---Returns true if the unit is a secondary space structure
---@param unitType GameObject
function is_secondary_space_structure(unitType, spaceStructures)
	local unitTypeName = unitType.Get_Type().Get_Name()

    for _, spaceStructuresSub in pairs(spaceStructures) do
        for _, spaceStructureName in pairs(spaceStructuresSub) do
			if unitTypeName == spaceStructureName then
                return true
            end
        end
    end

	return false
end

---Returns the object necessary to spawn an instance of the unit on the GC map. If the unit is in a company it will return the company. Otherwise returns the object
---@param unit GameObject
function get_relevant_object(unit)
    if is_in_company(unit) then
        return unit.Get_Parent_Object()
    end

    return unit
end

---Returns true if the unit is part of a company
---@param unit GameObject
function is_in_company(unit)
    local parent = unit.Get_Parent_Object()
    return parent and parent ~= unit.Get_Planet_Location() and parent.Get_Type() ~= Find_Object_Type("Galactic_Fleet")
end

function insert_all_enemy_units_on_planet(allUnitsPerOwner, planet_owner, planet)
	for _, enemy_faction in pairs(CONSTANTS.ALL_FACTIONS) do
		local enemy_faction_obj = Find_Player(enemy_faction)
		if enemy_faction_obj ~= planet_owner then
			local friendly_units_on_planet = get_friendly_units_on_planet(enemy_faction_obj, planet)
			if table.getn(friendly_units_on_planet) > 0 then
			    allUnitsPerOwner[enemy_faction_obj] = friendly_units_on_planet
            end
        end
    end
end

---@param player PlayerObject
---@param planet PlanetObject
--This same function is duplicated in AI_Plan_Rescue_Trapped_Fleet (to simplify dependencies?)
function get_friendly_units_on_planet(player, planet)
	DebugMessage("%s -- getting all units for %s on planet %s", tostring(Script), tostring(player), tostring(planet))
	local all_units_of_player = Find_All_Objects_Of_Type(player) or {}
	local friendly_units_on_planet = {}
	for _, unit in pairs(all_units_of_player) do
		if TestValid(unit) and unit.Get_Planet_Location() == planet and unit.Get_Type() ~= Find_Object_Type("Galactic_Fleet") then
			table.insert(friendly_units_on_planet, unit)
		end
	end

	return friendly_units_on_planet
end

--transfers all game objects that belong to oldOwner to newOwner. Transferred units over third-party planets retreat to one of newOwner's planets (capital preferred)
--@param oldOwnerPlayer PlayerObject
--@param newOwnerPlayer PlayerObject
--@param newBuildingsMode int (1 == basic structures per CONSTANTS, 2 == random structures from ChangePlanetOwnerAndPopulate, nil and all other values == nothing)
function Faction_Total_Replace(oldOwnerPlayer,newOwnerPlayer,newBuildingsMode)
	local allPlanetObjects = FindPlanet.Get_All_Planets()
	local planets_to_transfer = {}

	for _, planet in pairs(allPlanetObjects) do
		if planet.Get_Owner() == oldOwnerPlayer then
			table.insert(planets_to_transfer, planet)
		end
	end

	ChangePlanetOwnerAndReplace(planets_to_transfer, newOwnerPlayer, newBuildingsMode)

	Transfer_All_Units(oldOwnerPlayer,newOwnerPlayer)
end

--transfers all movable units that belong to oldOwner to newOwner. Transferred units over third-party planets retreat to one of newOwner's planets (capital preferred)
--@param oldOwnerPlayer PlayerObject
--@param newOwnerPlayer PlayerObject
function Transfer_All_Units(oldOwnerPlayer,newOwnerPlayer)
	local defaultSpawnPlanet = StoryUtil.FindFriendlyPlanet(newOwnerPlayer, true)

	if defaultSpawnPlanet == nil then
		return
	end

	local defaultPlanetUsed = false
    local queuedSpawns = {}
	queuedSpawns[defaultSpawnPlanet] = {}

	local allFactionUnitInstances = Find_All_Objects_Of_Type(oldOwnerPlayer) or {}

	for i, unitInstance in pairs(allFactionUnitInstances) do
		if TestValid(unitInstance) then
			if is_valid_category(unitInstance) then
				local unitInstanceRelevantObject = get_relevant_object(unitInstance)
				if TestValid(unitInstanceRelevantObject) then
					local unitPlanet = unitInstance.Get_Planet_Location()
					if TestValid(unitPlanet) then
						local spawnPlanet = nil

						if unitPlanet.Get_Owner() == newOwnerPlayer then
							spawnPlanet = unitPlanet
						else
							spawnPlanet = defaultSpawnPlanet
							defaultPlanetUsed = true
						end

						if not queuedSpawns[spawnPlanet] then
							queuedSpawns[spawnPlanet] = {}
						end

						table.insert(queuedSpawns[spawnPlanet], unitInstanceRelevantObject.Get_Type())

						--NB: despawn the relevant object, not the unit, to ensure only 1 object for each company causes that company to be added to queuedSpawns
						unitInstanceRelevantObject.Despawn()
					end
				end
			end
		end
	end

	for spawnPlanet, unitTypeTable in pairs(queuedSpawns) do
		for _, unitType in pairs(unitTypeTable) do
			spawnedUnit = Spawn_Unit(unitType, spawnPlanet, newOwnerPlayer)
			spawnedUnit[1].Prevent_AI_Usage(false)
		end
	end

	if newOwnerPlayer.Is_Human() and defaultPlanetUsed then
		StoryUtil.ShowScreenText("TEXT_SINGLE_UNIT_RETREAT_PLANET", 15, defaultSpawnPlanet, {r = 255, g = 255, b = 100})
	end
end

function Destroy_Planet(planet)
    if type(planet) == "string" then
        planet = FindPlanet(planet)
    end

    if TestValid(planet) then
        DestroySecondarySpaceStructures(planet)

        local pk_fleet = {
            "Dummy_Planet_Killer"
        }

        local hostile_player = Find_Player("Hostile")

        local pk_unit_list = SpawnList(pk_fleet, planet, hostile_player, false, false)
        local pk_fleet = Assemble_Fleet(pk_unit_list)

        local pk_list = Find_All_Objects_Of_Type("Dummy_Planet_Killer")
        local pk = pk_list[1]

        pk.Set_Check_Contested_Space(false)
        pk.Activate_Ability("Dummy_Planet_Killer")
        pk.Set_Check_Contested_Space(true)

        local checkpk = Find_First_Object("Dummy_Planet_Killer")

        if TestValid(checkpk) then
            checkpk.Despawn()
        end
    end
end

function DestroySecondarySpaceStructures(targetPlanet)
    local spaceStructures = require("StructureCategoryLists")
    local factionPlayer = targetPlanet.Get_Owner()

    local allFactionUnitInstances = Find_All_Objects_Of_Type(factionPlayer) or {}
    for i, unitInstance in pairs(allFactionUnitInstances) do
        if TestValid(unitInstance) then
            local unitPlanet = unitInstance.Get_Planet_Location()
            local unitAction = determine_unit_action(unitInstance, unitPlanet, {targetPlanet}, spaceStructures)

            --if unitInstance is a secondary space structure despawn it
            if unitAction == 1 then
                unitInstance.Despawn()
            end
        end
    end
end

function ForceSpaceRetreat(evacuatePlanetObject, newOccupyingPlayer, destinationPlanet)
    if type(evacuatePlanetObject) ~= "table" then
        evacuatePlanetObject = {evacuatePlanetObject}
    end

    local queuedSpawns = {}

    local spaceStructures = require("StructureCategoryLists")

	for _, factionName in pairs(CONSTANTS.ALL_FACTIONS) do
		local factionPlayer = Find_Player(factionName)

		if factionPlayer ~= newOccupyingPlayer then
			local allFactionUnitInstances = Find_All_Objects_Of_Type(factionPlayer) or {}
			for i, unitInstance in pairs(allFactionUnitInstances) do
				if TestValid(unitInstance) then
					local unitPlanet = unitInstance.Get_Planet_Location()
					local unitAction = determine_unit_action(unitInstance, unitPlanet, evacuatePlanetObject, spaceStructures, "spaceOnly")

					--if unitInstance is a secondary space structure despawn it
					if unitAction == 1 then
						unitInstance.Despawn()
					--if unitInstance meets conditions, add unitInstanceRelevantObject to queuedSpawns[spawnPlayer][spawnPlanet], then despawn unitInstanceRelevantObject
					elseif unitAction == 2 then
						local unitInstanceRelevantObject = get_relevant_object(unitInstance)
						if TestValid(unitInstanceRelevantObject) then
							spawnPlayer = factionPlayer

							if not queuedSpawns[spawnPlayer] then
								queuedSpawns[spawnPlayer] = {}
							end

							local spawnPlanet = nil

							--if destinationPlanet is friendly, then spawn on destinationPlanet
							if destinationPlanet then
								if StoryUtil.CheckFriendlyPlanet(destinationPlanet, factionPlayer) then
									spawnPlanet = destinationPlanet
								end
							end
							--else placeholder (selection made after all ownership transfers in batch)
							if not spawnPlanet then
								spawnPlanet = "placeholder"
							end

							if not queuedSpawns[spawnPlayer][spawnPlanet] then
								queuedSpawns[spawnPlayer][spawnPlanet] = {}
							end

							table.insert(queuedSpawns[spawnPlayer][spawnPlanet], unitInstanceRelevantObject.Get_Type())
							--NB: despawn the relevant object, not the unit, to ensure only 1 object for each company causes that company to be added to queuedSpawns
							unitInstanceRelevantObject.Despawn()
						end
					end
				end
			end
		end
	end

	for spawnPlayer, spawnPlanetTable in pairs(queuedSpawns) do
		local spawnPlanetOut = nil
		for spawnPlanetIn, unitTypeTable in pairs(spawnPlanetTable) do
			--replace placeholder with friendly planet, prefer capital
			if type(spawnPlanetIn) == "string" then
				spawnPlanetOut = StoryUtil.FindFriendlyPlanet(spawnPlayer, true)

				--if there's nowhere to go, just disappear
				if not spawnPlanetOut then
					break
				end
			else
				spawnPlanetOut = spawnPlanetIn
			end

			for _, unitType in pairs(unitTypeTable) do
				spawnedUnit = Spawn_Unit(unitType, spawnPlanetOut, spawnPlayer)
				spawnedUnit[1].Prevent_AI_Usage(false)
			end
		end

		if spawnPlayer.Is_Human() and spawnPlanetOut then
			StoryUtil.ShowScreenText("TEXT_SINGLE_UNIT_RETREAT_PLANET", 15, spawnPlanetOut, {r = 255, g = 255, b = 100})
		end
	end
end

function KillAllNonHumanNonHeroObjects()
	local p_human = Find_Player("local")
	local p_indep = Find_Player("Independent_Forces")
	local p_thirdparty = Find_Player("Empire")
	if p_human == p_thirdparty then
		p_thirdparty = Find_Player("Rebel")
	end

	for _, factionName in pairs(CONSTANTS.ALL_FACTIONS) do
		local factionPlayer = Find_Player(factionName)
		if factionPlayer ~= p_human then
			local allFactionUnitInstances = Find_All_Objects_Of_Type(factionPlayer) or {}
			for i, unitInstance in pairs(allFactionUnitInstances) do
				if TestValid(unitInstance) then
					if determine_unit_action(unitInstance, nil, nil, nil, "killAll") > 0 then
						local unitInstanceRelevantObject = get_relevant_object(unitInstance)
						if TestValid(unitInstanceRelevantObject) then
							unitInstanceRelevantObject.Despawn()
						end
					end
				end
			end
		end
	end
end
