
--*****************************************************--
--******** Operation Durge's Lance: Holo Hunt *********--
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

	republic_defender_list = {
		"Acclamator_I_Assault",
		"Acclamator_I_Assault",
		"PDF_DHC",
		"PDF_DHC",
		"Arquitens",
		"Arquitens",
		"LAC",
		"LAC",
		"LAC",
		"LAC",
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

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")

	cinematic_one = false

	cinematic_one_skipped = false

	act_1_active = false

	station_holonet_disabled = false

	grievous_soulless_one_active = false
	grievous_renitor_active = false
	grievous_munificent_active = false
	grievous_invisible_hand_active = false
	grievous_malevolence_active = false

	rep_propaganda_news_report = false
	interview_news_report = false
	cis_propaganda_news_report = false

	current_cinematic_thread_id = nil

	camera_offset = 125
	mission_started = false
end
function Begin_Battle(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			rep_defence_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defence-1")
			rep_defence_02_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defence-2")

			rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-1")
			rep_fleet_02_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-2")
			rep_fleet_03_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-3")
			rep_fleet_04_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-4")
			rep_fleet_05_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-5")

			grievous_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "grievous")

			introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
			introcam_target_station_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
			introcam_target_tagge_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")

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

			station_holonet = Find_First_Object("HoloNet_Relay_HQ")

			player_tagge = Find_Hint("TAGGE_BATTLECRUISER", "tagge")

			player_grievous = Find_First_Object("GRIEVOUS_MUNIFICENT")
			if TestValid(player_grievous) then
				grievous_munificent_active = true
			else
				player_grievous = Find_First_Object("GRIEVOUS_RECUSANT")
				if TestValid(player_grievous) then
					grievous_renitor_active = true
				else
					player_grievous = Find_First_Object("GRIEVOUS_INVISIBLE_HAND")
					if TestValid(player_grievous) then
						grievous_invisible_hand_active = true
					else
						player_grievous = Find_First_Object("GRIEVOUS_MALEVOLENCE")
						if TestValid(player_grievous) then
							grievous_malevolence_active = true
						else
							player_grievous = Find_First_Object("SOULLESS_ONE")
							if TestValid(player_grievous) then
								grievous_soulless_one_active = true
							end
						end
					end
				end
			end

			mission_started = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
		end
	end
end

function State_Avenger_Fleet_Arrives()
	if not avenger_fleet_arrived then
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
		Story_Event("NOT_GIVING_UP")
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

				Fade_Screen_Out(0)
				Stop_All_Music()
				Stop_All_Speech()
				Remove_All_Text()
				Stop_Bink_Movie()

				MissionUtil.CinematicEnvironmentOff()
				if p_republic.Get_Difficulty()== "Easy" then
				elseif p_republic.Get_Difficulty()== "Hard" then
					Register_Timer(State_Avenger_Fleet_Arrives, 150)
				else
					Register_Timer(State_Avenger_Fleet_Arrives, 240)
				end

				p_republic.Make_Enemy(p_cis)
				p_cis.Make_Enemy(p_republic)

				Letter_Box_Out(0)
				Lock_Controls(0)
				Suspend_AI(0)
				End_Cinematic_Camera()

				MissionUtil.AIActivation()

				Story_Event("GOAL_TRIGGER_CIS_I")
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
			if not station_holonet_disabled then
				if not TestValid(Find_First_Object("HoloNet_Relay_HQ")) then
					station_holonet_disabled = true
				end
			end
			if not defence_fleet_killed then
				rep_list = Find_All_Objects_Of_Type(p_republic, "SpaceHero | Corvette | Capital | Frigate | SuperCapital | SpaceStructure")
				if (table.getn(rep_list) == 0) then
					StoryUtil.DeclareVictory(p_cis, false)
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
	AI_Republic_Fleet = SpawnList(republic_defender_list, rep_defence_01_marker.Get_Position(), p_republic, true, true)
	Republic_AI_Fleet = AI_Republic_Fleet[1]
	Republic_AI_Fleet.Teleport_And_Face(rep_defence_01_marker)

	Start_Cinematic_Camera()
	Stop_All_Music()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()

	local GrievousObjectNames = {
		"Grievous_Malevolence_Hunt_Campaign",
		"Grievous_Malevolence_2",
		"Grievous_Malevolence",
		"Grievous_Recusant",
		"Grievous_Invisible_Hand",
		"Grievous_Munificent",
	}
	for _,GrievousObjectName in pairs(GrievousObjectNames) do
		Spawn_From_Reinforcement_Pool(Find_Object_Type(GrievousObjectName), grievous_marker, Find_Player("Rebel"))
		GrievousObject = Find_First_Object(GrievousObjectName)
		if TestValid(GrievousObject) then
			player_grievous = GrievousObject
		end
	end
	if not TestValid(player_grievous) then
		player_grievous = MissionUtil.SpawnUnitSpace("GRIEVOUS_INVISIBLE_HAND", grievous_marker, p_cis, 300)
	end

	Fade_On()
	Sleep(0.5)

	cinematic_one = true

	Fade_Screen_In(5)
	Letter_Box_In(3)

	local news_report_gamble = GameRandom.Free_Random(1, 3)
	if news_report_gamble == 1 then
		rep_propaganda_news_report = true
	elseif news_report_gamble == 2 then
		cis_propaganda_news_report = true
	elseif news_report_gamble == 3 then
		interview_news_report = true
	end

	if rep_propaganda_news_report then
		Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_2_marker, 11.5, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_2_marker, 11.5, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Play_Music("Duro_Defence_01")
		Sleep(5.5)

		Play_Music("Clone_Army_Theme")
		Sleep(0.5)

		Story_Event("NEWS_REPORT_01")
		Sleep(4.5)

		Fade_Screen_Out(2)
		Sleep(2.0)

		Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_4_marker, 16, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_4_marker, 16, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Story_Event("NEWS_REPORT_02")
		Sleep(0.5)

		Fade_Screen_In(2)
		Sleep(5.0)

		Story_Event("NEWS_REPORT_03")
		Sleep(8.5)

		Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_5_marker, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_6_marker, 7, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_6_marker, 7, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)

		Story_Event("NEWS_REPORT_04")
		Story_Event("NEWS_REPORT_05")
		Sleep(5.0)

		Fade_Screen_Out(2)
		Sleep(2.0)

		Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, introcam_target_tagge_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_8_marker, 8.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_8_marker, 8.0, 0, 0, 0, 0, introcam_target_tagge_marker, 1, 0)
		Sleep(1.0)

		Fade_Screen_In(3)
		Sleep(7.5)

		Set_Cinematic_Camera_Key(introcam_9_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_9_marker, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_10_marker, 16.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_10_marker, 16.0, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Story_Event("NEWS_REPORT_06")
		Story_Event("NEWS_REPORT_07")
		Sleep(15.5)

		Set_Cinematic_Camera_Key(introcam_11_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_11_marker, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_12_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_12_marker, 10.0, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Story_Event("NEWS_REPORT_08")
		Sleep(9.5)

		Set_Cinematic_Camera_Key(introcam_13_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_13_marker, 0, 0, 0, 0, introcam_target_tagge_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_14_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_14_marker, 10.0, 0, 0, 0, 0, introcam_target_tagge_marker, 1, 0)
		Story_Event("NEWS_REPORT_09")
		Sleep(6.5)

		Set_Cinematic_Camera_Key(introcam_15_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_15_marker, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_16_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_16_marker, 10.0, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Story_Event("NEWS_REPORT_10")
		Sleep(6.0)
		Fade_Screen_Out(2)
		Sleep(3.0)
	elseif cis_propaganda_news_report then
		Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_2_marker, 11.5, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_2_marker, 11.5, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Play_Music("Duro_Defence_01")
		Sleep(5.5)

		Play_Music("Grievous_Theme")
		Sleep(0.5)

		Story_Event("NEWS_REPORT_01_ALT_01")
		Sleep(4.5)

		Fade_Screen_Out(2)
		Sleep(2.0)

		Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_4_marker, 16, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_4_marker, 16, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Story_Event("NEWS_REPORT_02_ALT_01")
		Sleep(0.5)

		Fade_Screen_In(2)
		Sleep(7.0)

		Story_Event("NEWS_REPORT_03_ALT_01")
		Story_Event("NEWS_REPORT_04_ALT_01")
		Sleep(8.5)

		Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_5_marker, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_6_marker, 8, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_6_marker, 8, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Sleep(6.0)

		Fade_Screen_Out(2)
		Sleep(2.0)

		Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, introcam_target_tagge_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_8_marker, 8.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_8_marker, 8.0, 0, 0, 0, 0, introcam_target_tagge_marker, 1, 0)
		Story_Event("NEWS_REPORT_05_ALT_01")
		Sleep(1.0)

		Fade_Screen_In(3)
		Sleep(4.5)

		Set_Cinematic_Camera_Key(introcam_9_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_9_marker, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_10_marker, 9.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_10_marker, 9.0, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Story_Event("NEWS_REPORT_06_ALT_01")
		Sleep(8.5)

		Set_Cinematic_Camera_Key(introcam_11_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_11_marker, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_12_marker, 16.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_12_marker, 16.0, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Story_Event("NEWS_REPORT_07_ALT_01")
		Story_Event("NEWS_REPORT_08_ALT_01")
		Sleep(15.5)

		Set_Cinematic_Camera_Key(introcam_13_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_13_marker, 0, 0, 0, 0, introcam_target_tagge_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_14_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_14_marker, 10.0, 0, 0, 0, 0, introcam_target_tagge_marker, 1, 0)
		Story_Event("NEWS_REPORT_09_ALT_01")
		Sleep(8.5)

		Set_Cinematic_Camera_Key(introcam_15_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_15_marker, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_16_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_16_marker, 10.0, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Story_Event("NEWS_REPORT_10_ALT_01")
		Sleep(5.0)
		Fade_Screen_Out(2)
		Sleep(3.0)
	elseif interview_news_report then
		Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_2_marker, 11.5, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_2_marker, 11.5, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Play_Music("Duro_Defence_01")
		Sleep(5.5)

		Play_Music("Clone_Army_Theme")
		Sleep(0.5)

		Story_Event("NEWS_REPORT_01_ALT_02")
		Sleep(4.5)

		Fade_Screen_Out(2)
		Sleep(2.0)

		Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_4_marker, 16, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_4_marker, 16, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Story_Event("NEWS_REPORT_02_ALT_02")
		Sleep(0.5)

		Fade_Screen_In(2)
		Sleep(5.0)

		Story_Event("NEWS_REPORT_03_ALT_02")
		Sleep(8.5)

		Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_5_marker, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_6_marker, 7, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_6_marker, 7, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)

		Story_Event("NEWS_REPORT_04_ALT_02")
		Sleep(5.0)

		Fade_Screen_Out(2)
		Sleep(2.0)

		Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, introcam_target_tagge_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_8_marker, 8.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_8_marker, 8.0, 0, 0, 0, 0, introcam_target_tagge_marker, 1, 0)
		Story_Event("NEWS_REPORT_05_ALT_02")
		Sleep(1.0)

		Fade_Screen_In(3)
		Sleep(7.5)

		Set_Cinematic_Camera_Key(introcam_9_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_9_marker, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_10_marker, 16.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_10_marker, 16.0, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Story_Event("NEWS_REPORT_06_ALT_02")
		Sleep(7.5)

		Story_Event("NEWS_REPORT_07_ALT_02")
		Sleep(8.0)

		Set_Cinematic_Camera_Key(introcam_11_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_11_marker, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_12_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_12_marker, 10.0, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Story_Event("NEWS_REPORT_08_ALT_02")
		Sleep(9.5)

		Set_Cinematic_Camera_Key(introcam_13_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_13_marker, 0, 0, 0, 0, introcam_target_tagge_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_14_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_14_marker, 10.0, 0, 0, 0, 0, introcam_target_tagge_marker, 1, 0)
		Story_Event("NEWS_REPORT_09_ALT_02")
		Sleep(6.5)

		Set_Cinematic_Camera_Key(introcam_15_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_15_marker, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_16_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_16_marker, 10.0, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
		Story_Event("NEWS_REPORT_10_ALT_02")
		Sleep(6.0)
		Fade_Screen_Out(2)
		Sleep(3.0)
	end

	player_grievous.Teleport_And_Face(grievous_marker)
	player_grievous.Cinematic_Hyperspace_In(150)

	Set_Cinematic_Camera_Key(introcam_17_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_17_marker, 0, 0, 0, 0, player_grievous, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_18_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_18_marker, 10.0, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)

	Story_Event("NEWS_REPORT_11")
	Fade_Screen_In(5)
	Sleep(7.0)

	Cinematic_Zoom(40, 40)

	Set_Cinematic_Camera_Key(introcam_19_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_19_marker, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_20_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_20_marker, 10.0, 0, 0, 0, 0, introcam_target_station_marker, 1, 0)
	Story_Event("NEWS_REPORT_12")
	Sleep(6.5)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end
function End_Cinematic_Intro_CIS()
	MissionUtil.EndCinematicCamera(player_grievous, 3.0)
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.AIActivation()

	p_cis.Make_Enemy(p_republic)
	p_republic.Make_Enemy(p_cis)

	Story_Event("GOAL_TRIGGER_CIS_I")

	cinematic_one = false
	act_1_active = true

	if p_republic.Get_Difficulty()== "Easy" then
	elseif p_republic.Get_Difficulty()== "Hard" then
		Register_Timer(State_Avenger_Fleet_Arrives, 150)
	else
		Register_Timer(State_Avenger_Fleet_Arrives, 240)
	end

	MissionUtil.VictoryAllowance(true)
end