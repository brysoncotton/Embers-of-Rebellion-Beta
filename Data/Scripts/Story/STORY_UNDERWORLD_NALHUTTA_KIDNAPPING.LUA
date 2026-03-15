-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_NalHutta_Kidnapping.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_NalHutta_Kidnapping.lua $
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
		NalHutta_Kidnapping_Mission_Begin = State_NalHutta_Kidnapping_Mission_Begin,
		NalHutta_Kidnapping_Mission_Speech_Line_00_Remove_Text = State_NalHutta_Kidnapping_Mission_Speech_Line_00_Remove_Text
	}
	
	underworld = Find_Player("Underworld")
	rebel = Find_Player("Rebel")
	empire = Find_Player("Empire")
	hutts = Find_Player("Hutts")
	
	camera_offset = 135
	
	mission_started = false
	got_target = false
	victory_triggered = false
end

function State_NalHutta_Kidnapping_Mission_Begin(message)
	if message == OnEnter then
		mission_started = true
		-- make only minor tweaks to the script below... --
		
		--current_cinematic_thread = Create_Thread("Intro_Cinematic")
		Lock_Controls(0)
		urai = Find_First_Object("URAI_FEN")
		Point_Camera_At(urai)
	Story_Event("TEXT_SPEECH_UW_CLD_01")
	Story_Event("ADD_OBJECTIVE_00")
	Story_Event("ADD_OBJECTIVE_02")
		--Story_Event("TEXT_SPEECH_UW_CLD_01")
		home = Find_Hint("STORY_TRIGGER_ZONE", "home")
		
		--MessageBox("begin")
		target_list = Find_All_Objects_With_Hint("target")
		target = target_list[1]
		Register_Prox(target, Prox_TargetSurround, 75, underworld)
		target.Highlight(true)
		target.Prevent_AI_Usage(true)
		target.Guard_Target(home)
		target.Change_Owner(Find_Player("neutral"))
		--MessageBox("end")
		-- 9/19/06 JAC - We need this even if we're not doing a cinematic intro
		-- otherwise the Master Volume will be stuck at 0
		Start_Cinematic_Camera()
		End_Cinematic_Camera()
		Fade_Screen_In(1)
		Letter_Box_Out(0)
	end
end

function Prox_TargetSurround(self_obj, trigger_obj)
	if trigger_obj.Get_Owner() == underworld then
		Story_Event("COMPLETE_OBJECTIVE_00")
		if TestValid(target) then
			target.Highlight(false)
			got_target = true
		end
		self_obj.Cancel_Event_Object_In_Range(Prox_TargetSurround)
	end
end

function End_Sequence()
	Suspend_AI(1)
	Lock_Controls(0)

	-- Create_Cinematic_Transport(object_type_name, player_id, transport_pos, zangle, phase_mode, anim_delta, idle_time, persist,hint)
	landing = Find_Hint("STORY_TRIGGER_ZONE", "landing")
	transport = Create_Cinematic_Transport("Underworld_Hero_Shuttle_Landing", underworld.Get_ID(), landing, -135, 1, .25, 5, 0)
	player_list = Find_All_Objects_Of_Type(underworld)
	for i,unit in pairs(player_list) do
		if TestValid(unit) then
			unit.Move_To(landing)
		end
	end

end

function Story_Mode_Service()
	if mission_started then
		urai = Find_First_Object("URAI_FEN")
				
		if not TestValid(urai) then
			--MessageBox("Hero Killed")
			Story_Event("FAIL_OBJECTIVE_01")
			
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
		
		--target_list = Find_All_Objects_With_Hint("target")
		--target = target_list[1]
		
		if not TestValid(target) then
			--MessageBox("Target Killed")
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
				Story_Event("VICTORY_EMPIRE")
			end
		end
		
		
	end
		
	if mission_started and not victory_triggered then
		-- define mission objective here --	

		objective_list1 = Find_All_Objects_With_Hint("objective1")
		base_shields1 = table.getn(objective_list1)
		objective_list2 = Find_All_Objects_With_Hint("objective2")
		base_shields2 = table.getn(objective_list2)
		-- begin this bit will change per the mission objective --
		
		if base_shields1 < 1 or base_shields2 < 1 then
			Story_Event("COMPLETE_OBJECTIVE_02")
			if got_target then
				Story_Event("ENDMISSION_VICTORY")
				victory_triggered = true
  				Create_Thread("End_Sequence")
			end
		end
		
		
		-- end this bit will change per the mission objective --
		
	end
end

-- make only minor tweaks to the script below... --

function State_NalHutta_Kidnapping_Mission_Speech_Line_00_Remove_Text(message)
	if message == OnEnter then
		--Story_Event("ADD_OBJECTIVE_00")
		--Story_Event("ADD_OBJECTIVE_02")
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