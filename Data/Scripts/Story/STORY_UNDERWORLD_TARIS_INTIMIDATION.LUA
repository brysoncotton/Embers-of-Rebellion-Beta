-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Taris_Intimidation.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Taris_Intimidation.lua $
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
		Taris_Intimidation_Mission_Begin = State_Taris_Intimidation_Mission_Begin,
	}
	
	silri_spawnlist =
	{
		"Silri"
	}
end

function State_Taris_Intimidation_Mission_Begin(message)
	if message == OnEnter then
		Initialize_Mission()
		
		-- 9/19/06 JAC - We need this even if we're not doing a cinematic intro
		-- otherwise the Master Volume will be stuck at 0
		Start_Cinematic_Camera()
		End_Cinematic_Camera()		
		Letter_Box_Out(0)
		Fade_Screen_In(1)
		Lock_Controls(0)
		
		Story_Event("INTRO_SPEECH")

		-- current_cinematic_thread = Create_Thread("Intro_Cinematic")
	elseif message == OnUpdate then
		if not mission_success and not mission_failure then
			if silri_is_dead then
				mission_failure = true
				Story_Event("FAIL_OBJECTIVE_00")
				if empire_active then
					Story_Event("VICTORY_EMPIRE")
				else
					Story_Event("VICTORY_REBEL")
				end
			end
			if twitch_is_dead then
				mission_success = true
				Story_Event("COMPLETE_OBJECTIVE_00")
			end
		end
	end
end

function Initialize_Mission()
	mission_success = false
	mission_failure = false
	
	camera_offset = 135

	underworld_player = Find_Player("Underworld")
	rebel_player = Find_Player("Rebel")
	empire_player = Find_Player("Empire")
	empire_active = false
	rebel_active = false
	
	-- Set the air assault prox.
	
	air_attack_prox = Find_Hint("STORY_TRIGGER_ZONE", "prox-air")
	Register_Prox(air_attack_prox, Prox_Air_Attack, 250, underworld_player)
	
	-- Spawn Silri. Heroes starting on the map crashes the game.
	
	silri_start = Find_Hint("STORY_TRIGGER_ZONE", "silri-start")
	silri_list = SpawnList(silri_spawnlist, silri_start.Get_Position(), underworld_player, false, true)
	silri = silri_list[1]
	silri.Teleport_And_Face(silri_start)
	Point_Camera_At(silri)
	Register_Death_Event(silri, Silri_Destroyed)
	silri_is_dead = false
	
	-- Set death events for Twitch.
	
	twitch_rebel = Find_First_Object("TWITCH_REBEL")
	if TestValid(twitch_rebel) then
		Register_Death_Event(twitch_rebel, Twitch_Destroyed)
		twitch_rebel.Highlight(true)
		Add_Radar_Blip(twitch_rebel, "radar")		
		rebel_active = true
	end
	twitch_empire = Find_First_Object("TWITCH_EMPIRE")
	if TestValid(twitch_empire) then
		Register_Death_Event(twitch_empire, Twitch_Destroyed)
		twitch_empire.Highlight(true)
		Add_Radar_Blip(twitch_empire, "radar")		
		empire_active = true
	end
	twitch_is_dead = false

	-- Set the Rebel and Empire units to guard their location.
	
	empire_list = Find_All_Objects_Of_Type(empire_player)
	for i,unit in pairs(empire_list) do
		if unit.Is_Category("Infantry") or unit.Is_Category("Vehicle") or unit.Is_Category("Air") then
			if not TestValid(unit.Get_Parent_Object()) then
				unit.Prevent_AI_Usage(true)
				unit.Guard_Target(unit.Get_Position())
			end
		end
	end
	rebel_list = Find_All_Objects_Of_Type(rebel_player)
	for i,unit in pairs(rebel_list) do
		if unit.Is_Category("Infantry") or unit.Is_Category("Vehicle") or unit.Is_Category("Air") then
			if not TestValid(unit.Get_Parent_Object()) then
				unit.Prevent_AI_Usage(true)
				unit.Guard_Target(unit.Get_Position())
			end
		end
	end
	
	-- Deploy the Rebel guns if they exist.
	
	mptl_list = Find_All_Objects_Of_Type("MPTL")
	for i, unit in pairs (mptl_list) do
		if TestValid(unit) then
			unit.Activate_Ability("DEPLOY", true)
		end
	end
	
end

function Twitch_Destroyed()
	twitch_is_dead = true
end

function Silri_Destroyed()
	silri_is_dead = true
end

function Prox_Air_Attack(prox_obj, trigger_obj)
	prox_obj.Cancel_Event_Object_In_Range(Prox_Air_Attack)

	local snowspeeder_list = Find_All_Objects_Of_Type("SNOWSPEEDER")
	for i, unit in pairs (snowspeeder_list) do
		unit.Attack_Move(trigger_obj.Get_Position())
	end

	local lancet_list = Find_All_Objects_Of_Type("LANCET_AIR_ARTILLERY")
	for i, unit in pairs (lancet_list) do
		unit.Attack_Move(trigger_obj.Get_Position())
	end
end

-- function Story_Handle_Esc()
--	if current_cinematic_thread ~= nil then
--		Thread.Kill(current_cinematic_thread)
--		current_cinematic_thread = nil
--		Create_Thread("End_Camera")
--	end
-- end

function End_Camera()
	Transition_To_Tactical_Camera(6)
	Sleep(4)
	Letter_Box_Out(2)
	Sleep(2)
	Lock_Controls(0)
	End_Cinematic_Camera()
	
	Story_Event("INTRO_SPEECH")
end

-- ************************************************************************
-- ***********************INTRO CINEMATIC FUNCTION*************************
-- ************************************************************************

function Intro_Cinematic()
	
	Lock_Controls(1)
	Start_Cinematic_Camera()
	Letter_Box_In(0)	
	Fade_Screen_In(2)
		
	Transition_Cinematic_Camera_Key(silri, 0, 50, 25, 45, 1, 1, 1, 0)
	Transition_Cinematic_Target_Key(silri, 0, 0, 0, 7, 0, silri, 0, 0)
	--Sleep(7)
	
	Transition_Cinematic_Camera_Key(silri, 5, 50, 25, 135, 1, 1, 1, 0)
	
	Sleep(4.5)
	
	while true do
		camera_offset = camera_offset + 90
		Transition_Cinematic_Camera_Key(silri, 5, 50, 25, camera_offset, 1, 1, 1, 0)
		
		if camera_offset == 315 then
			Story_Handle_Esc()
		end
		
		Sleep(4.5)
	end
end