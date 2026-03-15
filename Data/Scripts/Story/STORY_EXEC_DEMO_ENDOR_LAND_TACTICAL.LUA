-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Exec_Demo_Endor_Land_Tactical.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Exec_Demo_Endor_Land_Tactical.lua $
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
		Underworld_Exec_Demo_Endor_Begin = State_Underworld_Exec_Demo_Endor_Begin
	}
	
	underworld = Find_Player("Underworld")
	rebel = Find_Player("Rebel")
	neutral = Find_Player("Neutral")
	
	camera_offset = 225
end

function State_Underworld_Exec_Demo_Endor_Begin(message)
	if message == OnEnter then
		--Turning off AI
		Suspend_AI(1)
		
		--Spawning in all Underworld units
		
		--Spawning in cinematic saboteur
		cine_sab_loc = Find_Hint("STORY_TRIGGER_ZONE_00", "saboteur0")
		cine_saboteur = Spawn_Unit(Find_Object_Type("UNDERWORLD_SABOTEUR"), cine_sab_loc, underworld)
		cine_saboteur[1].Teleport_And_Face(cine_sab_loc)
		
		--Spawning in 3 other saboteurs
		sab_spawn_list = Find_All_Objects_With_Hint("saboteur")
		for k, loc in pairs(sab_spawn_list) do
			if TestValid(loc) then
				saboteur = Spawn_Unit(Find_Object_Type("UNDERWORLD_SABOTEUR"), loc, underworld)
				saboteur[1].Teleport_And_Face(loc)
			end
		end
		
		--Spawning in 3 groups of underworld mercs
		merc_spawn_list = Find_All_Objects_With_Hint("merc")
		for k, loc in pairs(merc_spawn_list) do
			if TestValid(loc) then
				Spawn_Unit(Find_Object_Type("UNDERWORLD_MERC_SQUAD"), loc, underworld)
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
		
		--Spawning in Underworld Transport
		transport_loc = Find_All_Objects_With_Hint("transport")
		for k, loc in pairs(transport_loc) do
			if TestValid(loc) then
				transport = Spawn_Unit(Find_Object_Type("F9TZ_CLOAKING_TRANSPORT"), loc, underworld)
				Sleep(.5)
				transport[1].Teleport_And_Face(loc)
			end
		end
		
		current_cinematic_thread = Create_Thread("Intro_Cinematic")
		
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
	Transition_To_Tactical_Camera(6)
	Sleep(4)
	Letter_Box_Out(2)
	Sleep(2)
	Lock_Controls(0)
	End_Cinematic_Camera()
	
end



-- ************************************************************************
-- ***********************INTRO CINEMATIC FUNCTION*************************
-- ************************************************************************

function Intro_Cinematic ()	
	
	Lock_Controls(1)
	Start_Cinematic_Camera()
	Letter_Box_In(0)	
	Fade_Screen_In(2)
	
	Transition_Cinematic_Camera_Key(cine_saboteur[1], 0, 50, 35, 135, 1, 1, 1, 0)
	Transition_Cinematic_Target_Key(cine_saboteur[1], 0, 0, 0, 10, 0, 0, 0, 0)
	--Sleep(7)
	
	Transition_Cinematic_Camera_Key(cine_saboteur[1], 5, 50, 35, 225, 1, 1, 1, 0)
	
	Sleep(4.5)
	
	while true do
		camera_offset = camera_offset + 90
		Transition_Cinematic_Camera_Key(cine_saboteur[1], 5, 50, 35, camera_offset, 1, 1, 1, 0)
		
		if camera_offset == 315 then
			camera_offset = -45
		end
		
		Sleep(4.5)
	end
end


