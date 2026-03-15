require("PGBaseDefinitions")

-- Deprecated...
--
-- function ProduceForce(taskforce)
--	tfIndex = 0
--
--	DebugMessage("Beginning production on %s at %s.", tostring(taskforce),
--		  tostring(taskforce.Production_Facility()))
--
--	-- loop through all the unit types and produce each one.
--	UnitType = taskforce.Get_Type_Of_Unit(tfIndex)
--	while UnitType do
--
--	   -- Build the object at the production facility.
--	   tfObj = WaitProduceObject(UnitType, taskforce.Production_Facility())
--	   DebugMessage("Object %s produced.", tostring(tfObj))
--
--	   -- Add the object to the task force.
--	   taskforce.Add_Force(tfObj)
--
--		-- Remove our reference to the object, since a merge will destroy it.
--	   tfObj.Release()
--
--	   -- Merge the new fleets together.
--	   BlockOnCommand(taskforce.Form_Units())
--
--	   -- Look for another unit type.
--	   tfIndex = tfIndex + 1
--	   UnitType = taskforce.Get_Type_Of_Unit(tfIndex)
--	end
-- end
--
-- function ProduceObject(player, objecttype, where)
--	return _ProduceObject(player, objecttype, where)
-- end
--
-- function WaitProduceObject(objecttype, where)
--	return BlockOnCommand(ProduceObject(PlayerObject, objecttype, where))
-- end

function WaitForever()
	DebugMessage("%s -- Waiting forever...", tostring(Script))
	while true do
		PumpEvents()
	end
--	BlockOnCommand(BlockForever())
	DebugMessage("%s -- Something interrupted the wait!.", tostring(Script))
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

-- Cancels all occurences of this timer function
function Cancel_Timer(func)
	if func ~= nil then
		TimerTable[func] = nil
	else
		MessageBox("%s -- cancelling nonexistant function, got:%s; aborting.", tostring(Script), type(func))
	end
end


-- Setup a callback for the death or deletion of a given object.
function Register_Death_Event(obj, func)
	if not TestValid(obj) then
		MessageBox("%s -- Error, object doesn't exist or has already died.", tostring(Script))
		return
	end

	if DeathTable[obj] ~= nil then
		MessageBox("%s -- Error, object already registered for death event", tostring(Script))
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

-- Setup a callback for a given object falling under attack.
function Register_Attacked_Event(obj, func)
	if not TestValid(obj) then
		MessageBox("%s -- Error, object doesn't exist or has died.", tostring(Script))
		return
	end

	if AttackedTable[obj] ~= nil then
		MessageBox("%s -- Error, object already registered for attacked event", tostring(Script))
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
				--MessageBox("obj:%s now has no deadly enemy", tostring(obj))
				table[2] = false
				table[1](false, nil, obj)
			end
		end
	end
end

function Cancel_Attacked_Event(obj)
	if obj ~= nil then
		AttackedTable[obj] = nil
	else
		MessageBox("received nil object")
	end
end



-- Set up proximity triggers on arbitrary objects and have them serviced.
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
function Try_Ability(thing, ability_name, target, activate)

	--[[owner = PlayerObject
	if not Is_A_Taskforce(thing) then
		owner = thing.Get_Owner()
	end
	if owner == nil then
		MessageBox("%s -- no owner for thing:%s", tostring(Script), tostring(thing))
	end

	-- At a given difficulty, there is a chance that the ability use will be allowed.
	if not Chance(GetAbilityChanceSeed(), GetChanceAllowed(owner.Get_Difficulty())) then
		return false
	end]]

	return Use_Ability_If_Able(thing, ability_name, target, activate)
end

function Deactivate_Ability(thing, ability_name)
	if Is_A_Taskforce(thing) then
		tf_units = thing.Get_Unit_Table()
		for _,unit in pairs(tf_units) do
			if TestValid(unit) then
				if unit.Has_Ability(ability_name) then
					unit.Activate_Ability(ability_name, false)
				end
			end
		end
	else
		if thing.Has_Ability(ability_name) then
			thing.Activate_Ability(ability_name, false)
		end
	end
end

function Contained_Object_Count(thing)
	count = 0
	if thing ~= nil and thing.Get_Contained_Object_Count ~= nil then
		count = thing.Get_Contained_Object_Count()
	end
	return count
end


function Is_Ability_Available(thing, ability_name)
	return (thing.Has_Ability(ability_name) and thing.Is_Ability_Ready(ability_name) and (not thing.Is_Ability_Active(ability_name)))
end


-- Activates the ability for a unit or a taskforce's units if able.
-- Optionally uses ability on a target.
-- Returns true if the ability was attempted
function Use_Ability_If_Able(thing, ability_name, target)
	-- Check if its a Taskforce, if it is, loop through the Taskforce units and try to activate each one
	if Is_A_Taskforce(thing) then
		tf_units = thing.Get_Unit_Table()
		any_activated = false
		for _,unit in pairs(tf_units) do
			if TestValid(unit) then
				if Is_Ability_Available(unit, ability_name) then
					if target == nil then
						unit.Activate_Ability(ability_name, true)
					elseif TestValid(target) then
						unit.Activate_Ability(ability_name, target)
					end
					any_activated = true
				end
			end
		end
		return any_activated
	else
		if Is_Ability_Available(thing, ability_name) then
			if target == nil then
				thing.Activate_Ability(ability_name, true)
			elseif TestValid(target) then
				thing.Activate_Ability(ability_name, target)
			end
			return true
		end
		return false
	end
end

function Try_Activate_Ability(thing, ability_name, target)

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

function Try_Deactivate_Ability(thing, ability_name, target)

	-- Taskforces aren't able to check for the ability availablity or readiness, but check this for units
	if Is_A_Taskforce(thing) or (thing.Has_Ability(ability_name) and (not thing.Is_Ability_Ready(ability_name)) and thing.Is_Ability_Active(ability_name)) then
	
		if target == nil then
			thing.Activate_Ability(ability_name, false)
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
		if not (obj.Get_Owner() == PlayerObject) then
			 table.insert(non_friendly_obj_table, obj)
		end
	end
	
	return non_friendly_obj_table
end

function Try_Garrison(tf, unit, offensive_only, range)
	--Debug_Text("DEBUG_8")
	lib_nearest_garrison = Find_Nearest(unit, "GarrisonCanFire", unit.Get_Owner(), true)
	
	if TestValid(lib_nearest_garrison) and unit.Can_Garrison(lib_nearest_garrison)
			and (lib_nearest_garrison.Is_Category("LightVehicle | Vehicle | HeavyVehicle | SHeavyVehicle")) then
		lib_dist_to_garrison = unit.Get_Distance(lib_nearest_garrison)
		
		if lib_dist_to_garrison < range then
			Deactivate_Ability(unit, "SPREAD_OUT")
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
		
		if TestValid(lib_nearest_garrison) and unit.Can_Garrison(lib_nearest_garrison)
				and (lib_nearest_garrison.Is_Category("LightVehicle | Vehicle | HeavyVehicle | SHeavyVehicle")) then
			lib_dist_to_garrison = unit.Get_Distance(lib_nearest_garrison)
			
			if lib_dist_to_garrison < range then
				Deactivate_Ability(unit, "SPREAD_OUT")
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
	--Debug_Text("DEBUG_9")
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
		special_healer_table["Battledroids"] = "HealsVehicles"
		special_healer_table["BattleDroid_Squad_M_LucreHulk"] = "HealsVehicles"
		special_healer_table["Super_Battledroid"] = "HealsVehicles"
		special_healer_table["B2_Super_Team"] = "HealsVehicles"
		special_healer_table["Super_Battledroid"] = "HealsVehicles"
		special_healer_table["Cis_Super_BattleDroid_Squad"] = "HealsVehicles"
		special_healer_table["Rebel_Destroyer_Droid_Mk1"] = "HealsVehicles"
	end
	
	return special_healer_table[unit.Get_Type().Get_Name()]

end

--MaxiM: This list contains all units, that we allow to kite (retreat in space battles)
--		  Those are corvette heros = CorvetteHero
--		  fast frigates (<Max_Speed> >= 2.5) = FastFrigate
--		  frigates with shield boost = ShieldBoostFrigate
--		  carriers = Carrier
--		  healer = Healer

--[[function Get_Kiting_Units_Property_Flag(unit)

	if not TestValid(unit) then
		return nil
	end

	if not kiting_units_table then
		kiting_units_table = {}
		kiting_units_table["SUNDERED_HEART"] = "CorvetteHero"
		kiting_units_table["WILD_KARRDE"] = "CorvetteHero"

		kiting_units_table["CORELLIAN_DESTROYER"] = "FastFrigate"
		kiting_units_table["MC-30_FRIGATE"] = "FastFrigate"
		kiting_units_table["MC-40_Frigate"] = "FastFrigate"
		kiting_units_table["NEBULON_B_FRIGATE"] = "FastFrigate"
		kiting_units_table["IMPERIAL_ESCORT_CARRIER"] = "FastFrigate"
		kiting_units_table["VINDICATOR_CRUISER"] = "FastFrigate"
		kiting_units_table["BIZZARO_CULT_VINDICATOR_CRUISER"] = "FastFrigate"
		kiting_units_table["VINDICATOR_CRUISER_R"] = "FastFrigate"
		kiting_units_table["IMMOBILIZER_CRUISER"] = "FastFrigate"
		kiting_units_table["IMMOBILIZER_CRUISER_R"] = "FastFrigate"
		kiting_units_table["IMMOBILIZER_CRUISER_U"] = "FastFrigate"
		kiting_units_table["HAMMERHEAD_B_FRIGATE"] = "FastFrigate"
		kiting_units_table["MUNIFICENT_FRIGATE"] = "FastFrigate"
		kiting_units_table["MUNIFICENT_FRIGATE_E"] = "FastFrigate"
		kiting_units_table["MUNIFICENT_FRIGATE_R"] = "FastFrigate"
		kiting_units_table["MUNIFICENT_FRIGATE_U"] = "FastFrigate"
		kiting_units_table["NOVA_CRUISER"] = "FastFrigate"
		kiting_units_table["NOVA_CRUISER_E"] = "FastFrigate"
		kiting_units_table["NOVA_CRUISER_R"] = "FastFrigate"
		kiting_units_table["NOVA_CRUISER_U"] = "FastFrigate"
		kiting_units_table["BOTHAN_ASSAULT_CRUISER"] = "FastFrigate"
		kiting_units_table["BOTHAN_ASSAULT_CRUISER_E"] = "FastFrigate"
		kiting_units_table["BOTHAN_ASSAULT_CRUISER_R"] = "FastFrigate"
		kiting_units_table["BOTHAN_ASSAULT_CRUISER_U"] = "FastFrigate"
		kiting_units_table["EMPIRE_FLEET_COMMANDER_CAPTAIN"] = "FastFrigate"
		kiting_units_table["REBEL_FLEET_COMMANDER_CAPTAIN"] = "FastFrigate"
	
		kiting_units_table["ASSAULT_FRIGATE_MARK_II"] = "ShieldBoostFrigate"

		kiting_units_table["QUASAR_CARRIER"] = "Carrier"
		kiting_units_table["QUASAR_CARRIER_LOADOUT2"] = "Carrier"
		kiting_units_table["TON_FALK_CARRIER"] = "Carrier"
		kiting_units_table["TON_FALK_CARRIER_LOADOUT2"] = "Carrier"
	end

	return kiting_units_table[unit.Get_Type().Get_Name()]

end]]

function Set_Land_AI_Targeting_Priorities(tf)
	-- TODO: update this for mod units
	--First set up generic priorities
	tf.Set_Targeting_Priorities("Infantry_Attack_Move", "Infantry")
	tf.Set_Targeting_Priorities("Air_Attack_Move", "Air")
	tf.Set_Targeting_Priorities("LightVehicle_Attack_Move", "LightVehicle")
	tf.Set_Targeting_Priorities("Vehicle_Attack_Move", "Vehicle")
	
	--Now for some more specific stuff
	--tf.Set_Targeting_Priorities("Rocket_Infantry_Attack_Move", "Plex_Soldier_Team")
	--tf.Set_Targeting_Priorities("Rocket_Infantry_Attack_Move", "Pirate_Plex_Soldier_Team")
	--tf.Set_Targeting_Priorities("Light_Vehicle_Attack_Move", "TIE_Crawler")
	--tf.Set_Targeting_Priorities("Light_Vehicle_Attack_Move", "AT_ST_Walker_Walker")
	--tf.Set_Targeting_Priorities("Light_Vehicle_Attack_Move", "T2B_Tank")
	--tf.Set_Targeting_Priorities("Light_Vehicle_Attack_Move", "Dark_Trooper_PhaseI")
	--tf.Set_Targeting_Priorities("Artillery_Attack_Move", "MPTL")
	tf.Set_Targeting_Priorities("Artillery_Attack_Move", "AT_DT_Walker")
	tf.Set_Targeting_Priorities("Artillery_Attack_Move", "AAC_Hovertank")	
	tf.Set_Targeting_Priorities("Artillery_Attack_Move", "Hailfire_Tank")	
	tf.Set_Targeting_Priorities("Artillery_Attack_Move", "SPMAT_Walker")
	tf.Set_Targeting_Priorities("Artillery_Attack_Move", "Imperial_Artillery_Corp")
end

function Try_Kiting_Ability_Space(object)
	Deactivate_Ability(object, "SPREAD_OUT")
	Try_Ability(object, "SPOILER_LOCK")
	Try_Ability(object, "TURBO")
	Try_Ability(object, "STEALTH")
	Try_Ability(object, "REPLENISH_WINGMEN")
end

function Try_Weapon_Switch_Space(object, target)
	--Switch Lasers to Ion Cannons
	if object.Get_Type().Get_Name() == "A-WING_ELITE_SQUADRON" or
			object.Get_Type().Get_Name() == "A-WING_ELITE_GARRISON" or
			object.Get_Type().Get_Name() == "TURBO_SAILER_SQUADRON" or
			object.Get_Type().Get_Name() == "TURBO_SAILER_GARRISON" or
			object.Get_Type().Get_Name() == "TURBO_SAILER_ELITE_SQUADRON" or
			object.Get_Type().Get_Name() == "TURBO_SAILER_ELITE_GARRISON" then
		object.Activate_Ability("ROCKET_ATTACK", target.Get_Shield() > 0.2 and
		(not target.Is_Category("Fighter") and not target.Is_Category("Gunship") and not target.Is_Category("Bomber") and not target.Is_Category("Corvette")))
	--Switch Anti-Fighter-Shield Missiles to Anti-Armor Missiles
	elseif object.Get_Type().Get_Name() == "TIE_INTERDICTOR_SQUADRON" or
			object.Get_Type().Get_Name() == "TIE_INTERDICTOR_GARRISON" or
			object.Get_Type().Get_Name() == "TIE_DEFENDER_SQUADRON" or
			object.Get_Type().Get_Name() == "TIE_DEFENDER_GARRISON" or
			object.Get_Type().Get_Name() == "TIE_DEFENDER_ELITE_SQUADRON" or
			object.Get_Type().Get_Name() == "TIE_DEFENDER_ELITE_GARRISON" then
		object.Activate_Ability("ROCKET_ATTACK", target.Get_Shield() > 0.0 and target.Is_Category("Fighter") or target.Is_Category("Gunship") or target.Is_Category("Bomber"))
	--Missileboat Special Case
	elseif object.Get_Type().Get_Name() == "MISSILEBOAT_SQUADRON" or
			object.Get_Type().Get_Name() == "MISSILEBOAT_GARRISON" then
		object.Activate_Ability("ROCKET_ATTACK", target.Get_Shield() > 0.0 and 
		(not target.Is_Category("Fighter") and not target.Is_Category("Gunship") and not target.Is_Category("Bomber")) and GameRandom.Get_Float() > 0.5)
	end
end

function Try_Weapon_Switch_Ground(object, target)
	--Maximun Firepower
	if object.Get_Type().Get_Name() == "AT_AT" or
			object.Get_Type().Get_Name() == "AT_AT_Team" or
			object.Get_Type().Get_Name() == "Veers_Ground" or
			object.Get_Type().Get_Name() == "Veers_Ground_GC" or				
			object.Get_Type().Get_Name() == "AT_AT_Behemoth" then
		object.Activate_Ability("MAXIMUM_FIREPOWER", target.Get_Health() > 0.6 and target.Is_Category("Vehicle | HeavyVehicle | SHeavyVehicle") or target.Is_Category("Structure"))
	--Ion Switch
	elseif object.Get_Type().Get_Name() == "Persuader" or
			object.Get_Type().Get_Name() == "Droideka" then
		object.Activate_Ability("ROCKET_ATTACK", target.Get_Shield() > 0.2 and target.Is_Category("LightVehicle | Vehicle | HeavyVehicle | SHeavyVehicle") or target.Is_Category("Structure"))
	--Anti Air Mode
	elseif object.Get_Type().Get_Name() == "TX_228" or
			object.Get_Type().Get_Name() == "Canderous_Tank" or
			object.Get_Type().Get_Name() == "Canderous_Rushed" or
			object.Get_Type().Get_Name() == "Ominous" or			
			object.Get_Type().Get_Name() == "T2B" then
		object.Activate_Ability("ROCKET_ATTACK", target.Get_Health() > 0.1 and target.Is_Category("Air"))		
	--Ammo Switch to HE
	elseif object.Get_Type().Get_Name() == "AT_ST_Walker" or
			object.Get_Type().Get_Name() == "TX_130T" or
			object.Get_Type().Get_Name() == "T3B" or
			object.Get_Type().Get_Name() == "AAC_3_Hovertank" or
			object.Get_Type().Get_Name() == "T4B" or
			object.Get_Type().Get_Name() == "Rebel_AAT_Tank" or 
			object.Get_Type().Get_Name() == "MAL" then
		object.Activate_Ability("ROCKET_ATTACK", target.Is_Category("Infantry | Droid"))
	end
end

function Determine_Magic_Wait_Duration()

	lib_magic_wait_time = 2400 - GetCurrentTime()
	if lib_magic_wait_time < 60 then 
		lib_magic_wait_time = 60
	end
	
	return lib_magic_wait_time
end

function Get_Shield_And_Health(unit)
	hull = unit.Get_Hull()
	shields = unit.Get_Shield()

	if shields == 0 or hull < shields then
		return hull
	else 
		return shields 
	end
end

function Is_Unit_Damaged(unit, threshold)
	if TestValid(unit) then
		return unit.Get_Hull() < threshold or unit.Get_Shield() < threshold
	end
	return false
end

function Get_Freighter_Multiplier(object)
	multiplier = 1
	if object.Get_Type().Get_Name() == "BFF_BULK_FREIGHTER" or
			object.Get_Type().Get_Name() == "GR75_FREIGHTER" or
			object.Get_Type().Get_Name() == "HF901_FREIGHTER" then
		multiplier = 2.5
	end

	return multiplier
end

function Try_Offensive_Ability_Space(object, target)
	--Switch to Concussion Missiles
	object_name = object.Get_Type().Get_Name()
	if object_name == "A-Wing_Elite"
			or object_name == "A-Wing_Elite_G"
	then
		if target.Is_Category("Fighter | Bomber | Gunship") and not (target.Get_Shield() > 0.01) then
			Try_Ability(object, "ROCKET_ATTACK") else Deactivate_Ability(object, "ROCKET_ATTACK")			
		end
	--Switch to HE-Missile
	elseif object_name == "MissileBoat"
			or object_name == "MissileBoat_G"
	then
		if target.Is_Category("Fighter | Bomber | Gunship") then
			Try_Ability(object, "ROCKET_ATTACK")
		end
	--Switch to AP-Missile
	elseif object_name == "TIE_Defender_Elite"
			or object_name == "TIE_Defender_Elite_G"
			or object_name == "TIE_Interdictor"
			or object_name == "TIE_Interdictor_G"
	then
		if target.Is_Category("Fighter | Bomber | Gunship | Corvette | Frigate") and not (target.Get_Shield() > 0.01) then
			Try_Ability(object, "ROCKET_ATTACK")
		end
	--Switch to Proton Torpedoes
	elseif object_name == "MissileBoat_Elite"
			or object_name == "MissileBoat_Elite_G"
	then
		if target.Is_Category("Capital | Frigate | SpaceStation") then
			Try_Ability(object, "ROCKET_ATTACK")
		end
	--Switch to Ion Cannon
	elseif object_name == "Turbo_Sailer"
			or object_name == "Turbo_Sailer_G"
			or object_name == "Turbo_Sailer_Elite"
			or object_name == "Turbo_Sailer_Elite_G"
	then
		if target.Is_Category("Capital | Frigate | SpaceStation") and (target.Get_Shield() > 0.2) then
			Try_Ability(object, "ROCKET_ATTACK") else Deactivate_Ability(object, "ROCKET_ATTACK")
		end
	-- Defensive Formation, use when targeting bigger ships
	--[[elseif object_name == "E_XG1_STAR_WING_S"
			or object_name == "E_XG1_STAR_WING_F"
			or object_name == "E_TIE_BRUTE_S"
			or object_name == "RIKXYRK_MERC_COMMANDER_SQUADRON"
	then
		if not target.Is_Category("Fighter | Bomber") then
			Try_Ability(object, "SPREAD_OUT")
		end]]
	-- Overcharge Reactor, activate when health is high
	--[[elseif object_name == "N_SUPAFIGHTER_S"
			or object_name == "U_SUPAFIGHTER_S"
			or object_name == "H_SUPAFIGHTER_S"
			or object_name == "U_SUPAFIGHTER_F" then
		if (not target.Is_Category("Fighter | Bomber")) and (object.Get_Hull() > 0.5) then
			Try_Ability(object, "STIM_PACK")
		end]]
	-- Offensive Formation, use when dog fighting
	--[[elseif object_name == "E_HOWLRUNNER_S"
			or object_name == "N_CUTLASS_9_S"
			or object_name == "R_CUTLASS_9_S"
			or object_name == "R_CUTLASS_9_F"
			or object_name == "N_KIHRAXZ_S"
			or object_name == "N_FANG_FIGHTER_S"
			or object_name == "N_FANG_FIGHTER_F" then
		if target.Is_Category("Fighter | Bomber") then
			Try_Ability(object, "SPREAD_OUT")
		end]]
	-- Power to Weapons/Strike, activate against fighters
	elseif object_name == "TIE_Bizarro"
			or object_name == "TIE_Bizarro_G"
	then
		if not target.Is_Category("Fighter | Bomber | Gunship") then
			Try_Ability(object, "POWER_TO_WEAPONS")
		end
	-- Target Lock | Burst Fire, activate against fighters
	--[[elseif object_name == "R_E_WING_S"
			or object_name == "R_E_WING_F"
			or object_name == "N_N1_FIGHTER_S"
			or object_name == "N_TOSCAN_FIGHTER_S"
			or object_name == "U_TOSCAN_FIGHTER_S"
			or object_name == "H_TOSCAN_FIGHTER_S"
			or object_name == "U_TOSCAN_FIGHTER_F"
			or object_name == "N_DUNELIZARD_F"
			or object_name == "N_DUNELIZARD_S"
			or object_name == "U_DUNELIZARD_S" then
		if target.Is_Category("Fighter | Bomber") then
			Try_Ability(object, "ROCKET_ATTACK")
		end]]
	-- Deployable Massdriver turrets
	--[[elseif object_name == "U_HWK_290_S" then
		if not target.Is_Category("Fighter | Bomber | NonCombatHero | Corvette") then
			Try_Ability(object, "HARMONIC_BOMB")
		end]]
	-- Deployable Flak turrets
	elseif object_name == "Boba_Fett_Slave_I" then
		if target.Is_Category("Fighter | Bomber") then
			Try_Ability(object, "HARMONIC_BOMB")
		end
	--Ion Pulse Missile Burst
	elseif object_name == "Arquitens"
			or object_name == "Arquitens_E"
			or object_name == "Arquitens_R"
			or object_name == "Arquitens_U"
			or object_name == "Arquitens_GE"
			or object_name == "Arquitens_Rep"
			or object_name == "Arquitens_Warlords"
			or object_name == "Gladiator_Star_Destroyer"
			or object_name == "Gladiator_Star_Destroyer_R"
			or object_name == "Gladiator_Star_Destroyer_U"
			or object_name == "Gladiator_Star_Destroyer_GE"
			or object_name == "Gladiator_Star_Destroyer_Warlords"
			or object_name == "Gladiator_Star_Destroyer_Loadout2"
			or object_name == "Gladiator_Star_Destroyer_Loadout2_GE"
			or object_name == "Gladiator_Star_Destroyer_MP"
			or object_name == "Screed_Demolisher"
			or object_name == "Screed_Demolisher_GE"
			or object_name == "Screed_Demolisher_MP"
	then
		if target.Is_Category("Capital | Frigate | SpaceStation") then
			Try_Ability(object, "ROCKET_ATTACK")
		end
	--Heavy Plasma Torpedo Burst
	elseif object_name == "MC-30_Frigate"
			or object_name == "MC-30_Frigate_RA" then		
		if Is_Ability_Available(object, "ROCKET_ATTACK") and (target.Get_Shield() > 0.2) and target.Is_Category("Capital | Frigate | SpaceStation") then
			Try_Ability(object, "ROCKET_ATTACK")
		end
	-- Power to Main Batteries
	-- Make sure, that the main weapons are still alive before using the ability
	elseif object_name == "Dreadnaught_Cruiser"
			or object_name == "Dreadnaught_Cruiser_E"
			or object_name == "Dreadnaught_Cruiser_R"
			or object_name == "Dreadnaught_Cruiser_U"
			or object_name == "Dreadnaught_Cruiser_CSA"
			or object_name == "Dreadnaught_Cruiser_Rep" then
		if Is_Ability_Available(object, "POWER_TO_WEAPONS")	and target.Is_Category("Capital") then
			--[[if Are_Hardpoints_Alive(object, "Proj_Ship_Laser_Heavy_R", 4) then]]
				Try_Ability(object, "POWER_TO_WEAPONS")
			--[[end]]
		end
	elseif object_name == "Gorgon_Star_Destroyer_II"
			or object_name == "Pirate_Gorgon_Star_Destroyer_II" 
			or object_name == "Devastator_Star_Destroyer" then
		if Is_Ability_Available(object, "POWER_TO_WEAPONS") and target.Is_Category("Capital") then
			--[[if Are_Hardpoints_Alive(object, "Proj_Ship_Turbolaser_Green_Heavy", 3) then]]
				Try_Ability(object, "POWER_TO_WEAPONS")
			--[[end]]
		end
	-- Power to Weapons
	elseif object_name == "Marauder_Missile_Cruiser"
			or object_name == "Marauder_Missile_Cruiser_CSA"
			or object_name == "Marauder_Missile_Cruiser_U"
			or object_name == "Marauder_Missile_Cruiser_HC"
			or object_name == "Nebulon_B_Frigate_Warlords"
			or object_name == "Hammerhead_B_Frigate"
			or object_name == "Rebel_Fleet_Commander_Captain" then
		if object.Get_Rate_Of_Damage_Taken() < 20 and target.Is_Category("Frigate | Capital | SpaceStation") then
			Try_Ability(object, "POWER_TO_WEAPONS")
		end
	-- Ion Barrage
	-- For ships with untargetable Ions
	--[[elseif object_name == "Enforcer_Cruiser"
		if target.Get_Shield() > 0.2 and target.Is_Category("Frigate | Capital | SpaceStation") then
			Try_Ability(object, "FULL_SALVO")
		end]]
	elseif object_name == "Star_Destroyer_Ion"
			or object_name == "Star_Destroyer_Ion_Warlords" then
		if Is_Ability_Available(object, "FULL_SALVO") and (target.Get_Shield() > 0.2) and target.Is_Category("Capital") then
			--[[if Are_Hardpoints_Alive(object, "Proj_Ship_Ion_Cannon_Large_Quad_Line_Short", 2) then]]
				Try_Ability(object, "FULL_SALVO")
			--[[end]]
		end
	elseif object_name == "Nebula_Star_Destroyer" then
		if Is_Ability_Available(object, "FULL_SALVO") and (target.Get_Shield() > 0.2) and target.Is_Category("Capital") then
			--[[if Are_Hardpoints_Alive(object, "Proj_Ship_Turbo_Ion_Cannon_Large", 1) then]]
				Try_Ability(object, "FULL_SALVO")
			--[[end]]
		end
		if Is_Ability_Available(object, "FULL_SALVO") and (target.Get_Hull() > 0.5) and target.Is_Category("Capital") then
			--[[if Are_Hardpoints_Alive(object, "Proj_Ship_Turbolaser_Red_Triple", 4) then]]
				Try_Ability(object, "FULL_SALVO")
			--[[end]]
		end
	-- Ion Barrage Stun
	--[[elseif object_name == "T_NOVA_CRUISER"
		or object_name == "HAPANS_NOVA_CRUISER"
			or object_name == "R_NOVA_CRUISER"
			or object_name == "U_NOVA_CRUISER"
			or object_name == "E_NOVA_CRUISER" then
		if (target.Get_Hull() > 0.5) and target.Is_Category("Frigate | Capital | SpaceStation") then
			Try_Ability(object, "FULL_SALVO")
		end]]
	-- Full Salvo
	-- Torpedos untargetable
	--[[elseif object_name == "U_HF901_FREIGHTER"
			or object_name == "T_INTERCEPTOR_FRIGATE"
			or object_name == "R_INTERCEPTOR_FRIGATE"
			or object_name == "U_INTERCEPTOR_FRIGATE"
			or object_name == "H_INTERCEPTOR_FRIGATE"
			or object_name == "VIGOS_FIST"
	then
		if (target.Get_Hull() > 0.5) and (target.Get_Shield() > 0.5) and target.Is_Category("Capital") then
			Try_Ability(object, "FULL_SALVO")
		end]]
	-- Torpedos targetable
	elseif object_name == "Providence_Destroyer"
			or object_name == "Providence_Destroyer_U"
			or object_name == "Intemptor" then
		if Is_Ability_Available(object, "FULL_SALVO") and (target.Get_Hull() > 0.5) and (target.Get_Shield() > 0.5) and target.Is_Category("Capital") then
			--[[if Are_Hardpoints_Alive(object, "Proj_Proton_Torpedo_Adv", 1) then]]
				Try_Ability(object, "FULL_SALVO")
			--[[end]]
		end
	-- Rockets untargetable
	--[[elseif object_name == "T_HEAVY_CORELLIAN_GUNSHIP"
			or object_name == "U_HEAVY_CORELLIAN_GUNSHIP"
			or object_name == "CSA_HEAVY_CORELLIAN_GUNSHIP"
			or object_name == "VIGOS_FIST"
			or object_name == "T_INTERCEPTOR_4_FRIGATE"
			or object_name == "U_INTERCEPTOR_4_FRIGATE"
			or object_name == "MERCENARY_INTERCEPTOR4_FRIGATE"
			or object_name == "ZEKKA_THYNE_INTERCEPTOR_4" then
		if Is_Ability_Available(object, "FULL_SALVO") and (target.Get_Hull() > 0.5) and target.Is_Category("Capital") then
			Try_Ability(object, "FULL_SALVO")
		end]]
	-- Rockets targetable
	--[[elseif object_name == "T_VICTORY_STAR_DESTROYER_1"
			or object_name == "E_VICTORY_STAR_DESTROYER_1"
			or object_name == "E_VICTORY_STAR_DESTROYER_1_FIGHTERS"
			or object_name == "CSA_VICTORY_STAR_DESTROYER_1"
			or object_name == "T_CORELLIAN_BATTLECRUISER"
			or object_name == "R_CORELLIAN_BATTLECRUISER"
			or object_name == "E_CORELLIAN_BATTLECRUISER"
			or object_name == "P_CORELLIAN_BATTLECRUISER"
			or object_name == "U_CORELLIAN_BATTLECRUISER"
			or object_name == "R_MC80A_ALLIANCE" then
		if Is_Ability_Available(object, "FULL_SALVO") and (target.Get_Hull() > 0.5) and target.Is_Category("Capital") then
			if Are_Hardpoints_Alive(object, "Proj_Ship_Heavy_Artillery_Rocket", 2) then
				Try_Ability(object, "FULL_SALVO")
			end
		end]]
	-- Lasers targetable
	elseif object_name == "Vindicator_Cruiser"
			or object_name == "Vindicator_Cruiser_R"
			or object_name == "Vindicator_Cruiser_Warlords"
			or object_name == "Empire_Fleet_Commander_Captain"
			or object_name == "Bizzaro_Cult_Vindicator_Cruiser"
			or object_name == "Vindicator_Cruiser_Kas" then
		if Is_Ability_Available(object, "FULL_SALVO") and (target.Get_Hull() > 0.2) and target.Is_Category("Capital") then
			--[[if Are_Hardpoints_Alive(object, "Proj_Ship_Turbolaser_Green_Dual", 2) then]]
				Try_Ability(object, "FULL_SALVO")
			--[[end]]
		end
	elseif object_name == "Enforcer_Cruiser" then
		if Is_Ability_Available(object, "FULL_SALVO") and (target.Get_Hull() > 0.2) and target.Is_Category("Capital") then
			--[[if Are_Hardpoints_Alive(object, "Proj_Ship_Turbolaser_Green_Quad", 2) then]]
				Try_Ability(object, "FULL_SALVO")
			--[[end]]
		end
	elseif object_name == "Procursator"
			or object_name == "Procursator_R"
			or object_name == "Procursator_Warlords"
			or object_name == "Piett_Procursator" then
		if Is_Ability_Available(object, "FULL_SALVO") and (target.Get_Hull() > 0.2) and target.Is_Category("Capital") then
			--[[if Are_Hardpoints_Alive(object, "Proj_Ship_Turbolaser_Green_Quad_Line", 2) then]]
				Try_Ability(object, "FULL_SALVO")
			--[[end]]
		end
	elseif object_name == "Star_Destroyer"
			or object_name == "Star_Destroyer_R"
			or object_name == "Star_Destroyer_Rep"
			or object_name == "Star_Destroyer_Warlords"
			or object_name == "Empire_Fleet_Commander_Admiral"
			or object_name == "Singularity_Star_Destroyer"
			or object_name == "Pirate_Singularity_Star_Destroyer"
			or object_name == "Accuser_Star_Destroyer"
			or object_name == "Admonitor_Star_Destroyer"
			or object_name == "Predominant_Star_Destroyer"
			or object_name == "Blackguard" then
		if Is_Ability_Available(object, "FULL_SALVO") and (target.Get_Hull() > 0.2) and target.Is_Category("Capital") then
			--[[if Are_Hardpoints_Alive(object, "Proj_Ship_Turbolaser_Green_Heavy", 3) then]]
				Try_Ability(object, "FULL_SALVO")
			--[[end]]
		end
	elseif object_name == "Star_Destroyer_II"
			or object_name == "Star_Destroyer_II_R"
			or object_name == "Star_Destroyer_II_Warlords"
			or object_name == "Admiral_Hoytt_Star_Destroyer_II"
			or object_name == "Kalast_Avenger" then
		if Is_Ability_Available(object, "FULL_SALVO") and (target.Get_Hull() > 0.2) and target.Is_Category("Capital") then
			--[[if Are_Hardpoints_Alive(object, "Proj_Ship_Turbolaser_Green_Octuple_NewISD", 4) then]]
				Try_Ability(object, "FULL_SALVO")
			--[[end]]
		end
	elseif object_name == "Venator"
			or object_name == "Venator_IMP"
			or object_name == "Venator_R"
			or object_name == "Venator_U"
			or object_name == "Venator_Rep"
			or object_name == "Venator_Empire"
			or object_name == "Venator_Warlords"
			or object_name == "Venator_Underworld"
			or object_name == "Venator_Underworld_Loadout2"
			or object_name == "Sykes_Venator"
			or object_name == "Aspiration" then
		if Is_Ability_Available(object, "FULL_SALVO") and (target.Get_Hull() > 0.2) and target.Is_Category("Capital") then
			--[[if Are_Hardpoints_Alive(object, "Proj_Ship_Turbolaser_Blue_Dual_Venator", 4) then]]
				Try_Ability(object, "FULL_SALVO")
			--[[end]]
		end
	elseif object_name == "Secutor"
			or object_name == "Secutor_E"
			or object_name == "Secutor_R"
			or object_name == "Secutor_U"
			or object_name == "Secutor_Rep"
			or object_name == "Secutor_Empire" then
		if Is_Ability_Available(object, "FULL_SALVO") and (target.Get_Hull() > 0.2) and target.Is_Category("Capital") then
			--[[if Are_Hardpoints_Alive(object, "Proj_Ship_Turbolaser_Green_Quad_Line", 6) then]]
				Try_Ability(object, "FULL_SALVO")
			--[[end]]
		end
	elseif object_name == "Liberation" then
		if Is_Ability_Available(object, "FULL_SALVO") and (target.Get_Hull() > 0.2) and target.Is_Category("Capital") then
			--[[if Are_Hardpoints_Alive(object, "Proj_Ship_Turbolaser_Green_Heavy", 4) then]]
				Try_Ability(object, "FULL_SALVO")
			--[[end]]
		end
	elseif object_name == "Endurance_Fleet_Carrier" then
		if Is_Ability_Available(object, "FULL_SALVO") and (target.Get_Hull() > 0.2) and target.Is_Category("Capital") then
			--[[if Are_Hardpoints_Alive(object, "Proj_Ship_Turbolaser_Red_Triple", 2) then]]
				Try_Ability(object, "FULL_SALVO")
			--[[end]]
		end
	end
end

--- Function to set the Targeting priorities of an object or taskforce. The Targeting Priority Sets have to
--- exist and can be found under SpaceUnitTargetingPriorities.xml.
---
--- Not setting a tp_set and append will reset the targeting priority to the units default.
---
--- @param object: The taskforce or object to set a targeting priority to
--- @param tp_set: The Targeting Priority set to be used. If none is specified, the default set will be assigned

function Set_Space_Targeting_Priorities(object, tp_set)
	if tp_set == nil then
		if Is_A_Taskforce(object) then
			local tf_units = object.Get_Unit_Table()
			for _,unit in pairs(tf_units) do
				if TestValid(unit) then
					DebugMessage("%s -- Resetting Targeting Set for: %s", tostring(Script), tostring(object))
					Default_Space_Targeting_Priority(object)
				end
			end
		else
			DebugMessage("%s -- Resetting Targeting Set for: %s", tostring(Script), tostring(object))
			Default_Space_Targeting_Priority(object)
		end
	else
		DebugMessage("%s -- Setting Targeting Set to %s for: %s", tostring(Script), tp_set, tostring(object))
		object.Set_Targeting_Priorities(tp_set)
	end
end

function Default_Space_Targeting_Priority(object)
    if object.Is_Category == nil then
        return
    end
	if object.Is_Category("Fighter") then
		if object.Is_Category("AntiFighter") then
			object.Set_Targeting_Priorities("AntiFighter")
		elseif object.Is_Category("AntiFrigate") then
			object.Set_Targeting_Priorities("AntiFrigate")
		else
			object.Set_Targeting_Priorities("Fighter")
		end
	elseif object.Is_Category("Bomber") then
		if object.Is_Category("AntiFrigate") then
			object.Set_Targeting_Priorities("AntiFrigate")
		elseif object.Is_Category("AntiCapital") then
			object.Set_Targeting_Priorities("AntiCapital")
		else
			object.Set_Targeting_Priorities("Bomber")
		end
	elseif object.Is_Category("AntiFighter") then
		object.Set_Targeting_Priorities("AntiFighter")
	elseif object.Is_Category("Corvette") then
		object.Set_Targeting_Priorities("AntiCorvette")
	elseif object.Is_Category("Frigate") then
		object.Set_Targeting_Priorities("AntiFrigate")
	elseif object.Is_Category("Capital") then
		object.Set_Targeting_Priorities("AntiCapital")
	end
end