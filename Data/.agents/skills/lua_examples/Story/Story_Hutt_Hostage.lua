
--*****************************************************--
--*************** Rimward: Hutt Hostage ***************--
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

	p_hostile = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_hutts = Find_Player("Hutt_Cartels")
	p_neutral = Find_Player("Neutral")

	act_1_active = false

	cinematic_one = false
	cinematic_two = false

	cinematic_one_skipped = false
	cinematic_two_skipped = false

	defenders_spawned = false

	mission_started = false
end
function Begin_Battle(message)
	if message == OnEnter then

		MissionUtil.VictoryAllowance(false)

		MissionUtil.DisableRetreat("REBEL", true)
		MissionUtil.DisableRetreat("EMPIRE", true)
		MissionUtil.DisableRetreat("HUTT_CARTELS", true)

		p_hostile.Make_Ally(p_hutts)
		p_hutts.Make_Ally(p_hostile)

		crawl_cam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawl-cam-1")
		Promote_To_Space_Cinematic_Layer(crawl_cam_1_marker)

		crawl_cam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawl-cam-target-0")
		Promote_To_Space_Cinematic_Layer(crawl_cam_target_1_marker)

		crawl_cam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawl-cam-2")
		crawl_cam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawl-cam-3")
		crawl_cam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawl-cam-target-2")

		introcam_0_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-0")
		introcam_target_0_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-0")

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

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")
		introcam_target_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-4")
		introcam_target_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-5")
		introcam_target_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-6")

		outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-1")
		outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-2")

		outrocam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-1")

		extraction_point_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "extraction-point")
		Register_Prox(extraction_point_marker, Prox_Extraction_Point_Reached, 300, p_hutts)

		lander_rm09_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lander-rm09-1")
		lander_rm09_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lander-rm09-2")

		lander_kappa_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lander-kappa-1")
		lander_kappa_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lander-kappa-2")

		lander_gozanti_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lander-gozanti-1")
		lander_gozanti_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lander-gozanti-2")

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

		riot_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "riot-1")
		riot_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "riot-2")
		riot_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "riot-3")
		riot_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "riot-4")
		riot_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "riot-5")
		riot_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "riot-6")
		riot_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "riot-7")
		riot_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "riot-8")
		riot_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "riot-9")
		riot_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "riot-10")
		riot_11_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "riot-11")
		riot_12_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "riot-12")
		riot_13_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "riot-13")

		face_direction_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "face-direction-1")
		face_direction_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "face-direction-2")
		face_direction_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "face-direction-3")
		face_direction_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "face-direction-4")
		face_direction_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "face-direction-5")
		face_direction_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "face-direction-6")
		face_direction_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "face-direction-7")
		face_direction_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "face-direction-8")
		face_direction_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "face-direction-9")
		face_direction_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "face-direction-10")
		face_direction_11_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "face-direction-11")
		face_direction_12_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "face-direction-12")
		face_direction_13_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "face-direction-13")
		face_direction_14_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "face-direction-14")
		face_direction_15_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "face-direction-15")

		GlobalValue.Set("Rimward_Hutt_Hostage_Outcome_Bossk", 0) -- 0 = Survived; 1 = Died
		GlobalValue.Set("Rimward_Hutt_Hostage_Outcome_Dengar", 0) -- 0 = Survived; 1 = Died
		GlobalValue.Set("Rimward_Hutt_Hostage_Outcome_Shahan", 0) -- 0 = Survived; 1 = Died

		player_jayfon_senior = Find_First_Object("JAYFON_SENIOR")
		Register_Death_Event(player_jayfon_senior, State_Villain_Death)

		player_jesra = Find_First_Object("JESRA_LOTURE")

		player_ziro = Find_First_Object("ZIRO_THE_HUTT")
		Register_Death_Event(player_ziro, State_Hero_Death)
		FogOfWar.Reveal(p_hutts, player_ziro, 900)

		player_bossk = Find_First_Object("BOSSK")
		Register_Death_Event(player_bossk, State_Hero_Death)

		player_dengar = Find_First_Object("DENGAR")
		Register_Death_Event(player_dengar, State_Hero_Death)

		player_shahan = Find_First_Object("SHAHAN_ALAMA")
		Register_Death_Event(player_shahan, State_Hero_Death)

		Set_Cinematic_Environment(true)
		GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 0)

		mission_started = true
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Crawl_Hutts")
	end
end

function State_Hero_Death()
	if not TestValid(player_ziro) then
		MissionUtil.SetMissionObjectiveFailed("HUTT_HOSTAGE", "HUTTS", 2)
		StoryUtil.TriggerScriptedBattle("HUTT_HOSTAGE", "FLORRUM", "LAND", "HUTT_CARTELS", "EMPIRE", false)
		StoryUtil.DeclareVictory(p_republic, false)
	end
	if not TestValid(player_bossk) then
		MissionUtil.SetMissionObjectiveFailed("HUTT_HOSTAGE", "HUTTS", 3)
		GlobalValue.Set("Rimward_Hutt_Hostage_Outcome_Bossk", 1) -- 0 = Survived; 1 = Died
	end
	if not TestValid(player_dengar) then
		MissionUtil.SetMissionObjectiveFailed("HUTT_HOSTAGE", "HUTTS", 4)
		GlobalValue.Set("Rimward_Hutt_Hostage_Outcome_Dengar", 1) -- 0 = Survived; 1 = Died
	end
	if not TestValid(player_shahan) then
		MissionUtil.SetMissionObjectiveFailed("HUTT_HOSTAGE", "HUTTS", 5)
		GlobalValue.Set("Rimward_Hutt_Hostage_Outcome_Shahan", 1) -- 0 = Survived; 1 = Died
	end
end
function State_Villain_Death()
	if not TestValid(player_jayfon_senior) then
		MissionUtil.SetMissionObjectiveComplete("HUTT_HOSTAGE", "HUTTS", 6)
		p_hutts.Give_Money(7000)
	end
end

function State_Riot_Spawner()
	Sleep(5.0)
	MissionUtil.SpawnListSpawner("X34_TECHNICAL_COMPANY", riot_1_marker, p_hostile, 1)
	Sleep(1.0)
	MissionUtil.SpawnListSpawner("MIXED_CIVILIANS_TEAM_HUTTS", riot_2_marker, p_hostile, 2)
	Sleep(1.0)
	MissionUtil.SpawnListSpawner("MERCENARY_COMPANY", riot_3_marker, p_hostile, 1)
	Sleep(1.0)
	MissionUtil.SpawnListSpawner("HUTT_AIRHOOK_COMPANY", riot_5_marker, p_hostile, 1)
	Sleep(1.0)
	MissionUtil.SpawnListSpawner("HUTT_GUARD_COMPANY", riot_6_marker, p_hostile, 1)
end
function State_Senate_Spawner()
	MissionUtil.SpawnListSpawner("RIOT_PERSUADER_COMPANY", rep_5_marker, p_republic, 1)
	Sleep(1.0)
	MissionUtil.SpawnListSpawner("ESPO_WALKER_91_COMPANY", rep_6_marker, p_republic, 1)
	Sleep(1.0)
	MissionUtil.SpawnListSpawner("RIOT_HAILFIRE_COMPANY", rep_10_marker, p_republic, 1)
end

function Prox_Extraction_Point_Reached(self_obj, trigger_obj)
	if trigger_obj == player_ziro then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Hutts")
		self_obj.Cancel_Event_Object_In_Range(Prox_Extraction_Point_Reached)
	end
end

function Story_Handle_Esc()
	if p_hutts.Is_Human() then
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

				Set_Cinematic_Environment(false)
				Weather_Audio_Pause(false)
				Allow_Localized_SFX(true)
				Enable_Fog(true)

				cinematic_crawl = false
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Hutts")
			end
		end
		if cinematic_one then
			if not cinematic_one_skipped then
				cinematic_one_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				shock_marker_list = Find_All_Objects_With_Hint("shock-squad")
				for i,shock_marker in pairs(shock_marker_list) do
					MissionUtil.SpawnListSpawner("SHOCK_CLONETROOPER_PHASE_ONE_SQUAD", shock_marker, p_republic, 1)
				end

				Create_Thread("State_Riot_Spawner")

				if defenders_spawned == false then
					Create_Thread("State_Senate_Spawner")
				end

				MissionUtil.MissionTextSpeech("HUTT_HOSTAGE", 20, 8.5, nil, {r = 247, g = 201, b = 13})

				Add_Radar_Blip(extraction_point_marker, "extraction_point_blip")
				extraction_point_marker.Highlight(true)

				local attention_1_list = Find_All_Objects_With_Hint("1")
				for i,attention_1_unit in pairs(attention_1_list) do
					attention_1_unit.Despawn()
				end

				local attention_2_list = Find_All_Objects_With_Hint("2")
				for i,attention_2_unit in pairs(attention_2_list) do
					attention_2_unit.Despawn()
				end

				local attention_3_list = Find_All_Objects_With_Hint("3")
				for i,attention_3_unit in pairs(attention_3_list) do
					attention_3_unit.Despawn()
				end

				local attention_4_list = Find_All_Objects_With_Hint("4")
				for i,attention_4_unit in pairs(attention_4_list) do
					attention_4_unit.Despawn()
				end

				local attention_5_list = Find_All_Objects_With_Hint("5")
				for i,attention_5_unit in pairs(attention_5_list) do
					attention_5_unit.Despawn()
				end

				local attention_6_list = Find_All_Objects_With_Hint("6")
				for i,attention_6_unit in pairs(attention_6_list) do
					attention_6_unit.Despawn()
				end

				local attention_7_list = Find_All_Objects_With_Hint("7")
				for i,attention_7_unit in pairs(attention_7_list) do
					attention_7_unit.Despawn()
				end

				local attention_8_list = Find_All_Objects_With_Hint("8")
				for i,attention_8_unit in pairs(attention_8_list) do
					attention_8_unit.Despawn()
				end

				local attention_9_list = Find_All_Objects_With_Hint("9")
				for i,attention_9_unit in pairs(attention_9_list) do
					attention_9_unit.Despawn()
				end

				local attention_10_list = Find_All_Objects_With_Hint("10")
				for i,attention_10_unit in pairs(attention_10_list) do
					attention_10_unit.Despawn()
				end

				local attention_11_list = Find_All_Objects_With_Hint("11")
				for i,attention_11_unit in pairs(attention_11_list) do
					attention_11_unit.Despawn()
				end

				local attention_12_list = Find_All_Objects_With_Hint("12")
				for i,attention_12_unit in pairs(attention_12_list) do
					attention_12_unit.Despawn()
				end

				local attention_13_list = Find_All_Objects_With_Hint("13")
				for i,attention_13_unit in pairs(attention_13_list) do
					attention_13_unit.Despawn()
				end

				local attention_14_list = Find_All_Objects_With_Hint("14")
				for i,attention_14_unit in pairs(attention_14_list) do
					attention_14_unit.Despawn()
				end

				local attention_15_list = Find_All_Objects_With_Hint("15")
				for i,attention_15_unit in pairs(attention_15_list) do
					attention_15_unit.Despawn()
				end

				MissionUtil.SetObjectiveMissionSet("HUTT_HOSTAGE", "HUTTS", 6)
				MissionUtil.CinematicSkippingCleanUp(player_ziro)

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

				MissionUtil.DisableRetreat("REBEL", false)
				MissionUtil.DisableRetreat("EMPIRE", false)
				MissionUtil.DisableRetreat("HUTT_CARTELS", false)

				MissionUtil.CinematicSkippingCleanUp(nil)

				StoryUtil.DeclareVictory(p_republic, false)
			end
		end
	end
end
function Story_Mode_Service()
	if p_hutts.Is_Human() then
		if act_1_active then
		end
	end
end

function Start_Cinematic_Crawl_Hutts()

	Weather_Audio_Pause(true)
	Start_Cinematic_Camera(false)
	Allow_Localized_SFX(false)
	Enable_Fog(false)

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()
	Set_New_Environment(2)

	cinematic_skydome = MissionUtil.SpawnUnitGround("Space_Stars", crawl_cam_1_marker, p_hutts)
	cinematic_skydome.Teleport_And_Face(crawl_cam_1_marker)

	cinematic_crawl = true
	MissionUtil.SetCinematicCamera(crawl_cam_1_marker, crawl_cam_target_1_marker, true, nil, nil)

	MissionUtil.PlayCinematicMovieCrawl("Rimward_Campaign_Hutts_Intro", "Clone_Wars_Crawl_Theme")
	Fade_On()

	Set_Cinematic_Environment(false)
	Weather_Audio_Pause(false)
	Allow_Localized_SFX(true)
	Enable_Fog(true)

	if not cinematic_crawl_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Hutts")
	end
end
function Start_Cinematic_Intro_Hutts()
	MissionUtil.TransitionCinematicCamera(introcam_10_marker, crawl_cam_target_1_marker, true, 6.0, nil, nil)
	Set_New_Environment(1)
	Letter_Box_In(1.0)

	Weather_Audio_Pause(false)
	SFXManager.Allow_Localized_SFXEvents(false)	

	cinematic_crawl = false
	cinematic_one = true

	MissionUtil.CinematicIntroHeader("HUTT_HOSTAGE")
	MissionUtil.PlayGenericMusic("CW_ARC_Trooper_Theme")
	Sleep(1.0)

	MissionUtil.SetCinematicCamera(introcam_0_marker, introcam_target_0_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_10_marker, introcam_target_2_marker, true, 10.0, nil, nil)
	Fade_Screen_In(0.1)

	local republic_list = Find_All_Objects_Of_Type(p_republic, "Infantry")
	for i,republic_unit in pairs(republic_list) do
		MissionUtil.PlayAnimation(republic_unit, "Attention", true, 0)
	end

	local attention_1_list = Find_All_Objects_With_Hint("1")
	for i,attention_1_unit in pairs(attention_1_list) do
		attention_1_unit.Turn_To_Face(face_direction_1_marker)
	end

	local attention_2_list = Find_All_Objects_With_Hint("2")
	for i,attention_2_unit in pairs(attention_2_list) do
		attention_2_unit.Turn_To_Face(face_direction_2_marker)
	end

	local attention_3_list = Find_All_Objects_With_Hint("3")
	for i,attention_3_unit in pairs(attention_3_list) do
		attention_3_unit.Turn_To_Face(face_direction_3_marker)
	end

	local attention_4_list = Find_All_Objects_With_Hint("4")
	for i,attention_4_unit in pairs(attention_4_list) do
		attention_4_unit.Turn_To_Face(face_direction_4_marker)
	end

	local attention_5_list = Find_All_Objects_With_Hint("5")
	for i,attention_5_unit in pairs(attention_5_list) do
		attention_5_unit.Turn_To_Face(face_direction_5_marker)
	end

	local attention_6_list = Find_All_Objects_With_Hint("6")
	for i,attention_6_unit in pairs(attention_6_list) do
		attention_6_unit.Turn_To_Face(face_direction_6_marker)
	end

	local attention_7_list = Find_All_Objects_With_Hint("7")
	for i,attention_7_unit in pairs(attention_7_list) do
		attention_7_unit.Turn_To_Face(face_direction_7_marker)
	end

	local attention_8_list = Find_All_Objects_With_Hint("8")
	for i,attention_8_unit in pairs(attention_8_list) do
		attention_8_unit.Turn_To_Face(face_direction_8_marker)
	end

	local attention_9_list = Find_All_Objects_With_Hint("9")
	for i,attention_9_unit in pairs(attention_9_list) do
		attention_9_unit.Turn_To_Face(face_direction_9_marker)
	end

	local attention_10_list = Find_All_Objects_With_Hint("10")
	for i,attention_10_unit in pairs(attention_10_list) do
		attention_10_unit.Turn_To_Face(face_direction_10_marker)
	end

	local attention_11_list = Find_All_Objects_With_Hint("11")
	for i,attention_11_unit in pairs(attention_11_list) do
		attention_11_unit.Turn_To_Face(face_direction_11_marker)
	end

	local attention_12_list = Find_All_Objects_With_Hint("12")
	for i,attention_12_unit in pairs(attention_12_list) do
		attention_12_unit.Turn_To_Face(face_direction_12_marker)
	end

	local attention_13_list = Find_All_Objects_With_Hint("13")
	for i,attention_13_unit in pairs(attention_13_list) do
		attention_13_unit.Turn_To_Face(face_direction_13_marker)
	end

	local attention_14_list = Find_All_Objects_With_Hint("14")
	for i,attention_14_unit in pairs(attention_14_list) do
		attention_14_unit.Turn_To_Face(face_direction_14_marker)
	end

	local attention_15_list = Find_All_Objects_With_Hint("15")
	for i,attention_15_unit in pairs(attention_15_list) do
		attention_15_unit.Turn_To_Face(face_direction_15_marker)
	end

	MissionUtil.PlayAnimation(player_jesra, "Attention", true, 0)
	MissionUtil.PlayAnimation(player_jayfon_senior, "Talk_Gesture", false, 0)

	Sleep(5.0)

	player_jayfon_senior.Turn_To_Face(player_jesra)
	Sleep(5.0)

	MissionUtil.PlayAnimation(player_jayfon_senior, "Talk_Gesture", true, 0)

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, false, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_1_marker, false, 8.5, nil, nil)
	MissionUtil.MissionTextSpeech("HUTT_HOSTAGE", 1, 8.0, nil, {r = 90, g = 206, b = 234})
	MissionUtil.MissionTextSpeech("HUTT_HOSTAGE", 2, 8.0, nil, {r = 90, g = 206, b = 234})
	Sleep(9.0)

	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_2_marker, true, 9.0, nil, nil)
	MissionUtil.MissionTextSpeech("HUTT_HOSTAGE", 3, 7.5, nil, {r = 90, g = 206, b = 234})
	MissionUtil.MissionTextSpeech("HUTT_HOSTAGE", 4, 7.5, nil, {r = 90, g = 206, b = 234})
	Sleep(8.5)

	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_3_marker, true, 9.0, nil, nil)
	MissionUtil.MissionTextSpeech("HUTT_HOSTAGE", 5, 8.0, nil, {r = 90, g = 206, b = 234})
	MissionUtil.MissionTextSpeech("HUTT_HOSTAGE", 6, 8.0, nil, {r = 90, g = 206, b = 234})
	Sleep(9.0)

	MissionUtil.SetCinematicCamera(introcam_7_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_8_marker, introcam_target_2_marker, true, 10.5, nil, nil)
	MissionUtil.MissionTextSpeech("HUTT_HOSTAGE", 7, 10.0, nil, {r = 90, g = 206, b = 234})
	MissionUtil.MissionTextSpeech("HUTT_HOSTAGE", 8, 10.0, nil, {r = 90, g = 206, b = 234})
	Sleep(6.5)
	
	MissionUtil.SetCinematicCamera(introcam_9_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_10_marker, introcam_target_2_marker, true, 8.0, nil, nil)
	local republic_list = Find_All_Objects_Of_Type(p_republic, "Infantry")
	for i,republic_unit in pairs(republic_list) do
		MissionUtil.PlayAnimation(republic_unit, "Celebrate", true, 0)
	end

	Sleep(4.0)
	MissionUtil.MissionTextSpeech("HUTT_HOSTAGE", 9, 7.0, nil, {r = 90, g = 206, b = 234})
	MissionUtil.MissionTextSpeech("HUTT_HOSTAGE", 10, 7.0, nil, {r = 90, g = 206, b = 234})
	Sleep(2.0)

	local republic_list = Find_All_Objects_Of_Type(p_republic, "Infantry")
	for i,republic_unit in pairs(republic_list) do
		MissionUtil.PlayAnimation(republic_unit, "Attention", false, 0)
	end

	player_jayfon_senior.Turn_To_Face(introcam_10_marker)
	Sleep(3.0)

	Fade_Screen_Out(2.0)
	Sleep(3.0)

	if defenders_spawned == false then
		Create_Thread("State_Senate_Spawner")
	end

	MissionUtil.PlayGenericMusic("CW_Arctic_Ambient_1_Theme")

	MissionUtil.SetCinematicCamera(introcam_11_marker, introcam_target_4_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_12_marker, introcam_target_4_marker, true, 9.0, nil, nil)
	MissionUtil.MissionTextSpeech("HUTT_HOSTAGE", 11, 8.0, nil, {r = 212, g = 81, b = 255})
	MissionUtil.MissionTextSpeech("HUTT_HOSTAGE", 12, 8.0, nil, {r = 212, g = 81, b = 255})
	Fade_Screen_In(2.0)
	Sleep(9.0)

	MissionUtil.SetCinematicCamera(introcam_13_marker, introcam_target_5_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_14_marker, introcam_target_5_marker, true, 9.0, nil, nil)
	MissionUtil.MissionTextSpeech("HUTT_HOSTAGE", 13, 8.0, nil, {r = 247, g = 201, b = 13})
	MissionUtil.MissionTextSpeech("HUTT_HOSTAGE", 14, 8.0, nil, {r = 247, g = 201, b = 13})
	Sleep(9.0)

	MissionUtil.SetCinematicCamera(introcam_15_marker, introcam_target_6_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_16_marker, introcam_target_6_marker, true, 8.0, nil, nil)
	MissionUtil.MissionTextSpeech("HUTT_HOSTAGE", 15, 8.5, nil, nil)
	MissionUtil.MissionTextSpeech("HUTT_HOSTAGE", 16, 8.5, nil, nil)
	Sleep(9.5)

	MissionUtil.SetCinematicCamera(introcam_17_marker, introcam_target_6_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_18_marker, introcam_target_6_marker, true, 9.0, nil, nil)
	MissionUtil.MissionTextSpeech("HUTT_HOSTAGE", 17, 8.5, nil, nil)
	MissionUtil.MissionTextSpeech("HUTT_HOSTAGE", 18, 8.5, nil, nil)
	Sleep(9.5)

	MissionUtil.MissionTextSpeech("HUTT_HOSTAGE", 19, 5.5, nil, {r = 212, g = 81, b = 255})

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Hutts")
	end
end
function End_Cinematic_Intro_Hutts()
	MissionUtil.EndCinematicCamera(player_ziro, 3.0)
	MissionUtil.CinematicEnvironmentOff()

	Create_Thread("State_Riot_Spawner")
	Sleep(3.0)

	MissionUtil.MissionTextSpeech("HUTT_HOSTAGE", 20, 8.5, nil, {r = 247, g = 201, b = 13})

	MissionUtil.SetObjectiveMissionSet("HUTT_HOSTAGE", "HUTTS", 6)
	MissionUtil.AIActivation()

	Add_Radar_Blip(extraction_point_marker, "extraction_point_blip")
	extraction_point_marker.Highlight(true)

	shock_marker_list = Find_All_Objects_With_Hint("shock-squad")
	for i,shock_marker in pairs(shock_marker_list) do
		MissionUtil.SpawnListSpawner("SHOCK_CLONETROOPER_PHASE_ONE_SQUAD", shock_marker, p_republic, 1)
	end


	local attention_1_list = Find_All_Objects_With_Hint("1")
	for i,attention_1_unit in pairs(attention_1_list) do
		attention_1_unit.Despawn()
	end

	local attention_2_list = Find_All_Objects_With_Hint("2")
	for i,attention_2_unit in pairs(attention_2_list) do
		attention_2_unit.Despawn()
	end

	local attention_3_list = Find_All_Objects_With_Hint("3")
	for i,attention_3_unit in pairs(attention_3_list) do
		attention_3_unit.Despawn()
	end

	local attention_4_list = Find_All_Objects_With_Hint("4")
	for i,attention_4_unit in pairs(attention_4_list) do
		attention_4_unit.Despawn()
	end

	local attention_5_list = Find_All_Objects_With_Hint("5")
	for i,attention_5_unit in pairs(attention_5_list) do
		attention_5_unit.Despawn()
	end

	local attention_6_list = Find_All_Objects_With_Hint("6")
	for i,attention_6_unit in pairs(attention_6_list) do
		attention_6_unit.Despawn()
	end

	local attention_7_list = Find_All_Objects_With_Hint("7")
	for i,attention_7_unit in pairs(attention_7_list) do
		attention_7_unit.Despawn()
	end

	local attention_8_list = Find_All_Objects_With_Hint("8")
	for i,attention_8_unit in pairs(attention_8_list) do
		attention_8_unit.Despawn()
	end

	local attention_9_list = Find_All_Objects_With_Hint("9")
	for i,attention_9_unit in pairs(attention_9_list) do
		attention_9_unit.Despawn()
	end

	local attention_10_list = Find_All_Objects_With_Hint("10")
	for i,attention_10_unit in pairs(attention_10_list) do
		attention_10_unit.Despawn()
	end

	local attention_11_list = Find_All_Objects_With_Hint("11")
	for i,attention_11_unit in pairs(attention_11_list) do
		attention_11_unit.Despawn()
	end

	local attention_12_list = Find_All_Objects_With_Hint("12")
	for i,attention_12_unit in pairs(attention_12_list) do
		attention_12_unit.Despawn()
	end

	local attention_13_list = Find_All_Objects_With_Hint("13")
	for i,attention_13_unit in pairs(attention_13_list) do
		attention_13_unit.Despawn()
	end

	local attention_14_list = Find_All_Objects_With_Hint("14")
	for i,attention_14_unit in pairs(attention_14_list) do
		attention_14_unit.Despawn()
	end

	local attention_15_list = Find_All_Objects_With_Hint("15")
	for i,attention_15_unit in pairs(attention_15_list) do
		attention_15_unit.Despawn()
	end

	current_cinematic_thread_id = nil

	cinematic_one = false
	act_1_active = true
end

function Start_Cinematic_Outro_Hutts()
	extraction_point_marker.Highlight(false)
	GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)

	act_1_active = false
	cinematic_two = true

	Fade_Screen_Out(0.5)
	Sleep(0.5)

	MissionUtil.CinematicEnvironmentOn()
	MissionUtil.StartCinematicCamera()
	Sleep(0.5)

	Fade_Screen_In(0.5)
	Do_End_Cinematic_Cleanup()

	MissionUtil.MissionTextSpeech("HUTT_HOSTAGE", 21, 8.0, nil, {r = 212, g = 81, b = 255})
	Sleep(3)

	local prop_list = Find_All_Objects_With_Hint("prop")
	for i,prop_object in pairs(prop_list) do
		if TestValid(prop_object) then
			prop_object.Despawn()
		end	
	end

	local lander = MissionUtil.CreateCinematicLander("Alliance_Shuttle_Landing", lander_rm09_1_marker, p_hutts, 5.0, false, "LEAVING", 0)
	local lander = MissionUtil.CreateCinematicLander("Alliance_Shuttle_Landing", lander_rm09_2_marker, p_hutts, 5.0, false, "LEAVING", 0)

	local lander = MissionUtil.CreateCinematicLander("Kappa_Shuttle_Landing_Craft_Landing", lander_kappa_1_marker, p_hutts, 5.0, false, "LEAVING", 0)
	local lander = MissionUtil.CreateCinematicLander("Kappa_Shuttle_Landing_Craft_Landing", lander_kappa_1_marker, p_hutts, 5.0, false, "LEAVING", 0)

	local lander = MissionUtil.CreateCinematicLander("Gozanti_Landing_Craft_Landing", lander_gozanti_1_marker, p_hutts, 5.0, false, "LEAVING", 0)
	local lander = MissionUtil.CreateCinematicLander("Gozanti_Landing_Craft_Landing", lander_gozanti_2_marker, p_hutts, 5.0, false, "LEAVING", 0)

	MissionUtil.PlayGenericMusic("FoC_Tybers_Plan_Theme")

	MissionUtil.MissionTextSpeech("HUTT_HOSTAGE", 22, 8.5, nil, {r = 90, g = 206, b = 234})

	Fade_Screen_In(2.0)
	MissionUtil.SetCinematicCamera(outrocam_1_marker, outrocam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outrocam_target_1_marker, true, 8.0, nil, nil)
	Sleep(3.0)

	Fade_Screen_Out(4.0)
	Sleep(5.0)

	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.DisableRetreat("REBEL", false)
	MissionUtil.DisableRetreat("EMPIRE", false)
	MissionUtil.DisableRetreat("HUTT_CARTELS", false)

	StoryUtil.DeclareVictory(p_republic, false)
end
