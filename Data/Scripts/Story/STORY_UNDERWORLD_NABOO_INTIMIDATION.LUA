-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Naboo_Intimidation.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Naboo_Intimidation.lua $
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
		Naboo_Intimidation_Mission_Begin = State_Naboo_Intimidation_Mission_Begin,
	}
	
	silri_spawnlist =
	{
		"Silri"
	}
	
	night_sister_spawnlist =
	{
		"NIGHT_SISTER"
	}
end

function State_Naboo_Intimidation_Mission_Begin(message)
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
			if arnama_is_dead then
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
	
	-- Spawn Silri. Heroes starting on the map crashes the game.
	
	silri_start = Find_Hint("STORY_TRIGGER_ZONE", "silristart")
	silri_list = SpawnList(silri_spawnlist, silri_start.Get_Position(), underworld_player, false, true)
	silri = silri_list[1]
	silri.Teleport_And_Face(silri_start)
	Point_Camera_At(silri)
	Register_Death_Event(silri, Silri_Destroyed)
	silri_is_dead = false
	
	-- Spawn the Night Sister. These also crash the game.
	
	night_sister_start = Find_Hint("STORY_TRIGGER_ZONE", "nightsister")
	night_sister_list = SpawnList(night_sister_spawnlist, night_sister_start.Get_Position(), underworld_player, false, true)
	night_sister = night_sister_list[1]
	night_sister.Teleport_And_Face(night_sister_start)
	
	-- Set death events for arnama.
	
	arnama_rebel = Find_First_Object("CHAIRMAN_ARNAMA_REBEL")
	if TestValid(arnama_rebel) then
		Register_Death_Event(arnama_rebel, arnama_Destroyed)
		arnama_rebel.Highlight(true)
		Add_Radar_Blip(arnama_rebel, "radar")		
		rebel_active = true
	else
		arnama_empire = Find_First_Object("CHAIRMAN_ARNAMA_EMPIRE")
		if TestValid(arnama_empire) then
			Register_Death_Event(arnama_empire, arnama_Destroyed)
			arnama_empire.Highlight(true)
			Add_Radar_Blip(arnama_empire, "radar")		
			empire_active = true
		end
	end
	arnama_is_dead = false

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
	
	-- Deploy the Rebel and Empire guns if they exist.
	
	mptl_list = Find_All_Objects_Of_Type("MPTL")
	for i, unit in pairs (mptl_list) do
		if TestValid(unit) then
			unit.Activate_Ability("DEPLOY", true)
		end
	end
	spmat_list = Find_All_Objects_Of_Type("SPMAT_WALKER")
	for i, unit in pairs (spmat_list) do
		if TestValid(unit) then
			unit.Activate_Ability("DEPLOY", true)
		end
	end

	-- Register the prox for approaching the base area.
	
	guard_1 = Find_Hint("STORY_TRIGGER_ZONE", "guard1")
	guard_2 = Find_Hint("STORY_TRIGGER_ZONE", "guard2")
	guard_3 = Find_Hint("STORY_TRIGGER_ZONE", "guard3")
	guard_4 = Find_Hint("STORY_TRIGGER_ZONE", "guard4")
	troop_1_list = Find_All_Objects_With_Hint("troop1")
	troop_1 = troop_1_list[1]
	troop_2_list = Find_All_Objects_With_Hint("troop2")
	troop_2 = troop_2_list[1]
	troop_3_list = Find_All_Objects_With_Hint("troop3")
	troop_3 = troop_3_list[1]
	troop_4_list = Find_All_Objects_With_Hint("troop4")
	troop_4 = troop_4_list[1]
	
	rebel_guards = Find_All_Objects_With_Hint("rebelguard")
	
	baseprox = Find_Hint("STORY_TRIGGER_ZONE", "baseprox")
	gateprox = Find_Hint("STORY_TRIGGER_ZONE", "gateprox")
	
	Register_Prox(baseprox, Prox_Approach_Base, 600, underworld_player)
	Register_Prox(gateprox, Prox_Approach_Gates, 600, underworld_player)
	
end

function Prox_Approach_Gates(prox_obj, trigger_obj)
	prox_obj.Cancel_Event_Object_In_Range(Prox_Approach_Gates)
	Register_Timer(Timer_Alarm,2)	
end

function Timer_Alarm()
	gateprox.Play_SFX_Event("SFX_UMP_EmpireKesselAlarm")
	Register_Timer(Timer_Alarm,2)
end

function Prox_Approach_Base(prox_obj, trigger_obj)
	prox_obj.Cancel_Event_Object_In_Range(Prox_Approach_Base)
	if empire_active then
		troop_1.Attack_Move(guard_1.Get_Position())
		troop_2.Attack_Move(guard_2.Get_Position())
		troop_3.Attack_Move(guard_3.Get_Position())
		troop_4.Attack_Move(guard_4.Get_Position())
	else
		for i,unit in pairs(rebel_guards) do
			unit.Attack_Move(arnama_rebel.Get_Position())
		end
	end
	fog_id = FogOfWar.Reveal(underworld_player, prox_obj, 400, 400)	
end

function arnama_Destroyed()
	arnama_is_dead = true
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