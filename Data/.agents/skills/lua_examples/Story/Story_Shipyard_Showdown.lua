
--*****************************************************--
--***** Operation Durge's Lance: Shipyard Showdown ****--
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

	republic_defender_list = {
		"Imperator_Star_Destroyer",
		"Imperator_Star_Destroyer",
		"Praetor_I_Battlecruiser",
		"Venator_Star_Destroyer",
		"Venator_Star_Destroyer",
		"Venator_Star_Destroyer",
		"Tector_Star_Destroyer",
		"Arquitens",
		"Arquitens",
		"Arquitens",
		"Arquitens",
		"CR90",
		"CR90",
		"CR90",
		"CR90",
		"CR90",
		"CR90",
		"CR90",
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_hostile = Find_Player("Hostile")

	cinematic_one = false
	cinematic_one_skipped = false
	act_1_active = false

	cinematic_one_ALT = false
	cinematic_one_ALT_skipped = false
	act_1_ALT_active = false

	grievous_soulless_one_active = false
	grievous_renitor_active = false
	grievous_munificent_active = false
	grievous_invisible_hand_active = false
	grievous_malevolence_active = false

	current_cinematic_thread_id = nil

	camera_offset = 125
	mission_started = false
end
function Begin_Battle(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			MissionUtil.VictoryAllowance(false)

			MissionUtil.DisableRetreat("REBEL", true)
			MissionUtil.DisableRetreat("EMPIRE", true)

			rep_defence_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-defender-01")
			rep_defence_02_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-defender-02")

			intro_cis_ship_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-ship-1")
			intro_cis_ship_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-ship-2")
			intro_cis_ship_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-ship-3")

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

			introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
			introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")

			MissionUtil.Set_To_Allies(p_cis, p_republic)

			player_grievous_munificent = Find_First_Object("GRIEVOUS_MUNIFICENT")
			if TestValid(player_grievous_munificent) then
				grievous_munificent_active = true
			end
			player_grievous_renitor = Find_First_Object("GRIEVOUS_RECUSANT")
			if TestValid(player_grievous_renitor) then
				grievous_renitor_active = true
			end
			player_invisible_hand = Find_First_Object("GRIEVOUS_INVISIBLE_HAND")
			if TestValid(player_invisible_hand) then
				grievous_invisible_hand_active = true
			end
			player_malevolence = Find_First_Object("GRIEVOUS_MALEVOLENCE")
			if TestValid(player_malevolence) then
				grievous_malevolence_active = true
			end
			player_soulless_one = Find_First_Object("SOULLESS_ONE")
			if TestValid(player_soulless_one) then
				grievous_soulless_one_active = true
			end

			player_onara = Find_First_Object("ONARA_KUAT_PRIDE_OF_THE_CORE")

			mission_started = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
		end
	end
end

function State_Firework_Activated()
	MissionUtil.MissionTextSpeech("SHIPYARD_SHOWDOWN", 11, 13.0, nil, {r = 255, g = 255, b = 255}) -- Mandrake

	container_list = Find_All_Objects_Of_Type("ORBITAL_RESOURCE_CONTAINER")
	for k,player_container in pairs(container_list) do
		if TestValid(player_container) then
			player_container.Change_Owner(p_hostile)
			player_container.Take_Damage(9999)
		end
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

				if not TestValid(player_munificent_1) then
					player_munificent_1 = MissionUtil.SpawnUnitSpace("MUNIFICENT", intro_cis_ship_2_marker, p_cis, 300)
				end
				if not TestValid(player_munificent_2) then
					player_munificent_2 = MissionUtil.SpawnUnitSpace("MUNIFICENT", intro_cis_ship_3_marker, p_cis, 300)
				end

				MissionUtil.Set_To_Enemies(p_cis, p_republic)
				MissionUtil.VictoryAllowance(true)

				MissionUtil.SetObjectiveMissionSet("SHIPYARD_SHOWDOWN", "CIS", 3)
				MissionUtil.CinematicSkippingCleanUp(intro_cis_ship_1_marker)

				if (GlobalValue.Get("ODL_CIS_Shipyard_Struggle_Outcome") == 0) then
					Register_Timer(State_Firework_Activated, 15)
				else
					container_list = Find_All_Objects_Of_Type("ORBITAL_RESOURCE_CONTAINER")
					for k,player_container in pairs(container_list) do
						if TestValid(player_container) then
							player_container.Despawn()
						end
					end
				end

				--StoryUtil.DeclareVictory(p_cis, false)

				cinematic_one = false
				act_1_active = true

				Fade_Screen_In(0.5)
			end
		end
	end
end
function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_1_active then
		end
	end
end

function Start_Cinematic_Intro_CIS()
	AI_Republic_Fleet = SpawnList(republic_defender_list, rep_defence_01_marker.Get_Position(), p_republic, true, true)
	Republic_AI_Fleet = AI_Republic_Fleet[1]
	Republic_AI_Fleet.Teleport_And_Face(rep_defence_01_marker)

	local GrievousObjectNames = {
		"Grievous_Malevolence_Hunt_Campaign",
		"Grievous_Malevolence_2",
		"Grievous_Malevolence",
		"Grievous_Recusant",
		"Grievous_Invisible_Hand",
		"Grievous_Munificent",
	}
	for _,GrievousObjectName in pairs(GrievousObjectNames) do
		Spawn_From_Reinforcement_Pool(Find_Object_Type(GrievousObjectName), intro_cis_ship_1_marker, Find_Player("Rebel"))
		GrievousObject = Find_First_Object(GrievousObjectName)
		if TestValid(GrievousObject) then
			player_grievous = GrievousObject
		end
	end
	if not TestValid(player_grievous) then
		player_grievous = MissionUtil.SpawnUnitSpace("GRIEVOUS_INVISIBLE_HAND", intro_cis_ship_1_marker, p_cis, 300)
	end

	if not TestValid(player_munificent_1) then
		player_munificent_1 = MissionUtil.SpawnUnitSpace("MUNIFICENT", intro_cis_ship_2_marker, p_cis, 300)
	end
	if not TestValid(player_munificent_2) then
		player_munificent_2 = MissionUtil.SpawnUnitSpace("MUNIFICENT", intro_cis_ship_3_marker, p_cis, 300)
	end

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	Fade_On()
	Sleep(0.5)

	cinematic_one = true

	MissionUtil.PlayGenericMusic("Anakin_vs_ObiWan_Theme")
	Fade_Screen_In(5.0)
	Letter_Box_In(3.0)


	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_1_marker, true, 8.5, nil, nil)

	MissionUtil.MissionTextSpeech("SHIPYARD_SHOWDOWN", 1, 6.0, nil, {r = 237, g = 28, b = 36}) -- Onara Kuat
	Sleep(6.5)

	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_2_marker, true, 14.0, nil, nil)

	MissionUtil.MissionTextSpeech("SHIPYARD_SHOWDOWN", 2, 13.0, nil, {r = 237, g = 28, b = 36}) -- Onara Kuat
	MissionUtil.MissionTextSpeech("SHIPYARD_SHOWDOWN", 3, 13.0, nil, {r = 237, g = 28, b = 36}) -- Onara Kuat
	Sleep(14.0)

	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_2_marker, true, 13.0, nil, nil)

	MissionUtil.MissionTextSpeech("SHIPYARD_SHOWDOWN", 3, 12.0, nil, {r = 237, g = 28, b = 36}) -- Onara Kuat
	MissionUtil.MissionTextSpeech("SHIPYARD_SHOWDOWN", 4, 12.0, nil, {r = 237, g = 28, b = 36}) -- Onara Kuat
	Sleep(13.0)

	MissionUtil.SetCinematicCamera(introcam_7_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_8_marker, introcam_target_1_marker, true, 13.0, nil, nil)

	MissionUtil.MissionTextSpeech("SHIPYARD_SHOWDOWN", 5, 12.0, nil, {r = 237, g = 28, b = 36}) -- Onara Kuat
	MissionUtil.MissionTextSpeech("SHIPYARD_SHOWDOWN", 6, 12.0, nil, {r = 237, g = 28, b = 36}) -- Onara Kuat
	Sleep(13.0)

	MissionUtil.SetCinematicCamera(introcam_9_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_10_marker, introcam_target_1_marker, true, 13.0, nil, nil)

	MissionUtil.MissionTextSpeech("SHIPYARD_SHOWDOWN", 7, 12.0, nil, {r = 237, g = 28, b = 36}) -- Onara Kuat
	MissionUtil.MissionTextSpeech("SHIPYARD_SHOWDOWN", 8, 12.0, nil, {r = 237, g = 28, b = 36}) -- Onara Kuat
	Sleep(13.0)

	MissionUtil.SetCinematicCamera(introcam_11_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_12_marker, introcam_target_2_marker, true, 11.0, nil, nil)

	MissionUtil.MissionTextSpeech("SHIPYARD_SHOWDOWN", 9, 13.0, nil, {r = 44, g = 121, b = 216}) -- General Grievous
	MissionUtil.MissionTextSpeech("SHIPYARD_SHOWDOWN", 10, 13.0, nil, {r = 44, g = 121, b = 216}) -- General Grievous
	Sleep(11.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end
function End_Cinematic_Intro_CIS()
	MissionUtil.EndCinematicCamera(intro_cis_ship_1_marker, 3.0)
	MissionUtil.CinematicEnvironmentOff()

	cinematic_one = false
	act_1_active = true

	MissionUtil.Set_To_Enemies(p_cis, p_republic)
	MissionUtil.VictoryAllowance(true)

	MissionUtil.SetObjectiveMissionSet("SHIPYARD_SHOWDOWN", "CIS", 3)
	MissionUtil.AIActivation()

	if (GlobalValue.Get("ODL_CIS_Shipyard_Struggle_Outcome") == 0) then
		Register_Timer(State_Firework_Activated, 15)
	else
		container_list = Find_All_Objects_Of_Type("ORBITAL_RESOURCE_CONTAINER")
		for k,player_container in pairs(container_list) do
			if TestValid(player_container) then
				player_container.Despawn()
			end
		end
	end
end
