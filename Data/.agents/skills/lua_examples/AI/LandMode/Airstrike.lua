-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/Airstrike.lua#3 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/Airstrike.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 54633 $
--
--          $DateTime: 2006/09/14 17:46:53 $
--
--          $Revision: #3 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

--
-- Space Mode Test Script
--

ScriptPoolCount = 3

function Definitions()
	
	Category = "Airstrike"
	TaskForce = {
	{
		"MainForce"
		,"DenyHeroAttach"		
		,"AirGunship | AirSpeeder = 1, 5"
		,"-Gallofree_HTT_Transport"
	}
	}
	
	AllowEngagedUnits = false

	start_loc = nil
	
	flank_dist = 1000.0
	
end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())
	
	-- See if any units have landed
	if MainForce.Get_Force_Count() ~= 0 then
	
		-- Land the remainder nearby.
		WaitForAllReinforcements(MainForce, MainForce)
	else
	
		-- Land near the default starting point.
		start_loc = FindTarget(MainForce, "Is_Friendly_Start", "Tactical_Location", 1.0)
		if start_loc then
			WaitForAllReinforcements(MainForce, start_loc)
		else
			WaitForAllReinforcements(MainForce, AITarget)
		end
	end
	
	MainForce.Set_As_Goal_System_Removable(false)

	MainForce.Set_Targeting_Priorities("AirGunship_Attack_Move", "AirGunship")

	MainForce.Set_Targeting_Priorities("AirSpeeder_Attack_Move", "AirSpeeder")

	BlockOnCommand(MainForce.Attack_Move(AITarget, MainForce.Get_Self_Threat_Max()))

	ScriptExit()
end