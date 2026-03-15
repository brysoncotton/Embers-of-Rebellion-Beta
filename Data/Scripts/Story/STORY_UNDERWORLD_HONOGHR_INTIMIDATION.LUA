-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Honoghr_Intimidation.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Honoghr_Intimidation.lua $
--
--    Original Author: Jeff Stewart
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
		Honoghr_Intimidation_Mission_Begin = State_Honoghr_Intimidation_Mission_Begin,
		Honoghr_Intimidation_Mission_Speech_Line_00_Remove_Text = State_Honoghr_Intimidation_Mission_Speech_Line_00_Remove_Text
	}
	
	underworld = Find_Player("Underworld")
	rebel = Find_Player("Rebel")
	empire = Find_Player("Empire")
	hutts = Find_Player("Hutts")
	
	camera_offset = 135
	
	mission_started = false
	victory_triggered = false
end

function State_Honoghr_Intimidation_Mission_Begin(message)
	if message == OnEnter then
		mission_started = true
		
		-- make only minor tweaks to the script below... --
		
		--current_cinematic_thread = Create_Thread("Intro_Cinematic")
		Lock_Controls(0)
		urai = Find_First_Object("URAI_FEN")
		Point_Camera_At(urai)
	Story_Event("TEXT_SPEECH_UW_CLD_01")
	Story_Event("ADD_OBJECTIVE_00")
		--Story_Event("TEXT_SPEECH_UW_CLD_01")
		
		objective_list = Find_All_Objects_With_Hint("objective")
		for k, unit in pairs(objective_list) do
			if TestValid(unit) then
				unit.Highlight(true)
			end
		end			
		-- 9/19/06 JAC - We need this even if we're not doing a cinematic intro
		-- otherwise the Master Volume will be stuck at 0
		Start_Cinematic_Camera()
		End_Cinematic_Camera()
		Fade_Screen_In(1)
		Letter_Box_Out(0)
		Create_Thread("Main")	
	end
end

function Story_Mode_Service()
	if mission_started then
		urai = Find_First_Object("URAI_FEN")
				
		if not TestValid(urai) then
			Story_Event("FAIL_OBJECTIVE_00")
			
			rebel_list = Find_All_Objects_Of_Type(rebel)
			empire_list = Find_All_Objects_Of_Type(empire)
			hutt_list = Find_All_Objects_Of_Type(hutts)
			
			if TestValid(rebel_list[1]) then
				Story_Event("VICTORY_REBEL")
			end
			
			if TestValid(empire_list[1]) then
				Story_Event("VICTORY_EMPIRE")
			end
			
			if TestValid(hutt_list[1]) then
				Story_Event("VICTORY_HUTTS")
			end
		end
	end
		
	if mission_started and not victory_triggered then
		-- define mission objective here --	

		
		-- end this bit will change per the mission objective --
		
	end
end

function Main()
	while true do
		objective_list = Find_All_Objects_With_Hint("objective")
		noghri_houses=0
		--noghri_houses = table.getn(objective_list)
		for k, unit in pairs(objective_list) do
			if TestValid(unit) then
				if unit.Get_Hull() > 0 then 
				  noghri_houses=noghri_houses+1
				end
			end
		end				
		
		
		-- begin this bit will change per the mission objective --
		if noghri_houses < 4 then
			Story_Event("UPDATE_OBJECTIVE_00_3")
			Story_Event("COMPLETE_OBJECTIVE_00")
			victory_triggered = true
		elseif noghri_houses < 5 then
			Story_Event("UPDATE_OBJECTIVE_00_2")
		elseif noghri_houses < 6 then
			Story_Event("UPDATE_OBJECTIVE_00_1")
		elseif noghri_houses < 7 then
			Story_Event("UPDATE_OBJECTIVE_00_0")
		end
		Sleep(1)
	end
end


-- make only minor tweaks to the script below... --

function State_Honoghr_Intimidation_Mission_Speech_Line_00_Remove_Text(message)
	if message == OnEnter then
				
		--Story_Event("ADD_OBJECTIVE_00")
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
	
	Suspend_AI(0)
	Story_Event("TEXT_SPEECH_UW_CLD_01")
end



-- ************************************************************************
-- ***********************INTRO CINEMATIC FUNCTION*************************
-- ************************************************************************

function Intro_Cinematic ()	
	Suspend_AI(1)
	
	-- define mission hero here --
	urai = Find_First_Object("URAI_FEN")
	Point_Camera_At(urai)
	
	Lock_Controls(1)
	Start_Cinematic_Camera()
	Letter_Box_In(0)	
	Fade_Screen_In(2)
	
	Transition_Cinematic_Camera_Key(urai, 0, 50, 25, 45, 1, 1, 1, 0)
	Transition_Cinematic_Target_Key(urai, 0, 0, 0, 7, 0, urai, 0, 0)
	--Sleep(7)
	
	Transition_Cinematic_Camera_Key(urai, 5, 50, 25, 135, 1, 1, 1, 0)
	
	Sleep(4.5)
	
	while camera_offset > 0 do
		camera_offset = camera_offset + 90
		Transition_Cinematic_Camera_Key(urai, 5, 50, 25, camera_offset, 1, 1, 1, 0)
		
		if camera_offset == 315 then
			camera_offset = -45
		end
		
		Sleep(4.5)
	end
	
	current_cinematic_thread = nil
	Create_Thread("End_Camera")
end