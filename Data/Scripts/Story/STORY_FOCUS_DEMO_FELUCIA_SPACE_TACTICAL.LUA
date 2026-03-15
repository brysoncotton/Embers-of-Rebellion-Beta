-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Focus_Demo_Felucia_Space_Tactical.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Focus_Demo_Felucia_Space_Tactical.lua $
--
--    Original Author: Steve_Copeland
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

--
-- Definitions -- This function is called once when the script is first created.
-- 
function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))
	
	StoryModeEvents = 
	{
		Underworld_FocusDemo_Felucia_Space_Begin = State_Underworld_FocusDemo_Felucia_Space_Begin,
		Underworld_Focus_Demo_Felucia_Asteroid_Remove_Movie = State_Underworld_Focus_Demo_Felucia_Asteroid_Remove_Movie,
		Underworld_Focus_Demo_Felucia_Bomber_Speech_Done = State_Underworld_Focus_Demo_Felucia_Bomber_Speech_Done
	}
	
	underworld = Find_Player("Underworld")
	rebel = Find_Player("Rebel")
	
	bomber_tripped = false
	bombers_spawned = false
	path_clear = false
	base_tripped = false
	locomotor_tripped = false
	stealth_tripped = false
	kedalbe_spawned = false
	
	mission_started = false
	
	fog_id_00 = nil
	fog_id_01 = nil

end

function State_Underworld_FocusDemo_Felucia_Space_Begin(message)
	if message == OnEnter then
		--MessageBox("Space script active!!!")
		mission_started = true
		
		GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 0)
		
		
		
		--tyber = Find_First_Object("THE_PEACEBRINGER")
		--tyber.Make_Invulnerable(true)
		
		vengeance_02 = Find_First_Object("Vengeance_Frigate")
		
		vengeance_spawn_00 = Find_Hint("STORY_TRIGGER_ZONE_00", "vengeancespawn00")
		vengeance_spawn_01 = Find_Hint("STORY_TRIGGER_ZONE_00", "vengeancespawn01")
		
		vengeance_00 = Spawn_From_Reinforcement_Pool(Find_Object_Type("Vengeance_Frigate"), vengeance_spawn_00, underworld)
		vengeance_01 = Spawn_From_Reinforcement_Pool(Find_Object_Type("Vengeance_Frigate"), vengeance_spawn_01, underworld)
		
		space_station = Find_First_Object("REBEL_STAR_BASE_3")
		if TestValid (space_station) then
			Register_Prox(space_station, PROX_Star_Base, 2000, underworld)
		end
	end
end

function PROX_Star_Base (prox_obj, trigger_obj)
	if trigger_obj.Get_Owner().Get_Faction_Name() == "UNDERWORLD" and path_clear and not kedalbe_spawned then
		MessageBox("Warping in Kedalbe.")
		kedalbe_spawn = Find_Hint("STORY_TRIGGER_ZONE_00", "kedalbespawn")
		kedalbe = Spawn_From_Reinforcement_Pool(Find_Object_Type("Kedalbe_Battleship"), kedalbe_spawn, underworld)
		kedalbe[1].Teleport_And_Face(kedalbe_spawn)
		kedalbe[1].Cinematic_Hyperspace_In(20)
		
		underworld.Select_Object(kedalbe[1])
		
		kedalbe_spawned = true
		
		Story_Event("BASE")
	end
end

function Story_Mode_Service()
	--Turn off the locomotors for all the rebel units
	if mission_started and not bomber_tripped then
		rebel_unit_list = Find_All_Objects_Of_Type(rebel)
		for k, unit in pairs(rebel_unit_list) do
			if TestValid(unit) then
				unit.Suspend_Locomotor(true)
			end
		end
	end
	
	turret_00 = Find_All_Objects_With_Hint("turretunit00")
	turret_01 = Find_All_Objects_With_Hint("turretunit01")
	
	if not TestValid(turret_00[1]) then
		turret_flag_00 = Find_Hint("STORY_TRIGGER_ZONE_00", "turret00")
		
		turret_flag_00.Highlight(false)
		Remove_Radar_Blip("turret_blip_00")
		fog_id_00.Undo_Reveal()
	end
	
	if not TestValid(turret_01[1]) then		
		turret_flag_01 = Find_Hint("STORY_TRIGGER_ZONE_00", "turret01")
				
		turret_flag_01.Highlight(false)
		Remove_Radar_Blip("turret_blip_01")
		fog_id_01.Undo_Reveal()
	end
	
	if mission_started and not bomber_tripped and not TestValid(turret_00[1]) and not TestValid(turret_01[1]) then
		bomber_tripped = true
		
		crusader_spawn_00 = Find_Hint("STORY_TRIGGER_ZONE_00", "crusaderspawn00")
		crusader_spawn_01 = Find_Hint("STORY_TRIGGER_ZONE_00", "crusaderspawn01")
		crusader_spawn_02 = Find_Hint("STORY_TRIGGER_ZONE_00", "crusaderspawn02")
		
		crusader_00 = Spawn_From_Reinforcement_Pool(Find_Object_Type("Crusader_Gunship"), crusader_spawn_00, underworld)
		crusader_01 = Spawn_From_Reinforcement_Pool(Find_Object_Type("Crusader_Gunship"), crusader_spawn_01, underworld)
		crusader_02 = Spawn_From_Reinforcement_Pool(Find_Object_Type("Crusader_Gunship"), crusader_spawn_02, underworld)
		
		crusader_00[1].Teleport_And_Face(crusader_spawn_00)
		crusader_01[1].Teleport_And_Face(crusader_spawn_01)	
		crusader_02[1].Teleport_And_Face(crusader_spawn_02)	
		
		crusader_00[1].Cinematic_Hyperspace_In(20)
		crusader_01[1].Cinematic_Hyperspace_In(20)
		crusader_02[1].Cinematic_Hyperspace_In(20)
		
		crusader_list = Find_All_Objects_Of_Type("Crusader_Gunship")
		
		for k, unit in pairs(crusader_list) do
			if TestValid(unit) then
				underworld.Select_Object(unit)
			end
		end
		
		Story_Event("BOMBERS")
		
	end
	
	if bombers_spawned and not path_clear then
		if not TestValid(bomber_00) and not
		   TestValid(bomber_01) and not
		   TestValid(bomber_02) and not
		   TestValid(bomber_03) and not
		   TestValid(bomber_04) and not
		   TestValid(bomber_05) and not
		   TestValid(bomber_06) and not
		   TestValid(bomber_07) and not
		   TestValid(bomber_08) and not
		   TestValid(bomber_09) then
				Create_Thread("Path_Clear")
				path_clear = true
		end
	end
	
	if kedalbe_spawned and not tyber_spawned then
		if TestValid (kedalbe[1]) then
			if not kedalbe[1].Is_Ability_Ready("LEECH_SHIELDS") then
				tyber_spawn = Find_Hint("STORY_TRIGGER_ZONE_00", "tyberspawn")
				tyber = Spawn_Unit(Find_Object_Type("The_Peacebringer"), tyber_spawn, underworld)
				tyber[1].Make_Invulnerable(true)
				tyber[1].Teleport_And_Face(tyber_spawn)		
				tyber[1].Cinematic_Hyperspace_In(20)
								
				tyber_spawned = true
			end
		end
	end
end

function Path_Clear()
	Story_Event("PATH_CLEAR")
	
	space_station = Find_First_Object("REBEL_STAR_BASE_3")
	FogOfWar.Reveal(underworld, space_station, 1000,1000)
	Add_Radar_Blip(space_station, "station_blip")
	
	--Turn on the locomotors for all the rebel units
	rebel_unit_list = Find_All_Objects_Of_Type(rebel)
	for k, unit in pairs(rebel_unit_list) do
		if TestValid(unit) then
			unit.Suspend_Locomotor(false)
		end
	end

end

function State_Underworld_Focus_Demo_Felucia_Bomber_Speech_Done(message)
	if message == OnEnter then
		Create_Thread ("Warp_In_Bombers")
	end
end

function State_Underworld_Focus_Demo_Felucia_Asteroid_Remove_Movie(message)
	if message == OnEnter then
		stealth_tripped = true
		--this is the Vengeance hint about using Stealth Ability
		
		vengeance_list = Find_All_Objects_Of_Type("Vengeance_Frigate")
		
		for k, unit in pairs(vengeance_list) do
			if TestValid(unit) then
				underworld.Select_Object(unit)
			end
		end
		
		Story_Event("FLASH_CLOAK")
		
	
		turret_flag_00 = Find_Hint("STORY_TRIGGER_ZONE_00", "turret00")
		turret_flag_01 = Find_Hint("STORY_TRIGGER_ZONE_00", "turret01")

		turret_flag_00.Highlight(true)
		Add_Radar_Blip(turret_flag_00, "turret_blip_00")
		fog_id_00 = FogOfWar.Reveal(underworld, turret_flag_00, 250,250)
		
		turret_flag_01.Highlight(true)
		Add_Radar_Blip(turret_flag_01, "turret_blip_01")
		fog_id_01 = FogOfWar.Reveal(underworld, turret_flag_01, 250,250)

	end
end

function Warp_In_Bombers()
		
	bomber_spawn_00 = Find_Hint("STORY_TRIGGER_ZONE_00", "bomberspawn00")
	bomber_spawn_01 = Find_Hint("STORY_TRIGGER_ZONE_00", "bomberspawn01")
	bomber_spawn_02 = Find_Hint("STORY_TRIGGER_ZONE_00", "bomberspawn02")
	bomber_spawn_03 = Find_Hint("STORY_TRIGGER_ZONE_00", "bomberspawn03")
	bomber_spawn_04 = Find_Hint("STORY_TRIGGER_ZONE_00", "bomberspawn04")

	bomber_00_list = Spawn_Unit(Find_Object_Type("Y-WING_SQUADRON_NO_ABILITY"), bomber_spawn_00, rebel)
	bomber_01_list = Spawn_Unit(Find_Object_Type("Y-WING_SQUADRON_NO_ABILITY"), bomber_spawn_01, rebel)
	bomber_02_list = Spawn_Unit(Find_Object_Type("Y-WING_SQUADRON_NO_ABILITY"), bomber_spawn_02, rebel)
	bomber_03_list = Spawn_Unit(Find_Object_Type("Y-WING_SQUADRON_NO_ABILITY"), bomber_spawn_03, rebel)
	bomber_04_list = Spawn_Unit(Find_Object_Type("Y-WING_SQUADRON_NO_ABILITY"), bomber_spawn_04, rebel)
	bomber_05_list = Spawn_Unit(Find_Object_Type("Y-WING_SQUADRON_NO_ABILITY"), bomber_spawn_00, rebel)
	bomber_06_list = Spawn_Unit(Find_Object_Type("Y-WING_SQUADRON_NO_ABILITY"), bomber_spawn_01, rebel)
	bomber_07_list = Spawn_Unit(Find_Object_Type("Y-WING_SQUADRON_NO_ABILITY"), bomber_spawn_02, rebel)
	bomber_08_list = Spawn_Unit(Find_Object_Type("Y-WING_SQUADRON_NO_ABILITY"), bomber_spawn_03, rebel)
	bomber_09_list = Spawn_Unit(Find_Object_Type("Y-WING_SQUADRON_NO_ABILITY"), bomber_spawn_04, rebel)
	
	bomber_00 = bomber_00_list[1]
	bomber_01 = bomber_01_list[1]
	bomber_02 = bomber_02_list[1]
	bomber_03 = bomber_03_list[1]
	bomber_04 = bomber_04_list[1]
	bomber_05 = bomber_05_list[1]
	bomber_06 = bomber_06_list[1]
	bomber_07 = bomber_07_list[1]
	bomber_08 = bomber_08_list[1]
	bomber_09 = bomber_09_list[1]
	
	bombers_spawned = true
	
	FogOfWar.Reveal(underworld, bomber_00, 500,500)
	FogOfWar.Reveal(underworld, bomber_01, 500,500)
	FogOfWar.Reveal(underworld, bomber_02, 500,500)
	FogOfWar.Reveal(underworld, bomber_03, 500,500)
	FogOfWar.Reveal(underworld, bomber_04, 500,500)
	FogOfWar.Reveal(underworld, bomber_05, 500,500)
	FogOfWar.Reveal(underworld, bomber_06, 500,500)
	FogOfWar.Reveal(underworld, bomber_07, 500,500)
	FogOfWar.Reveal(underworld, bomber_08, 500,500)
	FogOfWar.Reveal(underworld, bomber_09, 500,500)
	
	bomber_00.Prevent_AI_Usage(true)
	bomber_01.Prevent_AI_Usage(true)
	bomber_02.Prevent_AI_Usage(true)
	bomber_03.Prevent_AI_Usage(true)
	bomber_04.Prevent_AI_Usage(true)
	bomber_05.Prevent_AI_Usage(true)
	bomber_06.Prevent_AI_Usage(true)
	bomber_07.Prevent_AI_Usage(true)
	bomber_08.Prevent_AI_Usage(true)
	bomber_09.Prevent_AI_Usage(true)
		
	crusader_list = Find_All_Objects_Of_Type("Crusader_Gunship")

	bomber_00.Attack_Move(crusader_list[1])
	bomber_01.Attack_Move(crusader_list[2])
	bomber_02.Attack_Move(crusader_list[3])
	bomber_03.Attack_Move(crusader_list[1])
	bomber_04.Attack_Move(crusader_list[2])
	bomber_05.Attack_Move(crusader_list[3])
	bomber_06.Attack_Move(crusader_list[1])
	bomber_07.Attack_Move(crusader_list[2])
	bomber_08.Attack_Move(crusader_list[3])
	bomber_09.Attack_Move(crusader_list[1])
end