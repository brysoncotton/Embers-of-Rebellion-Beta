
--*****************************************************--
--******* Operation Knight Hammer: Tomb Torment *******--
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
	p_hutts = Find_Player("Hutt_Cartels")
	p_neutral = Find_Player("Neutral")
	p_hostile = Find_Player("Independent_Forces")

	act_1_active = false

	cinematic_one = false
	cinematic_two = false

	cinematic_one_skipped = false
	cinematic_two_skipped = false

	temple_guard_spawn = false

	mission_started = false
end
function Begin_Battle(message)
	if message == OnEnter then
		MissionUtil.VictoryAllowance(false)

		MissionUtil.DisableRetreat("REBEL", true)
		MissionUtil.DisableRetreat("EMPIRE", true)
		MissionUtil.DisableRetreat("HUTT_CARTELS", true)
		MissionUtil.DisableRetreat("INDEPENDENT_FORCES", true)

		MissionUtil.AllowOrbitalSupport(p_cis, false)
		MissionUtil.AllowOrbitalSupport(p_republic, false)
		MissionUtil.AllowOrbitalSupport(p_hutts, false)

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
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")
		introcam_target_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-4")
		introcam_target_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-5")
		introcam_target_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-6")

		outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-1")
		outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-2")
		outrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-3")
		outrocam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-4")
		outrocam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-5")
		outrocam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-6")
		outrocam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-7")
		outrocam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-8")

		outrocam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-1")
		outrocam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-2")

		intro_cultist_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cultist-1")
		intro_cultist_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cultist-2")
		intro_cultist_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cultist-3")
		intro_cultist_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cultist-4")
		intro_cultist_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cultist-5")
		intro_cultist_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cultist-6")
		intro_cultist_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cultist-7")
		intro_cultist_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cultist-8")
		intro_cultist_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cultist-9")
		intro_cultist_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cultist-10")
		intro_cultist_11_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cultist-11")
		intro_cultist_12_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cultist-12")
		intro_cultist_13_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cultist-13")
		intro_cultist_14_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cultist-14")
		intro_cultist_15_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cultist-15")
		intro_cultist_16_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cultist-16")
		intro_cultist_17_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cultist-17")
		intro_cultist_18_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cultist-18")
		intro_cultist_19_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cultist-19")
		intro_cultist_20_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cultist-20")

		intro_1_apostle_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-apostle")
		intro_2_apostle_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-apostle")

		intro_headmaster_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-headmaster")

		intro_hero_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-hero-1")
		intro_hero_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-hero-2")
		intro_hero_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-hero-3")

		attacker_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "attacker-1")
		attacker_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "attacker-2")
		attacker_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "attacker-3")
		attacker_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "attacker-4")

		outro_hero_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-hero-1")
		outro_hero_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-hero-2")

		outro_sidekick_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-jedi-1")
		outro_sidekick_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-jedi-2")
		outro_sidekick_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-jedi-3")
		outro_sidekick_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-jedi-4")

		lander_1_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lander-1-1")
		lander_1_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lander-1-2")
		lander_1_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lander-1-3")
		lander_1_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lander-1-4")

		lander_2_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lander-2-1")
		lander_2_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lander-2-2")
		lander_2_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lander-2-3")
		lander_2_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lander-2-4")

		p_temple_door = Find_Hint("MISSION_SITH_STONE_DOOR_X2", "door")
		MissionUtil.PlayAnimation(p_temple_door, "Cinematic", true, 1)

		p_temple_entry_right = Find_Hint("BPFASSHI_DARK_JEDI_TEMPLE", "entry-right")
		Register_Death_Event(p_temple_entry_right, State_Temple_Entered_Right)

		p_temple_entry_left = Find_Hint("BPFASSHI_DARK_JEDI_TEMPLE", "entry-left")
		Register_Death_Event(p_temple_entry_left, State_Temple_Entered_Left)

		mission_started = true
		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
		elseif p_republic.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
		elseif p_hutts.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Hutts")
		end
	end
end

function State_Temple_Entered_Right()
	local temple_right_darkjedi_list = Find_All_Objects_With_Hint("defender-cave-right-darkjedi")
	for i,temple_right_darkjedi_marker in pairs(temple_right_darkjedi_list) do
		MissionUtil.SpawnListSpawner("DARK_JEDI_COMPANY", temple_right_darkjedi_marker, p_hostile, 1)
	end
	--[[local temple_right_cultist_list = Find_All_Objects_With_Hint("defender-cave-right-cultist")
	for i,temple_right_cultist_marker in pairs(temple_right_cultist_list) do
		MissionUtil.SpawnListSpawner("FORCE_CULTIST_COMPANY", temple_right_cultist_marker, p_hostile, 1)
	end]]


	if temple_guard_spawn == false then
		temple_guard_spawn = true
		Sleep(15.0)

		local temple_darkjedi_list = Find_All_Objects_With_Hint("defender-temple")
		for i,temple_darkjedi_marker in pairs(temple_darkjedi_list) do
			MissionUtil.SpawnListSpawner("DARK_JEDI_COMPANY", temple_darkjedi_marker, p_hostile, 1)
		end
	end
end
function State_Temple_Entered_Left()
	local temple_left_darkjedi_list = Find_All_Objects_With_Hint("defender-cave-left-darkjedi")
	for i,temple_left_darkjedi_marker in pairs(temple_left_darkjedi_list) do
		MissionUtil.SpawnListSpawner("DARK_JEDI_COMPANY", temple_left_darkjedi_marker, p_hostile, 1)
	end
	--[[local temple_left_cultist_list = Find_All_Objects_With_Hint("defender-cave-left-cultist")
	for i,temple_left_cultist_marker in pairs(temple_left_cultist_list) do
		MissionUtil.SpawnListSpawner("FORCE_CULTIST_COMPANY", temple_left_cultist_marker, p_hostile, 1)
	end]]

	if p_cis.Is_Human() then
		Create_Thread("State_Reinforcements_Arrives_CIS")
	elseif p_republic.Is_Human() then
		Create_Thread("State_Reinforcements_Arrives_Rep")
	elseif p_hutts.Is_Human() then
		Create_Thread("State_Reinforcements_Arrives_Hutts")
	end

	if temple_guard_spawn == false then
		temple_guard_spawn = true
		Sleep(15.0)

		local temple_darkjedi_list = Find_All_Objects_With_Hint("defender-temple")
		for i,temple_darkjedi_marker in pairs(temple_darkjedi_list) do
			MissionUtil.SpawnListSpawner("DARK_JEDI_COMPANY", temple_darkjedi_marker, p_hostile, 1)
		end
	end
end

function State_Reinforcements_Arrives_CIS()
	MissionUtil.SpawnListSpawner("SUN_GUARD_COMPANY", attacker_1_marker, p_cis, 2)
	MissionUtil.SpawnListSpawner("NIMBUS_COMMANDO_COMPANY", attacker_2_marker, p_cis, 1)

	MissionUtil.SpawnListSpawner("DARK_JEDI_COMPANY", attacker_3_marker, p_cis, 1)
	MissionUtil.SpawnListSpawner("DARK_JEDI_COMPANY", attacker_4_marker, p_cis, 1)
end
function State_Reinforcements_Arrives_Rep()
	MissionUtil.SpawnListSpawner("ANTARIAN_RANGER_COMPANY", attacker_1_marker, p_republic, 2)
	MissionUtil.SpawnListSpawner("ANTARIAN_RANGER_COMPANY", attacker_2_marker, p_republic, 1)

	MissionUtil.SpawnListSpawner("REPUBLIC_JEDI_KNIGHT_COMPANY", attacker_3_marker, p_republic, 1)
	MissionUtil.SpawnListSpawner("REPUBLIC_JEDI_KNIGHT_COMPANY", attacker_4_marker, p_republic, 1)
end
function State_Reinforcements_Arrives_Hutts()
	MissionUtil.SpawnListSpawner("MANDALORIAN_SOLDIER_COMPANY", attacker_1_marker, p_hutts, 2)
	MissionUtil.SpawnListSpawner("MANDALORIAN_SOLDIER_COMPANY", attacker_2_marker, p_hutts, 1)

	MissionUtil.SpawnListSpawner("MANDALORIAN_COMMANDO_COMPANY", attacker_3_marker, p_hutts, 2)
	MissionUtil.SpawnListSpawner("MANDALORIAN_COMMANDO_COMPANY", attacker_4_marker, p_hutts, 2)
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

				p_temple_entry_right.Set_Garrison_Spawn(true)
				Add_Radar_Blip(p_temple_entry_right, "p_temple_entry_right_blip")
				p_temple_entry_right.Highlight(true)

				p_temple_entry_left.Set_Garrison_Spawn(true)
				Add_Radar_Blip(p_temple_entry_left, "p_temple_entry_left_blip")
				p_temple_entry_left.Highlight(true)

				if TestValid(Find_First_Object("DARK_JEDI_HEADMASTER")) then
					Add_Radar_Blip(Find_First_Object("DARK_JEDI_HEADMASTER"), "player_headmaster_blip")
					Find_First_Object("DARK_JEDI_HEADMASTER").Highlight(true)
					Find_First_Object("DARK_JEDI_HEADMASTER").Prevent_AI_Usage(true)
					Hide_Sub_Object(Find_First_Object("DARK_JEDI_HEADMASTER"), 0, "lightsaber")
				end

				if TestValid(player_apostle) then
					player_apostle.Despawn()
				end

				if not TestValid(Find_First_Object("Sheathipede_B_Type_Landing_Craft_Landing")) then
					MissionUtil.CreateCinematicLander("SHEATHIPEDE_B_TYPE_LANDING_CRAFT_LANDING", lander_2_1_marker, p_cis, 7, true, "LANDING", 100.0)
					MissionUtil.CreateCinematicLander("SHEATHIPEDE_B_TYPE_LANDING_CRAFT_LANDING", lander_2_2_marker, p_cis, 7, true, "LANDING", 95.0)
					MissionUtil.CreateCinematicLander("SHEATHIPEDE_B_TYPE_LANDING_CRAFT_LANDING", lander_2_3_marker, p_cis, 7, true, "LANDING", 105.0)
					MissionUtil.CreateCinematicLander("SHEATHIPEDE_B_TYPE_LANDING_CRAFT_LANDING", lander_2_4_marker, p_cis, 7, true, "LANDING", 103.0)
					MissionUtil.CreateCinematicLander("SHEATHIPEDE_B_TYPE_LANDING_CRAFT_LANDING", lander_1_1_marker, p_cis, 7, true, "LANDING", 75.0)
					MissionUtil.CreateCinematicLander("SHEATHIPEDE_B_TYPE_LANDING_CRAFT_LANDING", lander_1_2_marker, p_cis, 7, true, "LANDING", 80.0)
					MissionUtil.CreateCinematicLander("SHEATHIPEDE_B_TYPE_LANDING_CRAFT_LANDING", lander_1_3_marker, p_cis, 7, true, "LANDING", 82.0)
					MissionUtil.CreateCinematicLander("SHEATHIPEDE_B_TYPE_LANDING_CRAFT_LANDING", lander_1_4_marker, p_cis, 7, true, "LANDING", 77.0)
				end

				if not TestValid(player_ventress) then
					player_ventress = MissionUtil.SpawnUnitGround("VENTRESS", intro_hero_1_marker, p_cis)
					player_DJ = MissionUtil.SpawnUnitGround("SHAALA_DONEETA", intro_hero_2_marker, p_cis)
					player_skorr = MissionUtil.SpawnUnitGround("SORA_BULQ", intro_hero_3_marker, p_cis)
				end

				if TestValid(Find_First_Object("SITH_CULT_FANATIC")) then
					local despawn_list = Find_All_Objects_Of_Type("SITH_CULT_FANATIC")
					for i,despawnies in pairs(despawn_list) do
						despawnies.Despawn()
					end
				end

				MissionUtil.SetObjectiveMissionSet("TOMB_TORMENT", "CIS", 2)
				MissionUtil.CinematicSkippingCleanUp(Find_First_Object("VENTRESS"))
				MissionUtil.CinematicEnvironmentOff()
				MissionUtil.PlayGenericMusic("Sith_Temple_Theme")

				MissionUtil.SpawnListSpawner("MAGNAGUARD_SQUAD", attacker_1_marker, p_cis, 1)
				MissionUtil.SpawnListSpawner("DARK_JEDI_COMPANY", attacker_2_marker, p_cis, 1)
				MissionUtil.SpawnListSpawner("MAGNAGUARD_SQUAD", attacker_3_marker, p_cis, 2)
				MissionUtil.SpawnListSpawner("CIS_GAT_COMPANY", attacker_4_marker, p_cis, 2)

				MissionUtil.SpawnListSpawner("SUN_GUARD_COMPANY", attacker_1_marker, p_cis, 2)
				MissionUtil.SpawnListSpawner("SUN_GUARD_COMPANY", attacker_2_marker, p_cis, 2)
				MissionUtil.SpawnListSpawner("NIMBUS_COMMANDO_COMPANY", attacker_3_marker, p_cis, 1)
				MissionUtil.SpawnListSpawner("CIS_STAP_COMPANY", attacker_4_marker, p_cis, 1)

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

				MissionUtil.AllowOrbitalSupport(p_cis, true)
				MissionUtil.AllowOrbitalSupport(p_republic, true)
				MissionUtil.AllowOrbitalSupport(p_hutts, true)

				MissionUtil.CinematicEnvironmentOff()
				MissionUtil.DisableRetreat("REBEL", false)
				MissionUtil.DisableRetreat("EMPIRE", false)
				MissionUtil.DisableRetreat("HUTT_CARTELS", false)
				MissionUtil.DisableRetreat("INDEPENDENT_FORCES", false)
				MissionUtil.CinematicEnvironmentOff()

				StoryUtil.DeclareVictory(p_cis, false)
			end
		end
	elseif p_republic.Is_Human() then
		if cinematic_one then
			if not cinematic_one_skipped then
				cinematic_one_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				p_temple_entry_right.Set_Garrison_Spawn(true)
				Add_Radar_Blip(p_temple_entry_right, "p_temple_entry_right_blip")
				p_temple_entry_right.Highlight(true)

				p_temple_entry_left.Set_Garrison_Spawn(true)
				Add_Radar_Blip(p_temple_entry_left, "p_temple_entry_left_blip")
				p_temple_entry_left.Highlight(true)

				if TestValid(Find_First_Object("DARK_JEDI_HEADMASTER")) then
					Add_Radar_Blip(Find_First_Object("DARK_JEDI_HEADMASTER"), "player_headmaster_blip")
					Find_First_Object("DARK_JEDI_HEADMASTER").Highlight(true)
					Find_First_Object("DARK_JEDI_HEADMASTER").Prevent_AI_Usage(true)
					Hide_Sub_Object(Find_First_Object("DARK_JEDI_HEADMASTER"), 0, "lightsaber")
				end

				if TestValid(player_apostle) then
					player_apostle.Despawn()
				end

				if not TestValid(Find_First_Object("T6_SHUTTLE_LANDING_CRAFT_LANDING_CINEMATIC")) then
					MissionUtil.CreateCinematicLander("T6_SHUTTLE_LANDING_CRAFT_LANDING_CINEMATIC", lander_2_1_marker, p_republic, 7, true, "LANDING", 100.0)
					MissionUtil.CreateCinematicLander("T6_SHUTTLE_LANDING_CRAFT_LANDING_CINEMATIC", lander_2_2_marker, p_republic, 7, true, "LANDING", 95.0)
					MissionUtil.CreateCinematicLander("T6_SHUTTLE_LANDING_CRAFT_LANDING_CINEMATIC", lander_2_3_marker, p_republic, 7, true, "LANDING", 105.0)
					MissionUtil.CreateCinematicLander("T6_SHUTTLE_LANDING_CRAFT_LANDING_CINEMATIC", lander_2_4_marker, p_republic, 7, true, "LANDING", 103.0)
					MissionUtil.CreateCinematicLander("T6_SHUTTLE_LANDING_CRAFT_LANDING_CINEMATIC", lander_1_1_marker, p_republic, 7, true, "LANDING", 75.0)
					MissionUtil.CreateCinematicLander("T6_SHUTTLE_LANDING_CRAFT_LANDING_CINEMATIC", lander_1_2_marker, p_republic, 7, true, "LANDING", 80.0)
					MissionUtil.CreateCinematicLander("T6_SHUTTLE_LANDING_CRAFT_LANDING_CINEMATIC", lander_1_3_marker, p_republic, 7, true, "LANDING", 82.0)
					MissionUtil.CreateCinematicLander("T6_SHUTTLE_LANDING_CRAFT_LANDING_CINEMATIC", lander_1_4_marker, p_republic, 7, true, "LANDING", 77.0)
				end

				if not TestValid(player_anakin) then
					player_anakin = MissionUtil.SpawnUnitGround("ANAKIN", intro_hero_1_marker, p_republic)
					player_halcyon = MissionUtil.SpawnUnitGround("NEJAA_HALCYON", intro_hero_2_marker, p_republic)
					player_yoda = MissionUtil.SpawnUnitGround("YODA", intro_hero_3_marker, p_republic)
				end

				if TestValid(Find_First_Object("SITH_CULT_FANATIC")) then
					local despawn_list = Find_All_Objects_Of_Type("SITH_CULT_FANATIC")
					for i,despawnies in pairs(despawn_list) do
						despawnies.Despawn()
					end
				end

				MissionUtil.SetObjectiveMissionSet("TOMB_TORMENT", "REP", 2)
				MissionUtil.CinematicSkippingCleanUp(Find_First_Object("ANAKIN"))
				MissionUtil.CinematicEnvironmentOff()
				MissionUtil.PlayGenericMusic("Sith_Temple_Theme")

				MissionUtil.SpawnListSpawner("REPUBLIC_JEDI_KNIGHT_COMPANY", attacker_1_marker, p_republic, 1)
				MissionUtil.SpawnListSpawner("REPUBLIC_JEDI_KNIGHT_COMPANY", attacker_2_marker, p_republic, 1)
				MissionUtil.SpawnListSpawner("REPUBLIC_JEDI_KNIGHT_COMPANY", attacker_3_marker, p_republic, 2)
				MissionUtil.SpawnListSpawner("REPUBLIC_JEDI_KNIGHT_COMPANY", attacker_4_marker, p_republic, 2)

				MissionUtil.SpawnListSpawner("ANTARIAN_RANGER_COMPANY", attacker_1_marker, p_republic, 1)
				MissionUtil.SpawnListSpawner("ANTARIAN_RANGER_COMPANY", attacker_2_marker, p_republic, 1)
				MissionUtil.SpawnListSpawner("REPUBLIC_AT_PT_COMPANY", attacker_3_marker, p_republic, 1)
				MissionUtil.SpawnListSpawner("REPUBLIC_TX130S_COMPANY", attacker_4_marker, p_republic, 1)

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

				MissionUtil.AllowOrbitalSupport(p_cis, true)
				MissionUtil.AllowOrbitalSupport(p_republic, true)
				MissionUtil.AllowOrbitalSupport(p_hutts, true)

				MissionUtil.CinematicEnvironmentOff()
				MissionUtil.DisableRetreat("REBEL", false)
				MissionUtil.DisableRetreat("EMPIRE", false)
				MissionUtil.DisableRetreat("HUTT_CARTELS", false)
				MissionUtil.DisableRetreat("INDEPENDENT_FORCES", false)
				MissionUtil.CinematicEnvironmentOff()

				StoryUtil.DeclareVictory(p_republic, false)
			end
		end
	elseif p_hutts.Is_Human() then
		if cinematic_one then
			if not cinematic_one_skipped then
				cinematic_one_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				if not TestValid(player_maul) then
					player_maul = MissionUtil.SpawnUnitGround("DARTH_MAUL", intro_hero_1_marker, p_hutts)
					player_vizsla = MissionUtil.SpawnUnitGround("PRE_VIZSLA", intro_hero_2_marker, p_hutts)
					player_savage = MissionUtil.SpawnUnitGround("SAVAGE_OPRESS", intro_hero_3_marker, p_hutts)
				end

				MissionUtil.SpawnListSpawner("MANDALORIAN_COMMANDO_COMPANY", attacker_1_marker, p_hutts, 1)
				MissionUtil.SpawnListSpawner("MANDALORIAN_COMMANDO_COMPANY", attacker_2_marker, p_hutts, 1)
				MissionUtil.SpawnListSpawner("MANDALORIAN_COMMANDO_COMPANY", attacker_3_marker, p_hutts, 2)
				MissionUtil.SpawnListSpawner("MANDALORIAN_COMMANDO_COMPANY", attacker_4_marker, p_hutts, 2)

				MissionUtil.SpawnListSpawner("MANDALORIAN_SOLDIER_COMPANY", attacker_1_marker, p_hutts, 2)
				MissionUtil.SpawnListSpawner("MANDALORIAN_SOLDIER_COMPANY", attacker_2_marker, p_hutts, 2)
				MissionUtil.SpawnListSpawner("MANDALORIAN_SOLDIER_COMPANY", attacker_3_marker, p_hutts, 1)
				MissionUtil.SpawnListSpawner("MANDALORIAN_SOLDIER_COMPANY", attacker_4_marker, p_hutts, 1)

				p_temple_entry_right.Set_Garrison_Spawn(true)
				Add_Radar_Blip(p_temple_entry_right, "p_temple_entry_right_blip")
				p_temple_entry_right.Highlight(true)

				p_temple_entry_left.Set_Garrison_Spawn(true)
				Add_Radar_Blip(p_temple_entry_left, "p_temple_entry_left_blip")
				p_temple_entry_left.Highlight(true)

				if TestValid(Find_First_Object("DARK_JEDI_HEADMASTER")) then
					Add_Radar_Blip(player_headmaster, "player_headmaster_blip")
					player_headmaster.Highlight(true)
					player_headmaster.Prevent_AI_Usage(true)
					Hide_Sub_Object(player_headmaster, 0, "lightsaber")
				end

				if TestValid(player_apostle) then
					player_apostle.Despawn()
				end

				if not TestValid(Find_First_Object("GOZANTI_LANDING_CRAFT_LANDING")) then
					MissionUtil.CreateCinematicLander("GOZANTI_LANDING_CRAFT_LANDING", lander_2_1_marker, p_hutts, 7, true, "LANDING", 100.0)
					MissionUtil.CreateCinematicLander("GOZANTI_LANDING_CRAFT_LANDING", lander_2_2_marker, p_hutts, 7, true, "LANDING", 95.0)
					MissionUtil.CreateCinematicLander("GOZANTI_LANDING_CRAFT_LANDING", lander_2_3_marker, p_hutts, 7, true, "LANDING", 105.0)
					MissionUtil.CreateCinematicLander("GOZANTI_LANDING_CRAFT_LANDING", lander_2_4_marker, p_hutts, 7, true, "LANDING", 103.0)
					MissionUtil.CreateCinematicLander("GOZANTI_LANDING_CRAFT_LANDING", lander_1_1_marker, p_hutts, 7, true, "LANDING", 75.0)
					MissionUtil.CreateCinematicLander("GOZANTI_LANDING_CRAFT_LANDING", lander_1_2_marker, p_hutts, 7, true, "LANDING", 80.0)
					MissionUtil.CreateCinematicLander("GOZANTI_LANDING_CRAFT_LANDING", lander_1_3_marker, p_hutts, 7, true, "LANDING", 82.0)
					MissionUtil.CreateCinematicLander("GOZANTI_LANDING_CRAFT_LANDING", lander_1_4_marker, p_hutts, 7, true, "LANDING", 77.0)
				end

				if TestValid(Find_First_Object("SITH_CULT_FANATIC")) then
					local despawn_list = Find_All_Objects_Of_Type("SITH_CULT_FANATIC")
					for i,despawnies in pairs(despawn_list) do
						despawnies.Despawn()
					end
				end

				MissionUtil.SetObjectiveMissionSet("TOMB_TORMENT", "HUTTS", 2)
				MissionUtil.CinematicSkippingCleanUp(Find_First_Object("DARTH_MAUL"))
				MissionUtil.PlayGenericMusic("Sith_Temple_Theme")

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

				MissionUtil.AllowOrbitalSupport(p_cis, true)
				MissionUtil.AllowOrbitalSupport(p_republic, true)
				MissionUtil.AllowOrbitalSupport(p_hutts, true)

				MissionUtil.CinematicEnvironmentOff()
				MissionUtil.DisableRetreat("REBEL", false)
				MissionUtil.DisableRetreat("EMPIRE", false)
				MissionUtil.DisableRetreat("HUTT_CARTELS", false)
				MissionUtil.DisableRetreat("INDEPENDENT_FORCES", false)
				MissionUtil.CinematicEnvironmentOff()

				StoryUtil.DeclareVictory(p_hutts, false)
			end
		end
	end
end
function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_1_active then
			local cis_list = Find_All_Objects_Of_Type(p_cis, "Vehicle | Infantry | AirGunship | AirSpeeder | InfantryHero | VehicleHero")
			if (table.getn(cis_list) == 0) then
				if not battle_over then
					StoryUtil.TriggerScriptedBattle("TOMB_TORMENT", "BPFASSH", "LAND", "REBEL", "EMPIRE", false, "CIS")
					StoryUtil.DeclareVictory(p_hostile, false)
				end
			end
		end
	elseif p_republic.Is_Human() then
		if act_1_active then
			local rep_list = Find_All_Objects_Of_Type(p_republic, "Vehicle | Infantry | AirGunship | AirSpeeder | InfantryHero | VehicleHero")
			if (table.getn(rep_list) == 0) then
				if not battle_over then
					StoryUtil.TriggerScriptedBattle("TOMB_TORMENT", "BPFASSH", "LAND", "EMPIRE", "REBEL", false, "REP")
					StoryUtil.DeclareVictory(p_hostile, false)
				end
			end
		end
	end
end


function Start_Cinematic_Intro_CIS()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()
	Sleep(0.5)

	MissionUtil.PlayGenericMusic("Sith_Temple_Theme")

	player_headmaster = Find_First_Object("DARK_JEDI_HEADMASTER")
	player_headmaster.Teleport_And_Face(intro_headmaster_marker)
	player_headmaster.Enable_Behavior(78, false)
	Register_Death_Event(Find_First_Object("DARK_JEDI_HEADMASTER"), Start_Cinematic_Outro_CIS)

	player_apostle = MissionUtil.SpawnUnitGround("DARK_JEDI_APOSTLE", intro_1_apostle_marker, p_hostile)

	cinematic_one = true

	Sleep(0.5)

	Hide_Sub_Object(player_headmaster, 1, "Lightsaber")
	Hide_Sub_Object(player_apostle, 1, "Lightsaber")
	Hide_Sub_Object(player_apostle, 1, "saberglow")

	MissionUtil.PlayAnimation(player_headmaster, "Cinematic", true, 1)
	MissionUtil.PlayAnimation(player_apostle, "Cinematic", false, 0)

	player_apostle.Prevent_AI_Usage(true)

	player_cultist_1 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_1_marker, p_hostile)
	player_cultist_2 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_2_marker, p_hostile)
	player_cultist_3 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_3_marker, p_hostile)
	player_cultist_4 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_4_marker, p_hostile)
	player_cultist_5 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_5_marker, p_hostile)
	player_cultist_6 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_6_marker, p_hostile)
	player_cultist_7 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_7_marker, p_hostile)
	player_cultist_8 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_8_marker, p_hostile)
	player_cultist_9 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_9_marker, p_hostile)
	player_cultist_10 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_10_marker, p_hostile)
	player_cultist_11 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_11_marker, p_hostile)
	player_cultist_12 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_12_marker, p_hostile)
	player_cultist_13 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_13_marker, p_hostile)
	player_cultist_14 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_14_marker, p_hostile)
	player_cultist_15 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_15_marker, p_hostile)
	player_cultist_16 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_16_marker, p_hostile)
	player_cultist_17 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_17_marker, p_hostile)
	player_cultist_18 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_18_marker, p_hostile)
	player_cultist_19 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_19_marker, p_hostile)
	player_cultist_20 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_20_marker, p_hostile)

	player_cultist_1.Turn_To_Face(player_headmaster)
	player_cultist_2.Turn_To_Face(player_headmaster)
	player_cultist_3.Turn_To_Face(player_headmaster)
	player_cultist_4.Turn_To_Face(player_headmaster)
	player_cultist_5.Turn_To_Face(player_headmaster)
	player_cultist_6.Turn_To_Face(player_headmaster)
	player_cultist_7.Turn_To_Face(player_headmaster)
	player_cultist_8.Turn_To_Face(player_headmaster)
	player_cultist_9.Turn_To_Face(player_headmaster)
	player_cultist_10.Turn_To_Face(player_headmaster)
	player_cultist_11.Turn_To_Face(player_headmaster)
	player_cultist_12.Turn_To_Face(player_headmaster)
	player_cultist_13.Turn_To_Face(player_headmaster)
	player_cultist_14.Turn_To_Face(player_headmaster)
	player_cultist_15.Turn_To_Face(player_headmaster)
	player_cultist_16.Turn_To_Face(player_headmaster)
	player_cultist_17.Turn_To_Face(player_headmaster)
	player_cultist_18.Turn_To_Face(player_headmaster)
	player_cultist_19.Turn_To_Face(player_headmaster)
	player_cultist_20.Turn_To_Face(player_headmaster)

	MissionUtil.CinematicIntroHeader("TOMB_TORMENT")

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, true, 11.5, nil, nil)

	Fade_Screen_In(5.0)
	Letter_Box_In(1.0)
	Sleep(7.0)

	Fade_Screen_Out(3.0)
	Sleep(4.0)

	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_3_marker, true, 13.5, nil, nil)
	Fade_Screen_In(2.0)
	Sleep(1.0)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_01", 1, 12.0, nil, {r = 255, g = 44, b = 44})
	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_01", 2, 12.0, nil, {r = 255, g = 44, b = 44})

	MissionUtil.PlayAnimation(player_headmaster, "Cinematic", false, 0)

	MissionUtil.PlayAnimation(player_cultist_1, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_2, "Cinematic", false, 1)
	MissionUtil.PlayAnimation(player_cultist_3, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_4, "Cinematic", false, 1)
	MissionUtil.PlayAnimation(player_cultist_5, "Cinematic", false, 1)
	MissionUtil.PlayAnimation(player_cultist_6, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_7, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_8, "Cinematic", false, 1)
	MissionUtil.PlayAnimation(player_cultist_9, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_10, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_11, "Cinematic", false, 1)
	MissionUtil.PlayAnimation(player_cultist_12, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_13, "Cinematic", false, 1)
	MissionUtil.PlayAnimation(player_cultist_14, "Cinematic", false, 1)
	MissionUtil.PlayAnimation(player_cultist_15, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_16, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_17, "Cinematic", false, 1)
	MissionUtil.PlayAnimation(player_cultist_18, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_19, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_20, "Cinematic", false, 1)

	player_apostle.Move_To(intro_2_apostle_marker)

	Sleep(2.5)

	MissionUtil.PlayAnimation(player_headmaster, "Cinematic", false, 1)

	MissionUtil.PlayAnimation(player_cultist_1, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_2, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_3, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_4, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_5, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_6, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_7, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_8, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_9, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_10, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_11, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_12, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_13, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_14, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_15, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_16, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_17, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_18, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_19, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_20, "Cinematic", true, 2)
	Sleep(8.0)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_01", 3, 8.0, nil, {r = 212, g = 81, b = 255})

	MissionUtil.PlayAnimation(player_apostle, "Cinematic", false, 0)

	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_4_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_4_marker, true, 9.5, nil, nil)
	Sleep(9.0)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_01", 4, 12.0, nil, {r = 255, g = 44, b = 44})

	MissionUtil.SetCinematicCamera(introcam_7_marker, introcam_target_4_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_8_marker, introcam_target_4_marker, true, 13.0, nil, nil)
	Sleep(8.5)

	player_cultist_1.Change_Owner(p_republic)
	player_cultist_2.Change_Owner(p_republic)
	player_cultist_3.Change_Owner(p_republic)
	player_cultist_4.Change_Owner(p_republic)
	player_cultist_5.Change_Owner(p_republic)
	player_cultist_6.Change_Owner(p_republic)
	player_cultist_7.Change_Owner(p_republic)
	player_cultist_8.Change_Owner(p_republic)
	player_cultist_9.Change_Owner(p_republic)
	player_cultist_10.Change_Owner(p_republic)
	player_cultist_11.Change_Owner(p_republic)
	player_cultist_12.Change_Owner(p_republic)
	player_cultist_13.Change_Owner(p_republic)
	player_cultist_14.Change_Owner(p_republic)
	player_cultist_15.Change_Owner(p_republic)
	player_cultist_16.Change_Owner(p_republic)
	player_cultist_17.Change_Owner(p_republic)
	player_cultist_18.Change_Owner(p_republic)
	player_cultist_19.Change_Owner(p_republic)
	player_cultist_20.Change_Owner(p_republic)

	Sleep(.2)
	
	player_headmaster.Activate_Ability("force_lightning", player_cultist_1)
	player_headmaster.Reset_Ability_Counter()	

	Sleep(1.0)

	MissionUtil.CreateCinematicLander("SHEATHIPEDE_B_TYPE_LANDING_CRAFT_LANDING", lander_2_1_marker, p_cis, 7, true, "LANDING", 100.0)
		Sleep(.1)
	MissionUtil.CreateCinematicLander("SHEATHIPEDE_B_TYPE_LANDING_CRAFT_LANDING", lander_2_2_marker, p_cis, 7, true, "LANDING", 95.0)
		Sleep(.3)
	MissionUtil.CreateCinematicLander("SHEATHIPEDE_B_TYPE_LANDING_CRAFT_LANDING", lander_2_3_marker, p_cis, 7, true, "LANDING", 105.0)
	MissionUtil.CreateCinematicLander("SHEATHIPEDE_B_TYPE_LANDING_CRAFT_LANDING", lander_2_4_marker, p_cis, 7, true, "LANDING", 103.0)
		Sleep(.2)

	MissionUtil.CreateCinematicLander("SHEATHIPEDE_B_TYPE_LANDING_CRAFT_LANDING", lander_1_1_marker, p_cis, 7, true, "LANDING", 75.0)
		Sleep(.1)
	MissionUtil.CreateCinematicLander("SHEATHIPEDE_B_TYPE_LANDING_CRAFT_LANDING", lander_1_2_marker, p_cis, 7, true, "LANDING", 80.0)
	MissionUtil.CreateCinematicLander("SHEATHIPEDE_B_TYPE_LANDING_CRAFT_LANDING", lander_1_3_marker, p_cis, 7, true, "LANDING", 82.0)
		Sleep(.3)
	MissionUtil.CreateCinematicLander("SHEATHIPEDE_B_TYPE_LANDING_CRAFT_LANDING", lander_1_4_marker, p_cis, 7, true, "LANDING", 77.0)

	player_ventress = MissionUtil.SpawnUnitGround("VENTRESS", intro_hero_1_marker, p_cis)
	player_DJ = MissionUtil.SpawnUnitGround("SHAALA_DONEETA", intro_hero_2_marker, p_cis)
	player_skorr = MissionUtil.SpawnUnitGround("SORA_BULQ", intro_hero_3_marker, p_cis)

	Fade_Screen_Out(3.0)
	Sleep(4.0)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_01", 5, 8.0, nil, nil)

	MissionUtil.SetCinematicCamera(introcam_9_marker, introcam_target_5_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_10_marker, introcam_target_5_marker, true, 8.5, nil, nil)
	Fade_Screen_In(2.0)
	Sleep(8.5)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_01", 6, 10.0, nil, {r = 255, g = 0, b = 0})
	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_01", 7, 10.0, nil, {r = 255, g = 0, b = 0})

	MissionUtil.SetCinematicCamera(introcam_11_marker, introcam_target_5_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_12_marker, introcam_target_6_marker, true, 10.5, nil, nil)
	Sleep(10.5)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_01", 8, 10.0, nil, nil)

	player_cultist_1.Despawn()
	player_cultist_2.Despawn()
	player_cultist_3.Despawn()
	player_cultist_4.Despawn()
	player_cultist_5.Despawn()
	player_cultist_6.Despawn()
	player_cultist_7.Despawn()
	player_cultist_8.Despawn()
	player_cultist_9.Despawn()
	player_cultist_10.Despawn()
	player_cultist_11.Despawn()
	player_cultist_12.Despawn()
	player_cultist_13.Despawn()
	player_cultist_14.Despawn()
	player_cultist_15.Despawn()
	player_cultist_16.Despawn()
	player_cultist_17.Despawn()
	player_cultist_18.Despawn()
	player_cultist_19.Despawn()
	player_cultist_20.Despawn()

	player_apostle.Despawn()

	Hide_Sub_Object(player_headmaster, 0, "lightsaber")

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end
function End_Cinematic_Intro_CIS()
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(Find_First_Object("VENTRESS"), 3.5)
	Sleep(3.5)

	MissionUtil.SetObjectiveMissionSet("TOMB_TORMENT", "CIS", 2)
	Stop_All_Speech()

	MissionUtil.SpawnListSpawner("DARK_JEDI_COMPANY", attacker_1_marker, p_cis, 1)
	MissionUtil.SpawnListSpawner("DARK_JEDI_COMPANY", attacker_2_marker, p_cis, 1)
	MissionUtil.SpawnListSpawner("MAGNAGUARD_SQUAD", attacker_3_marker, p_cis, 2)
	MissionUtil.SpawnListSpawner("CIS_GAT_COMPANY", attacker_4_marker, p_cis, 2)

	MissionUtil.SpawnListSpawner("SUN_GUARD_COMPANY", attacker_1_marker, p_cis, 2)
	MissionUtil.SpawnListSpawner("MAGNAGUARD_SQUAD", attacker_2_marker, p_cis, 2)
	MissionUtil.SpawnListSpawner("NIMBUS_COMMANDO_COMPANY", attacker_3_marker, p_cis, 1)
	MissionUtil.SpawnListSpawner("CIS_STAP_COMPANY", attacker_4_marker, p_cis, 1)

	p_temple_entry_right.Set_Garrison_Spawn(true)
	Add_Radar_Blip(p_temple_entry_right, "p_temple_entry_right_blip")
	p_temple_entry_right.Highlight(true)

	p_temple_entry_left.Set_Garrison_Spawn(true)
	Add_Radar_Blip(p_temple_entry_left, "p_temple_entry_left_blip")
	p_temple_entry_left.Highlight(true)

	Add_Radar_Blip(player_headmaster, "player_headmaster_blip")
	player_headmaster.Highlight(true)
	player_headmaster.Prevent_AI_Usage(true)

	MissionUtil.Set_To_Enemies(p_cis, p_hostile)

	MissionUtil.PlayGenericMusic("Sith_Temple_Theme")

	current_cinematic_thread_id = nil

	cinematic_one = false
	act_1_active = true
end

function Start_Cinematic_Outro_CIS()
	MissionUtil.SetMissionObjectiveComplete("TOMB_TORMENT", "CIS", 1)
	Sleep(10.0)

	act_1_active = false
	cinematic_two = true

	Fade_Screen_Out(0.5)
	Sleep(0.5)

	MissionUtil.CinematicEnvironmentOn()
	MissionUtil.StartCinematicCamera()
	Do_End_Cinematic_Cleanup()
	MissionUtil.PlayGenericMusic("TCW_Luminara_Theme")

	Sleep(0.5)

	player_ventress = MissionUtil.SpawnUnitGround("VENTRESS", outro_hero_1_marker, p_cis)
	player_skorr = MissionUtil.SpawnUnitGround("SORA_BULQ", outro_hero_2_marker, p_cis)

	player_ror = MissionUtil.SpawnUnitGround("SHAALA_DONEETA", outro_sidekick_1_marker, p_cis)
	player_sidekick_1 = MissionUtil.SpawnUnitGround("HOLOGRAM_DOOKU", outro_sidekick_2_marker, p_cis)
	player_sidekick_2 = MissionUtil.SpawnUnitGround("SUN_GUARD_SERGEANT", outro_sidekick_3_marker, p_cis)
	player_sidekick_3 = MissionUtil.SpawnUnitGround("SUN_GUARD", outro_sidekick_4_marker, p_cis)

	--player_sidekick_1.Play_Animation("Idle", true, 0)

	player_skorr.Turn_To_Face(player_ventress)

	player_ror.Turn_To_Face(player_skorr)
	player_ventress.Turn_To_Face(player_skorr)
	player_sidekick_2.Turn_To_Face(player_skorr)
	player_sidekick_3.Turn_To_Face(player_skorr)

	Hide_Sub_Object(player_ventress, 1, "lightsaber");
	Hide_Sub_Object(player_ventress, 1, "lightsaber01");

	Hide_Sub_Object(player_skorr, 1, "lightsaber");
	Hide_Sub_Object(player_ror, 1, "lightsaber");

	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_01", 9, 8.0, nil, nil)
	MissionUtil.SetCinematicCamera(outrocam_1_marker, outrocam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outrocam_target_1_marker, true, 8.5, nil, nil)
	Fade_Screen_In(2.0)
	Sleep(8.5)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_01", 10, 8.0, nil, {r = 255, g = 0, b = 0})
	MissionUtil.SetCinematicCamera(outrocam_3_marker, outrocam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_4_marker, outrocam_target_2_marker, true, 8.5, nil, nil)
	Sleep(8.5)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_01", 11, 13.0, nil, nil)
	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_01", 12, 13.0, nil, nil)
	MissionUtil.SetCinematicCamera(outrocam_5_marker, outrocam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_6_marker, outrocam_target_1_marker, true, 13.5, nil, nil)
	Sleep(8.5)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_01", 13, 15.0, nil, {r = 255, g = 0, b = 0})
	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_01", 14, 15.0, nil, {r = 0, g = 255, b = 0})
	MissionUtil.SetCinematicCamera(outrocam_7_marker, outrocam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_8_marker, outrocam_target_2_marker, true, 15.5, nil, nil)
	Sleep(10.5)

	Fade_Screen_Out(3.5)
	Sleep(5.5)

	MissionUtil.DisableRetreat("REBEL", false)
	MissionUtil.DisableRetreat("EMPIRE", false)
	MissionUtil.DisableRetreat("HUTT_CARTELS", false)
	MissionUtil.DisableRetreat("INDEPENDENT_FORCES", false)

	MissionUtil.AllowOrbitalSupport(p_cis, true)
	MissionUtil.AllowOrbitalSupport(p_republic, true)
	MissionUtil.AllowOrbitalSupport(p_hutts, true)

	MissionUtil.CinematicEnvironmentOff()
	StoryUtil.DeclareVictory(p_cis, false)
end


function Start_Cinematic_Intro_Rep()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()
	Sleep(0.5)

	MissionUtil.PlayGenericMusic("Sith_Temple_Theme")

	player_headmaster = Find_First_Object("DARK_JEDI_HEADMASTER")
	player_headmaster.Teleport_And_Face(intro_headmaster_marker)
	Register_Death_Event(Find_First_Object("DARK_JEDI_HEADMASTER"), Start_Cinematic_Outro_Rep)

	player_headmaster.Enable_Behavior(78, false)

	player_apostle = MissionUtil.SpawnUnitGround("DARK_JEDI_APOSTLE", intro_1_apostle_marker, p_hostile)

	cinematic_one = true

	Sleep(0.5)

	Hide_Sub_Object(player_headmaster, 1, "Lightsaber")
	Hide_Sub_Object(player_apostle, 1, "Lightsaber")
	Hide_Sub_Object(player_apostle, 1, "saberglow")

	MissionUtil.PlayAnimation(player_headmaster, "Cinematic", true, 1)
	MissionUtil.PlayAnimation(player_apostle, "Cinematic", false, 0)

	player_apostle.Prevent_AI_Usage(true)

	player_cultist_1 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_1_marker, p_hostile)
	player_cultist_2 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_2_marker, p_hostile)
	player_cultist_3 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_3_marker, p_hostile)
	player_cultist_4 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_4_marker, p_hostile)
	player_cultist_5 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_5_marker, p_hostile)
	player_cultist_6 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_6_marker, p_hostile)
	player_cultist_7 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_7_marker, p_hostile)
	player_cultist_8 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_8_marker, p_hostile)
	player_cultist_9 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_9_marker, p_hostile)
	player_cultist_10 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_10_marker, p_hostile)
	player_cultist_11 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_11_marker, p_hostile)
	player_cultist_12 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_12_marker, p_hostile)
	player_cultist_13 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_13_marker, p_hostile)
	player_cultist_14 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_14_marker, p_hostile)
	player_cultist_15 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_15_marker, p_hostile)
	player_cultist_16 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_16_marker, p_hostile)
	player_cultist_17 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_17_marker, p_hostile)
	player_cultist_18 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_18_marker, p_hostile)
	player_cultist_19 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_19_marker, p_hostile)
	player_cultist_20 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_20_marker, p_hostile)

	player_cultist_1.Turn_To_Face(player_headmaster)
	player_cultist_2.Turn_To_Face(player_headmaster)
	player_cultist_3.Turn_To_Face(player_headmaster)
	player_cultist_4.Turn_To_Face(player_headmaster)
	player_cultist_5.Turn_To_Face(player_headmaster)
	player_cultist_6.Turn_To_Face(player_headmaster)
	player_cultist_7.Turn_To_Face(player_headmaster)
	player_cultist_8.Turn_To_Face(player_headmaster)
	player_cultist_9.Turn_To_Face(player_headmaster)
	player_cultist_10.Turn_To_Face(player_headmaster)
	player_cultist_11.Turn_To_Face(player_headmaster)
	player_cultist_12.Turn_To_Face(player_headmaster)
	player_cultist_13.Turn_To_Face(player_headmaster)
	player_cultist_14.Turn_To_Face(player_headmaster)
	player_cultist_15.Turn_To_Face(player_headmaster)
	player_cultist_16.Turn_To_Face(player_headmaster)
	player_cultist_17.Turn_To_Face(player_headmaster)
	player_cultist_18.Turn_To_Face(player_headmaster)
	player_cultist_19.Turn_To_Face(player_headmaster)
	player_cultist_20.Turn_To_Face(player_headmaster)

	MissionUtil.CinematicIntroHeader("TOMB_TORMENT")

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, true, 11.5, nil, nil)

	Fade_Screen_In(5.0)
	Letter_Box_In(1.0)
	Sleep(7.0)

	Fade_Screen_Out(3.0)
	Sleep(4.0)

	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_3_marker, true, 13.5, nil, nil)
	Fade_Screen_In(2.0)
	Sleep(1.0)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT", 1, 12.0, nil, {r = 255, g = 44, b = 44})
	MissionUtil.MissionTextSpeech("TOMB_TORMENT", 2, 12.0, nil, {r = 255, g = 44, b = 44})

	MissionUtil.PlayAnimation(player_headmaster, "Cinematic", false, 0)

	MissionUtil.PlayAnimation(player_cultist_1, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_2, "Cinematic", false, 1)
	MissionUtil.PlayAnimation(player_cultist_3, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_4, "Cinematic", false, 1)
	MissionUtil.PlayAnimation(player_cultist_5, "Cinematic", false, 1)
	MissionUtil.PlayAnimation(player_cultist_6, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_7, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_8, "Cinematic", false, 1)
	MissionUtil.PlayAnimation(player_cultist_9, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_10, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_11, "Cinematic", false, 1)
	MissionUtil.PlayAnimation(player_cultist_12, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_13, "Cinematic", false, 1)
	MissionUtil.PlayAnimation(player_cultist_14, "Cinematic", false, 1)
	MissionUtil.PlayAnimation(player_cultist_15, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_16, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_17, "Cinematic", false, 1)
	MissionUtil.PlayAnimation(player_cultist_18, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_19, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_20, "Cinematic", false, 1)

	player_apostle.Move_To(intro_2_apostle_marker)

	Sleep(2.5)

	MissionUtil.PlayAnimation(player_headmaster, "Cinematic", false, 1)

	MissionUtil.PlayAnimation(player_cultist_1, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_2, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_3, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_4, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_5, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_6, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_7, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_8, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_9, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_10, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_11, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_12, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_13, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_14, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_15, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_16, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_17, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_18, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_19, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_20, "Cinematic", true, 2)
	Sleep(8.0)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT", 3, 8.0, nil, {r = 212, g = 81, b = 255})

	MissionUtil.PlayAnimation(player_apostle, "Cinematic", false, 0)

	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_4_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_4_marker, true, 9.5, nil, nil)
	Sleep(9.0)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT", 4, 12.0, nil, {r = 255, g = 44, b = 44})

	MissionUtil.SetCinematicCamera(introcam_7_marker, introcam_target_4_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_8_marker, introcam_target_4_marker, true, 13.0, nil, nil)
	Sleep(8.5)

	player_cultist_1.Change_Owner(p_republic)
	player_cultist_2.Change_Owner(p_republic)
	player_cultist_3.Change_Owner(p_republic)
	player_cultist_4.Change_Owner(p_republic)
	player_cultist_5.Change_Owner(p_republic)
	player_cultist_6.Change_Owner(p_republic)
	player_cultist_7.Change_Owner(p_republic)
	player_cultist_8.Change_Owner(p_republic)
	player_cultist_9.Change_Owner(p_republic)
	player_cultist_10.Change_Owner(p_republic)
	player_cultist_11.Change_Owner(p_republic)
	player_cultist_12.Change_Owner(p_republic)
	player_cultist_13.Change_Owner(p_republic)
	player_cultist_14.Change_Owner(p_republic)
	player_cultist_15.Change_Owner(p_republic)
	player_cultist_16.Change_Owner(p_republic)
	player_cultist_17.Change_Owner(p_republic)
	player_cultist_18.Change_Owner(p_republic)
	player_cultist_19.Change_Owner(p_republic)
	player_cultist_20.Change_Owner(p_republic)

	Sleep(.2)
	
	player_headmaster.Activate_Ability("force_lightning", player_cultist_1)
	player_headmaster.Reset_Ability_Counter()	

	Sleep(1.0)

	MissionUtil.CreateCinematicLander("T6_SHUTTLE_LANDING_CRAFT_LANDING_CINEMATIC", lander_2_1_marker, p_republic, 7, true, "LANDING", 100.0)
		Sleep(.1)
	MissionUtil.CreateCinematicLander("T6_SHUTTLE_LANDING_CRAFT_LANDING_CINEMATIC", lander_2_2_marker, p_republic, 7, true, "LANDING", 95.0)
		Sleep(.3)
	MissionUtil.CreateCinematicLander("T6_SHUTTLE_LANDING_CRAFT_LANDING_CINEMATIC", lander_2_3_marker, p_republic, 7, true, "LANDING", 105.0)
	MissionUtil.CreateCinematicLander("T6_SHUTTLE_LANDING_CRAFT_LANDING_CINEMATIC", lander_2_4_marker, p_republic, 7, true, "LANDING", 103.0)
		Sleep(.2)

	MissionUtil.CreateCinematicLander("T6_SHUTTLE_LANDING_CRAFT_LANDING_CINEMATIC", lander_1_1_marker, p_republic, 7, true, "LANDING", 75.0)
		Sleep(.1)
	MissionUtil.CreateCinematicLander("T6_SHUTTLE_LANDING_CRAFT_LANDING_CINEMATIC", lander_1_2_marker, p_republic, 7, true, "LANDING", 80.0)
	MissionUtil.CreateCinematicLander("T6_SHUTTLE_LANDING_CRAFT_LANDING_CINEMATIC", lander_1_3_marker, p_republic, 7, true, "LANDING", 82.0)
		Sleep(.3)
	MissionUtil.CreateCinematicLander("T6_SHUTTLE_LANDING_CRAFT_LANDING_CINEMATIC", lander_1_4_marker, p_republic, 7, true, "LANDING", 77.0)

	player_anakin = MissionUtil.SpawnUnitGround("ANAKIN", intro_hero_1_marker, p_republic)
	player_halcyon = MissionUtil.SpawnUnitGround("NEJAA_HALCYON", intro_hero_2_marker, p_republic)
	player_yoda = MissionUtil.SpawnUnitGround("YODA", intro_hero_3_marker, p_republic)

	Fade_Screen_Out(3.0)
	Sleep(4.0)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT", 5, 8.0, nil, nil)

	MissionUtil.SetCinematicCamera(introcam_9_marker, introcam_target_5_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_10_marker, introcam_target_5_marker, true, 8.5, nil, nil)
	Fade_Screen_In(2.0)
	Sleep(8.5)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT", 6, 10.0, nil, {r = 0, g = 255, b = 0})
	MissionUtil.MissionTextSpeech("TOMB_TORMENT", 7, 10.0, nil, {r = 0, g = 255, b = 0})

	MissionUtil.SetCinematicCamera(introcam_11_marker, introcam_target_5_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_12_marker, introcam_target_6_marker, true, 10.5, nil, nil)
	Sleep(10.5)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT", 8, 10.0, "Anakin_Loop", nil)

	player_cultist_1.Despawn()
	player_cultist_2.Despawn()
	player_cultist_3.Despawn()
	player_cultist_4.Despawn()
	player_cultist_5.Despawn()
	player_cultist_6.Despawn()
	player_cultist_7.Despawn()
	player_cultist_8.Despawn()
	player_cultist_9.Despawn()
	player_cultist_10.Despawn()
	player_cultist_11.Despawn()
	player_cultist_12.Despawn()
	player_cultist_13.Despawn()
	player_cultist_14.Despawn()
	player_cultist_15.Despawn()
	player_cultist_16.Despawn()
	player_cultist_17.Despawn()
	player_cultist_18.Despawn()
	player_cultist_19.Despawn()
	player_cultist_20.Despawn()

	player_apostle.Despawn()

	Hide_Sub_Object(player_headmaster, 0, "lightsaber")

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Rep")
	end
end
function End_Cinematic_Intro_Rep()
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(Find_First_Object("ANAKIN"), 3.5)
	Sleep(3.5)

	MissionUtil.SetObjectiveMissionSet("TOMB_TORMENT", "REP", 2)
	Stop_All_Speech()

	MissionUtil.SpawnListSpawner("REPUBLIC_JEDI_KNIGHT_COMPANY", attacker_1_marker, p_republic, 1)
	MissionUtil.SpawnListSpawner("REPUBLIC_JEDI_KNIGHT_COMPANY", attacker_2_marker, p_republic, 1)
	MissionUtil.SpawnListSpawner("REPUBLIC_JEDI_KNIGHT_COMPANY", attacker_3_marker, p_republic, 2)
	MissionUtil.SpawnListSpawner("REPUBLIC_JEDI_KNIGHT_COMPANY", attacker_4_marker, p_republic, 2)

	MissionUtil.SpawnListSpawner("ANTARIAN_RANGER_COMPANY", attacker_1_marker, p_republic, 1)
	MissionUtil.SpawnListSpawner("ANTARIAN_RANGER_COMPANY", attacker_2_marker, p_republic, 1)
	MissionUtil.SpawnListSpawner("REPUBLIC_AT_PT_COMPANY", attacker_3_marker, p_republic, 1)
	MissionUtil.SpawnListSpawner("REPUBLIC_TX130S_COMPANY", attacker_4_marker, p_republic, 1)

	p_temple_entry_right.Set_Garrison_Spawn(true)
	Add_Radar_Blip(p_temple_entry_right, "p_temple_entry_right_blip")
	p_temple_entry_right.Highlight(true)

	p_temple_entry_left.Set_Garrison_Spawn(true)
	Add_Radar_Blip(p_temple_entry_left, "p_temple_entry_left_blip")
	p_temple_entry_left.Highlight(true)

	Add_Radar_Blip(player_headmaster, "player_headmaster_blip")
	player_headmaster.Highlight(true)
	player_headmaster.Prevent_AI_Usage(true)

	MissionUtil.PlayGenericMusic("Sith_Temple_Theme")

	current_cinematic_thread_id = nil

	cinematic_one = false
	act_1_active = true
end

function Start_Cinematic_Outro_Rep()
	MissionUtil.SetMissionObjectiveComplete("TOMB_TORMENT", "REP", 1)
	Sleep(10.0)

	act_1_active = false
	cinematic_two = true

	Fade_Screen_Out(0.5)
	Sleep(0.5)

	MissionUtil.CinematicEnvironmentOn()
	MissionUtil.StartCinematicCamera()
	Do_End_Cinematic_Cleanup()
	MissionUtil.PlayGenericMusic("TCW_Luminara_Theme")

	Sleep(0.5)

	player_anakin = MissionUtil.SpawnUnitGround("ANAKIN", outro_hero_1_marker, p_republic)
	player_yoda = MissionUtil.SpawnUnitGround("YODA", outro_hero_2_marker, p_republic)

	player_halcyon = MissionUtil.SpawnUnitGround("NEJAA_HALCYON", outro_sidekick_1_marker, p_republic)
	player_sidekick_1 = MissionUtil.SpawnUnitGround("ANTARIAN_RANGER_RIFLE", outro_sidekick_2_marker, p_republic)
	player_sidekick_2 = MissionUtil.SpawnUnitGround("ANTARIAN_RANGER_CARBINE", outro_sidekick_3_marker, p_republic)
	player_sidekick_3 = MissionUtil.SpawnUnitGround("KNOL_VENNARI", outro_sidekick_4_marker, p_republic)

	MissionUtil.PlayAnimation(player_yoda, "Idle", true, 0)

	Hide_Sub_Object(player_anakin, 1, "lightsaber")
	Hide_Sub_Object(player_halcyon, 1, "blade")
	Hide_Sub_Object(player_sidekick_3, 1, "lightsaber")

	player_yoda.Turn_To_Face(player_anakin)

	player_anakin.Turn_To_Face(player_yoda)
	player_halcyon.Turn_To_Face(player_yoda)
	player_sidekick_1.Turn_To_Face(player_yoda)
	player_sidekick_2.Turn_To_Face(player_yoda)
	player_sidekick_3.Turn_To_Face(player_yoda)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT", 9, 8.0, nil, nil)
	MissionUtil.SetCinematicCamera(outrocam_1_marker, outrocam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outrocam_target_1_marker, true, 8.5, nil, nil)
	Fade_Screen_In(2.0)
	Sleep(8.5)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT", 10, 8.0, nil, {r = 0, g = 255, b = 0})
	MissionUtil.SetCinematicCamera(outrocam_3_marker, outrocam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_4_marker, outrocam_target_2_marker, true, 8.5, nil, nil)
	Sleep(8.5)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT", 11, 13.0, nil, nil)
	MissionUtil.MissionTextSpeech("TOMB_TORMENT", 12, 13.0, nil, nil)
	MissionUtil.SetCinematicCamera(outrocam_5_marker, outrocam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_6_marker, outrocam_target_1_marker, true, 13.5, nil, nil)
	Sleep(13.5)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT", 13, 15.0, nil, {r = 0, g = 255, b = 0})
	MissionUtil.MissionTextSpeech("TOMB_TORMENT", 14, 15.0, nil, {r = 0, g = 255, b = 0})
	MissionUtil.SetCinematicCamera(outrocam_7_marker, outrocam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_8_marker, outrocam_target_2_marker, true, 15.5, nil, nil)
	Sleep(10.5)

	Fade_Screen_Out(3.5)
	Sleep(5.5)

	MissionUtil.DisableRetreat("REBEL", false)
	MissionUtil.DisableRetreat("EMPIRE", false)
	MissionUtil.DisableRetreat("HUTT_CARTELS", false)
	MissionUtil.DisableRetreat("INDEPENDENT_FORCES", false)

	MissionUtil.AllowOrbitalSupport(p_cis, true)
	MissionUtil.AllowOrbitalSupport(p_republic, true)
	MissionUtil.AllowOrbitalSupport(p_hutts, true)

	MissionUtil.CinematicEnvironmentOff()
	StoryUtil.DeclareVictory(p_republic, false)
end


function Start_Cinematic_Intro_Hutts()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()
	Sleep(0.5)

	MissionUtil.PlayGenericMusic("Sith_Temple_Theme")

	player_headmaster = Find_First_Object("DARK_JEDI_HEADMASTER")
	player_headmaster.Teleport_And_Face(intro_headmaster_marker)
	player_headmaster.Enable_Behavior(78, false)
	Register_Death_Event(Find_First_Object("DARK_JEDI_HEADMASTER"), Start_Cinematic_Outro_Hutts)

	player_apostle = MissionUtil.SpawnUnitGround("DARK_JEDI_APOSTLE", intro_1_apostle_marker, p_hostile)

	cinematic_one = true

	Sleep(0.5)

	Hide_Sub_Object(player_headmaster, 1, "Lightsaber")
	Hide_Sub_Object(player_apostle, 1, "Lightsaber")
	Hide_Sub_Object(player_apostle, 1, "saberglow")

	MissionUtil.PlayAnimation(player_headmaster, "Cinematic", true, 1)
	MissionUtil.PlayAnimation(player_apostle, "Cinematic", false, 0)

	player_apostle.Prevent_AI_Usage(true)

	player_cultist_1 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_1_marker, p_hostile)
	player_cultist_2 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_2_marker, p_hostile)
	player_cultist_3 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_3_marker, p_hostile)
	player_cultist_4 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_4_marker, p_hostile)
	player_cultist_5 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_5_marker, p_hostile)
	player_cultist_6 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_6_marker, p_hostile)
	player_cultist_7 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_7_marker, p_hostile)
	player_cultist_8 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_8_marker, p_hostile)
	player_cultist_9 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_9_marker, p_hostile)
	player_cultist_10 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_10_marker, p_hostile)
	player_cultist_11 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_11_marker, p_hostile)
	player_cultist_12 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_12_marker, p_hostile)
	player_cultist_13 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_13_marker, p_hostile)
	player_cultist_14 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_14_marker, p_hostile)
	player_cultist_15 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_15_marker, p_hostile)
	player_cultist_16 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_16_marker, p_hostile)
	player_cultist_17 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_17_marker, p_hostile)
	player_cultist_18 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_18_marker, p_hostile)
	player_cultist_19 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_19_marker, p_hostile)
	player_cultist_20 = MissionUtil.SpawnUnitGround("SITH_CULT_FANATIC", intro_cultist_20_marker, p_hostile)

	player_cultist_1.Turn_To_Face(player_headmaster)
	player_cultist_2.Turn_To_Face(player_headmaster)
	player_cultist_3.Turn_To_Face(player_headmaster)
	player_cultist_4.Turn_To_Face(player_headmaster)
	player_cultist_5.Turn_To_Face(player_headmaster)
	player_cultist_6.Turn_To_Face(player_headmaster)
	player_cultist_7.Turn_To_Face(player_headmaster)
	player_cultist_8.Turn_To_Face(player_headmaster)
	player_cultist_9.Turn_To_Face(player_headmaster)
	player_cultist_10.Turn_To_Face(player_headmaster)
	player_cultist_11.Turn_To_Face(player_headmaster)
	player_cultist_12.Turn_To_Face(player_headmaster)
	player_cultist_13.Turn_To_Face(player_headmaster)
	player_cultist_14.Turn_To_Face(player_headmaster)
	player_cultist_15.Turn_To_Face(player_headmaster)
	player_cultist_16.Turn_To_Face(player_headmaster)
	player_cultist_17.Turn_To_Face(player_headmaster)
	player_cultist_18.Turn_To_Face(player_headmaster)
	player_cultist_19.Turn_To_Face(player_headmaster)
	player_cultist_20.Turn_To_Face(player_headmaster)

	MissionUtil.CinematicIntroHeader("TOMB_TORMENT")

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, true, 11.5, nil, nil)

	Fade_Screen_In(5.0)
	Letter_Box_In(1.0)
	Sleep(7.0)

	Fade_Screen_Out(3.0)
	Sleep(4.0)

	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_3_marker, true, 13.5, nil, nil)
	Fade_Screen_In(2.0)
	Sleep(1.0)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_02", 1, 12.0, nil, {r = 255, g = 44, b = 44})
	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_02", 2, 12.0, nil, {r = 255, g = 44, b = 44})

	MissionUtil.PlayAnimation(player_headmaster, "Cinematic", false, 0)

	MissionUtil.PlayAnimation(player_cultist_1, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_2, "Cinematic", false, 1)
	MissionUtil.PlayAnimation(player_cultist_3, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_4, "Cinematic", false, 1)
	MissionUtil.PlayAnimation(player_cultist_5, "Cinematic", false, 1)
	MissionUtil.PlayAnimation(player_cultist_6, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_7, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_8, "Cinematic", false, 1)
	MissionUtil.PlayAnimation(player_cultist_9, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_10, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_11, "Cinematic", false, 1)
	MissionUtil.PlayAnimation(player_cultist_12, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_13, "Cinematic", false, 1)
	MissionUtil.PlayAnimation(player_cultist_14, "Cinematic", false, 1)
	MissionUtil.PlayAnimation(player_cultist_15, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_16, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_17, "Cinematic", false, 1)
	MissionUtil.PlayAnimation(player_cultist_18, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_19, "Cinematic", false, 1)
		Sleep(.1)
	MissionUtil.PlayAnimation(player_cultist_20, "Cinematic", false, 1)

	player_apostle.Move_To(intro_2_apostle_marker)

	Sleep(2.5)

	MissionUtil.PlayAnimation(player_headmaster, "Cinematic", false, 1)

	MissionUtil.PlayAnimation(player_cultist_1, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_2, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_3, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_4, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_5, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_6, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_7, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_8, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_9, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_10, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_11, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_12, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_13, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_14, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_15, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_16, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_17, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_18, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_19, "Cinematic", true, 2)
	MissionUtil.PlayAnimation(player_cultist_20, "Cinematic", true, 2)
	Sleep(8.0)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_02", 3, 8.0, nil, {r = 212, g = 81, b = 255})

	MissionUtil.PlayAnimation(player_apostle, "Cinematic", false, 0)

	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_4_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_4_marker, true, 9.5, nil, nil)
	Sleep(9.0)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_02", 4, 12.0, nil, {r = 255, g = 44, b = 44})

	MissionUtil.SetCinematicCamera(introcam_7_marker, introcam_target_4_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_8_marker, introcam_target_4_marker, true, 13.0, nil, nil)
	Sleep(8.5)

	player_cultist_1.Change_Owner(p_republic)
	player_cultist_2.Change_Owner(p_republic)
	player_cultist_3.Change_Owner(p_republic)
	player_cultist_4.Change_Owner(p_republic)
	player_cultist_5.Change_Owner(p_republic)
	player_cultist_6.Change_Owner(p_republic)
	player_cultist_7.Change_Owner(p_republic)
	player_cultist_8.Change_Owner(p_republic)
	player_cultist_9.Change_Owner(p_republic)
	player_cultist_10.Change_Owner(p_republic)
	player_cultist_11.Change_Owner(p_republic)
	player_cultist_12.Change_Owner(p_republic)
	player_cultist_13.Change_Owner(p_republic)
	player_cultist_14.Change_Owner(p_republic)
	player_cultist_15.Change_Owner(p_republic)
	player_cultist_16.Change_Owner(p_republic)
	player_cultist_17.Change_Owner(p_republic)
	player_cultist_18.Change_Owner(p_republic)
	player_cultist_19.Change_Owner(p_republic)
	player_cultist_20.Change_Owner(p_republic)

	Sleep(.2)
	
	player_headmaster.Activate_Ability("force_lightning", player_cultist_1)
	player_headmaster.Reset_Ability_Counter()	

	Sleep(1.0)

	MissionUtil.CreateCinematicLander("SHEATHIPEDE_B_TYPE_LANDING_CRAFT_LANDING", lander_2_1_marker, p_hutts, 7, true, "LANDING", 100.0)
		Sleep(.1)
	MissionUtil.CreateCinematicLander("SHEATHIPEDE_B_TYPE_LANDING_CRAFT_LANDING", lander_2_2_marker, p_hutts, 7, true, "LANDING", 95.0)
		Sleep(.3)
	MissionUtil.CreateCinematicLander("SHEATHIPEDE_B_TYPE_LANDING_CRAFT_LANDING", lander_2_3_marker, p_hutts, 7, true, "LANDING", 105.0)
	MissionUtil.CreateCinematicLander("SHEATHIPEDE_B_TYPE_LANDING_CRAFT_LANDING", lander_2_4_marker, p_hutts, 7, true, "LANDING", 103.0)
		Sleep(.2)

	MissionUtil.CreateCinematicLander("SHEATHIPEDE_B_TYPE_LANDING_CRAFT_LANDING", lander_1_1_marker, p_hutts, 7, true, "LANDING", 75.0)
		Sleep(.1)
	MissionUtil.CreateCinematicLander("SHEATHIPEDE_B_TYPE_LANDING_CRAFT_LANDING", lander_1_2_marker, p_hutts, 7, true, "LANDING", 80.0)
	MissionUtil.CreateCinematicLander("SHEATHIPEDE_B_TYPE_LANDING_CRAFT_LANDING", lander_1_3_marker, p_hutts, 7, true, "LANDING", 82.0)
		Sleep(.3)
	MissionUtil.CreateCinematicLander("SHEATHIPEDE_B_TYPE_LANDING_CRAFT_LANDING", lander_1_4_marker, p_hutts, 7, true, "LANDING", 77.0)

	player_maul = MissionUtil.SpawnUnitGround("DARTH_MAUL", intro_hero_1_marker, p_hutts)
	player_vizsla = MissionUtil.SpawnUnitGround("PRE_VIZSLA", intro_hero_2_marker, p_hutts)
	player_savage = MissionUtil.SpawnUnitGround("SAVAGE_OPRESS", intro_hero_3_marker, p_hutts)

	Fade_Screen_Out(3.0)
	Sleep(4.0)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_02", 5, 8.0, nil, nil)

	MissionUtil.SetCinematicCamera(introcam_9_marker, introcam_target_5_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_10_marker, introcam_target_5_marker, true, 8.5, nil, nil)
	Fade_Screen_In(2.0)
	Sleep(8.5)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_02", 6, 10.0, nil, {r = 0, g = 255, b = 0})
	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_02", 7, 10.0, nil, {r = 0, g = 255, b = 0})

	MissionUtil.SetCinematicCamera(introcam_11_marker, introcam_target_5_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_12_marker, introcam_target_6_marker, true, 10.5, nil, nil)
	Sleep(10.5)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_02", 8, 10.0, nil, nil)

	player_cultist_1.Despawn()
	player_cultist_2.Despawn()
	player_cultist_3.Despawn()
	player_cultist_4.Despawn()
	player_cultist_5.Despawn()
	player_cultist_6.Despawn()
	player_cultist_7.Despawn()
	player_cultist_8.Despawn()
	player_cultist_9.Despawn()
	player_cultist_10.Despawn()
	player_cultist_11.Despawn()
	player_cultist_12.Despawn()
	player_cultist_13.Despawn()
	player_cultist_14.Despawn()
	player_cultist_15.Despawn()
	player_cultist_16.Despawn()
	player_cultist_17.Despawn()
	player_cultist_18.Despawn()
	player_cultist_19.Despawn()
	player_cultist_20.Despawn()

	player_apostle.Despawn()

	Hide_Sub_Object(player_headmaster, 0, "lightsaber")

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Hutts")
	end
end
function End_Cinematic_Intro_Hutts()
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(Find_First_Object("DARTH_MAUL"), 3.5)
	Sleep(3.5)

	MissionUtil.SetObjectiveMissionSet("TOMB_TORMENT", "HUTTS", 4)
	Stop_All_Speech()

	MissionUtil.SpawnListSpawner("MANDALORIAN_SOLDIER_COMPANY", attacker_1_marker, p_hutts, 1)
	MissionUtil.SpawnListSpawner("MANDALORIAN_SOLDIER_COMPANY", attacker_2_marker, p_hutts, 1)
	MissionUtil.SpawnListSpawner("MANDALORIAN_SOLDIER_COMPANY", attacker_3_marker, p_hutts, 2)
	MissionUtil.SpawnListSpawner("MANDALORIAN_SOLDIER_COMPANY", attacker_4_marker, p_hutts, 2)

	MissionUtil.SpawnListSpawner("MANDALORIAN_COMMANDO_COMPANY", attacker_1_marker, p_hutts, 2)
	MissionUtil.SpawnListSpawner("MANDALORIAN_COMMANDO_COMPANY", attacker_2_marker, p_hutts, 2)
	MissionUtil.SpawnListSpawner("MANDALORIAN_COMMANDO_COMPANY", attacker_3_marker, p_hutts, 1)
	MissionUtil.SpawnListSpawner("MANDALORIAN_COMMANDO_COMPANY", attacker_4_marker, p_hutts, 1)

	p_temple_entry_right.Set_Garrison_Spawn(true)
	Add_Radar_Blip(p_temple_entry_right, "p_temple_entry_right_blip")
	p_temple_entry_right.Highlight(true)

	p_temple_entry_left.Set_Garrison_Spawn(true)
	Add_Radar_Blip(p_temple_entry_left, "p_temple_entry_left_blip")
	p_temple_entry_left.Highlight(true)

	Add_Radar_Blip(player_headmaster, "player_headmaster_blip")
	player_headmaster.Highlight(true)
	player_headmaster.Prevent_AI_Usage(true)

	MissionUtil.PlayGenericMusic("Sith_Temple_Theme")

	current_cinematic_thread_id = nil

	cinematic_one = false
	act_1_active = true
end

function Start_Cinematic_Outro_Hutts()
	Sleep(15.0)

	act_1_active = false
	cinematic_two = true

	Fade_Screen_Out(0.5)
	Sleep(0.5)

	MissionUtil.CinematicEnvironmentOn()
	MissionUtil.StartCinematicCamera()
	Do_End_Cinematic_Cleanup()
	MissionUtil.PlayGenericMusic("TCW_Luminara_Theme")

	Sleep(0.5)

	player_maul = MissionUtil.SpawnUnitGround("DARTH_MAUL", outro_hero_1_marker, p_hutts)
	player_savage = MissionUtil.SpawnUnitGround("SAVAGE_OPRESS", outro_hero_2_marker, p_hutts)

	player_vizsla = MissionUtil.SpawnUnitGround("PRE_VIZSLA", outro_sidekick_1_marker, p_hutts)
	player_sidekick_1 = MissionUtil.SpawnUnitGround("MANDALORIAN_SOLDIER", outro_sidekick_2_marker, p_hutts)
	player_sidekick_2 = MissionUtil.SpawnUnitGround("MANDALORIAN_SOLDIER", outro_sidekick_3_marker, p_hutts)
	player_sidekick_3 = MissionUtil.SpawnUnitGround("MANDALORIAN_SOLDIER", outro_sidekick_4_marker, p_hutts)

	player_maul.Turn_To_Face(player_savage)

	player_vizsla.Turn_To_Face(player_maul)
	player_savage.Turn_To_Face(player_maul)
	player_sidekick_1.Turn_To_Face(player_maul)
	player_sidekick_2.Turn_To_Face(player_maul)
	player_sidekick_3.Turn_To_Face(player_maul)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_02", 9, 8.0, nil, nil)
	MissionUtil.SetCinematicCamera(outrocam_1_marker, outrocam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outrocam_target_1_marker, true, 8.5, nil, nil)
	Fade_Screen_In(2.0)
	Sleep(8.5)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_02", 10, 8.0, nil, {r = 0, g = 255, b = 0})
	MissionUtil.SetCinematicCamera(outrocam_3_marker, outrocam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_4_marker, outrocam_target_2_marker, true, 8.5, nil, nil)
	Sleep(8.5)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_02", 11, 13.0, nil, nil)
	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_02", 12, 13.0, nil, nil)
	MissionUtil.SetCinematicCamera(outrocam_5_marker, outrocam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_6_marker, outrocam_target_1_marker, true, 13.5, nil, nil)
	Sleep(8.5)

	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_02", 13, 15.0, nil, {r = 0, g = 255, b = 0})
	MissionUtil.MissionTextSpeech("TOMB_TORMENT_ALT_02", 14, 15.0, nil, {r = 0, g = 255, b = 0})
	MissionUtil.SetCinematicCamera(outrocam_7_marker, outrocam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_8_marker, outrocam_target_2_marker, true, 15.5, nil, nil)
	Sleep(10.5)

	Fade_Screen_Out(3.5)
	Sleep(5.5)

	MissionUtil.DisableRetreat("REBEL", false)
	MissionUtil.DisableRetreat("EMPIRE", false)
	MissionUtil.DisableRetreat("HUTT_CARTELS", false)
	MissionUtil.DisableRetreat("INDEPENDENT_FORCES", false)

	MissionUtil.AllowOrbitalSupport(p_cis, true)
	MissionUtil.AllowOrbitalSupport(p_republic, true)
	MissionUtil.AllowOrbitalSupport(p_hutts, true)

	MissionUtil.CinematicEnvironmentOff()
	StoryUtil.DeclareVictory(p_hutts, false)
end