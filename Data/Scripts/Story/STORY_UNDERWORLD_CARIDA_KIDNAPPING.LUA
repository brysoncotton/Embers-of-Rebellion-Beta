-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Carida_Kidnapping.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Carida_Kidnapping.lua $
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
--			DO NOT PUT OBJECT REFERENCES HERE.  THEY ARE NOT CREATED YET.
--
function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))
	
	StoryModeEvents = 
	{
		Carida_Kidnapping_Mission_Begin = State_Carida_Kidnapping_Mission_Begin,
		Carida_Kidnapping_Mission_Speech_Line_00_Remove_Text = State_Carida_Kidnapping_Mission_Speech_Line_00_Remove_Text,
		Carida_Kidnapping_Mission_Speech_Line_01_Remove_Text = State_Carida_Kidnapping_Mission_Speech_Line_01_Remove_Text,
		Carida_Kidnapping_Mission_Speech_Line_02_Remove_Text = State_Carida_Kidnapping_Mission_Speech_Line_02_Remove_Text
	}
		
	underworld = Find_Player("Underworld")
	rebel = Find_Player("Rebel")
	empire = Find_Player("Empire")
	hutts = Find_Player("Hutts")
	neutral = Find_Player("Neutral")
	
	empire_defender = false
	rebel_defender = false
	
	follow_triggered = false
	mission_started = false
	victory_triggered = false
	patrol_1_locked = false
	patrol_2_locked = false
end

function State_Carida_Kidnapping_Mission_Begin(message)
	if message == OnEnter then
		mission_started = true
		
		hero = Find_First_Object("BOSSK")
		
		--Turn off all units
		rebel_list = Find_All_Objects_Of_Type(rebel)
		empire_list = Find_All_Objects_Of_Type(empire)
		
		for k, unit in pairs(rebel_list) do
			if TestValid(unit) then
				unit.Prevent_AI_Usage(true)
				unit.Stop()
				--unit.Suspend_Locomotor(true)
				--unit.Prevent_All_Fire(true)
			end
		end
		
		for k, unit in pairs(empire_list) do
			if TestValid(unit) then
				unit.Prevent_AI_Usage(true)
				unit.Stop()
				--unit.Suspend_Locomotor(true)
				--unit.Prevent_All_Fire(true)
			end
		end
		
		entry_troop = Find_All_Objects_With_Hint("entrytroop")
		objective_list = Find_All_Objects_With_Hint("objective")
		objective = objective_list[1]
		if objective.Get_Owner().Get_Faction_Name() == "EMPIRE" then
			empire_defender = true
		end
		if objective.Get_Owner().Get_Faction_Name() == "REBEL" then
			rebel_defender = true
		end
		objective.Make_Invulnerable(true)
		objective.Change_Owner(neutral)
		
		pad0_list = Find_All_Objects_With_Hint("pad0")
		pad_0 = pad0_list[1]
		pad_0_troop = Find_All_Objects_With_Hint("pad0troop")
		pad_0_troop[1].Guard_Target(pad_0)
		pad1_list = Find_All_Objects_With_Hint("pad1")
		pad_1 = pad1_list[1]
		pad_1_troop = Find_All_Objects_With_Hint("pad1troop")
		pad_1_troop[1].Guard_Target(pad_1)
		
		rebel_base = Find_Hint("STORY_TRIGGER_ZONE_00","rebbase")
		empire_base = Find_Hint("STORY_TRIGGER_ZONE_00","empbase")
		
		alt_aircraft_list = Find_All_Objects_With_Hint("altaircraft")
		base_aircraft_list = Find_All_Objects_With_Hint("baseaircraft")
		
		alt_unit_list = Find_All_Objects_With_Hint("altunit")
		base_unit_list = Find_All_Objects_With_Hint("baseunit")
		
		if empire_defender then
			for k, unit in pairs(alt_aircraft_list) do
				if TestValid(unit) then
					unit.Guard_Target(rebel_base)
				end
			end
			for k, unit in pairs(base_aircraft_list) do
				if TestValid(unit) then
					unit.Guard_Target(empire_base)
				end
			end
			for k, unit in pairs(alt_unit_list) do
				if TestValid(unit) then
					unit.Guard_Target(rebel_base)
				end
			end
			for k, unit in pairs(base_unit_list) do
				if TestValid(unit) then
					unit.Guard_Target(empire_base)
				end
			end
			
			objective_patrol_0 = Find_Hint("STORY_TRIGGER_ZONE_00","empobjpatrol0")	
			objective_patrol_1 = Find_Hint("STORY_TRIGGER_ZONE_00","empobjpatrol1")
		end
		
		if rebel_defender then
			for k, unit in pairs(base_aircraft_list) do
				if TestValid(unit) then
					unit.Guard_Target(rebel_base)
				end
			end
			for k, unit in pairs(alt_aircraft_list) do
				if TestValid(unit) then
					unit.Guard_Target(empire_base)
				end
			end
			for k, unit in pairs(base_unit_list) do
				if TestValid(unit) then
					unit.Guard_Target(rebel_base)
				end
			end
			for k, unit in pairs(alt_unit_list) do
				if TestValid(unit) then
					unit.Guard_Target(empire_base)
				end
			end
			
			objective_patrol_0 = Find_Hint("STORY_TRIGGER_ZONE_00","rebobjpatrol0")	
			objective_patrol_1 = Find_Hint("STORY_TRIGGER_ZONE_00","rebobjpatrol1")
		end
		
		kidnap_dest_list = Find_All_Objects_With_Hint("kidnapdest")
		kidnap_dest = kidnap_dest_list[1]
		Register_Prox(kidnap_dest, Prox_Kidnap_Destination, 100, neutral)		
		
		lancet_list = Find_All_Objects_Of_Type("LANCET_AIR_ARTILLERY")
		
		for k, unit in pairs(lancet_list) do
			if TestValid(unit) then
				Register_Prox(unit, Prox_Lancet_Attack, 250, underworld)
			end
		end
		
		objective.Move_To(objective_patrol_0)
		Register_Prox(objective, Prox_Objective_Object, 20, underworld)
		Register_Prox(objective_patrol_0, Prox_Objective_Patrol_0, 10, neutral)
		Register_Prox(objective_patrol_1, Prox_Objective_Patrol_1, 10, neutral)
		
		Point_Camera_At(hero)
		Start_Cinematic_Camera()
		End_Cinematic_Camera()
		Letter_Box_Out(0)
		
		--current_cinematic_thread = Create_Thread("Intro_Cinematic", hero)
		Fade_Screen_In(1)
		Lock_Controls(0)
		
		Story_Event("TEXT_SPEECH_CARIDA_KID_TACTICAL_COR11_02")
	end
end

function Story_Mode_Service()
	if mission_started then				
		if not TestValid(hero) then
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
	
	if follow_triggered then
		if TestValid(objective) then 
			objective.Move_To(hero)
		end
	end		
end

function Prox_Lancet_Attack(self_obj, trigger_obj)
	if trigger_obj.Get_Owner() == underworld and trigger_obj.Get_Type().Get_Name() ~= "BOSSK" then
		self_obj.Attack_Target(trigger_obj)
	end
end

function Prox_Objective_Object(self_obj, trigger_obj)
	if trigger_obj.Get_Type().Get_Name() == "BOSSK" and not follow_triggered then
		Story_Event("TEXT_SPEECH_CARIDA_KID_TACTICAL_COR_11_07")
		objective.Stop()
		
		Story_Event("COMPLETE_OBJECTIVE_00")
	end
end

function State_Carida_Kidnapping_Mission_Speech_Line_01_Remove_Text(message)
	if message == OnEnter then
		follow_triggered = true
		objective.Move_To(hero)
		
		Story_Event("TEXT_SPEECH_CARIDA_KID_TACTICAL_COR_11_08")
	end
end

function State_Carida_Kidnapping_Mission_Speech_Line_02_Remove_Text(message)
	if message == OnEnter then
		Story_Event("ADD_OBJECTIVE_02")
		
		rebel_list = Find_All_Objects_Of_Type(rebel)
		empire_list = Find_All_Objects_Of_Type(empire)
		for k, unit in pairs(rebel_list) do
			if TestValid(unit) then
				if unit.Is_Category("Infantry") or unit.Is_Category("Vehicle") or unit.Is_Category("Air") then
					unit.Guard_Target(objective)
				end
			end
		end
		for k, unit in pairs(empire_list) do
			if TestValid(unit) then
				if unit.Is_Category("Infantry") or unit.Is_Category("Vehicle") or unit.Is_Category("Air") then
					unit.Guard_Target(objective)
				end
			end
		end
	end
end

function Prox_Objective_Patrol_0(self_obj, trigger_obj)
	if trigger_obj == objective and not patrol_0_locked then
		patrol_0_locked = true
		Create_Thread("Patrol_Move", objective_patrol_1)
	end
end

function Prox_Objective_Patrol_1(self_obj, trigger_obj)
	if trigger_obj == objective and not patrol_1_locked then
		patrol_1_locked = true
		Create_Thread("Patrol_Move", objective_patrol_0)
	end
end

function Prox_Kidnap_Destination(self_obj, trigger_obj)
	if follow_triggered and trigger_obj == objective then		
		Story_Event("COMPLETE_OBJECTIVE_02")
	end
end

function Patrol_Move(destination)
	if not follow_triggered then
		Sleep(5)
		objective.Move_To(destination)
		patrol_0_locked = false
		patrol_1_locked = false
	end
end

function State_Carida_Kidnapping_Mission_Speech_Line_00_Remove_Text(message)
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
	
	Transition_Cinematic_Camera_Key(focus_unit, 0, 50, 25, 45, 1, 1, 1, 0)
	Transition_Cinematic_Target_Key(focus_unit, 0, 0, 0, 7, 0, focus_unit, 0, 0)
	
	Transition_Cinematic_Camera_Key(focus_unit, 5, 50, 25, 135, 1, 1, 1, 0)
	
	camera_offset = 135
	
	Sleep(4.5)
	
	while true do
		camera_offset = camera_offset + 90
		Transition_Cinematic_Camera_Key(focus_unit, 5, 50, 25, camera_offset, 1, 1, 1, 0)
		
		if camera_offset == 315 then
			Story_Handle_Esc()
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
	
	Story_Event("TEXT_SPEECH_CARIDA_KID_TACTICAL_COR11_02")
end