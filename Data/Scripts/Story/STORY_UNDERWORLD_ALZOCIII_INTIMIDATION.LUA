-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_AlzocIII_Intimidation.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_AlzocIII_Intimidation.lua $
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
		AlzocIII_Intimidation_Mission_Begin = State_AlzocIII_Intimidation_Mission_Begin,
		AlzocIII_Intimidation_ADD_OBJECTIVE_Deliver_The_Heads = State_AlzocIII_Intimidation_ADD_OBJECTIVE_Deliver_The_Heads,
		AlzocIII_Intimidation_FAIL_OBJECTIVE_Tyber_Must_Survive = State_AlzocIII_Intimidation_FAIL_OBJECTIVE_Tyber_Must_Survive,
	}
	
	underworld = Find_Player("Underworld")
	rebel = Find_Player("Rebel")
	empire = Find_Player("Empire")
	hutts = Find_Player("Hutts")
	hostile = Find_Player("Hostile")
	
	camera_offset = 135
	
	counter_shaak_heads_collected = 0
	
end

function State_AlzocIII_Intimidation_Mission_Begin(message)
	if message == OnEnter then
		Fade_Screen_Out(0)
		
		mission_started = true
		
		-- define mission hero here --
		hero = Find_First_Object("TYBER_ZANN")
		if not TestValid(hero) then	
			hero = Find_First_Object("URAI_FEN")
		end
		
		Create_Thread("Thread_DeathMonitor_Hero", hero)
		
		rebel_list = Find_All_Objects_Of_Type(rebel)
		empire_list = Find_All_Objects_Of_Type(empire)
		hutt_list = Find_All_Objects_Of_Type(hutts)
		
		--make shaaks neutral to map owner
		if TestValid(rebel_list[1]) then
			rebel.Make_Ally(hostile)
		end
		
		if TestValid(empire_list[1]) then
			empire.Make_Ally(hostile)
		end
		
		if TestValid(hutt_list[1]) then
			hutts.Make_Ally(hostile)
		end
		
		commissioner_list = Find_All_Objects_With_Hint("commissioner")
		commissioner = commissioner_list[1]
		
		if not TestValid(commissioner) then
			MessageBox("AlzocIII Intimidation mission cannot find the food commisioner...aborting...tell Joe G immediately!")
			ScriptExit()
		end
		
		commissioner.Set_Cannot_Be_Killed(true)
		commissioner.Prevent_Opportunity_Fire(true)
		
		--find all the "Prize" shaak
		shaak_list = Find_All_Objects_Of_Type("AlzocIII_Prize_Shaak")
		for i,shaak in pairs(shaak_list) do
			Create_Thread("Thread_DeathMonitor_Shaak", shaak)
			shaak.Prevent_Opportunity_Fire(true)
		end
		
		-- make only minor tweaks to the script below... --
		--current_cinematic_thread = Create_Thread("Intro_Cinematic")
		Create_Thread("End_Camera")

	end
end

function Thread_DeathMonitor_Shaak(local_shaak)
	local shaak_position = local_shaak.Get_Position()
	while TestValid(local_shaak) do
		Sleep(1)
		if TestValid(local_shaak) then
			shaak_position = local_shaak.Get_Position()
		end
		--shaak_position = local_shaak.Get_Position()
	end
	
	--MessageBox("shaak killed")
	--set prox events on all existing shaak heads ... cause its easier then determining any new ones :(
	--shaak_head = Find_All_Objects_Of_Type("AlzocIII_Prize_Shaak_Head")
	Sleep(2)
	shaak_head_list = Spawn_Unit(Find_Object_Type("AlzocIII_Prize_Shaak_Head"), shaak_position, hostile)
	shaak_head = shaak_head_list[1]
	if TestValid(shaak_head) then
		Register_Prox(shaak_head,PROX_Shaak_Head,25,underworld)
		shaak_head.Highlight(true)
	else
		MessageBox("spawning the shaak head failed!!")
	end

end

function Thread_DeathMonitor_Hero(local_hero)
	while TestValid(local_hero) do
		Sleep(3)
	end
	--hero klled end misisonin loss
	Story_Event("AlzocIII_Intimidation_Player_Loses_AI_NOTIFICATION")
end

function State_AlzocIII_Intimidation_FAIL_OBJECTIVE_Tyber_Must_Survive(message)
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




function PROX_Shaak_Head(prox_obj, trigger_obj)
	if trigger_obj.Get_Owner() == underworld then 
		prox_obj.Cancel_Event_Object_In_Range(PROX_Shaak_Head)
		--MessageBox("shaak head picked up")
		prox_obj.Despawn()
		counter_shaak_heads_collected = counter_shaak_heads_collected + 1
		if counter_shaak_heads_collected == 1 then
			Story_Event("UPDATE_OBJECTIVE_1_HEAD_COLLECTED")
		elseif counter_shaak_heads_collected == 2 then
			Story_Event("UPDATE_OBJECTIVE_2_HEADS_COLLECTED")
		elseif counter_shaak_heads_collected == 3 then
			Story_Event("UPDATE_OBJECTIVE_3_HEADS_COLLECTED")
		elseif counter_shaak_heads_collected == 4 then
			Story_Event("UPDATE_OBJECTIVE_4_HEADS_COLLECTED")
		elseif counter_shaak_heads_collected == 5 then
			Story_Event("UPDATE_OBJECTIVE_5_HEADS_COLLECTED")
		elseif counter_shaak_heads_collected == 6 then
			Story_Event("UPDATE_OBJECTIVE_6_HEADS_COLLECTED")
		elseif counter_shaak_heads_collected == 7 then
			Story_Event("UPDATE_OBJECTIVE_7_HEADS_COLLECTED")
		elseif counter_shaak_heads_collected == 8 then
			Story_Event("UPDATE_OBJECTIVE_8_HEADS_COLLECTED")
		elseif counter_shaak_heads_collected == 9 then
			Story_Event("UPDATE_OBJECTIVE_9_HEADS_COLLECTED")
		elseif counter_shaak_heads_collected == 10 then
			--collect heads objective complete...switch to delivery objective
			Story_Event("UPDATE_COMPLETE_ALL_HEADS_COLLECTED")
		end
	end
end



function State_AlzocIII_Intimidation_ADD_OBJECTIVE_Deliver_The_Heads(message)
	if message == OnEnter then
		--player just got the objective to deliver the heads to the food commisioner...ping him on the radar
		
		
		commissioner.Highlight(true)
		Add_Radar_Blip(commissioner, "blip_commissioner")
		
		Register_Prox(commissioner,PROX_Food_Commissioner,25,underworld)
	
	end
end

function PROX_Food_Commissioner(prox_obj, trigger_obj)
	if trigger_obj.Get_Type().Get_Name() == "TYBER_ZANN" then
		prox_obj.Cancel_Event_Object_In_Range(PROX_Food_Commissioner)
		
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
	
		Story_Event("AlzocIII_Intimidation_Player_Wins_AI_NOTIFICATION")
		--MessageBox("Story_Event(AlzocIII_Intimidation_Player_Wins_AI_NOTIFICATION)")
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
		MessageBox("AlzocIII intimidation cannot find any heroes...aborting mission")
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
	Story_Event("AlzocIII_Intimidation_Mission_Start_AI_NOTIFICATION")
end