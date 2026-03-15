-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Fondor_Piracy.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_Fondor_Piracy.lua $
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
		Fondor_Piracy_Mission_Begin = State_Fondor_Piracy_Mission_Begin,
		Fondor_Piracy_FAIL_OBJECTIVE_Bossk_Must_Survive = State_Fondor_Piracy_FAIL_OBJECTIVE_Bossk_Must_Survive,
	}
	
	underworld = Find_Player("Underworld")
	rebel = Find_Player("Rebel")
	empire = Find_Player("Empire")
	hutts = Find_Player("Hutts")
	hostile = Find_Player("Hostile")
	
	camera_offset = 135
	
end

function State_Fondor_Piracy_Mission_Begin(message)
	if message == OnEnter then
		mission_started = true
		Fade_Screen_Out(0)
		JoeMessage("#####################################Starting Fondor_Piracy mission")
		--MessageBox("#####################################Starting Fondor_Piracy mission")
		
		-- define mission hero here --
		hero = Find_First_Object("TYBER_ZANN")
		if not TestValid(hero) then	
			hero = Find_First_Object("URAI_FEN")
		end
		if not TestValid(hero) then	
			hero = Find_First_Object("HOUNDSTOOTH")
		end

		
		if not TestValid(hero) then
			MessageBox("Fondor_Piracy mission cannot find the hero...aborting...tell Joe G immediately!")
			ScriptExit()
		end
		
		Create_Thread("Thread_DeathMonitor_Hero", hero)
		
		space_station_list = Find_All_Objects_With_Hint("spacestation")
		space_station = space_station_list[1]
		if not TestValid(space_station) then
			MessageBox("Fondor_Piracy mission cannot find the space_station...aborting...tell Joe G immediately!")
			ScriptExit()
		end
		
		Add_Radar_Blip(space_station, "space_station_blip")
		
		Create_Thread("Thread_DeathMonitor_SpaceStation", space_station)

		
		-- make only minor tweaks to the script below... --
		--current_cinematic_thread = Create_Thread("Intro_Cinematic")
		Create_Thread("End_Camera")
	end
end

function Thread_DeathMonitor_Hero(local_hero)
	while TestValid(local_hero) do
		Sleep(3)
	end
	--hero klled end misisonin loss
	Story_Event("Fondor_Piracy_Player_Loses_AI_NOTIFICATION")
end

function Thread_DeathMonitor_SpaceStation(local_space_station)
	while TestValid(local_space_station) do
		Sleep(3)
	end
	--space station is dead
	if TestValid(hero) then
		hero.Set_Cannot_Be_Killed(true) --safety 
		Story_Event("Fondor_Piracy_Player_Wins_AI_NOTIFICATION")
	end
end

function State_Fondor_Piracy_FAIL_OBJECTIVE_Bossk_Must_Survive(message)
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
		MessageBox("Fondor_Piracy cannot find any heroes...aborting mission")
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
	Story_Event("Fondor_Piracy_Mission_Start_AI_NOTIFICATION")
end

-- ##########################################################################################
function JoeMessage(...)
	--JoeMessage("current current_spawn_times  is %d", current_spawn_times)
	_CustomScriptMessage("JoeLog.txt", string.format(unpack(arg)))
end