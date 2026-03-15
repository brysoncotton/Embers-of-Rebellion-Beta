-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Mandalore_Piracy_Prologue.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Mandalore_Piracy_Prologue.lua $
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
		Underworld_Tutorial_Piracy_Mission_Begin = State_Underworld_Tutorial_Piracy_Mission_Begin,
		Underworld_Tutorial_Piracy_Speech_Line_00_Remove_Text = State_Underworld_Tutorial_Piracy_Speech_Line_00_Remove_Text,
		Underworld_Tutorial_Piracy_Speech_Line_01_Remove_Text = State_Underworld_Tutorial_Piracy_Speech_Line_01_Remove_Text,
		Underworld_Tutorial_Piracy_Speech_Line_02_Remove_Text = State_Underworld_Tutorial_Piracy_Speech_Line_02_Remove_Text,
		Underworld_Tutorial_Piracy_Speech_Line_03_Remove_Text = State_Underworld_Tutorial_Piracy_Speech_Line_03_Remove_Text,
		Underworld_Tutorial_Piracy_Speech_Line_04_Remove_Text = State_Underworld_Tutorial_Piracy_Speech_Line_04_Remove_Text,
		Underworld_Tutorial_Piracy_Speech_Line_05_Remove_Text = State_Underworld_Tutorial_Piracy_Speech_Line_05_Remove_Text,
		Underworld_Tutorial_Piracy_Speech_Line_06_Remove_Text = State_Underworld_Tutorial_Piracy_Speech_Line_06_Remove_Text,
		Underworld_Tutorial_Piracy_Speech_Line_100_Remove_Text = State_Underworld_Tutorial_Piracy_Speech_Line_100_Remove_Text
	}
		
	underworld = Find_Player("Underworld")
	rebel = Find_Player("Rebel")
	empire = Find_Player("Empire")
	hutts = Find_Player("Hutts")
	neutral = Find_Player("Neutral")
	
	camera_offset = 125
	
	mission_started = false	
	intro_rotate = true	
	vwings_killed = false
	vwing_alive = true
	strategist_spawned = false
	engines_destroyed = false
	escort_destroyed = false
	shuttle_prox_given = false
	guard_cycle = true
	strategist_neutral = false
	guard1_attacked = false
	guard2_attacked = false
	guard3_attacked = false
	guard4_attacked = false
	guard5_attacked = false
	guard6_attacked = false
	guard7_attacked = false
	
end

function State_Underworld_Tutorial_Piracy_Mission_Begin(message)
	if message == OnEnter then
		shuttle = Find_First_Object("TYBER_ZANN_BOARDING_SHUTTLE_PROLOGUE")
		
		if TestValid(shuttle) then
			shuttle.Highlight(true)
			shuttle.Set_Cannot_Be_Killed(true)
		end
		
		Story_Event("ADD_OBJECTIVE_03")
		
		--Spawn in my hutt forces
		vwing_spawn_0 = Find_Hint ("STORY_TRIGGER_ZONE_00","vwingspawn0")
		vwing_spawn_1 = Find_Hint ("STORY_TRIGGER_ZONE_00","vwingspawn1")
		vwing_spawn_2 = Find_Hint ("STORY_TRIGGER_ZONE_00","vwingspawn2")
		vwing_spawn_3 = Find_Hint ("STORY_TRIGGER_ZONE_00","vwingspawn3")
		vwing_spawn_4 = Find_Hint ("STORY_TRIGGER_ZONE_00","vwingspawn4")
		hutt_base_loc = Find_Hint ("STORY_TRIGGER_ZONE_00","huttbase")
		
		vwing_0_list = Spawn_Unit(Find_Object_Type("HUTT_VWING_SQUADRON"), vwing_spawn_0, hutts)
		intro_vwing = vwing_0_list[1]
		vwing_1_list = Spawn_Unit(Find_Object_Type("HUTT_VWING_SQUADRON"), vwing_spawn_1, hutts)
		vwing_2_list = Spawn_Unit(Find_Object_Type("HUTT_VWING_SQUADRON"), vwing_spawn_2, hutts)
		vwing_3_list = Spawn_Unit(Find_Object_Type("HUTT_VWING_SQUADRON"), vwing_spawn_3, hutts)
		vwing_4_list = Spawn_Unit(Find_Object_Type("HUTT_VWING_SQUADRON"), vwing_spawn_4, hutts)
		
		hutt_base = Create_Generic_Object (Find_Object_Type("HUTT_ASTEROID_BASE"), hutt_base_loc, hutts)
		
		if TestValid(hutt_base) then
			hutt_base.Set_Garrison_Spawn(false)		
			hutt_base.Prevent_Opportunity_Fire(true)
		end
		
		vwing_list = Find_All_Objects_Of_Type("HUTT_V-WING_FIGHTER")
		
		for k, unit in pairs(vwing_list) do
			if TestValid(unit) then
				if unit.Get_Parent_Object() == vwing_0_list[1] then
					vwing0 = unit
				end
				if unit.Get_Parent_Object() == vwing_1_list[1] then
					vwing1 = unit
				end
				if unit.Get_Parent_Object() == vwing_2_list[1] then
					vwing2 = unit
				end
				if unit.Get_Parent_Object() == vwing_3_list[1] then
					vwing3 = unit
				end
				if unit.Get_Parent_Object() == vwing_4_list[1] then
					vwing4 = unit
				end
			end
		end
				
		mission_started = true
		
		
		current_cinematic_thread = Create_Thread("Intro_Cinematic")
	end
end

function Story_Mode_Service()
	if mission_started and not TestValid(shuttle) then
		Story_Event("FAIL_OBJECTIVE_03")
	end
	
	underworld_unit_list = Find_All_Objects_Of_Type(underworld)
	
	if mission_started and 
	   underworld_unit_list[1].Get_Type().Get_Name() == "TYBER_ZANN_BOARDING_SHUTTLE_PROLOGUE" and 
	   not TestValid(underworld_unit_list[2]) then
			Story_Event("FAIL_NO_FORCES")
	end
	
	if mission_started and not vwings_killed then
		fighter_list = Find_All_Objects_Of_Type("HUTT_V-WING_FIGHTER")
		
		vwing_alive = false
		for k, unit in pairs(fighter_list) do
			if TestValid(unit) then
				vwing_alive = true
			end
		end
		
		if not vwing_alive then
			vwings_killed = true
			Story_Event("COMPLETE_OBJECTIVE_00")
			Story_Event("TEXT_SPEECH_UNDERWORLD_PIRACY_TUTORIAL_04")
		end
	end
	
	if mission_started and not TestValid(vwing_0_list[1]) then
		vwing0_reveal.Undo_Reveal()
	end
	if mission_started and not TestValid(vwing_1_list[1]) then
		vwing1_reveal.Undo_Reveal()
	end
	if mission_started and not TestValid(vwing_2_list[1]) then
		vwing2_reveal.Undo_Reveal()
	end
	if mission_started and not TestValid(vwing_3_list[1]) then
		vwing3_reveal.Undo_Reveal()
	end
	if mission_started and not TestValid(vwing_4_list[1]) then
		vwing4_reveal.Undo_Reveal()
	end
	
	if strategist_spawned and not strategist.Are_Engines_Online() and not engines_destroyed and escort_destroyed then
		Story_Event("COMPLETE_OBJECTIVE_01")
		engines_destroyed = true
		Create_Thread("Cycle_Guards")	
		if TestValid(strategist) then
			strategist.Override_Max_Speed(0)
			strategist.Suspend_Locomotor(true)
		end
	end
	
	if strategist_spawned and not strategist.Are_Engines_Online() and not strategist_neutral then
		strategist_neutral = true
		strategist.Change_Owner(neutral)
		
		if TestValid(strategist) then
			strategist.Suspend_Locomotor(true)
		end
		
		if TestValid(guard1) then
			guard1.Suspend_Locomotor(true)
		end
		
		if TestValid(guard2) then	
			guard2.Suspend_Locomotor(true)
		end
		
		if TestValid(guard3) then	
			guard3.Suspend_Locomotor(true)
		end
		
		if TestValid(guard4) then
			guard4.Suspend_Locomotor(true)
		end
		
		if TestValid(guard5) then	
			guard5.Suspend_Locomotor(true)
		end
		
		if TestValid(guard6) then	
			guard6.Suspend_Locomotor(true)
		end
		
		if TestValid(guard7) then	
			guard7.Suspend_Locomotor(true)
		end
		
		underworld_list = Find_All_Objects_Of_Type(underworld)
		
		for k, unit in pairs(underworld_list) do
			if TestValid(unit) then
				unit.Prevent_All_Fire(true)
			end
		end
		
		for k, unit in pairs(underworld_list) do
			if TestValid(unit) then
				unit.Prevent_All_Fire(false)
			end
		end
	end
	
	if strategist_spawned and not escort_destroyed and
	   not TestValid(guard1) and 
	   not TestValid(guard2) and
	   not TestValid(guard3) and
	   not TestValid(guard4) and
	   not TestValid(guard5) and
	   not TestValid(guard6) and
	   not TestValid(guard7) then
			Story_Event("COMPLETE_OBJECTIVE_04")
			Story_Event("ADD_OBJECTIVE_01")
			
			escort_destroyed = true
	end
	
	if engines_destroyed and escort_destroyed and not shuttle_prox_given then
		shuttle_prox_given = true		
		Story_Event("ADD_OBJECTIVE_02")
		if TestValid(shuttle) then
			Register_Prox(shuttle, Prox_Boarding_Shuttle, 100, neutral)
			shuttle.Highlight(true)
		end
	end
	
	if strategist_spawned and TestValid(strategist) then
		strategist_reveal.Undo_Reveal()
		strategist_reveal = FogOfWar.Reveal(underworld, strategist, 400, 400)
	end
	
	if strategist_spawned and not guard_cycle then
		guard_cycle = true
		Create_Thread("Cycle_Guards")
	end
end

function Prox_Boarding_Shuttle(self_obj, trigger_obj)
	if engines_destroyed and trigger_obj == strategist then	
		if TestValid(shuttle) then
			shuttle.Highlight(false)
		end
		Story_Event("COMPLETE_OBJECTIVE_02")
		Story_Event("TEXT_SPEECH_UNDERWORLD_PIRACY_TUTORIAL_06")
	end
end

function Cycle_Guards()
	Sleep(5)
	guard_cycle = false
	
	if TestValid(strategist) then
--		if TestValid(guard1) then 
--			guard1.Attack_Move(strategist)
--		end
--		if TestValid(guard2) then 
--			guard2.Attack_Move(strategist)
--		end
--		if TestValid(guard3) then 
--			guard3.Attack_Move(strategist)
--		end
--		if TestValid(guard4) then 
--			guard4.Attack_Move(strategist)
--		end
--		if TestValid(guard5) then 
--			guard5.Attack_Move(strategist)
--		end
--		if TestValid(guard6) then 
--			guard6.Attack_Move(strategist)
--		end
--		if TestValid(guard7) then 
--			guard7.Attack_Move(strategist)
--		end
	end
end

function Warp_In_Strategist()
	Sleep(6)
	
	warp_loc = Find_Hint("STORY_TRIGGER_ZONE_00","warpin")
	strategist_list = Spawn_Unit(Find_Object_Type("HUTT_REFURBISHED_VENATOR"), warp_loc, hutts)
	strategist = strategist_list[1]
	strategist.Set_Cannot_Be_Killed(true)
	if TestValid(strategist) then
		strategist.Teleport_And_Face(warp_loc)
		strategist.Hide(true)
	end
	
	warp_1_loc = Find_Hint("STORY_TRIGGER_ZONE_00","warpin1")
	guard1_list = Spawn_Unit(Find_Object_Type("HUTT_IPV1_CRAFT"), warp_1_loc, hutts)
	guard1 = guard1_list[1]
	if TestValid(guard1) then
		guard1.Teleport_And_Face(warp_1_loc)
		guard1.Hide(true)
	end
	
	warp_2_loc = Find_Hint("STORY_TRIGGER_ZONE_00","warpin2")
	guard2_list = Spawn_Unit(Find_Object_Type("HUTT_IPV1_CRAFT"), warp_2_loc, hutts)
	guard2 = guard2_list[1]
	if TestValid(guard2) then
		guard2.Teleport_And_Face(warp_2_loc)
		guard2.Hide(true)
	end
	
	warp_3_loc = Find_Hint("STORY_TRIGGER_ZONE_00","warpin3")
	guard3_list = Spawn_Unit(Find_Object_Type("HUTT_IPV1_CRAFT"), warp_3_loc, hutts)
	guard3 = guard3_list[1]
	if TestValid(guard3) then
		guard3.Teleport_And_Face(warp_3_loc)
		guard3.Hide(true)
	end
	
	warp_4_loc = Find_Hint("STORY_TRIGGER_ZONE_00","warpin4")
	guard4_list = Spawn_Unit(Find_Object_Type("HUTT_CORELLIAN_CORVETTE"), warp_4_loc, hutts)
	guard4 = guard4_list[1]
	if TestValid(guard4) then
		guard4.Teleport_And_Face(warp_4_loc)
		guard4.Hide(true)
	end
	
	warp_5_loc = Find_Hint("STORY_TRIGGER_ZONE_00","warpin5")
	guard5_list = Spawn_Unit(Find_Object_Type("HUTT_IPV1_CRAFT"), warp_5_loc, hutts)
	guard5 = guard5_list[1]
	if TestValid(guard5) then
		guard5.Teleport_And_Face(warp_5_loc)
		guard5.Hide(true)
	end
	
	warp_6_loc = Find_Hint("STORY_TRIGGER_ZONE_00","warpin6")
	guard6_list = Spawn_Unit(Find_Object_Type("HUTT_IPV1_CRAFT"), warp_6_loc, hutts)
	guard6 = guard6_list[1]
	if TestValid(guard6) then
		guard6.Teleport_And_Face(warp_6_loc)
		guard6.Hide(true)
	end
	
	warp_7_loc = Find_Hint("STORY_TRIGGER_ZONE_00","warpin7")
	guard7_list = Spawn_Unit(Find_Object_Type("HUTT_IPV1_CRAFT"), warp_7_loc, hutts)
	guard7 = guard7_list[1]
	if TestValid(guard7) then
		guard7.Teleport_And_Face(warp_7_loc)
		guard7.Hide(true)
	end
	
	Create_Thread("Strategist_Midtro")
	
end

function Prox_Guard_Attack(self_obj, trigger_obj)
	if not engines_destroyed and trigger_obj.Get_Owner() == underworld then		
--		if self_obj == guard1 then
--			guard1_attacked = true
--			self_obj.Override_Max_Speed(2.75)
--			self_obj.Attack_Target(trigger_obj)
--		end
--		if self_obj == guard2 then
--			guard2_attacked = true
--			self_obj.Override_Max_Speed(2.75)
--			self_obj.Attack_Target(trigger_obj)
--		end
--		if self_obj == guard3 then
--			guard3_attacked = true
--			self_obj.Override_Max_Speed(2.75)
--			self_obj.Attack_Target(trigger_obj)
--		end
--		if self_obj == guard4 then
--			guard4_attacked = true
--		end
--		if self_obj == guard5 then
--			guard5_attacked = true
--		end
--		if self_obj == guard6 then
--			guard6_attacked = true
--		end
--		if self_obj == guard7 then
--			guard7_attacked = true
--			self_obj.Override_Max_Speed(2.75)
--			self_obj.Attack_Target(trigger_obj)
--		end
	end
end

function Story_Handle_Esc()
	if current_cinematic_thread ~= nil then
		Thread.Kill(current_cinematic_thread)
		current_cinematic_thread = nil
		
		Stop_All_Music()
		Stop_All_Speech()
		Remove_All_Text()
		
		Story_Event("PROLOGUE_MANDALORE_ESC_PREVENT_INTRO_DIALOG_AI_NOTIFICATION")
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
	
	if TestValid(vwing0) then
		vwing0.Highlight(true)
		Add_Radar_Blip(vwing0, "vwing_0_blip")
		vwing0_reveal = FogOfWar.Reveal(underworld, vwing0, 400, 400)
	end
	
	if TestValid(vwing1) then
		vwing1.Highlight(true)
		Add_Radar_Blip(vwing1, "vwing_1_blip")
		vwing1_reveal = FogOfWar.Reveal(underworld, vwing1, 400, 400)
	end
	
	if TestValid(vwing2) then
		vwing2.Highlight(true)
		Add_Radar_Blip(vwing2, "vwing_2_blip")
		vwing2_reveal = FogOfWar.Reveal(underworld, vwing2, 400, 400)
	end
		
	if TestValid(vwing3) then
		vwing3.Highlight(true)
		Add_Radar_Blip(vwing3, "vwing_3_blip")
		vwing3_reveal = FogOfWar.Reveal(underworld, vwing3, 400, 400)
	end
	
	if TestValid(vwing4) then
		vwing4.Highlight(true)
		Add_Radar_Blip(vwing4, "vwing_4_blip")
		vwing4_reveal = FogOfWar.Reveal(underworld, vwing4, 400, 400)
	end
	
	Story_Event("ADD_OBJECTIVE_00")
	
	fighter_list = Find_All_Objects_Of_Type("StarViper_Team")
	for k, unit in pairs(fighter_list) do
		if TestValid(unit) then
			underworld.Select_Object(unit)
		end
	end
	Story_Event("HIGHLIGHT_BUZZ")
	
	Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_100")
	
	Sleep(10)
	shuttle.Highlight(false)
end



-- ************************************************************************
-- ***********************INTRO CINEMATIC FUNCTION*************************
-- ************************************************************************

function Intro_Cinematic ()	
	
	Lock_Controls(1)
	Start_Cinematic_Camera()
	Cancel_Fast_Forward()
	Letter_Box_In(0)	
	Fade_Screen_In(2)
	
	intro_target = Find_First_Object("TYBER_ZANN_BOARDING_SHUTTLE_PROLOGUE")
	
	Transition_Cinematic_Camera_Key(intro_target, 0, 175, 15, 45, 1, 1, 1, 0)
	Transition_Cinematic_Target_Key(intro_target, 0, 0, 0, 7, 0, intro_target, 0, 0)
	--Sleep(7)
	
	Transition_Cinematic_Camera_Key(intro_target, 10, 175, 15, 135, 1, 1, 1, 0)
	
	Story_Event("TEXT_SPEECH_UNDERWORLD_PIRACY_TUTORIAL_00")
	
	Sleep(9.5)
	
	while intro_rotate do
		camera_offset = camera_offset + 90
		Transition_Cinematic_Camera_Key(intro_target, 10, 175, 15, camera_offset, 1, 1, 1, 0)
		
		if camera_offset == 315 then
			camera_offset = -45
		end
		
		Sleep(9.5)
	end
end

function Intro_Cinematic_01()
	intro_rotate = false
	
	
	Transition_Cinematic_Target_Key(intro_vwing, 9, 0, 0, 0, 0, intro_vwing, 0, 0)
	Sleep(4)
	Transition_Cinematic_Camera_Key(intro_vwing, 5, 400, 15, 60, 1, 1, 1, 0)
end

function Strategist_Midtro()
	Suspend_AI(1)
	Lock_Controls(1)
	Start_Cinematic_Camera()
	Cancel_Fast_Forward()
	Letter_Box_In(0)
	Fade_Screen_In(1)
	
	if TestValid(guard1) then
		guard1.Cinematic_Hyperspace_In(10)
		guard1.Hide(false)
	end
	
	if TestValid(guard2) then
		guard2.Cinematic_Hyperspace_In(25)
		guard2.Hide(false)
	end
	
	if TestValid(guard3) then
		guard3.Cinematic_Hyperspace_In(40)
		guard3.Hide(false)
	end
	
	if TestValid(guard4) then
		guard4.Cinematic_Hyperspace_In(55)
		guard4.Hide(false)
	end
	
	if TestValid(guard5) then
		guard5.Cinematic_Hyperspace_In(70)
		guard5.Hide(false)
	end
	
	if TestValid(strategist) then
		strategist.Cinematic_Hyperspace_In(85)
		strategist.Hide(false)
	end
	
	if TestValid(guard6) then
		guard6.Cinematic_Hyperspace_In(100)
		guard6.Hide(false)
	end
	
	if TestValid(guard7) then
		guard7.Cinematic_Hyperspace_In(115)
		guard7.Hide(false)
	end
	
	Transition_Cinematic_Camera_Key(warp_loc, 0, 900, 20, 125, 1, 1, 1, 0)
	Transition_Cinematic_Target_Key(warp_loc, 0, 0, 0, 7, 0, warp_loc, 0, 0)
	
	Transition_Cinematic_Camera_Key(warp_loc, 15, 600, 10, 125, 1, 1, 1, 0)
	
	Sleep(0.25)
	warp_loc.Play_SFX_Event("Unit_Ship_Hyperspace_Enter")
	Sleep(0.50)
	warp_loc.Play_SFX_Event("Unit_Ship_Hyperspace_Enter")
	Sleep(0.50)
	warp_loc.Play_SFX_Event("Unit_Ship_Hyperspace_Enter")
	Sleep(0.50)
	warp_loc.Play_SFX_Event("Unit_Ship_Hyperspace_Enter")
	Sleep(0.50)
	warp_loc.Play_SFX_Event("Unit_Ship_Hyperspace_Enter")
	Sleep(0.50)
	warp_loc.Play_SFX_Event("Unit_Ship_Hyperspace_Enter")
	Sleep(0.50)
	warp_loc.Play_SFX_Event("Unit_Ship_Hyperspace_Enter")
	Sleep(0.50)
	warp_loc.Play_SFX_Event("Unit_Ship_Hyperspace_Enter")
	Sleep(1.25)
	
	
	
	Story_Event("TEXT_SPEECH_UNDERWORLD_PIRACY_TUTORIAL_05")
end	

function State_Underworld_Tutorial_Piracy_Speech_Line_00_Remove_Text(message)
	if message == OnEnter then
		Story_Event("TEXT_SPEECH_UNDERWORLD_PIRACY_TUTORIAL_01")
	end
end

function State_Underworld_Tutorial_Piracy_Speech_Line_01_Remove_Text(message)
	if message == OnEnter then
		Story_Event("TEXT_SPEECH_UNDERWORLD_PIRACY_TUTORIAL_02")
		
		Create_Thread("Intro_Cinematic_01")
	end
end

function State_Underworld_Tutorial_Piracy_Speech_Line_02_Remove_Text(message)
	if message == OnEnter then
		Story_Event("TEXT_SPEECH_UNDERWORLD_PIRACY_TUTORIAL_03")
	end
end

function State_Underworld_Tutorial_Piracy_Speech_Line_03_Remove_Text(message)
	if message == OnEnter then		
		current_cinematic_thread = nil
		Create_Thread("End_Camera")
	end
end

function State_Underworld_Tutorial_Piracy_Speech_Line_04_Remove_Text(message)
	if message == OnEnter then
		Create_Thread("Warp_In_Strategist")
	end
end

function State_Underworld_Tutorial_Piracy_Speech_Line_05_Remove_Text(message)
	if message == OnEnter then
		Story_Event("ADD_OBJECTIVE_04")
		
		Transition_To_Tactical_Camera(6)
		Sleep(4)
		Letter_Box_Out(2)
		Sleep(2)
		Lock_Controls(0)
		End_Cinematic_Camera()
		Suspend_AI(0)
		
		if TestValid(strategist) then
			strategist.Highlight(true)
			Add_Radar_Blip(strategist, "strategist_blip")
			strategist.Override_Max_Speed(1)
			if TestValid(hutt_base_loc) then
				strategist.Move_To(hutt_base_loc)
			end
			strategist_reveal = FogOfWar.Reveal(underworld, strategist, 400, 400)
		end
		
		if TestValid(guard1) then
			guard1.Override_Max_Speed(1)
			if TestValid(hutt_base_loc) then
				guard1.Move_To(hutt_base_loc)
			end		
			Register_Prox(guard1, Prox_Guard_Attack, 1200, underworld)
		end
		
		if TestValid(guard2) then
			guard2.Override_Max_Speed(1)
			if TestValid(hutt_base_loc) then
				guard2.Move_To(hutt_base_loc)
			end		
			Register_Prox(guard2, Prox_Guard_Attack, 1200, underworld)
		end
		
		if TestValid(guard3) then
			guard3.Override_Max_Speed(1)
			if TestValid(hutt_base_loc) then
				guard3.Move_To(hutt_base_loc)
			end		
			Register_Prox(guard3, Prox_Guard_Attack, 1200, underworld)
		end
		
		if TestValid(guard4) then
			guard4.Override_Max_Speed(1)
			if TestValid(hutt_base_loc) then
				guard4.Move_To(hutt_base_loc)
			end		
			Register_Prox(guard4, Prox_Guard_Attack, 1200, underworld)
		end
		
		if TestValid(guard5) then	
			guard5.Override_Max_Speed(1)
			if TestValid(hutt_base_loc) then
				guard5.Move_To(hutt_base_loc)
			end		
			Register_Prox(guard5, Prox_Guard_Attack, 1200, underworld)
		end
		
		if TestValid(guard6) then	
			guard6.Override_Max_Speed(1)
			if TestValid(hutt_base_loc) then
				guard6.Move_To(hutt_base_loc)
			end		
			Register_Prox(guard6, Prox_Guard_Attack, 1200, underworld)
		end
		
		if TestValid(guard7) then	
			guard7.Override_Max_Speed(1)
			if TestValid(hutt_base_loc) then
				guard7.Move_To(hutt_base_loc)
			end
			Register_Prox(guard7, Prox_Guard_Attack, 1200, underworld)
		end
				
		strategist_spawned = true
		
		Sleep(1)
		
		Story_Event("TEXT_SPEECH_UNDERWORLD_PIRACY_TUTORIAL_07")
	end
end



function State_Underworld_Tutorial_Piracy_Speech_Line_06_Remove_Text(message)
	if message == OnEnter then
		Story_Event("SEND_VICTORY")
	end
end