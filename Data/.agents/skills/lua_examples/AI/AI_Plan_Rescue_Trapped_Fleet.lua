-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/ContrastToReconnect.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/ContrastToReconnect.lua $
--
--    Original Author: Steve_Copeland
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

ScriptPoolCount = 1

require("pgevents")

--
-- Galactic Mode Contrast To Reconnect Islands of Nodes Script
--

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))	
	Category = "Rescue_Trapped_Fleet"
	TaskForce = {
	{
		"MainForce"						
		,"TaskForceRequired"
		,"DenyHeroAttach"
	},
	}
	
	trapped_units = {}
	reconnect_location = nil
	trapped_fleet = nil
	home = nil
	path_home = {}
	
	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function MainForce_Thread()
	DebugMessage("%s -- In MainForce_Thread for target %s, AItarget %s.", tostring(Script), tostring(Target), tostring(AITarget))

	trapped_units = get_friendly_units_on_planet(PlayerObject, Target)
	DebugPrintTable(trapped_units)
	
	trapped_fleet = Assemble_Fleet(trapped_units)
	
	if trapped_fleet == nil then
		DebugMessage("%s -- No units at target? Exiting plan.", tostring(Script))
		MainForce.Set_Plan_Result(false)
		ScriptExit()
	end
		
	
	DebugMessage("%s -- Fleet assembled %s", tostring(Script), tostring(trapped_fleet))
	
	reconnect_location = FindTarget.Reachable_Target(PlayerObject, "Is_Connected_To_Me", "Enemy", "Enemy_destination", 1.0, Target)
	
	DebugMessage("%s -- Reconnect location is %s", tostring(Script), tostring(reconnect_location))
	
	if reconnect_location ~= nil then
		trapped_fleet.Move_To(reconnect_location)
	else
		DebugMessage("%s -- Can't find reconnect location for trapped fleet, moving to enemy planet along path home", tostring(Script))
		home = FindTarget(MainForce, "One", "Friendly", 1.0)
		path_home = Find_Path(PlayerObject, AITarget.Get_Game_Object(), home)
		DebugMessage("%s -- Home is %s, first step is %s", tostring(Script), tostring(home), tostring(path_home[2]))
		trapped_fleet.Move_To(path_home[2])
	end
	
	MainForce.Set_Plan_Result(true)
	
	DebugMessage("%s -- MainForce Done!  Exiting Script!", tostring(Script))
	ScriptExit()
end

function MainForce_Production_Failed(tf, failed_object_type)
	DebugMessage("%s -- Abandonning plan owing to production failure.", tostring(Script))
	ScriptExit()
end

--This same function is duplicated in ChangeOwnerUtilities (to simplify dependencies?)
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