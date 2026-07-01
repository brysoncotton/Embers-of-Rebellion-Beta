
--*****************************************************--
--******* Operation Durge's Lance: Duro Defence *******--
--*****************************************************--

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")
require("eawx-util/StoryUtil")
require("eawx-util/MissionUtil")

function Definitions()
	--DebugMessage("%s -- In Definitions", tostring(Script))

	StoryModeEvents =
	{
		Battle_Start = Begin_Battle,
	}

	republic_defender_list = {
		"ACCLAMATOR_I_CARRIER",
		"ACCLAMATOR_I_CARRIER",
		"ACCLAMATOR_I_CARRIER",
		"ACCLAMATOR_I_ASSAULT",
		"ACCLAMATOR_I_ASSAULT",
		"ACCLAMATOR_I_ASSAULT",
		"ACCLAMATOR_I_ASSAULT",
		"PDF_DHC",
		"PDF_DHC",
		"PDF_DHC",
	}

	republic_avenger_medium_list = {
		"Venator_Star_Destroyer",
		"Venator_Star_Destroyer",
		"Captor",
		"Captor",
		"PDF_DHC",
		"PDF_DHC",
		"LAC",
		"LAC",
		"CR90",
		"CR90",
		"Arquitens",
		"Arquitens",
	}
	republic_avenger_hard_list = {
		"Venator_Star_Destroyer",
		"Victory_I_Star_Destroyer",
		"Victory_I_Star_Destroyer",
		"Captor",
		"Captor",
		"Captor",
		"PDF_DHC",
		"PDF_DHC",
		"LAC",
		"LAC",
		"LAC",
		"LAC",
		"CR90",
		"CR90",
		"Arquitens",
		"Arquitens",
	}

	cis_attacker_list = {
		"MUNIFICENT_SUBFACTION",
		"MUNIFICENT_SUBFACTION",
		"MUNIFICENT_SUBFACTION",
		"MUNIFICENT_SUBFACTION",
		"MUNIFICENT_SUBFACTION",
		"MUNIFICENT_SUBFACTION",
		"MUNIFICENT_SUBFACTION",
		"C9979_CARRIER",
		"C9979_CARRIER",
		"C9979_CARRIER",
		"C9979_CARRIER",
		"C9979_CARRIER",
		"HARDCELL",
		"HARDCELL",
		"HARDCELL",
		"HARDCELL",
		"HARDCELL",
		"HARDCELL",
		"PROVIDENCE_CARRIER_DESTROYER",
		"PROVIDENCE_CARRIER_DESTROYER",
		"RECUSANT_LIGHT_DESTROYER",
		"LUCREHULK_BATTLESHIP",
		"LUCREHULK_CORE_DESTROYER",
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")

	cinematic_one = false
	cinematic_two = false

	cinematic_one_skipped = false
	cinematic_two_skipped = false

	act_1_active = false
	act_2_active = false

	grievous_soulless_one_active = false
	grievous_renitor_active = false
	grievous_munificent_active = false
	grievous_invisible_hand_active = false
	grievous_malevolence_active = false

	honest_news_report = false
	interview_news_report = false
	propaganda_news_report = false

	station_jivv_disabled = false
	station_jyvus_disabled = false
	station_orr_om_disabled = false
	station_bburru_disabled = false
	station_urrdorf_disabled = false
	station_rrudobar_disabled = false
	station_kri_larun_disabled = false
	station_new_tayana_disabled = false

	defence_fleet_killed = false
	avenger_fleet_arrived = false

	conquered_station_amount = 0

	current_cinematic_thread_id = nil

	mission_started = false
end
function Begin_Battle(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			MissionUtil.VictoryAllowance(false)

			MissionUtil.DisableRetreat("REBEL", true)
			MissionUtil.DisableRetreat("EMPIRE", true)
			MissionUtil.DisableRetreat("SECTOR_FORCES", true)

			MissionUtil.Set_To_Allies(p_cis, p_invaders)
			MissionUtil.Set_To_Allies(p_cis, p_republic)
			MissionUtil.Set_To_Allies(p_republic, p_invaders)

			rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-1")
			rep_fleet_02_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-2")
			rep_fleet_03_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-3")
			rep_fleet_04_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-4")
			rep_fleet_05_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-5")

			intro_cis_ship_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-ship-1")
			intro_cis_ship_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-ship-2")

			invisible_hand_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "ih")
			introcam_target_invisible_hand_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget-invisible-hand")
			munificent_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "munificent")
			introcam_target_munificent_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget-munificent")
			renitor_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "renitor")
			introcam_target_renitor_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget-renitor")

			introcam_target_victory_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget-victory")
			introcam_target_station_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget-station")

			introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam1")
			introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam2")
			introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam3")
			introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam4")
			introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam5a")
			introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam6")
			introcam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam7")
			introcam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam8")
			introcam_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam9")
			introcam_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam10")
			introcam_11_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam11")
			introcam_12_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam12")
			introcam_13_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam13")
			introcam_14_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam14")

			introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget1")

			outro_cis_ship_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cis-ship-1")
			outro_cis_ship_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cis-ship-2")
			outro_cis_ship_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cis-ship-3")
			outro_cis_ship_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cis-ship-4")
			outro_cis_ship_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cis-ship-5")

			outro_cis_ships_move_to_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cis-ships-move-to")

			outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam1")
			outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam2")

			station_kri_larun = Find_First_Object("KRI_LARUN")
			station_kri_larun.Set_Cannot_Be_Killed(true)

			station_urrdorf_city = Find_First_Object("URRDORF_CITY")
			station_urrdorf_city.Set_Cannot_Be_Killed(true)

			station_rrudobar = Find_First_Object("RRUDOBAR")
			station_rrudobar.Set_Cannot_Be_Killed(true)

			station_jyvus_space_city = Find_First_Object("JYVUS_SPACE_CITY")
			station_jyvus_space_city.Set_Cannot_Be_Killed(true)

			station_bburru_station = Find_First_Object("BBURRU_STATION")
			station_bburru_station.Set_Cannot_Be_Killed(true)

			station_jivv_space_city = Find_First_Object("JIVV_SPACE_CITY")
			station_jivv_space_city.Set_Cannot_Be_Killed(true)

			station_new_tayana = Find_First_Object("NEW_TAYANA")
			station_new_tayana.Set_Cannot_Be_Killed(true)

			station_orr_om = Find_First_Object("ORR_OM")
			station_orr_om.Set_Cannot_Be_Killed(true)

			player_victory = Find_Hint("VICTORY_I_STAR_DESTROYER", "victory")

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

			mission_started = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
		end
		if p_republic.Is_Human() then
			MissionUtil.VictoryAllowance(false)

			MissionUtil.DisableRetreat("REBEL", true)
			MissionUtil.DisableRetreat("EMPIRE", true)
			MissionUtil.DisableRetreat("SECTOR_FORCES", true)

			MissionUtil.Set_To_Allies(p_cis, p_invaders)
			MissionUtil.Set_To_Allies(p_cis, p_republic)
			MissionUtil.Set_To_Allies(p_republic, p_invaders)

			rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-1")

			intro_cis_ship_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-ship-1")
			intro_cis_ship_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-ship-2")

			invisible_hand_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "ih")
			introcam_target_invisible_hand_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget-invisible-hand")
			munificent_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "munificent")
			introcam_target_munificent_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget-munificent")
			renitor_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "renitor")
			introcam_target_renitor_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget-renitor")

			introcam_target_victory_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget-victory")
			introcam_target_station_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget-station")

			introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam1")
			introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam2")
			introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam3")
			introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam4")
			introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam5a")
			introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam6")
			introcam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam7")
			introcam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam8")
			introcam_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam9")
			introcam_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam10")
			introcam_11_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam11")
			introcam_12_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam12")
			introcam_13_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam13")
			introcam_14_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam14")

			introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget1")

			outro_cis_ship_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cis-ship-1")
			outro_cis_ship_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cis-ship-2")
			outro_cis_ship_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cis-ship-3")
			outro_cis_ship_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cis-ship-4")
			outro_cis_ship_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cis-ship-5")

			outro_cis_ships_move_to_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-cis-ships-move-to")

			outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam1")
			outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam2")

			station_kri_larun = Find_First_Object("KRI_LARUN")
			station_kri_larun.Set_Cannot_Be_Killed(true)

			station_urrdorf_city = Find_First_Object("URRDORF_CITY")
			station_urrdorf_city.Set_Cannot_Be_Killed(true)

			station_rrudobar = Find_First_Object("RRUDOBAR")
			station_rrudobar.Set_Cannot_Be_Killed(true)

			station_jyvus_space_city = Find_First_Object("JYVUS_SPACE_CITY")
			station_jyvus_space_city.Set_Cannot_Be_Killed(true)

			station_bburru_station = Find_First_Object("BBURRU_STATION")
			station_bburru_station.Set_Cannot_Be_Killed(true)

			station_jivv_space_city = Find_First_Object("JIVV_SPACE_CITY")
			station_jivv_space_city.Set_Cannot_Be_Killed(true)

			station_new_tayana = Find_First_Object("NEW_TAYANA")
			station_new_tayana.Set_Cannot_Be_Killed(true)

			station_orr_om = Find_First_Object("ORR_OM")
			station_orr_om.Set_Cannot_Be_Killed(true)

			player_victory = Find_Hint("VICTORY_I_STAR_DESTROYER", "victory")

			mission_started = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
		end
	end
end

function State_Avenger_Fleet_Arrives()
	if p_cis.Is_Human() then
		if not avenger_fleet_arrived then
			avenger_fleet_arrived = true
			if StoryUtil.GetDifficulty() == "EASY" then
			end
			if StoryUtil.GetDifficulty() == "NORMAL" then
				AI_Republic_Fleet = SpawnList(republic_avenger_medium_list, rep_fleet_01_marker.Get_Position(), p_republic, true, true)
				Republic_AI_Fleet = AI_Republic_Fleet[1]
				Republic_AI_Fleet.Teleport_And_Face(rep_fleet_01_marker)
				Republic_AI_Fleet.Cinematic_Hyperspace_In(150)
			end
			if StoryUtil.GetDifficulty() == "HARD" then
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
				AI_Republic_Fleet = SpawnList(republic_avenger_hard_list, rep_fleet_01_marker.Get_Position(), p_republic, true, true)
				Republic_AI_Fleet = AI_Republic_Fleet[1]
				Republic_AI_Fleet.Teleport_And_Face(rep_fleet_01_marker)
				Republic_AI_Fleet.Cinematic_Hyperspace_In(150)
			end

			MissionUtil.MissionTextSpeech("DURO_DEFENCE", 18, 8.0, nil, {r = 250, g = 44, b = 44}) -- Republic Officer
		end
	end
	if p_republic.Is_Human() then
		MissionUtil.DisableRetreat("EMPIRE", false)
		MissionUtil.DisableRetreat("SECTOR_FORCES", false)
		MissionUtil.MissionTextSpeech("DURO_DEFENCE", 19, 8.0, nil, {r = 250, g = 44, b = 44}) -- Republic Officer
	end
end
function State_Boarding_Begins()
	if p_cis.Is_Human() then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
	end
	if p_republic.Is_Human() then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
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
					player_munificent_1 = MissionUtil.SpawnUnitSpace("MUNIFICENT", intro_cis_ship_1_marker, p_cis, 50)
				end
				if not TestValid(player_munificent_2) then
					player_munificent_2 = MissionUtil.SpawnUnitSpace("MUNIFICENT", intro_cis_ship_2_marker, p_cis, 50)
				end

				if StoryUtil.GetDifficulty() == "EASY" then
					Register_Timer(State_Avenger_Fleet_Arrives, 300)
				end
				if StoryUtil.GetDifficulty() == "NORMAL" then
					Register_Timer(State_Avenger_Fleet_Arrives, 240)
				end
				if StoryUtil.GetDifficulty() == "HARD" then
					Register_Timer(State_Avenger_Fleet_Arrives, 150)
				end

				MissionUtil.SetObjectiveMissionSet("DURO_DEFENCE", "CIS", 3)
				MissionUtil.CinematicSkippingCleanUp(intro_cis_ship_1_marker)

				MissionUtil.Set_To_Enemies(p_cis, p_republic)

				MissionUtil.MissionTextSpeech("DURO_DEFENCE", 13, 10.0, "Grievous_Loop", {r = 245, g = 243, b = 82}) -- General Grievous

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

				if not TestValid(player_munificent_1) then
					player_munificent_1 = MissionUtil.SpawnUnitSpace("MUNIFICENT", intro_cis_ship_1_marker, p_cis, 50)
				end
				if not TestValid(player_munificent_2) then
					player_munificent_2 = MissionUtil.SpawnUnitSpace("MUNIFICENT", intro_cis_ship_2_marker, p_cis, 50)
				end

				AI_Fleet = SpawnList(cis_attacker_list, intro_cis_ship_1_marker.Get_Position(), p_cis, true, true)
				AI_Fleet = AI_Fleet[1]
				AI_Fleet.Teleport_And_Face(intro_cis_ship_1_marker)

				Reinforce_Unit(Find_Object_Type("ACCLAMATOR_I_CARRIER"), false, p_republic, true, false)
				Reinforce_Unit(Find_Object_Type("ACCLAMATOR_I_CARRIER"), false, p_republic, true, false)
				Reinforce_Unit(Find_Object_Type("ACCLAMATOR_I_CARRIER"), false, p_republic, true, false)
				Reinforce_Unit(Find_Object_Type("ACCLAMATOR_I_CARRIER"), false, p_republic, true, false)

				Reinforce_Unit(Find_Object_Type("ACCLAMATOR_I_ASSAULT"), false, p_republic, true, false)
				Reinforce_Unit(Find_Object_Type("ACCLAMATOR_I_ASSAULT"), false, p_republic, true, false)
				Reinforce_Unit(Find_Object_Type("ACCLAMATOR_I_ASSAULT"), false, p_republic, true, false)

				Reinforce_Unit(Find_Object_Type("PDF_DHC"), false, p_republic, true, false)
				Reinforce_Unit(Find_Object_Type("PDF_DHC"), false, p_republic, true, false)
				Reinforce_Unit(Find_Object_Type("PDF_DHC"), false, p_republic, true, false)

				if StoryUtil.GetDifficulty() == "EASY" then
					Register_Timer(State_Avenger_Fleet_Arrives, 60)
				end
				if StoryUtil.GetDifficulty() == "NORMAL" then
					Register_Timer(State_Avenger_Fleet_Arrives, 105)
				end
				if StoryUtil.GetDifficulty() == "HARD" then
					Register_Timer(State_Avenger_Fleet_Arrives, 150)
				end

				MissionUtil.SetObjectiveMissionSet("DURO_DEFENCE", "REP", 3)
				MissionUtil.CinematicSkippingCleanUp(intro_cis_ship_1_marker)

				MissionUtil.Set_To_Enemies(p_cis, p_republic)

				MissionUtil.MissionTextSpeech("DURO_DEFENCE", 14, 10.0, "SoBilles_Loop", {r = 250, g = 44, b = 44}) -- Hoolidan Keggle

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
			if not station_jyvus_disabled then
				if Find_First_Object("JYVUS_SPACE_CITY").Get_Hull() <= 0.10 then
					station_jyvus_disabled = true
					Find_First_Object("JYVUS_SPACE_CITY").Change_Owner(p_invaders)
					conquered_station_amount = conquered_station_amount + 1
					if not defence_fleet_killed then
						MissionUtil.MissionTextSpeech("DURO_DEFENCE", 15, 8.0, "Grievous_Loop", {r = 245, g = 243, b = 82}) -- General Grievous
					end
				end
			end
			if not station_jivv_disabled then
				if Find_First_Object("JIVV_SPACE_CITY").Get_Hull() <= 0.10 then
					station_jivv_disabled = true
					Find_First_Object("JIVV_SPACE_CITY").Change_Owner(p_cis)
					conquered_station_amount = conquered_station_amount + 1
				end
			end
			if not station_rrudobar_disabled then
				if Find_First_Object("RRUDOBAR").Get_Hull() <= 0.10 then
					station_rrudobar_disabled = true
					Find_First_Object("RRUDOBAR").Change_Owner(p_cis)
					conquered_station_amount = conquered_station_amount + 1
				end
			end
			if not station_urrdorf_disabled then
				if Find_First_Object("URRDORF_CITY").Get_Hull() <= 0.10 then
					station_urrdorf_disabled = true
					Find_First_Object("URRDORF_CITY").Change_Owner(p_cis)
					conquered_station_amount = conquered_station_amount + 1
				end
			end
			if not station_orr_om_disabled then
				if Find_First_Object("ORR_OM").Get_Hull() <= 0.10 then
					station_urrdorf_disabled = true
					Find_First_Object("ORR_OM").Change_Owner(p_cis)
					conquered_station_amount = conquered_station_amount + 1
				end
			end
			if not station_bburru_disabled then
				if Find_First_Object("BBURRU_STATION").Get_Hull() <= 0.10 then
					station_bburru_disabled = true
					Find_First_Object("BBURRU_STATION").Change_Owner(p_cis)
					conquered_station_amount = conquered_station_amount + 1
				end
			end
			if not station_kri_larun_disabled then
				if Find_First_Object("KRI_LARUN").Get_Hull() <= 0.10 then
					station_kri_larun_disabled = true
					Find_First_Object("KRI_LARUN").Change_Owner(p_cis)
					conquered_station_amount = conquered_station_amount + 1
				end
			end
			if not station_new_tayana_disabled then
				if Find_First_Object("NEW_TAYANA").Get_Hull() <= 0.10 then
					station_new_tayana_disabled = true
					Find_First_Object("NEW_TAYANA").Change_Owner(p_cis)
					conquered_station_amount = conquered_station_amount + 1
				end
			end
			if not defence_fleet_killed then
				rep_list = Find_All_Objects_Of_Type(p_republic, "SpaceHero | Corvette | Capital | Frigate | SuperCapital")
				if (table.getn(rep_list) == 0) then
					defence_fleet_killed = true
				end
			end
			if not act_2_active then
				if station_jyvus_disabled and defence_fleet_killed then
					Create_Thread("State_Boarding_Begins")
					act_1_active = false
					act_2_active = true
				end
			end
			cis_list = Find_All_Objects_Of_Type(p_cis, "SpaceHero | Corvette | Capital | Frigate | SuperCapital")
			if (table.getn(cis_list) == 0) then
				StoryUtil.DeclareVictory(p_republic, false)
			end
			if (conquered_station_amount > 4) and not avenger_fleet_arrived then
				avenger_fleet_arrived = true
				if p_republic.Get_Difficulty()== "Easy" then
				elseif p_republic.Get_Difficulty()== "Hard" then

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

					AI_Republic_Fleet = SpawnList(republic_avenger_hard_list, rep_fleet_01_marker.Get_Position(), p_republic, true, true)
					Republic_AI_Fleet = AI_Republic_Fleet[1]
					Republic_AI_Fleet.Teleport_And_Face(rep_fleet_01_marker)
					Republic_AI_Fleet.Cinematic_Hyperspace_In(150)

				else
					AI_Republic_Fleet = SpawnList(republic_avenger_medium_list, rep_fleet_01_marker.Get_Position(), p_republic, true, true)
					Republic_AI_Fleet = AI_Republic_Fleet[1]
					Republic_AI_Fleet.Teleport_And_Face(rep_fleet_01_marker)
					Republic_AI_Fleet.Cinematic_Hyperspace_In(150)
				end
				MissionUtil.MissionTextSpeech("DURO_DEFENCE", 18, 8.0, nil, {r = 250, g = 44, b = 44}) -- Republic Officer
			end
		end
	elseif p_republic.Is_Human() then
		if act_1_active then
			if not station_jyvus_disabled then
				if Find_First_Object("JYVUS_SPACE_CITY").Get_Hull() <= 0.10 then
					station_jyvus_disabled = true
					Find_First_Object("JYVUS_SPACE_CITY").Change_Owner(p_invaders)
					if not defence_fleet_killed then
						MissionUtil.MissionTextSpeech("DURO_DEFENCE", 14, 8.0, nil, {r = 250, g = 44, b = 44}) -- Hoolidan Keggle
					end
				end
			end
			if not station_jivv_disabled then
				if Find_First_Object("JIVV_SPACE_CITY").Get_Hull() <= 0.10 then
					station_jivv_disabled = true
					Find_First_Object("JIVV_SPACE_CITY").Change_Owner(p_cis)
				end
			end
			if not station_rrudobar_disabled then
				if Find_First_Object("RRUDOBAR").Get_Hull() <= 0.10 then
					station_rrudobar_disabled = true
					Find_First_Object("RRUDOBAR").Change_Owner(p_cis)
				end
			end
			if not station_urrdorf_disabled then
				if Find_First_Object("URRDORF_CITY").Get_Hull() <= 0.10 then
					station_urrdorf_disabled = true
					Find_First_Object("URRDORF_CITY").Change_Owner(p_cis)
				end
			end
			if not station_orr_om_disabled then
				if Find_First_Object("ORR_OM").Get_Hull() <= 0.10 then
					station_urrdorf_disabled = true
					Find_First_Object("ORR_OM").Change_Owner(p_cis)
				end
			end
			if not station_bburru_disabled then
				if Find_First_Object("BBURRU_STATION").Get_Hull() <= 0.10 then
					station_bburru_disabled = true
					Find_First_Object("BBURRU_STATION").Change_Owner(p_cis)
				end
			end
			if not station_kri_larun_disabled then
				if Find_First_Object("KRI_LARUN").Get_Hull() <= 0.10 then
					station_kri_larun_disabled = true
					Find_First_Object("KRI_LARUN").Change_Owner(p_cis)
				end
			end
			if not station_new_tayana_disabled then
				if Find_First_Object("NEW_TAYANA").Get_Hull() <= 0.10 then
					station_new_tayana_disabled = true
					Find_First_Object("NEW_TAYANA").Change_Owner(p_cis)
				end
			end
			if not defence_fleet_killed then
				rep_list = Find_All_Objects_Of_Type(p_republic, "SpaceHero | Corvette | Capital | Frigate | SuperCapital")
				if (table.getn(rep_list) == 0) then
					defence_fleet_killed = true
				end
			end
			if not act_2_active then
				if station_jyvus_disabled and defence_fleet_killed then
					Create_Thread("State_Boarding_Begins")
					act_1_active = false
				end
			end
			cis_list = Find_All_Objects_Of_Type(p_cis, "SpaceHero | Corvette | Capital | Frigate | SuperCapital")
			if (table.getn(cis_list) == 0) then
				StoryUtil.DeclareVictory(p_republic, false)
			end
		end
	end
end


function Start_Cinematic_Intro_CIS()
	AI_Republic_Fleet = SpawnList(republic_defender_list, rep_fleet_01_marker.Get_Position(), p_republic, true, true)
	Republic_AI_Fleet = AI_Republic_Fleet[1]
	Republic_AI_Fleet.Teleport_And_Face(rep_fleet_01_marker)

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	local GrievousObjectNames = {
		"Grievous_Malevolence_Hunt_Campaign",
		"Grievous_Malevolence_2",
		"Grievous_Malevolence",
		"Grievous_Recusant",
		"Grievous_Invisible_Hand",
		"Grievous_Munificent",
	}
	for _,GrievousObjectName in pairs(GrievousObjectNames) do
		Spawn_From_Reinforcement_Pool(Find_Object_Type(GrievousObjectName), invisible_hand_marker, Find_Player("Rebel"))
		GrievousObject = Find_First_Object(GrievousObjectName)
		if TestValid(GrievousObject) then
			player_grievous = GrievousObject
		end
	end
	if not TestValid(player_grievous) then
		player_grievous = MissionUtil.SpawnUnitSpace("GRIEVOUS_INVISIBLE_HAND", invisible_hand_marker, p_cis, 300)
	end

	Fade_On()
	Sleep(0.5)

	cinematic_one = true

	Fade_Screen_In(5.0)
	Letter_Box_In(3.0)

	news_report_gamble = GameRandom.Free_Random(1, 3)
	if news_report_gamble == 1 then
		honest_news_report = true
	elseif news_report_gamble == 2 then
		propaganda_news_report = true
	elseif news_report_gamble == 3 then
		interview_news_report = true
	end

	if honest_news_report then
		MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_station_marker, true, 10.5, nil, nil)

		MissionUtil.PlayGenericSpeech("Duro_Defence_01")
		MissionUtil.PlayGenericMusic("Silence_Theme")
		Sleep(5.5)

		MissionUtil.PlayGenericMusic("Dark_Side_Reimagined_Theme")
		Sleep(0.5)

		Story_Event("NEWS_REPORT_01")
		Sleep(3.5)

		Fade_Screen_Out(2.0)
		Sleep(2.0)

		MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_station_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_station_marker, true, 16.0, nil, nil)
		Story_Event("NEWS_REPORT_02")
		Sleep(0.5)

		Fade_Screen_In(2.0)
		Sleep(6.5)

		Story_Event("NEWS_REPORT_03")
		Sleep(9.0)

		MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_station_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_station_marker, true, 20.0, nil, nil)

		Story_Event("NEWS_REPORT_04")
		Sleep(5.0)

		Fade_Screen_Out(2.0)
		Sleep(2.0)

		MissionUtil.SetCinematicCamera(introcam_7_marker, introcam_target_victory_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_8_marker, introcam_target_victory_marker, true, 30.0, nil, nil)

		Story_Event("NEWS_REPORT_05")
		Sleep(1.0)

		Fade_Screen_In(3.0)
		Sleep(7.5)

		Story_Event("NEWS_REPORT_06")
		Sleep(7.5)
	end
	if propaganda_news_report then
		MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_station_marker, true, 11.5, nil, nil)

		MissionUtil.PlayGenericSpeech("Duro_Defence_01")
		MissionUtil.PlayGenericMusic("Silence_Theme")
		Sleep(5.5)

		MissionUtil.PlayGenericMusic("Anakin_vs_ObiWan_Theme")
		Sleep(0.5)

		Story_Event("NEWS_REPORT_01_ALT_01")
		Sleep(4.5)

		Fade_Screen_Out(2.0)
		Sleep(2.0)

		MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_station_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_station_marker, true, 16.0, nil, nil)
		Story_Event("NEWS_REPORT_02_ALT_01")
		Sleep(0.5)

		Fade_Screen_In(2.0)
		Sleep(6.5)

		Story_Event("NEWS_REPORT_03_ALT_01")
		Sleep(6.5)

		MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_victory_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_victory_marker, true, 20.0, nil, nil)

		Story_Event("NEWS_REPORT_04_ALT_01")
		Sleep(8.0)

		Fade_Screen_Out(2.0)
		Sleep(2.0)

		MissionUtil.SetCinematicCamera(introcam_7_marker, introcam_target_victory_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_8_marker, introcam_target_victory_marker, true, 30.0, nil, nil)

		Story_Event("NEWS_REPORT_05_ALT_01")
		Sleep(1.0)

		Fade_Screen_In(3.0)
		Sleep(7.5)

		Story_Event("NEWS_REPORT_06_ALT_01")
		Sleep(8.5)
	end
	if interview_news_report then
		MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_station_marker, true, 12.9, nil, nil)

		MissionUtil.PlayGenericSpeech("Duro_Defence_01")
		MissionUtil.PlayGenericMusic("Silence_Theme")
		Sleep(5.5)

		MissionUtil.PlayGenericMusic("Clone_Army_Theme")
		Sleep(0.5)

		Story_Event("NEWS_REPORT_01_ALT_02")
		Sleep(5.0)

		Fade_Screen_Out(2.0)
		Sleep(2.0)

		MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_station_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_station_marker, true, 16.5, nil, nil)
		Story_Event("NEWS_REPORT_02_ALT_02")
		Sleep(0.5)

		Fade_Screen_In(2.0)
		Sleep(6.0)

		Story_Event("NEWS_REPORT_03_ALT_02")
		Sleep(9.0)

		MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_victory_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_victory_marker, true, 20.0, nil, nil)

		Story_Event("NEWS_REPORT_04_ALT_02")
		Sleep(7.5)

		Fade_Screen_Out(2.0)
		Sleep(2.0)

		MissionUtil.SetCinematicCamera(introcam_7_marker, introcam_target_victory_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_8_marker, introcam_target_victory_marker, true, 30.0, nil, nil)

		Story_Event("NEWS_REPORT_05_ALT_02")
		Sleep(1.0)

		Fade_Screen_In(3.0)
		Sleep(7.5)

		Story_Event("NEWS_REPORT_06_ALT_01")
		Sleep(6.0)
	end

	MissionUtil.MissionTextSpeech("DURO_DEFENCE", 7, 6.5, nil, {r = 250, g = 44, b = 44}) -- Rule Davenbay
	Sleep(1.0)

	Fade_Screen_Out(5.0)
	Sleep(6.5)

	player_munificent_1 = MissionUtil.SpawnUnitSpace("MUNIFICENT", intro_cis_ship_1_marker, p_cis, 50)
	player_munificent_2 = MissionUtil.SpawnUnitSpace("MUNIFICENT", intro_cis_ship_2_marker, p_cis, 50)

	if TestValid(Find_First_Object("Grievous_Invisible_Hand")) then
		Find_First_Object("Grievous_Invisible_Hand").Teleport_And_Face(invisible_hand_marker)
		Find_First_Object("Grievous_Invisible_Hand").Cinematic_Hyperspace_In(150)
		grievous_invisible_hand_active = true

		MissionUtil.SetCinematicCamera(introcam_9_marker, introcam_target_invisible_hand_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_10_marker, introcam_target_invisible_hand_marker, true, 10.0, nil, nil)
	end
	if TestValid(Find_First_Object("Grievous_Recusant")) then
		Find_First_Object("Grievous_Recusant").Teleport_And_Face(renitor_marker)
		Find_First_Object("Grievous_Recusant").Cinematic_Hyperspace_In(150)
		grievous_renitor_active = true

		MissionUtil.SetCinematicCamera(introcam_9_marker, introcam_target_renitor_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_10_marker, introcam_target_renitor_marker, true, 10.0, nil, nil)
	end
	if TestValid(Find_First_Object("Grievous_Munificent")) then
		Find_First_Object("Grievous_Munificent").Teleport_And_Face(munificent_marker)
		Find_First_Object("Grievous_Munificent").Cinematic_Hyperspace_In(150)
		grievous_munificent_active = true

		MissionUtil.SetCinematicCamera(introcam_9_marker, introcam_target_munificent_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_10_marker, introcam_target_munificent_marker, true, 10.0, nil, nil)
	end
	if TestValid(Find_First_Object("Grievous_Malevolence")) then
		Find_First_Object("Grievous_Malevolence").Teleport_And_Face(invisible_hand_marker)
		Find_First_Object("Grievous_Malevolence").Cinematic_Hyperspace_In(150)
		grievous_malevolence_active = true

		MissionUtil.SetCinematicCamera(introcam_9_marker, introcam_target_invisible_hand_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_10_marker, introcam_target_invisible_hand_marker, true, 10.0, nil, nil)
	end

	Cinematic_Zoom(40, 40)

	MissionUtil.PlayGenericMusic("Grievous_Theme")

	MissionUtil.MissionTextSpeech("DURO_DEFENCE", 8, 8.0, "Grievous_Loop", {r = 245, g = 243, b = 82}) -- General Grievous
	Fade_Screen_In(3.0)
	Sleep(8.5)

	cis_fleet = Find_All_Objects_Of_Type(p_cis)
	for _,cis_ships in pairs(cis_fleet) do
		if TestValid(cis_ships) then
			if TestValid(station_jyvus_space_city) then
				cis_ships.Attack_Move(station_jyvus_space_city)
			end
		end
	end

	MissionUtil.MissionTextSpeech("DURO_DEFENCE", 9, 6.0, "Grievous_Loop", {r = 245, g = 243, b = 82}) -- General Grievous
	Sleep(6.5)

	MissionUtil.SetCinematicCamera(introcam_11_marker, station_jivv_space_city, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_12_marker, station_urrdorf_city, true, 8.0, nil, nil)

	MissionUtil.MissionTextSpeech("DURO_DEFENCE", 10, 7.5, "Grievous_Loop", {r = 245, g = 243, b = 82}) -- General Grievous
	Sleep(8.0)

	MissionUtil.SetCinematicCamera(introcam_13_marker, introcam_target_station_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_14_marker, introcam_target_station_marker, true, 10.0, nil, nil)

	MissionUtil.MissionTextSpeech("DURO_DEFENCE", 11, 4.0, nil, {r = 250, g = 44, b = 44}) -- Hoolidan Keggle
	Sleep(4.5)

	MissionUtil.MissionTextSpeech("DURO_DEFENCE", 11, 5.0, "Grievous_Loop", {r = 245, g = 243, b = 82}) -- General Grievous
	Sleep(5.5)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end
function End_Cinematic_Intro_CIS()
	MissionUtil.EndCinematicCamera(intro_cis_ship_1_marker, 3.0)
	MissionUtil.CinematicEnvironmentOff()

	MissionUtil.Set_To_Enemies(p_cis, p_republic)

	MissionUtil.SetObjectiveMissionSet("DURO_DEFENCE", "CIS", 3)
	MissionUtil.AIActivation()

	MissionUtil.MissionTextSpeech("DURO_DEFENCE", 13, 10.0, "Grievous_Loop", {r = 245, g = 243, b = 82}) -- General Grievous

	if StoryUtil.GetDifficulty() == "EASY" then
		Register_Timer(State_Avenger_Fleet_Arrives, 300)
	end
	if StoryUtil.GetDifficulty() == "NORMAL" then
		Register_Timer(State_Avenger_Fleet_Arrives, 240)
	end
	if StoryUtil.GetDifficulty() == "HARD" then
		Register_Timer(State_Avenger_Fleet_Arrives, 150)
	end

	current_cinematic_thread_id = nil

	cinematic_one = false
	act_1_active = true
end

function Start_Cinematic_Outro_CIS()
	StoryUtil.TriggerScriptedBattle("JYVUS_JOYRIDE", "DURO", "LAND", "REBEL", "EMPIRE", false)

	act_1_active = false
	cinematic_two = true

	Fade_Screen_Out(0.5)
	Sleep(0.5)

	MissionUtil.CinematicEnvironmentOn()
	MissionUtil.StartCinematicCamera()
	Sleep(0.5)

	Fade_Screen_In(0.5)
	Letter_Box_In(0.5)

	MissionUtil.PlayGenericMusic("Grievous_Theme")

	player_transport_1 = Spawn_Unit(Find_Object_Type("TF_Landing_Craft"), outro_cis_ship_1_marker, p_cis)
	player_transport_1 = Find_Nearest(outro_cis_ship_1_marker, p_cis, true)
	player_transport_1.Teleport_And_Face(outro_cis_ship_1_marker)
	player_transport_1.Cinematic_Hyperspace_In(50)

	player_transport_2 = Spawn_Unit(Find_Object_Type("TF_Landing_Craft"), outro_cis_ship_2_marker, p_cis)
	player_transport_2 = Find_Nearest(outro_cis_ship_2_marker, p_cis, true)
	player_transport_2.Teleport_And_Face(outro_cis_ship_2_marker)
	player_transport_2.Cinematic_Hyperspace_In(50)

	player_transport_3 = Spawn_Unit(Find_Object_Type("TF_Landing_Craft"), outro_cis_ship_3_marker, p_cis)
	player_transport_3 = Find_Nearest(outro_cis_ship_3_marker, p_cis, true)
	player_transport_3.Teleport_And_Face(outro_cis_ship_3_marker)
	player_transport_3.Cinematic_Hyperspace_In(50)

	player_transport_4 = Spawn_Unit(Find_Object_Type("TF_Landing_Craft"), outro_cis_ship_4_marker, p_cis)
	player_transport_4 = Find_Nearest(outro_cis_ship_4_marker, p_cis, true)
	player_transport_4.Teleport_And_Face(outro_cis_ship_4_marker)
	player_transport_4.Cinematic_Hyperspace_In(50)

	player_transport_5 = Spawn_Unit(Find_Object_Type("TF_Landing_Craft"), outro_cis_ship_5_marker, p_cis)
	player_transport_5 = Find_Nearest(outro_cis_ship_5_marker, p_cis, true)
	player_transport_5.Teleport_And_Face(outro_cis_ship_5_marker)
	player_transport_5.Cinematic_Hyperspace_In(50)


	MissionUtil.SetCinematicCamera(outrocam_1_marker, outro_cis_ship_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outro_cis_ship_1_marker, true, 10.0, nil, nil)

	MissionUtil.MissionTextSpeech("DURO_DEFENCE", 17, 7.5, "Grievous_Loop", {r = 245, g = 243, b = 82}) -- General Grievous
	Sleep(5.5)

	Fade_Screen_Out(1.5)
	Sleep(2.5)

	MissionUtil.CinematicEnvironmentOff()
	StoryUtil.DeclareVictory(p_cis, false)
end


function Start_Cinematic_Intro_Rep()
	rep_fleet_01_marker = Find_First_Object("DEFENDING FORCES POSITION")
	AI_Republic_Fleet = SpawnList(republic_defender_list, rep_fleet_01_marker.Get_Position(), p_republic, true, true)
	Republic_AI_Fleet = AI_Republic_Fleet[1]
	Republic_AI_Fleet.Teleport_And_Face(rep_fleet_01_marker)

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	player_invisible_hand = Spawn_Unit(Find_Object_Type("Providence_Carrier_Destroyer"), invisible_hand_marker, p_cis)
	player_invisible_hand = Find_Nearest(invisible_hand_marker, p_cis, true)
	player_invisible_hand.Teleport_And_Face(invisible_hand_marker)	
	grievous_invisible_hand_active = true

	Fade_On()
	Sleep(0.5)

	cinematic_one = true

	Fade_Screen_In(5.0)
	Letter_Box_In(3.0)

	news_report_gamble = GameRandom.Free_Random(1, 3)
	if news_report_gamble == 1 then
		honest_news_report = true
	elseif news_report_gamble == 2 then
		propaganda_news_report = true
	elseif news_report_gamble == 3 then
		interview_news_report = true
	end

	if honest_news_report then
		MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_station_marker, true, 10.5, nil, nil)

		MissionUtil.PlayGenericSpeech("Duro_Defence_01")
		MissionUtil.PlayGenericMusic("Silence_Theme")
		Sleep(5.5)

		MissionUtil.PlayGenericMusic("Dark_Side_Reimagined_Theme")
		Sleep(0.5)

		Story_Event("NEWS_REPORT_01")
		Sleep(3.5)

		Fade_Screen_Out(2.0)
		Sleep(2.0)

		MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_station_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_station_marker, true, 16.0, nil, nil)
		Story_Event("NEWS_REPORT_02")
		Sleep(0.5)

		Fade_Screen_In(2.0)
		Sleep(6.5)

		Story_Event("NEWS_REPORT_03")
		Sleep(9.0)

		MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_station_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_station_marker, true, 20.0, nil, nil)

		Story_Event("NEWS_REPORT_04")
		Sleep(5.0)

		Fade_Screen_Out(2.0)
		Sleep(2.0)

		MissionUtil.SetCinematicCamera(introcam_7_marker, introcam_target_victory_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_8_marker, introcam_target_victory_marker, true, 30.0, nil, nil)

		Story_Event("NEWS_REPORT_05")
		Sleep(1.0)

		Fade_Screen_In(3.0)
		Sleep(7.5)

		Story_Event("NEWS_REPORT_06")
		Sleep(7.5)
	end
	if propaganda_news_report then
		MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_station_marker, true, 11.5, nil, nil)

		MissionUtil.PlayGenericSpeech("Duro_Defence_01")
		MissionUtil.PlayGenericMusic("Silence_Theme")
		Sleep(5.5)

		MissionUtil.PlayGenericMusic("Anakin_vs_ObiWan_Theme")
		Sleep(0.5)

		Story_Event("NEWS_REPORT_01_ALT_01")
		Sleep(4.5)

		Fade_Screen_Out(2.0)
		Sleep(2.0)

		MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_station_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_station_marker, true, 16.0, nil, nil)
		Story_Event("NEWS_REPORT_02_ALT_01")
		Sleep(0.5)

		Fade_Screen_In(2.0)
		Sleep(6.5)

		Story_Event("NEWS_REPORT_03_ALT_01")
		Sleep(6.5)

		MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_victory_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_victory_marker, true, 20.0, nil, nil)

		Story_Event("NEWS_REPORT_04_ALT_01")
		Sleep(8.0)

		Fade_Screen_Out(2.0)
		Sleep(2.0)

		MissionUtil.SetCinematicCamera(introcam_7_marker, introcam_target_victory_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_8_marker, introcam_target_victory_marker, true, 30.0, nil, nil)

		Story_Event("NEWS_REPORT_05_ALT_01")
		Sleep(1.0)

		Fade_Screen_In(3.0)
		Sleep(7.5)

		Story_Event("NEWS_REPORT_06_ALT_01")
		Sleep(8.5)
	end
	if interview_news_report then
		MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_station_marker, true, 12.9, nil, nil)

		MissionUtil.PlayGenericSpeech("Duro_Defence_01")
		MissionUtil.PlayGenericMusic("Silence_Theme")
		Sleep(5.5)

		MissionUtil.PlayGenericMusic("Clone_Army_Theme")
		Sleep(0.5)

		Story_Event("NEWS_REPORT_01_ALT_02")
		Sleep(5.0)

		Fade_Screen_Out(2.0)
		Sleep(2.0)

		MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_station_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_station_marker, true, 16.5, nil, nil)
		Story_Event("NEWS_REPORT_02_ALT_02")
		Sleep(0.5)

		Fade_Screen_In(2.0)
		Sleep(6.0)

		Story_Event("NEWS_REPORT_03_ALT_02")
		Sleep(9.0)

		MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_victory_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_victory_marker, true, 20.0, nil, nil)

		Story_Event("NEWS_REPORT_04_ALT_02")
		Sleep(7.5)

		Fade_Screen_Out(2.0)
		Sleep(2.0)

		MissionUtil.SetCinematicCamera(introcam_7_marker, introcam_target_victory_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_8_marker, introcam_target_victory_marker, true, 30.0, nil, nil)

		Story_Event("NEWS_REPORT_05_ALT_02")
		Sleep(1.0)

		Fade_Screen_In(3.0)
		Sleep(7.5)

		Story_Event("NEWS_REPORT_06_ALT_01")
		Sleep(6.0)
	end

	MissionUtil.MissionTextSpeech("DURO_DEFENCE", 7, 6.5, nil, {r = 250, g = 44, b = 44}) -- Rule Davenbay
	Sleep(1.0)

	Fade_Screen_Out(5.0)
	Sleep(6.5)

	player_munificent_1 = MissionUtil.SpawnUnitSpace("MUNIFICENT", intro_cis_ship_1_marker, p_cis, 50)
	player_munificent_2 = MissionUtil.SpawnUnitSpace("MUNIFICENT", intro_cis_ship_2_marker, p_cis, 50)

	player_invisible_hand.Teleport_And_Face(invisible_hand_marker)
	player_invisible_hand.Cinematic_Hyperspace_In(150)

	MissionUtil.SetCinematicCamera(introcam_9_marker, introcam_target_invisible_hand_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_10_marker, introcam_target_invisible_hand_marker, true, 10.0, nil, nil)

	Cinematic_Zoom(40, 40)

	MissionUtil.PlayGenericMusic("Grievous_Theme")

	MissionUtil.MissionTextSpeech("DURO_DEFENCE", 8, 8.0, "Grievous_Loop", {r = 245, g = 243, b = 82}) -- General Grievous
	Fade_Screen_In(3.0)
	Sleep(8.5)

	cis_fleet = Find_All_Objects_Of_Type(p_cis)
	for _,cis_ships in pairs(cis_fleet) do
		if TestValid(cis_ships) then
			if TestValid(station_jyvus_space_city) then
				cis_ships.Attack_Move(station_jyvus_space_city)
			end
		end
	end

	MissionUtil.MissionTextSpeech("DURO_DEFENCE", 9, 6.0, "Grievous_Loop", {r = 245, g = 243, b = 82}) -- General Grievous
	Sleep(6.5)

	MissionUtil.SetCinematicCamera(introcam_11_marker, station_jivv_space_city, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_12_marker, station_urrdorf_city, true, 8.0, nil, nil)

	MissionUtil.MissionTextSpeech("DURO_DEFENCE", 10, 7.5, "Grievous_Loop", {r = 245, g = 243, b = 82}) -- General Grievous
	Sleep(8.0)

	MissionUtil.SetCinematicCamera(introcam_13_marker, introcam_target_station_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_14_marker, introcam_target_station_marker, true, 10.0, nil, nil)

	MissionUtil.MissionTextSpeech("DURO_DEFENCE", 11, 4.0, nil, {r = 250, g = 44, b = 44}) -- Hoolidan Keggle
	Sleep(4.5)

	MissionUtil.MissionTextSpeech("DURO_DEFENCE", 11, 5.0, "Grievous_Loop", {r = 245, g = 243, b = 82}) -- General Grievous
	Sleep(5.5)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Rep")
	end
end
function End_Cinematic_Intro_Rep()
	MissionUtil.EndCinematicCamera(intro_cis_ship_1_marker, 3.0)
	MissionUtil.CinematicEnvironmentOff()

	MissionUtil.Set_To_Enemies(p_cis, p_republic)

	MissionUtil.SetObjectiveMissionSet("DURO_DEFENCE", "REP", 3)
	MissionUtil.AIActivation()

	MissionUtil.MissionTextSpeech("DURO_DEFENCE", 14, 10.0, "SoBilles_Loop", {r = 250, g = 44, b = 44}) -- Hoolidan Keggle

	AI_Fleet = SpawnList(cis_attacker_list, intro_cis_ship_1_marker.Get_Position(), p_cis, true, true)
	AI_Fleet = AI_Fleet[1]
	AI_Fleet.Teleport_And_Face(intro_cis_ship_1_marker)

	if StoryUtil.GetDifficulty() == "EASY" then
		Register_Timer(State_Avenger_Fleet_Arrives, 60)
	end
	if StoryUtil.GetDifficulty() == "NORMAL" then
		Register_Timer(State_Avenger_Fleet_Arrives, 105)
	end
	if StoryUtil.GetDifficulty() == "HARD" then
		Register_Timer(State_Avenger_Fleet_Arrives, 150)
	end

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
	Letter_Box_In(0.5)

	MissionUtil.PlayGenericMusic("Grievous_Theme")

	player_transport_1 = Spawn_Unit(Find_Object_Type("TF_Landing_Craft"), outro_cis_ship_1_marker, p_cis)
	player_transport_1 = Find_Nearest(outro_cis_ship_1_marker, p_cis, true)
	player_transport_1.Teleport_And_Face(outro_cis_ship_1_marker)
	player_transport_1.Cinematic_Hyperspace_In(50)

	player_transport_2 = Spawn_Unit(Find_Object_Type("TF_Landing_Craft"), outro_cis_ship_2_marker, p_cis)
	player_transport_2 = Find_Nearest(outro_cis_ship_2_marker, p_cis, true)
	player_transport_2.Teleport_And_Face(outro_cis_ship_2_marker)
	player_transport_2.Cinematic_Hyperspace_In(50)

	player_transport_3 = Spawn_Unit(Find_Object_Type("TF_Landing_Craft"), outro_cis_ship_3_marker, p_cis)
	player_transport_3 = Find_Nearest(outro_cis_ship_3_marker, p_cis, true)
	player_transport_3.Teleport_And_Face(outro_cis_ship_3_marker)
	player_transport_3.Cinematic_Hyperspace_In(50)

	player_transport_4 = Spawn_Unit(Find_Object_Type("TF_Landing_Craft"), outro_cis_ship_4_marker, p_cis)
	player_transport_4 = Find_Nearest(outro_cis_ship_4_marker, p_cis, true)
	player_transport_4.Teleport_And_Face(outro_cis_ship_4_marker)
	player_transport_4.Cinematic_Hyperspace_In(50)

	player_transport_5 = Spawn_Unit(Find_Object_Type("TF_Landing_Craft"), outro_cis_ship_5_marker, p_cis)
	player_transport_5 = Find_Nearest(outro_cis_ship_5_marker, p_cis, true)
	player_transport_5.Teleport_And_Face(outro_cis_ship_5_marker)
	player_transport_5.Cinematic_Hyperspace_In(50)

	MissionUtil.SetCinematicCamera(outrocam_1_marker, outro_cis_ship_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outro_cis_ship_1_marker, true, 10.0, nil, nil)

	MissionUtil.MissionTextSpeech("DURO_DEFENCE", 17, 7.5, "Grievous_Loop", {r = 245, g = 243, b = 82}) -- General Grievous
	Sleep(5.5)

	Fade_Screen_Out(1.5)
	Sleep(2.5)

	MissionUtil.CinematicEnvironmentOff()
	StoryUtil.DeclareVictory(p_cis, false)
end
