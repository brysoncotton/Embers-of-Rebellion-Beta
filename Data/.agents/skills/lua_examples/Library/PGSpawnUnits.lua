-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/Library/PGSpawnUnits.lua#1 $
--/////////////////////////////////////////////////////////////////////////////////////////////////
--
-- (C) Petroglyph Games, Inc.
--
--
--  *****           **                          *                   *
--  *   **          *                           *                   *
--  *    *          *                           *                   *
--  *    *          *     *                 *   *          *        *
--  *   *     *** ******  * **  ****      ***   * *      * *****    * ***
--  *  **    *  *   *     **   *   **   **  *   *  *    * **   **   **   *
--  ***     *****   *     *   *     *  *    *   *  *   **  *    *   *    *
--  *       *       *     *   *     *  *    *   *   *  *   *    *   *    *
--  *       *       *     *   *     *  *    *   *   * **   *   *    *    *
--  *       **       *    *   **   *   **   *   *    **    *  *     *   *
-- **        ****     **  *    ****     *****   *    **    ***      *   *
--                                          *        *     *
--                                          *        *     *
--                                          *       *      *
--                                      *  *        *      *
--                                      ****       *       *
--
--/////////////////////////////////////////////////////////////////////////////////////////////////
-- C O N F I D E N T I A L   S O U R C E   C O D E -- D O   N O T   D I S T R I B U T E
--/////////////////////////////////////////////////////////////////////////////////////////////////
--
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/Library/PGSpawnUnits.lua $
--
--    Original Author: Brian Hayes
--
--            $Author: Andre_Arsenault $
--
--            $Change: 37816 $
--
--          $DateTime: 2006/02/15 15:33:33 $
--
--          $Revision: #1 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGBaseDefinitions")

---@private
---@return nil
function Process_Reinforcements()
	for index, btable in ipairs(block_table) do
		for k, block in pairs(btable) do
			if not block.block then
				--Haven't yet issued the reinforcement command, or else a previous attempt failed
				block.block = Reinforce_Unit(block.ref_type, block.entry_marker, block.player, true, block.obey_zones)
			elseif block.block.IsFinished() then
				new_units = block.block.Result()
				if type(new_units) == "table" then
					for j, unit in pairs(new_units) do
						DebugMessage("%s -- Process_Reinforcements Block: %s, unit: %s, allow:%s, delete:%s", tostring(Script), tostring(block.block), tostring(unit), tostring(block.allow_ai_usage), tostring(block.delete_after_scenario))
						if block.allow_ai_usage then
							DebugMessage("allow_ai_usage: %s", tostring(unit))
							unit.Prevent_AI_Usage(false)
						end
						if block.delete_after_scenario then
							DebugMessage("deleting after scenario: %s", tostring(unit))
							unit.Mark_Parent_Mode_Object_For_Death()
						end
						table.insert(block.block_track.unit_list, unit)
					end
					block.block_track.type_count = block.block_track.type_count - 1
					if block.block_track.type_count <= 0 then
						if type(block.callback) == "function" then
							block.callback(block.block_track.unit_list)
						end
						table.remove(block_table, index)
						Process_Reinforcements()
						return
					end
				end
				block_table[index][k] = nil
				Process_Reinforcements()
				return
			end
		end
	end
		
	new_units = nil
end

---Adds a unit to the reinforcement pool of a player
---@param object_type GameObjectType The GameObjectType of the unit to add
---@param player PlayerObject The player receiving the unit
function Add_Reinforcement(object_type, player)

	if type(object_type) == "string" then
		object_type = Find_Object_Type(object_type)
	end
	
	Reinforce_Unit(object_type, false, player, true, false)
end


---@alias ReinforceListCallback fun(units: GameObject[]):nil A function that gets called with a table containing the spawned units after ReinforceList is finished

-- Reinforce units via transport, simultaneously.
---Spawns multiple units with Hyperspace/landing Transport animation and calls a callback function when done
---@param type_list string[] The type names of the units to be spawned
---@param entry_marker PlanetObject|GameObject|Position The location the units are supposed to spawn at
---@param player PlayerObject The owner of the units
---@param allow_ai_usage boolean Determines whether the AI is allowed to control the units
---@param delete_after_scenario boolean If set to true the units will be removed after a tactical battle
---@param ignore_reinforcement_rules boolean Ignores reinforcement rules when set to true
---@param callback ReinforceListCallback
function ReinforceList(type_list, entry_marker, player, allow_ai_usage, delete_after_scenario, ignore_reinforcement_rules, callback)

	if type(ignore_reinforcement_rules) == "function" then
		DebugMessage("Received a function for 6th parameter; expected bool.  Note the signature change, sorry.")
		return
	end
	
	if player == nil then
		DebugMessage("expected a player for 3rd parameter; aborting")
		return
	end

	table.insert(block_table, {})
	index = table.getn(block_table)

	block_track = {
		type_count = table.getn(type_list),
		unit_list = {} 
	}
	
	for k, unit_type in pairs(type_list) do
		ref_type = Find_Object_Type(unit_type)
		btab = {
			block = nil,
			block_track = block_track,
			ref_type = ref_type,
			entry_marker = entry_marker,
			player = player,
			obey_zones = not ignore_reinforcement_rules,
			allow_ai_usage = allow_ai_usage, 
			callback = callback,
			delete_after_scenario = delete_after_scenario 
		}
		table.insert(block_table[index], btab)
		btab = nil
		ref_type = nil
	end
end

-- Spawn units simultaneously.
---Spawns a multiple units and returns them as a table
---@param type_list string[] The type names of the units to be spawned
---@param entry_marker PlanetObject|GameObject|Position The location the units are supposed to spawn at
---@param player PlayerObject The owner of the units
---@param allow_ai_usage boolean Determines whether the AI is allowed to control the units
---@param delete_after_scenario boolean If set to true the units will be removed after a tactical battle
---@return GameObject[]
function SpawnList(type_list, entry_marker, player, allow_ai_usage, delete_after_scenario)

		unit_list = {}
		
		if type_list ~= nil then
			for k, unit_type in pairs(type_list) do
				ref_type = Find_Object_Type(unit_type)
				if TestValid(ref_type) then
					new_units= Spawn_Unit(ref_type, entry_marker, player)
					if new_units ~= nil then
						for j, unit in pairs(new_units) do
							table.insert(unit_list, unit)
							if allow_ai_usage then
								DebugMessage("allow_ai_usage: %s", tostring(unit))
								unit.Prevent_AI_Usage(false)
							else
								unit.Prevent_AI_Usage(true) -- This doesn't happen automatically, unlike for Reinforce_Unit
							end
							if delete_after_scenario then
								DebugMessage("deleting after scenario: %s", tostring(unit))
								unit.Mark_Parent_Mode_Object_For_Death()
							end
						end
					end
				else
					DebugMessage("%s -- ERROR! Unit %s not found in XML!", tostring(Script), tostring(unit_type))
				end
			end
		end
			
		new_units = nil
		
		return unit_list
end
