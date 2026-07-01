
--*****************************************************--
--***** Operation Knight Hammer: Mauling Mustafar *****--
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

	act_1_active = false
	act_2_active = false

	cinematic_one = false
	cinematic_two = false
	cinematic_three = false

	cinematic_one_skipped = false
	cinematic_two_skipped = false
	cinematic_three_skipped = false

	panel_1_destroyed = false
	panel_2_destroyed = false
	generator_destroyed = false

	phase_1_spawned = false
	phase_2_spawned = false
	phase_3_spawned = false
	phase_4_spawned = false

	panel_counter = 0
end
function Begin_Battle(message)
	if message == OnEnter then
		MissionUtil.VictoryAllowance(false)

		MissionUtil.AIActivation()

		MissionUtil.Set_To_Allies(p_cis, p_republic)

		MissionUtil.DisableRetreat("REBEL", true)
		MissionUtil.DisableRetreat("EMPIRE", true)

		space_cinematic_centre_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "space-cinematic-centre")
		Promote_To_Space_Cinematic_Layer(space_cinematic_centre_marker)

		cinematic_lua_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-animation-start")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_marker)

		crawl_cam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawl-cam-1")
		Promote_To_Space_Cinematic_Layer(crawl_cam_1_marker)

		crawl_cam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawl-cam-target-1")
		Promote_To_Space_Cinematic_Layer(crawl_cam_target_1_marker)

		crawl_cam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawl-cam-2")
		Promote_To_Space_Cinematic_Layer(crawl_cam_2_marker)

		crawl_cam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawl-cam-target-2")
		Promote_To_Space_Cinematic_Layer(crawl_cam_target_2_marker)

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-4")
		introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-5")
		introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-6")
		introcam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-7")
		introcam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-8")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")
		introcam_target_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-4")
		introcam_target_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-5")

		midtrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-1")
		midtrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-2")
		midtrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-3")
		midtrocam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-4")
		midtrocam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-5")
		midtrocam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-6")
		midtrocam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-7")
		midtrocam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-8")
		midtrocam_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-9")
		midtrocam_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-10")
		midtrocam_11_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-11")
		midtrocam_12_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-12")
		midtrocam_13_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-13")
		midtrocam_14_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-14")

		midtrocam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-target-1")
		midtrocam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-target-2")
		midtrocam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-target-3")
		midtrocam_target_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-target-4")
		midtrocam_target_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-target-5")
		midtrocam_target_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-target-6")
		midtrocam_target_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-target-7")
		midtrocam_target_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-target-8")

		outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-1")
		outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-2")
		outrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-3")
		outrocam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-4")
		outrocam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-5")
		outrocam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-6")
		outrocam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-7")
		outrocam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-8")
		outrocam_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-9")
		outrocam_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-10")
		outrocam_11_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-11")
		outrocam_12_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-12")

		outrocam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-1")
		outrocam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-2")
		outrocam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-3")
		outrocam_target_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-4")
		outrocam_target_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-5")
		outrocam_target_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-6")

		defender_phase_1_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-1-1")
		defender_phase_1_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-1-2")
		defender_phase_1_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-1-3")
		defender_phase_1_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-1-4")
		defender_phase_1_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-1-5")
		defender_phase_1_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-1-6")
		defender_phase_1_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-1-7")

		defender_phase_2_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-2-1")
		defender_phase_2_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-2-2")
		defender_phase_2_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-2-3")
		defender_phase_2_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-2-4")
		defender_phase_2_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-2-5")

		defender_phase_3_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-3-1")
		defender_phase_3_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-3-2")
		defender_phase_3_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-3-3")
		defender_phase_3_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-3-4")
		defender_phase_3_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-3-5")

		defender_phase_4_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-4-1")
		defender_phase_4_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-4-2")
		defender_phase_4_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-phase-4-3")

		attacker_phase_1_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "attacker-phase-1-1")
		attacker_phase_1_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "attacker-phase-1-2")
		attacker_phase_1_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "attacker-phase-1-3")
		attacker_phase_1_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "attacker-phase-1-4")
		attacker_phase_1_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "attacker-phase-1-5")

		lander_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lander-1")
		lander_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lander-2")
		lander_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lander-3")

		intro_1_guard_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-guard_1")

		intro_1_anakin_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-anakin")

		--[[intro_1_ziton_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-ziton")

		intro_1_maul_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-maul")
		intro_1_savage_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-savage")
		intro_1_vizsla_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-vizsla")
		intro_1_katan_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-katan")

		intro_1_guard_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-guard-1")
		intro_1_guard_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-guard-2")
		intro_1_guard_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-guard-3")
		intro_1_guard_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-guard-4")

		midtro_1_xomit_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-1-xomit")

		midtro_1_maul_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-1-maul")
		midtro_1_savage_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-1-savage")
		midtro_1_vizsla_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-1-vizsla")
		midtro_1_katan_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-1-katan")

		midtro_1_guard_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-1-guard-1")
		midtro_1_guard_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-1-guard-2")
		midtro_1_guard_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-1-guard-3")
		midtro_1_guard_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-1-guard-4")
		midtro_1_guard_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-1-guard-5")
		midtro_1_guard_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-1-guard-6")

		outro_1_ziton_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-1-ziton")

		outro_1_maul_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-1-maul")
		outro_1_savage_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-1-savage")
		outro_1_vizsla_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-1-vizsla")
		outro_1_katan_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-1-katan")]]

		midtro_1_anakin_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-1-anakin")
		midtro_1_padme_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-1-padme")
		midtro_1_obiwan_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-1-obiwan")

		outro_1_anakin_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-1-anakin")
		outro_1_obiwan_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-1-obiwan")

		checkpoint_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "checkpoint")

		p_mission_panel_1 = Find_Hint("MISSION_CONTROL_PANEL", "1")
		Register_Death_Event(p_mission_panel_1, State_Panel_1_Destroyed)

		p_mission_panel_2 = Find_Hint("MISSION_CONTROL_PANEL", "2")
		Register_Death_Event(p_mission_panel_2, State_Panel_2_Destroyed)

		p_mission_generator = Find_Hint("MISSION_POWER_GENERATOR", "gen")
		Register_Death_Event(p_mission_generator, State_Generator_Destroyed)

		p_generic_panel_1 = Find_Hint("GENERIC_CONTROL_PANEL", "2")
		Register_Death_Event(p_generic_panel_1, State_Phase_2_Spawner_Trigger)

		p_generic_panel_2 = Find_Hint("GENERIC_CONTROL_PANEL", "4")
		Register_Death_Event(p_generic_panel_2, State_Phase_2_Spawner_Trigger)

		p_generic_panel_3 = Find_Hint("GENERIC_CONTROL_PANEL", "7")
		Register_Death_Event(p_generic_panel_3, State_Phase_2_Spawner_Trigger)

		p_blast_door_main = Find_Hint("MISSION_MAGNETIC_BLAST_DOOR_BIG", "main")
		p_blast_door_throne = Find_Hint("MISSION_MAGNETIC_BLAST_DOOR_BIG", "throne")

		Set_Cinematic_Environment(true)

		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Crawl_Rep")
	end
end

function State_Hero_Death_Anakin()
	MissionUtil.SetMissionObjectiveFailed("MUSTAFAR_MASSACRE", "REP", 2)
	StoryUtil.TriggerScriptedBattle("MUSTAFAR_MASSACRE", "MUSTAFAR", "LAND", "EMPIRE", "REBEL", false)
	StoryUtil.DeclareVictory(p_cis, false)
end
function State_Hero_Death_CIS_Leaders()
	if not TestValid(Find_First_Object("NUTE_GUNRAY"))
	and not TestValid(Find_First_Object("POGGLE_THE_LESSER"))
	and not TestValid(Find_First_Object("WAT_TAMBOR"))
	and not TestValid(Find_First_Object("RUNE_HAARKO"))	then
		MissionUtil.SetMissionObjectiveComplete("MUSTAFAR_MASSACRE", "REP", 1)
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Crawl_Rep")
	end
end

function State_Panel_1_Destroyed()
	if not phase_2_spawned then
		Create_Thread("State_Spawner_Phase_2")
	end

	panel_counter = panel_counter + 1

	if panel_counter == 1 then
		MissionUtil.SetMissionObjectiveUpdate("MUSTAFAR_MASSACRE", "REP", 5, 6)
	elseif panel_counter == 2 then
		MissionUtil.SetMissionObjectiveUpdate("MUSTAFAR_MASSACRE", "REP", 6, 7)
	elseif panel_counter == 3 then
		MissionUtil.SetMissionObjectiveUpdate("MUSTAFAR_MASSACRE", "REP", 7, 8)
		Create_Thread("State_Throne_Room_Showdown")
	end
end
function State_Panel_2_Destroyed()
	if not phase_3_spawned then
		Create_Thread("State_Spawner_Phase_3")
	end

	panel_counter = panel_counter + 1

	if panel_counter == 1 then
		MissionUtil.SetMissionObjectiveUpdate("MUSTAFAR_MASSACRE", "REP", 5, 6)
	elseif panel_counter == 2 then
		MissionUtil.SetMissionObjectiveUpdate("MUSTAFAR_MASSACRE", "REP", 6, 7)
	elseif panel_counter == 3 then
		MissionUtil.SetMissionObjectiveUpdate("MUSTAFAR_MASSACRE", "REP", 7, 8)
		Create_Thread("State_Throne_Room_Showdown")
	end
end

function State_Generator_Destroyed()
	if not phase_3_spawned then
		Create_Thread("State_Spawner_Phase_3")
	end

	panel_counter = panel_counter + 1

	if panel_counter == 1 then
		MissionUtil.SetMissionObjectiveUpdate("MUSTAFAR_MASSACRE", "REP", 5, 6)
	elseif panel_counter == 2 then
		MissionUtil.SetMissionObjectiveUpdate("MUSTAFAR_MASSACRE", "REP", 6, 7)
	elseif panel_counter == 3 then
		MissionUtil.SetMissionObjectiveUpdate("MUSTAFAR_MASSACRE", "REP", 7, 8)
		MissionUtil.SetMissionObjectiveComplete("MUSTAFAR_MASSACRE", "REP", 8)
		Create_Thread("State_Throne_Room_Showdown")
	end
end

function State_Throne_Room_Showdown()
	p_blast_door_main.Play_SFX_Event("SFX_UMP_EmpireKesselAlarm")
	p_blast_door_main.Play_Animation("Cinematic", false, 1)
	Sleep(3.0)
	p_blast_door_main.Despawn()

	Register_Prox(checkpoint_marker, Prox_Checkpoint_Reached, 200, p_hutts)
	Add_Radar_Blip(checkpoint_marker, "checkpoint_blip")
	checkpoint_marker.Highlight(true)

	MissionUtil.SpawnListSpawner("MAGNAGUARD_SQUAD", checkpoint_marker, p_cis, 1, false)

	MissionUtil.SetMissionObjectiveRemove("MUSTAFAR_MASSACRE", "REP", 8)
	MissionUtil.SetMissionObjectiveNew("MUSTAFAR_MASSACRE", "REP", 9)

	MissionUtil.MissionTextSpeech("MUSTAFAR_MASSACRE", 6, 8.0, nil, nil)
end

function State_Phase_1_Spawner_Trigger()
	if not phase_1_spawned then
		Create_Thread("State_Spawner_Phase_1")
	end
end
function State_Phase_2_Spawner_Trigger()
	if not phase_2_spawned then
		Create_Thread("State_Spawner_Phase_2")
	end
end
function State_Phase_3_Spawner_Trigger()
	if not phase_3_spawned then
		Create_Thread("State_Spawner_Phase_3")
	end
end
function State_Phase_4_Spawner_Trigger()
	if not phase_4_spawned then
		Create_Thread("State_Spawner_Phase_4")
	end
end

function State_Spawner_Attacker()
end

function State_Spawner_Phase_1()
	phase_1_spawned = true
	MissionUtil.SpawnListSpawner("LIGHT_MERCENARY_COMPANY", defender_phase_1_1_marker, p_cis, 1, false)
	MissionUtil.SpawnListSpawner("DESTROYER_DROID_I_W_COMPANY", defender_phase_1_2_marker, p_cis, 1, false)
	MissionUtil.SpawnListSpawner("HUTT_GUARD_COMPANY", defender_phase_1_3_marker, p_cis, 1, false)
	--MissionUtil.SpawnListSpawner("REPUBLIC_AT_PT_COMPANY", defender_phase_1_4_marker, p_cis, 1, false)
	--MissionUtil.SpawnListSpawner("OVERRACER_SPEEDER_BIKE_COMPANY", defender_phase_1_5_marker, p_cis, 1, false)
	MissionUtil.SpawnListSpawner("ELITE_MERCENARY_COMPANY", defender_phase_1_6_marker, p_cis, 1, false)
	--MissionUtil.SpawnListSpawner("SD_5_HULK_INFANTRY_DROID_COMPANY", defender_phase_1_7_marker, p_cis, 1, false)

	MissionUtil.SpawnListSpawner("MANDALORIAN_COMMANDO_COMPANY", attacker_phase_1_1_marker, p_hutts, 1)
	MissionUtil.SpawnListSpawner("MANDALORIAN_COMMANDO_COMPANY", attacker_phase_1_2_marker, p_hutts, 1)
	MissionUtil.SpawnListSpawner("MANDALORIAN_SOLDIER_COMPANY", attacker_phase_1_3_marker, p_hutts, 1)
	MissionUtil.SpawnListSpawner("MANDALORIAN_SOLDIER_COMPANY", attacker_phase_1_4_marker, p_hutts, 1)
	MissionUtil.SpawnListSpawner("MANDALORIAN_SOLDIER_COMPANY", attacker_phase_1_5_marker, p_hutts, 1)
end
function State_Spawner_Phase_2()
	phase_2_spawned = true
	MissionUtil.SpawnListSpawner("LIGHT_MERCENARY_COMPANY", defender_phase_2_1_marker, p_cis, 1, false)
	--MissionUtil.SpawnListSpawner("OVERRACER_SPEEDER_BIKE_COMPANY", defender_phase_2_2_marker, p_cis, 1, false)
	MissionUtil.SpawnListSpawner("BX_COMMANDO_SNIPER_SQUAD", defender_phase_2_3_marker, p_cis, 4, false)
	MissionUtil.SpawnListSpawner("MERCENARY_COMPANY", defender_phase_2_4_marker, p_cis, 1, false)
	MissionUtil.SpawnListSpawner("HUTT_GUARD_COMPANY", defender_phase_2_5_marker, p_cis, 1, false)

	MissionUtil.SpawnListSpawner("MANDALORIAN_COMMANDO_COMPANY", attacker_phase_1_1_marker, p_hutts, 1)
	MissionUtil.SpawnListSpawner("MANDALORIAN_COMMANDO_COMPANY", attacker_phase_1_2_marker, p_hutts, 1)
	MissionUtil.SpawnListSpawner("MANDALORIAN_SOLDIER_COMPANY", attacker_phase_1_3_marker, p_hutts, 1)
end
function State_Spawner_Phase_3()
	phase_3_spawned = true
	MissionUtil.SpawnListSpawner("SD_5_HULK_INFANTRY_DROID_COMPANY", defender_phase_3_1_marker, p_cis, 1, false)
	--MissionUtil.SpawnListSpawner("DESTROYER_DROID_I_W_COMPANY", defender_phase_3_2_marker, p_cis, 1, false)
	MissionUtil.SpawnListSpawner("HELIOS_86_SQUAD", defender_phase_3_3_marker, p_cis, 1, false)
	MissionUtil.SpawnListSpawner("MERCENARY_COMPANY", defender_phase_3_4_marker, p_cis, 1, false)
	MissionUtil.SpawnListSpawner("REPUBLIC_AT_PT_COMPANY", defender_phase_3_5_marker, p_cis, 1, false)

	MissionUtil.SpawnListSpawner("MANDALORIAN_COMMANDO_COMPANY", attacker_phase_1_1_marker, p_hutts, 1)
	MissionUtil.SpawnListSpawner("MANDALORIAN_SOLDIER_COMPANY", attacker_phase_1_2_marker, p_hutts, 1)
	MissionUtil.SpawnListSpawner("MANDALORIAN_SOLDIER_COMPANY", attacker_phase_1_3_marker, p_hutts, 1)
end
function State_Spawner_Phase_4()
	phase_4_spawned = true
	MissionUtil.SpawnListSpawner("ELITE_MERCENARY_COMPANY", defender_phase_4_1_marker, p_cis, 1, false)
	MissionUtil.SpawnListSpawner("SD_5_HULK_INFANTRY_DROID_COMPANY", defender_phase_4_2_marker, p_cis, 1, false)
	MissionUtil.SpawnListSpawner("HELIOS_86_SQUAD", defender_phase_4_3_marker, p_cis, 1, false)

	MissionUtil.SpawnListSpawner("MANDALORIAN_COMMANDO_COMPANY", attacker_phase_1_1_marker, p_hutts, 1)
	MissionUtil.SpawnListSpawner("MANDALORIAN_COMMANDO_COMPANY", attacker_phase_1_2_marker, p_hutts, 1)
	MissionUtil.SpawnListSpawner("MANDALORIAN_SOLDIER_COMPANY", attacker_phase_1_3_marker, p_hutts, 1)
end

function Prox_Checkpoint_Reached(self_obj, trigger_obj)
	if trigger_obj == player_maul then
		maul_arrived = true
	end
	if trigger_obj == player_savage then
		savage_arrived = true
	end
	if trigger_obj == player_vizsla then
		vizsla_arrived = true
	end
	if maul_arrived and savage_arrived and vizsla_arrived then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_Rep")
		self_obj.Cancel_Event_Object_In_Range(Prox_Checkpoint_Reached)
	end
end


function Story_Handle_Esc()
	if p_hutts.Is_Human() then
		if cinematic_crawl then
			if not cinematic_crawl_skipped then
				cinematic_crawl_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				Stop_All_Music()
				Stop_All_Speech()
				Remove_All_Text()
				Stop_Bink_Movie()

				Set_Cinematic_Environment(true)
				Weather_Audio_Pause(true)
				Allow_Localized_SFX(false)
				Enable_Fog(false)

				cinematic_crawl = false
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
			end
		end
		if cinematic_one then
			if not cinematic_one_skipped then
				cinematic_one_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				MissionUtil.MissionTextSpeech("MUSTAFAR_MASSACRE", 5, 8.5, nil, nil)

				p_cis.Make_Enemy(p_hutts)
				p_hutts.Make_Enemy(p_cis)

				Set_New_Environment(1)
				Set_Cinematic_Environment(false)
				Weather_Audio_Pause(false)
				Allow_Localized_SFX(true)
				Enable_Fog(true)

				if not phase_1_spawned then
					Create_Thread("State_Spawner_Phase_1")
				end

				Add_Radar_Blip(p_mission_panel_1, "p_mission_panel_1_blip")
				p_mission_panel_1.Highlight(true)

				Add_Radar_Blip(p_mission_panel_2, "p_mission_panel_2_blip")
				p_mission_panel_2.Highlight(true)

				Add_Radar_Blip(p_mission_generator, "p_mission_generator_blip")
				p_mission_generator.Highlight(true)

				if TestValid(player_intro_guard_1) then
					player_intro_guard_1.Despawn()
					player_intro_guard_2.Despawn()
					player_intro_guard_3.Despawn()
					player_intro_guard_4.Despawn()
				end

				if TestValid(p_cinematic_skydome) then
					p_cinematic_skydome.Despawn()
					p_lua_cinematic.Despawn()
				end

				if not TestValid(player_ziton) then
					player_ziton = MissionUtil.SpawnUnitGround("Ziton_Moj", intro_1_ziton_marker, p_cis)
					player_ziton.Teleport_And_Face(intro_1_ziton_marker)
				end

				if not TestValid(player_maul) then
					player_maul = MissionUtil.SpawnUnitGround("DARTH_MAUL", intro_1_maul_marker, p_hutts)
					player_maul.Teleport_And_Face(intro_1_maul_marker)
					Register_Death_Event(player_maul, State_Hero_Death)

					player_savage = MissionUtil.SpawnUnitGround("SAVAGE_OPRESS", intro_1_savage_marker, p_hutts)
					player_savage.Teleport_And_Face(intro_1_savage_marker)
					Register_Death_Event(player_savage, State_Hero_Death)

					player_vizsla = MissionUtil.SpawnUnitGround("PRE_VIZSLA", intro_1_vizsla_marker, p_hutts)
					player_vizsla.Teleport_And_Face(intro_1_vizsla_marker)
					Register_Death_Event(player_vizsla, State_Hero_Death)
				end

				if not TestValid(Find_First_Object("KOMRK_LANDING_CRAFT_LANDING_CINEMATIC")) then
					MissionUtil.CreateCinematicLander("KOMRK_LANDING_CRAFT_LANDING_CINEMATIC", lander_1_marker, p_hutts, 1, true, "LANDING", 207.0)
					MissionUtil.CreateCinematicLander("KOMRK_LANDING_CRAFT_LANDING_CINEMATIC", lander_2_marker, p_hutts, 1, true, "LANDING", 122.0)
					MissionUtil.CreateCinematicLander("KOMRK_LANDING_CRAFT_LANDING_CINEMATIC", lander_3_marker, p_hutts, 1, true, "LANDING", 253.0)
				end

				Hide_Sub_Object(player_maul, 0, "Blade")
				Hide_Sub_Object(player_savage, 0, "Blade")

				MissionUtil.SetObjectiveMissionSet("MUSTAFAR_MASSACRE", "REP", 5)
				MissionUtil.CinematicSkippingCleanUp(player_maul)

				player_ziton.Teleport_And_Face(defender_phase_1_3_marker)

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

				Add_Radar_Blip(player_xomit, "xomit_blip")
				player_xomit.Highlight(true)

				MissionUtil.SetMissionObjectiveNew("MUSTAFAR_MASSACRE", "REP", 10)
				MissionUtil.CinematicSkippingCleanUp(player_maul)

				p_cis.Make_Enemy(p_hutts)
				p_hutts.Make_Enemy(p_cis)

				if TestValid(player_midtro_guard_1) then
					player_midtro_guard_1.Despawn()
					player_midtro_guard_2.Despawn()
					player_midtro_guard_3.Despawn()
					player_midtro_guard_4.Despawn()
					player_midtro_guard_5.Despawn()
					player_midtro_guard_6.Despawn()
				end

				Create_Thread("State_Spawner_Phase_4")

				Register_Death_Event(player_xomit, State_Xomit_Death)

				cinematic_two = false
				act_2_active = true

				Fade_Screen_In(0.5)
			end
		end
		if cinematic_three then
			if not cinematic_three_skipped then
				cinematic_three_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				MissionUtil.DisableRetreat("REBEL", false)
				MissionUtil.DisableRetreat("EMPIRE", false)
				MissionUtil.DisableRetreat("INDEPENDENT_FORCES", false)
				MissionUtil.DisableRetreat("HUTT_CARTELS", false)

				MissionUtil.CinematicSkippingCleanUp(nil)

				StoryUtil.DeclareVictory(p_hutts, false)
			end
		end
	end
end
function Story_Mode_Service()
	if p_hutts.Is_Human() then
		if act_1_active then
		end
	end
end


function Start_Cinematic_Intro_Rep()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()
	Set_New_Environment(2)

	p_cinematic_skydome = MissionUtil.SpawnUnitGround("Space_Stars", space_cinematic_centre_marker, p_hutts)
	p_cinematic_skydome.Teleport_And_Face(space_cinematic_centre_marker)

	Weather_Audio_Pause(true)
	Start_Cinematic_Camera(false)
	Allow_Localized_SFX(false)
	Enable_Fog(false)

	lua_cinematic_list = Find_All_Objects_Of_Type("CINEMATIC_ETA2_VOLCANIC")
	p_lua_cinematic = lua_cinematic_list[1]

	p_lua_cinematic.Teleport(cinematic_lua_marker)
	p_lua_cinematic.Hide(true)

	MissionUtil.SetCinematicCamera(crawl_cam_1_marker, crawl_cam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(crawl_cam_2_marker, crawl_cam_target_2_marker, true, 15.0, nil, nil)
	Letter_Box_In(1.0)

	lua_cinematic_list = Find_All_Objects_Of_Type("CINEMATIC_ETA2_VOLCANIC")
	p_lua_cinematic = lua_cinematic_list[1]

	MissionUtil.PlayAnimation(p_lua_cinematic, "Cinematic", false, 0)
	p_lua_cinematic.Hide(false)

	cinematic_crawl = false
	cinematic_one = true

	MissionUtil.CinematicIntroHeader("MUSTAFAR_MASSACRE")
	MissionUtil.PlayGenericMusic("Solo_Marauder_Arrive_Theme")
	Sleep(13.0)

	Fade_Screen_Out(1.0)
	Sleep(2.0)

	Set_Cinematic_Environment(false)
	Weather_Audio_Pause(false)
	Allow_Localized_SFX(true)
	Enable_Fog(true)
	Set_New_Environment(1)

	p_cinematic_skydome.Despawn()
	p_lua_cinematic.Despawn()

	Fade_Screen_In(2.0)
	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, false, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, false, 13.5, nil, nil)
	MissionUtil.MissionTextSpeech("MUSTAFAR_MASSACRE", 1, 13.0, nil, nil)

	MissionUtil.CreateCinematicLander("KOMRK_LANDING_CRAFT_LANDING_CINEMATIC", lander_1_marker, p_hutts, 15, true, "LANDING", 207.0)
		Sleep(.4)
	MissionUtil.CreateCinematicLander("KOMRK_LANDING_CRAFT_LANDING_CINEMATIC", lander_2_marker, p_hutts, 15, true, "LANDING", 122.0)
		Sleep(.6)
	MissionUtil.CreateCinematicLander("KOMRK_LANDING_CRAFT_LANDING_CINEMATIC", lander_3_marker, p_hutts, 15, true, "LANDING", 253.0)
	Sleep(12.5)

	player_ziton = MissionUtil.SpawnUnitGround("Ziton_Moj", intro_1_ziton_marker, p_cis)
	player_ziton.Teleport_And_Face(intro_1_ziton_marker)

	player_intro_guard_1 = MissionUtil.SpawnUnitGround("HEAVY_SCAVENGER", intro_1_guard_1_marker, p_cis)
	player_intro_guard_1.Teleport_And_Face(intro_1_guard_1_marker)

	player_intro_guard_2 = MissionUtil.SpawnUnitGround("HUTT_GUARD_RIFLE", intro_1_guard_2_marker, p_cis)
	player_intro_guard_2.Teleport_And_Face(intro_1_guard_2_marker)

	player_intro_guard_3 = MissionUtil.SpawnUnitGround("HEAVY_SCAVENGER", intro_1_guard_3_marker, p_cis)
	player_intro_guard_3.Teleport_And_Face(intro_1_guard_3_marker)

	player_intro_guard_4 = MissionUtil.SpawnUnitGround("HUTT_GUARD_RIFLE", intro_1_guard_4_marker, p_cis)
	player_intro_guard_4.Teleport_And_Face(intro_1_guard_4_marker)

	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_3_marker, true, 8.0, nil, nil)
	Sleep(6.0)

	Fade_Screen_Out(1.0)
	Sleep(2)

	player_maul = MissionUtil.SpawnUnitGround("DARTH_MAUL", intro_1_maul_marker, p_hutts)
	player_maul.Teleport_And_Face(intro_1_maul_marker)
	Register_Death_Event(player_maul, State_Hero_Death)
	Hide_Sub_Object(player_maul, 1, "Blade")

	player_savage = MissionUtil.SpawnUnitGround("SAVAGE_OPRESS", intro_1_savage_marker, p_hutts)
	player_savage.Teleport_And_Face(intro_1_savage_marker)
	Register_Death_Event(player_savage, State_Hero_Death)
	Hide_Sub_Object(player_savage, 1, "Blade")

	player_vizsla = MissionUtil.SpawnUnitGround("PRE_VIZSLA", intro_1_vizsla_marker, p_hutts)
	player_vizsla.Teleport_And_Face(intro_1_vizsla_marker)
	Register_Death_Event(player_vizsla, State_Hero_Death)

	Fade_Screen_In(1.0)

	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_4_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_5_marker, true, 15.0, nil, nil)
	MissionUtil.MissionTextSpeech("MUSTAFAR_MASSACRE", 2, 7.5, nil, nil)
	Sleep(8.0)

	MissionUtil.MissionTextSpeech("MUSTAFAR_MASSACRE", 3, 7.0, nil, nil)
	Sleep(7.0)

	MissionUtil.SetCinematicCamera(introcam_7_marker, introcam_target_4_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_8_marker, introcam_target_5_marker, true, 10.0, nil, nil)
	MissionUtil.MissionTextSpeech("MUSTAFAR_MASSACRE", 4, 5.0, nil, nil)
	Sleep(7.0)

	Fade_Screen_Out(2.0)
	Sleep(3.0)

	player_ziton.Move_To(defender_phase_1_3_marker)

	if not phase_1_spawned then
		Create_Thread("State_Spawner_Phase_1")
	end

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Rep")
	end
end
function End_Cinematic_Intro_Rep()
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(player_maul, 8.0)
	MissionUtil.CinematicEnvironmentOff()

	Fade_Screen_In(3.0)
	Sleep(8.0)

	p_cis.Make_Enemy(p_hutts)
	p_hutts.Make_Enemy(p_cis)

	MissionUtil.MissionTextSpeech("MUSTAFAR_MASSACRE", 5, 8.5, nil, nil)

	MissionUtil.SetObjectiveMissionSet("MUSTAFAR_MASSACRE", "REP", 5)
	MissionUtil.CinematicEnvironmentOff()

	Add_Radar_Blip(p_mission_panel_1, "p_mission_panel_1_blip")
	p_mission_panel_1.Highlight(true)

	Add_Radar_Blip(p_mission_panel_2, "p_mission_panel_2_blip")
	p_mission_panel_2.Highlight(true)

	Add_Radar_Blip(p_mission_generator, "p_mission_generator_blip")
	p_mission_generator.Highlight(true)

	Hide_Sub_Object(player_maul, 0, "Blade")
	Hide_Sub_Object(player_savage, 0, "Blade")

	current_cinematic_thread_id = nil

	cinematic_one = false
	act_1_active = true
end

function Start_Cinematic_Midtro_Rep()
	p_cis.Make_Ally(p_hutts)
	p_hutts.Make_Ally(p_cis)

	Fade_Screen_Out(0.5)
	Sleep(1.0)

	Letter_Box_In(0.1)

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	p_blast_door_throne.Despawn()

	player_xomit = MissionUtil.SpawnUnitGround("Xomit_Grunseit", midtro_1_xomit_marker, p_cis)
	player_xomit.Teleport_And_Face(midtro_1_xomit_marker)

	player_midtro_guard_1 = MissionUtil.SpawnUnitGround("HEAVY_SCAVENGER", midtro_1_guard_1_marker, p_cis)
	player_midtro_guard_1.Teleport_And_Face(midtro_1_guard_1_marker)

	player_midtro_guard_2 = MissionUtil.SpawnUnitGround("HUTT_GUARD_RIFLE", midtro_1_guard_2_marker, p_cis)
	player_midtro_guard_2.Teleport_And_Face(midtro_1_guard_2_marker)

	player_midtro_guard_3 = MissionUtil.SpawnUnitGround("HEAVY_SCAVENGER", midtro_1_guard_3_marker, p_cis)
	player_midtro_guard_3.Teleport_And_Face(midtro_1_guard_3_marker)

	player_midtro_guard_4 = MissionUtil.SpawnUnitGround("HUTT_GUARD_RIFLE", midtro_1_guard_4_marker, p_cis)
	player_midtro_guard_4.Teleport_And_Face(midtro_1_guard_4_marker)

	player_midtro_guard_5 = MissionUtil.SpawnUnitGround("HEAVY_SCAVENGER", midtro_1_guard_5_marker, p_cis)
	player_midtro_guard_5.Teleport_And_Face(midtro_1_guard_5_marker)

	player_midtro_guard_6 = MissionUtil.SpawnUnitGround("HUTT_GUARD_RIFLE", midtro_1_guard_6_marker, p_cis)
	player_midtro_guard_6.Teleport_And_Face(midtro_1_guard_6_marker)

	if not maul_arrived then
		player_maul = MissionUtil.SpawnUnitGround("DARTH_MAUL", midtro_1_maul_marker, p_hutts)
		player_savage = MissionUtil.SpawnUnitGround("SAVAGE_OPRESS", midtro_1_savage_marker, p_hutts)
		player_vizsla = MissionUtil.SpawnUnitGround("PRE_VIZSLA", midtro_1_vizsla_marker, p_hutts)
	end

	player_maul.Teleport_And_Face(midtro_1_maul_marker)
	player_savage.Teleport_And_Face(midtro_1_savage_marker)
	player_vizsla.Teleport_And_Face(midtro_1_vizsla_marker)

	player_maul.Teleport_And_Face(player_xomit)
	player_xomit.Teleport_And_Face(player_maul)

	act_1_active = false
	cinematic_two = true

	Fade_Screen_In(1.0)
	MissionUtil.SetCinematicCamera(midtrocam_1_marker, midtrocam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(midtrocam_2_marker, midtrocam_target_2_marker, true, 10.0, nil, nil)

	MissionUtil.MissionTextSpeech("MUSTAFAR_MASSACRE", 7, 4.0, nil, nil)
	MissionUtil.PlayGenericSpeech("MUSTAFAR_MASSACRE_01")
	Sleep(4.5)

	MissionUtil.MissionTextSpeech("MUSTAFAR_MASSACRE", 8, 4.0, nil, nil)
	MissionUtil.PlayGenericSpeech("MUSTAFAR_MASSACRE_02")
	Sleep(4.5)

	MissionUtil.SetCinematicCamera(midtrocam_3_marker, midtrocam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(midtrocam_4_marker, midtrocam_target_2_marker, true, 13.0, nil, nil)

	MissionUtil.MissionTextSpeech("MUSTAFAR_MASSACRE", 9, 7.5, nil, nil)
	MissionUtil.PlayGenericSpeech("MUSTAFAR_MASSACRE_03")
	Sleep(8.0)

	MissionUtil.MissionTextSpeech("MUSTAFAR_MASSACRE", 10, 4.0, nil, nil)
	MissionUtil.PlayGenericSpeech("MUSTAFAR_MASSACRE_04")
	Sleep(4.5)

	MissionUtil.SetCinematicCamera(midtrocam_7_marker, midtrocam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(midtrocam_8_marker, midtrocam_target_2_marker, true, 12.0, nil, nil)

	MissionUtil.MissionTextSpeech("MUSTAFAR_MASSACRE", 11, 4.0, nil, nil)
	MissionUtil.PlayGenericSpeech("MUSTAFAR_MASSACRE_05")
	Sleep(4.5)

	MissionUtil.MissionTextSpeech("MUSTAFAR_MASSACRE", 12, 3.5, nil, nil)
	MissionUtil.PlayGenericSpeech("MUSTAFAR_MASSACRE_06")
	Sleep(3.5)

	MissionUtil.MissionTextSpeech("MUSTAFAR_MASSACRE", 13, 3.5, nil, nil)
	MissionUtil.PlayGenericSpeech("MUSTAFAR_MASSACRE_07")
	Sleep(3.5)

	Fade_Screen_Out(0.5)
	Sleep(0.75)

	player_midtro_guard_1.Despawn()
	player_midtro_guard_2.Despawn()
	player_midtro_guard_3.Despawn()
	player_midtro_guard_4.Despawn()
	player_midtro_guard_5.Despawn()
	player_midtro_guard_6.Despawn()

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Midtro_Rep")
	end
end
function End_Cinematic_Midtro_Rep()
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(player_maul, 1.0)
	MissionUtil.CinematicEnvironmentOff()

	Fade_Screen_In(1.0)
	Sleep(1.0)

	MissionUtil.SetMissionObjectiveNew("MUSTAFAR_MASSACRE", "REP", 10)
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.AIActivation()

	Add_Radar_Blip(player_xomit, "xomit_blip")
	player_xomit.Highlight(true)

	current_cinematic_thread_id = nil

	p_cis.Make_Enemy(p_hutts)
	p_hutts.Make_Enemy(p_cis)

	Create_Thread("State_Spawner_Phase_4")

	Register_Death_Event(player_xomit, State_Xomit_Death)

	cinematic_two = false
	act_2_active = true
end

function Start_Cinematic_Outro_Rep()
	act_2_active = false
	cinematic_three_skipped = true

	Fade_Screen_Out(0.5)
	Sleep(1.0)

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	Do_End_Cinematic_Cleanup()

	player_ziton = MissionUtil.SpawnUnitGround("Ziton_Moj", outro_1_ziton_marker, p_hutts)
	player_ziton.Teleport_And_Face(outro_1_ziton_marker)

	player_maul = MissionUtil.SpawnUnitGround("DARTH_MAUL", outro_1_maul_marker, p_hutts)
	player_maul.Teleport_And_Face(outro_1_maul_marker)

	player_savage = MissionUtil.SpawnUnitGround("SAVAGE_OPRESS", outro_1_savage_marker, p_hutts)
	player_savage.Teleport_And_Face(outro_1_savage_marker)

	player_vizsla = MissionUtil.SpawnUnitGround("PRE_VIZSLA", outro_1_vizsla_marker, p_hutts)
	player_vizsla.Teleport_And_Face(outro_1_vizsla_marker)

	player_katan = MissionUtil.SpawnUnitGround("BO_KATAN", outro_1_katan_marker, p_hutts)
	player_katan.Teleport_And_Face(outro_1_katan_marker)

	MissionUtil.SetCinematicCamera(outrocam_1_marker, outrocam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outrocam_target_1_marker, true, 15.0, nil, nil)

	Fade_Screen_In(1.0)
	Letter_Box_In(1.0)

	MissionUtil.MissionTextSpeech("MUSTAFAR_MASSACRE", 14, 4.0, nil, nil)
	MissionUtil.PlayGenericSpeech("MUSTAFAR_MASSACRE_08")
	Sleep(4.5)

	MissionUtil.MissionTextSpeech("MUSTAFAR_MASSACRE", 15, 4.0, nil, nil)
	MissionUtil.PlayGenericSpeech("MUSTAFAR_MASSACRE_09")
	Sleep(4.5)

	MissionUtil.MissionTextSpeech("MUSTAFAR_MASSACRE", 16, 4.0, nil, nil)
	MissionUtil.PlayGenericSpeech("MUSTAFAR_MASSACRE_10")
	Sleep(4.5)

	Fade_Screen_Out(3.0)
	Sleep(2.0)

	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.DisableRetreat("REBEL", false)
	MissionUtil.DisableRetreat("EMPIRE", false)
	MissionUtil.DisableRetreat("INDEPENDENT_FORCES", false)
	MissionUtil.DisableRetreat("HUTT_CARTELS", false)

	StoryUtil.DeclareVictory(p_hutts, false)
end
