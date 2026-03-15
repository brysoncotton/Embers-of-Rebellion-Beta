-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Mandalore_Piracy_Story.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Mandalore_Piracy_Story.lua $
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
		Mandalore_Piracy_Mission_Begin = State_Mandalore_Piracy_Mission_Begin,
		Mandalore_Piracy_Mission_Speech_Line_00_Remove_Text = State_Mandalore_Piracy_Mission_Speech_Line_00_Remove_Text
	}
		
	underworld = Find_Player("Underworld")
	rebel = Find_Player("Rebel")
	empire = Find_Player("Empire")
	pirate = Find_Player("Pirates")
	
	camera_offset = 135
	
	mission_started = false
	victory_triggered = false
	close_to_objective = false
	
	fighters_attack = false
	kedalbe_attack = false
	
end

function State_Mandalore_Piracy_Mission_Begin(message)
	if message == OnEnter then
		mission_started = true
		
		--current_cinematic_thread = Create_Thread("Intro_Cinematic")
		Story_Event("TEXT_SPEECH_UW_CLD_01")
		Story_Event("ADD_OBJECTIVE_00")
		objective_list = Find_All_Objects_With_Hint("objective")
		objective_unit = objective_list[1]
		if TestValid(objective_unit) then
			Add_Radar_Blip(objective_unit, "objective_blip")
			objective_unit.Highlight(true)
		end	
		Lock_Controls(0)
		--Story_Event("TEXT_SPEECH_UW_CLD_01")
		
		objective_unit = Find_Hint("PIRATE_ASTEROID_NON_VICTORY", "spacebase")
		
		kedalbe_objective = nil
		
		fightersa = Find_Hint("STORY_TRIGGER_ZONE", "fightersa")
		fightersb = Find_Hint("STORY_TRIGGER_ZONE", "fightersb")
		fightersc = Find_Hint("STORY_TRIGGER_ZONE", "fightersc")
		kedalbe = Find_Hint("STORY_TRIGGER_ZONE", "kedalbe")
		
		fighters_reinforce = {
			"STARVIPER_SQUADRON"
		}
		kedalbe_reinforce = {
			"KELDALBE_PROTOTYPE"
		}
		-- 9/19/06 JAC - We need this even if we're not doing a cinematic intro
		-- otherwise the Master Volume will be stuck at 0
		Start_Cinematic_Camera()
		End_Cinematic_Camera()
		Fade_Screen_In(1)
		Letter_Box_Out(0)
	end
end

function Story_Mode_Service()
	if mission_started then
		tyber = Find_First_Object("COR_TYBER_INTERCEPTOR")
				
		if not TestValid(tyber) then
			Story_Event("FAIL_OBJECTIVE_00")
			
			rebel_list = Find_All_Objects_Of_Type(rebel)
			empire_list = Find_All_Objects_Of_Type(empire)
			pirate_list = Find_All_Objects_Of_Type(pirate)
			
			if TestValid(rebel_list[1]) then
				Story_Event("VICTORY_REBEL")
			end
			
			if TestValid(empire_list[1]) then
				Story_Event("VICTORY_EMPIRE")
			end
			
			if TestValid(pirate_list[1]) then
				Story_Event("VICTORY_PIRATE")
			end
		end
	end
	
	if mission_started and not victory_triggered then
		objective_unit = Find_Hint("PIRATE_ASTEROID_NON_VICTORY", "spacebase")
		if TestValid(objective_unit) then
			if objective_unit.Get_Hull() < .90 then
				if not fighters_attack then
					ReinforceList(fighters_reinforce, fightersa, pirate, false, true, true, Find_And_Attack)
					ReinforceList(fighters_reinforce, fightersb, pirate, false, true, true, Find_And_Attack)
					--ReinforceList(fighters_reinforce, fightersc, pirate, false, true, true, Find_And_Attack)
					fighters_attack = true
				end
			end
			if objective_unit.Get_Hull() < .50 then
				if not kedalbe_attack then
					ReinforceList(kedalbe_reinforce, kedalbe, pirate, false, true, true, Kedalbe_Attack)
					kedalbe_attack = true
				end
			end
			if objective_unit.Get_Hull() < .10 then
				--objective_unit.Make_Invulnerable(true)
			end
		end
	end
end

function State_Mandalore_Piracy_Mission_Speech_Line_00_Remove_Text(message)
	if message == OnEnter then
				
		Story_Event("ADD_OBJECTIVE_00")
		objective_list = Find_All_Objects_With_Hint("objective")
		objective_unit = objective_list[1]
		
		if TestValid(objective_unit) then
			Add_Radar_Blip(objective_unit, "objective_blip")
			objective_unit.Highlight(true)
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
	Point_Camera_At(tyber)

	Transition_To_Tactical_Camera(6)
	Sleep(4)
	Letter_Box_Out(2)
	Sleep(2)
	Lock_Controls(0)
	End_Cinematic_Camera()
	
	Suspend_AI(0)
	empire_enemies = Find_All_Objects_Of_Type(empire)
	for k, unit in pairs(empire_enemies) do
		if TestValid(unit) then
			unit.Suspend_Locomotor(false)
		end
	end
	rebel_enemies = Find_All_Objects_Of_Type(rebel)
	for k, unit in pairs(rebel_enemies) do
		if TestValid(unit) then
			unit.Suspend_Locomotor(false)
		end
	end
	
	Story_Event("TEXT_SPEECH_UW_CLD_01")
end

function Find_And_Attack(attack_list)
	Create_Thread("Hunt_Underworld",attack_list)
end

function Kedalbe_Attack(attack_list)
	Story_Event("COMPLETE_OBJECTIVE_00")
	Story_Event("ADD_OBJECTIVE_02")
	Create_Thread("Hunt_Underworld",attack_list)
	Remove_Radar_Blip("objective_blip")
	objective_unit.Highlight(false)
	for k, unit in pairs(attack_list) do
		if TestValid(unit) then
			Add_Radar_Blip(unit, "objective_blip")
			unit.Highlight(true)
		end
	end
	Create_Thread("CheckKedalbe")
end

function CheckKedalbe()
	kedalbo = Find_First_Object("KELDALBE_PROTOTYPE")
	while true do
		if TestValid(kedalbo) then
			--do nothing
		else
			Story_Event("COMPLETE_OBJECTIVE_02")
			victory_triggered = true
		end
		Sleep(1)	
	end
end

function Hunt_Underworld(attack_list)
	local enemy_player = Find_Player("Underworld")
	while true do
	  if not VictoryStarted and not DefeatStarted then
		for k, unit in pairs(attack_list) do
			if TestValid(unit) then
				if not unit.Get_Owner().Is_Human() then
					local closest_enemy = Find_Nearest(unit, enemy_player, true)	
					unit.Attack_Move(closest_enemy)
				end
			end
		end
	  end
      Sleep(4)
	end
end

-- ************************************************************************
-- ***********************INTRO CINEMATIC FUNCTION*************************
-- ************************************************************************

function Intro_Cinematic ()	
	Suspend_AI(1)
	
	empire_enemies = Find_All_Objects_Of_Type(empire)
	for k, unit in pairs(empire_enemies) do
		if TestValid(unit) then
			unit.Suspend_Locomotor(true)
		end
	end
	rebel_enemies = Find_All_Objects_Of_Type(rebel)
	for k, unit in pairs(rebel_enemies) do
		if TestValid(unit) then
			unit.Suspend_Locomotor(true)
		end
	end
	
	Lock_Controls(1)
	Start_Cinematic_Camera()
	Letter_Box_In(0)	
	Fade_Screen_In(2)
	
	tyber = Find_First_Object("COR_TYBER_INTERCEPTOR")
	
	Transition_Cinematic_Camera_Key(tyber, 0, 750, 25, 45, 1, 1, 1, 0)
	Transition_Cinematic_Target_Key(tyber, 0, 0, 0, 7, 0, tyber, 0, 0)
	--Sleep(7)
	
	Transition_Cinematic_Camera_Key(tyber, 5, 750, 25, 135, 1, 1, 1, 0)
	
	Sleep(4.5)
	
	while camera_offset > 0 do
		camera_offset = camera_offset + 90
		Transition_Cinematic_Camera_Key(tyber, 5, 750, 25, camera_offset, 1, 1, 1, 0)
		
		if camera_offset == 315 then
			camera_offset = -45
		end
		
		Sleep(4.5)
	end
	
	current_cinematic_thread = nil
	Create_Thread("End_Camera")
end