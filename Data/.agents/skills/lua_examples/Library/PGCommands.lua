-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/Library/PGCommands.lua#10 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/Library/PGCommands.lua $
--
--    Original Author: Brian Hayes
--
--            $Author: James_Yarrow $
--
--            $Change: 53991 $
--
--          $DateTime: 2006/09/08 11:01:51 $
--
--          $Revision: #10 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGBaseDefinitions")

-- Deprecated...
--
-- function ProduceForce(taskforce)
--    tfIndex = 0
--
--    DebugMessage("Beginning production on %s at %s.", tostring(taskforce),
--          tostring(taskforce.Production_Facility()))
--
--    -- loop through all the unit types and produce each one.
--    UnitType = taskforce.Get_Type_Of_Unit(tfIndex)
--    while UnitType do
--
--       -- Build the object at the production facility.
--       tfObj = WaitProduceObject(UnitType, taskforce.Production_Facility())
--       DebugMessage("Object %s produced.", tostring(tfObj))
--
--       -- Add the object to the task force.
--       taskforce.Add_Force(tfObj)
--
--        -- Remove our reference to the object, since a merge will destroy it.
--       tfObj.Release()
--
--       -- Merge the new fleets together.
--       BlockOnCommand(taskforce.Form_Units())
--
--       -- Look for another unit type.
--       tfIndex = tfIndex + 1
--       UnitType = taskforce.Get_Type_Of_Unit(tfIndex)
--    end
-- end
--
-- function ProduceObject(player, objecttype, where)
--    return _ProduceObject(player, objecttype, where)
-- end
--
-- function WaitProduceObject(objecttype, where)
--    return BlockOnCommand(ProduceObject(PlayerObject, objecttype, where))
-- end

function WaitForever()
	DebugMessage("%s -- Waiting forever...", tostring(Script))
	while true do
		PumpEvents()
	end
--	BlockOnCommand(BlockForever())
	-- DebugMessage("%s -- Something interrupted the wait!.", tostring(Script))
end

--	TimerTable[func] = {timeout = timeout, start_time = GetCurrentTime(), param = param }
--function Debug_Timer_Table()
--	OutputDebug("%s -- TimerTable Dump.\n", tostring(Script))
--	for func,tabtab in pairs(TimerTable) do
--		for idx,tab in pairs(tabtab) do
--			OutputDebug("%s, %f, %f, %s\n", tostring(func), tab.timeout, tab.start_time, tostring(tab.param))
--		end
--	end
--end

---Registers a callback function that gets called after a set amount of time
---@param func function The callback function
---@param timeout number The amount of time in seconds that has to pass before the callback gets called
---@param param any An optional parameter that gets passed to the callback function
function Register_Timer(func, timeout, param)
	if TimerTable[func] == nil then
		TimerTable[func] = {}
	end
	
	table.insert(TimerTable[func], {timeout = timeout, start_time = GetCurrentTime(), param = param})
end

function Process_Timers()
	for func,tabtab in pairs(TimerTable) do
		found_entry = false
		for idx,tab in pairs(tabtab) do
			found_entry = true
			if tab.timeout + tab.start_time < GetCurrentTime() then
				tabtab[idx] = nil
				func(tab.param)
				Process_Timers()
				return
			end
		end
		if found_entry == false then
			TimerTable[func] = nil
			Process_Timers()
			return
		end
	end
end

---Cancels all occurences of this timer function
---@param func function The callback function
function Cancel_Timer(func)
	if func ~= nil then
		TimerTable[func] = nil
	else
		DebugMessage("%s -- cancelling nonexistant function, got:%s; aborting.", tostring(Script), type(func))
	end
end


---Setup a callback for the death or deletion of a given object
---@param obj GameObject The GameObject that has to die
---@param func function The callback function that gets called after the object has died
function Register_Death_Event(obj, func)
	if not TestValid(obj) then
		DebugMessage("%s -- Error, object doesn't exist or has already died.", tostring(Script))
		return
	end

	if DeathTable[obj] ~= nil then
		DebugMessage("%s -- Error, object already registered for death event", tostring(Script))
		return
	end
	
	DeathTable[obj] = func
end

function Process_Death_Events()
	for obj, func in pairs(DeathTable) do
		if not TestValid(obj) then
			DeathTable[obj] = nil
			func()
			Process_Death_Events()
			return
		end
	end
end

---Setup a callback for a given object falling under attack
---@param obj GameObject The GameObject that has to be attacked
---@param func function The callback function that is called when the object gets attacked
function Register_Attacked_Event(obj, func)
	if not TestValid(obj) then
		DebugMessage("%s -- Error, object doesn't exist or has died.", tostring(Script))
		return
	end

	if AttackedTable[obj] ~= nil then
		DebugMessage("%s -- Error, object already registered for attacked event", tostring(Script))
		return
	end
	
	-- Storing the callback and if the object currently has a "deadly enemy"
	AttackedTable[obj] = {func, false}
end


-- Executes the callback with (true, object) if first going under attack.
-- Executes the callback with (false) if no longer under attack.
function Process_Attacked_Events()
	for obj, table in pairs(AttackedTable) do
		if not TestValid(obj) then
			AttackedTable[obj] = nil
		else
			most_deadly_enemy = FindDeadlyEnemy(obj)
			if most_deadly_enemy then
		
				-- If we have a deadly enemy and this just became true, run the callback.
				if not table[2] then
					table[2] = true
					table[1](true, most_deadly_enemy, obj)
					Process_Attacked_Events()
					return
				end
			
			-- Update that we don't have a deadly enemy any longer.
			--else
			elseif table[2] then
				DebugMessage("obj:%s now has no deadly enemy", tostring(obj))
				table[2] = false
				table[1](false, nil, obj)
			end
		end
	end
end

---Cancels the attacked callback for the given object
---@param obj GameObject The GameObject
function Cancel_Attacked_Event(obj)
	if obj ~= nil then
		AttackedTable[obj] = nil
	else
		DebugMessage("received nil object")
	end
end

---@alias RegisterProxCallback fun(source_object: GameObject, target_object: GameObject): nil
---A callback handler that gets called when the target_object is in the specified range of the source_object

---Set up proximity triggers on arbitrary objects and have them serviced
---@param obj GameObject The GameObject that is the center of the proximity calculation
---@param func RegisterProxCallback The callback function
---@param range number The range at which the callback function gets called
---@param player_filter PlayerObject Limits the proximity callback to objects of the specified faction
function Register_Prox(obj, func, range, player_filter)

	-- prevent this from doing anything in galactic mode
	if Get_Game_Mode() == "Galactic" then
		DebugMessage("%s -- Warning, proximity register disallowed in galactic mode; aborting.", tostring(Script))
		return
	end

	if not TestValid(obj) then
		MessageBox("%s -- Error, prox object doesn't exist; aborting", tostring(Script))
		ScriptError("%s -- Error, prox object doesn't exist; aborting", tostring(Script))
		return
	end
	
	-- Note the player_filter is optional.  The user of this function must check
	-- for player validity at the source.	
	if player_filter == nil then
		DebugMessage("%s -- Warning, passed a nil player, not filtering prox by player", tostring(Script))
	end

	obj.Event_Object_In_Range(func, range, player_filter)
	ProxTable[obj] = 1
end

function Process_Proximities()
	for obj, count in pairs(ProxTable) do
		if TestValid(obj) then
			obj.Service_Wrapper()
		else
			ProxTable[obj] = nil
		end
	end
end

function Pump_Service()
	Process_Timers()
	Process_Death_Events()
	Process_Proximities()
	Process_Attacked_Events()
	
	-- Don't test if this is a function, so that we can catch accidental redefinitions when it's used as a function.
	if Process_Reinforcements then
		Process_Reinforcements()
	end
	
	-- This is for behavior that we need evaluated every service without regard to story event state.
	if Story_Mode_Service then
		Story_Mode_Service()
	end
end


-- Try an ability if the AI difficulty will allow a chance
function Try_Ability(thing, ability_name, target)

	if not thing then
		return false
	end

	owner = PlayerObject
	if not Is_A_Taskforce(thing) then
		owner = thing.Get_Owner()
	end
	if owner == nil then
		DebugMessage("%s -- no owner for thing:%s", tostring(Script), tostring(thing))
	end

	-- At a given difficulty, there is a chance that the ability use will be allowed.
	if not Chance(GetAbilityChanceSeed(), GetChanceAllowed(owner.Get_Difficulty())) then
		return false
	end

	if ability_name == "JET_PACK" and not Allowed_Jet_Pack(thing) then
		return false
	end

	return Use_Ability_If_Able(thing, ability_name, target)
end


-- Activates the ability for a unit or a taskforce's units if able.
-- Optionally uses ability on a target.
-- Returns true if the ability was attempted
function Use_Ability_If_Able(thing, ability_name, target)

	-- Taskforces aren't able to check for the ability availablity or readiness, but check this for units
	if Is_A_Taskforce(thing) or (thing.Has_Ability(ability_name) and thing.Is_Ability_Ready(ability_name) and (not thing.Is_Ability_Active(ability_name))) then
	
		if target == nil then
			thing.Activate_Ability(ability_name, true)
		elseif TestValid(target) then
			thing.Activate_Ability(ability_name, target)
		end
		return true
	end
	return false
end


function Is_A_Taskforce(thing)
	return thing and thing.Get_Unit_Table
end


-- This will consider diverting the passed object in order to use an area of effect ability centered on the unit.
function ConsiderDivertAndAOE(object, ability_name, area_of_effect, recent_enemy_units, min_threat_to_use_ability)

	-- At a given difficulty, there is a chance that the divert for ability use will be allowed.
	if (not aoe_pos) and (not Chance(GetCurrentMinute(), GetChanceAllowed(object.Get_Owner().Get_Difficulty()))) then
		return
	end

	-- See if the ability is ready and there are enough enemies around to consider using it.
	if object.Is_Ability_Ready(ability_name) then

		DebugMessage("%s -- %s is ready and trigger number met", tostring(Script), ability_name)

		-- If we haven't found a good use for the ability
		if aoe_pos == nil then

			-- Find a good place to use the ability and divert or throw the result away.
			aoe_pos, aoe_victim_threat = Find_Best_Local_Threat_Center(recent_enemy_units, area_of_effect)
			if aoe_pos == nil then
				DebugMessage("%s -- couldn't get a valid threat center", tostring(Script))
				DebugPrintTable(recent_enemy_units)
				return
			end				

			DebugMessage("%s -- Found ability pos with threat %d", tostring(Script), aoe_victim_threat)
			if (aoe_victim_threat > min_threat_to_use_ability) then
			
				-- Check distance to prevent the unit from spinning in circles on repeated diversions
				if object.Get_Distance(aoe_pos) > 15 then
					DebugMessage("%s -- Met minimum threat; diverting.", tostring(Script))
					Use_Ability_If_Able(object, "SPRINT")
					object.Divert(aoe_pos)
				else
					DebugMessage("%s -- Met minimum threat; Already very close to ideal target so no divert necessary.", tostring(Script))
				end
			else
				DebugMessage("%s -- Resetting pos and threat.", tostring(Script))
				aoe_pos = nil
				aoe_victim_threat = nil
			end

		-- We have found a good use for the ability 
		else

			-- Are we done chasing down the position to use the ability?
			if object.Is_On_Diversion() then
			
				DebugMessage("%s -- In process of diverting to chase threat %d (no new orders issued)", tostring(Script), aoe_victim_threat)
			
			else
				
				-- We're done diverting.  Perform a sanity check to make sure at least one enemy is now in range.
				--if OneOrMoreInRange(object, recent_enemy_units, area_of_effect) then
				-- We're done diverting so check to see if we're at least in range of the best location (even if not centered on it)
				aoe_pos, aoe_victim_threat = Find_Best_Local_Threat_Center(recent_enemy_units, area_of_effect)
				if aoe_pos and (object.Get_Distance(aoe_pos) < area_of_effect) then

					-- Use the ability
					DebugMessage("%s -- Attempting %s.", tostring(Script), ability_name)
					Use_Ability_If_Able(object, ability_name)
				else
					DebugMessage("%s -- Nothing at diversion locaion; aborting.", tostring(Script))
				end
				
				-- Reset everything; this try is done.  If the victims moved too much, we'll need to start over.
				recent_enemy_units = {}
				aoe_pos = nil
				aoe_victim_threat = nil
			end
		end
	end
end

function OneOrMoreInRange(origin_unit, target_unit_list, range)
	for key, unit in pairs(target_unit_list) do
		if origin_unit.Get_Distance(unit) < range then
			return true
		end
	end
	return false
end

function PruneFriendlyObjects(obj_table)
	non_friendly_obj_table = {}
	for i, obj in pairs(obj_table) do
		if obj.Get_Owner() ~= PlayerObject then
			 table.insert(non_friendly_obj_table, obj)
		end
	end
	
	return non_friendly_obj_table
end

function Try_Garrison(tf, unit, offensive_only, range)

	if unit.Is_Category("InfantryHero") or unit.Is_Category("VehicleHero") then
		return false
	end

	lib_nearest_garrison = Find_Nearest(unit, "GarrisonCanFire", unit.Get_Owner(), true)
	
	if TestValid(lib_nearest_garrison) and unit.Can_Garrison(lib_nearest_garrison) then
		lib_dist_to_garrison = unit.Get_Distance(lib_nearest_garrison)
		
		if lib_dist_to_garrison < range then
			unit.Activate_Ability("SPREAD_OUT", false)
			unit.Garrison(lib_nearest_garrison)
			
			if TestValid(tf) then
				tf.Release_Unit(unit)
				unit.Lock_Current_Orders()
			end
			
			return true
		end
	end
	
	if not offensive_only then
		lib_nearest_garrison = Find_Nearest(unit, "CanContainGarrison", unit.Get_Owner(), true)
		
		if TestValid(lib_nearest_garrison) and unit.Can_Garrison(lib_nearest_garrison) then
			lib_dist_to_garrison = unit.Get_Distance(lib_nearest_garrison)
			
			if lib_dist_to_garrison < range then
				unit.Activate_Ability("SPREAD_OUT", false)
				unit.Garrison(lib_nearest_garrison)
				if TestValid(tf) then
					unit.Lock_Current_Orders()
					tf.Release_Unit(unit)
				end
				return true
			end
		end
	end
	
	return false
end

function Try_Deploy_Garrison(object, target, health_threshold)
	lib_any_deployed = false
	lib_garrison_table = object.Get_Garrisoned_Units()
	if table.getn(lib_garrison_table) > 0 then		
		for i,garrison in pairs(lib_garrison_table) do
			if garrison.Get_Hull() > health_threshold then
				if (not TestValid(target)) or garrison.Is_Good_Against(target) then
					garrison.Leave_Garrison()
					lib_any_deployed = true
				end
			end
		end
	end
	return lib_any_deployed
end

function Get_Special_Healer_Property_Flag(unit)

	if not TestValid(unit) then
		return nil
	end
	
	if not special_healer_table then
		special_healer_table = {}
	end
	
	return special_healer_table[unit.Get_Type().Get_Name()]

end

function Set_Land_AI_Targeting_Priorities(tf)

	--First set up generic priorities
	tf.Set_Targeting_Priorities("Infantry_Attack_Move", "Infantry")
	tf.Set_Targeting_Priorities("InfantryHero_Attack_Move", "InfantryHero")
	tf.Set_Targeting_Priorities("Vehicle_Attack_Move", "Vehicle")
	tf.Set_Targeting_Priorities("VehicleHero_Attack_Move", "VehicleHero")
	tf.Set_Targeting_Priorities("AirGunship_Attack_Move", "AirGunship")
	tf.Set_Targeting_Priorities("AirSpeeder_Attack_Move", "AirSpeeder")
end

function Try_Weapon_Switch(object, target)

	lib_switcher_type = object.Get_Type()

	if not lib_aat_type then
		lib_aat_type = Find_Object_Type("AAT")
		lib_aat_cis_type = Find_Object_Type("CIS_AAT")
		lib_aat_pdf_type = Find_Object_Type("AAT_PDF")
		lib_aat_commander_type = Find_Object_Type("COMMANDER_AAT_IV")
		lib_aat_whorm_type = Find_Object_Type("WHORM_AAT")
		lib_aat_oom_224_type = Find_Object_Type("OOM_224_AAT")
		lib_aat_tx_20_type = Find_Object_Type("TX_20_AAT")
		lib_defoliator_tf_type = Find_Object_Type("DEFOLIATOR")
		lib_defoliator_cis_type = Find_Object_Type("CIS_DEFOLIATOR")
		lib_defoliator_durd_type = Find_Object_Type("LOK_DURD_DEFOLIATOR")	
		lib_supertank_tf_type = Find_Object_Type("SUPER_TANK")
		lib_supertank_cis_type = Find_Object_Type("CIS_SUPER_TANK")
		lib_supertank_tx21_type = Find_Object_Type("TX_21_SUPERTANK")
		lib_supertank_drogen_type = Find_Object_Type("DROGEN_HOSH_SUPERTANK")
		lib_bossk_type = Find_Object_Type("BOSSK")
		lib_clone_commando_type = Find_Object_Type("CLONE_COMMANDO_CONTAINER")
		lib_nimbus_commando_type = Find_Object_Type("NIMBUS_COMMANDO_CONTAINER")		
		lib_at_st_type = Find_Object_Type("AT_ST_WALKER")
		lib_at_st_otto_type = Find_Object_Type("OTTO_ATST")
		lib_at_st_xantus_type = Find_Object_Type("XANTUS_ATST")
		lib_at_st_xexus_type = Find_Object_Type("XEXUS_SHEV")
		lib_at_st_a_type = Find_Object_Type("AT_ST_A_WALKER")
		lib_espo_walker_type = Find_Object_Type("ESPO_WALKER_101")
		lib_espo_walker_early_type = Find_Object_Type("ESPO_WALKER_91")		
	end

	if lib_switcher_type == lib_aat_type then
		object.Activate_Ability("ROCKET_ATTACK", target.Is_Category("InfantryHero") or target.Is_Category("Infantry"))
	elseif lib_switcher_type == lib_aat_pdf_type then
		object.Activate_Ability("ROCKET_ATTACK", (target.Is_Category("Infantry") or target.Is_Category("InfantryHero")) and GameRandom.Get_Float() > 0.6)
	elseif lib_switcher_type == lib_supertank_tf_type then
		object.Activate_Ability("DEPLOY", (target.Is_Category("Structure") or target.Is_Category("Vehicle") or target.Is_Category("VehicleHero")) and GameRandom.Get_Float() > 0.4)
	elseif lib_switcher_type == lib_supertank_cis_type then
		object.Activate_Ability("DEPLOY", (target.Is_Category("Structure") or target.Is_Category("Vehicle") or target.Is_Category("VehicleHero")) and GameRandom.Get_Float() > 0.4)
	elseif lib_switcher_type == lib_bossk_type then
		object.Activate_Ability("ROCKET_ATTACK", (target.Is_Category("Infantry") or target.Is_Category("InfantryHero")) and GameRandom.Get_Float() > 0.6)
	elseif lib_switcher_type == lib_clone_commando_type then
		object.Activate_Ability("ROCKET_ATTACK", (target.Is_Category("Infantry") or target.Is_Category("InfantryHero")) and GameRandom.Get_Float() > 0.33)		
	elseif lib_switcher_type == lib_nimbus_commando_type then
		object.Activate_Ability("ROCKET_ATTACK", (target.Is_Category("Infantry") or target.Is_Category("InfantryHero")) and GameRandom.Get_Float() > 0.33)		
	elseif lib_switcher_type == lib_at_st_type then
		object.Activate_Ability("ROCKET_ATTACK", target.Is_Category("Structure") or target.Is_Category("Vehicle") or target.Is_Category("VehicleHero"))
	elseif lib_switcher_type == lib_at_st_a_type then
		object.Activate_Ability("ROCKET_ATTACK", target.Is_Category("Structure") or target.Is_Category("Vehicle") or target.Is_Category("VehicleHero"))
	elseif lib_switcher_type == lib_espo_walker_type then
		object.Activate_Ability("ROCKET_ATTACK", target.Is_Category("Structure") or target.Is_Category("Vehicle") or target.Is_Category("VehicleHero"))
	elseif lib_switcher_type == lib_espo_walker_early_type then
		object.Activate_Ability("ROCKET_ATTACK", target.Is_Category("Structure") or target.Is_Category("Vehicle") or target.Is_Category("VehicleHero"))		
	elseif object.Should_Switch_Weapons(target) then
		object.Activate_Ability("SWAP_WEAPONS", not object.Is_Ability_Active("SWAP_WEAPONS"))
	end	

end

function Determine_Magic_Wait_Duration()

	lib_magic_wait_time = 2400 - GetCurrentTime()
	if lib_magic_wait_time < 60 then 
		lib_magic_wait_time = 60
	end
	
	return lib_magic_wait_time
end

function Is_Type_In_List(unit_type, type_name_list)
	for i, type_name in pairs(type_name_list) do
		DebugMessage("%s -- type:%s checking match to:%s", tostring(Script), unit_type.Get_Name(), type_name)
		if unit_type == Find_Object_Type(type_name) then
			return true
		end
	end
	return false
end

function Allowed_Jet_Pack(object)
	disallowed_jet_pack = {
		"Jaska",
		"Dorjander_Kace",
		"Pre_Vizsla"
	}

	if Is_Type_In_List(object.Get_Type(), disallowed_jet_pack) then
		return false
	end

	return true
end