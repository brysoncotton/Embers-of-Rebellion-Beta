-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_AetenII_Piracy.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_AetenII_Piracy.lua $
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
		AetenII_Piracy_Mission_Begin = State_AetenII_Piracy_Mission_Begin,
		AetenII_Piracy_FAIL_OBJECTIVE_Bossk_Must_Survive = State_AetenII_Piracy_FAIL_OBJECTIVE_Bossk_Must_Survive,

		
	}
	
	underworld = Find_Player("Underworld")
	rebel = Find_Player("Rebel")
	empire = Find_Player("Empire")
	hutts = Find_Player("Hutts")
	hostile = Find_Player("Hostile")
	
	camera_offset = 135
	
	counter_containers_destroyed = 0
	patrol_list = {}
	enemy_faction = nil
	
end

function State_AetenII_Piracy_Mission_Begin(message)
	if message == OnEnter then
		mission_started = true
		JoeMessage("#####################################Starting AetenII_Piracy mission")
		--MessageBox("#####################################Starting AetenII_Piracy mission")
		
		empire_unit_list = Find_All_Objects_Of_Type(empire)
		for i,empire_unit in pairs(empire_unit_list) do
			if TestValid(empire_unit) then
				empire_unit.Prevent_AI_Usage(true)
			end
		end
		
		rebel_unit_list = Find_All_Objects_Of_Type(rebel)
		for i,rebel_unit in pairs(rebel_unit_list) do
			if TestValid(rebel_unit) then
				rebel_unit.Prevent_AI_Usage(true)
			end
		end
		

		patrol_list = Find_All_Objects_With_Hint("pointguard")
		if patrol_list[1].Get_Owner() == empire then
			enemy_faction = empire
		else
			enemy_faction = rebel
		end
		
		--definitions for the patrol loop
		patrol_flag01 = Find_Hint("MARKER_GENERIC_RED", "patrol01")
		patrol_flag02 = Find_Hint("MARKER_GENERIC_RED", "patrol02")
		patrol_flag03 = Find_Hint("MARKER_GENERIC_RED", "patrol03")
		patrol_flag04 = Find_Hint("MARKER_GENERIC_RED", "patrol04")
		
		patrol_flag_list = Find_All_Objects_Of_Type("MARKER_GENERIC_RED")
		
		
		
		-- define mission hero here --
		hero = Find_First_Object("TYBER_ZANN")
		if not TestValid(hero) then	
			hero = Find_First_Object("URAI_FEN")
		end
		if not TestValid(hero) then	
			hero = Find_First_Object("HOUNDSTOOTH")
		end

		if not TestValid(hero) then
			MessageBox("AetenII_Piracy mission cannot find the hero...aborting...tell Joe G immediately!")
			ScriptExit()
		end
		
		Create_Thread("Thread_DeathMonitor_Hero", hero)
		
		container_list = Find_All_Objects_Of_Type("STYGIUM_CRYSTAL_STORAGE_CONTAINER")
		for i, container in pairs(container_list) do
			if TestValid(container) then
				Create_Thread("Thread_DeathMonitor_Container", container)
				Add_Radar_Blip(container, "somename")
				container.Prevent_Opportunity_Fire(true)
			end
		end
		
		
		
		-- make only minor tweaks to the script below... --
		--current_cinematic_thread = Create_Thread("Intro_Cinematic")
		Create_Thread("End_Camera")

	end
end

function Find_Nearest_Marker(unit)
	best_distance = 99999
	best_marker = patrol_flag_list[0]

	if TestValid(unit) then
		for j, patrol_flag in pairs(patrol_flag_list) do
			distance = patrol_flag.Get_Distance(unit)
			if distance < best_distance then
				best_marker = patrol_flag
				best_distance = distance
			end
		end
	end

	return best_marker
end

function PROX_AetenII_Piracy_Mission_Patrol_Loop(prox_obj, trigger_obj)
	if trigger_obj.Get_Owner() == enemy_faction then
		if prox_obj == patrol_flag01 then
			if trigger_obj.Has_Attack_Target() == true then
				target = trigger_obj.Get_Attack_Target()
				trigger_obj.Attack_Move(target.Get_Position())
			else
				trigger_obj.Attack_Move(patrol_flag02.Get_Position())
			end
			
			--return
		elseif prox_obj == patrol_flag02 then
			if trigger_obj.Has_Attack_Target() == true then
				target = trigger_obj.Get_Attack_Target()
				trigger_obj.Attack_Move(target.Get_Position())
			else
				trigger_obj.Attack_Move(patrol_flag03.Get_Position())
			end
		elseif prox_obj == patrol_flag03 then
			if trigger_obj.Has_Attack_Target() == true then
				target = trigger_obj.Get_Attack_Target()
				trigger_obj.Attack_Move(target.Get_Position())
			else
				trigger_obj.Attack_Move(patrol_flag04.Get_Position())
			end
		elseif prox_obj == patrol_flag04 then
			if trigger_obj.Has_Attack_Target() == true then
				target = trigger_obj.Get_Attack_Target()
				trigger_obj.Attack_Move(target.Get_Position())
			else
				trigger_obj.Attack_Move(patrol_flag01.Get_Position())
			end
		end
	end
end

function Thread_DeathMonitor_Hero(local_hero)
	while TestValid(local_hero) do
		Sleep(3)
	end
	--hero klled end misisonin loss
	Story_Event("AetenII_Piracy_Player_Loses_AI_NOTIFICATION")
end

function Thread_DeathMonitor_Container(local_container)
	while TestValid(local_container) do
		Sleep(3)
	end
	--space station is dead
	counter_containers_destroyed = counter_containers_destroyed + 1
	
	if counter_containers_destroyed == 1 then
		Story_Event("AetenII_Piracy_Notice_Container_Destroyed_AI_NOTIFICATION")
		Sleep(0.5)
		Story_Event("AetenII_Piracy_Update_Container_Objective_One_Destroyed_AI_NOTIFICATION")
	elseif counter_containers_destroyed == 2 then
		Story_Event("AetenII_Piracy_Notice_Container_Destroyed_AI_NOTIFICATION")
		Sleep(0.5)
		Story_Event("AetenII_Piracy_Update_Container_Objective_Two_Destroyed_AI_NOTIFICATION")
	elseif counter_containers_destroyed ==  3 then
		Story_Event("AetenII_Piracy_Notice_Container_Destroyed_AI_NOTIFICATION")
		Sleep(0.5)
		Story_Event("AetenII_Piracy_Update_Container_Objective_Three_Destroyed_AI_NOTIFICATION")
	elseif counter_containers_destroyed == 4 then
		Story_Event("AetenII_Piracy_Notice_Container_Destroyed_AI_NOTIFICATION")
		Sleep(0.5)
		Story_Event("AetenII_Piracy_Update_Container_Objective_Four_Destroyed_AI_NOTIFICATION")
	elseif counter_containers_destroyed == 5 then
		hero.Set_Cannot_Be_Killed(true) --safety
		Sleep(0.5)
		Story_Event("AetenII_Piracy_Player_Wins_AI_NOTIFICATION")
	end
end

function State_AetenII_Piracy_FAIL_OBJECTIVE_Bossk_Must_Survive(message)
	if message == OnEnter then
		--lose dialog is over..determine who actually won.
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


-- ************************************************************************
-- ***********************INTRO CINEMATIC FUNCTION*************************
-- ************************************************************************
-- make only minor tweaks to the script below... --
function Story_Handle_Esc()
	if current_cinematic_thread ~= nil then
		Thread.Kill(current_cinematic_thread)
		current_cinematic_thread = nil
		Create_Thread("End_Camera")
	end
end


function Intro_Cinematic ()	
	Suspend_AI(1)
	
	if not TestValid(hero) then	
		MessageBox("AetenII_Piracy cannot find any heroes...aborting mission")
		ScriptExit()
	end
	
	Point_Camera_At(hero)
	
	Lock_Controls(1)
	Start_Cinematic_Camera()
	Letter_Box_In(0)	
	Fade_Screen_In(2)
	
	Transition_Cinematic_Camera_Key(hero, 0, 400, 25, 45, 1, 1, 1, 0)
	Transition_Cinematic_Target_Key(hero, 0, 0, 0, 7, 0, urai, 0, 0)
	--Sleep(7)
	
	Transition_Cinematic_Camera_Key(hero, 5, 400, 25, 135, 1, 1, 1, 0)
	
	Sleep(4.5)
	
	while camera_offset > 0 do
		camera_offset = camera_offset + 90
		Transition_Cinematic_Camera_Key(hero, 5, 400, 25, camera_offset, 1, 1, 1, 0) -- (hero, 5, 50, 25, camera_offset, 1, 1, 1, 0)
		
		if camera_offset == 315 then
			camera_offset = -45
		end
		
		Sleep(4.5)
	end
	
	current_cinematic_thread = nil
	Create_Thread("End_Camera")
end

function End_Camera()
	Point_Camera_At(hero)
	
	-- 9/19/06 JAC - We need this even if we're not doing a cinematic intro
	-- otherwise the Master Volume will be stuck at 0
	Start_Cinematic_Camera()
	End_Cinematic_Camera()
	Letter_Box_Out(0) 
	
	Lock_Controls(0)
	Fade_Screen_In(1)
	Suspend_AI(0)
	
	Story_Event("AetenII_Piracy_Mission_Start_AI_NOTIFICATION")
	
	Sleep(5)
	
	for i, patrol_unit in pairs(patrol_list) do
		if TestValid(patrol_unit) then
			--Create_Thread("Thread_AetenII_Piracy_Mission_Patrol_Loop", patrol_unit)
			--my_closest_patrol_flag = Find_Nearest(patrol_unit, "MARKER_GENERIC_RED")
			--if not TestValid(my_closest_patrol_flag) then
			--	MessageBox("not TestValid(my_closest_patrol_flag) ")
			--end
			--patrol_unit.Attack_Move(my_closest_patrol_flag.Get_Position())
			
			start_point = Find_Nearest_Marker(patrol_unit)
			patrol_unit.Attack_Move(start_point.Get_Position())
			
		end
	end
	
	
	for i, patrol_flag in pairs(patrol_flag_list) do
		if TestValid(patrol_flag) then
			Register_Prox(patrol_flag, PROX_AetenII_Piracy_Mission_Patrol_Loop, 75, enemy_faction)
			
		end
	end
	
end


	



-- ##########################################################################################
function JoeMessage(...)
	--JoeMessage("current current_spawn_times  is %d", current_spawn_times)
	_CustomScriptMessage("JoeLog.txt", string.format(unpack(arg)))
end