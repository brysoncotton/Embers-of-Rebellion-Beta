-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Focus_Demo_Felucia_Land_Tactical.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Focus_Demo_Felucia_Land_Tactical.lua $
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
		Underworld_Prologue_Felucia_Begin = State_Underworld_Prologue_Felucia_Begin,
		Underworld_Prologue_Felucia_Speech_Line_00_Remove_Text = State_Underworld_Prologue_Felucia_Speech_Line_00_Remove_Text,
		Underworld_Prologue_Felucia_Speech_Line_01_Remove_Text = State_Underworld_Prologue_Felucia_Speech_Line_01_Remove_Text,
		Underworld_Prologue_Felucia_Speech_Line_02_Remove_Text = State_Underworld_Prologue_Felucia_Speech_Line_02_Remove_Text,
		Underworld_Prologue_Felucia_Speech_Line_03_Remove_Text = State_Underworld_Prologue_Felucia_Speech_Line_03_Remove_Text,
		Underworld_Prologue_Felucia_Speech_Line_04_Remove_Text = State_Underworld_Prologue_Felucia_Speech_Line_04_Remove_Text,
		Underworld_Prologue_Felucia_Speech_Line_05_Remove_Text = State_Underworld_Prologue_Felucia_Speech_Line_05_Remove_Text,
		Underworld_Prologue_Felucia_Speech_Line_06_Remove_Text = State_Underworld_Prologue_Felucia_Speech_Line_06_Remove_Text,
		Underworld_Prologue_Felucia_Speech_Line_07_Remove_Text = State_Underworld_Prologue_Felucia_Speech_Line_07_Remove_Text,
		Underworld_Prologue_Felucia_Speech_Line_08_Remove_Text = State_Underworld_Prologue_Felucia_Speech_Line_08_Remove_Text,
		Underworld_Prologue_Felucia_Speech_Line_09_Remove_Text = State_Underworld_Prologue_Felucia_Speech_Line_09_Remove_Text,
		Underworld_Prologue_Felucia_Speech_Line_10_Remove_Text = State_Underworld_Prologue_Felucia_Speech_Line_10_Remove_Text,
		Underworld_Prologue_Felucia_Speech_Line_11_Remove_Text = State_Underworld_Prologue_Felucia_Speech_Line_11_Remove_Text,
		Underworld_Prologue_Felucia_Speech_Line_12_Remove_Text = State_Underworld_Prologue_Felucia_Speech_Line_12_Remove_Text,
		Underworld_Prologue_Felucia_Speech_Line_13_Remove_Text = State_Underworld_Prologue_Felucia_Speech_Line_13_Remove_Text,
		Underworld_Prologue_Felucia_Speech_Line_14_Remove_Text = State_Underworld_Prologue_Felucia_Speech_Line_14_Remove_Text,
		Underworld_Prologue_Felucia_Speech_Line_15_Remove_Text = State_Underworld_Prologue_Felucia_Speech_Line_15_Remove_Text,
		Underworld_Prologue_Felucia_Speech_Line_59_Remove_Text = State_Underworld_Prologue_Felucia_Speech_Line_59_Remove_Text,
		Underworld_Prologue_Felucia_Speech_Line_64_Remove_Text = State_Underworld_Prologue_Felucia_Speech_Line_64_Remove_Text,
		Underworld_Prologue_Felucia_Speech_Line_65_Remove_Text = State_Underworld_Prologue_Felucia_Speech_Line_65_Remove_Text,
		Underworld_Prologue_Felucia_Speech_Line_66_Remove_Text = State_Underworld_Prologue_Felucia_Speech_Line_66_Remove_Text,
		Underworld_Prologue_Felucia_Speech_Line_97_Remove_Text = State_Underworld_Prologue_Felucia_Speech_Line_97_Remove_Text,
		Underworld_Prologue_Felucia_Speech_Line_101_Remove_Text = State_Underworld_Prologue_Felucia_Speech_Line_101_Remove_Text
	}
	
	underworld = Find_Player("Underworld")
	rebel = Find_Player("Rebel")
	empire = Find_Player("Empire")
	neutral = Find_Player("Neutral")
	hutts = Find_Player("Hutts")
	
	camera_step = 0
	
	intro_started = false
	intro_done = false
	transport_spawned = false
	transport_garrisoned = false
	end_cine_started = false
	scene_2_started = false
	cin_troopers_spawned = false
	end_atst_in_position = false
	tyber_give_up = false
	stay_back_text = true
	mdu_defend_text = true
	infantry_flower_text = true
	objective_02_given = false
	objective_02_complete = false
	cin_trooper_attack_given = false
	tyber_freeze = false
	objective_00_given = false
	objective_00_complete = false
	
	intro_off = false
	
	noghri_unit = nil
	guard1_unit = nil
	guard2_unit = nil
	
	merc_squad_list = {}
end

function State_Underworld_Prologue_Felucia_Begin(message)
	if message == OnEnter then
		empire.Make_Ally(hutts)
		hutts.Make_Ally(empire)
		
		rock_spawn = Find_Hint("STORY_TRIGGER_ZONE_00", "rock")
		rock_spawn_2 = Find_Hint("STORY_TRIGGER_ZONE_00", "rock2")
		passable_rock = Create_Generic_Object ("Prop_EndrRock_Cluster_03_Large", rock_spawn, neutral)
		passable_rock_2 = Create_Generic_Object ("Prop_EndrRock_Cluster_03_Large", rock_spawn_2, neutral)
		
		trans_spawn_loc = Find_Hint("STORY_TRIGGER_ZONE_00", "transportspawn")
		trans_goto_0 = Find_Hint("STORY_TRIGGER_ZONE_00", "transportgoto0")
		trans_goto_1 = Find_Hint("STORY_TRIGGER_ZONE_00", "transportgoto1")
		trans_goto_2 = Find_Hint("STORY_TRIGGER_ZONE_00", "transportgoto2")
		
		cin_tyber =  Find_First_Object("TYBER_ZANN_PROLOGUE")
		tyber = cin_tyber
		
		if TestValid(tyber) then
			tyber.Hide(true)
		end
		
		transport_list = Spawn_Unit(Find_Object_Type("Underworld_Vehicle_Transport_Landing_CIN"), trans_spawn_loc, underworld)
		cin_transport = transport_list[1]
		if TestValid(cin_transport) and TestValid(trans_spawn_loc) then
			cin_transport.Teleport_And_Face(trans_spawn_loc)
		end
		
		Story_Event("ADD_OBJECTIVE_03")
		
		infantry_only = Find_Hint("STORY_TRIGGER_ZONE_00", "infonly")
		Register_Prox(infantry_only, PROX_Infantry_Only_Area, 200, underworld)
		
		end_infantry_only_prox = Find_Hint("STORY_TRIGGER_ZONE_00", "endinfprox")
		Register_Prox(end_infantry_only_prox, PROX_End_Infantry_Only_Area, 220, underworld)
		
		urai_prox = Find_Hint("STORY_TRIGGER_ZONE_00", "uraiprox")
		Register_Prox(urai_prox, PROX_Urai_End_Cinematic, 100, underworld)
		
		if not intro_off then
			intro_started = true
			current_cinematic_thread = Create_Thread("Intro_Cinematic")
		end
		if intro_off then
			intro_done = true
			
			merc_spawn_loc = Find_Hint ("STORY_TRIGGER_ZONE_00","mercspawn")
			cin_tyber_spawn_loc = Find_Hint ("STORY_TRIGGER_ZONE_00","tybercin")
			merc_squad_list = Spawn_Unit(Find_Object_Type("Underworld_Disruptor_Merc_Squad"), merc_spawn_loc, underworld)
			merc_list = Find_All_Objects_Of_Type("Underworld_Disruptor_Merc")
			cin_tyber = Find_First_Object("Tyber_Zann_Prologue")
			tyber = cin_tyber
			
			merc_spawn_loc_1 = Find_Hint ("STORY_TRIGGER_ZONE_00","mercspawn1")
			merc_spawn_loc_2 = Find_Hint ("STORY_TRIGGER_ZONE_00","mercspawn2")
			merc_spawn_loc_3 = Find_Hint ("STORY_TRIGGER_ZONE_00","mercspawn3")		
			merc_squad_list1 = Spawn_Unit(Find_Object_Type("Underworld_Merc_Squad"), merc_spawn_loc_1, underworld)
			merc_squad_list3 = Spawn_Unit(Find_Object_Type("Underworld_Disruptor_Merc_Squad"), merc_spawn_loc_3, underworld)
			
			urai_spawn_loc = Find_Hint("STORY_TRIGGER_ZONE_00", "uraispawn")
			--urai_spawn = Spawn_From_Reinforcement_Pool(Find_Object_Type("Urai_Fen_Team"), urai_spawn_loc, underworld)
			
			if not urai_spawn or not TestValid(urai_spawn[1]) then
				urai_spawn = Spawn_Unit(Find_Object_Type("Urai_Fen_Prologue"), urai_spawn_loc, underworld)
			end
			urai = urai_spawn[1]
			
			Fade_Screen_In(1)
			Transition_To_Tactical_Camera(0)
			Letter_Box_Out(0)
			End_Cinematic_Camera()
			Suspend_AI(0)
			
			Sleep(2)
			Lock_Controls(0)
		end
		
		--Spawn in all the hutt forces
		
		hutt_spawn_loc_0 = Find_Hint("STORY_TRIGGER_ZONE_00", "huttspawn0")
		hutt_spawn_loc_1 = Find_Hint("STORY_TRIGGER_ZONE_00", "huttspawn1")
		hutt_spawn_loc_2 = Find_Hint("STORY_TRIGGER_ZONE_00", "huttspawn2")
		hutt_guard_0_loc = Find_Hint("STORY_TRIGGER_ZONE_00", "huttguard0")
		hutt_guard_1_loc = Find_Hint("STORY_TRIGGER_ZONE_00", "huttguard1")
		hutt_guard_2_loc = Find_Hint("STORY_TRIGGER_ZONE_00", "huttguard2")
		hutt_guard_3_loc = Find_Hint("STORY_TRIGGER_ZONE_00", "huttguard3")
		hutt_guard_4_loc = Find_Hint("STORY_TRIGGER_ZONE_00", "huttguard4")
		hutt_guard_5_loc = Find_Hint("STORY_TRIGGER_ZONE_00", "huttguard5")
		hutt_guard_6_loc = Find_Hint("STORY_TRIGGER_ZONE_00", "huttguard6")
		
		hutt_guard_0 = Spawn_Unit(Find_Object_Type("HUTT_SOLDIER_SQUAD"), hutt_spawn_loc_0, hutts)
		for k, unit in pairs(hutt_guard_0) do
			if TestValid(unit) and TestValid(hutt_guard_3_loc) then				
				unit.Guard_Target(hutt_guard_3_loc)
			end
		end
		hutt_guard_1 = Spawn_Unit(Find_Object_Type("HUTT_SOLDIER_SQUAD"), hutt_spawn_loc_0, hutts)
		for k, unit in pairs(hutt_guard_1) do
			if TestValid(unit) and TestValid(hutt_guard_6_loc) then				
				unit.Guard_Target(hutt_guard_6_loc)
			end
		end
		hutt_guard_2 = Spawn_Unit(Find_Object_Type("HUTT_SOLDIER_SQUAD"), hutt_spawn_loc_1, hutts)
		for k, unit in pairs(hutt_guard_2) do
			if TestValid(unit) and TestValid(hutt_guard_2_loc) then				
				unit.Guard_Target(hutt_guard_2_loc)
			end
		end
		hutt_guard_3 = Spawn_Unit(Find_Object_Type("HUTT_SOLDIER_SQUAD"), hutt_spawn_loc_1, hutts)
		for k, unit in pairs(hutt_guard_3) do
			if TestValid(unit) and TestValid(hutt_guard_3_loc) then				
				unit.Guard_Target(hutt_guard_3_loc)
			end
		end
		hutt_guard_4 = Spawn_Unit(Find_Object_Type("HUTT_SOLDIER_SQUAD"), hutt_spawn_loc_2, hutts)
		for k, unit in pairs(hutt_guard_4) do
			if TestValid(unit) and TestValid(hutt_guard_4_loc) then				
				unit.Guard_Target(hutt_guard_4_loc)
			end
		end
		hutt_guard_5 = Spawn_Unit(Find_Object_Type("HUTT_SOLDIER_SQUAD"), hutt_spawn_loc_2, hutts)
		for k, unit in pairs(hutt_guard_5) do
			if TestValid(unit) and TestValid(hutt_guard_5_loc) then				
				unit.Guard_Target(hutt_guard_5_loc)
			end
		end
		hutt_guard_6 = Spawn_Unit(Find_Object_Type("HUTT_SOLDIER_SQUAD"), hutt_spawn_loc_2, hutts)
		for k, unit in pairs(hutt_guard_6) do
			if TestValid(unit) and TestValid(hutt_guard_6_loc) then				
				unit.Guard_Target(hutt_guard_6_loc)
			end
		end
		
		if TestValid(hutt_spawn_loc_0) then
			Register_Prox(hutt_spawn_loc_0, PROX_Urai_Only_Area, 550, underworld) 
		end
		if TestValid(hutt_guard_3_loc) then
			Register_Prox(hutt_guard_3_loc, PROX_Non_Urai_Goto, 50, underworld)
		end
		
		reveal_stealth_loc = Find_Hint("STORY_TRIGGER_ZONE_00", "revealstealth")
		if TestValid(reveal_stealth_loc) then
			Register_Prox(reveal_stealth_loc, PROX_Unstealth_Heroes, 250, underworld)
		end
	end
end

function PROX_Unstealth_Heroes(prox_obj, trigger_obj)
	if objective_02_given and not end_cine_started then
		if trigger_obj.Get_Owner() == underworld then
			if trigger_obj == urai or trigger_obj == tyber then
				--MessageBox("Unstealth Area Hit!")
				
				trigger_obj.Activate_Ability("STEALTH", false)
			end
		end
	end
end

function PROX_Urai_Only_Area(prox_obj, trigger_obj)
	if objective_02_given and not end_cine_started then
		if trigger_obj.Get_Owner() == underworld then
			if trigger_obj ~= urai and trigger_obj ~= tyber then
				if trigger_obj.Get_Type().Get_Name() == "UNDERWORLD_DISRUPTOR_MERC" or trigger_obj.Get_Type().Get_Name() == "UNDERWORLD_MERC" or trigger_obj.Get_Type().Get_Name() == "PIRATE_SOLDIER_CONVERTED_TO_ENEMY" then
					if stay_back_text then
						stay_back_text = false
						Story_Event("TEXT_SPEECH_UNDERWORLD_PROLOGUE_FELUCIA_12")
					end
					--MessageBox("Non Urai Area tripped!  Sending units back to cover!")
					parent = trigger_obj.Get_Parent_Object()
					if TestValid(parent) and TestValid(hutt_guard_3_loc) then
						parent.Move_To(hutt_guard_3_loc)
						parent.Set_Selectable(false)
					end
					if not TestValid(parent) then
						if TestValid(trigger_obj) and TestValid(hutt_guard_3_loc) then
							trigger_obj.Move_To(hutt_guard_3_loc)
							trigger_obj.Set_Selectable(false)
						end
					end
				end
			end
		end
	end
end

function PROX_Non_Urai_Goto(prox_obj, trigger_obj)
	if trigger_obj.Get_Owner() == underworld then        
        parent = trigger_obj.Get_Parent_Object()
		if TestValid(parent) and not parent.Is_Selectable() then
			parent.Set_Selectable(true)
		end
		if not TestValid(parent) and not trigger_obj.Is_Selectable() then
			if TestValid(trigger_obj) then
				trigger_obj.Set_Selectable(true)
			end
		end
	end
end

function State_Underworld_Prologue_Felucia_Speech_Line_12_Remove_Text(message)
	if message == OnEnter then
		Sleep(5)
		stay_back_text = true
	end
end

function Story_Mode_Service()
	--MessageBox("State Hit!")
	if intro_done and not transport_spawned then
		transport_spawn_loc = Find_Hint("STORY_TRIGGER_ZONE_00", "transportspawn1")
		transport = Spawn_Unit(Find_Object_Type("F9TZ_Cloaking_Transport_Company"), transport_spawn_loc, underworld)
		
		flower_flag = Find_Hint("STORY_TRIGGER_ZONE_00", "flowerprox")
		--Register_Prox(flower_flag, PROX_Poison_Plant_Area, 500, underworld)
		
		--Register_Prox(flower_flag, PROX_Non_Urai_Goto, 20, underworld)
				
		mdu_0_spawn_loc = Find_Hint("STORY_TRIGGER_ZONE_00", "mduspawn0")		
		mdu0_list = Spawn_Unit(Find_Object_Type("UNDERWORLD_MOBILE_DEFENSE_UNIT_PROLOGUE"), mdu_0_spawn_loc, underworld)
		--mdu_1_spawn_loc = Find_Hint("STORY_TRIGGER_ZONE_00", "mduspawn1")		
		--mdu1_list = Spawn_Unit(Find_Object_Type("UNDERWORLD_MOBILE_DEFENSE_UNIT_PROLOGUE"), mdu_1_spawn_loc, underworld)
		
		if TestValid(transport[1]) and TestValid(transport_spawn_loc) then
			transport[1].Teleport_And_Face(transport_spawn_loc)
		end
		
		--Spawn the artifact guards
		noghri_spawn_loc = Find_Hint("STORY_TRIGGER_ZONE_00", "noghri")
		twilek_spawn_loc = Find_Hint("STORY_TRIGGER_ZONE_00", "twilek")
		guard1_spawn_loc = Find_Hint("STORY_TRIGGER_ZONE_00", "guard1")
		guard2_spawn_loc = Find_Hint("STORY_TRIGGER_ZONE_00", "guard2")
		
		noghri = Spawn_Unit(Find_Object_Type("NOGHRI_ASSASSIN"), noghri_spawn_loc, hutts)
		noghri_unit = noghri[1]
		if TestValid(noghri_unit) then
			noghri_unit.Make_Invulnerable(true)
			noghri_unit.Suspend_Locomotor(true)
			noghri_unit.Prevent_AI_Usage(true)
			noghri_unit.Prevent_All_Fire(true)
			if TestValid(noghri_spawn_loc) then
				noghri_unit.Teleport_And_Face(noghri_spawn_loc)
			end
		end
		twilek = Spawn_Unit(Find_Object_Type("TWILEK_COMMANDO"), twilek_spawn_loc, hutts)
		if TestValid(twilek[1]) then
			twilek[1].Make_Invulnerable(true)
			twilek[1].Suspend_Locomotor(true)
			twilek[1].Prevent_AI_Usage(true)
			twilek[1].Prevent_All_Fire(true)
			if TestValid(twilek_spawn_loc) then
				twilek[1].Teleport_And_Face(twilek_spawn_loc)
			end
		end
		guard1 = Spawn_Unit(Find_Object_Type("HUTT_CIVILIAN"), guard1_spawn_loc, hutts)
		guard1_unit = guard1[1]
		if TestValid(guard1_unit) then
			guard1_unit.Make_Invulnerable(true)
			guard1_unit.Suspend_Locomotor(true)
			guard1_unit.Prevent_AI_Usage(true)
			guard1_unit.Prevent_All_Fire(true)
			if TestValid(guard1_spawn_loc) then
				guard1_unit.Teleport_And_Face(guard1_spawn_loc)
			end
		end
		guard2 = Spawn_Unit(Find_Object_Type("HUTT_CIVILIAN"), guard2_spawn_loc, hutts)
		guard2_unit = guard2[1]
		if TestValid(guard2_unit) then
			guard2_unit.Make_Invulnerable(true)
			guard2_unit.Suspend_Locomotor(true)
			guard2_unit.Prevent_AI_Usage(true)
			guard2_unit.Prevent_All_Fire(true)
			if TestValid(guard2_spawn_loc) then
				guard2[1].Teleport_And_Face(guard2_spawn_loc)
			end
		end	
		transport_spawned = true
	end
	
	if intro_done then
		if not TestValid(tyber) or not TestValid(urai) then
			Story_Event("FAIL_OBJECTIVE_03")
		end
	end
	
	if objective_02_given and not objective_02_complete then
		rocket_pod_uc = Find_First_Object("UC_UNDERWORLD_ROCKET_POD")
		rocket_pod = Find_First_Object("UNDERWORLD_ROCKET_POD")
		if TestValid(rocket_pod_uc) or TestValid(rocket_pod) then
			Story_Event("COMPLETE_OBJECTIVE_02")
			objective_02_complete = true
			Story_Event("TEXT_SPEECH_UNDERWORLD_PROLOGUE_FELUCIA_04")
			if TestValid(transport[1]) then
				transport[1].Highlight(true)
			end
		end
	end
	
	if objective_00_given and not objective_00_complete then
		if TestValid(transport[1]) and transport[1].Has_Garrison() then
			objective_00_complete = true
			transport[1].Highlight(false)
			Story_Event("COMPLETE_OBJECTIVE_00")
		end
	end
		
	if intro_done and not transport_garrisoned then
		if TestValid(transport[1]) and transport[1].Has_Garrison() then
			transport_garrisoned = true
			if TestValid(transport[1]) then
				transport[1].Highlight(false)
			end
			
			underworld_list = Find_All_Objects_Of_Type(underworld)
			for k, unit in pairs(underworld_list) do
				if TestValid(unit) and unit.Is_Category("Infantry") then
					if not unit.Is_In_Garrison() and TestValid(transport[1]) then
						unit.Garrison(transport[1])
					end
				end
			end
			if TestValid(tyber) and TestValid(transport[1]) and not tyber.Is_In_Garrison() then
				tyber.Garrison(transport[1])
			end
			if TestValid(urai) and TestValid(transport[1]) and not urai.Is_In_Garrison() then
				urai.Garrison(transport[1])
			end
			
			Story_Event("ADD_OBJECTIVE_01")
			objective_01_loc = Find_Hint("STORY_TRIGGER_ZONE_00","objectivedestination")
			if TestValid(objective_01_loc) then
				Add_Radar_Blip(objective_01_loc, "objective_1_blip")
			end
			if TestValid(objective_01_loc) then
				hutt_landing_area = FogOfWar.Reveal(underworld,objective_01_loc,250,250)
			end
		end
	end
	
	if end_cine_started then
		if not TestValid(noghri[1]) and not TestValid(guard1[1]) and not TestValid(guard2[1]) and not scene_2_started then
			scene_2_started = true
			
			
			
			Suspend_AI(1)
			Fade_Screen_Out(1)
			Sleep(.5)
			urai_cin.Stop()
			Sleep(1)
			
			artifact = Find_First_Object("UM05_CINE_HOLOCRON")
			if TestValid(artifact) then
				artifact.Despawn()
			end
			
			tyber_end_cine_loc = Find_Hint("STORY_TRIGGER_ZONE_00","tyberendcine")
			urai_end_cine_loc = Find_Hint("STORY_TRIGGER_ZONE_00","uraiendcine")
			
			cin_tyber_list = Spawn_Unit(Find_Object_Type("Tyber_Zann_Prologue_Cin"), tyber_end_cine_loc, underworld)
			tyber = cin_tyber_list[1]
			
			if TestValid(tyber) then
				tyber.Make_Invulnerable(true)
				--tyber.Prevent_All_Fire(true)
				if TestValid(tyber_end_cine_loc) then
					tyber.Teleport_And_Face(tyber_end_cine_loc)
				end
			end
			if TestValid(urai_cin) then
				urai_cin.Make_Invulnerable(true)
				urai_cin.Prevent_All_Fire(true)
				if TestValid(urai_end_cine_loc) then
					urai_cin.Teleport_And_Face(urai_end_cine_loc)
				end
				
				Set_Cinematic_Camera_Key(urai_cin, 50, 10, 0, 1, 0, 0, 0)
				Set_Cinematic_Target_Key(urai_cin, 0, 0, 8, 0, 0, 0, 0)
			end			
						
			Fade_Screen_In(1)
			Sleep(1)			
			
			urai_cin.Play_Animation("cinematic", true, 0)
			Story_Event("TEXT_SPEECH_UNDERWORLD_PROLOGUE_FELUCIA_11")
			
			if TestValid(tyber) then
				Transition_Cinematic_Camera_Key(tyber, 5, 75, 10, 20, 1, 0, 0, 0)
				Sleep(3)
				Transition_Cinematic_Target_Key(tyber, 5, 0, 0, 10, 0, 0, 0, 0)
			end
		end
		
		if cin_troopers_spawned and not cin_trooper_attack_given then
			if not TestValid(cin_trooper_0[1]) or not TestValid(cin_trooper_1[1]) or not TestValid(cin_trooper_2[1]) then
				if TestValid(cin_trooper_0[1]) then
					cin_trooper_0[1].Prevent_All_Fire(false)
					cin_trooper_0[1].Attack_Target(tyber)
				end
				if TestValid(cin_trooper_1[1]) then
					cin_trooper_1[1].Prevent_All_Fire(false)
					cin_trooper_1[1].Attack_Target(tyber)
				end
				if TestValid(cin_trooper_2[1]) then
					cin_trooper_2[1].Prevent_All_Fire(false)
					cin_trooper_2[1].Attack_Target(tyber)
				end
				cin_trooper_attack_given = true
			end
		end
		
		if cin_troopers_spawned then
			if not TestValid(cin_trooper_0[1]) and not TestValid(cin_trooper_1[1]) and not TestValid(cin_trooper_2[1]) then
				--tyber_freeze = true
				if TestValid(tyber) then
					tyber.Suspend_Locomotor(true)
					--MessageBox("turning tyber fire OFF --> 1")
					tyber.Prevent_All_Fire(true)
				end
			end
		end
		
		if end_atst_in_position and not tyber_give_up then
			if not TestValid(cin_trooper_0[1]) or not TestValid(cin_trooper_1[1]) or not TestValid(cin_trooper_2[1]) then
				tyber_give_up = true
				
				if TestValid(cin_trooper_0[1]) then
					cin_trooper_0[1].Prevent_All_Fire(true)
				end
				if TestValid(cin_trooper_1[1]) then
					cin_trooper_1[1].Prevent_All_Fire(true)
				end
				if TestValid(cin_trooper_2[1]) then
					cin_trooper_2[1].Prevent_All_Fire(true)
				end
				if TestValid(tyber) then
					--tyber.Prevent_All_Fire(true)
				end
				Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_66")
				tyber.Play_Animation("cinematic", true, 2)
				
				if TestValid(cin_dark_0[1]) then			
					cin_dark_0[1].Suspend_Locomotor(false)
					if TestValid(atst_goto_0) then
						cin_dark_0[1].Move_To(atst_goto_0)
					end
				end

				if TestValid(cin_dark_1[1]) then
					cin_dark_1[1].Suspend_Locomotor(false)
					if TestValid(atst_goto_1) then
						cin_dark_1[1].Move_To(atst_goto_1)
					end
				end
				if TestValid(cin_dark_2[1]) then
					cin_dark_2[1].Suspend_Locomotor(false)
					if TestValid(atst_goto_2) then
						cin_dark_2[1].Move_To(atst_goto_2)
					end
				end
					
				if TestValid(cin_squad_0[1]) and TestValid(atst_goto_0) then
					cin_squad_0[1].Move_To(atst_goto_0)
				end
				if TestValid(cin_squad_1[1]) and TestValid(atst_goto_1) then
					cin_squad_1[1].Move_To(atst_goto_1)
				end
				if TestValid(cin_squad_2[1]) and TestValid(atst_goto_2) then
					cin_squad_2[1].Move_To(atst_goto_2)
				end
				
				if TestValid(cin_stormtroopers_0[1]) and TestValid(atst_goto_0) then
					cin_stormtroopers_0[1].Move_To(atst_goto_0)
				end
				if TestValid(cin_stormtroopers_1[1]) and TestValid(atst_goto_1) then
					cin_stormtroopers_1[1].Move_To(atst_goto_1)
				end
				if TestValid(cin_stormtroopers_2[1]) and TestValid(atst_goto_2) then
					cin_stormtroopers_2[1].Move_To(atst_goto_2)
				end
			end
		end
	end	
end

function PROX_Poison_Plant_Area(prox_obj, trigger_obj)
	if trigger_obj.Get_Type().Get_Name() == "UNDERWORLD_MOBILE_DEFENSE_UNIT_PROLOGUE" then
		if mdu_defend_text and infantry_flower_text then
			mdu_defend_text = false
			Story_Event("TEXT_SPEECH_UNDERWORLD_PROLOGUE_FELUCIA_16")
		end
		--MessageBox("Flower Area tripped!  Sending units back to cover!")
		if TestValid(trigger_obj) then
			trigger_obj.Set_Selectable(false)
			if TestValid(mdu_0_spawn_loc) then
				trigger_obj.Move_To(mdu_0_spawn_loc)
			end
		end		        
	end
	
	if trigger_obj.Is_Category("Infantry") then
		if mdu_defend_text and infantry_flower_text then
			infantry_flower_text = false
			Story_Event("TEXT_SPEECH_UNDERWORLD_PROLOGUE_FELUCIA_17")
		end
		--MessageBox("Flower Area tripped!  Sending units back to cover!")
		parent = trigger_obj.Get_Parent_Object()
		if TestValid(parent) then
			trigger_obj.Set_Selectable(false)
			if TestValid(merc_spawn_loc_1) then
				parent.Move_To(merc_spawn_loc_1)
			end
		end
		if not TestValid(parent) then
			if TestValid(trigger_obj) then
				trigger_obj.Set_Selectable(false)
				if TestValid(merc_spawn_loc_1) then
					trigger_obj.Move_To(merc_spawn_loc_1)
				end
			end
		end				        
	end
end

function State_Underworld_Prologue_Felucia_Speech_Line_16_Remove_Text(message)
	if message == OnEnter then
		Sleep(5)
		mdu_defend_text = true
	end
end

function State_Underworld_Prologue_Felucia_Speech_Line_17_Remove_Text(message)
	if message == OnEnter then
		Sleep(5)
		infantry_flower_text = true
	end
end

function PROX_Infantry_Only_Area(prox_obj, trigger_obj)
	if trigger_obj.Get_Type().Get_Name() == "F9TZ_CLOAKING_TRANSPORT" then
        prox_obj.Cancel_Event_Object_In_Range(PROX_Infantry_Only_Area)
        Story_Event("TEXT_SPEECH_UNDERWORLD_PROLOGUE_FELUCIA_07")
        
        Create_Thread("Midtro_Infantry_Only")
	end
	if trigger_obj.Get_Type().Get_Name() == "F9TZ_CLOAKING_TRANSPORT" or trigger_obj.Get_Type().Get_Name() == "UNDERWORLD_MOBILE_DEFENSE_UNIT_PROLOGUE" then
		if TestValid(passable_rock) then
			--MessageBox("Swapping Rocks")
			passable_rock.Despawn()
			impassable_rock = Create_Generic_Object ("Prop_EndrRock_Cluster_03_No_Passability", rock_spawn, neutral)
		end
		if TestValid(passable_rock_2) then
			--MessageBox("Swapping Rocks")
			passable_rock_2.Despawn()
			impassable_rock_2 = Create_Generic_Object ("Prop_EndrRock_Cluster_03_No_Passability", rock_spawn_2, neutral)
		end
	end
end

function PROX_End_Infantry_Only_Area(prox_obj, trigger_obj)
	if trigger_obj.Get_Owner() == underworld then
        prox_obj.Cancel_Event_Object_In_Range(PROX_End_Infantry_Only_Area)
        
        turret_list = Find_All_Objects_Of_Type("EMPIRE_ANTI_INFANTRY_TURRET")
        
        for k, unit in pairs(turret_list) do
			if TestValid(unit) then				
				fog_id = FogOfWar.Reveal(underworld,unit,250,250)
			end
		end
        
        Create_Thread("Turret_Midtro", trigger_obj)        
	end
end

function PROX_Urai_End_Cinematic(prox_obj, trigger_obj)
	if trigger_obj.Get_Owner() == underworld then
        prox_obj.Cancel_Event_Object_In_Range(PROX_Urai_End_Cinematic)
        
        Create_Thread("End_Cinematic")
        
    end
end

function Story_Handle_Esc()
	if intro_started and not intro_done then
		if current_cinematic_thread ~= nil then
			if camera_step == 1 then
				Thread.Kill(current_cinematic_thread)
				current_cinematic_thread = nil
				Create_Thread("End_Camera")
				camera_step = 2
			end
			if camera_step == 0 then
				Thread.Kill(current_cinematic_thread)
				current_cinematic_thread = nil
				current_cinematic_thread = Create_Thread("Intro_Transition_Camera")
				camera_step = 1
			end
		end
	end
end

function Intro_Transition_Camera()
	
	Stop_All_Music()
	Stop_All_Speech()
	Remove_All_Text()
	
	landing_spot = Find_Hint ("STORY_TRIGGER_ZONE_00","landingarea")
	if TestValid(cin_tyber) then
		Transition_Cinematic_Target_Key(cin_tyber, 0, 0, 0, 0, 0, cin_tyber, 1, 1)
		Transition_Cinematic_Camera_Key(cin_tyber, 0, 150, 10, 0, 1, cin_tyber, 0, 0)
	end
	
	transport = Find_First_Object("UNDERWORLD_VEHICLE_TRANSPORT_LANDING_CIN")
	if TestValid(transport) then
		transport.Despawn()
	end
	
	transport = Find_First_Object("UNDERWORLD_VEHICLE_TRANSPORT_LANDING")
	if TestValid(transport) then
		transport.Despawn()
	end
	
	
	transport = Create_Cinematic_Transport("Underworld_Vehicle_Transport_Cinematic_Landing", underworld.Get_ID(), landing_spot, 342.67, 1, 1, 20, 1)
	
	Story_Event("PROLOGUE_FELUCIA_ESCAPEKEY_PREVENT_INTRO_DIALOG_AI_NOTIFICATION_0")
	
	merc_spawn_loc = Find_Hint ("STORY_TRIGGER_ZONE_00","mercspawn")
	cin_tyber_spawn_loc = Find_Hint ("STORY_TRIGGER_ZONE_00","tybercin")
	merc_squad_list = Spawn_Unit(Find_Object_Type("Underworld_Disruptor_Merc_Squad"), merc_spawn_loc, underworld)
	merc_list = Find_All_Objects_Of_Type("Underworld_Disruptor_Merc")
	if TestValid(tyber) then
		tyber.Hide(false)
		if TestValid(cin_tyber_spawn_loc) then
			tyber.Teleport_And_Face(cin_tyber_spawn_loc)
		end
	end
	
	
	merc_spawn_loc_1 = Find_Hint ("STORY_TRIGGER_ZONE_00","mercspawn1")
	merc_spawn_loc_2 = Find_Hint ("STORY_TRIGGER_ZONE_00","mercspawn2")
	merc_spawn_loc_3 = Find_Hint ("STORY_TRIGGER_ZONE_00","mercspawn3")	
	if not merc_squad_list1 then	
		merc_squad_list1 = Spawn_Unit(Find_Object_Type("Underworld_Merc_Squad"), merc_spawn_loc_1, underworld)
	end
	if not merc_squad_list3 then
		merc_squad_list3 = Spawn_Unit(Find_Object_Type("Underworld_Disruptor_Merc_Squad"), merc_spawn_loc_3, underworld)
	end
	
	urai_spawn_loc = Find_Hint("STORY_TRIGGER_ZONE_00", "uraispawn")
	if not urai_spawn or not TestValid(urai_spawn[1]) then
		--urai_spawn = Spawn_From_Reinforcement_Pool(Find_Object_Type("Urai_Fen_Team"), urai_spawn_loc, underworld)
	end
	if not urai_spawn or not TestValid(urai_spawn[1]) then
		urai_spawn = Spawn_Unit(Find_Object_Type("Urai_Fen_Prologue"), urai_spawn_loc, underworld)
	end
	urai = urai_spawn[1]				
	
	if TestValid(merc_squad_list[1]) and TestValid(cin_tyber) then
		merc_squad_list[1].Turn_To_Face(cin_tyber)
	end
	
	
	Fade_Screen_In(2)
	Sleep(.5)
	
	Story_Event("TEXT_SPEECH_UNDERWORLD_PROLOGUE_FELUCIA_02")
	
end

function End_Camera()
	
	Fade_Screen_Out(0)
	Transition_To_Tactical_Camera(0)
	
	transport = Find_First_Object("UNDERWORLD_VEHICLE_TRANSPORT_LANDING_CIN")
	if TestValid(transport) then
		transport.Despawn()
	end
	
	transport = Find_First_Object("UNDERWORLD_VEHICLE_TRANSPORT_LANDING")
	if TestValid(transport) then
		transport.Despawn()
	end
	
	landing_spot = Find_Hint ("STORY_TRIGGER_ZONE_00","landingarea")
	transport = Create_Cinematic_Transport("Underworld_Vehicle_Transport_Cinematic_Landing", underworld.Get_ID(), landing_spot, 342.67, 1, 1, 20, 1)
	
	Stop_All_Music()
	Stop_All_Speech()
	Remove_All_Text()
	
	Story_Event("PROLOGUE_FELUCIA_ESCAPEKEY_PREVENT_INTRO_DIALOG_AI_NOTIFICATION_1")
	
	
	for k, unit in pairs(merc_squad_list) do
		if TestValid(unit) then				
			unit.Despawn()
		end
	end
	
	urai_spawn_loc = Find_Hint("STORY_TRIGGER_ZONE_00", "uraispawn")
	
	if not urai_spawn or not TestValid(urai_spawn[1]) then
		urai_spawn = Spawn_Unit(Find_Object_Type("Urai_Fen_Prologue"), urai_spawn_loc, underworld)
	end
	urai = urai_spawn[1]
	
	if TestValid(tyber) then	
		tyber.Hide(false)
	end
	
	merc_spawn_loc_1 = Find_Hint ("STORY_TRIGGER_ZONE_00","mercspawn1")
	merc_spawn_loc_2 = Find_Hint ("STORY_TRIGGER_ZONE_00","mercspawn2")
	merc_spawn_loc_3 = Find_Hint ("STORY_TRIGGER_ZONE_00","mercspawn3")	
	
	if not merc_squad_list1 then
		merc_squad_list1 = Spawn_Unit(Find_Object_Type("Underworld_Merc_Squad"), merc_spawn_loc_1, underworld)
	end
	if not merc_squad_list3 then
		merc_squad_list3 = Spawn_Unit(Find_Object_Type("Underworld_Disruptor_Merc_Squad"), merc_spawn_loc_3, underworld)
	end
	
	Letter_Box_Out(0)
	intro_done = true
	
	Sleep(1)
	Fade_Screen_In(2)
	Sleep(2)
	Lock_Controls(0)
	End_Cinematic_Camera()
					
	Sleep(1)
	
	Story_Event("TEXT_SPEECH_UNDERWORLD_PROLOGUE_FELUCIA_13")
	
end


-- ************************************************************************
-- ***********************INTRO CINEMATIC FUNCTION*************************
-- ************************************************************************

function Intro_Cinematic ()	
	
	Suspend_AI(1)
	Lock_Controls(1)
	Start_Cinematic_Camera()
	Cancel_Fast_Forward()
	Letter_Box_In(0)	
	Fade_Screen_In(2)	
	
	--Set_Cinematic_Target_Key(target_pos, xoffset_dist, yoffset_pitch, zoffset_yaw, angles?, attach_object, use_object_rotation, cinematic_animation)
	if TestValid(trans_spawn_loc) then
		Set_Cinematic_Camera_Key(trans_spawn_loc, 200, -10, 230, 1, 0, 0, 0)
	end
	if TestValid(trans_goto_0) then
		Set_Cinematic_Target_Key(trans_goto_0, 0, 0, 200, 0, 0, 0, 0)
	end
	
	if TestValid(cin_transport) and TestValid(trans_goto_0) then
		cin_transport.Move_To(trans_goto_0)
	end
	
	cin_transport.Play_SFX_Event("Unit_Star_Destroyer_Cinematic_Engine_Loop")
	
	Sleep(1.5)
	--Shake_Camera(shake_amount, seconds)
	--Shake_Camera(0.8, 2)
	Sleep(1)
	
	
	-- ***********Opening Shot***************
	
	if TestValid(cin_transport) then
		Transition_Cinematic_Target_Key(cin_transport, 6, 0, 0, 0, 0, cin_transport, 1, 0)
		Transition_Cinematic_Camera_Key(cin_transport, 15, 325, 40, 210, 1, cin_transport, 1, 0)
	end
	Sleep(4)
	if TestValid(cin_transport) and TestValid(trans_goto_1) then
		cin_transport.Move_To(trans_goto_1)
	end
	Story_Event("TEXT_SPEECH_UNDERWORLD_PROLOGUE_FELUCIA_00")
	Sleep(8)
	if TestValid(cin_transport) and TestValid(trans_goto_2) then
		cin_transport.Move_To(trans_goto_2)
	end
end

function State_Underworld_Prologue_Felucia_Speech_Line_00_Remove_Text(message)
	if message == OnEnter then
		Story_Event("TEXT_SPEECH_UNDERWORLD_PROLOGUE_FELUCIA_01")
	end
end

function State_Underworld_Prologue_Felucia_Speech_Line_01_Remove_Text(message)
	if message == OnEnter then
		Sleep(2)
		Fade_Screen_Out(1)
		Sleep(1)
		
		if camera_step == 0 then
			camera_step = camera_step + 1
			if TestValid(cin_transport) then
				cin_transport.Despawn()
			end
			landing_spot = Find_Hint ("STORY_TRIGGER_ZONE_00","landingarea")
			transport = Find_First_Object("UNDERWORLD_VEHICLE_TRANSPORT_LANDING")
			if TestValid(transport) then
				transport.Despawn()
			end
			
			transport = Create_Cinematic_Transport("Underworld_Vehicle_Transport_Cinematic_Landing", underworld.Get_ID(), landing_spot, 342.67, 1, .35, 20, 1)
			Sleep(1)
			Fade_Screen_In(1)
			
			if TestValid(transport) then
				Transition_Cinematic_Target_Key(transport, 0, 0, 0, 0, 0, transport, 1, 1)
			end
			if TestValid(landing_spot) then
				Transition_Cinematic_Camera_Key(landing_spot, 0, 700, 10, -25, 1, landing_spot, 0, 0)
				Transition_Cinematic_Camera_Key(landing_spot, 6, 500, 22, 20, 1, landing_spot, 0, 0)
			end
			
			Sleep(5)
			Fade_Screen_Out(1)
			Sleep(1)
		
		
			merc_spawn_loc = Find_Hint ("STORY_TRIGGER_ZONE_00","mercspawn")
			cin_tyber_spawn_loc = Find_Hint ("STORY_TRIGGER_ZONE_00","tybercin")
			merc_squad_list = Spawn_Unit(Find_Object_Type("Underworld_Disruptor_Merc_Squad"), merc_spawn_loc, underworld)
			merc_list = Find_All_Objects_Of_Type("Underworld_Disruptor_Merc")
			
			if TestValid(tyber) and TestValid(cin_tyber_spawn_loc) then
				tyber.Teleport_And_Face(cin_tyber_spawn_loc)
				tyber.Hide(false)
			end
			
			merc_spawn_loc_1 = Find_Hint ("STORY_TRIGGER_ZONE_00","mercspawn1")
			merc_spawn_loc_2 = Find_Hint ("STORY_TRIGGER_ZONE_00","mercspawn2")
			merc_spawn_loc_3 = Find_Hint ("STORY_TRIGGER_ZONE_00","mercspawn3")	
			if not merc_squad_list1 then
				merc_squad_list1 = Spawn_Unit(Find_Object_Type("Underworld_Merc_Squad"), merc_spawn_loc_1, underworld)
			end
			if not merc_squad_list3 then
				merc_squad_list3 = Spawn_Unit(Find_Object_Type("Underworld_Disruptor_Merc_Squad"), merc_spawn_loc_3, underworld)
			end
			
			urai_spawn_loc = Find_Hint("STORY_TRIGGER_ZONE_00", "uraispawn")
			if not urai_spawn or not TestValid(urai_spawn[1]) then
				--urai_spawn = Spawn_From_Reinforcement_Pool(Find_Object_Type("Urai_Fen_Team"), urai_spawn_loc, underworld)
			end
			
			if not urai_spawn or not TestValid(urai_spawn[1]) then
				urai_spawn = Spawn_Unit(Find_Object_Type("Urai_Fen_Prologue"), urai_spawn_loc, underworld)
			end
			urai = urai_spawn[1]				
			
			if TestValid (merc_squad_list[1]) and TestValid (cin_tyber) then
				merc_squad_list[1].Turn_To_Face(cin_tyber)
			end
			
			if TestValid (merc_squad_list[1]) then
				Transition_Cinematic_Target_Key(cin_tyber, 0, 0, 0, 0, 0, 0, 1, 1)
			end
			if TestValid (cin_tyber) then
				Transition_Cinematic_Camera_Key(cin_tyber, 0, 100, 13, 45, 1, 0, 0, 0)
			end
			
			--if TestValid (merc_squad_list[1]) then
			--	Transition_Cinematic_Target_Key(merc_squad_list[1], 0, 0, 0, 0, 0, merc_squad_list[1], 1, 1)
			--end
			--if TestValid (cin_tyber) then
			--	Transition_Cinematic_Camera_Key(cin_tyber, 0, 85, 8, 75, 1, cin_tyber, 0, 0)
			--end
			
			Fade_Screen_In(1)
			Sleep(.5)
			
			tyber.Play_Animation("Cinematic",false,2)
			Story_Event("TEXT_SPEECH_UNDERWORLD_PROLOGUE_FELUCIA_02")
			
		end
	end
end

function State_Underworld_Prologue_Felucia_Speech_Line_02_Remove_Text(message)
	if message == OnEnter then
		
		tyber.Play_Animation("idle", false, 0)
		cincamera_goto_0 = Find_Hint ("STORY_TRIGGER_ZONE_00","cincameragoto0")
		
		if TestValid (merc_squad_list[1]) then
			Transition_Cinematic_Target_Key(merc_squad_list[1], 2, 0, 0, 0, 0, merc_squad_list[1], 1, 1)
		end
		
		if TestValid(cincamera_goto_0) then
			Transition_Cinematic_Camera_Key(cincamera_goto_0, 12, 100, 65, 0, 1, 0, 0, 0)
		end
		
		Sleep(1)
		
		
		
		merc_goto_0 = Find_Hint ("STORY_TRIGGER_ZONE_00","mercgoto0")
		for k, unit in pairs(merc_squad_list) do
			if TestValid(unit) and TestValid(merc_goto_0) then				
				unit.Move_To(merc_goto_0)
			end
		end
				
		Sleep(2)
		
		for k, unit in pairs(merc_list) do
			if TestValid(unit) then
				Sleep(.3)
				Create_Thread("Choke_And_Die", unit)
			end
		end
		
		Sleep(2)
		if TestValid(cin_tyber) then
			Transition_Cinematic_Target_Key(cin_tyber_spawn_loc, 3, 0, 0, 0, 0, 0, 1, 1)
			Transition_Cinematic_Camera_Key(cin_tyber, 6, 75, 15, -45, 1, 0, 0, 0)
		end
		
		tyber.Play_Animation("Cinematic",false,2)
		Story_Event("TEXT_SPEECH_UNDERWORLD_PROLOGUE_FELUCIA_03")
	end
end

function Choke_And_Die(unit)
	if TestValid(unit) then
		unit.Stop()
		unit.Play_Animation("Cinematic", false, 0)
		Sleep(2)
		unit.Take_Damage(50000)
	end
end

function State_Underworld_Prologue_Felucia_Speech_Line_03_Remove_Text(message)
	if message == OnEnter then
		tyber.Play_Animation("idle", false, 0)
		Fade_Screen_Out(1)
		Sleep(1)
		Fade_Screen_In(1)
		Transition_To_Tactical_Camera(0)
		Letter_Box_Out(0)
		End_Cinematic_Camera()
		Suspend_AI(0)
		
		intro_done = true
		Lock_Controls(0)
						
		Sleep(1)
		
		Story_Event("TEXT_SPEECH_UNDERWORLD_PROLOGUE_FELUCIA_13")
	end
end

function State_Underworld_Prologue_Felucia_Speech_Line_13_Remove_Text(message)
	if message == OnEnter then
		Story_Event("TEXT_SPEECH_UNDERWORLD_PROLOGUE_FELUCIA_14")
		Story_Event("ADD_OBJECTIVE_02")
	end
end

function State_Underworld_Prologue_Felucia_Speech_Line_14_Remove_Text(message)
	if message == OnEnter then
		objective_02_given = true
	end
end
		
function State_Underworld_Prologue_Felucia_Speech_Line_04_Remove_Text(message)
	if message == OnEnter then
		Story_Event("TEXT_SPEECH_UNDERWORLD_PROLOGUE_FELUCIA_05")
		Story_Event("ADD_OBJECTIVE_00")
		objective_00_given = true
		
	end
end

function Midtro_Infantry_Only()
	
	Suspend_AI(1)
	Lock_Controls(1)
	Start_Cinematic_Camera()
	Cancel_Fast_Forward()
	Letter_Box_In(0)	
	Fade_Screen_In(1)
	
	infantry_only = Find_Hint("STORY_TRIGGER_ZONE_00", "infonly")
	infantry_only_exit = Find_Hint("STORY_TRIGGER_ZONE_00", "infonlyend")
			
	--Set_Cinematic_Target_Key(target_pos, xoffset_dist, yoffset_pitch, zoffset_yaw, angles?, attach_object, use_object_rotation, cinematic_animation)
	if TestValid(infantry_only) then
		Set_Cinematic_Camera_Key(infantry_only, 700, 10, -105, 1, 0, 0, 0)
	end
	if TestValid(infantry_only_exit) then
		Set_Cinematic_Target_Key(infantry_only_exit, 0, 0, 20, 0, infantry_only_exit, 0, 0)
		Transition_Cinematic_Camera_Key(infantry_only_exit, 12, 300, 30, -90, 1, 0, 0, 0)
	end
	
	Sleep(2)
	infantry_transport = Find_First_Object("F9TZ_CLOAKING_TRANSPORT")
	if TestValid(infantry_transport) then
		infantry_transport.Stop()
	end
	Sleep(6)
	
	Story_Event("TEXT_SPEECH_UNDERWORLD_PROLOGUE_FELUCIA_15")
	
	if TestValid(passable_rock) then
		--MessageBox("Swapping Rocks")
		passable_rock.Despawn()
		impassable_rock = Create_Generic_Object ("Prop_EndrRock_Cluster_03_No_Passability", rock_spawn, neutral)
	end
	
	Transition_To_Tactical_Camera(0)
	Letter_Box_Out(0)
	End_Cinematic_Camera()
	Suspend_AI(0)
	Lock_Controls(0)
end

function State_Underworld_Prologue_Felucia_Speech_Line_15_Remove_Text(message)
	if message == OnEnter then
		
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_97")
	end
end

function State_Underworld_Prologue_Felucia_Speech_Line_97_Remove_Text(message)
	if message == OnEnter then
		
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_101")
	end
end

function Turret_Midtro(cine_focus)
	underworld_list = Find_All_Objects_Of_Type(underworld)
	for k, unit in pairs(underworld_list) do
		if TestValid(unit) then
			unit.Stop()
			unit.Prevent_All_Fire(true)
			unit.Make_Invulnerable(true)
		end
	end
	Sleep(.5)
	for k, unit in pairs(underworld_list) do
		if TestValid(unit) then
			unit.Suspend_Locomotor(true)
		end
	end
				
	Suspend_AI(1)
	Lock_Controls(1)
	Start_Cinematic_Camera()
	Cancel_Fast_Forward()
	Letter_Box_In(2)	
	--Fade_Screen_In(2)
	
	pad_0 = Find_Hint("EMPIRE_BUILD_PAD","pad0")
	pad_1 = Find_Hint("EMPIRE_BUILD_PAD","pad1")
	
	if TestValid(cine_focus) then
		Transition_Cinematic_Camera_Key(cine_focus, 8, 400, 30, -100, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(cine_focus, 4, 0, 0, 20, 0, 0, 0, 0)
	end
	
	Sleep(4)
	if TestValid(pad_0) then
		Transition_Cinematic_Target_Key(pad_0, 4, 0, 0, 20, 0, 0, 0, 0)
	end
	Sleep(2)
	if TestValid(pad_1) then
		Transition_Cinematic_Camera_Key(pad_1, 10, 200, 30, -150, 1, 0, 0, 0)
	end
	
	Sleep(3)
	Story_Event("TEXT_SPEECH_UNDERWORLD_PROLOGUE_FELUCIA_08")
	if TestValid(pad_1) then
		Transition_Cinematic_Target_Key(pad_1, 4, 0, 0, 20, 0, 1, 0, 0)
	end
	
	Sleep(3)
	
	
	Sleep(4)
	
	Suspend_AI(0)
	Lock_Controls(0)
	End_Cinematic_Camera()
	Letter_Box_Out(0)	
	Fade_Screen_In(2)
	
	Story_Event("UPDATE_OBJECTIVE_01")
	
	underworld_list = Find_All_Objects_Of_Type(underworld)
	for k, unit in pairs(underworld_list) do
		if TestValid(unit) then
			unit.Suspend_Locomotor(false)
			unit.Prevent_All_Fire(false)
			unit.Make_Invulnerable(false)
		end
	end
	
	Sleep(2)
	urai = Find_First_Object("Urai_Fen_Prologue")
    if TestValid(urai) then
		underworld.Select_Object(urai)
		Story_Event("FLASH_CLOAK")
	end
	
end

function End_Cinematic ()	
	
	underworld_list = Find_All_Objects_Of_Type(underworld)
	for k, unit in pairs(underworld_list) do
		if TestValid(unit) then
			unit.Stop()
		end
	end
	
	Sleep(.5)
		
	for k, unit in pairs(underworld_list) do
		if TestValid(unit) then
			unit.Suspend_Locomotor(true)
			unit.Prevent_All_Fire(true)
			unit.Make_Invulnerable(true)
			if TestValid(merc_spawn_loc_1) then
				unit.Teleport_And_Face(merc_spawn_loc_1)
			end
		end
	end
	
	end_cine_started = true
	
	Suspend_AI(1)
	Lock_Controls(1)
	Start_Cinematic_Camera()
	Cancel_Fast_Forward()
	Letter_Box_In(0)	
	Fade_Screen_In(2)
	
	empire_list = Find_All_Objects_Of_Type(empire)
	for k, unit in pairs(empire_list) do
		if TestValid(unit) then
			unit.Suspend_Locomotor(true)
			unit.Prevent_All_Fire(true)
		end
	end
	
	urai_attack_loc = Find_Hint("STORY_TRIGGER_ZONE_00", "uraiattackloc")
	urai_spawn_loc = Find_Hint("STORY_TRIGGER_ZONE_00", "uraispawn")
		
	urai_cin_list = Spawn_Unit(Find_Object_Type("Urai_Fen_Prologue"), urai_spawn_loc, underworld)
	urai_cin = urai_cin_list[1]
	twilek = Find_First_Object("TWILEK_COMMANDO")
	noghri = Find_First_Object("NOGHRI_ASSASSIN")
	
	if TestValid(urai_cin) then
		urai_cin.Hide(true)
	end
	
	artifact = Find_First_Object("UM05_CINE_HOLOCRON")
	
	if TestValid(artifact) then
		Set_Cinematic_Camera_Key(artifact, 20, 25, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(artifact, 0, 0, 0, 0, 0, 0, 0)
		Transition_Cinematic_Camera_Key(artifact, 5, 20, 25, -35, 1, 0, 0, 0)
	end
	
	Sleep(3)
	if TestValid(noghri) then
		Transition_Cinematic_Target_Key(noghri, 5, 0, 0, 0, 0, 0, 0, 0)
		Transition_Cinematic_Camera_Key(noghri, 6, 75, 15, -65, 1, 0, 0, 0)
	end
	Sleep(4)
	
	noghri.Play_Animation("cinematic", true, 2)
	Story_Event("TEXT_SPEECH_UNDERWORLD_PROLOGUE_FELUCIA_09")
			
	--Transition_Cinematic_Camera_Key(noghri, 10, 300, 30, 90, 1, 0, 0, 0)
	if TestValid(urai_cin) then
		urai_cin.Activate_Ability("STEALTH", true)
		Sleep(.75)
		Sleep(.5)
		urai_cin.Prevent_All_Fire(true)
		if TestValid(urai_attack_loc) then
			urai_cin.Teleport_And_Face(urai_attack_loc)
		end
		urai_cin.Play_Animation("Attack", false, 0)
		urai_cin.Activate_Ability("STEALTH", false)
		urai_cin.Hide(false)
	end
	
	Sleep(.45)
	if TestValid(noghri) then
		noghri.Take_Damage(50000)
	end
	
	if TestValid(urai_cin) then
		urai_cin.Prevent_All_Fire(false)
	end
	
	Transition_Cinematic_Target_Key(artifact, 5, 0, 0, 0, 0, 0, 0, 0)
	
	if TestValid(noghri) then
		noghri.Make_Invulnerable(false)
		noghri.Suspend_Locomotor(false)		
		noghri.Prevent_All_Fire(false)
		if TestValid(urai_cin) then
			noghri.Attack_Target(urai_cin)
		end
	end
	if TestValid(twilek) then
		twilek.Make_Invulnerable(false)
		twilek.Suspend_Locomotor(false)
		twilek.Prevent_All_Fire(false)
		if TestValid(urai_cin) then
			twilek.Attack_Target(urai_cin)
		end
	end
	if TestValid(guard1[1]) then
		guard1[1].Make_Invulnerable(false)
		guard1[1].Suspend_Locomotor(false)
		guard1[1].Prevent_All_Fire(false)
		if TestValid(urai_cin) then
			guard1[1].Attack_Target(urai_cin)
		end
	end
	if TestValid(guard2[1]) then
		guard2[1].Make_Invulnerable(false)
		guard2[1].Suspend_Locomotor(false)
		guard2[1].Prevent_All_Fire(false)
		if TestValid(urai_cin) then
			guard2[1].Attack_Target(urai_cin)
		end
	end
	
	Story_Event("TEXT_SPEECH_UNDERWORLD_PROLOGUE_FELUCIA_10")
	
end

function State_Underworld_Prologue_Felucia_Speech_Line_11_Remove_Text(message)
	if message == OnEnter then
		urai_cin.Play_Animation("idle", true, 0)
		tyber.Play_Animation("Cinematic", true, 2)
		Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_64")
	end
end

function State_Underworld_Prologue_Felucia_Speech_Line_64_Remove_Text(message)
	if message == OnEnter then
		tyber.Play_Animation("idle", true, 0)
		if TestValid(urai_cin) then
			urai_cin.Reset_Ability_Counter()
			Sleep(1)
			urai_cin.Activate_Ability("STEALTH", true)
			Sleep(2)
			urai_cin.Despawn()
		end
		
		trooper_spawn_0 = Find_Hint("STORY_TRIGGER_ZONE_00", "trooperspawn0")
		trooper_spawn_1 = Find_Hint("STORY_TRIGGER_ZONE_00", "trooperspawn1")
		trooper_spawn_2 = Find_Hint("STORY_TRIGGER_ZONE_00", "trooperspawn2")
		
		trooper_goto_0 = Find_Hint("STORY_TRIGGER_ZONE_00", "troopergoto0")
		trooper_goto_1 = Find_Hint("STORY_TRIGGER_ZONE_00", "troopergoto1")
		trooper_goto_2 = Find_Hint("STORY_TRIGGER_ZONE_00", "troopergoto2")
		
		atst_spawn_0 = Find_Hint("STORY_TRIGGER_ZONE_00", "atstspawn0")
		atst_spawn_1 = Find_Hint("STORY_TRIGGER_ZONE_00", "atstspawn1")
		atst_spawn_2 = Find_Hint("STORY_TRIGGER_ZONE_00", "atstspawn2")
		
		atst_goto_0 = Find_Hint("STORY_TRIGGER_ZONE_00", "atstgoto0")
		atst_goto_1 = Find_Hint("STORY_TRIGGER_ZONE_00", "atstgoto1")
		atst_goto_2 = Find_Hint("STORY_TRIGGER_ZONE_00", "atstgoto2")
				
		dark_spawn_0 = Find_Hint("STORY_TRIGGER_ZONE_00", "darkspawn0")
		dark_spawn_1 = Find_Hint("STORY_TRIGGER_ZONE_00", "darkspawn1")
		dark_spawn_2 = Find_Hint("STORY_TRIGGER_ZONE_00", "darkspawn2")
		
		cin_trooper_0 = Spawn_Unit(Find_Object_Type("Dialogue_Stormtrooper"), trooper_spawn_0, empire)
		cin_trooper_1 = Spawn_Unit(Find_Object_Type("Dialogue_Stormtrooper"), trooper_spawn_1, empire)
		cin_trooper_2 = Spawn_Unit(Find_Object_Type("Dialogue_Stormtrooper"), trooper_spawn_2, empire)
		
		if TestValid(cin_trooper_0[1]) then
			cin_trooper_0[1].Prevent_All_Fire(true)
			if TestValid(trooper_goto_0) then
				cin_trooper_0[1].Move_To(trooper_goto_0)
			end
		end
		
		if TestValid(cin_trooper_1[1]) then
			cin_trooper_1[1].Prevent_All_Fire(true)
			if TestValid(trooper_goto_1) then
				cin_trooper_1[1].Move_To(trooper_goto_1)
			end
		end
		
		if TestValid(cin_trooper_2[1]) then
			cin_trooper_2[1].Prevent_All_Fire(true)
			if TestValid(trooper_goto_2) then
				cin_trooper_2[1].Move_To(trooper_goto_2)
			end
		end
		
		if TestValid(trooper_goto_0) then
			Register_Prox(trooper_goto_0, PROX_Dialog_Trooper, 5, empire)
		end
		
		if TestValid(atst_goto_0) then
			Register_Prox(atst_goto_0, PROX_Atst_Face_Tyber, 8, empire)
		end
		if TestValid(atst_goto_1) then
			Register_Prox(atst_goto_1, PROX_Atst_Face_Tyber, 8, empire)
		end
		if TestValid(atst_goto_2) then
			Register_Prox(atst_goto_2, PROX_Atst_Face_Tyber, 8, empire)
		end
		
		Sleep(2)
		if TestValid(tyber) then
			tyber.Suspend_Locomotor(false)
			if TestValid(trooper_spawn_1) then
				Transition_Cinematic_Target_Key(tyber, 2, 0, 0, 0, 0, tyber, 0, 0)
				tyber.Move_To(trooper_spawn_1)
			end
			Sleep(.75)
			
			Story_Event("TEXT_SPEECH_UNDERWORLD_TUTORIAL_65")
			Sleep(.2)
			tyber.Stop()
			
			
			
			--MessageBox("turning tyber fire ON --> 1")
			tyber.Prevent_All_Fire(false)
			--tyber.Attack_Target(cin_trooper_1[1])
		end
		cin_troopers_spawned = true
		if TestValid(cin_trooper_1[1]) then
			--Transition_Cinematic_Target_Key(cin_trooper_1[1], 6, 0, 0, 0, 0, cin_trooper_1[1], 0, 0)
			Transition_Cinematic_Camera_Key(tyber, 6, 250, 20, -40, 1, 0, 0, 0)
			Sleep(6)
			Transition_Cinematic_Camera_Key(tyber, 15, 400, 20, -40, 1, 0, 0, 0)
		end
	end
end

function PROX_Dialog_Trooper(prox_obj, trigger_obj)
	if trigger_obj.Get_Type().Get_Name() == "DIALOGUE_STORMTROOPER" then
        prox_obj.Cancel_Event_Object_In_Range(PROX_Dialog_Trooper)
        --MessageBox("Trooper Dialog triggered!")
        
        if TestValid(cin_trooper_0[1]) then
			--cin_trooper_0[1].Play_Animation("attackidle", true, 0)
		end
		if TestValid(cin_trooper_1[1]) then
			--cin_trooper_1[1].Play_Animation("attackidle", true, 0)
		end
		if TestValid(cin_trooper_2[1]) then
			--cin_trooper_2[1].Play_Animation("attackidle", true, 0)
		end
	end
end

function State_Underworld_Prologue_Felucia_Speech_Line_65_Remove_Text(message)
	if message == OnEnter then
		if TestValid(tyber) then
			Transition_Cinematic_Target_Key(tyber, 5, 0, 0, 0, 0, tyber, 0, 0)
		end
		
		if TestValid(cin_trooper_0[1]) then
			--cin_trooper_0[1].Stop()
		end
		if TestValid(cin_trooper_1[1]) then
			--cin_trooper_1[1].Stop()
		end
		if TestValid(cin_trooper_2[1]) then
			--cin_trooper_2[1].Stop()
		end
		
		Sleep(1)
		
		if TestValid(cin_trooper_0[1]) and TestValid(tyber) then
			cin_trooper_0[1].Turn_To_Face(tyber)
		end
		if TestValid(cin_trooper_1[1]) and TestValid(tyber) then
			cin_trooper_1[1].Turn_To_Face(tyber)
		end
		if TestValid(cin_trooper_2[1]) and TestValid(tyber) then
			cin_trooper_2[1].Turn_To_Face(tyber)
		end
		
		if TestValid(cin_trooper_0[1]) then
			--cin_trooper_0[1].Suspend_Locomotor(true)
		end
		if TestValid(cin_trooper_1[1]) then
			--cin_trooper_1[1].Suspend_Locomotor(true)
		end
		if TestValid(cin_trooper_2[1]) then
			--cin_trooper_2[1].Suspend_Locomotor(true)
		end
				
		Sleep(1.5)
		
		cin_dark_0 = Spawn_Unit(Find_Object_Type("Dark_Trooper_PhaseIII"), dark_spawn_0, empire)
		if TestValid(cin_dark_0[1]) then		
			cin_dark_0[1].Prevent_AI_Usage(true)
			cin_dark_0[1].Suspend_Locomotor(true)
			cin_dark_0[1].Prevent_All_Fire(true)
			if TestValid(tyber) then
				cin_dark_0[1].Face_Immediate(tyber)
			end
		end
		Sleep(.10)
		cin_dark_1 = Spawn_Unit(Find_Object_Type("Dark_Trooper_PhaseIII"), dark_spawn_1, empire)
		if TestValid(cin_dark_1[1]) then
			cin_dark_1[1].Prevent_AI_Usage(true)
			cin_dark_1[1].Suspend_Locomotor(true)
			cin_dark_1[1].Prevent_All_Fire(true)
			if TestValid(tyber) then
				cin_dark_1[1].Face_Immediate(tyber)
			end
		end
		Sleep(.10)
		cin_dark_2 = Spawn_Unit(Find_Object_Type("Dark_Trooper_PhaseIII"), dark_spawn_2, empire)
		if TestValid(cin_dark_2[1]) then
			cin_dark_2[1].Prevent_AI_Usage(true)
			cin_dark_2[1].Suspend_Locomotor(true)
			cin_dark_2[1].Prevent_All_Fire(true)
			if TestValid(tyber) then
				cin_dark_2[1].Face_Immediate(tyber)
			end
		end
		Sleep(.10)
		cin_atst_0 = Spawn_Unit(Find_Object_Type("AT_ST_Walker"), atst_spawn_0, empire)
		if TestValid(cin_atst_0[1]) then
			cin_atst_0[1].Prevent_AI_Usage(true)
			cin_atst_0[1].Move_To(atst_goto_0)
			cin_atst_0[1].Prevent_All_Fire(true)
			if TestValid(tyber) then
				cin_atst_0[1].Face_Immediate(tyber)
			end
		end
		Sleep(.10)
		cin_atst_1 = Spawn_Unit(Find_Object_Type("AT_ST_Walker"), atst_spawn_1, empire)
		if TestValid(cin_atst_1[1]) then
			cin_atst_1[1].Prevent_AI_Usage(true)
			cin_atst_1[1].Move_To(atst_goto_1)
			cin_atst_1[1].Prevent_All_Fire(true)
			if TestValid(tyber) then
				cin_atst_1[1].Face_Immediate(tyber)
			end
		end
		Sleep(.10)
		cin_atst_2 = Spawn_Unit(Find_Object_Type("AT_ST_Walker"), atst_spawn_2, empire)
		if TestValid(cin_atst_2[1]) then
			cin_atst_2[1].Prevent_AI_Usage(true)
			cin_atst_2[1].Move_To(atst_goto_2)
			cin_atst_2[1].Prevent_All_Fire(true)
			if TestValid(tyber) then
				cin_atst_2[1].Face_Immediate(tyber)
			end
		end	
		Sleep(.10)	
		cin_squad_0 = Spawn_Unit(Find_Object_Type("AT_ST_Walker"), trooper_spawn_0, empire)
		if TestValid(cin_squad_0[1]) then
			cin_squad_0[1].Prevent_AI_Usage(true)
			cin_squad_0[1].Prevent_All_Fire(true)
			if TestValid(tyber) then
				cin_squad_0[1].Face_Immediate(tyber)
			end
		end
		Sleep(.10)
		cin_squad_1 = Spawn_Unit(Find_Object_Type("AT_ST_Walker"), trooper_spawn_1, empire)
		if TestValid(cin_squad_1[1]) then
			cin_squad_1[1].Prevent_AI_Usage(true)
			cin_squad_1[1].Prevent_All_Fire(true)
			if TestValid(tyber) then
				cin_squad_1[1].Face_Immediate(tyber)
			end
		end
		Sleep(.10)
		cin_squad_2 = Spawn_Unit(Find_Object_Type("AT_ST_Walker"), trooper_spawn_2, empire)
		if TestValid(cin_squad_2[1]) then
			cin_squad_2[1].Prevent_AI_Usage(true)
			cin_squad_2[1].Prevent_All_Fire(true)
			if TestValid(tyber) then
				cin_squad_2[1].Face_Immediate(tyber)
			end
		end
		Sleep(.10)
		cin_stormtroopers_0 = Spawn_Unit(Find_Object_Type("Imperial_Stormtrooper_Squad"), trooper_spawn_0, empire)
		if TestValid(cin_stormtroopers_0[1]) then
			cin_stormtroopers_0[1].Prevent_AI_Usage(true)
			cin_stormtroopers_0[1].Prevent_All_Fire(true)
			if TestValid(tyber) then
				cin_stormtroopers_0[1].Face_Immediate(tyber)
			end
		end
		Sleep(.10)
		cin_stormtroopers_1 = Spawn_Unit(Find_Object_Type("Imperial_Stormtrooper_Squad"), trooper_spawn_1, empire)
		if TestValid(cin_stormtroopers_1[1]) then
			cin_stormtroopers_1[1].Prevent_AI_Usage(true)
			cin_stormtroopers_1[1].Prevent_All_Fire(true)
			if TestValid(tyber) then
				cin_stormtroopers_1[1].Face_Immediate(tyber)
			end
		end
		Sleep(.10)
		cin_stormtroopers_2 = Spawn_Unit(Find_Object_Type("Imperial_Stormtrooper_Squad"), trooper_spawn_2, empire)
		if TestValid(cin_stormtroopers_2[1]) then
			cin_stormtroopers_2[1].Prevent_AI_Usage(true)
			cin_stormtroopers_2[1].Prevent_All_Fire(true)
			if TestValid(tyber) then
				cin_stormtroopers_2[1].Face_Immediate(tyber)
			end
		end		
	end
end

function PROX_Atst_Face_Tyber(prox_obj, trigger_obj)
	if trigger_obj.Get_Type().Get_Name() == "AT_ST_WALKER" then
		--MessageBox("AtST prox hit.  Turn to face Tyber!")
        prox_obj.Cancel_Event_Object_In_Range(PROX_Atst_Face_Tyber)
		trigger_obj.Stop()
		if TestValid(tyber) then
			trigger_obj.Turn_To_Face(tyber)
		end
		end_atst_in_position = true
	end
end

function State_Underworld_Prologue_Felucia_Speech_Line_66_Remove_Text(message)
	if message == OnEnter then
		if TestValid(tyber) then	
			Transition_Cinematic_Camera_Key(tyber, 8, 1000, 30, -60, 1, 0, 1, 0)
			--Transition_Cinematic_Target_Key(cin_dark_1[1], 8, 0, 0, 0, 0, cin_dark_1[1], 0, 0)
		end
		tyber.Play_Animation("idle", true, 0)
		
		cin_dark_3 = Spawn_Unit(Find_Object_Type("Dark_Trooper_PhaseIII"), dark_spawn_0, empire)
		if TestValid(cin_dark_3[1]) then
			cin_dark_3[1].Prevent_AI_Usage(true)
			cin_dark_3[1].Prevent_All_Fire(true)
			cin_dark_3[1].Face_Immediate(tyber)
		end
		Sleep(.10)
		cin_dark_4 = Spawn_Unit(Find_Object_Type("Dark_Trooper_PhaseIII"), dark_spawn_1, empire)
		if TestValid(cin_dark_4[1]) then
			cin_dark_4[1].Prevent_AI_Usage(true)
			cin_dark_4[1].Prevent_All_Fire(true)
			cin_dark_4[1].Face_Immediate(tyber)
		end
		Sleep(.10)
		cin_dark_5 = Spawn_Unit(Find_Object_Type("Dark_Trooper_PhaseIII"), dark_spawn_2, empire)
		if TestValid(cin_dark_5[1]) then
			cin_dark_5[1].Prevent_AI_Usage(true)
			cin_dark_5[1].Prevent_All_Fire(true)
			cin_dark_5[1].Face_Immediate(tyber)
		end
		Sleep(.10)
		cin_atst_3 = Spawn_Unit(Find_Object_Type("AT_ST_Walker"), atst_spawn_0, empire)
		if TestValid(cin_atst_3[1]) then
			cin_atst_3[1].Prevent_AI_Usage(true)
			cin_atst_3[1].Prevent_All_Fire(true)
			cin_atst_3[1].Face_Immediate(tyber)
		end
		Sleep(.10)
		cin_atst_4 = Spawn_Unit(Find_Object_Type("AT_ST_Walker"), atst_spawn_1, empire)
		if TestValid(cin_atst_4[1]) then
			cin_atst_4[1].Prevent_AI_Usage(true)
			cin_atst_4[1].Prevent_All_Fire(true)
			cin_atst_4[1].Face_Immediate(tyber)
		end
		Sleep(.10)
		cin_atst_5 = Spawn_Unit(Find_Object_Type("AT_ST_Walker"), atst_spawn_2, empire)
		if TestValid(cin_atst_5[1]) then
			cin_atst_5[1].Prevent_AI_Usage(true)
			cin_atst_5[1].Prevent_All_Fire(true)
			cin_atst_5[1].Face_Immediate(tyber)
		end
		Sleep(.10)	
		cin_squad_3 = Spawn_Unit(Find_Object_Type("AT_ST_Walker"), trooper_spawn_0, empire)
		if TestValid(cin_squad_3[1]) then
			cin_squad_3[1].Prevent_AI_Usage(true)
			cin_squad_3[1].Prevent_All_Fire(true)
			cin_squad_3[1].Face_Immediate(tyber)
		end
		Sleep(.10)
		cin_squad_4 = Spawn_Unit(Find_Object_Type("AT_ST_Walker"), trooper_spawn_1, empire)
		if TestValid(cin_squad_4[1]) then
			cin_squad_4[1].Prevent_AI_Usage(true)
			cin_squad_4[1].Prevent_All_Fire(true)
			cin_squad_4[1].Face_Immediate(tyber)
		end
		Sleep(.10)
		cin_squad_5 = Spawn_Unit(Find_Object_Type("AT_ST_Walker"), trooper_spawn_2, empire)
		if TestValid(cin_squad_5[1]) then
			cin_squad_5[1].Prevent_AI_Usage(true)
			cin_squad_5[1].Prevent_All_Fire(true)
			cin_squad_5[1].Face_Immediate(tyber)
		end
		Sleep(.10)
		cin_stormtroopers_3 = Spawn_Unit(Find_Object_Type("Imperial_Stormtrooper_Squad"), trooper_spawn_0, empire)
		if TestValid(cin_stormtroopers_3[1]) then
			cin_stormtroopers_3[1].Prevent_AI_Usage(true)
			cin_stormtroopers_3[1].Prevent_All_Fire(true)
			cin_stormtroopers_3[1].Face_Immediate(tyber)
		end
		Sleep(.10)
		cin_stormtroopers_4 = Spawn_Unit(Find_Object_Type("Imperial_Stormtrooper_Squad"), trooper_spawn_1, empire)
		if TestValid(cin_stormtroopers_4[1]) then
			cin_stormtroopers_4[1].Prevent_AI_Usage(true)
			cin_stormtroopers_4[1].Prevent_All_Fire(true)
			cin_stormtroopers_4[1].Face_Immediate(tyber)
		end
		Sleep(.10)
		cin_stormtroopers_5 = Spawn_Unit(Find_Object_Type("Imperial_Stormtrooper_Squad"), trooper_spawn_2, empire)
		if TestValid(cin_stormtroopers_5[1]) then
			cin_stormtroopers_5[1].Prevent_AI_Usage(true)
			cin_stormtroopers_5[1].Prevent_All_Fire(true)
			cin_stormtroopers_5[1].Face_Immediate(tyber)
		end
		Sleep(.10)
		
		Sleep(7)	
		
		Story_Event("VICTORY_TRIGGER")
		
		Sleep(7)
		
		Letter_Box_Out(0)
		End_Cinematic_Camera()
		Suspend_AI(0)
		Lock_Controls(0)
		
		Story_Event("SET_FELUCIA_WON")
	end
end