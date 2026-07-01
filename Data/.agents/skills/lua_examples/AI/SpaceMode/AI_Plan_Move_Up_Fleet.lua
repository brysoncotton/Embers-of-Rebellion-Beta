-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/BurnUnits.lua#6 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/BurnUnits.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: James_Yarrow $
--
--            $Change: 56734 $
--
--          $DateTime: 2006/10/24 14:15:48 $
--
--          $Revision: #6 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

function Definitions()
	
	AllowEngagedUnits = true
	IgnoreTarget = true
	Category = "Move_Up_Fleet"
	TaskForce = {
	{
		"MainForce"
		,"TaskForceRequired"
		,"DenySpecialWeaponAttach"
	}
	}

end

function MainForce_Thread()
	if Is_Multiplayer_Mode() == true or (EvaluatePerception("Is_Skirmish_Mode", PlayerObject) == 1) or Attacking then
		ScriptExit()
	end
	
	move_target = FindTarget(MainForce, "Current_Enemy_Location_Space", "Tactical_Location", 1.0)
	if not TestValid(move_target) then
		ScriptExit()
	end
	
	-- Cancel all goals
	Purge_Goals(PlayerObject)
	
	Sleep(1)	
	-- Use all idle units, mapwide
	DebugMessage("%s-- collecting all free units and moving to target:%s", tostring(Script), tostring(move_target))
	MainForce.Collect_All_Free_Units()
	
	unit_table = MainForce.Get_Unit_Table()
	
	for i,unit in pairs(unit_table) do
		if not unit.Are_Engines_Online() then
			MainForce.Release_Unit(unit)
		end
	end
	
	SetClassPriorities(MainForce, "Attack_Move")
	BlockOnCommand(MainForce.Attack_Move(move_target, MainForce.Get_Self_Threat_Max()), -1, Engaged_Enemy)
	
	MainForce.Set_Plan_Result(true)

	ScriptExit()
end

function MainForce_Unit_Damaged(tf, unit, attacker, deliberate)
	Attacking = true
	
	Default_Unit_Damaged(tf, unit, attacker, deliberate)
end

function Engaged_Enemy()
	return Attacking or TestValid(FindDeadlyEnemy(MainForce))
end
