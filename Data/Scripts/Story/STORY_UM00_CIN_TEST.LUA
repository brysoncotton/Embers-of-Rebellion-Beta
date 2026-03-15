-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_UM00_CIN_Test.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_UM00_CIN_Test.lua $
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

require("PGStoryMode")
require("PGSpawnUnits")
require("PGStateMachine")

--
-- Definitions -- This function is called once when the script is first created.
-- 
function Definitions()

	StoryModeEvents = 
	{
		Underworld_M00_Begin = State_Underworld_M00_Begin
	}
	
	underworld = Find_Player("Underworld")
	empire = Find_Player("Empire")
	rebel = Find_Player("Rebel")
	neutral = Find_Player("Neutral")
	hostile = Find_Player("Hostile")
end

function State_Underworld_M00_Begin (message)
	if message == OnEnter then
		door_list = Find_All_Objects_Of_Type("cin_sith_door")
		
		for k, unit in pairs(door_list) do
			if TestValid(unit) then
				unit.Play_Animation("Cinematic", false, 1)
			end
		end

		rebel_reveal = FogOfWar.Reveal_All(rebel)
		empire_reveal = FogOfWar.Reveal_All(empire)
		uw_reveal = FogOfWar.Reveal_All(underworld)
		
		door_trigger = Find_Hint("STORY_TRIGGER_ZONE_00", "doortrigger")
		
		Register_Prox(door_trigger, PROX_Door_Cinematic, 30, underworld)
		
		Create_Thread("Intro_Cinematic")
		
	end
end



function PROX_Door_Cinematic(prox_obj, trigger_obj)
	if trigger_obj.Get_Owner().Get_Faction_Name() == "UNDERWORLD" then
		prox_obj.Cancel_Event_Object_In_Range(PROX_Door_Cinematic)
		
		Create_Thread("Animate_Doors")
	end
end

function Animate_Doors()
	door_list = Find_All_Objects_Of_Type("cin_sith_door")
	hanger = Find_Hint("STORY_TRIGGER_ZONE_00", "hanger")
	
	Sleep(4)
	
	Transition_Cinematic_Target_Key(door_cine, 7, 0, 0, 15, 0, 0, 0, 0)
	
	Sleep(3)
	
	for k, unit in pairs(door_list) do
		if TestValid(unit) then
			unit.Play_Animation("Cinematic", false, 0)
		end
	end
	
	Sleep(9)
	
	for k, unit in pairs(door_list) do
		if TestValid(unit) then
			--unit.Despawn()
		end
	end
	
	Transition_Cinematic_Camera_Key(hanger, 20, 30, 15, 180, 1, 0, 1, 0)
	Transition_Cinematic_Target_Key(hanger, 7, 0, 0, 10, 0, 0, 0, 0)
	
	Sleep(24)
	
	Lock_Controls(0)
	End_Cinematic_Camera()
	--Letter_Box_Out(0)	
	Suspend_AI(0)
	Fade_Screen_In(1)
end

-- ##########################################################################################
--	Cinematic functions
-- ##########################################################################################

function Intro_Cinematic()
	
	Suspend_AI(1)
	Lock_Controls(1)
	Start_Cinematic_Camera()
	--Letter_Box_In(0)
	Fade_Screen_In(2)
	
	door_trigger = Find_Hint("STORY_TRIGGER_ZONE_00", "doortrigger")
	cinestatue = Find_Hint("STORY_TRIGGER_ZONE_00", "statue")
	landing_loc = Find_Hint("STORY_TRIGGER_ZONE_00", "landing")
	silri_spawn = Find_Hint("STORY_TRIGGER_ZONE_00", "silrispawn")
	door_cine = Find_Hint("STORY_TRIGGER_ZONE_00", "doorcine")

	-- ***********Opening Shot***************
	
	-- Set_Cinematic_Camera_Key(target_pos, x_dist, y_pitch, z_yaw, euler, pobj, use_object_rotation, cinematic_animation)
	Set_Cinematic_Camera_Key(cinestatue, 105, 35, -155, 1, 0, 1, 0)
	--Set_Cinematic_Target_Key(target_pos, xoffset_dist, yoffset_pitch, zoffset_yaw, angles?, attach_object, use_object_rotation, cinematic_animation)
	Set_Cinematic_Target_Key(landing_loc, 0, 0, 1000, 0, 0, 0, 0)
	
	--Transition_Cinematic_Camera_Key(camera_loc1, 10, 500, 19, 150, 1, 1, 1, 0)
	
	--Sleep(2)
	-- Create_Cinematic_Transport(object_type_name, player_id, transport_pos, zangle, phase_mode, anim_delta, idle_time, persist,hint)
	transport = Create_Cinematic_Transport("Underworld_Hero_Shuttle_Landing", underworld.Get_ID(), landing_loc, 120, 0, 0, 20, 1)
	
	Transition_Cinematic_Target_Key(landing_loc, 5, 0, 0, 0, 0, 0, 0, 0)
	
		
	Sleep(7)
	
	silri = Spawn_Unit(Find_Object_Type("Silri_No_Abilities"), silri_spawn, underworld)
	
	trigger = Find_Hint("STORY_TRIGGER_ZONE_00", "doortrigger")
	Sleep(.5)
	silri[1].Move_To(trigger.Get_Position())
	
	Transition_Cinematic_Target_Key(silri[1], 5, 0, 0, 5, 0, silri[1], 0, 0)
	
	Sleep(1)
	
	Transition_Cinematic_Camera_Key(silri[1], 7, 30, 15, 180, 1, silri[1], 1, 0)

	
end

