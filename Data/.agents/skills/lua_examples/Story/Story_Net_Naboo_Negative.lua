
--*****************************************************--
--*** Hunt for the Malevolence: Net Naboo Negative ****--
--*****************************************************--

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")
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

	cinematic_one = false
	cinematic_one_skipped = false

	defenders_spawned = false

	intro_skipped = false
	mission_started = false
end
function Begin_Battle(message)
	if message == OnEnter then
		MissionUtil.VictoryAllowance(false)
		MissionUtil.DisableRetreat("EMPIRE", true)

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-4")
		introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-5")
		introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-6")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")
		introcam_target_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-4")
		introcam_target_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-5")

		gian_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "gian-1")
		gian_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "gian-2")
		gian_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "gian-3")

		gungan_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "gungan-1")
		gungan_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "gungan-2")
		gungan_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "gungan-3")


		prop_c9979_01 = Find_Hint("C9979_CARRIER_LANDING_FULL", "transport-1")
		c9979_01_marker = prop_c9979_01.Get_Position()
		--prop_c9979_01.Despawn()

		prop_c9979_02 = Find_Hint("C9979_CARRIER_LANDING_FULL", "transport-2")
		c9979_02_marker = prop_c9979_02.Get_Position()
		--prop_c9979_02.Despawn()

		prop_c9979_03 = Find_Hint("C9979_CARRIER_LANDING_FULL", "transport-3")
		c9979_03_marker = prop_c9979_03.Get_Position()
		--prop_c9979_03.Despawn()

		prop_c9979_04 = Find_Hint("C9979_CARRIER_LANDING_FULL", "transport-4")
		c9979_04_marker = prop_c9979_04.Get_Position()
		--prop_c9979_04.Despawn()

		prop_c9979_05 = Find_Hint("C9979_CARRIER_LANDING_FULL", "transport-5")
		c9979_05_marker = prop_c9979_05.Get_Position()
		--prop_c9979_05.Despawn()

		prop_c9979_06 = Find_Hint("C9979_CARRIER_LANDING_FULL", "transport-6")
		c9979_06_marker = prop_c9979_06.Get_Position()
		--prop_c9979_06.Despawn()

		prop_c9979_07 = Find_Hint("C9979_CARRIER_LANDING_FULL", "transport-7")
		c9979_07_marker = prop_c9979_07.Get_Position()
		--prop_c9979_07.Despawn()


		prop_hardcell_01 = Find_Hint("HARDCELL_LANDING", "transport-1")
		hardcell_01_marker = prop_hardcell_01.Get_Position()
		--prop_hardcell_01.Despawn()

		prop_hardcell_02 = Find_Hint("HARDCELL_LANDING", "transport-2")
		hardcell_02_marker = prop_hardcell_02.Get_Position()
		--prop_hardcell_02.Despawn()

		prop_hardcell_03 = Find_Hint("HARDCELL_LANDING", "transport-3")
		hardcell_03_marker = prop_hardcell_03.Get_Position()
		--prop_hardcell_03.Despawn()

		prop_hardcell_04 = Find_Hint("HARDCELL_LANDING", "transport-4")
		hardcell_04_marker = prop_hardcell_04.Get_Position()
		--prop_hardcell_04.Despawn()

		prop_hardcell_05 = Find_Hint("HARDCELL_LANDING", "transport-5")
		hardcell_05_marker = prop_hardcell_05.Get_Position()
		--prop_hardcell_05.Despawn()

		prop_hardcell_06 = Find_Hint("HARDCELL_LANDING", "transport-6")
		hardcell_06_marker = prop_hardcell_06.Get_Position()
		--prop_hardcell_06.Despawn()

		prop_hardcell_07 = Find_Hint("HARDCELL_LANDING", "transport-7")
		hardcell_07_marker = prop_hardcell_07.Get_Position()
		--prop_hardcell_07.Despawn()

		prop_hardcell_08 = Find_Hint("HARDCELL_LANDING", "transport-8")
		hardcell_08_marker = prop_hardcell_08.Get_Position()
		--prop_hardcell_08.Despawn()


		player_tarpals = Find_First_Object("ROOS_TARPALS")
		Register_Death_Event(player_tarpals, State_Hero_Death_Tarpals)

		player_jarjar = Find_First_Object("JAR_JAR_BINKS")

		p_capital = Find_First_Object("REPUBLIC_SECTOR_CAPITAL")
		Register_Death_Event(p_capital, State_Hero_Death_Capital)

		mission_started = true
		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
		end
	end
end

function State_Hero_Death_Tarpals()
	MissionUtil.SetMissionObjectiveComplete("NET_NABOO_NEGATIVE", "CIS", 2)
	p_cis.Give_Money(4000)
end
function State_Hero_Death_Capital()
	MissionUtil.SetMissionObjectiveComplete("NET_NABOO_NEGATIVE", "CIS", 3)
	p_cis.Give_Money(5000)
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

				MissionUtil.SetObjectiveMissionSet("NET_NABOO_NEGATIVE", "CIS", 3)
				MissionUtil.CinematicSkippingCleanUp(Find_First_Object("ATTACKER ENTRY POSITION"))

				MissionUtil.VictoryAllowance(true)

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
	MissionUtil.SpawnListSpawner("GUNGAN_WARRIOR_COMPANY", gungan_1_marker, p_republic, 1)
	MissionUtil.SpawnListSpawner("GUNGAN_WARRIOR_COMPANY", gungan_2_marker, p_republic, 1)

	MissionUtil.SpawnListSpawner("GIAN_COMPANY", gian_2_marker, p_republic, 1)

	MissionUtil.AddToReinforcementPool("GRIEVOUS_TEAM", p_cis, 1)

	cinematic_one = true

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	Sleep(1.0)

	MissionUtil.MissionTextSpeech("NET_NABOO_NEGATIVE", 1, 10.0, nil, nil, 0)
	MissionUtil.MissionTextSpeech("NET_NABOO_NEGATIVE", 2, 10.0, nil, nil, 0)
	MissionUtil.PlayGenericMusic("TPM_The_Droid_Invasion_Theme")

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, true, 10.5, nil, nil)

	Fade_Screen_In(4.0)
	Letter_Box_In(1.0)

	--p_c9979_lander_01 = MissionUtil.CreateCinematicLander("C9979_CARRIER_LANDING_FULL", c9979_01_marker, p_cis, 5, true, "LANDING", 277.0)
	Sleep(1.0)

	--p_c9979_lander_02 = MissionUtil.CreateCinematicLander("C9979_CARRIER_LANDING_FULL", c9979_02_marker, p_cis, 5, true, "LANDING", 257.0)
	Sleep(1.0)

	--p_c9979_lander_03 = MissionUtil.CreateCinematicLander("C9979_CARRIER_LANDING_FULL", c9979_03_marker, p_cis, 5, true, "LANDING", 272.0)
	Sleep(1.0)

	--p_c9979_lander_04 = MissionUtil.CreateCinematicLander("C9979_CARRIER_LANDING_FULL", c9979_04_marker, p_cis, 5, true, "LANDING", 304.0)
	Sleep(1.0)

	--p_c9979_lander_05 = MissionUtil.CreateCinematicLander("C9979_CARRIER_LANDING_FULL", c9979_05_marker, p_cis, 5, true, "LANDING", 242.0)
	Sleep(1.0)

	--p_harcell_lander_01 = MissionUtil.CreateCinematicLander("HARDCELL_LANDING", hardcell_01_marker, p_cis, 5, true, "LANDING", 0)
	Sleep(1.0)

	--p_harcell_lander_02 = MissionUtil.CreateCinematicLander("HARDCELL_LANDING", hardcell_02_marker, p_cis, 5, true, "LANDING", 0)
	Sleep(4.5)

	MissionUtil.MissionTextSpeech("NET_NABOO_NEGATIVE", 3, 8.0, nil, nil, 0)
	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_4_marker, true, 8.5, nil, nil)
	Sleep(8.5)

	MissionUtil.MissionTextSpeech("NET_NABOO_NEGATIVE", 4, 8.0, nil, nil, 0)
	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_5_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_5_marker, true, 8.5, nil, nil)
	Sleep(0.5)


	--p_c9979_lander_06 = MissionUtil.CreateCinematicLander("C9979_CARRIER_LANDING_FULL", c9979_06_marker, p_cis, 5, true, "LANDING", 90.0)
	Sleep(1.0)

	--p_c9979_lander_07 = MissionUtil.CreateCinematicLander("C9979_CARRIER_LANDING_FULL", c9979_07_marker, p_cis, 5, true, "LANDING", 77.0)
	Sleep(1.0)


	--p_harcell_lander_03 = MissionUtil.CreateCinematicLander("HARDCELL_LANDING", hardcell_03_marker, p_cis, 5, true, "LANDING", 0)
	Sleep(1.0)

	--p_harcell_lander_04 = MissionUtil.CreateCinematicLander("HARDCELL_LANDING", hardcell_04_marker, p_cis, 5, true, "LANDING", 0)
	Sleep(1.0)

	--p_harcell_lander_05 = MissionUtil.CreateCinematicLander("HARDCELL_LANDING", hardcell_05_marker, p_cis, 5, true, "LANDING", 0)
	Sleep(1.0)

	--p_harcell_lander_06 = MissionUtil.CreateCinematicLander("HARDCELL_LANDING", hardcell_06_marker, p_cis, 5, true, "LANDING", 0)
	Sleep(1.0)

	--p_harcell_lander_07 = MissionUtil.CreateCinematicLander("HARDCELL_LANDING", hardcell_07_marker, p_cis, 5, true, "LANDING", 0)
	Sleep(1.0)

	--p_harcell_lander_08 = MissionUtil.CreateCinematicLander("HARDCELL_LANDING", hardcell_08_marker, p_cis, 5, true, "LANDING", 0)
	Sleep(1.0)


	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end
function End_Cinematic_Intro_CIS()
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(Find_First_Object("ATTACKER ENTRY POSITION"), 3.5)
	Sleep(3.5)

	p_republic.Make_Enemy(p_cis)
	p_cis.Make_Enemy(p_republic)

	MissionUtil.SetObjectiveMissionSet("NET_NABOO_NEGATIVE", "CIS", 3)

	current_cinematic_thread_id = nil

	cinematic_one = false
	act_1_active = true

	MissionUtil.VictoryAllowance(true)
	MissionUtil.AIActivation()
end
