-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Anaxes_Intimidation.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Anaxes_Intimidation.lua $
--
--    Original Author: Dan Etter
--
--            $Author: Brian_Hayes $
--
--            $Change: 637819 $
--
--          $DateTime: 2017/03/22 10:16:16 $
--
--          $Revision: #1 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGStateMachine")
require("PGStoryMode")

--
-- Definitions -- This function is called once when the script is first created.
-- 
function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))
	
	StoryModeEvents = 
	{
		Anaxes_Intimidation_Mission_Begin = State_Anaxes_Intimidation_Mission_Begin,
		Anaxes_Intimidation_Mission_Speech_Line_02_Remove_Text = State_Anaxes_Intimidation_Mission_Speech_Line_02_Remove_Text
	}
		
	underworld = Find_Player("Underworld")
	rebel = Find_Player("Rebel")
	empire = Find_Player("Empire")
	hutts = Find_Player("Hutts")
	
	rebel_defender = false
	empire_defender = false
	
	phase_0_triggered = false
	mission_started = false
	victory_triggered = false
end

function State_Anaxes_Intimidation_Mission_Begin(message)
	if message == OnEnter then
		mission_started = true
		
		rebel_list = Find_All_Objects_Of_Type(rebel)
		empire_list = Find_All_Objects_Of_Type(empire)
		hutt_list = Find_All_Objects_Of_Type(hutts)
		
		hero = Find_First_Object("BOSSK")
		
		if TestValid(rebel_list[1]) then
			rebel_defender = true
		end		
		if TestValid(empire_list[1]) then
			empire_defender = true
		end
		
--		phase_0_guard = Find_Hint("STORY_TRIGGER_ZONE_00","phase0guard")
--		phase_1_guard = Find_Hint("STORY_TRIGGER_ZONE_00","phase1guard")
--		phase_2_guard = Find_Hint("STORY_TRIGGER_ZONE_00","phase2guard")
		
--		phase_0_list = Find_All_Objects_With_Hint("phase0")
--		phase_1_list = Find_All_Objects_With_Hint("phase0")
--		phase_2_list = Find_All_Objects_With_Hint("phase0")
		objective_list = Find_All_Objects_With_Hint("objective")
		objective = objective_list[1]
		
--		for k, unit in pairs(phase_0_list) do
--			if TestValid(unit) then
--				unit.Guard_Target(phase_0_guard)
--			end
--		end
--		for k, unit in pairs(phase_1_list) do
--			if TestValid(unit) then
--				unit.Guard_Target(phase_1_guard)
--			end
--		end
--		for k, unit in pairs(phase_2_list) do
--			if TestValid(unit) then
--				unit.Guard_Target(phase_2_guard)
--			end
--		end
		
		
		
		Point_Camera_At(hero)
		Start_Cinematic_Camera()
		End_Cinematic_Camera()
		Letter_Box_Out(0)
		
		--current_cinematic_thread = Create_Thread("Intro_Cinematic", hero)
		Fade_Screen_In(1)
		Lock_Controls(0)
		
		Story_Event("ADD_OBJECTIVE_01")
		Story_Event("TEXT_SPEECH_ANAXES_INT_TACTICAL_COR04_02")
		
		mdu_list = Find_All_Objects_With_Hint("mdu")
		for k, unit in pairs(mdu_list) do
			if TestValid(unit) then
				unit.Prevent_AI_Usage(true)
				unit.Activate_Ability("DEPLOY", true)
			end
		end
		
		if rebel_defender then
			mptl = Find_First_Object("MPTL")
			mptl.Prevent_AI_Usage(true)
			mptl.Activate_Ability("DEPLOY", true)
			for k, unit in pairs(rebel_list) do
				if TestValid(unit) then
					unit.Prevent_AI_Usage(true)
					unit.Guard_Target(unit.Get_Position())
				end
			end
			
			Sleep(2)
			for k, unit in pairs(mdu_list) do
				if TestValid(unit) then
					unit.Build("UC_Rebel_Mobile_Shield_Generator")
				end
			end			
		end
		if empire_defender then
			spmat = Find_First_Object("SPMAT_WALKER")
			spmat.Prevent_AI_Usage(true)
			spmat.Activate_Ability("DEPLOY", true)
			for k, unit in pairs(empire_list) do
				if TestValid(unit) then
					unit.Prevent_AI_Usage(true)
					unit.Guard_Target(unit.Get_Position())
				end
			end
			
			Sleep(2)
			for k, unit in pairs(mdu_list) do
				if TestValid(unit) then
					unit.Build("UC_Empire_EM_Field_Generator")
				end
			end	
		end
	end
end

function Story_Mode_Service()
	if mission_started then						
		if not TestValid(hero) then
			Story_Event("FAIL_OBJECTIVE_00")
			
			if empire_defender then
				Story_Event("VICTORY_EMPIRE")
			end
			if rebel_defender then
				Story_Event("VICTORY_REBEL")
			end
		end
	end
	
	if mission_started and not victory_triggered then
		if not TestValid(objective) then
			victory_triggered = true
			
			Story_Event("COMPLETE_OBJECTIVE_00")
		end
	end
end

function State_Anaxes_Intimidation_Mission_Speech_Line_02_Remove_Text(message)
	if message == OnEnter then				
		Story_Event("ADD_OBJECTIVE_00")
	end
end

-- ************************************************************************
-- ***********************INTRO CINEMATIC FUNCTION*************************
-- ************************************************************************

function Intro_Cinematic(focus_unit)	
	
	Lock_Controls(1)
	Start_Cinematic_Camera()
	Letter_Box_In(0)	
	Fade_Screen_In(2)
	
	camera_distance = 50
	camera_rotation = 45
	camera_end = (camera_rotation + 180)
	
	Transition_Cinematic_Camera_Key(focus_unit, 0, camera_distance, 25, (camera_rotation - 90), 1, 1, 1, 0)
	Transition_Cinematic_Target_Key(focus_unit, 0, 0, 0, 7, 0, focus_unit, 0, 0)
	
	Transition_Cinematic_Camera_Key(focus_unit, 5, camera_distance, 25, camera_rotation, 1, 1, 1, 0)
	
	Sleep(4.5)
	
	while true do
		camera_rotation = camera_rotation + 90
		Transition_Cinematic_Camera_Key(focus_unit, 5, camera_distance, 25, camera_rotation, 1, 1, 1, 0)
		
		if camera_rotation == camera_end then
			End_Camera()
		end
		
		Sleep(4.5)
	end
end

function Story_Handle_Esc()
	if current_cinematic_thread ~= nil then
		Thread.Kill(current_cinematic_thread)
		current_cinematic_thread = nil
		Create_Thread("End_Camera")
	end
end

function End_Camera()
	Transition_To_Tactical_Camera(6)
	Sleep(4)
	Letter_Box_Out(2)
	Sleep(2)
	Lock_Controls(0)
	End_Cinematic_Camera()
end