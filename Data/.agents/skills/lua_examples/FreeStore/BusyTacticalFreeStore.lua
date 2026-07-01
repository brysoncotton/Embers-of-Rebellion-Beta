-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/FreeStore/BusyTacticalFreeStore.lua#12 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/FreeStore/BusyTacticalFreeStore.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: James_Yarrow $
--
--            $Change: 55010 $
--
--          $DateTime: 2006/09/19 19:14:06 $
--
--          $Revision: #12 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgcommands")
require("TRTacticalFreeStore")

---Basic freestore definitions
function Base_Definitions()

    Common_Base_Definitions()

    ServiceRate = 10
    UnitServiceRate = 2

    if Definitions then
        Definitions()
    end

    FREE_STORE_ATTACK_RANGE = 6000.0
	
	aggressive_mode = false
end

---freestore cycle until exit
function main()

    if FreeStoreService then
        while 1 do
            FreeStoreService()
            PumpEvents()
        end
    end

    ScriptExit()
end

---Default behavior when unit added to the freestore
---@param object GameObject
function On_Unit_Added(object)
end

---Freestore cycle service. Checks enemy and friendly locations, and turns on aggressive mode, based on perceptions
function FreeStoreService()
    enemy_location = FindTarget.Reachable_Target(PlayerObject, "Current_Enemy_Location", "Tactical_Location", "Any_Threat", 0.5)
    friendly_location = FindTarget.Reachable_Target(PlayerObject, "Current_Friendly_Location", "Tactical_Location", "Any_Threat", 0.5)

	if Find_Hint("ATTACKER ENTRY POSITION", "main-menu-battle-disable-me") then
		aggressive_mode = true
	else
		if (EvaluatePerception("Allowed_As_Defender_Space_Untargeted", PlayerObject) > 0.0) then
			DebugMessage("%s -- Aggressive mode activated", tostring(Script))
			aggressive_mode = true
		else
			aggressive_mode = false
		end	
	end

	if TestValid(space_station) then
		station_threat = FindDeadlyEnemy(space_station)
		if station_threat then
			space_station.Attack_Target(station_threat)
		end
	else
		space_station = Find_All_Objects_Of_Type("IsStarbase", PlayerObject)
		
		if space_station then
			space_station = space_station[1]
		end
	end
end

---Default behavior on UnitService (controlled by UnitServiceRate)
---@param object GameObject
function On_Unit_Service(object)

    if not TestValid(object) then
        return
    end

    if object.Is_Category("SpaceStructure") or object.Is_Category("Structure") then
        return
    end
	
	-- idle healers should stick with friendlies
	if object.Has_Property("HealsVehicles") then
		if Service_Heal_Friendly(object) then
			DebugMessage("%s -- %s healing friendly", tostring(Script), tostring(object))
			return
		end
	end
	
	current_target = object.Get_Attack_Target()
    
    if TestValid(current_target) then
	
		DebugMessage("%s -- %s already have a target %s", tostring(Script), tostring(object), tostring(current_target))
		
		local in_range = object.Get_Distance(current_target) < object.Get_Type().Get_Max_Range()
		
		-- Don't need to kite away from small stuff
		if object.Is_Good_Against(current_target) then
			DebugMessage("%s -- %s fighting %s we're good against, keep it up", tostring(Script), tostring(object), tostring(current_target))
			if in_range then	
				-- If we have a good target in range, stop moving and attack it, enabling offensive abilities
				object.Attack_Target(current_target)
				Try_Ability(object,"Power_To_Weapons")
				Try_Ability(object, "FULL_SALVO")
			end
			return
		end
			
		-- Current target is something small and we're not good at killing it (and not a fighter out of range), find an alternative target
		if (current_target.Is_Category("Fighter") or current_target.Is_Category("Bomber")) and not object.Is_Category("AntiFighter") then
			DebugMessage("%s -- %s finding alternate target to %s", tostring(Script), tostring(object), tostring(current_target))
			if Service_Attack(object) then 
				return
			end
		end
		
		if object.Get_Shield() < 0.1 then
			if in_range then
				Try_Ability(object,"Power_To_Weapons")
			end
			Try_Ability(object,"Defend")
		end

		if should_kite(object, current_target) then
			if Service_Kite(object) then
				DebugMessage("%s -- %s Kiting", tostring(Script), tostring(object))
				return
			end
			
			if Service_Heal(object, 0.5) then
				DebugMessage("%s -- %s Healing", tostring(Script), tostring(object))
				return
			end
		end
	
    elseif aggressive_mode then
		if TR_On_Unit_Service(object) then
			DebugMessage("%s -- %s attacking preferred target within TR attack range", tostring(Script), tostring(object))
			return
		end
	end

    if not object.Has_Active_Orders() then
	
		DebugMessage("%s -- %s nothing to do, search and destroy", tostring(Script), tostring(object))
		
		--Small units kite, or guard
		if should_kite(object, nil) then
			if Service_Kite(object) then
				DebugMessage("%s -- %s Kiting", tostring(Script), tostring(object))
				return
			end
		elseif Service_Attack(object) then
            return
        end
		
		-- Heal anything if they are idle
		if Service_Heal(object, 0.9) then
			DebugMessage("%s -- %s Healing", tostring(Script), tostring(object))
			return
		end
    end
	
	Service_Guard(object)
	
	if Service_Attack(object) then
		return
	end
	
	return
end

---Makes units engage enemies
---@param object GameObject
---@return boolean
function Service_Attack(object)
	-- keep corvettes guarding
	if object.Is_Category("AntiBomber") then
		return false
	end
	
	-- first deal with best possible target for non-group units
	if not object.Is_Category("Fighter") and not object.Is_Category("Bomber") and not object.Is_Category("Gunship") and not object.Is_Category("SpaceHero") then
		local best_target = FindTarget.Reachable_Target(PlayerObject, "Unit_Needs_To_Be_Destroyed_Freestore", "Enemy_Unit", "Any_Threat", 1.0, object, object.Get_Type().Get_Max_Range())
		
		if TestValid(best_target) then
			DebugMessage("%s -- attacking best target %s", tostring(Script), tostring(best_target))
			object.Attack_Target(best_target)
			return true
		end	
	end
	
	-- then deal with enemies attacking us that we can fight
	local deadly_enemy = FindDeadlyEnemy(object)
	
	if TestValid(deadly_enemy) then
		if object.Is_Good_Against(deadly_enemy) then
			object.Attack_Target(deadly_enemy)
			return true
		end
	end

	-- then deal with nearby enemies in range
	local closest_enemy = Find_Nearest(object, "Corvette|Frigate|Capital|SuperCapital|SpaceHero|SpaceStructure", object.Get_Owner(), false)
	
	if not TestValid(closest_enemy) then
		return false
	else
		DebugMessage("%s -- closest enemy is %s units away", tostring(Script), tostring(object.Get_Distance(closest_enemy)))
	end
	
	if object.Get_Distance(closest_enemy) < FREE_STORE_ATTACK_RANGE then
		object.Attack_Target(closest_enemy)
		return true
	elseif aggressive_mode then
		DebugMessage("%s -- %s aggressive mode, attacking %s", tostring(Script), tostring(object), tostring(closest_enemy))
		object.Attack_Target(closest_enemy)
		return true
	end

    return false
end

---Controls freestore guard behavior
---@param object GameObject
---@return boolean
function Service_Guard(object)

	-- make sure larger ships don't waddle around trying to guard things
	if object.Is_Category("Frigate") or object.Is_Category("Capital") or object.Is_Category("SuperCapital") or object.Is_Category("SpaceHero") then
		return false
	end
	
	DebugMessage("%s -- %s trying to guard", tostring(Script), tostring(object))
	
	if object.Is_Category("Fighter") or object.Is_Category("Bomber") or object.Is_Category("Gunship") then
		local friendly = Find_Nearest(object, "Corvette|Frigate|Capital|SuperCapital|SpaceHero|SpaceStructure", PlayerObject, true)
		
		if TestValid(friendly) then
			object.Attack_Move(friendly.Get_Position())
			object.Guard_Target(friendly)
			return true
		end
	end
	
	if TestValid(friendly_location) then
		object.Attack_Move(friendly_location)
		return true
	elseif TestValid(space_station) then
		object.Attack_Move(space_station.Get_Position())
		return true
	end
	
	DebugMessage("%s -- %s no valid guard target", tostring(Script), tostring(object))
    return false
end

---Controls freestore kiting behavior
---@param object GameObject
---@return boolean
function Service_Kite(object)

    local deadly_enemy = FindDeadlyEnemy(object)

    if TestValid(deadly_enemy) then
		
		Try_Ability(object, "SPOILER_LOCK")
		Try_Ability(object, "STEALTH")

		kite_pos = Project_By_Unit_Range(deadly_enemy, object)
		
		DebugMessage("%s -- %s Kiting away from %s", tostring(Script), tostring(object), tostring(deadly_enemy))
		object.Move_To(kite_pos)

		return true
    end

    return false
end

---Sends a unit to heal if it is below a given health fraction
---@param object GameObject
---@param health_threshold number
---@return boolean
function Service_Heal(object, health_threshold)

    if object.Get_Hull() > health_threshold then
        return false
    end

    -- Try to find the nearest healing structure appropriate for this unit
    local fs_healer_property_flag = "HealsVehicles"
    healer = Find_Nearest(object, fs_healer_property_flag, PlayerObject, true)

    if not TestValid(healer) then
        return false
    end
	
	DebugMessage("%s -- %s moving to healer", tostring(Script), tostring(object), tostring(deadly_enemy))
    object.Move_To(healer, 10)
    
    return true
end

function Service_Heal_Friendly(object)
    local heal_target = FindTarget.Reachable_Target(PlayerObject, "Unit_Needs_Repair", "Friendly_Unit", "Any_Threat", 1.0)

    if not TestValid(heal_target) then
        return false
    end
	
	DebugMessage("%s -- %s moving to escort target %s", tostring(Script), tostring(object), tostring(heal_target))
    object.Move_To(heal_target, 10)
    
    return true
end

function should_kite(object, target)
	if TestValid(target) then
		if target.Is_Category("SpaceStructure") then
			return true
		end
	else
		return object.Has_Property("DoKite") or object.Is_Category("Fighter") or object.Is_Category("Bomber") or object.Is_Category("Corvette") or object.Is_Category("Transport")
	end
end
