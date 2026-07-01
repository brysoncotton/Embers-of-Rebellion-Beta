
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
		introcam_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-9")
		introcam_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-10")
		introcam_11_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-11")
		introcam_12_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-12")
		introcam_13_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-13")
		introcam_14_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-14")
		introcam_15_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-15")
		introcam_16_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-16")
		introcam_17_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-17")
		introcam_18_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-18")
		introcam_19_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-19")
		introcam_20_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-20")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")
		introcam_target_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-4")
		introcam_target_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-5")
		introcam_target_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-6")

		outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-1")
		outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-2")

		outrocam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-1")

		rep_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-1")
		rep_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-2")
		rep_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-3")
		rep_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-4")
		rep_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-5")

		cis_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-1")
		cis_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-2")
		cis_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-3")
		cis_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-4")
		cis_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-5")

		player_halcyon = Find_Hint("NEJAA_HALCYON", "2")
		Register_Death_Event(player_slayke, State_Hero_Death_Halcyon)

		player_anakin = Find_Hint("ANAKIN", "2")
		Register_Death_Event(player_anakin, State_Hero_Death_Anakin)

		player_slayke = Find_Hint("ZOZRIDOR_SLAYKE", "2")
		Register_Death_Event(player_slayke, State_Hero_Death_Slayke)

		player_grudo = Find_Hint("grudo", "2")

		p_victory_point = Find_Hint("REINFORCEMENT_POINT_PLUS5_CAP", "vp")

		mission_started = true
		if p_republic.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
		end
	end
end

function State_Hero_Death_Halcyon(self_obj, trigger_obj)
	MissionUtil.SetMissionObjectiveFailed("PRAESITLYN_PROBLEMS", "Rep", 3)
end
function State_Hero_Death_Anakin(self_obj, trigger_obj)
	MissionUtil.SetMissionObjectiveFailed("PRAESITLYN_PROBLEMS", "Rep", 4)
end
function State_Hero_Death_Slayke(self_obj, trigger_obj)
	MissionUtil.SetMissionObjectiveFailed("PRAESITLYN_PROBLEMS", "Rep", 5)
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

				p_victory_point.Highlight(true)
				Add_Radar_Blip(p_victory_point, "victory_point_blip")

				MissionUtil.SpawnUnitGround("B1_DROID_COMPANY", cis_1_marker, p_cis)
				MissionUtil.SpawnUnitGround("B2_DROID_COMPANY", cis_2_marker, p_cis)
				MissionUtil.SpawnUnitGround("CIS_STAP_COMPANY", cis_3_marker, p_cis)
				MissionUtil.SpawnUnitGround("AAT_COMPANY", cis_4_marker, p_cis)
				MissionUtil.SpawnUnitGround("MTT_COMPANY", cis_5_marker, p_cis)

				MissionUtil.AddToReinforcementPool("NEIMOIDIAN_GUARD_COMPANY", p_cis, 5)
				MissionUtil.AddToReinforcementPool("SUPER_TANK_COMPANY", p_cis, 5)
				MissionUtil.AddToReinforcementPool("SKAKOAN_COMBAT_ENGINEER_COMPANY", p_cis, 5)
				MissionUtil.AddToReinforcementPool("NIMBUS_COMMANDO_COMPANY", p_cis, 5)
				MissionUtil.AddToReinforcementPool("B1_DROID_COMPANY", p_cis, 12)
				MissionUtil.AddToReinforcementPool("B2_DROID_COMPANY", p_cis, 12)
				MissionUtil.AddToReinforcementPool("CA_ARTILLERY_COMPANY", p_cis, 2)
				MissionUtil.AddToReinforcementPool("CIS_MAF_COMPANY", p_cis, 2)
				MissionUtil.AddToReinforcementPool("CIS_STAP_COMPANY", p_cis, 8)
				MissionUtil.AddToReinforcementPool("AAT_COMPANY", p_cis, 2)
				MissionUtil.AddToReinforcementPool("CRAB_DROID_COMPANY", p_cis, 8)
				MissionUtil.AddToReinforcementPool("J1_CANNON_COMPANY", p_cis, 3)
				MissionUtil.AddToReinforcementPool("MTT_COMPANY", p_cis, 2)
				MissionUtil.AddToReinforcementPool("HAILFIRE_COMPANY", p_cis, 5)

				if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
					MissionUtil.AddToReinforcementPool("CLONETROOPER_PHASE_TWO_COMPANY", p_republic, 8)
					MissionUtil.AddToReinforcementPool("CLONE_JUMPTROOPER_PHASE_TWO_COMPANY", p_republic, 8)
					MissionUtil.AddToReinforcementPool("ARC_PHASE_TWO_COMPANY", p_republic, 8)
				else
					MissionUtil.AddToReinforcementPool("CLONETROOPER_PHASE_ONE_COMPANY", p_republic, 8)
					MissionUtil.AddToReinforcementPool("CLONE_JUMPTROOPER_PHASE_ONE_COMPANY", p_republic, 8)
					MissionUtil.AddToReinforcementPool("ARC_PHASE_ONE_COMPANY", p_republic, 8)
				end

				MissionUtil.AddToReinforcementPool("REPUBLIC_TX130S_COMPANY", p_republic, 8)
				MissionUtil.AddToReinforcementPool("REPUBLIC_SD_6_DROID_COMPANY", p_republic, 8)
				MissionUtil.AddToReinforcementPool("REPUBLIC_AT_TE_WALKER_COMPANY", p_republic, 8)
				MissionUtil.AddToReinforcementPool("REPUBLIC_UT_AA_COMPANY", p_republic, 8)
				MissionUtil.AddToReinforcementPool("UT_AT_SPEEDER_COMPANY", p_republic, 8)
				MissionUtil.AddToReinforcementPool("SPECIAL_TACTICS_TROOPER_COMPANY", p_republic, 8)
				MissionUtil.AddToReinforcementPool("REPUBLIC_ISP_COMPANY", p_republic, 8)
				MissionUtil.AddToReinforcementPool("REPUBLIC_GIAN_COMPANY", p_republic, 8)
				MissionUtil.AddToReinforcementPool("AT_XT_COMPANY", p_republic, 8)
				MissionUtil.AddToReinforcementPool("REPUBLIC_AT_RT_COMPANY", p_republic, 8)
				MissionUtil.AddToReinforcementPool("REPUBLIC_74Z_BIKE_COMPANY", p_republic, 8)
				MissionUtil.AddToReinforcementPool("PDF_SOLDIER_COMPANY", p_republic, 8)

				Hide_Sub_Object(player_halcyon, 0, "blade");
				Hide_Sub_Object(player_anakin, 0, "lightsaber");

				MissionUtil.SetObjectiveMissionSet("PRAESITLYN_PROBLEMS", "REP", 5)
				MissionUtil.CinematicSkippingCleanUp(Find_First_Object("ZOZRIDOR_SLAYKE"))

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
			if p_victory_point.Get_Owner() == p_republic then
				if not battle_over then
					battle_over = true
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
				end
			end
		end
	end
end

function Start_Cinematic_Intro_Rep()
	MissionUtil.SpawnUnitGround("REPUBLIC_AT_AP_WALKER_COMPANY", rep_1_marker, p_republic)
	MissionUtil.SpawnUnitGround("ESPO_WALKER_91_COMPANY", rep_3_marker, p_republic)
	MissionUtil.SpawnUnitGround("REPUBLIC_74Z_BIKE_COMPANY", rep_4_marker, p_republic)
	MissionUtil.SpawnUnitGround("REPUBLIC_TROOPER_COMPANY", rep_5_marker, p_republic)

	if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
		MissionUtil.SpawnUnitGround("CLONETROOPER_PHASE_TWO_COMPANY", rep_2_marker, p_republic)
	else
		MissionUtil.SpawnUnitGround("CLONETROOPER_PHASE_ONE_COMPANY", rep_2_marker, p_republic)
	end

	cinematic_one = true

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	Sleep(1.0)

	MissionUtil.PlayGenericMusic("ESB_The_Ice_Planet_Hoth")
	MissionUtil.CinematicIntroHeader("PRAESITLYN_PROBLEMS")

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, true, 10.0, nil, nil)

	Fade_Screen_In(3.0)
	Letter_Box_In(1.0)
	Sleep(6.0)

	Fade_Screen_Out(3.0)
	Sleep(4.0)

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

	Hide_Sub_Object(player_halcyon, 1, "blade");
	Hide_Sub_Object(player_anakin, 1, "lightsaber");

	Fade_Screen_In(2.0)

	player_slayke.Turn_To_Face(player_halcyon)
	MissionUtil.PlayAnimation(player_slayke, "TALK_GESTURE", true, 0)

	MissionUtil.MissionTextSpeech("PRAESITLYN_PROBLEMS", 1, 12.0, nil, nil, 0)
	MissionUtil.MissionTextSpeech("PRAESITLYN_PROBLEMS", 2, 12.0, nil, nil, 0)

	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_3_marker, true, 12.0, nil, nil)
	Sleep(12.5)

	local group_1_table = Find_All_Objects_With_Hint("1")
	for i,group_1 in pairs(group_1_table) do
		if TestValid(group_1) then
			group_1.Turn_To_Face(player_anakin)
		end
	end

	local group_2_table = Find_All_Objects_With_Hint("2")
	for i,group_2 in pairs(group_2_table) do
		if TestValid(group_2) then
			group_2.Turn_To_Face(player_anakin)
		end
	end

	player_anakin.Turn_To_Face(player_slayke)
	MissionUtil.PlayAnimation(player_anakin, "TALK", false, 1)

	MissionUtil.MissionTextSpeech("PRAESITLYN_PROBLEMS", 3, 11.0, nil, nil, 0)
	MissionUtil.MissionTextSpeech("PRAESITLYN_PROBLEMS", 4, 11.0, nil, nil, 0)

	MissionUtil.SetCinematicCamera(introcam_7_marker, introcam_target_4_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_9_marker, introcam_target_4_marker, true, 11.5, nil, nil)
	Sleep(11.5)

	MissionUtil.PlayAnimation(player_anakin, "TALK", false, 1)

	MissionUtil.MissionTextSpeech("PRAESITLYN_PROBLEMS", 5, 11.0, nil, nil, 0)
	MissionUtil.MissionTextSpeech("PRAESITLYN_PROBLEMS", 6, 11.0, nil, nil, 0)

	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_4_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_4_marker, true, 11.5, nil, nil)
	Sleep(11.5)

	player_anakin.Turn_To_Face(player_halcyon)
	MissionUtil.PlayAnimation(player_anakin, "IDLE", false, 0)

	MissionUtil.PlayAnimation(player_halcyon, "TALK", false, 0)

	MissionUtil.MissionTextSpeech("PRAESITLYN_PROBLEMS", 7, 5.0, nil, nil, 0)

	MissionUtil.SetCinematicCamera(introcam_7_marker, introcam_target_5_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_8_marker, introcam_target_5_marker, true, 5.5, nil, nil)
	Sleep(5.5)

	player_anakin.Turn_To_Face(player_grudo)
	MissionUtil.PlayAnimation(player_anakin, "TALK", false, 0)

	MissionUtil.MissionTextSpeech("PRAESITLYN_PROBLEMS", 8, 8.0, nil, nil, 0)

	MissionUtil.SetCinematicCamera(introcam_9_marker, introcam_target_4_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_10_marker, introcam_target_6_marker, true, 8.5, nil, nil)
	Sleep(8.5)

	local group_1_table = Find_All_Objects_With_Hint("1")
	for i,group_1 in pairs(group_1_table) do
		if TestValid(group_1) then
			group_1.Turn_To_Face(player_grudo)
		end
	end

	local group_2_table = Find_All_Objects_With_Hint("2")
	for i,group_2 in pairs(group_2_table) do
		if TestValid(group_2) then
			group_2.Turn_To_Face(player_grudo)
		end
	end

	player_grudo.Turn_To_Face(player_anakin)
	MissionUtil.PlayAnimation(player_grudo, "IDLE", false, 0)

	MissionUtil.MissionTextSpeech("PRAESITLYN_PROBLEMS", 9, 8.0, nil, nil, 0)

	MissionUtil.SetCinematicCamera(introcam_11_marker, introcam_target_6_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_12_marker, introcam_target_6_marker, true, 8.5, nil, nil)
	Sleep(8.5)

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

	player_slayke.Turn_To_Face(player_anakin)
	MissionUtil.PlayAnimation(player_slayke, "TALK_GESTURE", false, 0)

	MissionUtil.MissionTextSpeech("PRAESITLYN_PROBLEMS", 10, 7.0, nil, nil, 0)

	MissionUtil.SetCinematicCamera(introcam_13_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_14_marker, introcam_target_3_marker, true, 7.5, nil, nil)
	Sleep(7.5)

	local group_2_table = Find_All_Objects_With_Hint("2")
	for i,group_2 in pairs(group_2_table) do
		if TestValid(group_2) then
			group_2.Turn_To_Face(player_halcyon)
		end
	end

	MissionUtil.PlayAnimation(player_halcyon, "TALK", false, 1)

	MissionUtil.MissionTextSpeech("PRAESITLYN_PROBLEMS", 11, 12.0, nil, nil, 0)
	MissionUtil.MissionTextSpeech("PRAESITLYN_PROBLEMS", 12, 12.0, nil, nil, 0)

	MissionUtil.SetCinematicCamera(introcam_15_marker, introcam_target_5_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_16_marker, introcam_target_5_marker, true, 12.5, nil, nil)
	Sleep(12.5)

	MissionUtil.PlayAnimation(player_halcyon, "IDLE", false, 0)

	MissionUtil.PlayAnimation(player_slayke, "TALK_GESTURE", false, 0)

	MissionUtil.MissionTextSpeech("PRAESITLYN_PROBLEMS", 13, 7.0, nil, nil, 0)

	MissionUtil.SetCinematicCamera(introcam_17_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_18_marker, introcam_target_3_marker, true, 7.5, nil, nil)
	Sleep(7.5)

	player_slayke.Turn_To_Face(player_anakin)

	player_anakin.Turn_To_Face(player_slayke)
	MissionUtil.PlayAnimation(player_anakin, "TALK_GESTURE", false, 0)

	MissionUtil.MissionTextSpeech("PRAESITLYN_PROBLEMS", 14, 7.0, nil, nil, 0)

	MissionUtil.SetCinematicCamera(introcam_19_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_20_marker, introcam_target_3_marker, true, 12.5, nil, nil)
	Sleep(7.5)

	MissionUtil.PlayAnimation(player_slayke, "TALK_GESTURE", false, 0)

	MissionUtil.MissionTextSpeech("PRAESITLYN_PROBLEMS", 15, 7.0, nil, nil, 0)

	Sleep(4.5)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Rep")
	end
end
function End_Cinematic_Intro_Rep()
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(player_anakin, 3.5)
	Sleep(3.5)

	p_republic.Make_Enemy(p_cis)
	p_cis.Make_Enemy(p_republic)

	MissionUtil.AIActivation()

	MissionUtil.SetObjectiveMissionSet("PRAESITLYN_PROBLEMS", "REP", 5)
	Stop_All_Speech()

	Hide_Sub_Object(player_halcyon, 0, "blade");
	Hide_Sub_Object(player_anakin, 0, "lightsaber");

	local despawn_me_table = Find_All_Objects_With_Hint("1")
	for i,despawn_me in pairs(despawn_me_table) do
		if TestValid(despawn_me) then
			despawn_me.Despawn()
		end
	end

	p_victory_point.Highlight(true)
	Add_Radar_Blip(p_victory_point, "victory_point_blip")

	current_cinematic_thread_id = nil

	MissionUtil.SpawnUnitGround("B1_DROID_COMPANY", cis_1_marker, p_cis)
	MissionUtil.SpawnUnitGround("B2_DROID_COMPANY", cis_2_marker, p_cis)
	MissionUtil.SpawnUnitGround("CIS_STAP_COMPANY", cis_3_marker, p_cis)
	MissionUtil.SpawnUnitGround("AAT_COMPANY", cis_4_marker, p_cis)
	MissionUtil.SpawnUnitGround("MTT_COMPANY", cis_5_marker, p_cis)

	MissionUtil.AddToReinforcementPool("NEIMOIDIAN_GUARD_COMPANY", p_cis, 5)
	MissionUtil.AddToReinforcementPool("SUPER_TANK_COMPANY", p_cis, 5)
	MissionUtil.AddToReinforcementPool("SKAKOAN_COMBAT_ENGINEER_COMPANY", p_cis, 5)
	MissionUtil.AddToReinforcementPool("NIMBUS_COMMANDO_COMPANY", p_cis, 5)
	MissionUtil.AddToReinforcementPool("B1_DROID_COMPANY", p_cis, 12)
	MissionUtil.AddToReinforcementPool("B2_DROID_COMPANY", p_cis, 12)
	MissionUtil.AddToReinforcementPool("CA_ARTILLERY_COMPANY", p_cis, 2)
	MissionUtil.AddToReinforcementPool("CIS_MAF_COMPANY", p_cis, 2)
	MissionUtil.AddToReinforcementPool("CIS_STAP_COMPANY", p_cis, 8)
	MissionUtil.AddToReinforcementPool("AAT_COMPANY", p_cis, 2)
	MissionUtil.AddToReinforcementPool("CRAB_DROID_COMPANY", p_cis, 8)
	MissionUtil.AddToReinforcementPool("J1_CANNON_COMPANY", p_cis, 3)
	MissionUtil.AddToReinforcementPool("MTT_COMPANY", p_cis, 2)
	MissionUtil.AddToReinforcementPool("HAILFIRE_COMPANY", p_cis, 5)

	if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
		MissionUtil.AddToReinforcementPool("CLONETROOPER_PHASE_TWO_COMPANY", p_republic, 8)
		MissionUtil.AddToReinforcementPool("CLONE_JUMPTROOPER_PHASE_TWO_COMPANY", p_republic, 8)
		MissionUtil.AddToReinforcementPool("ARC_PHASE_TWO_COMPANY", p_republic, 8)
	else
		MissionUtil.AddToReinforcementPool("CLONETROOPER_PHASE_ONE_COMPANY", p_republic, 8)
		MissionUtil.AddToReinforcementPool("CLONE_JUMPTROOPER_PHASE_ONE_COMPANY", p_republic, 8)
		MissionUtil.AddToReinforcementPool("ARC_PHASE_ONE_COMPANY", p_republic, 8)
	end

	MissionUtil.AddToReinforcementPool("REPUBLIC_TX130S_COMPANY", p_republic, 8)
	MissionUtil.AddToReinforcementPool("REPUBLIC_SD_6_DROID_COMPANY", p_republic, 8)
	MissionUtil.AddToReinforcementPool("REPUBLIC_AT_TE_WALKER_COMPANY", p_republic, 8)
	MissionUtil.AddToReinforcementPool("REPUBLIC_UT_AA_COMPANY", p_republic, 8)
	MissionUtil.AddToReinforcementPool("UT_AT_SPEEDER_COMPANY", p_republic, 8)
	MissionUtil.AddToReinforcementPool("SPECIAL_TACTICS_TROOPER_COMPANY", p_republic, 8)
	MissionUtil.AddToReinforcementPool("REPUBLIC_ISP_COMPANY", p_republic, 8)
	MissionUtil.AddToReinforcementPool("REPUBLIC_GIAN_COMPANY", p_republic, 8)
	MissionUtil.AddToReinforcementPool("AT_XT_COMPANY", p_republic, 8)
	MissionUtil.AddToReinforcementPool("REPUBLIC_AT_RT_COMPANY", p_republic, 8)
	MissionUtil.AddToReinforcementPool("REPUBLIC_74Z_BIKE_COMPANY", p_republic, 8)
	MissionUtil.AddToReinforcementPool("PDF_SOLDIER_COMPANY", p_republic, 8)

	cinematic_one = false
	act_1_active = true
end

function Start_Cinematic_Outro_Rep()
	act_1_active = false
	cinematic_two = true

	Fade_Screen_Out(0.5)
	Sleep(0.5)

	MissionUtil.CinematicEnvironmentOn()
	MissionUtil.StartCinematicCamera()
	Sleep(0.5)

	Fade_Screen_In(0.5)
	MissionUtil.MissionTextSpeech("PRAESITLYN_PROBLEMS", 16, 8.0, nil, nil, 0)
	MissionUtil.MissionTextSpeech("PRAESITLYN_PROBLEMS", 17, 8.0, nil, nil, 0)
	MissionUtil.PlayGenericMusic("CW_ARC_Trooper_Theme")

	MissionUtil.SetCinematicCamera(outrocam_1_marker, outrocam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outrocam_target_1_marker, true, 8.0, nil, nil)
	Sleep(4.0)

	Fade_Screen_Out(3.0)
	Sleep(4.0)

	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.DisableRetreat("REBEL", false)
	MissionUtil.DisableRetreat("EMPIRE", false)

	p_cis.Disable_Orbital_Bombardment(false)
	p_republic.Disable_Orbital_Bombardment(false)

	p_republic.Disable_Bombing_Run(true)
	p_cis.Disable_Bombing_Run(true)
	StoryUtil.DeclareVictory(p_republic, false)
end