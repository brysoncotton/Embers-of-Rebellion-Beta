
--*****************************************************--
--********* Foerost Campaign: Foerost Fallen **********--
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
	p_hostile = Find_Player("Hostile")

	mission_started = false

	cinematic_crawl = false
	act_1_active = false

	treetor_dead = false

	cinematic_one = false
	cinematic_crawl_skipped = false
	cinematic_one_skipped = false

	current_cinematic_thread_id = nil
end
function Begin_Battle(message)
	if message == OnEnter then
		MissionUtil.VictoryAllowance(false)
		MissionUtil.DisableRetreat("EMPIRE", true)
		MissionUtil.Set_To_Allies(p_republic, p_cis)

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

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")

		intro_praetor_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-praetor")
--		intro_tagge_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-tagge")
--		intro_invincible_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-invincible")

		player_treetor = Find_First_Object("TREETOR_CAPTOR")
		player_treetor.Set_Cannot_Be_Killed(true)

		mission_started = true

		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Crawl_Rep")
	end
end

function Story_Handle_Esc()
	if p_republic.Is_Human() then
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

				if not TestValid(player_praetor_01) then
					player_praetor_01 = MissionUtil.SpawnUnitSpace("PRAETOR_I_BATTLECRUISER", intro_praetor_marker, p_republic)
				end

				for k,player_container in pairs(Find_All_Objects_Of_Type("ORBITAL_RESOURCE_CONTAINER")) do
					if TestValid(player_container) then
						player_container.Change_Owner(p_hostile)
					end
				end

				MissionUtil.SetObjectiveMissionSet("FOEROST_FALLEN", "REP", 2)
				Fade_Screen_Out(0)
				Stop_All_Music()
				Stop_All_Speech()
				Remove_All_Text()
				Stop_Bink_Movie()

				MissionUtil.CinematicEnvironmentOff()
				Resume_Mode_Based_Music()

				if intro_praetor_marker ~= nil then
					Point_Camera_At(intro_praetor_marker)
				end
				Transition_To_Tactical_Camera(1)
				Letter_Box_Out(1)
				Suspend_AI(0)
				Lock_Controls(0)
				End_Cinematic_Camera()
				MissionUtil.Set_To_Enemies(p_republic, p_cis)
				MissionUtil.VictoryAllowance(true)

				cinematic_one = false
				act_1_active = true

				--StoryUtil.DeclareVictory(p_republic, false)

				Fade_Screen_In(0.5)
			end
		end
	end
end
function Story_Mode_Service()
	if p_republic.Is_Human() then
		if not treetor_dead then
			if Find_First_Object("TREETOR_CAPTOR").Get_Hull() <= 0.10 then
				Find_First_Object("TREETOR_CAPTOR").Hyperspace_Away(true)
				MissionUtil.MissionTextSpeech("FOEROST_FALLEN", 11, 10.0, nil, {r = 245, g = 243, b = 82}) -- Domb Treetor
				Sleep(5.0)
				if TestValid(Find_First_Object("TREETOR_CAPTOR")) then
					Find_First_Object("TREETOR_CAPTOR").Despawn()
					treetor_dead = true
				end
			end
		end
	end
end

function Start_Cinematic_Crawl_Rep()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true)

	cinematic_crawl = true
	MissionUtil.PlayCinematicMovieCrawl("Foerost_Campaign_Rep_Intro", "Clone_Wars_Crawl_Theme")
	MissionUtil.CinematicEnvironmentOff()

	if not cinematic_crawl_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
	end
end
function Start_Cinematic_Intro_Rep()
	cinematic_crawl = false
	cinematic_one = true

	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, true, 22.0, nil, nil)
	Letter_Box_In(1.0)

	MissionUtil.CinematicIntroHeader("FOEROST_FALLEN")
	MissionUtil.PlayGenericMusic("Clone_Army_Theme")
	Sleep(3.0)
	
	for k,player_acc in pairs(Find_All_Objects_Of_Type(p_republic, "ACCLAMATOR_I_ASSAULT")) do
		if TestValid(player_acc) then
			player_acc.Cinematic_Hyperspace_In(60)
		end
	end
	for k,player_lac in pairs(Find_All_Objects_Of_Type(p_republic, "LAC")) do
		if TestValid(player_lac) then
			player_lac.Cinematic_Hyperspace_In(75)
		end
	end
	for k,player_starbolt in pairs(Find_All_Objects_Of_Type(p_republic, "STARBOLT")) do
		if TestValid(player_starbolt) then
			player_starbolt.Cinematic_Hyperspace_In(65)
		end
	end
	for k,player_galleon in pairs(Find_All_Objects_Of_Type(p_republic, "GALLEON")) do
		if TestValid(player_galleon) then
			player_galleon.Cinematic_Hyperspace_In(70)
		end
	end
	for k,player_tagge in pairs(Find_All_Objects_Of_Type(p_republic, "TAGGE_BATTLECRUISER")) do
		if TestValid(player_tagge) then
			player_tagge.Cinematic_Hyperspace_In(100)
		end
	end

	Sleep(8.0)

	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, true, 11.0, nil, nil)

	player_praetor_01 = MissionUtil.SpawnUnitSpace("PRAETOR_I_BATTLECRUISER", intro_praetor_marker, p_republic, 100)
	Sleep(3.0)
	
	MissionUtil.MissionTextSpeech("FOEROST_FALLEN", 1, 6.5, nil, {r = 250, g = 44, b = 44}) -- Captain Mayn
	Sleep(7.5)

	MissionUtil.MissionTextSpeech("FOEROST_FALLEN", 2, 10.5, nil, {r = 250, g = 44, b = 44}) -- Captain Mayn
	MissionUtil.MissionTextSpeech("FOEROST_FALLEN", 3, 10.5, nil, {r = 250, g = 44, b = 44}) -- Captain Mayn
	Sleep(2.0)

	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_2_marker, true, 13.5, nil, nil)
	Sleep(10.0)

	MissionUtil.MissionTextSpeech("FOEROST_FALLEN", 4, 11.5, nil, {r = 250, g = 44, b = 44}) -- Captain Mayn
	MissionUtil.MissionTextSpeech("FOEROST_FALLEN", 5, 11.5, nil, {r = 250, g = 44, b = 44}) -- Captain Mayn
	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_3_marker, true, 16.5, nil, nil)
	Sleep(12.5)

	MissionUtil.MissionTextSpeech("FOEROST_FALLEN", 6, 6.5, nil, {r = 250, g = 44, b = 44}) -- Captain Mayn
	Sleep(7.5)

	MissionUtil.MissionTextSpeech("FOEROST_FALLEN", 7, 9.5, nil, {r = 245, g = 243, b = 82}) -- Domb Treetor
	MissionUtil.MissionTextSpeech("FOEROST_FALLEN", 8, 9.5, nil, {r = 245, g = 243, b = 82}) -- Domb Treetor
	MissionUtil.SetCinematicCamera(introcam_7_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_8_marker, introcam_target_3_marker, true, 13.5, nil, nil)
	Sleep(10.5)

	MissionUtil.MissionTextSpeech("FOEROST_FALLEN", 9, 11.5, nil, {r = 250, g = 44, b = 44}) -- Captain Mayn
	MissionUtil.MissionTextSpeech("FOEROST_FALLEN", 10, 11.5, nil, {r = 250, g = 44, b = 44}) -- Captain Mayn
	MissionUtil.SetCinematicCamera(introcam_9_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_10_marker, introcam_target_2_marker, true, 15.5, nil, nil)
	Sleep(10.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Rep")
	end
end
function End_Cinematic_Intro_Rep()
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(player_praetor_01, 3.5)
	Sleep(3.5)

	MissionUtil.Set_To_Enemies(p_republic, p_cis)

	MissionUtil.SetObjectiveMissionSet("FOEROST_FALLEN", "REP", 2)
	MissionUtil.VictoryAllowance(true)

	current_cinematic_thread_id = nil

	cinematic_one = false
	act_1_active = true

	Sleep(10.0)
	for k,player_container in pairs(Find_All_Objects_Of_Type("ORBITAL_RESOURCE_CONTAINER")) do
		if TestValid(player_container) then
			player_container.Change_Owner(p_hostile)
		end
	end
end
