-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/AI_Plan_ExpansionGeneric_GarrisonTarget.lua#3 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/AI_Plan_ExpansionGeneric_GarrisonTarget.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 52811 $
--
--          $DateTime: 2006/08/28 18:52:56 $
--
--          $Revision: #3 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

function Definitions()

	Category = "Garrison_Bunker | Garrison_Transport"
	IgnoreTarget = true
	TaskForce = 
	{
		{
			"MainForce"
			,"Infantry = 1,5"
			,"-Vornskr"
		}
	}

	AllowEngagedUnits = false

end

function MainForce_Thread()

	BlockOnCommand(MainForce.Produce_Force())
	QuickReinforce(PlayerObject, AITarget, MainForce, nil)
	
	if not MainForce.Can_Garrison(AITarget) then
		ScriptExit()
	end
	
	MainForce.Activate_Ability("SPREAD_OUT", false)	
	
	Set_Land_AI_Targeting_Priorities(MainForce)
	BlockOnCommand(MainForce.Attack_Move(Target.Get_Position()))
		
	Sleep(5)

	ScriptExit()
	
end

-- Override default handling, which will kill the plan
function MainForce_Original_Target_Owner_Changed(tf, old_player, new_player)

	--If someone else captures the bunker then I need to assault it with anti-structure
	--units rather than capture it with infantry
	if new_player ~= PlayerObject and new_player.Is_Neutral() == false then
		ScriptExit()
	end

end

function MainForce_Unit_Move_Finished(tf, unit)

	MainForce.Set_Plan_Result(true)
	Create_Thread("Finalize_Garrison", unit)
	
end

function Finalize_Garrison(unit)

	unit.Guard_Target(Target)
	while TestValid(Target) and (not Target.Has_Garrison()) and (Target.Get_Owner() ~= PlayerObject) do
		Sleep(2)
		unit.Guard_Target(Target)
	end	

	if TestValid(Target) and unit.Can_Garrison(Target) then
		unit.Garrison(Target)
	end
	
	MainForce.Release_Unit(unit)

end
