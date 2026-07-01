
--*****************************************************--
--*** Operation Knight Hammer: Praesitlyn Pressure ****--
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
	cinematic_two = false

	cinematic_one_skipped = false
	cinematic_two_skipped = false

	defenders_spawned = false

	timer_started = false
	battle_over = false

	mission_started = false
end
function Begin_Battle(message)
	if message == OnEnter then
		MissionUtil.VictoryAllowance(false)

		MissionUtil.DisableRetreat("REBEL", true)
		MissionUtil.DisableRetreat("EMPIRE", true)

		p_cis.Disable_Orbital_Bombardment(true)
		p_republic.Disable_Orbital_Bombardment(true)

		p_republic.Disable_Bombing_Run(false)
		p_cis.Disable_Bombing_Run(false)


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

		outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-1")
		outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-2")

		outrocam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-1")

		lander_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lander-1")
		lander_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lander-2")
		lander_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lander-3")
		lander_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lander-4")
		lander_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lander-5")
		lander_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lander-6")
		lander_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lander-7")
		lander_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lander-8")
		lander_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lander-9")
		lander_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lander-10")

		rep_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-1")
		rep_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-2")
		rep_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-3")
		rep_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-4")
		rep_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-5")
		rep_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-6")
		rep_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-7")
		rep_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-8")
		rep_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-9")
		rep_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-10")

		outro_cr90_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cr90-1")
		outro_cr90_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cr90-2")
		outro_carrack_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-carrack-1")

		player_slayke = Find_Hint("ZOZRIDOR_SLAYKE", "slayke")

		mission_started = true
		if p_republic.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
		end
	end
end

function State_Hero_Death()
	MissionUtil.SetMissionObjectiveFailed("PRAESITLYN_PRESSURE", "Rep", 2)
end

function State_Enemy_Waves()
	Spawn_From_Reinforcement_Pool(Find_Object_Type("B1_DROID_COMPANY"), Find_First_Object("Attacker Entry Position"), p_cis)
	Spawn_From_Reinforcement_Pool(Find_Object_Type("B1_DROID_COMPANY"), Find_First_Object("Attacker Entry Position"), p_cis)
	Spawn_From_Reinforcement_Pool(Find_Object_Type("B2_DROID_COMPANY"), Find_First_Object("Attacker Entry Position"), p_cis)
	Spawn_From_Reinforcement_Pool(Find_Object_Type("CA_ARTILLERY_COMPANY"), Find_First_Object("Attacker Entry Position"), p_cis)
	Spawn_From_Reinforcement_Pool(Find_Object_Type("AAT_COMPANY"), Find_First_Object("Attacker Entry Position"), p_cis)
	Sleep(45.0)

	Spawn_From_Reinforcement_Pool(Find_Object_Type("CIS_STAP_COMPANY"), Find_First_Object("Attacker Entry Position"), p_cis)
	Spawn_From_Reinforcement_Pool(Find_Object_Type("J1_CANNON_COMPANY"), Find_First_Object("Attacker Entry Position"), p_cis)
	Spawn_From_Reinforcement_Pool(Find_Object_Type("B1_DROID_COMPANY"), Find_First_Object("Attacker Entry Position"), p_cis)
	Spawn_From_Reinforcement_Pool(Find_Object_Type("B2_DROID_COMPANY"), Find_First_Object("Attacker Entry Position"), p_cis)
	Sleep(90.0)

	if act_1_active then
		Create_Thread("State_Enemy_Waves")
	end
end
function State_Cavalry_Timer()
	if not timer_started then
		timer_started = true
		MissionUtil.SetMissionObjectiveNew("PRAESITLYN_PRESSURE", "REP", 8)

		Sleep(60)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 8, 9)
		Sleep(60)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 9, 10)
		Sleep(60)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 10, 11)
		Sleep(60)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 11, 12)
		Sleep(60)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 12, 13)
		Sleep(60)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 13, 14)
		Sleep(60)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 14, 15)

		Sleep(30)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 15, 16)
		Sleep(30)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 16, 17)
		Sleep(30)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 17, 18)
		Sleep(30)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 18, 19)

		Sleep(15)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 19, 20)
		Sleep(15)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 20, 21)

		Sleep(10)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 21, 22)
		Sleep(10)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 22, 23)

		Sleep(1)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 23, 24)
		Sleep(1)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 24, 25)
		Sleep(1)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 25, 26)
		Sleep(1)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 26, 27)
		Sleep(1)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 27, 28)
		Sleep(1)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 28, 29)
		Sleep(1)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 29, 30)
		Sleep(1)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 30, 31)
		Sleep(1)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 31, 32)
		Sleep(1)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 32, 33)
		Sleep(1)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 33, 24)
		Sleep(1)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 34, 33)
		Sleep(1)
		MissionUtil.SetMissionObjectiveUpdate("PRAESITLYN_PRESSURE", "REP", 33, 34)
	end
	if not battle_over then
		battle_over = true
		Create_Thread("Start_Cinematic_Outro_Rep")
	end
end

function Story_Handle_Esc()
	if p_republic.Is_Human() then
		if cinematic_one then
			if not cinematic_one_skipped then
				cinematic_one_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				local despawn_me_table = Find_All_Objects_With_Hint("1")
				for i,despawn_me in pairs(despawn_me_table) do
					if TestValid(despawn_me) then
						despawn_me.Despawn()
					end
				end

				local despawn_me_table = Find_All_Objects_With_Hint("2")
				for i,despawn_me in pairs(despawn_me_table) do
					if TestValid(despawn_me) then
						despawn_me.Despawn()
					end
				end

				MissionUtil.SetObjectiveMissionSet("PRAESITLYN_PRESSURE", "REP", 2)
				MissionUtil.CinematicSkippingCleanUp(Find_First_Object("ZOZRIDOR_SLAYKE"))

				Create_Thread("State_Cavalry_Timer")

				MissionUtil.AddToReinforcementPool("B1_DROID_COMPANY", p_cis, 18)
				MissionUtil.AddToReinforcementPool("B2_DROID_COMPANY", p_cis, 18)
				MissionUtil.AddToReinforcementPool("CA_ARTILLERY_COMPANY", p_cis, 8)
				MissionUtil.AddToReinforcementPool("CIS_MAF_COMPANY", p_cis, 8)
				MissionUtil.AddToReinforcementPool("CIS_STAP_COMPANY", p_cis, 8)
				MissionUtil.AddToReinforcementPool("AAT_COMPANY", p_cis, 8)
				MissionUtil.AddToReinforcementPool("CRAB_DROID_COMPANY", p_cis, 8)
				MissionUtil.AddToReinforcementPool("J1_CANNON_COMPANY", p_cis, 8)
				MissionUtil.AddToReinforcementPool("MTT_COMPANY", p_cis, 8)

				cinematic_one = false
				act_1_active = true

				Create_Thread("State_Enemy_Waves")

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

				p_cis.Disable_Orbital_Bombardment(false)
				p_republic.Disable_Orbital_Bombardment(false)

				p_republic.Disable_Bombing_Run(true)
				p_cis.Disable_Bombing_Run(true)

				MissionUtil.CinematicEnvironmentOff()
				MissionUtil.DisableRetreat("REBEL", false)
				MissionUtil.DisableRetreat("EMPIRE", false)

				StoryUtil.DeclareVictory(p_republic, false)
			end
		end
	end
end
function Story_Mode_Service()
	if p_republic.Is_Human() then
		if act_1_active then
			rep_outpost_list = Find_All_Objects_With_Hint("base")
			if (table.getn(rep_outpost_list) == 0) then
				if not battle_over then
					battle_over = true
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
				end
			end
		end
	end
end

function Start_Cinematic_Intro_Rep()
  MissionUtil.SpawnUnitGround("REPUBLIC_OVERRACER_SPEEDER_BIKE_COMPANY", rep_1_marker, p_republic)
	MissionUtil.SpawnUnitGround("REPUBLIC_TROOPER_COMPANY", rep_2_marker, p_republic)
	MissionUtil.SpawnUnitGround("ESPO_WALKER_91_COMPANY", rep_3_marker, p_republic)
	MissionUtil.SpawnUnitGround("STORM_CLOUD_CAR_COMPANY", rep_4_marker, p_republic)
	MissionUtil.SpawnUnitGround("AV7_COMPANY", rep_5_marker, p_republic)
	MissionUtil.SpawnUnitGround("REPUBLIC_TROOPER_COMPANY", rep_6_marker, p_republic)
	MissionUtil.SpawnUnitGround("REPUBLIC_TROOPER_COMPANY", rep_7_marker, p_republic)
	MissionUtil.SpawnUnitGround("REPUBLIC_GIAN_COMPANY", rep_8_marker, p_republic)
	MissionUtil.SpawnUnitGround("AV7_COMPANY", rep_9_marker, p_republic)
	MissionUtil.SpawnUnitGround("REPUBLIC_VAAT_COMPANY", rep_10_marker, p_republic)

	cinematic_one = true

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	Sleep(1.0)

	MissionUtil.PlayGenericMusic("Battle_of_Coruscant_Theme")
	MissionUtil.CinematicIntroHeader("PRAESITLYN_PRESSURE")

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, true, 16.0, nil, nil)

	Fade_Screen_In(5.0)
	Letter_Box_In(1.0)
	Sleep(10.0)

	local group_1_table = Find_All_Objects_With_Hint("1")
	for i,group_1 in pairs(group_1_table) do
		if TestValid(group_1) then
			group_1.Turn_To_Face(player_slayke)
		end
	end

	local group_2_table = Find_All_Objects_With_Hint("2")
	for i,group_2 in pairs(group_2_table) do
		if TestValid(group_2) then
			group_2.Turn_To_Face(player_slayke)
		end
	end

	MissionUtil.PlayAnimation(player_slayke, "TALK_GESTURE", false, 0)

	MissionUtil.MissionTextSpeech("PRAESITLYN_PRESSURE", 1, 12.0, nil, nil, 0)
	MissionUtil.MissionTextSpeech("PRAESITLYN_PRESSURE", 2, 12.0, nil, nil, 0)

	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_2_marker, true, 12.5, nil, nil)
	Sleep(12.5)

	MissionUtil.PlayAnimation(player_slayke, "TALK", true, 0)

	MissionUtil.MissionTextSpeech("PRAESITLYN_PRESSURE", 3, 12.0, nil, nil, 0)
	MissionUtil.MissionTextSpeech("PRAESITLYN_PRESSURE", 4, 12.0, nil, nil, 0)

	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_2_marker, true, 12.5, nil, nil)
	Sleep(12.5)

	MissionUtil.PlayAnimation(player_slayke, "TALK", true, 1)

	MissionUtil.MissionTextSpeech("PRAESITLYN_PRESSURE", 5, 12.0, nil, nil, 0)
	MissionUtil.MissionTextSpeech("PRAESITLYN_PRESSURE", 6, 12.0, nil, nil, 0)

	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_2_marker, true, 12.5, nil, nil)
	Sleep(12.5)

	MissionUtil.PlayAnimation(player_slayke, "TALK", true, 2)

	MissionUtil.MissionTextSpeech("PRAESITLYN_PRESSURE", 7, 10.0, nil, nil, 0)
	MissionUtil.MissionTextSpeech("PRAESITLYN_PRESSURE", 8, 10.0, nil, nil, 0)

	MissionUtil.SetCinematicCamera(introcam_7_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_8_marker, introcam_target_2_marker, true, 6.5, nil, nil)
	Sleep(6.5)

	MissionUtil.PlayAnimation(player_slayke, "TALK", false, 0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Rep")
	end
end
function End_Cinematic_Intro_Rep()
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(player_slayke, 3.5)
	Sleep(3.5)

	p_republic.Make_Enemy(p_cis)
	p_cis.Make_Enemy(p_republic)

	MissionUtil.AIActivation()

	MissionUtil.CinematicEnvironmentOff()
	Stop_All_Speech()

	local despawn_me_table = Find_All_Objects_With_Hint("1")
	for i,despawn_me in pairs(despawn_me_table) do
		if TestValid(despawn_me) then
			despawn_me.Despawn()
		end
	end

	local despawn_me_table = Find_All_Objects_With_Hint("2")
	for i,despawn_me in pairs(despawn_me_table) do
		if TestValid(despawn_me) then
			despawn_me.Despawn()
		end
	end

	MissionUtil.SetObjectiveMissionSet("PRAESITLYN_PRESSURE", "REP", 2)

	Create_Thread("State_Cavalry_Timer")

	current_cinematic_thread_id = nil

  MissionUtil.AddToReinforcementPool("B1_DROID_COMPANY", p_cis, 18)
	MissionUtil.AddToReinforcementPool("B2_DROID_COMPANY", p_cis, 18)
	MissionUtil.AddToReinforcementPool("CA_ARTILLERY_COMPANY", p_cis, 8)
	MissionUtil.AddToReinforcementPool("CIS_MAF_COMPANY", p_cis, 8)
	MissionUtil.AddToReinforcementPool("CIS_STAP_COMPANY", p_cis, 8)
	MissionUtil.AddToReinforcementPool("AAT_COMPANY", p_cis, 8)
	MissionUtil.AddToReinforcementPool("CRAB_DROID_COMPANY", p_cis, 8)
	MissionUtil.AddToReinforcementPool("J1_CANNON_COMPANY", p_cis, 8)
	MissionUtil.AddToReinforcementPool("MTT_COMPANY", p_cis, 8)

	cinematic_one = false
	act_1_active = true

	Create_Thread("State_Enemy_Waves")
end

function Start_Cinematic_Outro_Rep()

	StoryUtil.TriggerScriptedBattle("PRAESITLYN_PROBLEMS", "PRAESITLYN", "LAND", "REBEL", "EMPIRE", true)

	act_1_active = false
	cinematic_two = true

	p_lander_01 = MissionUtil.CreateCinematicLander("CR20_LANDING_CRAFT_LANDING", lander_1_marker, p_republic, 11, true, "LANDING", 0.0)
	Sleep(0.5)
	p_lander_02 = MissionUtil.CreateCinematicLander("CR20_LANDING_CRAFT_LANDING", lander_2_marker, p_republic, 10, true, "LANDING", 2.0)
	Sleep(0.3)
	p_lander_03 = MissionUtil.CreateCinematicLander("CR20_LANDING_CRAFT_LANDING", lander_3_marker, p_republic, 9, true, "LANDING", 4.0)
	Sleep(0.6)
	p_lander_04 = MissionUtil.CreateCinematicLander("CR20_LANDING_CRAFT_LANDING", lander_4_marker, p_republic, 15, true, "LANDING", 6.0)
	Sleep(0.9)
	p_lander_05 = MissionUtil.CreateCinematicLander("CR20_LANDING_CRAFT_LANDING", lander_5_marker, p_republic, 13, true, "LANDING", 7.0)
	Sleep(0.1)
	p_lander_06 = MissionUtil.CreateCinematicLander("CR20_LANDING_CRAFT_LANDING", lander_6_marker, p_republic, 8, true, "LANDING", 20.0)
	Sleep(1.0)
	p_lander_07 = MissionUtil.CreateCinematicLander("CR20_LANDING_CRAFT_LANDING", lander_7_marker, p_republic, 9, true, "LANDING", 350.0)
	Sleep(0.3)
	p_lander_08 = MissionUtil.CreateCinematicLander("CR20_LANDING_CRAFT_LANDING", lander_8_marker, p_republic, 10, true, "LANDING", 30.0)
	Sleep(0.5)
	p_lander_09 = MissionUtil.CreateCinematicLander("CR20_LANDING_CRAFT_LANDING", lander_9_marker, p_republic, 11, true, "LANDING", 345.0)
	Sleep(0.2)
	p_lander_10 = MissionUtil.CreateCinematicLander("CR20_LANDING_CRAFT_LANDING", lander_10_marker, p_republic, 13, true, "LANDING", 7.0)

	Fade_Screen_Out(0.5)
	Sleep(0.5)

	MissionUtil.CinematicEnvironmentOn()
	MissionUtil.StartCinematicCamera()
	Sleep(0.5)

	Fade_Screen_In(0.5)
	MissionUtil.MissionTextSpeech("PRAESITLYN_PRESSURE", 9, 12.0, nil, nil, 0)
	MissionUtil.MissionTextSpeech("PRAESITLYN_PRESSURE", 10, 12.0, nil, nil, 0)
	MissionUtil.PlayGenericMusic("CW_ARC_Trooper_Theme")

	MissionUtil.SetCinematicCamera(outrocam_1_marker, outrocam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outrocam_target_1_marker, true, 12.0, nil, nil)
	Sleep(7.0)

	Fade_Screen_Out(4.0)
	Sleep(5.0)

	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.DisableRetreat("REBEL", false)
	MissionUtil.DisableRetreat("EMPIRE", false)

	p_cis.Disable_Orbital_Bombardment(false)
	p_republic.Disable_Orbital_Bombardment(false)

	p_republic.Disable_Bombing_Run(true)
	p_cis.Disable_Bombing_Run(true)
	StoryUtil.DeclareVictory(p_republic, false)
end