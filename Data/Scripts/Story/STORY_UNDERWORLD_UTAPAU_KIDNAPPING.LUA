-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Utapau_Kidnapping.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Utapau_Kidnapping.lua $
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
		Utapau_Kidnapping_Mission_Begin = State_Utapau_Kidnapping_Mission_Begin,
		Utapau_Kidnapping_FAIL_OBJECTIVE_Silri_Must_Survive = State_Utapau_Kidnapping_FAIL_OBJECTIVE_Silri_Must_Survive,
		Utapau_Kidnapping_ADD_OBJECTIVE_Capture_Garnak = State_Utapau_Kidnapping_ADD_OBJECTIVE_Capture_Garnak,
		
	}
	
	underworld = Find_Player("Underworld")
	rebel = Find_Player("Rebel")
	empire = Find_Player("Empire")
	hutts = Find_Player("Hutts")
	hostile = Find_Player("Hostile")
	neutral = Find_Player("Neutral")
	
	camera_offset = 135
	
	garnak_fey_reveal = nil
	flag_Garnak_following = false
	

end

function State_Utapau_Kidnapping_Mission_Begin(message)
	if message == OnEnter then
		Fade_Screen_Out(0)
		mission_started = true
		JoeMessage("#####################################Starting UTAPAU KIDNAPPING mission")
		
		-- define mission hero here --
		hero = Find_First_Object("TYBER_ZANN")
		if not TestValid(hero) then	
			hero = Find_First_Object("URAI_FEN")
		end
		if not TestValid(hero) then	
			hero = Find_First_Object("Silri")
		end
		if not TestValid(hero) then	
			--spawn a silri in
			hero_spawn_flag = Find_Hint("MARKER_GENERIC_PURPLE","hero-spawn")
			Spawn_Unit(Find_Object_Type("SILRI"), hero_spawn_flag, underworld)
			hero = Find_First_Object("SILRI")
			hero.Teleport_And_Face(hero_spawn_flag)
		end
		
		if not TestValid(hero) then
			MessageBox("Utapau Kidnapping mission cannot find the hero...aborting...tell Joe G immediately!")
			ScriptExit()
		end
		
		Create_Thread("Thread_DeathMonitor_Hero", hero)
		
		rebel_list = Find_All_Objects_Of_Type(rebel)
		empire_list = Find_All_Objects_Of_Type(empire)
		hutt_list = Find_All_Objects_Of_Type(hutts)
		

		
		garnak_fey_list = Find_All_Objects_With_Hint("garnak-fey")
		garnak_fey = garnak_fey_list[1]
		
		
		if not TestValid(garnak_fey) then
			MessageBox("Utapau Kidnapping mission cannot find the garnak_fey...aborting...tell Joe G immediately!")
			ScriptExit()
		end
		
		defending_faction = garnak_fey.Get_Owner()
		Create_Thread("Thread_Cleanup_Faction_Stuff", defending_faction)
		
		garnak_fey.Set_Cannot_Be_Killed(true)
		garnak_fey.Prevent_Opportunity_Fire(true)
		--garnak_fey.Suspend_Locomotor(true)
		
		garnak_fey.Guard_Target(garnak_fey.Get_Position())
		Add_Radar_Blip(garnak_fey, "garnak_fey_blip")
		
		compound_guards_list = Find_All_Objects_With_Hint("compound")
		for i,unit in pairs(compound_guards_list) do
			if TestValid(unit) then
				if unit.Get_Type().Get_Name() == "E_GROUND_TURBOLASER_TOWER" or unit.Get_Type().Get_Name() == "R_GROUND_TURBOLASER_TOWER" then
					--do nothing
				else
					unit.Guard_Target(unit.Get_Position())
					unit.Prevent_AI_Usage(true)
				end
			end
		end
		
		
	
		
		
		
		
		pointguards_list = Find_All_Objects_With_Hint("pointguard")
		for i,unit in pairs(pointguards_list) do
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

function Thread_Cleanup_Faction_Stuff(defender_faction)
	--DESERT_CIVILIAN_SPAWN_HOUSE_EMPIRE
	if defender_faction == empire then
		--delete all rebel spawn houses
		JoeMessage("Defender is Empire...cleaning up")
		--spawn_house_list = Find_All_Objects_Of_Type("DESERT_CIVILIAN_SPAWN_HOUSE_REBEL")
		spawn_house_list = Find_All_Objects_Of_Type(rebel)
	elseif defender_faction == rebel then
		JoeMessage("Defender is Rebel...cleaning up")
		--spawn_house_list = Find_All_Objects_Of_Type("DESERT_CIVILIAN_SPAWN_HOUSE_EMPIRE")
		spawn_house_list = Find_All_Objects_Of_Type(empire)
	end
	
	for i,spawn_house in pairs(spawn_house_list) do
		spawn_house.Despawn()
	end
	
end


function Thread_DeathMonitor_Compound_Guards()
	while (true) do
		local flag_compound_clear = true
		compound_guards_list = Find_All_Objects_With_Hint("compound")
		for i,unit in pairs(compound_guards_list) do
			if TestValid(unit) then
				flag_compound_clear = false
			end
		end
		
		
		tubolaser_list = Find_All_Objects_With_Hint("turbo")
		powerplant_list = Find_All_Objects_With_Hint("power")
		
		local turbolasers_clear = true
		for i,unit in pairs(tubolaser_list) do
			if TestValid(unit) then
				turbolasers_clear = false
			end
		end
		
		local powerplant_dead = true
		for i,unit in pairs(powerplant_list) do
			if TestValid(unit) then
				powerplant_dead = false
			end
		end
		
		
		
		
		
		if flag_compound_clear == true and turbolasers_clear == true then
			--compound is clear, complete the objective
			Story_Event("Utapau_Kidnapping_Compound_Clear_AI_NOTIFICATION")
			break
		end
		
		if flag_compound_clear == true and powerplant_dead == true then
			--compound is clear, complete the objective
			Story_Event("Utapau_Kidnapping_Compound_Clear_AI_NOTIFICATION")
			break
		end
		
		Sleep(5)
	end
end


function Thread_DeathMonitor_Hero(local_hero)
	while TestValid(local_hero) do
		Sleep(3)
	end
	--hero klled end misisonin loss
	Story_Event("Utapau_Kidnapping_Player_Loses_AI_NOTIFICATION")
end

function State_Utapau_Kidnapping_FAIL_OBJECTIVE_Silri_Must_Survive(message)
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



function State_Utapau_Kidnapping_ADD_OBJECTIVE_Capture_Garnak(message)
	if message == OnEnter then
		--callback from xml...player just got objective to capture Garnak with Silri...set up prox event here.
		if TestValid(garnak_fey) then
			Register_Prox(garnak_fey,PROX_Garnak_Fey,45,underworld)
			garnak_fey.Highlight(true)
			garnak_fey_reveal = FogOfWar.Reveal(underworld, garnak_fey, 100, 100)
		else
			MessageBox("utapau kidnapping cannot find garnak_fey to set up prox event...aborting!!  Tell Joe G immediately!")
		end
	end
end

function PROX_Garnak_Fey(prox_obj, trigger_obj)
	if trigger_obj.Get_Type().Get_Name() == "SILRI" then
		JoeMessage("Silri reaches Garnak...setting prox on shuttle")
		prox_obj.Cancel_Event_Object_In_Range(PROX_Garnak_Fey)
		--garnak_fey.Move_To(hero)
		--garnak_fey.Guard_Target(hero)
		flag_Garnak_following = true
		
		landing_shuttle = Find_First_Object("UNDERWORLD_HERO_SHUTTLE_LANDING")
		Register_Prox(landing_shuttle,PROX_Return_To_Shuttle,50,underworld)
		
		Story_Event("Utapau_Kidnapping_Silri_Reaches_Garnak_AI_NOTIFICATION")
		garnak_fey.Highlight(false)
		landing_shuttle.Highlight(true)
		Remove_Radar_Blip("garnak_fey_blip")
		Add_Radar_Blip(landing_shuttle, "landing_shuttle_blip")
		
		garnak_fey.Change_Owner(neutral)
		
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
end

function Story_Mode_Service()
	if not flag_Garnak_following == true then
		return
	end
	
	if TestValid(garnak_fey) and TestValid(hero) then
		garnak_fey.Move_To(hero)
	end
end


--change this to prox on shuttle
function PROX_Return_To_Shuttle(prox_obj, trigger_obj)
	if trigger_obj.Get_Type().Get_Name() == "SILRI" then
		JoeMessage("Silri and Garnak reach shuttle ... mission over")
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
	
		Story_Event("Utapau_Kidnapping_Player_Wins_AI_NOTIFICATION")
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
		MessageBox("Utapau Kidnapping cannot find any heroes...aborting mission")
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
	Story_Event("Utapau_Kidnapping_Mission_Start_AI_NOTIFICATION")
end

-- ##########################################################################################
function JoeMessage(...)
	--JoeMessage("current current_spawn_times  is %d", current_spawn_times)
	_CustomScriptMessage("JoeLog.txt", string.format(unpack(arg)))
end