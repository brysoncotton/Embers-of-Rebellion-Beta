-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Byss_Kidnapping.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Byss_Kidnapping.lua $
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
		Byss_Kidnapping_Mission_Begin = State_Byss_Kidnapping_Mission_Begin,
	}
	
	silri_spawnlist =
	{
		"Silri"
	}
end

function State_Byss_Kidnapping_Mission_Begin(message)
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
--		current_cinematic_thread = Create_Thread("Intro_Cinematic")
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
			if kirith_is_caught then
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
	neutral_player = Find_Player("Neutral")
	empire_active = false
	rebel_active = false
		
	-- Spawn Silri. Heroes starting on the map crashes the game.
	
	silri_start = Find_Hint("STORY_TRIGGER_ZONE", "silristart")
	silri_list = SpawnList(silri_spawnlist, silri_start.Get_Position(), underworld_player, false, true)
	silri = silri_list[1]
	silri.Teleport_And_Face(silri_start)
	Point_Camera_At(silri)
	Register_Death_Event(silri, Silri_Destroyed)
	silri_is_dead = false
	
	-- Set death events for kirith.
	
	kirith_rebel = Find_First_Object("GOVERNOR_KIRITH_REBEL")
	if TestValid(kirith_rebel) then
		kirith_rebel.Change_Owner(neutral_player)
		kirith_rebel.Make_Invulnerable(true)
		kirith_rebel.Highlight(true)
		Add_Radar_Blip(kirith_rebel, "radar")		
		rebel_active = true
	end
	kirith_empire = Find_First_Object("GOVERNOR_KIRITH_EMPIRE")
	if TestValid(kirith_empire) then
		kirith_empire.Change_Owner(neutral_player)
		kirith_empire.Make_Invulnerable(true)
		kirith_empire.Highlight(true)
		Add_Radar_Blip(kirith_empire, "radar")		
		empire_active = true
	end
	kirith_is_caught = false

	-- Set the Rebel and Empire units to guard their location.
	
	empire_list = Find_All_Objects_Of_Type(empire_player)
	for i,unit in pairs(empire_list) do
		if unit.Is_Category("Infantry") or unit.Is_Category("Vehicle") or unit.Is_Category("Air") or unit.Is_Category("LandHero") then
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
	
	-- Establish the kidnapping prox.

	kidnap_prox = Find_Hint("STORY_TRIGGER_ZONE", "kidnapflag")
	Register_Prox(kidnap_prox, Prox_Kidnapping, 100, underworld_player)
	
	-- Establish the retaliation prox.
	
	retaliation_prox = Find_Hint("STORY_TRIGGER_ZONE", "assaultprox")
	Register_Prox(retaliation_prox, Prox_Assault, 250, underworld_player)	

	-- Find and destroy the inappropriate spawn houses. Set destruction triggers on the other ones.
	
	temperate_rebel_list = Find_All_Objects_Of_Type("TEMPERATE_CIVILIAN_SPAWN_HOUSE_REBEL")
	temperate_empire_list = Find_All_Objects_Of_Type("TEMPERATE_CIVILIAN_SPAWN_HOUSE_EMPIRE")
	swamp_rebel_list = Find_All_Objects_Of_Type("SWAMP_CIVILIAN_SPAWN_HOUSE_REBEL")
	swamp_empire_list = Find_All_Objects_Of_Type("SWAMP_CIVILIAN_SPAWN_HOUSE_EMPIRE")
	
	if empire_active then
		for i,unit in pairs (temperate_rebel_list) do
			if TestValid(unit) then
				unit.Despawn()
			end
		end
		for i,unit in pairs (swamp_rebel_list) do
			if TestValid(unit) then
				unit.Despawn()
			end
		end
	else
		for i,unit in pairs (temperate_empire_list) do
			if TestValid(unit) then
				unit.Despawn()
			end
		end
		for i,unit in pairs (swamp_empire_list) do
			if TestValid(unit) then
				unit.Despawn()
			end
		end
	end
	
end

function Prox_Assault(prox_obj, trigger_obj)
	prox_obj.Cancel_Event_Object_In_Range(Prox_Assault)
	if not mission_success and not mission_failure then
		if empire_active then
			assault_list = Find_All_Objects_Of_Type("UM05_ADEPTGENERIC")
		else
			assault_list = Find_All_Objects_Of_Type("REBEL_INFILTRATOR")
		end
		for i,unit in pairs(assault_list) do
			if TestValid(unit) then
				unit.Attack_Move(silri.Get_Position())
			end
		end
	end
end

function Prox_Kidnapping(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj == silri then
	 		prox_obj.Cancel_Event_Object_In_Range(Prox_Kidnapping)
			Remove_Radar_Blip("radar")
			Add_Radar_Blip(silri_start,"radar2")
			Register_Prox(silri_start, Prox_Escape, 250, neutral_player)
			Story_Event("RETURN_TO_SHUTTLE")
			if empire_active then
				Register_Timer(Timer_Kidnap_Move_Empire,2)
			else
				Register_Timer(Timer_Kidnap_Move_Rebel,2)
			end
		end
	end
end

function Timer_Kidnap_Move_Empire()
	if not mission_success and not mission_failure then
		kirith_empire.Move_To(silri.Get_Position())
		Register_Timer(Timer_Kidnap_Move_Empire,2)
	end
end

function Timer_Kidnap_Move_Rebel()
	if not mission_success and not mission_failure then
		kirith_rebel.Move_To(silri.Get_Position())
		Register_Timer(Timer_Kidnap_Move_Rebel,2)
	end
end

function Prox_Escape(prox_obj, trigger_obj)
	prox_obj.Cancel_Event_Object_In_Range(Prox_Escape)
	Remove_Radar_Blip("radar2")
	if not mission_success and not mission_failure then
		kirith_is_caught = true
	end
end

function Silri_Destroyed()
	silri_is_dead = true
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