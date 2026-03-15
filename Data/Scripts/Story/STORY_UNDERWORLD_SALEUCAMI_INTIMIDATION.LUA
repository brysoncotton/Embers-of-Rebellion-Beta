-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Saleucami_Intimidation.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Saleucami_Intimidation.lua $
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
		Saleucami_Intimidation_Mission_Begin = State_Saleucami_Intimidation_Mission_Begin,
		Saleucami_Intimidation_Mission_Speech_Line_00_Remove_Text = State_Saleucami_Intimidation_Mission_Speech_Line_00_Remove_Text
	}
		
	underworld = Find_Player("Underworld")
	rebel = Find_Player("Rebel")
	empire = Find_Player("Empire")
	hutts = Find_Player("Hutts")
	
	camera_offset = 135
	
	phase_0_triggered = false
	mission_started = false
	victory_triggered = false
	loss_triggered = false
end

function State_Saleucami_Intimidation_Mission_Begin(message)
	if message == OnEnter then
	
		
		Story_Event("ADD_OBJECTIVE_00")
				
		--Turn off all phase 0 units
		phase_0_list = Find_All_Objects_With_Hint("phase0")
		phase_1_list = Find_All_Objects_With_Hint("phase1")
		phase_2_list = Find_All_Objects_With_Hint("phase2")
		phase_0_trooper_list = Find_All_Objects_With_Hint("phase0trooper")
		phase_0_vehicle_list = Find_All_Objects_With_Hint("phase0vehicle")
		
		pad0 = Find_Hint("SKIRMISH_BUILD_PAD", "phase0pad0")
		pad1 = Find_Hint("SKIRMISH_BUILD_PAD", "phase0pad1")
		
		
		
		for k, unit in pairs(phase_0_list) do
			if TestValid(unit) then
				unit.Suspend_Locomotor(true)
			end
		end
		
		for k, unit in pairs(phase_1_list) do
			if TestValid(unit) then
				unit.Prevent_AI_Usage(true)
				unit.Stop()
				--unit.Suspend_Locomotor(true)
				unit.Prevent_All_Fire(true)
			end
		end
		
		for k, unit in pairs(phase_2_list) do
			if TestValid(unit) then
				unit.Suspend_Locomotor(true)
				unit.Prevent_All_Fire(true)
			end
		end
		
		for k, unit in pairs(phase_0_trooper_list) do
			if TestValid(unit) then
				unit.Suspend_Locomotor(true)
			end
		end
		
		for k, unit in pairs(phase_0_vehicle_list) do
			if TestValid(unit) then
				unit.Suspend_Locomotor(true)
			end
		end
		
		objective_list = Find_All_Objects_With_Hint("objective")
		objective_unit = objective_list[1]
		
		base_entry_list = Find_All_Objects_With_Hint("baseentry")
		base_entry = base_entry_list[1]
		
		phase_1_flag_list = Find_All_Objects_With_Hint("phase1flag")
		phase_1_flag = phase_1_flag_list[1]
		
		Register_Prox(phase_1_flag, Prox_Phase_1_Entry, 150, underworld_player)
		Register_Prox(base_entry, Prox_Base_Entry, 150, underworld_player)
		
		Story_Event("TEXT_SPEECH_UW_CLD_01")
		urai = Find_First_Object("URAI_FEN")
		
		Point_Camera_At(urai)
		Start_Cinematic_Camera()
		End_Cinematic_Camera()
		Letter_Box_Out(0)
		
		--current_cinematic_thread = Create_Thread("Intro_Cinematic", hero)
		Fade_Screen_In(1)
		Lock_Controls(0)
		
		
		mission_started = true
	end
end

function Story_Mode_Service()
	if mission_started then
		urai = Find_First_Object("URAI_FEN")
				
		if not TestValid(urai) and not loss_triggered then
			loss_triggered = true
			Fail_Mission()
		end
	end
		
	phase_0_turret_list = Find_All_Objects_With_Hint("phase0turret")
	phase_0_turret = phase_0_turret_list[1]
	
	if not phase_0_triggered and not TestValid(phase_0_turret) then
		phase_0_triggered = true
		
		phase_0_trooper_list = Find_All_Objects_With_Hint("phase0trooper")
		phase_0_vehicle_list = Find_All_Objects_With_Hint("phase0vehicle")
		
		for k, unit in pairs(phase_0_trooper_list) do
			if TestValid(unit) then
				unit.Suspend_Locomotor(false)
				unit.Prevent_AI_Usage(true)
				unit.Guard_Target(pad0)
			end
		end
		
		for k, unit in pairs(phase_0_vehicle_list) do
			if TestValid(unit) then
				unit.Suspend_Locomotor(false)
				unit.Prevent_AI_Usage(true)
				unit.Guard_Target(pad1)
			end
		end
		
	end
		
	if mission_started and not victory_triggered then
		objective_list = Find_All_Objects_With_Hint("objective")
		objective_unit = objective_list[1]
		
		if not TestValid(objective_unit) then
			Story_Event("COMPLETE_OBJECTIVE_00")
			
			victory_triggered = true
			base_entry_list = Find_All_Objects_With_Hint("baseentry")
			base_entry = base_entry_list[1]
			base_entry.Play_SFX_Event("Unit_Underworld_Soldier_Bomb_Death")
		end
		
		--if TestValid(objective_unit) and objective_unit.Get_Hull() <= 0.25 then
		--	objective_unit.Make_Invulnerable(true)
		--	Story_Event("COMPLETE_OBJECTIVE_00")
		--	Remove_Radar_Blip("objective_blip")
		--	objective_unit.Highlight(false)
		--end
	end
end

function Fail_Mission()
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


function Prox_Phase_1_Entry(self_obj, trigger_obj)
	if trigger_obj.Get_Owner() == underworld then
		self_obj.Cancel_Event_Object_In_Range(Prox_Phase_1_Entry)
		phase_1_list = Find_All_Objects_With_Hint("phase1")
		
		for k, unit in pairs(phase_1_list) do
			if TestValid(unit) then
				unit.Prevent_AI_Usage(false)
				unit.Prevent_All_Fire(false)
			end
		end
	end
end

function Prox_Base_Entry(self_obj, trigger_obj)
	if trigger_obj.Get_Owner() == underworld then
		if TestValid(objective_unit) then
			self_obj.Cancel_Event_Object_In_Range(Prox_Base_Entry)
			objective_reveal = FogOfWar.Reveal(underworld, objective_unit, 250,250)
			Add_Radar_Blip(objective_unit, "objective_blip")
			objective_unit.Highlight(true)
		end
		
		phase_2_list = Find_All_Objects_With_Hint("phase2")
		for k, unit in pairs(phase_2_list) do
			if TestValid(unit) then
				unit.Prevent_AI_Usage(true)
				unit.Suspend_Locomotor(false)
				unit.Prevent_All_Fire(false)
				unit.Guard_Target(objective_unit)
			end
		end
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
	
	Story_Event("TEXT_SPEECH_UW_CLD_01")
end



-- ************************************************************************
-- ***********************INTRO CINEMATIC FUNCTION*************************
-- ************************************************************************

function Intro_Cinematic ()	
	
	Lock_Controls(1)
	Start_Cinematic_Camera()
	Letter_Box_In(0)	
	Fade_Screen_In(2)
	
	urai = Find_First_Object("URAI_FEN")
	
	Transition_Cinematic_Camera_Key(urai, 0, 50, 25, 45, 1, 1, 1, 0)
	Transition_Cinematic_Target_Key(urai, 0, 0, 0, 7, 0, urai, 0, 0)
	--Sleep(7)
	
	Transition_Cinematic_Camera_Key(urai, 5, 50, 25, 135, 1, 1, 1, 0)
	
	Sleep(4.5)
	
	while true do
		camera_offset = camera_offset + 90
		Transition_Cinematic_Camera_Key(urai, 5, 50, 25, camera_offset, 1, 1, 1, 0)
		
		if camera_offset == 315 then
			Create_Thread("End_Camera")
			--Thread.Kill(current_cinematic_thread)
			current_cinematic_thread = nil
			break
		end
		
		Sleep(4.5)
	end
end