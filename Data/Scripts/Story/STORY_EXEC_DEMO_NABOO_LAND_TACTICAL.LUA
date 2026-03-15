-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Exec_Demo_Naboo_Land_Tactical.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Exec_Demo_Naboo_Land_Tactical.lua $
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
		Underworld_Exec_Demo_1_Endor_Begin = State_Underworld_Exec_Demo_1_Endor_Begin
	}
	
	underworld = Find_Player("Underworld")
	rebel = Find_Player("Rebel")
	neutral = Find_Player("Neutral")
	
	mdu_deployed = false
	
	camera_offset = 135
	
	intro_state = 0
end

function State_Underworld_Exec_Demo_1_Endor_Begin(message)
	if message == OnEnter then
		--Turning off AI
		Suspend_AI(1)
		
		FogOfWar.Reveal_All(underworld)
		
		--Preventing T2Bs from moving
		t2b_group = Find_All_Objects_With_Hint("t2b")
        for k, unit in pairs(t2b_group) do
			if TestValid(unit) then
				unit.Prevent_AI_Usage(true)
				unit.Suspend_Locomotor(true)
			end
		end
		
		--Preventing MPTLs from moving
		mptl_group = Find_All_Objects_Of_Type("MPTL")
        for k, unit in pairs(mptl_group) do
			if TestValid(unit) then
				unit.Activate_Ability("DEPLOY", true)
				unit.Prevent_Opportunity_Fire(true)
				unit.Prevent_AI_Usage(true)
				unit.Suspend_Locomotor(true)
			end
		end
				
		sab_prox = Find_Hint("STORY_TRIGGER_ZONE_00", "sabprox")
		Register_Prox(sab_prox, PROX_Saboteur, 100, underworld)
		
		--Spawning in all Underworld units
		
		--Spawning in cinematic ewok handler
		cine_handler_loc = Find_Hint("STORY_TRIGGER_ZONE_00", "handler0")
		cine_handler = Spawn_Unit(Find_Object_Type("EWOK_HANDLER"), cine_handler_loc, underworld)
		cine_handler[1].Teleport_And_Face(cine_handler_loc)
		
		--Spawning in 3 other handlers
		handler_spawn_list = Find_All_Objects_With_Hint("handler")
		for k, loc in pairs(handler_spawn_list) do
			if TestValid(loc) then
				handler = Spawn_Unit(Find_Object_Type("EWOK_HANDLER"), loc, underworld)
				handler[1].Teleport_And_Face(loc)
			end
		end
		
		--Spawning in 5 saboteurs
		sab_spawn_list = Find_All_Objects_With_Hint("saboteur")
		for k, loc in pairs(sab_spawn_list) do
			if TestValid(loc) then
				saboteur = Spawn_Unit(Find_Object_Type("UNDERWORLD_SABOTEUR"), loc, underworld)
				saboteur[1].Teleport_And_Face(loc)
			end
		end
		
		--Spawning in 2 groups of underworld mercs
		merc_spawn_list = Find_All_Objects_With_Hint("merc")
		for k, loc in pairs(merc_spawn_list) do
			if TestValid(loc) then
				Spawn_Unit(Find_Object_Type("UNDERWORLD_MERC_SQUAD"), loc, underworld)
			end
		end
		
		--Spawning in 2 groups of underworld disruptors
		disruptor_spawn_list = Find_All_Objects_With_Hint("disruptor")
		for k, loc in pairs(disruptor_spawn_list) do
			if TestValid(loc) then
				Spawn_Unit(Find_Object_Type("UNDERWORLD_DISRUPTOR_MERC_SQUAD"), loc, underworld)
			end
		end
		
		--Spawning in IG-88
		ig88_loc = Find_All_Objects_With_Hint("ig88")
		for k, loc in pairs(ig88_loc) do
			if TestValid(loc) then
				ig88 = Spawn_Unit(Find_Object_Type("IG-88"), loc, underworld)
				ig88[1].Teleport_And_Face(loc)
			end
		end
		
		--Spawning in Tyber Zann
		tyber_loc = Find_All_Objects_With_Hint("tyberloc")
		for k, loc in pairs(tyber_loc) do
			if TestValid(loc) then
				tyber = Spawn_Unit(Find_Object_Type("TYBER_ZANN"), loc, underworld)
				tyber[1].Teleport_And_Face(loc)
			end
		end
		
		--Spawning in Underworld Mobile Defense Unit
		mdu_loc = Find_All_Objects_With_Hint("mduloc")
		for k, loc in pairs(mdu_loc) do
			if TestValid(loc) then
				mdu = Spawn_Unit(Find_Object_Type("UNDERWORLD_MOBILE_DEFENSE_UNIT"), loc, underworld)
				mdu[1].Turn_To_Face(sab_prox)
			end
		end
		
		--Spawning in Underworld Transport
		transport_loc = Find_All_Objects_With_Hint("transport")
		for k, loc in pairs(transport_loc) do
			if TestValid(loc) then
				transport = Spawn_Unit(Find_Object_Type("F9TZ_CLOAKING_TRANSPORT"), loc, underworld)
				transport[1].Teleport_And_Face(loc)
			end
		end
		
		current_cinematic_thread = Create_Thread("Intro_Cinematic")
		
	end
end

function Story_Mode_Service()
	if not mdu_deployed then
		mdu_list = Find_All_Objects_Of_Type("UNDERWORLD_MOBILE_DEFENSE_UNIT")
		if TestValid(mdu_list[1]) then
			if mdu_list[1].Is_Ability_Active("DEPLOY") then
				--MessageBox("MDU 1 Deployed!  Sending Speeders!")
				mdu_deployed = true
				Create_Thread("Send_Speeders", mdu_list[1])
			end
		end
		if TestValid(mdu_list[2]) then
			if mdu_list[2].Is_Ability_Active("DEPLOY") then
				--MessageBox("MDU 2 Deployed!  Sending Speeders!")
				mdu_deployed = true
				Create_Thread("Send_Speeders", mdu_list[2])
			end
		end
	end
end

function Send_Speeders(target)
	Sleep(10)
	
	speeder_list = Find_All_Objects_Of_Type("SNOWSPEEDER")
	
	for k, unit in pairs(speeder_list) do
		if TestValid(unit) then
			unit.Attack_Move(target)
		end
	end
end

function PROX_Saboteur(prox_obj, trigger_obj)
	if trigger_obj.Get_Type().Get_Name() == "UNDERWORLD_SABOTEUR" then
		--MessageBox("Prox Tripped, Sending T2Bs!")
        prox_obj.Cancel_Event_Object_In_Range(PROX_Saboteur)
        
        t2b_goto = Find_Hint("STORY_TRIGGER_ZONE_00", "t2bgoto")
        t2b_group = Find_All_Objects_With_Hint("t2b")
        for k, unit in pairs(t2b_group) do
			if TestValid(unit) then
				unit.Suspend_Locomotor(false)
				unit.Move_To(t2b_goto)
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
	if intro_state == 1 then
		Transition_To_Tactical_Camera(6)
		Sleep(4)
		Letter_Box_Out(2)
		Sleep(2)
		Lock_Controls(0)
		End_Cinematic_Camera()
	end
	
	if intro_state == 0 then
		intro_state = 1
		current_cinematic_thread = Create_Thread("Intro_Cinematic_Part2")
	end
end



-- ************************************************************************
-- ***********************INTRO CINEMATIC FUNCTION*************************
-- ************************************************************************

function Intro_Cinematic ()	
	
	Lock_Controls(1)
	Start_Cinematic_Camera()
	Letter_Box_In(0)	
	Fade_Screen_In(2)
	
	Transition_Cinematic_Camera_Key(cine_handler[1], 0, 50, 25, 45, 1, 1, 1, 0)
	Transition_Cinematic_Target_Key(cine_handler[1], 0, 0, 0, 0, 0, cine_handler[1], 0, 0)
	--Sleep(7)
	
	Transition_Cinematic_Camera_Key(cine_handler[1], 5, 50, 25, 135, 1, 1, 1, 0)
	
	Sleep(4.5)
	
	while true do
		camera_offset = camera_offset + 90
		Transition_Cinematic_Camera_Key(cine_handler[1], 5, 50, 25, camera_offset, 1, 1, 1, 0)
		
		if camera_offset == 315 then
			camera_offset = -45
		end
		
		Sleep(4.5)
	end
end

function Intro_Cinematic_Part2()
	if TestValid(cine_handler[1]) then
		Transition_Cinematic_Camera_Key(cine_handler[1], 5, 50, 18, 180, 1, cine_handler[1], 1, 0)
		Transition_Cinematic_Target_Key(cine_handler[1], 5, 0, 0, 0, 0, cine_handler[1], 0, 0)
		Sleep(4)
		ewok_target = Find_Hint("MPTL", "ewoktarget")
		cine_handler[1].Attack_Move(ewok_target)
		
		Transition_Cinematic_Camera_Key(cine_handler[1], 6, 50, 10, 110, 1, cine_handler[1], 1, 0)
		
		Sleep(7)
		Transition_Cinematic_Camera_Key(cine_handler[1], 6, 40, 10, 145, 1, cine_handler[1], 1, 0)
		Sleep(4)
		Transition_Cinematic_Target_Key(cine_handler[1], 3, -20, 0, 5, 0, cine_handler[1], 0, 0)
		
		
		
	end
end
