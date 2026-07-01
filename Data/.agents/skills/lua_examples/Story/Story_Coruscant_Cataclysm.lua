
--*****************************************************--
--**************** Rimward: Water World ***************--
--*****************************************************--

require("PGBase")
require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")
require("TRCommands")
require("eawx-util/StoryUtil")
require("eawx-util/MissionUtil")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	StoryModeEvents =
	{
		Battle_Start = Begin_Battle,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_neutral = Find_Player("Neutral")

	republic_defender_easy_01_list = {
		"Victory_II_Star_Destroyer",
		"Victory_I_Frigate",
		"DP20",
		"DP20",
	}
	republic_defender_easy_02_list = {
		"Venator_Star_Destroyer",
		"Acclamator_II",
		"Acclamator_II",
		"Class_C_Support",
		"Class_C_Support",
	}
	republic_defender_easy_03_list = {
		"Venator_Star_Destroyer",
		"Rep_DHC",
		"Class_C_Support",
		"Class_C_Support",
		"Class_C_Support",
		"Lancer_Frigate_Prototype",
		"Lancer_Frigate_Prototype",
		"Lancer_Frigate_Prototype",
		"Lancer_Frigate_Prototype",
		"Lancer_Frigate_Prototype",
		"CR90",
		"CR90",
		"CR90",
		"CR90",
		"CR90",
	}

	republic_defender_normal_01_list = {
		"Victory_II_Star_Destroyer",
		"Victory_II_Star_Destroyer",
		"Victory_I_Frigate",
		"DP20",
		"DP20",
		"DP20",
	}
	republic_defender_normal_02_list = {
		"Venator_Star_Destroyer",
		"Venator_Star_Destroyer",
		"Acclamator_II",
		"Acclamator_II",
		"Class_C_Support",
		"Class_C_Support",
		"Class_C_Support",
	}
	republic_defender_normal_03_list = {
		"Venator_Star_Destroyer",
		"Rep_DHC",
		"Class_C_Support",
		"Lancer_Frigate_Prototype",
		"Lancer_Frigate_Prototype",
		"Lancer_Frigate_Prototype",
		"Lancer_Frigate_Prototype",
		"Lancer_Frigate_Prototype",
		"CR90",
		"CR90",
		"CR90",
		"CR90",
		"CR90",
	}

	republic_defender_hard_01_list = {
		"Victory_II_Star_Destroyer",
		"Victory_II_Star_Destroyer",
		"Victory_II_Star_Destroyer",
		"Victory_I_Frigate",
		"Victory_I_Frigate",
		"Victory_I_Frigate",
		"DP20",
		"DP20",
		"DP20",
	}
	republic_defender_hard_02_list = {
		"Venator_Star_Destroyer",
		"Venator_Star_Destroyer",
		"Venator_Star_Destroyer",
		"Acclamator_II",
		"Acclamator_II",
		"Acclamator_II",
		"Class_C_Support",
		"Class_C_Support",
		"Class_C_Support",
	}
	republic_defender_hard_03_list = {
		"Venator_Star_Destroyer",
		"Venator_Star_Destroyer",
		"Rep_DHC",
		"Rep_DHC",
		"Class_C_Support",
		"Class_C_Support",
		"Lancer_Frigate_Prototype",
		"Lancer_Frigate_Prototype",
		"Lancer_Frigate_Prototype",
		"Lancer_Frigate_Prototype",
		"Lancer_Frigate_Prototype",
		"CR90",
		"CR90",
		"CR90",
		"CR90",
		"CR90",
	}

	republic_avenger_easy_list = {
		"Yularen_Integrity",
		"Venator_Star_Destroyer",
		"Venator_Star_Destroyer",
		"Acclamator_II",
		"Acclamator_II",
		"Charger_C70",
		"Charger_C70",
	}
	republic_avenger_normal_list = {
		"Yularen_Integrity",
		"Venator_Star_Destroyer",
		"Venator_Star_Destroyer",
		"Venator_Star_Destroyer",
		"Acclamator_II",
		"Acclamator_II",
		"Acclamator_II",
		"Charger_C70",
		"Charger_C70",
		"Charger_C70",
		"Charger_C70",
	}
	republic_avenger_hard_list = {
		"Yularen_Integrity",
		"Venator_Star_Destroyer",
		"Venator_Star_Destroyer",
		"Venator_Star_Destroyer",
		"Venator_Star_Destroyer",
		"Acclamator_II",
		"Acclamator_II",
		"Acclamator_II",
		"Acclamator_II",
		"Charger_C70",
		"Charger_C70",
		"Charger_C70",
		"Charger_C70",
		"Charger_C70",
	}

	act_1_active = false
	act_2_active = false

	cinematic_one = false
	cinematic_two = false

	cinematic_one_skipped = false
	cinematic_two_skipped = false

	avenger_fleet_arrived = false

	mission_started = false
end
function Begin_Battle(message)
	if message == OnEnter then
		MissionUtil.VictoryAllowance(false)

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-4")
		introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-5")
		introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-6")
		introcam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-7")
		introcam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-8")
		introcam_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-9")
		introcam_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-10")
		introcam_11_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-11")
		introcam_12_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-12")
		introcam_13_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-13")
		introcam_14_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-14")
		introcam_15_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-15")
		introcam_16_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-16")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")
		introcam_target_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-4")
		introcam_target_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-5")
		introcam_target_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-6")
		introcam_target_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-7")
		introcam_target_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-8")
		introcam_target_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-9")
		introcam_target_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-10")
		introcam_target_11_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-11")
		introcam_target_12_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-12")
		introcam_target_13_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-13")
		introcam_target_14_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-14")
		introcam_target_15_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-15")
		introcam_target_16_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-16")

		intro_1_attacker_hero_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-cassus")
		intro_1_attacker_hero_02_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-mandalore")

		intro_1_attacker_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-mando-1")
		intro_1_attacker_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-mando-2")
		intro_1_attacker_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-mando-3")
		intro_1_attacker_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-mando-4")
		intro_1_attacker_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-mando-5")
		intro_1_attacker_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-mando-6")

		rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-1")
		rep_fleet_02_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-2")
		rep_fleet_03_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-3")
		rep_fleet_04_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-4")
		rep_fleet_05_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-5")

		mission_started = true
		if p_cis.Is_Human() then
			MissionUtil.DisableRetreat("EMPIRE", true)
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
		elseif p_republic.Is_Human() then
			MissionUtil.DisableRetreat("REBEL", true)
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
		end
	end
end

function State_Avenger_Fleet_Arrives()
	if not avenger_fleet_arrived then
		avenger_fleet_arrived = true
		act_2_active = true
		if StoryUtil.GetDifficulty() == "EASY" then
			AI_Republic_Fleet = SpawnList(republic_avenger_easy_list, rep_fleet_01_marker.Get_Position(), p_republic, true, true)
			Republic_AI_Fleet = AI_Republic_Fleet[1]
			Republic_AI_Fleet.Teleport_And_Face(rep_fleet_01_marker)
			Republic_AI_Fleet.Cinematic_Hyperspace_In(150)
		end
		if StoryUtil.GetDifficulty() == "NORMAL" then
			AI_Republic_Fleet = SpawnList(republic_avenger_normal_list, rep_fleet_01_marker.Get_Position(), p_republic, true, true)
			Republic_AI_Fleet = AI_Republic_Fleet[1]
			Republic_AI_Fleet.Teleport_And_Face(rep_fleet_01_marker)
			Republic_AI_Fleet.Cinematic_Hyperspace_In(150)
		end
		if StoryUtil.GetDifficulty() == "HARD" then
			AI_Republic_Fleet = SpawnList(republic_avenger_hard_list, rep_fleet_01_marker.Get_Position(), p_republic, true, true)
			Republic_AI_Fleet = AI_Republic_Fleet[1]
			Republic_AI_Fleet.Teleport_And_Face(rep_fleet_01_marker)
			Republic_AI_Fleet.Cinematic_Hyperspace_In(150)

		end

		MissionUtil.MissionTextSpeech("CORUSCANT_CATACLYSM", 20, 10.0, nil, {r = 247, g = 201, b = 13}) -- Mandalorian Officer
	end
end

function Story_Handle_Esc()
	if p_cis.Is_Human() then
		if cinematic_one then
			if not cinematic_one_skipped then
				cinematic_one_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				local GrievousObjectNames = {
					"Grievous_Malevolence_Hunt_Campaign",
					"Grievous_Malevolence_2",
					"Grievous_Malevolence",
					"Grievous_Recusant",
					"Grievous_Invisible_Hand",
					"Grievous_Munificent",
				}
				for _,GrievousObjectName in pairs(GrievousObjectNames) do
					Spawn_From_Reinforcement_Pool(Find_Object_Type(GrievousObjectName), intro_1_attacker_1_marker, Find_Player("Rebel"))
					GrievousObject = Find_First_Object(GrievousObjectName)
					if TestValid(GrievousObject) then
						player_grievous = GrievousObject
					end
				end
				if not TestValid(player_grievous) then
					player_grievous = MissionUtil.SpawnUnitSpace("GRIEVOUS_INVISIBLE_HAND", intro_1_attacker_1_marker, p_cis, 300)
				end

				MissionUtil.SpawnUnitSpace("PROVIDENCE_DESTROYER", intro_1_attacker_1_marker, p_cis)
				MissionUtil.SpawnUnitSpace("PROVIDENCE_DESTROYER", intro_1_attacker_2_marker, p_cis)

				MissionUtil.SpawnUnitSpace("PROVIDENCE_DESTROYER", intro_1_attacker_3_marker, p_cis)
				MissionUtil.SpawnUnitSpace("PROVIDENCE_DESTROYER", intro_1_attacker_4_marker, p_cis)

				MissionUtil.SpawnUnitSpace("PROVIDENCE_DESTROYER", intro_1_attacker_5_marker, p_cis)
				MissionUtil.SpawnUnitSpace("PROVIDENCE_DESTROYER", intro_1_attacker_6_marker, p_cis)

				MissionUtil.SetObjectiveMissionSet("CORUSCANT_CATACLYSM", "CIS", 2)

				MissionUtil.CinematicSkippingCleanUp(Find_First_Object("ATTACKER ENTRY POSITION"))

				if StoryUtil.GetDifficulty() == "EASY" then
					Register_Timer(State_Avenger_Fleet_Arrives, 300)
				end
				if StoryUtil.GetDifficulty() == "NORMAL" then
					Register_Timer(State_Avenger_Fleet_Arrives, 240)
				end
				if StoryUtil.GetDifficulty() == "HARD" then
					Register_Timer(State_Avenger_Fleet_Arrives, 180)
				end

				cinematic_one = false
				act_1_active = true

				Fade_Screen_In(0.5)
			end
		end
		if cinematic_two then
			if not cinematic_two_skipped then
				cinematic_two_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				cinematic_two = false

				MissionUtil.CinematicEnvironmentOff()
				MissionUtil.DisableRetreat("EMPIRE", false)
				MissionUtil.VictoryAllowance(true)

				StoryUtil.DeclareVictory(p_cis, false)
			end
		end
	end
end
function Story_Mode_Service()
	if act_1_active then
		local cis_list = Find_All_Objects_Of_Type(p_cis, "SpaceHero | Gunship | Corvette | Capital | Frigate | SpaceStructure | SuperCapital")
		if (table.getn(cis_list) == 0) then
			StoryUtil.DeclareVictory(p_republic, false)
			act_1_active = false
		end
		local rep_list = Find_All_Objects_Of_Type(p_republic, "SpaceHero | Gunship | Corvette | Capital | Frigate | SuperCapital")
		if (table.getn(rep_list) == 0) then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
			act_1_active = false
		end
	end
end


function Start_Cinematic_Intro_CIS()
	--StoryUtil.DeclareVictory(p_cis, false)

	if StoryUtil.GetDifficulty() == "EASY" then
		SpawnList(republic_defender_easy_01_list, rep_fleet_01_marker.Get_Position(), p_republic, true, true)
		SpawnList(republic_defender_easy_02_list, rep_fleet_02_marker.Get_Position(), p_republic, true, true)
		SpawnList(republic_defender_easy_03_list, rep_fleet_03_marker.Get_Position(), p_republic, true, true)
	end
	if StoryUtil.GetDifficulty() == "NORMAL" then
		SpawnList(republic_defender_normal_01_list, rep_fleet_01_marker.Get_Position(), p_republic, true, true)
		SpawnList(republic_defender_normal_02_list, rep_fleet_02_marker.Get_Position(), p_republic, true, true)
		SpawnList(republic_defender_normal_03_list, rep_fleet_03_marker.Get_Position(), p_republic, true, true)
	end
	if StoryUtil.GetDifficulty() == "HARD" then
		SpawnList(republic_defender_hard_01_list, rep_fleet_01_marker.Get_Position(), p_republic, true, true)
		SpawnList(republic_defender_hard_02_list, rep_fleet_02_marker.Get_Position(), p_republic, true, true)
		SpawnList(republic_defender_hard_03_list, rep_fleet_03_marker.Get_Position(), p_republic, true, true)
	end

	cinematic_one = true

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	Sleep(1.0)

	MissionUtil.CinematicIntroHeader("CORUSCANT_CATACLYSM")
	MissionUtil.PlayGenericMusic("Battle_of_Coruscant_Theme")

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, true, 12.5, nil, nil)

	Fade_Screen_In(4.0)
	Letter_Box_In(1.0)
	Sleep(10.0)

	Fade_Screen_Out(3.0)
	Sleep(6.0)

	local GrievousObjectNames = {
		"Grievous_Malevolence_Hunt_Campaign",
		"Grievous_Malevolence_2",
		"Grievous_Malevolence",
		"Grievous_Recusant",
		"Grievous_Invisible_Hand",
		"Grievous_Munificent",
	}
	for _,GrievousObjectName in pairs(GrievousObjectNames) do
		Spawn_From_Reinforcement_Pool(Find_Object_Type(GrievousObjectName), intro_1_attacker_1_marker, Find_Player("Rebel"))
		GrievousObject = Find_First_Object(GrievousObjectName)
		if TestValid(GrievousObject) then
			player_grievous = GrievousObject
		end
	end
	if not TestValid(player_grievous) then
		player_grievous = MissionUtil.SpawnUnitSpace("GRIEVOUS_INVISIBLE_HAND", intro_1_attacker_1_marker, p_cis, 300)
	end

	MissionUtil.SpawnUnitSpace("PROVIDENCE_DESTROYER", intro_1_attacker_1_marker, p_cis)
	MissionUtil.SpawnUnitSpace("PROVIDENCE_DESTROYER", intro_1_attacker_2_marker, p_cis)

	MissionUtil.SpawnUnitSpace("PROVIDENCE_DESTROYER", intro_1_attacker_3_marker, p_cis)
	MissionUtil.SpawnUnitSpace("PROVIDENCE_DESTROYER", intro_1_attacker_4_marker, p_cis)

	MissionUtil.SpawnUnitSpace("PROVIDENCE_DESTROYER", intro_1_attacker_5_marker, p_cis)
	MissionUtil.SpawnUnitSpace("PROVIDENCE_DESTROYER", intro_1_attacker_6_marker, p_cis)

	Fade_Screen_In(3.0)
	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_4_marker, true, 13.0, nil, nil)

	MissionUtil.MissionTextSpeech("CORUSCANT_CATACLYSM", 1, 12.0, nil, {r = 46, g = 121, b = 216}) -- Dallan Morvis
	MissionUtil.MissionTextSpeech("CORUSCANT_CATACLYSM", 2, 12.0, nil, {r = 46, g = 121, b = 216}) -- Dallan Morvis
	Sleep(13.0)

	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_5_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_6_marker, true, 13.0, nil, nil)

	MissionUtil.MissionTextSpeech("CORUSCANT_CATACLYSM", 3, 12.0, nil, {r = 46, g = 121, b = 216}) -- Saul Karath
	MissionUtil.MissionTextSpeech("CORUSCANT_CATACLYSM", 4, 12.0, nil, {r = 46, g = 121, b = 216}) -- Saul Karath
	Sleep(13.0)

	MissionUtil.SetCinematicCamera(introcam_7_marker, introcam_target_7_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_8_marker, introcam_target_8_marker, true, 13.0, nil, nil)

	MissionUtil.MissionTextSpeech("CORUSCANT_CATACLYSM", 5, 12.0, nil, {r = 46, g = 121, b = 216}) -- Saul Karath
	MissionUtil.MissionTextSpeech("CORUSCANT_CATACLYSM", 6, 12.0, nil, {r = 46, g = 121, b = 216}) -- Saul Karath
	Sleep(13.0)

	MissionUtil.SetCinematicCamera(introcam_9_marker, introcam_target_9_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_10_marker, introcam_target_10_marker, true, 15.0, nil, nil)

	MissionUtil.MissionTextSpeech("CORUSCANT_CATACLYSM", 7, 14.0, nil, {r = 46, g = 121, b = 216}) -- Saul Karath
	MissionUtil.MissionTextSpeech("CORUSCANT_CATACLYSM", 8, 14.0, nil, {r = 46, g = 121, b = 216}) -- Saul Karath
	Sleep(9.0)

	Fade_Screen_Out(3.0)
	Sleep(6.0)

	MissionUtil.CinematicMidtroHeader("CORUSCANT_CATACLYSM")

	MissionUtil.SetCinematicCamera(introcam_11_marker, introcam_target_11_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_12_marker, introcam_target_12_marker, true, 14.5, nil, nil)
	Fade_Screen_In(4.0)
	Letter_Box_In(1.0)
	Sleep(9.0)

	Fade_Screen_Out(3.0)
	Sleep(6.0)

	Fade_Screen_In(3.0)
	MissionUtil.SetCinematicCamera(introcam_13_marker, introcam_target_13_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_14_marker, introcam_target_14_marker, true, 17.0, nil, nil)

	MissionUtil.MissionTextSpeech("CORUSCANT_CATACLYSM", 9, 8.0, nil, {r = 46, g = 121, b = 216}) -- Dallan Morvis
	Sleep(9.0)

	MissionUtil.MissionTextSpeech("CORUSCANT_CATACLYSM", 10, 7.0, nil, {r = 46, g = 121, b = 216}) -- Zayne Carrick
	Sleep(8.0)

	MissionUtil.SetCinematicCamera(introcam_10_marker, introcam_target_7_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_7_marker, introcam_target_1_marker, true, 16.0, nil, nil)

	MissionUtil.MissionTextSpeech("CORUSCANT_CATACLYSM", 11, 14.0, nil, {r = 46, g = 121, b = 216}) -- Dallan Morvis
	MissionUtil.MissionTextSpeech("CORUSCANT_CATACLYSM", 12, 14.0, nil, {r = 46, g = 121, b = 216}) -- Dallan Morvis
	Sleep(15.0)

	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_5_marker, introcam_target_4_marker, true, 26.0, nil, nil)

	MissionUtil.MissionTextSpeech("CORUSCANT_CATACLYSM", 13, 15.0, nil, {r = 46, g = 121, b = 216}) -- Dallan Morvis
	MissionUtil.MissionTextSpeech("CORUSCANT_CATACLYSM", 14, 12.0, nil, {r = 46, g = 121, b = 216}) -- Dallan Morvis
	Sleep(16.0)

	MissionUtil.SetCinematicCamera(introcam_8_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_10_marker, introcam_target_1_marker, true, 14.0, nil, nil)

	MissionUtil.MissionTextSpeech("CORUSCANT_CATACLYSM", 15, 12.0, nil, {r = 46, g = 121, b = 216}) -- Zayne Carrick
	MissionUtil.MissionTextSpeech("CORUSCANT_CATACLYSM", 16, 12.0, nil, {r = 46, g = 121, b = 216}) -- Zayne Carrick
	Sleep(14.0)

	MissionUtil.SetCinematicCamera(introcam_15_marker, introcam_target_15_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_16_marker, introcam_target_16_marker, true, 26.0, nil, nil)

	MissionUtil.MissionTextSpeech("CORUSCANT_CATACLYSM", 17, 8.0, nil, {r = 46, g = 121, b = 216}) -- Dallan Morvis
	Sleep(9.0)

	MissionUtil.MissionTextSpeech("CORUSCANT_CATACLYSM", 18, 7.0, nil, {r = 46, g = 121, b = 216}) -- Saul Karath
	Sleep(8.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end
function End_Cinematic_Intro_CIS()
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(Find_First_Object("ATTACKER ENTRY POSITION"), 3.5)
	Sleep(3.5)

	MissionUtil.SetObjectiveMissionSet("CORUSCANT_CATACLYSM", "CIS", 2)

	MissionUtil.MissionTextSpeech("CORUSCANT_CATACLYSM", 19, 10.0, nil, {r = 247, g = 201, b = 13}) -- Cassus Fett

	if StoryUtil.GetDifficulty() == "EASY" then
		Register_Timer(State_Avenger_Fleet_Arrives, 300)
	end
	if StoryUtil.GetDifficulty() == "NORMAL" then
		Register_Timer(State_Avenger_Fleet_Arrives, 240)
	end
	if StoryUtil.GetDifficulty() == "HARD" then
		Register_Timer(State_Avenger_Fleet_Arrives, 180)
	end

	current_cinematic_thread_id = nil

	cinematic_one = false
	act_1_active = true
	MissionUtil.AIActivation()
end

function Start_Cinematic_Outro_CIS()
	act_1_active = false
	cinematic_two = true

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, true, 12.5, nil, nil)

	MissionUtil.MissionTextSpeech("CORUSCANT_CATACLYSM", 22, 11.0, nil, {r = 247, g = 201, b = 13}) -- Mand'alor

	Fade_Screen_Out(5.0)
	Sleep(9.0)

	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.DisableRetreat("EMPIRE", false)

	StoryUtil.DeclareVictory(p_cis, false)
end
