
--*****************************************************--
--******* Outer Rim Sieges: Breaking Belderone ********--
--*****************************************************--

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")
require("eawx-util/StoryUtil")
require("eawx-util/UnitUtil")
require("eawx-util/MissionUtil")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	StoryModeEvents =
	{
		Battle_Start = Begin_Battle,
		Trigger_Allow_Retreat = State_Allow_Retreat,
	}

	convoy_list = {
		"SUPER_TRANSPORT_XI_CARGO_A",
		"SUPER_TRANSPORT_XI_CARGO_A",
		"SUPER_TRANSPORT_XI_CARGO_A",
		"SUPER_TRANSPORT_XI_CARGO_A",
		"SUPER_TRANSPORT_XI_CARGO_A",
		"SUPER_TRANSPORT_XI_CARGO_A",
	}

	republic_fleet_01_list = {
		"Victory_I_Star_Destroyer",
		"PDF_DHC",
		"Customs_Corvette",
		"CR90",
		"DP20",
		"DP20",
		"Arquitens",
	}
	republic_fleet_02_list = {
		"Venator_Star_Destroyer",
		"PDF_DHC",
		"PDF_DHC",
		"Customs_Corvette",
		"CR90",
		"DP20",
		"Arquitens",
	}
	republic_fleet_03_list = {
		"Victory_I_Star_Destroyer",
		"PDF_DHC",
		"Customs_Corvette",
		"CR90",
		"DP20",
		"Arquitens",
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")

	cinematic_one = false

	cinematic_one_skipped = false

	act_1_active = false

	grievous_soulless_one_active = false
	grievous_renitor_active = false
	grievous_munificent_active = false
	grievous_invisible_hand_active = false
	grievous_malevolence_active = false

	current_convoy_amount = 6
	max_amount_destroyed = false

	current_cinematic_thread_id = nil
end
function Begin_Battle(message)
	if message == OnEnter then
		MissionUtil.DisableRetreat("REBEL", true)
		MissionUtil.DisableRetreat("EMPIRE", true)

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-4")
		introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-5")
		introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-6")
		introcam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-7")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")
		introcam_target_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-4")

		rep_fleet_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-1")
		rep_fleet_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-2")
		rep_fleet_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-3")

		convoy_entry_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "convoy-entry")
		extraction_point_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "extraction-point")
		grievous_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "grievous")
		hero_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "hero")

		cis_fleet_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-fleet-1")
		cis_fleet_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-fleet-2")
		cis_fleet_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-fleet-3")
		cis_fleet_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-fleet-4")
		cis_fleet_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-fleet-5")
		cis_fleet_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-fleet-6")
		cis_fleet_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-fleet-7")
		cis_fleet_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-fleet-8")

		cis_heroes = Find_All_Objects_Of_Type(p_cis, "SpaceHero")
		for _,cis_hero in pairs(cis_heroes) do
			if TestValid(cis_hero) then
				cis_hero.Teleport_And_Face(hero_marker)
			end
		end

		mission_started = true
		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
		end
	end
end

function State_Allow_Retreat(message)
	if message == OnEnter then
		MissionUtil.MissionTextSpeech("BREAKING_BELDERONE", 5, 9.0, "Grievous_Loop", {r = 255, g = 255, b = 255})
		MissionUtil.SetMissionObjectiveComplete("BREAKING_BELDERONE", "CIS", 3)
		MissionUtil.DisableRetreat("REBEL", false)
	end
end

function State_Extraction_Reached(prox_obj, trigger_obj)
	if trigger_obj == extraction_point_marker then
		prox_obj.Hyperspace_Away(true)
		current_convoy_amount = current_convoy_amount - 1
	end
end

function Story_Handle_Esc()
	if mission_started then
		if p_cis.Is_Human() then
			if cinematic_one then
				if not cinematic_one_skipped then
					cinematic_one_skipped = true
	
					if current_cinematic_thread_id ~= nil then
						Thread.Kill(current_cinematic_thread_id)
						current_cinematic_thread_id = nil
					end

					if StoryUtil.GetDifficulty() == "EASY" then
						AI_Republic_01_Fleet = SpawnList(republic_fleet_01_list, rep_fleet_1_marker.Get_Position(), p_republic, true, true)
						Republic_AI_Fleet_01 = AI_Republic_01_Fleet[1]
						Republic_AI_Fleet_01.Teleport_And_Face(rep_fleet_1_marker)
					end
					if StoryUtil.GetDifficulty() == "NORMAL" then
						AI_Republic_01_Fleet = SpawnList(republic_fleet_01_list, rep_fleet_1_marker.Get_Position(), p_republic, true, true)
						Republic_AI_Fleet_01 = AI_Republic_01_Fleet[1]
						Republic_AI_Fleet_01.Teleport_And_Face(rep_fleet_1_marker)

						AI_Republic_03_Fleet = SpawnList(republic_fleet_03_list, rep_fleet_3_marker.Get_Position(), p_republic, true, true)
						Republic_AI_Fleet_03 = AI_Republic_03_Fleet[1]
						Republic_AI_Fleet_03.Teleport_And_Face(rep_fleet_3_marker)
					end
					if StoryUtil.GetDifficulty() == "HARD" then
						AI_Republic_01_Fleet = SpawnList(republic_fleet_02_list, rep_fleet_1_marker.Get_Position(), p_republic, true, true)
						Republic_AI_Fleet_01 = AI_Republic_01_Fleet[1]
						Republic_AI_Fleet_01.Teleport_And_Face(rep_fleet_1_marker)

						AI_Republic_03_Fleet = SpawnList(republic_fleet_03_list, rep_fleet_3_marker.Get_Position(), p_republic, true, true)
						Republic_AI_Fleet_03 = AI_Republic_03_Fleet[1]
						Republic_AI_Fleet_03.Teleport_And_Face(rep_fleet_3_marker)
					end

					convoy_ships = Find_All_Objects_Of_Type("SUPER_TRANSPORT_XI_CARGO_A")
					for _,convoy_ship in pairs(convoy_ships) do
						if TestValid(convoy_ship) then
							convoy_ship.Move_To(extraction_point_marker)
							convoy_ship.Prevent_AI_Usage(true)
							Register_Prox(convoy_ship, State_Extraction_Reached, 200, p_republic)
						end
					end

					MissionUtil.Set_To_Enemies(p_cis, p_republic)
					MissionUtil.CinematicSkippingCleanUp(attacker_marker)
					MissionUtil.CinematicEnvironmentOff()

					MissionUtil.SetObjectiveMissionSet("BREAKING_BELDERONE", "CIS", 3)
					MissionUtil.MissionTextSpeech("BREAKING_BELDERONE", 4, 9.0, "Grievous_Loop", {r = 255, g = 255, b = 255})

					cinematic_one = false
					act_1_active = true

					Fade_Screen_In(0.5)
				end
			end
		end
	end 
end
function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_1_active then
			if current_convoy_amount < 6 and not max_amount_destroyed then
				local player_new_convoy = Spawn_Unit(Find_Object_Type("SUPER_TRANSPORT_XI_CARGO_A"), convoy_entry_marker, p_republic)
				player_new_convoy = Find_Nearest(convoy_entry_marker, p_republic, true)
				player_new_convoy.Teleport_And_Face(convoy_entry_marker)
				player_new_convoy.Cinematic_Hyperspace_In(GameRandom.Free_Random(10, 1000))
				player_new_convoy.Move_To(extraction_point_marker)
				player_new_convoy.Prevent_AI_Usage(true)

				current_convoy_amount = current_convoy_amount + 1
			end
		end
	end
end

function Start_Cinematic_Intro_CIS()
	AI_Republic_02_Fleet = SpawnList(republic_fleet_02_list, rep_fleet_2_marker.Get_Position(), p_republic, true, true)
	Republic_AI_Fleet_02 = AI_Republic_02_Fleet[1]
	Republic_AI_Fleet_02.Teleport_And_Face(rep_fleet_2_marker)

	Convoy_Fleet = SpawnList(convoy_list, convoy_entry_marker.Get_Position(), p_republic, false, false)
	Republic_Convoy_Fleet = Convoy_Fleet[1]
	Republic_Convoy_Fleet.Teleport_And_Face(convoy_entry_marker)

	Spawn_From_Reinforcement_Pool(Find_Object_Type("Munificent"), cis_fleet_1_marker, p_cis)
	Spawn_From_Reinforcement_Pool(Find_Object_Type("Munificent"), cis_fleet_2_marker, p_cis)
	Spawn_From_Reinforcement_Pool(Find_Object_Type("Munificent"), cis_fleet_3_marker, p_cis)
	Spawn_From_Reinforcement_Pool(Find_Object_Type("Munificent"), cis_fleet_4_marker, p_cis)
	Spawn_From_Reinforcement_Pool(Find_Object_Type("Munificent"), cis_fleet_5_marker, p_cis)

	Spawn_From_Reinforcement_Pool(Find_Object_Type("Lucrehulk_Core_Destroyer"), cis_fleet_4_marker, p_cis)
	Spawn_From_Reinforcement_Pool(Find_Object_Type("Lucrehulk_Core_Destroyer"), cis_fleet_5_marker, p_cis)

	Spawn_From_Reinforcement_Pool(Find_Object_Type("Recusant_Light_Destroyer"), cis_fleet_8_marker, p_cis)
	Spawn_From_Reinforcement_Pool(Find_Object_Type("Recusant_Light_Destroyer"), cis_fleet_7_marker, p_cis)
	Spawn_From_Reinforcement_Pool(Find_Object_Type("Recusant_Light_Destroyer"), cis_fleet_6_marker, p_cis)
	Spawn_From_Reinforcement_Pool(Find_Object_Type("Recusant_Light_Destroyer"), cis_fleet_5_marker, p_cis)
	Spawn_From_Reinforcement_Pool(Find_Object_Type("Recusant_Light_Destroyer"), cis_fleet_4_marker, p_cis)

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()
	Fade_On()

	local GrievousObjectNames = {
		"Grievous_Malevolence_Hunt_Campaign",
		"Grievous_Malevolence_2",
		"Grievous_Malevolence",
		"Grievous_Recusant",
		"Grievous_Invisible_Hand",
		"Grievous_Munificent",
	}
	for _,GrievousObjectName in pairs(GrievousObjectNames) do
		Spawn_From_Reinforcement_Pool(Find_Object_Type(GrievousObjectName), grievous_marker, Find_Player("Rebel"))
		GrievousObject = Find_First_Object(GrievousObjectName)
		if TestValid(GrievousObject) then
			player_grievous = GrievousObject
		end
	end
	if not TestValid(player_grievous) then
		player_grievous = MissionUtil.SpawnUnitSpace("GRIEVOUS_INVISIBLE_HAND", grievous_marker, p_cis, 300)
	end

	cinematic_one = true
	MissionUtil.PlayGenericMusic("Anakin_vs_ObiWan_Theme")
	Sleep(1.5)

	Fade_Screen_In(6.0)
	Letter_Box_In(6.0)

	MissionUtil.MissionTextSpeech("BREAKING_BELDERONE", 1, 9.0, nil, {r = 255, g = 255, b = 255})
	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, true, 9.0, nil, nil)
	Sleep(10.0)

	convoy_ships = Find_All_Objects_Of_Type("SUPER_TRANSPORT_XI_CARGO_A")
	for _,convoy_ship in pairs(convoy_ships) do
		if TestValid(convoy_ship) then
			convoy_ship.Move_To(extraction_point_marker)
			convoy_ship.Prevent_AI_Usage(true)
			Register_Prox(convoy_ship, State_Extraction_Reached, 200, p_republic)
		end
	end

	MissionUtil.MissionTextSpeech("BREAKING_BELDERONE", 2, 9.0, nil, {r = 255, g = 255, b = 255})
	MissionUtil.SetCinematicCamera(introcam_3_marker, convoy_entry_marker, true, nil, nil)
	Cinematic_Zoom(4.5, 0.4)
	Sleep(4.5)

	MissionUtil.SetCinematicCamera(introcam_4_marker, convoy_entry_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_5_marker, introcam_target_3_marker, true, 7.5, nil, nil)
	Sleep(5.0)

	MissionUtil.MissionTextSpeech("BREAKING_BELDERONE", 3, 9.0, nil, {r = 255, g = 255, b = 255})
	Sleep(2.5)

	MissionUtil.SetCinematicCamera(introcam_6_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_7_marker, introcam_target_4_marker, true, 7.0, nil, nil)
	Sleep(7.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end
function End_Cinematic_Intro_CIS()
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(grievous_marker, 3.5)
	Sleep(3.5)

	Story_Event("TRAPPED_04")

	if StoryUtil.GetDifficulty() == "EASY" then
		AI_Republic_01_Fleet = SpawnList(republic_fleet_01_list, rep_fleet_1_marker.Get_Position(), p_republic, true, true)
		Republic_AI_Fleet_01 = AI_Republic_01_Fleet[1]
		Republic_AI_Fleet_01.Teleport_And_Face(rep_fleet_1_marker)
	end
	if StoryUtil.GetDifficulty() == "NORMAL" then
		AI_Republic_01_Fleet = SpawnList(republic_fleet_01_list, rep_fleet_1_marker.Get_Position(), p_republic, true, true)
		Republic_AI_Fleet_01 = AI_Republic_01_Fleet[1]
		Republic_AI_Fleet_01.Teleport_And_Face(rep_fleet_1_marker)

		AI_Republic_03_Fleet = SpawnList(republic_fleet_03_list, rep_fleet_3_marker.Get_Position(), p_republic, true, true)
		Republic_AI_Fleet_03 = AI_Republic_03_Fleet[1]
		Republic_AI_Fleet_03.Teleport_And_Face(rep_fleet_3_marker)
	end
	if StoryUtil.GetDifficulty() == "HARD" then
		AI_Republic_01_Fleet = SpawnList(republic_fleet_02_list, rep_fleet_1_marker.Get_Position(), p_republic, true, true)
		Republic_AI_Fleet_01 = AI_Republic_01_Fleet[1]
		Republic_AI_Fleet_01.Teleport_And_Face(rep_fleet_1_marker)

		AI_Republic_03_Fleet = SpawnList(republic_fleet_03_list, rep_fleet_3_marker.Get_Position(), p_republic, true, true)
		Republic_AI_Fleet_03 = AI_Republic_03_Fleet[1]
		Republic_AI_Fleet_03.Teleport_And_Face(rep_fleet_3_marker)
	end

	MissionUtil.Set_To_Enemies(p_cis, p_republic)

	MissionUtil.MissionTextSpeech("BREAKING_BELDERONE", 4, 9.0, "Grievous_Loop", {r = 255, g = 255, b = 255})
	MissionUtil.SetObjectiveMissionSet("BREAKING_BELDERONE", "CIS", 3)
	MissionUtil.AIActivation()

	cinematic_one = false
	act_1_active = true
end
