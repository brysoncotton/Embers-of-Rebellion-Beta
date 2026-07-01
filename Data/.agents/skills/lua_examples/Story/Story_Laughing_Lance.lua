
--*****************************************************--
--****** Operation Durge's Lance: Laughing Lance *******--
--*****************************************************--

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")
require("PGCommands")
require("TRCommands")
require("eawx-util/StoryUtil")
require("eawx-util/MissionUtil")
require("deepcore/std/class")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	StoryModeEvents =
	{
		Battle_Start = Begin_Battle,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_hostile = Find_Player("Hostile")
	p_neutral = Find_Player("Neutral")
	p_pdf = Find_Player("Sector_Forces")

	mission_started = false

	cinematic_crawl = false
	cinematic_one = false
	cinematic_two = false
	cinematic_three = false
	cinematic_four = false

	cinematic_crawl_skipped = false
	cinematic_one_skipped = false
	cinematic_two_skipped = false
	cinematic_three_skipped = false
	cinematic_four_skipped = false

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
		introcam_13_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-13")
		introcam_14_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-14")
		introcam_15_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-15")
		introcam_16_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-16")
		introcam_17_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-17")
		introcam_18_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-18")
		introcam_19_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-19")
		introcam_20_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-20")
		introcam_21_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-21")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")
		introcam_target_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-4")

		intro_dhc_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-dhc-1")
		intro_dhc_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-dhc-2")

		intro_grievous_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-grievous")
		intro_cis_fleet_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-fleet-1")
		intro_cis_fleet_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-fleet-2")
		intro_cis_fleet_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-fleet-3")
		intro_cis_fleet_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-fleet-4")
		intro_cis_fleet_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-fleet-5")
		intro_cis_fleet_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-fleet-6")
		intro_cis_fleet_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-fleet-7")

		player_munificent	= Find_First_Object("MUNIFICENT")
		player_recusant = Find_First_Object("RECUSANT_LIGHT_DESTROYER")
		player_recusant_d = Find_First_Object("RECUSANT_DREADNOUGHT")
		player_providence_d = Find_First_Object("PROVIDENCE_DREADNOUGHT")
		player_lucrehulk = Find_First_Object("LUCREHULK_CARRIER_CONTROL")
		player_core_d = Find_First_Object("LUCREHULK_CORE_DESTROYER")
		player_supplier = Find_First_Object("DH_OMNI")

		player_dhc = Find_Hint("PDF_DHC", "1")
		player_dhc.Change_Owner(p_republic)

		MissionUtil.Set_To_Allies(p_cis, p_republic)

		cis_list = Find_All_Objects_Of_Type(p_cis)
		for j,cis_stuff in pairs(cis_list) do
			if TestValid(cis_stuff) then
				Hide_Object(cis_stuff, 1)
			end
		end

		if p_cis.Is_Human() then
			mission_started = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Crawl_CIS")
		elseif p_republic.Is_Human() then
			mission_started = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Crawl_Rep")
		end
	end
end

function Story_Handle_Esc()
	if mission_started then
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

					MissionUtil.CinematicEnvironmentOff()
					MissionUtil.AIActivation()
					StoryUtil.DeclareVictory(p_cis, false)
				end
			end
		elseif p_republic.Is_Human() then
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

					MissionUtil.CinematicEnvironmentOff()
					MissionUtil.AIActivation()
					StoryUtil.DeclareVictory(p_republic, false)
				end
			end
		end
	end
end
function Story_Mode_Service()
	if p_cis.Is_Human() then
	elseif p_republic.Is_Human() then
	end
end

function Start_Cinematic_Crawl_CIS()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true)

	cinematic_crawl = true
	MissionUtil.PlayCinematicMovieCrawl("Durges_Lance_Campaign_Intro", "Clone_Wars_Crawl_Theme")

	if not cinematic_crawl_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
	end
end
function Start_Cinematic_Intro_CIS()
	cinematic_crawl = false

	if (GlobalValue.Get("ODL_CIS_GC_Version") == 0) then
		Find_First_Object("GRIEVOUS_MALEVOLENCE").Despawn()
		player_grievous = Find_First_Object("GRIEVOUS_INVISIBLE_HAND")
	else
		Find_First_Object("GRIEVOUS_INVISIBLE_HAND").Despawn()
		player_grievous = Find_First_Object("GRIEVOUS_MALEVOLENCE")
	end

	cinematic_one = true

	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, true, 8.0, nil, nil)

	MissionUtil.PlayGenericMusic("ESB_The_Ice_Planet_Hoth")
	Letter_Box_In(1.0)
	Sleep(1.5)

	MissionUtil.CinematicIntroHeader("LAUGHING_LANCE")

	player_dhc.Teleport_And_Face(intro_dhc_1_marker)
	player_dhc.Cinematic_Hyperspace_In(150)
	Sleep(8.5)

	Fade_Screen_In(0.01)
	MissionUtil.MissionTextSpeech("LAUGHING_LANCE", 1, 7.5, nil, {r = 250, g = 44, b = 44}) -- Cpt. Hunt

	player_dhc.Despawn()
	player_dhc = Find_Hint("PDF_DHC", "2")
	player_dhc.Teleport_And_Face(intro_dhc_1_marker)
	player_dhc.Override_Max_Speed(1.5)
	player_dhc.Move_To(intro_dhc_2_marker)

	MissionUtil.SetCinematicCamera(introcam_4_marker, player_dhc, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_5_marker, player_dhc, true, 14.0, nil, nil)
	Sleep(9.5)

	MissionUtil.SetCinematicCamera(introcam_6_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_7_marker, introcam_target_3_marker, true, 10.0, nil, nil)

	MissionUtil.MissionTextSpeech("LAUGHING_LANCE", 2, 8.0, nil, {r = 250, g = 44, b = 44}) -- Sgt. Va'ari
	Sleep(8.5)

	MissionUtil.SetCinematicCamera(introcam_8_marker, player_dhc, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_9_marker, player_dhc, true, 19.0, nil, nil)

	MissionUtil.MissionTextSpeech("LAUGHING_LANCE", 3, 15.0, nil, {r = 250, g = 44, b = 44}) -- Cpt. Hunt
	MissionUtil.MissionTextSpeech("LAUGHING_LANCE", 4, 15.0, nil, {r = 250, g = 44, b = 44}) -- Cpt. Hunt
	Sleep(16.0)

	MissionUtil.SetCinematicCamera(introcam_11_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_13_marker, introcam_target_3_marker, true, 19.0, nil, nil)

	MissionUtil.MissionTextSpeech("LAUGHING_LANCE", 5, 14.0, nil, {r = 250, g = 44, b = 44}) -- Sgt. Va'ari
	MissionUtil.MissionTextSpeech("LAUGHING_LANCE", 6, 14.0, nil, {r = 250, g = 44, b = 44}) -- Sgt. Va'ari
	Sleep(15.0)

	MissionUtil.PlayGenericMusic("TCW_Luminara_Theme")

	MissionUtil.SetCinematicCamera(introcam_13_marker, player_dhc, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_12_marker, player_dhc, true, 8.5, nil, nil)

	MissionUtil.MissionTextSpeech("LAUGHING_LANCE", 7, 8.0, nil, {r = 250, g = 44, b = 44}) -- Cpt. Hunt
	Sleep(8.5)

	MissionUtil.SetCinematicCamera(introcam_14_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_15_marker, introcam_target_3_marker, true, 8.0, nil, nil)

	MissionUtil.MissionTextSpeech("LAUGHING_LANCE", 8, 11.3, nil, {r = 250, g = 44, b = 44}) -- Sgt. Va'ari
	Sleep(5.5)

	cis_list = Find_All_Objects_Of_Type(p_cis)
	for j,cis_stuff in pairs(cis_list) do
		if TestValid(cis_stuff) then
			Hide_Object(cis_stuff, 0)
		end
	end

	MissionUtil.Set_To_Enemies(p_cis, p_republic)

	MissionUtil.SetCinematicCamera(introcam_16_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_17_marker, introcam_target_4_marker, true, 8.5, nil, nil)

	MissionUtil.MissionTextSpeech("LAUGHING_LANCE", 9, 6.6, nil, {r = 250, g = 44, b = 44}) -- Sgt. Va'ari
	Sleep(4.0)

	player_grievous.Teleport_And_Face(intro_grievous_marker)
	player_grievous.Cinematic_Hyperspace_In(50)

	player_munificent.Teleport_And_Face(intro_cis_fleet_1_marker)
	player_munificent.Cinematic_Hyperspace_In(100)

	player_recusant.Teleport_And_Face(intro_cis_fleet_2_marker)
	player_recusant.Cinematic_Hyperspace_In(50)

	player_recusant_d.Teleport_And_Face(intro_cis_fleet_3_marker)
	player_recusant_d.Cinematic_Hyperspace_In(100)

	player_providence_d.Teleport_And_Face(intro_cis_fleet_4_marker)
	player_providence_d.Cinematic_Hyperspace_In(150)

	player_lucrehulk.Teleport_And_Face(intro_cis_fleet_5_marker)
	player_lucrehulk.Cinematic_Hyperspace_In(100)

	player_core_d.Teleport_And_Face(intro_cis_fleet_6_marker)
	player_core_d.Cinematic_Hyperspace_In(150)

	player_supplier.Teleport_And_Face(intro_cis_fleet_7_marker)
	player_supplier.Cinematic_Hyperspace_In(100)

	MissionUtil.PlayGenericMusic("Grievous_Theme")
	Sleep(4.5)

	MissionUtil.SetCinematicCamera(introcam_18_marker, introcam_target_4_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_19_marker, introcam_target_4_marker, true, 17.0, nil, nil)

	MissionUtil.MissionTextSpeech("LAUGHING_LANCE", 10, 8.0, nil, {r = 245, g = 243, b = 82}) -- General Grievous
	Sleep(9.0)

	MissionUtil.MissionTextSpeech("LAUGHING_LANCE", 11, 7.0, nil, {r = 245, g = 243, b = 82}) -- Lushros Dofine
	Sleep(7.8)

	MissionUtil.SetCinematicCamera(introcam_20_marker, player_grievous, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_21_marker, player_grievous, true, 23.0, nil, nil)

	MissionUtil.MissionTextSpeech("LAUGHING_LANCE", 12, 15.0, nil, {r = 245, g = 243, b = 82}) -- General Grievous
	MissionUtil.MissionTextSpeech("LAUGHING_LANCE", 13, 15.0, nil, {r = 245, g = 243, b = 82}) -- General Grievous
	Sleep(4.0)

	Fade_Screen_Out(8.0)
	Sleep(9.0)

	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.AIActivation()
	StoryUtil.DeclareVictory(p_cis, false)
end

function Start_Cinematic_Crawl_Rep()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true)

	cinematic_crawl = true
	MissionUtil.PlayCinematicMovieCrawl("Durges_Lance_Campaign_Intro", "Clone_Wars_Crawl_Theme")

	if not cinematic_crawl_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
	end
end
function Start_Cinematic_Intro_Rep()
	cinematic_crawl = false

	Find_First_Object("GRIEVOUS_MALEVOLENCE").Despawn()
	player_grievous = Find_First_Object("GRIEVOUS_INVISIBLE_HAND")

	cinematic_one = true

	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, true, 8.0, nil, nil)

	MissionUtil.PlayGenericMusic("ESB_The_Ice_Planet_Hoth")
	Letter_Box_In(1.0)
	Sleep(1.5)

	MissionUtil.CinematicIntroHeader("LAUGHING_LANCE")

	player_dhc.Teleport_And_Face(intro_dhc_1_marker)
	player_dhc.Cinematic_Hyperspace_In(150)
	Sleep(8.5)

	Fade_Screen_In(0.01)
	MissionUtil.MissionTextSpeech("LAUGHING_LANCE", 1, 7.5, nil, {r = 250, g = 44, b = 44}) -- Cpt. Hunt

	player_dhc.Despawn()
	player_dhc = Find_Hint("PDF_DHC", "2")
	player_dhc.Teleport_And_Face(intro_dhc_1_marker)
	player_dhc.Override_Max_Speed(1.5)
	player_dhc.Move_To(intro_dhc_2_marker)

	MissionUtil.SetCinematicCamera(introcam_4_marker, player_dhc, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_5_marker, player_dhc, true, 14.0, nil, nil)
	Sleep(9.5)

	MissionUtil.SetCinematicCamera(introcam_6_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_7_marker, introcam_target_3_marker, true, 10.0, nil, nil)

	MissionUtil.MissionTextSpeech("LAUGHING_LANCE", 2, 8.0, nil, {r = 250, g = 44, b = 44}) -- Sgt. Va'ari
	Sleep(8.5)

	MissionUtil.SetCinematicCamera(introcam_8_marker, player_dhc, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_9_marker, player_dhc, true, 19.0, nil, nil)

	MissionUtil.MissionTextSpeech("LAUGHING_LANCE", 3, 15.0, nil, {r = 250, g = 44, b = 44}) -- Cpt. Hunt
	MissionUtil.MissionTextSpeech("LAUGHING_LANCE", 4, 15.0, nil, {r = 250, g = 44, b = 44}) -- Cpt. Hunt
	Sleep(16.0)

	MissionUtil.SetCinematicCamera(introcam_11_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_13_marker, introcam_target_3_marker, true, 19.0, nil, nil)

	MissionUtil.MissionTextSpeech("LAUGHING_LANCE", 5, 14.0, nil, {r = 250, g = 44, b = 44}) -- Sgt. Va'ari
	MissionUtil.MissionTextSpeech("LAUGHING_LANCE", 6, 14.0, nil, {r = 250, g = 44, b = 44}) -- Sgt. Va'ari
	Sleep(15.0)

	MissionUtil.PlayGenericMusic("TCW_Luminara_Theme")

	MissionUtil.SetCinematicCamera(introcam_13_marker, player_dhc, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_12_marker, player_dhc, true, 8.5, nil, nil)

	MissionUtil.MissionTextSpeech("LAUGHING_LANCE", 7, 8.0, nil, {r = 250, g = 44, b = 44}) -- Cpt. Hunt
	Sleep(8.5)

	MissionUtil.SetCinematicCamera(introcam_14_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_15_marker, introcam_target_3_marker, true, 8.0, nil, nil)

	MissionUtil.MissionTextSpeech("LAUGHING_LANCE", 8, 11.3, nil, {r = 250, g = 44, b = 44}) -- Sgt. Va'ari
	Sleep(5.5)

	cis_list = Find_All_Objects_Of_Type(p_cis)
	for j,cis_stuff in pairs(cis_list) do
		if TestValid(cis_stuff) then
			Hide_Object(cis_stuff, 0)
		end
	end

	MissionUtil.Set_To_Enemies(p_cis, p_republic)

	MissionUtil.SetCinematicCamera(introcam_16_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_17_marker, introcam_target_4_marker, true, 8.5, nil, nil)

	MissionUtil.MissionTextSpeech("LAUGHING_LANCE", 9, 6.6, nil, {r = 250, g = 44, b = 44}) -- Sgt. Va'ari
	Sleep(4.0)

	player_grievous.Teleport_And_Face(intro_grievous_marker)
	player_grievous.Cinematic_Hyperspace_In(50)

	player_munificent.Teleport_And_Face(intro_cis_fleet_1_marker)
	player_munificent.Cinematic_Hyperspace_In(100)

	player_recusant.Teleport_And_Face(intro_cis_fleet_2_marker)
	player_recusant.Cinematic_Hyperspace_In(50)

	player_recusant_d.Teleport_And_Face(intro_cis_fleet_3_marker)
	player_recusant_d.Cinematic_Hyperspace_In(100)

	player_providence_d.Teleport_And_Face(intro_cis_fleet_4_marker)
	player_providence_d.Cinematic_Hyperspace_In(150)

	player_lucrehulk.Teleport_And_Face(intro_cis_fleet_5_marker)
	player_lucrehulk.Cinematic_Hyperspace_In(100)

	player_core_d.Teleport_And_Face(intro_cis_fleet_6_marker)
	player_core_d.Cinematic_Hyperspace_In(150)

	player_supplier.Teleport_And_Face(intro_cis_fleet_7_marker)
	player_supplier.Cinematic_Hyperspace_In(100)

	MissionUtil.PlayGenericMusic("Grievous_Theme")
	Sleep(4.5)

	MissionUtil.SetCinematicCamera(introcam_18_marker, introcam_target_4_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_19_marker, introcam_target_4_marker, true, 17.0, nil, nil)

	MissionUtil.MissionTextSpeech("LAUGHING_LANCE", 10, 8.0, nil, {r = 245, g = 243, b = 82}) -- General Grievous
	Sleep(9.0)

	MissionUtil.MissionTextSpeech("LAUGHING_LANCE", 11, 7.0, nil, {r = 245, g = 243, b = 82}) -- Lushros Dofine
	Sleep(7.8)

	MissionUtil.SetCinematicCamera(introcam_20_marker, player_grievous, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_21_marker, player_grievous, true, 23.0, nil, nil)

	MissionUtil.MissionTextSpeech("LAUGHING_LANCE", 12, 15.0, nil, {r = 245, g = 243, b = 82}) -- General Grievous
	MissionUtil.MissionTextSpeech("LAUGHING_LANCE", 13, 15.0, nil, {r = 245, g = 243, b = 82}) -- General Grievous
	Sleep(4.0)

	Fade_Screen_Out(8.0)
	Sleep(9.0)

	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.AIActivation()
	StoryUtil.DeclareVictory(p_republic, false)
end
