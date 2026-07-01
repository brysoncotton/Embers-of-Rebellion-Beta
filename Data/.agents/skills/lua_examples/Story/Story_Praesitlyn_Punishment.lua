
--*****************************************************--
--*** Operation Knight Hammer: Praesitlyn Punishment **--
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
	cinematic_two_alt_01 = false
	cinematic_two_alt_02 = false

	cinematic_one_skipped = false
	cinematic_two_alt_01_skipped = false
	cinematic_two_alt_02_skipped = false

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

		outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-1")
		outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-2")

		outrocam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-1")

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
		rep_11_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-11")
		rep_12_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-12")

		outro_cr90_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cr90-1")
		outro_cr90_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cr90-2")
		outro_carrack_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-carrack-1")

		mission_started = true
		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
		end
	end
end

function State_Hero_Death()
	MissionUtil.SetMissionObjectiveComplete("PRAESITLYN_PUNISHMENT", "CIS", 2)
	p_cis.Give_Money(15000)
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

				MissionUtil.SetObjectiveMissionSet("PRAESITLYN_PUNISHMENT", "CIS", 2)
				MissionUtil.CinematicSkippingCleanUp(Find_First_Object("REINFORCEMENT_POINT_PLUS6_CAP"))

				cinematic_one = false
				act_1_active = true

				Fade_Screen_In(0.5)
			end
		end
		if cinematic_two_alt_01 then
			if not cinematic_two_alt_01_skipped then
				cinematic_two_alt_01_skipped = true

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

				StoryUtil.DeclareVictory(p_cis, false)
			end
		end
		if cinematic_two_alt_02 then
			if not cinematic_two_alt_02_skipped then
				cinematic_two_alt_02_skipped = true

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
	if p_cis.Is_Human() then
		if act_1_active then
			local rep_outpost_list = Find_All_Objects_With_Hint("base")
			if (table.getn(rep_outpost_list) == 0) then
				if not battle_over then
					battle_over = true
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_01_CIS")
				end
			end
			local cis_list = Find_All_Objects_Of_Type(p_cis, "Vehicle | Infantry | AirGunship | AirSpeeder")
			if (table.getn(cis_list) == 0) then
				if not battle_over then
					battle_over = true
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_02_CIS")
				end
			end
		end
	end
end


function Start_Cinematic_Intro_CIS()
	player_khamar = MissionUtil.SpawnUnitGround("KHAMAR_A5RX", rep_1_marker, p_republic)
	Register_Death_Event(player_khamar, State_Hero_Death)

	MissionUtil.SpawnUnitGround("ARROW_23_COMPANY", rep_2_marker, p_republic)
	MissionUtil.SpawnUnitGround("ESPO_WALKER_91_COMPANY", rep_3_marker, p_republic)
	MissionUtil.SpawnUnitGround("REPUBLIC_74Z_BIKE_COMPANY", rep_4_marker, p_republic)
	MissionUtil.SpawnUnitGround("REPUBLIC_TROOPER_COMPANY", rep_5_marker, p_republic)
	MissionUtil.SpawnUnitGround("REPUBLIC_TROOPER_COMPANY", rep_6_marker, p_republic)
	MissionUtil.SpawnUnitGround("REPUBLIC_TROOPER_COMPANY", rep_7_marker, p_republic)
	MissionUtil.SpawnUnitGround("REPUBLIC_GIAN_COMPANY", rep_8_marker, p_republic)
	MissionUtil.SpawnUnitGround("AV7_COMPANY", rep_9_marker, p_republic)
	MissionUtil.SpawnUnitGround("AV7_COMPANY", rep_10_marker, p_republic)
	MissionUtil.SpawnUnitGround("REPUBLIC_VAAT_COMPANY", rep_11_marker, p_republic)
	MissionUtil.SpawnUnitGround("REPUBLIC_OVERRACER_SPEEDER_BIKE_COMPANY", rep_12_marker, p_republic)

	cinematic_one = true

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	Sleep(1.0)

	MissionUtil.PlayGenericMusic("ESB_The_Ice_Planet_Hoth")
	MissionUtil.CinematicIntroHeader("PRAESITLYN_PUNISHMENT")

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, true, 16.0, nil, nil)

	Fade_Screen_In(5.0)
	Letter_Box_In(1.0)
	Sleep(10.0)

	MissionUtil.MissionTextSpeech("PRAESITLYN_PUNISHMENT", 1, 5.0, nil, nil, 0)
	Sleep(5.5)

	MissionUtil.MissionTextSpeech("PRAESITLYN_PUNISHMENT", 2, 12.0, nil, nil, 0)
	MissionUtil.MissionTextSpeech("PRAESITLYN_PUNISHMENT", 3, 12.0, nil, nil, 0)

	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_4_marker, true, 12.5, nil, nil)
	Sleep(12.5)

	MissionUtil.MissionTextSpeech("PRAESITLYN_PUNISHMENT", 4, 12.0, nil, nil, 0)
	MissionUtil.MissionTextSpeech("PRAESITLYN_PUNISHMENT", 5, 12.0, nil, nil, 0)

	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_5_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_6_marker, true, 12.5, nil, nil)
	Sleep(12.5)

	MissionUtil.MissionTextSpeech("PRAESITLYN_PUNISHMENT", 6, 12.0, nil, nil, 0)
	MissionUtil.MissionTextSpeech("PRAESITLYN_PUNISHMENT", 7, 12.0, nil, nil, 0)

	MissionUtil.SetCinematicCamera(introcam_7_marker, introcam_target_7_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_8_marker, introcam_target_8_marker, true, 12.5, nil, nil)
	Sleep(12.5)

	MissionUtil.MissionTextSpeech("PRAESITLYN_PUNISHMENT", 8, 12.0, nil, nil, 0)
	MissionUtil.MissionTextSpeech("PRAESITLYN_PUNISHMENT", 9, 12.0, nil, nil, 0)

	MissionUtil.SetCinematicCamera(introcam_9_marker, introcam_target_9_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_10_marker, introcam_target_10_marker, true, 12.5, nil, nil)
	Sleep(12.5)

	MissionUtil.PlayGenericMusic("CW_ARC_Trooper_Theme")

	MissionUtil.MissionTextSpeech("PRAESITLYN_PUNISHMENT", 10, 12.0, nil, nil, 0)
	MissionUtil.MissionTextSpeech("PRAESITLYN_PUNISHMENT", 11, 12.0, nil, nil, 0)

	MissionUtil.SetCinematicCamera(introcam_11_marker, introcam_target_11_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_12_marker, introcam_target_12_marker, true, 10, nil, nil)
	Sleep(10)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end
function End_Cinematic_Intro_CIS()
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(Find_First_Object("REINFORCEMENT_POINT_PLUS6_CAP"), 3.5)
	Sleep(3.5)

	p_republic.Make_Enemy(p_cis)
	p_cis.Make_Enemy(p_republic)

	MissionUtil.SetObjectiveMissionSet("PRAESITLYN_PUNISHMENT", "CIS", 2)
	MissionUtil.CinematicEnvironmentOff()
	Stop_All_Speech()

	current_cinematic_thread_id = nil
	MissionUtil.AIActivation()

	cinematic_one = false
	act_1_active = true
end

function Start_Cinematic_Outro_01_CIS()
	act_1_active = false
	cinematic_two_alt_01 = true

	p_c9979_lander = MissionUtil.CreateCinematicLander("C9979_CARRIER_LANDING_FULL", outro_carrack_1_marker, p_cis, 11, true, "LANDING", 0.0)
	p_hardcell_1_lander = MissionUtil.CreateCinematicLander("HARDCELL_LANDING", outro_cr90_1_marker, p_cis, 11, true, "LANDING", 0.0)
	p_hardcell_2_lander = MissionUtil.CreateCinematicLander("HARDCELL_LANDING", outro_cr90_2_marker, p_cis, 11, true, "LANDING", 0.0)

	Fade_Screen_Out(0.5)
	Sleep(0.5)

	MissionUtil.CinematicEnvironmentOn()
	MissionUtil.StartCinematicCamera()
	Sleep(0.5)

	Fade_Screen_In(0.5)
	MissionUtil.MissionTextSpeech("PRAESITLYN_PUNISHMENT", 12, 8.0, nil, nil, 0)
	MissionUtil.PlayGenericMusic("Trade_Federation_Theme")

	MissionUtil.SetCinematicCamera(outrocam_1_marker, outrocam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outrocam_target_1_marker, true, 8.0, nil, nil)
	Sleep(3.0)

	Fade_Screen_Out(4.0)
	Sleep(5.0)

	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.DisableRetreat("REBEL", false)
	MissionUtil.DisableRetreat("EMPIRE", false)

	p_cis.Disable_Orbital_Bombardment(false)
	p_republic.Disable_Orbital_Bombardment(false)

	p_republic.Disable_Bombing_Run(true)
	p_cis.Disable_Bombing_Run(true)
	StoryUtil.DeclareVictory(p_cis, false)
end
function Start_Cinematic_Outro_02_CIS()
	act_1_active = false
	cinematic_two_alt_02 = true

	Fade_Screen_Out(0.5)
	Sleep(0.5)

	MissionUtil.CinematicEnvironmentOn()
	MissionUtil.StartCinematicCamera()
	Sleep(0.5)

	Fade_Screen_In(0.5)
	MissionUtil.MissionTextSpeech("PRAESITLYN_PUNISHMENT", 5, 8.0, nil, nil, 0)
	MissionUtil.PlayGenericMusic("Clone_Army_Theme")

	MissionUtil.SetCinematicCamera(outrocam_1_marker, outrocam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outrocam_target_1_marker, true, 8.0, nil, nil)
	Sleep(3.0)

	Fade_Screen_Out(0.5)
	Sleep(5.0)

	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.DisableRetreat("REBEL", false)
	MissionUtil.DisableRetreat("EMPIRE", false)

	p_cis.Disable_Orbital_Bombardment(false)
	p_republic.Disable_Orbital_Bombardment(false)

	p_republic.Disable_Bombing_Run(true)
	p_cis.Disable_Bombing_Run(true)
	StoryUtil.DeclareVictory(p_cis, false)
end
