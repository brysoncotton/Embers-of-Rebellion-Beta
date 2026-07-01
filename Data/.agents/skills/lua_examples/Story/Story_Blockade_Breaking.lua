
--*****************************************************--
--******** Foerost Campaign: Blockade Breaking ********--
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

	republic_avenger_list = {
		"CAPTOR",
		"CAPTOR",
		"LAC",
		"LAC",
		"LAC",
		"LAC",
		"CR90",
		"CR90",
		"ARQUITENS",
		"ARQUITENS",
	}
	cis_attacker_ai_list = {
		"BULWARK_I",
		"BULWARK_I",
		"BULWARK_I",
		"BULWARK_I",
		"BULWARK_I",
		"DIAMOND_FRIGATE",
		"DIAMOND_FRIGATE",
		"DIAMOND_FRIGATE",
		"DIAMOND_FRIGATE",
		"HARDCELL",
		"HARDCELL",
		"HARDCELL",
		"HARDCELL",
		"GEONOSIAN_CRUISER",
		"GEONOSIAN_CRUISER",
		"GEONOSIAN_CRUISER",
	}
	cis_attacker_list = {
		"BULWARK_I",
		"BULWARK_I",
		"BULWARK_I",
		"BULWARK_I",
		"BULWARK_I",
		"BULWARK_I",
		"BULWARK_I",
		"BULWARK_I",
		"DIAMOND_FRIGATE",
		"DIAMOND_FRIGATE",
		"DIAMOND_FRIGATE",
		"HARDCELL",
		"HARDCELL",
		"HARDCELL",
		"HARDCELL",
		"GEONOSIAN_CRUISER",
		"GEONOSIAN_CRUISER",
		"GEONOSIAN_CRUISER",
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")

	cinematic_crawl = false
	act_1_active = false
	act_2_active = false

	cinematic_one = false
	cinematic_two_alt_01 = false
	cinematic_two_alt_02 = false

	cinematic_crawl_skipped = false
	cinematic_one_skipped = false
	cinematic_two_alt_01_skipped = false
	cinematic_two_alt_02_skipped = false

	surveillance_station_dead = false
	cis_fleet_dead = false

	current_cinematic_thread_id = nil
end
function Begin_Battle(message)
	if message == OnEnter then
		MissionUtil.VictoryAllowance(false)
		MissionUtil.DisableRetreat("REBEL", true)
		MissionUtil.DisableRetreat("EMPIRE", true)

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

		intro_1_bw_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bw-1")
		intro_1_bw_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bw-2")
		intro_1_bw_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bw-3")
		intro_1_bw_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bw-4")
		intro_1_bw_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bw-5")
		intro_1_bw_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bw-6")
		intro_1_bw_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bw-7")
		intro_1_bw_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bw-8")
		intro_1_bw_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bw-9")

		intro_1_wolf_squadron_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-wolf")
		intro_2_wolf_squadron_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-wolf")

		outro_1_pod_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-1-pod")

		outro_1_ningo_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-1-ningo")
		outro_1_bw_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-1-bw-1")
		outro_1_bw_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-1-bw-2")

		outrocam_1_alt_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-1-alt-1")
		outrocam_2_alt_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-2-alt-1")
		outrocam_3_alt_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-3-alt-1")
		outrocam_4_alt_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-4-alt-1")

		outrocam_1_alt_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-1-alt-2")
		outrocam_2_alt_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-2-alt-2")

		rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-1")
		rep_fleet_02_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-2")
		rep_fleet_03_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-3")
		rep_fleet_04_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-4")
		rep_fleet_05_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-5")
		rep_fleet_06_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-6")
		rep_fleet_07_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-7")
		rep_fleet_08_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-8")
		rep_fleet_09_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-9")

		cis_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-fleet-1")

		player_station = Find_Hint("SURVEILLANCE_STATION_VALOR", "station")
		Register_Death_Event(player_station, State_Hero_Death_Station)

		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Crawl_CIS")
		elseif p_republic.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
		end
	end
end

function State_Nebulae_Reached_CIS()
	player_bw_1 = MissionUtil.SpawnUnitSpace("BULWARK_I", intro_1_bw_1_marker, p_cis)
	player_bw_2 = MissionUtil.SpawnUnitSpace("BULWARK_I", intro_1_bw_2_marker, p_cis)
	player_bw_3 = MissionUtil.SpawnUnitSpace("BULWARK_I", intro_1_bw_3_marker, p_cis)
	player_bw_4 = MissionUtil.SpawnUnitSpace("BULWARK_I", intro_1_bw_4_marker, p_cis)
	player_bw_5 = MissionUtil.SpawnUnitSpace("BULWARK_I", intro_1_bw_5_marker, p_cis)

	player_bw_1 = MissionUtil.SpawnUnitSpace("BULWARK_I", intro_1_bw_1_marker, p_cis)
	player_bw_2 = MissionUtil.SpawnUnitSpace("BULWARK_I", intro_1_bw_2_marker, p_cis)
	player_bw_3 = MissionUtil.SpawnUnitSpace("DIAMOND_FRIGATE", intro_1_bw_3_marker, p_cis)
	player_bw_4 = MissionUtil.SpawnUnitSpace("DIAMOND_FRIGATE", intro_1_bw_4_marker, p_cis)
	player_bw_5 = MissionUtil.SpawnUnitSpace("HARDCELL", intro_1_bw_5_marker, p_cis)
	player_bw_6 = MissionUtil.SpawnUnitSpace("HARDCELL", intro_1_bw_6_marker, p_cis)
	player_bw_7 = MissionUtil.SpawnUnitSpace("HARDCELL", intro_1_bw_7_marker, p_cis)
	player_bw_8 = MissionUtil.SpawnUnitSpace("GEONOSIAN_CRUISER", intro_1_bw_8_marker, p_cis)
	player_bw_9 = MissionUtil.SpawnUnitSpace("GEONOSIAN_CRUISER", intro_1_bw_9_marker, p_cis)

	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 10, 8.0, nil, {r = 250, g = 44, b = 44}) -- Wolf Leader
	Sleep(10.0)

	if StoryUtil.GetDifficulty() == "EASY" then
		Register_Timer(State_Avenger_Fleet_Arrives_CIS, 120)
	end
	if StoryUtil.GetDifficulty() == "NORMAL" then
		Register_Timer(State_Avenger_Fleet_Arrives_CIS, 80)
	end
	if StoryUtil.GetDifficulty() == "HARD" then
		Register_Timer(State_Avenger_Fleet_Arrives_CIS, 40)
	end

	Register_Timer(State_Second_Wave_Arrives_CIS, 20)
	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 11, 9.0, nil, {r = 250, g = 44, b = 44}) -- Captain Massel

	act_1_active = false
	act_2_active = true
end
function State_Nebulae_Reached_Rep()
	Remove_Radar_Blip("Nebula_Blip")

	SpawnList(cis_attacker_ai_list, intro_1_bw_1_marker.Get_Position(), p_cis, false, false)

	MissionUtil.SetMissionObjectiveNew("BLOCKADE_BREAKING", "REP", 2)
	MissionUtil.SetMissionObjectiveNew("BLOCKADE_BREAKING", "REP", 3)

	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 10, 8.0, nil, {r = 250, g = 44, b = 44}) -- Wolf Leader
	Sleep(10.0)

	if StoryUtil.GetDifficulty() == "EASY" then
		Register_Timer(State_Second_Wave_Arrives_Rep, 60)
		Register_Timer(State_Avenger_Fleet_Arrives_Rep, 45)
	end
	if StoryUtil.GetDifficulty() == "NORMAL" then
		Register_Timer(State_Second_Wave_Arrives_Rep, 45)
		Register_Timer(State_Avenger_Fleet_Arrives_Rep, 60)
	end
	if StoryUtil.GetDifficulty() == "HARD" then
		Register_Timer(State_Second_Wave_Arrives_Rep, 30)
		Register_Timer(State_Avenger_Fleet_Arrives_Rep, 45)
	end

	local cis_list = Find_All_Objects_Of_Type(p_cis, "SpaceHero | Corvette | Capital | Frigate | Fighter | Bomber | SuperCapital")
	for k,cis_unit in pairs(cis_list) do
		if TestValid(cis_unit) then
			cis_unit.Attack_Move(Find_First_Object("SURVEILLANCE_STATION_VALOR"))
		end
	end

	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 11, 9.0, nil, {r = 250, g = 44, b = 44}) -- Captain Massel

	act_1_active = false
	act_2_active = true
end

function State_Second_Wave_Arrives_CIS()
	player_bw_1 = MissionUtil.SpawnUnitSpace("BULWARK_I", intro_1_bw_1_marker, p_cis)
	player_bw_2 = MissionUtil.SpawnUnitSpace("BULWARK_I", intro_1_bw_2_marker, p_cis)
	player_bw_3 = MissionUtil.SpawnUnitSpace("BULWARK_I", intro_1_bw_3_marker, p_cis)
	player_bw_4 = MissionUtil.SpawnUnitSpace("BULWARK_I", intro_1_bw_4_marker, p_cis)
	player_bw_5 = MissionUtil.SpawnUnitSpace("BULWARK_I", intro_1_bw_5_marker, p_cis)

	player_bw_3 = MissionUtil.SpawnUnitSpace("DIAMOND_FRIGATE", intro_1_bw_3_marker, p_cis)
	player_bw_4 = MissionUtil.SpawnUnitSpace("DIAMOND_FRIGATE", intro_1_bw_4_marker, p_cis)
	player_bw_5 = MissionUtil.SpawnUnitSpace("HARDCELL", intro_1_bw_5_marker, p_cis)
	player_bw_6 = MissionUtil.SpawnUnitSpace("HARDCELL", intro_1_bw_6_marker, p_cis)
	player_bw_7 = MissionUtil.SpawnUnitSpace("HARDCELL", intro_1_bw_7_marker, p_cis)
	player_bw_8 = MissionUtil.SpawnUnitSpace("GEONOSIAN_CRUISER", intro_1_bw_8_marker, p_cis)
	player_bw_9 = MissionUtil.SpawnUnitSpace("GEONOSIAN_CRUISER", intro_1_bw_9_marker, p_cis)
end
function State_Second_Wave_Arrives_Rep()
	SpawnList(cis_attacker_ai_list, intro_1_bw_1_marker.Get_Position(), p_cis, false, false)

	Sleep(5.0)

	local cis_list = Find_All_Objects_Of_Type(p_cis, "SpaceHero | Corvette | Capital | Frigate | Fighter | Bomber | SuperCapital")
	for k,cis_unit in pairs(cis_list) do
		if TestValid(cis_unit) then
			cis_unit.Attack_Move(Find_First_Object("SURVEILLANCE_STATION_VALOR"))
		end
	end

	MissionUtil.AIActivation()
end

function State_Avenger_Fleet_Arrives_CIS()
	avenger_fleet_arrived = true

	AI_Republic_Fleet = SpawnList(republic_avenger_list, rep_fleet_01_marker.Get_Position(), p_republic, true, true)
	Republic_AI_Fleet = AI_Republic_Fleet[1]
	Republic_AI_Fleet.Teleport_And_Face(rep_fleet_01_marker)
	Republic_AI_Fleet.Cinematic_Hyperspace_In(150)

	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 12, 9.0, nil, {r = 250, g = 44, b = 44}) -- Republic Captain
end
function State_Avenger_Fleet_Arrives_Rep()
	avenger_fleet_arrived = true

	AI_Republic_Fleet = SpawnList(republic_avenger_list, rep_fleet_01_marker.Get_Position(), p_republic, true, true)
	Republic_AI_Fleet = AI_Republic_Fleet[1]
	Republic_AI_Fleet.Teleport_And_Face(rep_fleet_01_marker)
	Republic_AI_Fleet.Cinematic_Hyperspace_In(150)

	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 12, 9.0, nil, {r = 250, g = 44, b = 44}) -- Republic Captain
end

function State_Hero_Death_Station()
	if not cis_fleet_dead then
		surveillance_station_dead = true
		act_2_active = false
		Sleep(3.0)

		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS_Alt_01")
		elseif p_republic.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep_Alt_01")
		end
	end
end

function Story_Handle_Esc()
	if p_cis.Is_Human() then
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
				Weather_Audio_Pause(false)
				MissionUtil.CinematicEnvironmentOff()

				cinematic_crawl = false
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
			end
		end
		if cinematic_one then
			if not cinematic_one_skipped then
				cinematic_one_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				Register_Timer(State_Nebulae_Reached_CIS, 1)

				MissionUtil.SetObjectiveMissionSet("BLOCKADE_BREAKING", "CIS", 2)
				MissionUtil.CinematicSkippingCleanUp(intro_2_wolf_squadron_marker)

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

				MissionUtil.CinematicEnvironmentOff()

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

				MissionUtil.CinematicEnvironmentOff()

				StoryUtil.DeclareVictory(p_republic, false)
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

				Add_Radar_Blip(intro_2_wolf_squadron_marker, "Nebula_Blip")
				Register_Timer(State_Nebulae_Reached_Rep, 10)

				MissionUtil.SetObjectiveMissionSet("BLOCKADE_BREAKING", "REP", 1)
				MissionUtil.CinematicSkippingCleanUp(intro_2_wolf_squadron_marker)

				MissionUtil.AIActivation()

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

				MissionUtil.CinematicEnvironmentOff()

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

				MissionUtil.CinematicEnvironmentOff()

				StoryUtil.DeclareVictory(p_republic, false)
			end
		end
	end
end
function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_2_active then
			cis_list = Find_All_Objects_Of_Type(p_cis, "SpaceHero | Corvette | Capital | Frigate | SpaceStructure | SuperCapital")
			if (table.getn(cis_list) == 0) then
				if not cis_fleet_dead then
					cis_fleet_dead = true
					act_2_active = false

					if not surveillance_station_dead then
						current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS_Alt_02")
					end
				end
			end
		end
	end
	if p_republic.Is_Human() then
		if act_2_active then
			cis_list = Find_All_Objects_Of_Type("BULWARK_I")
			if (table.getn(cis_list) == 0) then
				if not cis_fleet_dead then
					cis_fleet_dead = true
					act_2_active = false

					if not surveillance_station_dead then
						current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep_Alt_02")
					end
				end
			end
		end
	end
end

function Start_Cinematic_Crawl_CIS()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true)

	cinematic_crawl = true
	MissionUtil.PlayCinematicMovieCrawl("Foerost_Campaign_CIS_Intro", "Clone_Wars_Crawl_Theme")
	MissionUtil.CinematicEnvironmentOff()

	if not cinematic_crawl_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
	end
end
function Start_Cinematic_Intro_CIS()
	cinematic_crawl = false

	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, true, 22.0, nil, nil)
	Letter_Box_In(1.0)

	player_wolf_squadron = Find_First_Object("ARC_170")
	mama_wolf = player_wolf_squadron.Get_Parent_Object()
	mama_wolf.Override_Max_Speed(4.5)

	cinematic_one = true

	MissionUtil.CinematicIntroHeader("BLOCKADE_BREAKING")
	MissionUtil.PlayGenericMusic("Clone_Army_Theme")
	Sleep(13.0)

	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 1, 5.0, nil, {r = 250, g = 44, b = 44}) -- Captain Massel
	Sleep(5.5)

	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 2, 16.0, nil, {r = 250, g = 44, b = 44}) -- Captain Massel
	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 3, 16.0, nil, {r = 250, g = 44, b = 44}) -- Captain Massel
	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_3_marker, true, 17.5, nil, nil)
	Sleep(17.0)

	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 4, 14.0, nil, {r = 250, g = 44, b = 44}) -- Captain Massel
	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 5, 14.0, nil, {r = 250, g = 44, b = 44}) -- Captain Massel
	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_2_marker, true, 15.5, nil, nil)
	Sleep(15.0)

	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 6, 6.0, nil, {r = 250, g = 44, b = 44}) -- Sgt. Lanno
	MissionUtil.SetCinematicCamera(introcam_7_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_8_marker, introcam_target_3_marker, true, 15.5, nil, nil)
	Sleep(6.5)

	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 7, 14.0, nil, {r = 250, g = 44, b = 44}) -- Captain Massel
	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 8, 14.0, nil, {r = 250, g = 44, b = 44}) -- Captain Massel
	MissionUtil.SetCinematicCamera(introcam_9_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_10_marker, introcam_target_4_marker, true, 14.5, nil, nil)
	Sleep(15.0)

	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 9, 9.0, nil, {r = 250, g = 44, b = 44}) -- Wolf Leader
	MissionUtil.SetCinematicCamera(introcam_11_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_12_marker, introcam_target_4_marker, true, 15.5, nil, nil)	Sleep(5.0)
	Sleep(6.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end
function End_Cinematic_Intro_CIS()
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(intro_1_bw_1_marker, 3.5)
	Sleep(3.5)

	MissionUtil.SetObjectiveMissionSet("BLOCKADE_BREAKING", "CIS", 2)

	Register_Timer(State_Nebulae_Reached_CIS, 5)

	current_cinematic_thread_id = nil

	cinematic_one = false
	act_1_active = true
	MissionUtil.AIActivation()
end

function Start_Cinematic_Outro_CIS_Alt_01()
	act_2_active = false
	cinematic_two_alt_01 = true

	Fade_On()
	Do_End_Cinematic_Cleanup()

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	player_pod = MissionUtil.SpawnUnitSpace("REPUBLIC_ESCAPE_POD", outro_1_pod_marker, p_republic, 100)

	MissionUtil.PlayGenericMusic("Republic_Defeat")
	Sleep(1.0)

	player_bw_1 = MissionUtil.SpawnUnitSpace("BULWARK_I", outro_1_ningo_marker, p_cis, 100)
	player_bw_2 = MissionUtil.SpawnUnitSpace("BULWARK_I", outro_1_bw_1_marker, p_cis, 100)
	player_bw_3 = MissionUtil.SpawnUnitSpace("BULWARK_I", outro_1_bw_2_marker, p_cis, 100)

	Letter_Box_In(1.0)
	Fade_Screen_In(2.0)

	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 13, 8.0, nil, {r = 250, g = 44, b = 44}) -- Captain Massel
	MissionUtil.SetCinematicCamera(outrocam_1_alt_1_marker, player_pod, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_2_alt_1_marker, player_pod, true, 8.5, nil, nil)
	Sleep(10.0)

	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 14, 7.0, nil, {r = 239, g = 139, b = 9}) -- Dua Ningo
	MissionUtil.SetCinematicCamera(outrocam_3_alt_1_marker, outro_1_ningo_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_4_alt_1_marker, outro_1_ningo_marker, true, 8.5, nil, nil)
	Fade_Screen_In(0.5)
	Sleep(4.0)

	player_bw_1.Hyperspace_Away(true)
	player_bw_2.Hyperspace_Away(true)
	player_bw_3.Hyperspace_Away(true)

	Fade_Screen_Out(2.0)
	Sleep(3.0)

	MissionUtil.CinematicEnvironmentOff()

	StoryUtil.DeclareVictory(p_cis, false)
end
function Start_Cinematic_Outro_CIS_Alt_02()
	act_2_active = false
	cinematic_two_alt_02 = true

	Fade_On()
	Do_End_Cinematic_Cleanup()
	Sleep(1.0)

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	player_pod = MissionUtil.SpawnUnitSpace("REPUBLIC_ESCAPE_POD", outro_1_pod_marker, p_republic)

	MissionUtil.PlayGenericMusic("Republic_Defeat")
	Sleep(1.0)

	player_bw_1 = MissionUtil.SpawnUnitSpace("BULWARK_I", outro_1_ningo_marker, p_cis)
	player_bw_2 = MissionUtil.SpawnUnitSpace("BULWARK_I", outro_1_bw_1_marker, p_cis)
	player_bw_3 = MissionUtil.SpawnUnitSpace("BULWARK_I", outro_1_bw_2_marker, p_cis)

	Letter_Box_In(1.0)
	Fade_Screen_In(2.0)

	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 15, 9.5, nil, {r = 250, g = 44, b = 44}) -- Captain Massel
	MissionUtil.SetCinematicCamera(outrocam_1_alt_1_marker, player_pod, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_2_alt_1_marker, player_pod, true, 8.5, nil, nil)
	Sleep(10.0)

	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 16, 5.0, nil, {r = 250, g = 44, b = 44}) -- Captain Massel
	MissionUtil.SetCinematicCamera(outrocam_3_alt_1_marker, outro_1_ningo_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_4_alt_1_marker, outro_1_ningo_marker, true, 8.5, nil, nil)
	Fade_Screen_In(0.5)
	Sleep(4.0)

	player_bw_1.Hyperspace_Away(true)
	player_bw_2.Hyperspace_Away(true)
	player_bw_3.Hyperspace_Away(true)

	Fade_Screen_Out(2.0)
	Sleep(3.0)

	MissionUtil.CinematicEnvironmentOff()

	StoryUtil.DeclareVictory(p_republic, false)
end

function Start_Cinematic_Intro_Rep()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, true, 22.0, nil, nil)
	Fade_Screen_In(1.0)
	Letter_Box_In(1.0)

	player_wolf_squadron = Find_First_Object("ARC_170")
	mama_wolf = player_wolf_squadron.Get_Parent_Object()
	mama_wolf.Override_Max_Speed(4.5)

	cinematic_one = true

	MissionUtil.CinematicIntroHeader("BLOCKADE_BREAKING")
	MissionUtil.PlayGenericMusic("Clone_Army_Theme")
	Sleep(13.0)

	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 1, 5.0, nil, {r = 250, g = 44, b = 44}) -- Captain Massel
	Sleep(5.5)

	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 2, 16.0, nil, {r = 250, g = 44, b = 44}) -- Captain Massel
	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 3, 16.0, nil, {r = 250, g = 44, b = 44}) -- Captain Massel
	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_3_marker, true, 17.5, nil, nil)
	Sleep(17.0)

	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 4, 14.0, nil, {r = 250, g = 44, b = 44}) -- Captain Massel
	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 5, 14.0, nil, {r = 250, g = 44, b = 44}) -- Captain Massel
	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_2_marker, true, 15.5, nil, nil)
	Sleep(15.0)

	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 6, 6.0, nil, {r = 250, g = 44, b = 44}) -- Sgt. Lanno
	MissionUtil.SetCinematicCamera(introcam_7_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_8_marker, introcam_target_3_marker, true, 15.5, nil, nil)
	Sleep(6.5)

	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 7, 14.0, nil, {r = 250, g = 44, b = 44}) -- Captain Massel
	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 8, 14.0, nil, {r = 250, g = 44, b = 44}) -- Captain Massel
	MissionUtil.SetCinematicCamera(introcam_9_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_10_marker, introcam_target_4_marker, true, 14.5, nil, nil)
	Sleep(15.0)

	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 9, 9.0, nil, {r = 250, g = 44, b = 44}) -- Wolf Leader
	MissionUtil.SetCinematicCamera(introcam_11_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_12_marker, introcam_target_4_marker, true, 15.5, nil, nil)	Sleep(5.0)
	Sleep(6.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Rep")
	end
end
function End_Cinematic_Intro_Rep()
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(intro_2_wolf_squadron_marker, 3.5)
	MissionUtil.AIActivation()
	Sleep(3.5)

	MissionUtil.SetObjectiveMissionSet("BLOCKADE_BREAKING", "REP", 1)

	Add_Radar_Blip(intro_2_wolf_squadron_marker, "Nebula_Blip")

	Register_Timer(State_Nebulae_Reached_Rep, 10)

	current_cinematic_thread_id = nil

	cinematic_one = false
	act_1_active = true
end

function Start_Cinematic_Outro_Rep_Alt_01()
	act_2_active = false
	cinematic_two_alt_01 = true

	Fade_On()
	Do_End_Cinematic_Cleanup()

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	player_pod = MissionUtil.SpawnUnitSpace("REPUBLIC_ESCAPE_POD", outro_1_pod_marker, p_republic, 100)

	MissionUtil.PlayGenericMusic("Republic_Defeat")
	Sleep(1.0)

	player_bw_1 = MissionUtil.SpawnUnitSpace("BULWARK_I", outro_1_ningo_marker, p_cis, 100)
	player_bw_2 = MissionUtil.SpawnUnitSpace("BULWARK_I", outro_1_bw_1_marker, p_cis, 100)
	player_bw_3 = MissionUtil.SpawnUnitSpace("BULWARK_I", outro_1_bw_2_marker, p_cis, 100)

	Letter_Box_In(1.0)
	Fade_Screen_In(2.0)

	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 13, 8.0, nil, {r = 250, g = 44, b = 44}) -- Captain Massel
	MissionUtil.SetCinematicCamera(outrocam_1_alt_1_marker, player_pod, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_2_alt_1_marker, player_pod, true, 8.5, nil, nil)
	Sleep(10.0)

	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 14, 7.0, nil, {r = 250, g = 44, b = 44}) -- Dua Ningo
	MissionUtil.SetCinematicCamera(outrocam_3_alt_1_marker, outro_1_ningo_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_4_alt_1_marker, outro_1_ningo_marker, true, 8.5, nil, nil)
	Fade_Screen_In(0.5)
	Sleep(4.0)

	player_bw_1.Hyperspace_Away(true)
	player_bw_2.Hyperspace_Away(true)
	player_bw_3.Hyperspace_Away(true)

	Fade_Screen_Out(2.0)
	Sleep(3.0)

	MissionUtil.CinematicEnvironmentOff()

	StoryUtil.DeclareVictory(p_cis, false)
end
function Start_Cinematic_Outro_Rep_Alt_02()
	act_2_active = false
	cinematic_two_alt_02 = true

	Fade_On()
	Do_End_Cinematic_Cleanup()

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	player_pod = MissionUtil.SpawnUnitSpace("REPUBLIC_ESCAPE_POD", outro_1_pod_marker, p_republic, 100)

	MissionUtil.PlayGenericMusic("Republic_Defeat")
	Sleep(1.0)

	player_bw_1 = MissionUtil.SpawnUnitSpace("BULWARK_I", outro_1_ningo_marker, p_cis, 100)
	player_bw_2 = MissionUtil.SpawnUnitSpace("BULWARK_I", outro_1_bw_1_marker, p_cis, 100)
	player_bw_3 = MissionUtil.SpawnUnitSpace("BULWARK_I", outro_1_bw_2_marker, p_cis, 100)

	Letter_Box_In(1.0)
	Fade_Screen_In(2.0)

	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 15, 9.5, nil, {r = 250, g = 44, b = 44}) -- Captain Massel
	MissionUtil.SetCinematicCamera(outrocam_1_alt_1_marker, player_pod, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_2_alt_1_marker, player_pod, true, 8.5, nil, nil)
	Sleep(10.0)

	MissionUtil.MissionTextSpeech("BLOCKADE_BREAKING", 16, 5.0, nil, {r = 250, g = 44, b = 44}) -- Captain Massel
	MissionUtil.SetCinematicCamera(outrocam_3_alt_1_marker, outro_1_ningo_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_4_alt_1_marker, outro_1_ningo_marker, true, 8.5, nil, nil)
	Fade_Screen_In(0.5)
	Sleep(4.0)

	player_bw_1.Hyperspace_Away(true)
	player_bw_2.Hyperspace_Away(true)
	player_bw_3.Hyperspace_Away(true)

	Fade_Screen_Out(2.0)
	Sleep(3.0)

	MissionUtil.CinematicEnvironmentOff()

	StoryUtil.DeclareVictory(p_republic, false)
end
