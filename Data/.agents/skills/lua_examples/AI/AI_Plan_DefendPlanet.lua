-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/ConquerPiratePlan.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/ConquerPiratePlan.lua $
--
--    Original Author: James Yarrow
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

require("pgevents")

-- Tell the script pooling system to pre-cache this number of scripts.
ScriptPoolCount = 16

function Definitions()	
	Category = "Defend_Planet | CIS_Federation_Defend_Planet"
	TaskForce = {
	{
		"ReserveForce"
		,"DenyHeroAttach"
		,"MinimumTotalForce = 5000"
		,"Corvette|Frigate|Capital = 100%"
	}
	}
end

function ReserveForce_Thread()

	ReserveForce.Set_As_Goal_System_Removable(false)
	BlockOnCommand(ReserveForce.Produce_Force(Target));
	
	unit_table = ReserveForce.Get_Unit_Table()
	
	for i,unit in pairs(unit_table) do
		if unit.Is_Category("SpaceHero") then
			ReserveForce.Release_Unit(unit)
		end
	end
	
	ReserveForce.Set_Plan_Result(true)

	Sleep(20)
	
	local i = 1
	while (EvaluatePerception("Keep_Defensive_Fleet", PlayerObject, Target) == 0.0) and (EvaluatePerception("Is_Connected_To_Enemy", PlayerObject, Target) > 0.0) and i < 120 do
		Sleep(1)
		i = i + 1
	end
	
	ScriptExit()
end

function ReserveForce_Production_Failed(failed_object_type)
	ScriptExit()
end