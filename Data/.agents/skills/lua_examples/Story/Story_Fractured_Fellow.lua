
--*****************************************************--
--***** Operation Knight Hammer: Fractured Fellow *****--
--*****************************************************--

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")
require("eawx-util/StoryUtil")
require("eawx-util/UnitUtil")
require("eawx-util/MissionUtil")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	StoryModeEvents =
	{
		Battle_Start = Begin_Battle,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_hutts = Find_Player("Hutt_Cartels")
	p_hostile = Find_Player("Independent_Forces")
	p_neutral = Find_Player("Neutral")

	act_1_active = false

	cinematic_crawl = false
	cinematic_one = false
	cinematic_two = false

	cinematic_crawl_skipped = false
	cinematic_one_skipped = false
	cinematic_two_skipped = false

	mission_started = false
end
function Begin_Battle(message)
	if message == OnEnter then
		MissionUtil.VictoryAllowance(false)

		MissionUtil.DisableRetreat("REBEL", true)
		MissionUtil.DisableRetreat("EMPIRE", true)
		MissionUtil.DisableRetreat("HUTT_CARTELS", true)

		space_cinematic_centre_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "space-cinematic-centre")
		Promote_To_Space_Cinematic_Layer(space_cinematic_centre_marker)

		cinematic_lua_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-animation-start")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_marker)

		crawl_cam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawlcam-0")
		Promote_To_Space_Cinematic_Layer(crawl_cam_1_marker)

		crawl_cam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawlcam-target-0")
		Promote_To_Space_Cinematic_Layer(crawl_cam_target_1_marker)

		crawl_cam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawlcam-2")
		Promote_To_Space_Cinematic_Layer(crawl_cam_2_marker)

		crawl_cam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawlcam-target-2")
		Promote_To_Space_Cinematic_Layer(crawl_cam_target_2_marker)

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

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")
		introcam_target_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-4")
		introcam_target_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-5")
		introcam_target_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-6")

		intro_1_headmaster_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-headmaster")
		intro_1_barsenthor_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-barsenthor")
		intro_2_barsenthor_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-barsenthor")

		p_door_1 = Find_Hint("MISSION_SITH_STONE_DOOR_X2", "door-1")
		MissionUtil.PlayAnimation(p_door_1, "Idle", true, 0)

		p_door_2 = Find_Hint("MISSION_SITH_STONE_DOOR_X2", "door-2")
		MissionUtil.PlayAnimation(p_door_2, "Idle", true, 0)

		Set_Cinematic_Environment(true)

		mission_started = true
		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Crawl_CIS")
		elseif p_republic.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Crawl_Rep")
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

				Set_Cinematic_Environment(true)
				Weather_Audio_Pause(true)
				Allow_Localized_SFX(false)
				Enable_Fog(false)

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

				Set_Cinematic_Environment(false)
				Weather_Audio_Pause(false)
				Allow_Localized_SFX(true)
				Enable_Fog(true)

				MissionUtil.DisableRetreat("REBEL", false)
				MissionUtil.DisableRetreat("EMPIRE", false)
				MissionUtil.DisableRetreat("INDEPENDENT_FORCES", false)
				MissionUtil.DisableRetreat("HUTT_CARTELS", false)

				MissionUtil.CinematicSkippingCleanUp(nil)

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

				Set_Cinematic_Environment(true)
				Weather_Audio_Pause(true)
				Allow_Localized_SFX(false)
				Enable_Fog(false)

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

				Set_Cinematic_Environment(false)
				Weather_Audio_Pause(false)
				Allow_Localized_SFX(true)
				Enable_Fog(true)

				MissionUtil.DisableRetreat("REBEL", false)
				MissionUtil.DisableRetreat("EMPIRE", false)
				MissionUtil.DisableRetreat("INDEPENDENT_FORCES", false)
				MissionUtil.DisableRetreat("HUTT_CARTELS", false)

				MissionUtil.CinematicSkippingCleanUp(nil)

				StoryUtil.DeclareVictory(p_republic, false)
			end
		end
	end
end
function Story_Mode_Service()
end

function Start_Cinematic_Crawl_CIS()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	p_cinematic_skydome = MissionUtil.SpawnUnitGround("Space_Stars", space_cinematic_centre_marker, p_republic)
	p_cinematic_skydome.Teleport_And_Face(space_cinematic_centre_marker)

	Weather_Audio_Pause(true)
	Start_Cinematic_Camera(false)
	Allow_Localized_SFX(false)
	Enable_Fog(false)

	lua_cinematic_list = Find_All_Objects_Of_Type("CINEMATIC_NU_CLASS_LANDING_FOREST")
	p_lua_cinematic = lua_cinematic_list[1]

	p_lua_cinematic.Teleport(cinematic_lua_marker)
	p_lua_cinematic.Hide(true)

	cinematic_crawl = true
	MissionUtil.SetCinematicCamera(crawl_cam_1_marker, crawl_cam_target_1_marker, true, nil, nil)

	MissionUtil.PlayCinematicMovieCrawl("Knight_Hammer_Intro", "Clone_Wars_Crawl_Theme")

	if not cinematic_crawl_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
	end
end
function Start_Cinematic_Intro_CIS()
	MissionUtil.SetCinematicCamera(crawl_cam_1_marker, crawl_cam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(crawl_cam_1_marker, crawl_cam_target_2_marker, true, 17.0, nil, nil)
	Letter_Box_In(1.0)

	lua_cinematic_list = Find_All_Objects_Of_Type("CINEMATIC_NU_CLASS_LANDING_FOREST")
	p_lua_cinematic = lua_cinematic_list[1]

	MissionUtil.PlayAnimation(p_lua_cinematic, "Cinematic", false, 0)
	p_lua_cinematic.Hide(false)

	player_headmaster = MissionUtil.SpawnUnitGround("PRAXEUM_HEADMASTER_JEDI", intro_1_headmaster_marker, p_republic)
	player_headmaster.Enable_Behavior(78, false)
	Hide_Sub_Object(player_headmaster, 1, "lightsaber")

	player_barsenthor = MissionUtil.SpawnUnitGround("BARSENTHOR", intro_1_barsenthor_marker, p_republic)
	player_barsenthor.Enable_Behavior(78, false)
	Hide_Sub_Object(player_barsenthor, 1, "lightsaber")

	cinematic_crawl = false
	cinematic_one = true

	MissionUtil.PlayGenericMusic("TOR_Occupation_Of_Balmorra_Chorus_Theme")
	Sleep(1.5)

	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 1, 15.0, nil, {r = 255, g = 0, b = 0})
	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 2, 15.0, nil, {r = 255, g = 0, b = 0})
	Sleep(10.0)

	Fade_Screen_Out(3.0)
	Sleep(6.0)

	Set_Cinematic_Environment(false)
	Weather_Audio_Pause(false)
	Allow_Localized_SFX(true)
	Enable_Fog(true)

	p_cinematic_skydome.Despawn()
	p_lua_cinematic.Despawn()

	Fade_Screen_In(6.0)
	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, false, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, false, 19.5, nil, nil)
	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 3, 16.0, nil, {r = 255, g = 0, b = 0})
	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 4, 16.0, nil, {r = 255, g = 0, b = 0})
	Sleep(17.0)

	MissionUtil.TransitionCinematicCamera(introcam_3_marker, introcam_target_3_marker, false, 9.0, nil, nil)
	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 5, 17.5, nil, {r = 0, g = 255, b = 0})
	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 6, 17.5, nil, {r = 0, g = 255, b = 0})
	Sleep(0.5)

	p_door_1 = Find_Hint("MISSION_SITH_STONE_DOOR_X2", "door-1")
	MissionUtil.PlayAnimation(p_door_1, "Cinematic", false, 0)
	Sleep(2.5)

	player_barsenthor.Move_To(intro_2_barsenthor_marker)

	p_door_2 = Find_Hint("MISSION_SITH_STONE_DOOR_X2", "door-2")
	MissionUtil.PlayAnimation(p_door_2, "Cinematic", false, 0)
	Sleep(4.0)

	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_4_marker, false, 12.5, nil, nil)
	Sleep(12.0)

	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_5_marker, false, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_4_marker, false, 14.5, nil, nil)
	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 7, 13.0, nil, {r = 255, g = 0, b = 0})
	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 8, 13.0, nil, {r = 255, g = 0, b = 0})
	Sleep(14.5)

	MissionUtil.SetCinematicCamera(introcam_7_marker, introcam_target_6_marker, false, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_8_marker, introcam_target_6_marker, false, 15.0, nil, nil)
	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 9, 13.5, nil, {r = 255, g = 0, b = 0})
	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 10, 13.5, nil, {r = 255, g = 0, b = 0})
	Sleep(15.0)

	MissionUtil.SetCinematicCamera(introcam_9_marker, introcam_target_5_marker, false, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_10_marker, introcam_target_4_marker, false, 11.5, nil, nil)
	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 11, 10.0, nil, {r = 255, g = 0, b = 0})
	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 12, 10.0, nil, {r = 255, g = 0, b = 0})
	Sleep(7.5)

	player_barsenthor.Enable_Behavior(78, true)
	Hide_Sub_Object(player_barsenthor, 0, "lightsaber")
	Sleep(4.0)

	player_headmaster.Enable_Behavior(78, true)
	Hide_Sub_Object(player_headmaster, 0, "lightsaber")
	Sleep(1.0)

	player_headmaster.Change_Owner(p_cis)
	player_headmaster.Attack_Move(player_barsenthor)

	MissionUtil.SetCinematicCamera(introcam_11_marker, introcam_target_5_marker, false, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_12_marker, introcam_target_4_marker, false, 13.0, nil, nil)
	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 13, 12.0, nil, {r = 0, g = 255, b = 0})
	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 14, 12.0, nil, {r = 0, g = 255, b = 0})
	Sleep(6.0)

	MissionUtil.SetCinematicCamera(introcam_13_marker, introcam_target_5_marker, false, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_14_marker, introcam_target_4_marker, false, 15.0, nil, nil)
	Sleep(8.0)

	Fade_Screen_Out(3.0)
	Sleep(5.0)

	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 15, 5.0, nil, {r = 0, g = 255, b = 0})
	Sleep(5.0)

	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.DisableRetreat("REBEL", false)
	MissionUtil.DisableRetreat("EMPIRE", false)
	MissionUtil.DisableRetreat("INDEPENDENT_FORCES", false)
	MissionUtil.DisableRetreat("HUTT_CARTELS", false)

	StoryUtil.DeclareVictory(p_cis, false)
end

function Start_Cinematic_Crawl_Rep()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	p_cinematic_skydome = MissionUtil.SpawnUnitGround("Space_Stars", space_cinematic_centre_marker, p_republic)
	p_cinematic_skydome.Teleport_And_Face(space_cinematic_centre_marker)

	Weather_Audio_Pause(true)
	Start_Cinematic_Camera(false)
	Allow_Localized_SFX(false)
	Enable_Fog(false)

	lua_cinematic_list = Find_All_Objects_Of_Type("CINEMATIC_NU_CLASS_LANDING_FOREST")
	p_lua_cinematic = lua_cinematic_list[1]

	p_lua_cinematic.Teleport(cinematic_lua_marker)
	p_lua_cinematic.Hide(true)

	cinematic_crawl = true
	MissionUtil.SetCinematicCamera(crawl_cam_1_marker, crawl_cam_target_1_marker, true, nil, nil)

	MissionUtil.PlayCinematicMovieCrawl("Knight_Hammer_Intro", "Clone_Wars_Crawl_Theme")

	if not cinematic_crawl_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
	end
end
function Start_Cinematic_Intro_Rep()
	MissionUtil.SetCinematicCamera(crawl_cam_1_marker, crawl_cam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(crawl_cam_1_marker, crawl_cam_target_2_marker, true, 17.0, nil, nil)
	Letter_Box_In(1.0)

	lua_cinematic_list = Find_All_Objects_Of_Type("CINEMATIC_NU_CLASS_LANDING_FOREST")
	p_lua_cinematic = lua_cinematic_list[1]

	MissionUtil.PlayAnimation(p_lua_cinematic, "Cinematic", false, 0)
	p_lua_cinematic.Hide(false)

	player_headmaster = MissionUtil.SpawnUnitGround("PRAXEUM_HEADMASTER_JEDI", intro_1_headmaster_marker, p_republic)
	player_headmaster.Enable_Behavior(78, false)
	Hide_Sub_Object(player_headmaster, 1, "lightsaber")

	player_barsenthor = MissionUtil.SpawnUnitGround("BARSENTHOR", intro_1_barsenthor_marker, p_republic)
	player_barsenthor.Enable_Behavior(78, false)
	Hide_Sub_Object(player_barsenthor, 1, "lightsaber")

	cinematic_crawl = false
	cinematic_one = true

	MissionUtil.PlayGenericMusic("TOR_Occupation_Of_Balmorra_Chorus_Theme")
	Sleep(1.5)

	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 1, 15.0, nil, {r = 255, g = 0, b = 0})
	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 2, 15.0, nil, {r = 255, g = 0, b = 0})
	Sleep(10.0)

	Fade_Screen_Out(3.0)
	Sleep(6.0)

	Set_Cinematic_Environment(false)
	Weather_Audio_Pause(false)
	Allow_Localized_SFX(true)
	Enable_Fog(true)

	p_cinematic_skydome.Despawn()
	p_lua_cinematic.Despawn()

	Fade_Screen_In(6.0)
	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, false, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, false, 19.5, nil, nil)
	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 3, 16.0, nil, {r = 255, g = 0, b = 0})
	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 4, 16.0, nil, {r = 255, g = 0, b = 0})
	Sleep(17.0)

	MissionUtil.TransitionCinematicCamera(introcam_3_marker, introcam_target_3_marker, false, 9.0, nil, nil)
	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 5, 17.5, nil, {r = 0, g = 255, b = 0})
	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 6, 17.5, nil, {r = 0, g = 255, b = 0})
	Sleep(0.5)

	p_door_1 = Find_Hint("MISSION_SITH_STONE_DOOR_X2", "door-1")
	MissionUtil.PlayAnimation(p_door_1, "Cinematic", false, 0)
	Sleep(2.5)

	player_barsenthor.Move_To(intro_2_barsenthor_marker)

	p_door_2 = Find_Hint("MISSION_SITH_STONE_DOOR_X2", "door-2")
	MissionUtil.PlayAnimation(p_door_2, "Cinematic", false, 0)
	Sleep(4.0)

	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_4_marker, false, 12.5, nil, nil)
	Sleep(12.0)

	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_5_marker, false, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_4_marker, false, 14.5, nil, nil)
	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 7, 13.0, nil, {r = 255, g = 0, b = 0})
	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 8, 13.0, nil, {r = 255, g = 0, b = 0})
	Sleep(14.5)

	MissionUtil.SetCinematicCamera(introcam_7_marker, introcam_target_6_marker, false, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_8_marker, introcam_target_6_marker, false, 15.0, nil, nil)
	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 9, 13.5, nil, {r = 255, g = 0, b = 0})
	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 10, 13.5, nil, {r = 255, g = 0, b = 0})
	Sleep(15.0)

	MissionUtil.SetCinematicCamera(introcam_9_marker, introcam_target_5_marker, false, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_10_marker, introcam_target_4_marker, false, 11.5, nil, nil)
	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 11, 10.0, nil, {r = 255, g = 0, b = 0})
	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 12, 10.0, nil, {r = 255, g = 0, b = 0})
	Sleep(7.5)

	player_barsenthor.Enable_Behavior(78, true)
	Hide_Sub_Object(player_barsenthor, 0, "lightsaber")
	Sleep(4.0)

	player_headmaster.Enable_Behavior(78, true)
	Hide_Sub_Object(player_headmaster, 0, "lightsaber")
	Sleep(1.0)

	player_headmaster.Change_Owner(p_cis)
	player_headmaster.Attack_Move(player_barsenthor)

	MissionUtil.SetCinematicCamera(introcam_11_marker, introcam_target_5_marker, false, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_12_marker, introcam_target_4_marker, false, 13.0, nil, nil)
	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 13, 12.0, nil, {r = 0, g = 255, b = 0})
	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 14, 12.0, nil, {r = 0, g = 255, b = 0})
	Sleep(6.0)

	MissionUtil.SetCinematicCamera(introcam_13_marker, introcam_target_5_marker, false, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_14_marker, introcam_target_4_marker, false, 15.0, nil, nil)
	Sleep(8.0)

	Fade_Screen_Out(3.0)
	Sleep(5.0)

	MissionUtil.MissionTextSpeech("FRACTURED_FELLOW", 15, 5.0, nil, {r = 0, g = 255, b = 0})
	Sleep(5.0)

	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.DisableRetreat("REBEL", false)
	MissionUtil.DisableRetreat("EMPIRE", false)
	MissionUtil.DisableRetreat("INDEPENDENT_FORCES", false)
	MissionUtil.DisableRetreat("HUTT_CARTELS", false)

	StoryUtil.DeclareVictory(p_republic, false)
end
