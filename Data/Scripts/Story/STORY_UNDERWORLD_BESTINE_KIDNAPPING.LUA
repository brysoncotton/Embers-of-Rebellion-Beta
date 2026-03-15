-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Bestine_Kidnapping.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Bestine_Kidnapping.lua $
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
		Bestine_Kidnapping_Mission_Begin = State_Bestine_Kidnapping_Mission_Begin,
		Bestine_Kidnapping_FAIL_OBJECTIVE_IG88_Must_Survive = State_Bestine_Kidnapping_FAIL_OBJECTIVE_IG88_Must_Survive,
		Bestine_Kidnapping_ADD_OBJECTIVE_MoveTo_Ral_Falan = State_Bestine_Kidnapping_ADD_OBJECTIVE_MoveTo_Ral_Falan,
		
	}
	
	underworld = Find_Player("Underworld")
	rebel = Find_Player("Rebel")
	empire = Find_Player("Empire")
	hutts = Find_Player("Hutts")
	hostile = Find_Player("Hostile")
	neutral = Find_Player("Neutral")
	
	camera_offset = 135
	
	ral_falan_reveal = nil
	flag_RalFalan_following = false
	
	flag_compound_clear = false
	flag_turbolaser_clear = false

end

function State_Bestine_Kidnapping_Mission_Begin(message)
	if message == OnEnter then
		mission_started = true
		JoeMessage("#####################################Starting BESTINE KIDNAPPING mission")
		--MessageBox("#####################################Starting BESTINE KIDNAPPING mission")
		
		-- define mission hero here --
		hero = Find_First_Object("TYBER_ZANN")
		if not TestValid(hero) then	
			hero = Find_First_Object("URAI_FEN")
		end
		if not TestValid(hero) then	
			hero = Find_First_Object("IG-88")
		end

		
		if not TestValid(hero) then
			MessageBox("BESTINE KIDNAPPING mission cannot find the hero...aborting...tell Joe G immediately!")
			ScriptExit()
		end
		
		Create_Thread("Thread_DeathMonitor_Hero", hero)
		
		rebel_list = Find_All_Objects_Of_Type(rebel)
		empire_list = Find_All_Objects_Of_Type(empire)
		hutt_list = Find_All_Objects_Of_Type(hutts)
		

		
		ral_falan_list = Find_All_Objects_With_Hint("ral")
		ral_falan = ral_falan_list[1]
		
		
		if not TestValid(ral_falan) then
			MessageBox("BESTINE KIDNAPPING mission cannot find the ral_falan...aborting...tell Joe G immediately!")
			ScriptExit()
		end
		
		--defending_faction = garnak_fey.Get_Owner()
		--Create_Thread("Thread_Cleanup_Faction_Stuff", defending_faction)
		
		ral_falan.Set_Cannot_Be_Killed(true)
		ral_falan.Prevent_Opportunity_Fire(true)
		ral_falan.Suspend_Locomotor(true)
		Add_Radar_Blip(ral_falan, "ral_falan_blip")
		

		
		turbolaser_list = Find_All_Objects_With_Hint("turbolaser")
		turbolaser = turbolaser_list[1]
		
		power_list = Find_All_Objects_With_Hint("power")
		power = power_list[1]
		
		
		Create_Thread("Thread_DeathMonitor_Tubolaser_Tower")
		
		
		
		pointguards_list = Find_All_Objects_With_Hint("pointguard")
		for i,unit in pairs(pointguards_list) do
			if TestValid(unit) then
				
				unit.Guard_Target(unit.Get_Position())
				unit.Prevent_AI_Usage(true)
			end
		end
		
		compound_guard_list = Find_All_Objects_With_Hint("compound")
		for i,unit in pairs(compound_guard_list) do
			if TestValid(unit) then
				unit.Guard_Target(unit.Get_Position())
				unit.Prevent_AI_Usage(true)
			end
		end
		
		Create_Thread("Thread_DeathMonitor_Compound_Guards")
		
		
		-- make only minor tweaks to the script below... --
		--current_cinematic_thread = Create_Thread("Intro_Cinematic")
		
		Create_Thread("End_Camera")

	end
end




function Thread_DeathMonitor_Compound_Guards()
	while (true) do
		
		flag_compound_clear = true
		for i,unit in pairs(compound_guard_list) do
			if TestValid(unit) then
				flag_compound_clear = false
			end
		end
		
		if flag_compound_clear == true then
			--MessageBox("flag_compound_clear = true")
			--compound is clear, complete the objective
			--Story_Event("Bestine_Kidnapping_Compound_Clear_AI_NOTIFICATION")
			break -- breaks out of this loop to start monitoring power/turbo status
		end
		
		Sleep(5)
	end
	
	while (true) do
		
		if flag_compound_clear == true and flag_turbolaser_clear == true then
			--compound is clear, complete the objective
			Story_Event("Bestine_Kidnapping_Compound_Clear_AI_NOTIFICATION")
			break
		end
		
		Sleep(5)
	end
end
function Thread_DeathMonitor_Tubolaser_Tower()
	
	while TestValid(turbolaser) and TestValid(power) do
		Sleep(5)
	end
	
	--MessageBox("flag_turbolaser_clear = true")
	flag_turbolaser_clear = true
	

end




function Thread_DeathMonitor_Hero(local_hero)
	while TestValid(local_hero) do
		Sleep(3)
	end
	--hero klled end misisonin loss
	Story_Event("Bestine_Kidnapping_Player_Loses_AI_NOTIFICATION")
end

function State_Bestine_Kidnapping_FAIL_OBJECTIVE_IG88_Must_Survive(message)
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



function State_Bestine_Kidnapping_ADD_OBJECTIVE_MoveTo_Ral_Falan(message)
	if message == OnEnter then
		--callback from xml...player just got objective to capture ral_falan with ig-88...set up prox event here.
		if TestValid(ral_falan) then
			Register_Prox(ral_falan,PROX_Ral_Falan,25,underworld)
			ral_falan.Highlight(true)
			ral_falan_reveal = FogOfWar.Reveal(underworld, ral_falan, 100, 100)
		else
			MessageBox("Bestine_Kidnapping cannot find ral_falan to set up prox event...aborting!!  Tell Joe G immediately!")
		end
	end
end




--change this to prox on garnak fey
function PROX_Ral_Falan(prox_obj, trigger_obj)
	if trigger_obj.Get_Type().Get_Name() == "IG-88" then
		prox_obj.Cancel_Event_Object_In_Range(PROX_Ral_Falan)
		
			
		flag_RalFalan_following = true
		Create_Thread("THREAD_Ral_Falan")
		
	
		
	end
end

function THREAD_Ral_Falan ()
		landing_shuttle = Find_First_Object("UNDERWORLD_HERO_SHUTTLE_LANDING")
		Register_Prox(landing_shuttle,PROX_Return_To_Shuttle,50,underworld)
		
		Story_Event("Bestine_Kidnapping_IG88_Reaches_RalFalan_AI_NOTIFICATION")
		ral_falan.Highlight(false)
		landing_shuttle.Highlight(true)
		Remove_Radar_Blip("ral_falan_blip")
		Add_Radar_Blip(landing_shuttle, "landing_shuttle_blip")
		ral_falan.Suspend_Locomotor(false)
		
		ral_falan.Change_Owner(neutral)
		
		rebel_list = Find_All_Objects_Of_Type(rebel)
		for i,unit in pairs(rebel_list) do
			if TestValid(unit) then
				unit.Prevent_AI_Usage(false)
			end
		end
		
		empire_list = Find_All_Objects_Of_Type(empire)
		for i,unit in pairs(empire_list) do
			if TestValid(unit) then
				unit.Prevent_AI_Usage(false)
			end
		end
		
end

function Story_Mode_Service()
	if not flag_RalFalan_following == true then
		return
	end
	
	if TestValid(ral_falan) and TestValid(hero) then
		ral_falan.Move_To(hero)
	end
end

--change this to prox on shuttle
function PROX_Return_To_Shuttle(prox_obj, trigger_obj)
	if trigger_obj.Get_Type().Get_Name() == "IG-88" then
		MessageBox("IG88 and friend reach shuttle ... mission over")
		prox_obj.Cancel_Event_Object_In_Range(PROX_Return_To_Shuttle)
		
			rebel_list = Find_All_Objects_Of_Type(rebel)
			empire_list = Find_All_Objects_Of_Type(empire)
			hutt_list = Find_All_Objects_Of_Type(hutts)
			
			--make shaaks neutral to map owner
			if TestValid(rebel_list[1]) then
				rebel.Make_Ally(underworld)
				underworld.Make_Ally(rebel)
			end
			
			if TestValid(empire_list[1]) then
				empire.Make_Ally(underworld)
				underworld.Make_Ally(empire)
			end
			
			if TestValid(hutt_list[1]) then
				hutts.Make_Ally(underworld)
				underworld.Make_Ally(hutts)
			end
			
			Suspend_AI(1)
			Lock_Controls(1)
	
		Story_Event("Bestine_Kidnapping_Player_Wins_AI_NOTIFICATION")
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
		MessageBox("Bestine_Kidnapping cannot find any heroes...aborting mission")
		ScriptExit()
	end
	
	Point_Camera_At(hero)
	
	
	
	Lock_Controls(1)
	Start_Cinematic_Camera()
	Letter_Box_In(0)	
	Fade_Screen_In(2)
	
	Transition_Cinematic_Camera_Key(hero, 0, 50, 25, 45, 1, 1, 1, 0)
	Transition_Cinematic_Target_Key(hero, 0, 0, 0, 7, 0, urai, 0, 0)
	--Sleep(7)
	
	Transition_Cinematic_Camera_Key(hero, 5, 50, 25, 135, 1, 1, 1, 0)
	
	Sleep(4.5)
	
	while camera_offset > 0 do
		camera_offset = camera_offset + 90
		Transition_Cinematic_Camera_Key(hero, 5, 50, 25, camera_offset, 1, 1, 1, 0)
		
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
	Story_Event("Bestine_Kidnapping_Mission_Start_AI_NOTIFICATION")
end

-- ##########################################################################################
function JoeMessage(...)
	--JoeMessage("current current_spawn_times  is %d", current_spawn_times)
	_CustomScriptMessage("JoeLog.txt", string.format(unpack(arg)))
end