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

    FREE_STORE_ATTACK_RANGE = 10000.0
	
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

	aggressive_mode = true
end

---Default behavior on UnitService (controlled by UnitServiceRate)
---@param object GameObject
function On_Unit_Service(object)

    if not TestValid(object) then
        return
    end

    if object.Is_Category("SpaceStructure") or object.Is_Category("Transport") or object.Is_Category("Structure") then
        return
    end
	
	-- idle healers should stick with friendlies
	if object.Has_Property("HealsVehicles") then
		Service_Guard(object)
		return
	end
	
	current_target = object.Get_Attack_Target()

	if aggressive_mode and not TestValid(current_target) then
		if TR_On_Unit_Service(object) then
			DebugMessage("%s -- %s attacking target within TR attack range", tostring(Script), tostring(object))
			return
		end
	end
    
    if TestValid(current_target) then
	
		DebugMessage("%s -- %s already have a target %s, kiting or healing", tostring(Script), tostring(object), tostring(current_target))
		
		-- Don't need to kite away from small stuff
		if object.Is_Good_Against(current_target) then
			DebugMessage("%s -- %s fighting %s we're good against, keep it up", tostring(Script), tostring(object), tostring(current_target))
			if object.Get_Distance(current_target) < object.Get_Type().Get_Max_Range() then
				Try_Ability(unit,"Power_To_Weapons")
			end
			return
		end
		
		if object.Get_Shield() < 0.1 then
			Try_Ability(unit,"Power_To_Weapons")
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
		
		return
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

		if Service_Attack(object) then
            return
        end

        Service_Guard(object)
		
		return
    end
end

---Gets units in range of enemies or attack immediately if in range
---@param object GameObject
---@param enemy_object GameObject unit to attack
function get_in_range(object, enemy_object)
	
	if object.Get_Distance(enemy_object) < object.Get_Type().Get_Max_Range() then
		object.Attack_Target(enemy_object)
	else
		object.Attack_Move(Project_By_Unit_Range(object, enemy_object.Get_Position()))
	end
	
	return true	
end

---Makes units engage enemies
---@param object GameObject
---@return boolean
function Service_Attack(object)

	local closest_enemy = Find_Nearest(object, "Corvette|Frigate|Capital|SuperCapital|SpaceHero|SpaceStructure", object.Get_Owner(), false)
	
	if not TestValid(closest_enemy) or not TestValid(enemy_location) then
		return false
	else
		DebugMessage("%s -- closest enemy is %s units away", tostring(Script), tostring(object.Get_Distance(closest_enemy)))
	end
	
	if get_in_range(object, closest_enemy) then
		return true
	end
	
	local deadly_enemy = FindDeadlyEnemy(object)
	
	if TestValid(deadly_enemy) then
		DebugMessage("%s -- attacking enemy attacker", tostring(Script))
		if get_in_range(object, deadly_enemy) then
			return true
		end
	end	

    return false
end

---Controls freestore guard behavior
---@param object GameObject
---@return boolean
function Service_Guard(object)

	-- make sure larger ships don't waddle around trying to guard things
	if object.Is_Category("Frigate") or object.Is_Category("Capital") or object.Is_Category("SuperCapital") or object.Is_Category("AntiCapital") then
		return false
	end
	
	DebugMessage("%s -- %s going to guard", tostring(Script), tostring(object))

    local closest_friendly_structure = Find_Nearest(object, "SpaceStructure", object.Get_Owner(), true)
	
	if object.Has_Property("Carrier") then
		if TestValid(friendly_location) then
			object.Attack_Move(friendly_location)
			return true	
		elseif TestValid(closest_friendly_structure) then
			object.Attack_Move(closest_friendly_structure.Get_Position())
			return true
		elseif aggressive_mode and TestValid(enemy_location) then
			object.Move_To(Project_By_Unit_Range(object, enemy_location))
			return true
		end		
	end
	
	if TestValid(friendly_location) then
		object.Attack_Move(friendly_location)
		return true
	elseif aggressive_mode and TestValid(enemy_location) then
		object.Move_To(Project_By_Unit_Range(object, enemy_location))
		return true
	elseif TestValid(closest_friendly_structure) then
		object.Attack_Move(closest_friendly_structure.Get_Position())
		return true
	end

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

function should_kite(object, target)
	if TestValid(target) then
		if target.Is_Category("SpaceStructure") then
			return true
		end
	else
		return object.Has_Property("DoKite") or object.Is_Category("Fighter") or object.Is_Category("Bomber") or object.Is_Category("Corvette") or object.Is_Category("Transport")
	end
end
