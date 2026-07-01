
--*****************************************************--
--******** Foerost Campaign: Anaxes Annexation ********--
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
		"Victory_I_Fleet_Star_Destroyer",
		"Victory_I_Fleet_Star_Destroyer",
		"PDF_DHC",
		"PDF_DHC",
		"PDF_DHC",
		"Customs_Corvette",
		"Customs_Corvette",
	}

	screed_easy_list = {
		"Screed_Arlionne",
		"Victory_I_Fleet_Star_Destroyer",
		"Victory_I_Fleet_Star_Destroyer",
		"Gladiator_I",
		"PDF_DHC",
		"PDF_DHC",
		"PDF_DHC",
		"Customs_Corvette",
		"Customs_Corvette",
		"Customs_Corvette",
	}
	screed_medium_list = {
		"Screed_Arlionne",
		"Victory_I_Fleet_Star_Destroyer",
		"Victory_I_Fleet_Star_Destroyer",
		"Victory_I_Fleet_Star_Destroyer",
		"Victory_I_Fleet_Star_Destroyer",
		"Gladiator_I",
		"Gladiator_I",
		"PDF_DHC",
		"PDF_DHC",
		"PDF_DHC",
		"Customs_Corvette",
		"Customs_Corvette",
		"Customs_Corvette",
		"Customs_Corvette",
	}
	screed_hard_list = {
		"Screed_Arlionne",
		"Victory_I_Fleet_Star_Destroyer",
		"Victory_I_Fleet_Star_Destroyer",
		"Victory_I_Fleet_Star_Destroyer",
		"Victory_I_Fleet_Star_Destroyer",
		"Victory_I_Fleet_Star_Destroyer",
		"Gladiator_I",
		"Gladiator_I",
		"Gladiator_I",
		"Gladiator_I",
		"PDF_DHC",
		"PDF_DHC",
		"Customs_Corvette",
		"Customs_Corvette",
		"Customs_Corvette",
		"Customs_Corvette",
	}

	bulwark_easy_list = {
		"Bulwark_I",
	}
	bulwark_medium_list = {
		"Bulwark_I",
		"Bulwark_I",
	}
	bulwark_hard_list = {
		"Bulwark_I",
		"Bulwark_I",
		"Bulwark_I",
	}

	screed_player_list = {
		"Screed_Arlionne",
		"Customs_Corvette",
		"Customs_Corvette",
		"Customs_Corvette",
		"Customs_Corvette",
		"Gladiator_I",
		"Gladiator_I",
		"Victory_I_Fleet_Star_Destroyer",
		"Victory_I_Fleet_Star_Destroyer",
		"Victory_I_Fleet_Star_Destroyer",
		"Victory_I_Fleet_Star_Destroyer",
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")

	act_1_active = false

	cinematic_one = false

	cinematic_one_skipped = false

	current_cinematic_thread_id = nil

	screed_arrived = false
	avenger_fleet_arrived = false

	dodonna_dead = false
	screed_dead = false
	ningo_dead = false

	republic_victory = false
	cis_victory = false
end
function Begin_Battle(message)
	if message == OnEnter then
		MissionUtil.VictoryAllowance(false)
		MissionUtil.DisableRetreat("EMPIRE", true)

		attacker_marker = Find_First_Object("Attacker Entry Position")

		rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-1")
		rep_fleet_02_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-2")
		rep_fleet_03_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-3")
		rep_fleet_04_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-4")
		rep_fleet_05_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-5")

		rep_defender_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-rep-defender")

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-4")
		introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-5")
		introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-6")
		introcam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-7")
		introcam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-8")
		introcam_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-9")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")

		intro_1_ningo_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-ningo")
		intro_2_ningo_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-ningo")

		intro_1_dodonna_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-dodonna")
		intro_2_dodonna_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-dodonna")

		intro_1_vsd_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-vsd-1")
		intro_1_vsd_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-vsd-2")

		intro_2_vsd_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-vsd-1")
		intro_2_vsd_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-vsd-2")

		intro_1_cc_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-cc-1")
		intro_1_cc_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-cc-2")

		intro_2_cc_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-cc-1")
		intro_2_cc_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-cc-2")

		intro_1_bw_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bw-1")
		intro_2_bw_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-bw-1")

		intro_1_bw_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bw-2")
		intro_2_bw_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-bw-2")

		intro_1_bw_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bw-3")
		intro_2_bw_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-bw-3")

		intro_1_bw_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bw-4")
		intro_2_bw_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-bw-4")

		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
		elseif p_republic.Is_Human() then
			MissionUtil.DisableRetreat("REBEL", true)
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
		end
	end
end

function State_Hero_Death_Ningo()
	if p_cis.Is_Human() then
		MissionUtil.SetMissionObjectiveFailed("ANAXES_ANNEXATION", "CIS", 1)
	elseif p_republic.Is_Human() then
		MissionUtil.SetMissionObjectiveComplete("ANAXES_ANNEXATION", "REP", 1)
	end
end
function State_Hero_Death_Dodonna()
	if p_cis.Is_Human() then
		MissionUtil.SetMissionObjectiveComplete("ANAXES_ANNEXATION", "CIS", 3)
	elseif p_republic.Is_Human() then
		MissionUtil.SetMissionObjectiveFailed("ANAXES_ANNEXATION", "REP", 3)
	end
end
function State_Hero_Death_Screed()
	if p_cis.Is_Human() then
		MissionUtil.SetMissionObjectiveComplete("ANAXES_ANNEXATION", "CIS", 4)
	elseif p_republic.Is_Human() then
		MissionUtil.SetMissionObjectiveFailed("ANAXES_ANNEXATION", "REP", 4)
	end
end

function State_Avenger_Fleet_Arrives()
	if p_cis.Is_Human() then
		if not avenger_fleet_arrived then
			avenger_fleet_arrived = true

			local entry_gamble = GameRandom.Free_Random(1, 5)
			if entry_gamble == 1 then
				rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-1")
			elseif entry_gamble == 2 then
				rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-2")
			elseif entry_gamble == 3 then
				rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-3")
			elseif entry_gamble == 4 then
				rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-4")
			elseif entry_gamble == 5 then
				rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-5")
			end

			if StoryUtil.GetDifficulty() == "EASY" then
				Republic_AI_Fleet = SpawnList(screed_easy_list, rep_fleet_01_marker.Get_Position(), p_republic, true, true)
				Republic_AI_Fleet = Republic_AI_Fleet[1]
				Republic_AI_Fleet.Teleport_And_Face(rep_fleet_01_marker)
				Republic_AI_Fleet.Cinematic_Hyperspace_In(150)
			end
			if StoryUtil.GetDifficulty() == "NORMAL" then
				Republic_AI_Fleet = SpawnList(screed_medium_list, rep_fleet_01_marker.Get_Position(), p_republic, true, true)
				Republic_AI_Fleet = Republic_AI_Fleet[1]
				Republic_AI_Fleet.Teleport_And_Face(rep_fleet_01_marker)
				Republic_AI_Fleet.Cinematic_Hyperspace_In(150)
			end
			if StoryUtil.GetDifficulty() == "HARD" then
				Republic_AI_Fleet = SpawnList(screed_hard_list, rep_fleet_01_marker.Get_Position(), p_republic, true, true)
				Republic_AI_Fleet = Republic_AI_Fleet[1]
				Republic_AI_Fleet.Teleport_And_Face(rep_fleet_01_marker)
				Republic_AI_Fleet.Cinematic_Hyperspace_In(150)
			end

			MissionUtil.MissionTextSpeech("ANAXES_ANNEXATION", 8, 11.0, nil, {r = 239, g = 139, b = 9}) -- Skakoan Engineer
			MissionUtil.SetMissionObjectiveNew("ANAXES_ANNEXATION", "CIS", 4)
		end
	elseif p_republic.Is_Human() then
		local entry_gamble = GameRandom.Free_Random(1, 3)
		if entry_gamble == 1 then
			rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-1")
		elseif entry_gamble == 2 then
			rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-2")
		elseif entry_gamble == 3 then
			rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-3")
		elseif entry_gamble == 4 then
			rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-4")
		elseif entry_gamble == 5 then
			rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-5")
		end

		Republic_Fleet = SpawnList(screed_player_list, rep_fleet_01_marker.Get_Position(), p_republic, true, true)
		Republic_Fleet = Republic_Fleet[1]
		Republic_Fleet.Teleport_And_Face(rep_fleet_01_marker)
		Republic_Fleet.Cinematic_Hyperspace_In(100)

		MissionUtil.MissionTextSpeech("ANAXES_ANNEXATION", 9, 11.0, nil, {r = 250, g = 44, b = 44}) -- Terrinald Screed
		MissionUtil.SetMissionObjectiveNew("ANAXES_ANNEXATION", "REP", 4)
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

				if not TestValid(Find_First_Object("DODONNA_ARDENT")) then
					player_dodonna = MissionUtil.SpawnUnitSpace("DODONNA_ARDENT", intro_1_dodonna_marker, p_republic, 100)
					Register_Death_Event(player_dodonna, State_Hero_Death_Dodonna)

					player_cc_1 = MissionUtil.SpawnUnitSpace("CUSTOMS_CORVETTE", intro_1_cc_1_marker, p_republic, 100)
					player_cc_2 = MissionUtil.SpawnUnitSpace("CUSTOMS_CORVETTE", intro_1_cc_2_marker, p_republic, 100)

					player_vsd_1 = MissionUtil.SpawnUnitSpace("VICTORY_I_FLEET_STAR_DESTROYER", intro_1_vsd_1_marker, p_republic, 100)
					player_vsd_2 = MissionUtil.SpawnUnitSpace("VICTORY_I_FLEET_STAR_DESTROYER", intro_1_vsd_2_marker, p_republic, 100)

					player_glad_1 = MissionUtil.SpawnUnitSpace("GLADIATOR_I", intro_1_cc_1_marker, p_republic, 100)
					player_glad_2 = MissionUtil.SpawnUnitSpace("GLADIATOR_I", intro_1_cc_2_marker, p_republic, 100)
				end

				Republic_AI_Fleet = SpawnList(republic_defender_list, rep_defender_01_marker.Get_Position(), p_republic, true, true)
				Republic_AI_Fleet = Republic_AI_Fleet[1]
				Republic_AI_Fleet.Teleport_And_Face(rep_defender_01_marker)

				Register_Timer(State_Avenger_Fleet_Arrives, 90)

				MissionUtil.SetObjectiveMissionSet("ANAXES_ANNEXATION", "CIS", 3)
				MissionUtil.CinematicSkippingCleanUp(intro_1_dodonna_marker)
				MissionUtil.Set_To_Enemies(p_republic, p_cis)
				MissionUtil.VictoryAllowance(true)

				cinematic_one = false
				act_1_active = true

				Fade_Screen_In(0.5)
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

				if not TestValid(Find_First_Object("DODONNA_ARDENT")) then
					player_dodonna = MissionUtil.SpawnUnitSpace("DODONNA_ARDENT", intro_1_dodonna_marker, p_republic, 100)
					Register_Death_Event(player_dodonna, State_Hero_Death_Dodonna)

					player_cc_1 = MissionUtil.SpawnUnitSpace("CUSTOMS_CORVETTE", intro_1_cc_1_marker, p_republic, 100)
					player_cc_2 = MissionUtil.SpawnUnitSpace("CUSTOMS_CORVETTE", intro_1_cc_2_marker, p_republic, 100)

					player_vsd_1 = MissionUtil.SpawnUnitSpace("VICTORY_I_FLEET_STAR_DESTROYER", intro_1_vsd_1_marker, p_republic, 100)
					player_vsd_2 = MissionUtil.SpawnUnitSpace("VICTORY_I_FLEET_STAR_DESTROYER", intro_1_vsd_2_marker, p_republic, 100)

					player_glad_1 = MissionUtil.SpawnUnitSpace("GLADIATOR_I", intro_1_cc_1_marker, p_republic, 100)
					player_glad_2 = MissionUtil.SpawnUnitSpace("GLADIATOR_I", intro_1_cc_2_marker, p_republic, 100)
				end

				if not TestValid(Find_First_Object("DUA_NINGO_UNREPENTANT")) then
					player_ningo = MissionUtil.SpawnUnitSpace("DUA_NINGO_UNREPENTANT", intro_1_ningo_marker, p_cis, 100)
					Register_Death_Event(player_ningo, State_Hero_Death_Ningo)

					player_bw_1 = MissionUtil.SpawnUnitSpace("BULWARK_I", intro_1_bw_1_marker, p_cis, 100)
					player_bw_2 = MissionUtil.SpawnUnitSpace("BULWARK_I", intro_1_bw_2_marker, p_cis, 100)
					player_bw_3 = MissionUtil.SpawnUnitSpace("BULWARK_I", intro_1_bw_3_marker, p_cis, 100)
					player_bw_4 = MissionUtil.SpawnUnitSpace("BULWARK_I", intro_1_bw_4_marker, p_cis, 100)
				end

				if StoryUtil.GetDifficulty() == "EASY" then
					CIS_AI_Fleet = SpawnList(bulwark_easy_list, attacker_marker.Get_Position(), p_cis, true, true)
					CIS_AI_Fleet = CIS_AI_Fleet[1]
					CIS_AI_Fleet.Teleport_And_Face(attacker_marker)
					CIS_AI_Fleet.Cinematic_Hyperspace_In(150)
				end
				if StoryUtil.GetDifficulty() == "NORMAL" then
					CIS_AI_Fleet = SpawnList(bulwark_medium_list, attacker_marker.Get_Position(), p_cis, true, true)
					CIS_AI_Fleet = CIS_AI_Fleet[1]
					CIS_AI_Fleet.Teleport_And_Face(attacker_marker)
					CIS_AI_Fleet.Cinematic_Hyperspace_In(150)
				end
				if StoryUtil.GetDifficulty() == "HARD" then
					CIS_AI_Fleet = SpawnList(bulwark_hard_list, attacker_marker.Get_Position(), p_cis, true, true)
					CIS_AI_Fleet = CIS_AI_Fleet[1]
					CIS_AI_Fleet.Teleport_And_Face(attacker_marker)
					CIS_AI_Fleet.Cinematic_Hyperspace_In(150)
				end

				Register_Timer(State_Avenger_Fleet_Arrives, 90)

				MissionUtil.SetObjectiveMissionSet("ANAXES_ANNEXATION", "REP", 3)
				MissionUtil.CinematicSkippingCleanUp(intro_1_dodonna_marker)
				MissionUtil.Set_To_Enemies(p_republic, p_cis)
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
	elseif p_republic.Is_Human() then
		if act_1_active then
		end
	end
end

function Start_Cinematic_Intro_CIS()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	Fade_On()
	Sleep(0.5)

	player_ningo = Find_First_Object("DUA_NINGO_UNREPENTANT")
	if not TestValid(player_ningo) then
		player_ningo = Spawn_From_Reinforcement_Pool(Find_Object_Type("DUA_NINGO_UNREPENTANT"), intro_1_ningo_marker, p_cis)
		if player_ningo then
			player_ningo = player_ningo[1]
		end
	end
	Register_Death_Event(player_ningo, State_Hero_Death_Ningo)

	cinematic_one = true

	Letter_Box_In(3.0)
	Fade_Screen_In(5.0)

	MissionUtil.CinematicIntroHeader("ANAXES_ANNEXATION")
	MissionUtil.PlayGenericMusic("TPM_The_Droid_Invasion_Theme")

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, true, 12.5, nil, nil)
	Sleep(11.0)

	player_dodonna = MissionUtil.SpawnUnitSpace("DODONNA_ARDENT", intro_1_dodonna_marker, p_republic, 100)
	Register_Death_Event(player_dodonna, State_Hero_Death_Dodonna)

	player_cc_1 = MissionUtil.SpawnUnitSpace("CUSTOMS_CORVETTE", intro_1_cc_1_marker, p_republic, 100)
	player_cc_2 = MissionUtil.SpawnUnitSpace("CUSTOMS_CORVETTE", intro_1_cc_2_marker, p_republic, 100)

	player_vsd_1 = MissionUtil.SpawnUnitSpace("VICTORY_I_FLEET_STAR_DESTROYER", intro_1_vsd_1_marker, p_republic, 100)
	player_vsd_2 = MissionUtil.SpawnUnitSpace("VICTORY_I_FLEET_STAR_DESTROYER", intro_1_vsd_2_marker, p_republic, 100)

	player_glad_1 = MissionUtil.SpawnUnitSpace("GLADIATOR_I", intro_1_cc_1_marker, p_republic, 100)
	player_glad_2 = MissionUtil.SpawnUnitSpace("GLADIATOR_I", intro_1_cc_2_marker, p_republic, 100)

	MissionUtil.MissionTextSpeech("ANAXES_ANNEXATION", 1, 10.0, nil, {r = 250, g = 44, b = 44}) -- Jan Dodonna
	MissionUtil.MissionTextSpeech("ANAXES_ANNEXATION", 2, 10.0, nil, {r = 250, g = 44, b = 44}) -- Jan Dodonna
	Sleep(5.0)

	Fade_Screen_Out(2.0)
	Sleep(3.0)

	player_dodonna.Move_To(intro_2_dodonna_marker)
	player_cc_1.Move_To(intro_2_cc_1_marker)
	player_cc_2.Move_To(intro_2_cc_2_marker)
	player_vsd_1.Move_To(intro_2_vsd_1_marker)
	player_vsd_2.Move_To(intro_2_cc_2_marker)

	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, player_dodonna, true, 12.5, nil, nil)
	Sleep(3.0)

	MissionUtil.MissionTextSpeech("ANAXES_ANNEXATION", 3, 8.5, nil, {r = 250, g = 44, b = 44}) -- Terrinald Screed
	Fade_Screen_In(2.0)
	Sleep(9.0)

	player_bw_1 = Spawn_From_Reinforcement_Pool(Find_Object_Type("BULWARK_I"), intro_1_bw_1_marker, p_cis)
	if player_bw_1 then
		player_bw_1 = player_bw_1[1]
	else
		player_bw_1 = MissionUtil.SpawnUnitSpace("BULWARK_I", intro_1_bw_1_marker, p_cis, 100)
	end
	player_bw_2 = Spawn_From_Reinforcement_Pool(Find_Object_Type("BULWARK_I"), intro_1_bw_2_marker, p_cis)
	if player_bw_2 then
		player_bw_2 = player_bw_1[1]
	else
		player_bw_2 = MissionUtil.SpawnUnitSpace("BULWARK_I", intro_1_bw_2_marker, p_cis, 100)
	end

	MissionUtil.PlayGenericMusic("Grievous_Theme")

	MissionUtil.MissionTextSpeech("ANAXES_ANNEXATION", 4, 5.0, nil, {r = 250, g = 44, b = 44}) -- Jan Dodonna
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_3_marker, true, 5.0, nil, nil)
	Sleep(5.5)

	MissionUtil.MissionTextSpeech("ANAXES_ANNEXATION", 5, 4.5, nil, {r = 250, g = 44, b = 44}) -- Terrinald Screed
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, player_ningo, true, 20.0, nil, nil)
	Sleep(5.5)

	if TestValid(player_ningo) then
		player_ningo.Move_To(intro_2_ningo_marker)
	end
	if TestValid(player_bw_1) then
		player_bw_1.Move_To(intro_2_bw_1_marker)
	end
	if TestValid(player_bw_2) then
	player_bw_2.Move_To(intro_2_bw_2_marker)
	end

	MissionUtil.MissionTextSpeech("ANAXES_ANNEXATION", 6, 8.0, nil, {r = 239, g = 139, b = 9}) -- Skakoan Engineer
	Sleep(8.5)

	MissionUtil.MissionTextSpeech("ANAXES_ANNEXATION", 7, 8.0, nil, {r = 239, g = 139, b = 9}) -- Dua Ningo
	MissionUtil.SetCinematicCamera(introcam_7_marker, player_ningo, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_8_marker, player_ningo, true, 25.0, nil, nil)
	Sleep(5.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end
function End_Cinematic_Intro_CIS()
	Republic_AI_Fleet = SpawnList(republic_defender_list, rep_defender_01_marker.Get_Position(), p_republic, true, true)
	Republic_AI_Fleet = Republic_AI_Fleet[1]
	Republic_AI_Fleet.Teleport_And_Face(rep_defender_01_marker)

	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(Find_First_Object("ATTACKER ENTRY POSITION"), 3.5)
	Sleep(3.5)

	MissionUtil.SetObjectiveMissionSet("ANAXES_ANNEXATION", "CIS", 3)
	MissionUtil.VictoryAllowance(true)
	MissionUtil.Set_To_Enemies(p_republic, p_cis)

	Register_Timer(State_Avenger_Fleet_Arrives, 90)

	current_cinematic_thread_id = nil

	cinematic_one = false
	act_1_active = true
	MissionUtil.AIActivation()
end

function Start_Cinematic_Intro_Rep()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	Fade_On()
	Sleep(0.5)

	player_dodonna = Find_First_Object("DODONNA_ARDENT")
	if not TestValid(player_dodonna) then
		player_dodonna = Spawn_From_Reinforcement_Pool(Find_Object_Type("DODONNA_ARDENT"), intro_1_dodonna_marker, p_republic)
		if player_dodonna then
			player_dodonna = player_dodonna[1]
		end
	end
	Register_Death_Event(player_dodonna, State_Hero_Death_Dodonna)

	cinematic_one = true

	Letter_Box_In(3.0)
	Fade_Screen_In(9.0)

	MissionUtil.CinematicIntroHeader("ANAXES_ANNEXATION")
	MissionUtil.PlayGenericMusic("TPM_The_Droid_Invasion_Theme")

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, true, 12.5, nil, nil)
	Sleep(7.0)

	if not TestValid(player_dodonna) then
		player_dodonna = MissionUtil.SpawnUnitSpace("DODONNA_ARDENT", intro_1_dodonna_marker, p_republic, 100)
		Register_Death_Event(player_dodonna, State_Hero_Death_Dodonna)
	end

	player_cc_1 = MissionUtil.SpawnUnitSpace("CUSTOMS_CORVETTE", intro_1_cc_1_marker, p_republic, 100)
	player_cc_2 = MissionUtil.SpawnUnitSpace("CUSTOMS_CORVETTE", intro_1_cc_2_marker, p_republic, 100)

	player_vsd_1 = MissionUtil.SpawnUnitSpace("VICTORY_I_FLEET_STAR_DESTROYER", intro_1_vsd_1_marker, p_republic, 100)
	player_vsd_2 = MissionUtil.SpawnUnitSpace("VICTORY_I_FLEET_STAR_DESTROYER", intro_1_vsd_2_marker, p_republic, 100)

	player_glad_1 = MissionUtil.SpawnUnitSpace("GLADIATOR_I", intro_1_cc_1_marker, p_republic, 100)
	player_glad_2 = MissionUtil.SpawnUnitSpace("GLADIATOR_I", intro_1_cc_2_marker, p_republic, 100)

	MissionUtil.MissionTextSpeech("ANAXES_ANNEXATION", 1, 10.0, nil, {r = 250, g = 44, b = 44}) -- Jan Dodonna
	MissionUtil.MissionTextSpeech("ANAXES_ANNEXATION", 2, 10.0, nil, {r = 250, g = 44, b = 44}) -- Jan Dodonna
	Sleep(9.0)

	Fade_Screen_Out(2.0)
	Sleep(3.0)

	player_dodonna.Move_To(intro_2_dodonna_marker)
	player_cc_1.Move_To(intro_2_cc_1_marker)
	player_cc_2.Move_To(intro_2_cc_2_marker)
	player_vsd_1.Move_To(intro_2_vsd_1_marker)
	player_vsd_2.Move_To(intro_2_cc_2_marker)

	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, player_dodonna, true, 12.5, nil, nil)
	Sleep(3.0)

	MissionUtil.MissionTextSpeech("ANAXES_ANNEXATION", 3, 8.5, nil, {r = 250, g = 44, b = 44}) -- Terrinald Screed
	Fade_Screen_In(2.0)
	Sleep(9.0)

	player_ningo = MissionUtil.SpawnUnitSpace("DUA_NINGO_UNREPENTANT", intro_1_ningo_marker, p_cis, 100)
	Register_Death_Event(player_ningo, State_Hero_Death_Ningo)

	player_bw_1 = MissionUtil.SpawnUnitSpace("BULWARK_I", intro_1_bw_1_marker, p_cis, 100)
	player_bw_2 = MissionUtil.SpawnUnitSpace("BULWARK_I", intro_1_bw_2_marker, p_cis, 100)
	player_bw_3 = MissionUtil.SpawnUnitSpace("BULWARK_I", intro_1_bw_3_marker, p_cis, 100)
	player_bw_4 = MissionUtil.SpawnUnitSpace("BULWARK_I", intro_1_bw_4_marker, p_cis, 100)

	MissionUtil.PlayGenericMusic("Grievous_Theme")

	MissionUtil.MissionTextSpeech("ANAXES_ANNEXATION", 4, 5.0, nil, {r = 250, g = 44, b = 44}) -- Jan Dodonna
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_3_marker, true, 5.0, nil, nil)
	Sleep(5.5)

	MissionUtil.MissionTextSpeech("ANAXES_ANNEXATION", 5, 4.5, nil, {r = 250, g = 44, b = 44}) -- Terrinald Screed
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, player_ningo, true, 20.0, nil, nil)
	Sleep(5.5)

	if TestValid(player_ningo) then
		player_ningo.Move_To(intro_2_ningo_marker)
	end
	if TestValid(player_bw_1) then
		player_bw_1.Move_To(intro_2_bw_1_marker)
	end
	if TestValid(player_bw_2) then
	player_bw_2.Move_To(intro_2_bw_2_marker)
	end

	MissionUtil.MissionTextSpeech("ANAXES_ANNEXATION", 6, 8.0, nil, {r = 239, g = 139, b = 9}) -- Skakoan Engineer
	Sleep(8.5)

	MissionUtil.MissionTextSpeech("ANAXES_ANNEXATION", 7, 8.0, nil, {r = 239, g = 139, b = 9}) -- Dua Ningo
	MissionUtil.SetCinematicCamera(introcam_7_marker, player_ningo, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_8_marker, player_ningo, true, 25.0, nil, nil)
	Sleep(5.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Rep")
	end
end
function End_Cinematic_Intro_Rep()
	if StoryUtil.GetDifficulty() == "EASY" then
		CIS_AI_Fleet = SpawnList(bulwark_easy_list, attacker_marker.Get_Position(), p_cis, true, true)
		CIS_AI_Fleet = CIS_AI_Fleet[1]
		CIS_AI_Fleet.Teleport_And_Face(attacker_marker)
		CIS_AI_Fleet.Cinematic_Hyperspace_In(150)
	end
	if StoryUtil.GetDifficulty() == "NORMAL" then
		CIS_AI_Fleet = SpawnList(bulwark_medium_list, attacker_marker.Get_Position(), p_cis, true, true)
		CIS_AI_Fleet = CIS_AI_Fleet[1]
		CIS_AI_Fleet.Teleport_And_Face(attacker_marker)
		CIS_AI_Fleet.Cinematic_Hyperspace_In(150)
	end
	if StoryUtil.GetDifficulty() == "HARD" then
		CIS_AI_Fleet = SpawnList(bulwark_hard_list, attacker_marker.Get_Position(), p_cis, true, true)
		CIS_AI_Fleet = CIS_AI_Fleet[1]
		CIS_AI_Fleet.Teleport_And_Face(attacker_marker)
		CIS_AI_Fleet.Cinematic_Hyperspace_In(150)
	end

	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(Find_First_Object("ATTACKER ENTRY POSITION"), 3.5)
	Sleep(3.5)

	MissionUtil.Set_To_Enemies(p_republic, p_cis)

	MissionUtil.AIActivation()
	MissionUtil.SetObjectiveMissionSet("ANAXES_ANNEXATION", "REP", 3)
	MissionUtil.VictoryAllowance(true)

	Register_Timer(State_Avenger_Fleet_Arrives, 90)

	current_cinematic_thread_id = nil

	cinematic_one = false
	act_1_active = true
end
