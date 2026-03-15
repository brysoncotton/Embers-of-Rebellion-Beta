-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Dantooine_Intimidation.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Dantooine_Intimidation.lua $
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
		Dantooine_Intimidation_Mission_Begin = State_Dantooine_Intimidation_Mission_Begin,
	}
	
	urai_spawnlist =
	{
		"URAI_FEN"
	}
end

function State_Dantooine_Intimidation_Mission_Begin(message)
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
			if urai_is_dead then
				mission_failure = true
				Story_Event("FAIL_OBJECTIVE_00")
				if empire_active then
					Story_Event("VICTORY_EMPIRE")
				else
					Story_Event("VICTORY_REBEL")
				end
			end
			if houses_left == 0 then
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
		
	-- Spawn urai. Heroes starting on the map crashes the game.
	
	urai_start = Find_Hint("STORY_TRIGGER_ZONE", "uraispawn")
	urai_list = SpawnList(urai_spawnlist, urai_start.Get_Position(), underworld_player, false, true)
	urai = urai_list[1]
	urai.Teleport_And_Face(urai_start)
	Point_Camera_At(urai)
	Register_Death_Event(urai, urai_Destroyed)
	urai_is_dead = false
	
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
			rebel_active = true
		end
	end
	if not rebel_active then
		empire_active = true
	end
	
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
		for i,unit in pairs (temperate_empire_list) do
			if TestValid(unit) then
				Register_Death_Event(unit, House_Destroyed)
			end
		end
		for i,unit in pairs (swamp_empire_list) do
			if TestValid(unit) then
				Register_Death_Event(unit, House_Destroyed)
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
		for i,unit in pairs (temperate_rebel_list) do
			if TestValid(unit) then
				Register_Death_Event(unit, House_Destroyed)
			end
		end
		for i,unit in pairs (swamp_rebel_list) do
			if TestValid(unit) then
				Register_Death_Event(unit, House_Destroyed)
			end
		end
	end
	
	houses_left = 10
	
end

function House_Destroyed()
	houses_left = houses_left - 1
end

function urai_Destroyed()
	urai_is_dead = true
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
		
	Transition_Cinematic_Camera_Key(urai, 0, 50, 25, 45, 1, 1, 1, 0)
	Transition_Cinematic_Target_Key(urai, 0, 0, 0, 7, 0, urai, 0, 0)
	--Sleep(7)
	
	Transition_Cinematic_Camera_Key(urai, 5, 50, 25, 135, 1, 1, 1, 0)
	
	Sleep(4.5)
	
	while true do
		camera_offset = camera_offset + 90
		Transition_Cinematic_Camera_Key(urai, 5, 50, 25, camera_offset, 1, 1, 1, 0)
		
		if camera_offset == 315 then
			Story_Handle_Esc()
		end
		
		Sleep(4.5)
	end
end