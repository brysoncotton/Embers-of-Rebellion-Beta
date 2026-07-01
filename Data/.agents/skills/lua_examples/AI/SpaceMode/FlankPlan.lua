-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/FlankPlan.lua#3 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/FlankPlan.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 45952 $
--
--          $DateTime: 2006/06/09 16:00:52 $
--
--          $Revision: #3 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	
	AllowEngagedUnits = false
	MinContrastScale = 0.75
	MaxContrastScale = 3.0
	Category = "AlwaysOff"
	TaskForce = {
	{
		"MainForce"
		,"Frigate | Capital | SuperCapital | SpaceHero = 100%"
	},
	{
		"FlankForce"
		,"Fighter | Bomber = 2,8"
	}
	}
	
	ExecuteFlank = true
	flank_block = nil
	flank_dist = 4000.0
	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function MainForce_Thread()
	DebugMessage("%s -- In MainForce_Thread.", tostring(Script))
	ExecuteFlank = false

	BlockOnCommand(MainForce.Produce_Force());
	
	unit_table = MainForce.Get_Unit_Table()
	
	for i,unit in pairs(unit_table) do
		if unit.Has_Property("Carrier") then
			MainForce.Release_Unit(unit)
		end
	end
	
	QuickReinforce(PlayerObject, AITarget, MainForce, FlankForce)
	
	DebugMessage("MainForce constructed at stage area!")
	MainForce.Enable_Attack_Positioning(true)

	SetClassPriorities(MainForce, "Attack_Move")
	BlockOnCommand(MainForce.Attack_Move(AITarget, MainForce.Get_Self_Threat_Max()))	
	DebugMessage("%s -- MainForce Done!  Exiting Script!", tostring(Script))
	ScriptExit()
end

function FlankForce_Thread()
	BlockOnCommand(FlankForce.Produce_Force())

	QuickReinforce(PlayerObject, AITarget, FlankForce, MainForce)	

	-- Parameters = target, direction ("left", "right", "front", "back"), minimum distance from target, threat tolerance
	flank_block = FlankForce.Prepare_Ambush(AITarget, "left", flank_dist, 500.0)
	if not flank_block then 
		DebugMessage("Unable to reach LEFT flank, trying right.")
		flank_block = FlankForce.Prepare_Ambush(AITarget, "right", flank_dist, 500.0)
	end

	if not flank_block then 
		DebugMessage("Unable to reach RIGHT flank, trying back.")
		flank_block = FlankForce.Prepare_Ambush(AITarget, "back", flank_dist, 500.0)
	end
	
	if not flank_block then 
		DebugMessage("Unable to reach a flank.  Abandonning plan.")
		ScriptExit()
	end
	
	-- Try to stay in position to perform the flank
	while not ExecuteFlank do
		if flank_block.IsFinished() then
			if TestValid(AITarget) and FlankForce.Get_Distance(AITarget) < flank_dist then
					DebugMessage("%s -- Attempting to stay out of range and safe.", tostring(Script))
					FlankForce.Move_To(Project_By_Unit_Range(AITarget.Get_Game_Object(), FlankForce), FlankForce.Get_Self_Threat_Max())
			end
		end
		Sleep(5)
	end
	
	BlockOnCommand(FlankForce.Attack_Target(AITarget))
	FlankForce.Enable_Attack_Positioning(false)
	
	ScriptExit()
end
	

function MainForce_No_Units_Remaining()
	DebugMessage("%s -- All units dead or non-buildable.  Abandonning plan.", tostring(Script))
	ScriptExit()
end

function MainForce_Original_Target_Destroyed()
	DebugMessage("%s -- Target destroyed!  Exiting Script.", tostring(Script))
	ScriptExit()
end

function MainForce_Target_In_Range()
	ExecuteFlank = true
	MainForce.Enable_Attack_Positioning(true)
end

function FlankForce_Target_In_Range()
	FlankForce.Enable_Attack_Positioning(true)
end

function FlankForce_Original_Target_Destroyed()
	ScriptExit()	
end
