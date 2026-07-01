
--****************************************************--
--******* Outer Rim Sieges: Cato Castle Clash ********--
--****************************************************--

require("PGBase")
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
	p_hostile = Find_Player("Hostile")

	current_cinematic_thread_id = nil

	act_1_active = false
	act_2_active = false
	act_3_active = false
	act_4_active = false

	cinematic_one = false
	cinematic_two = false

	cinematic_one_skipped = false
	cinematic_two_skipped = false
end
function Begin_Battle(message)
	if message == OnEnter then
		MissionUtil.VictoryAllowance(false)
		MissionUtil.DisableRetreat("REBEL", true)
		MissionUtil.DisableRetreat("EMPIRE", true)

		MissionUtil.Set_To_Allies(p_republic, p_cis)

		space_cinematic_centre_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "space-cinematic-centre")
		Promote_To_Space_Cinematic_Layer(space_cinematic_centre_marker)

		cinematic_lua_venator_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-venator-start")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_venator_marker)

		cinematic_lua_acclamator_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-acclamator-start")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_acclamator_marker)

		cinematic_lua_cam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-1")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_1_marker)

		cinematic_lua_cam_1_target_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-1-target")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_1_target_marker)

		cinematic_lua_cam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-2")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_2_marker)

		cinematic_lua_cam_2_target_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-2-target")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_2_target_marker)

		cinematic_lua_cam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-3")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_3_marker)

		cinematic_lua_cam_3_target_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-3-target")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_3_target_marker)

		cinematic_lua_cam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-4")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_4_marker)

		cinematic_lua_cam_4_target_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-4-target")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_4_target_marker)

		crawl_cam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawl-cam-1")
		Promote_To_Space_Cinematic_Layer(crawl_cam_1_marker)

		crawl_cam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawl-cam-2")
		Promote_To_Space_Cinematic_Layer(crawl_cam_2_marker)

		crawl_cam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawl-cam-target-1")
		Promote_To_Space_Cinematic_Layer(crawl_cam_target_1_marker)

		crawl_cam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawl-cam-target-2")
		Promote_To_Space_Cinematic_Layer(crawl_cam_target_2_marker)

		cam_look_at_fleet1 = Find_Hint("STORY_TRIGGER_ZONE_00", "cam-target-fleet1")
		Promote_To_Space_Cinematic_Layer(cam_look_at_fleet1)

		cam_look_at_fleet2 = Find_Hint("STORY_TRIGGER_ZONE_00", "cam-target-fleet2")
		Promote_To_Space_Cinematic_Layer(cam_look_at_fleet2)

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-4")
		introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-5")
		introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-6")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")
		introcam_target_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-4")
		introcam_target_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-5")

		rep_intro_utat_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-intro-utat-1")
		rep_intro_clone_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-intro-clone-1")

		rep_phase_1_laat_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-1-laat-1")
		rep_phase_1_laat_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-1-laat-2")
		rep_phase_1_laat_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-1-laat-3")

		rep_phase_1_atte_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-1-atte-1")

		rep_phase_2_laat_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-2-laat-1")
		rep_phase_2_laat_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-2-laat-2")
		rep_phase_2_laat_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-2-laat-3")
		rep_phase_2_laat_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-2-laat-4")

		rep_phase_3_laat_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-3-laat-1")
		rep_phase_3_laat_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-3-laat-2")
		rep_phase_3_laat_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-3-laat-3")

		rep_phase_4_laat_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-4-laat-1")
		rep_phase_4_laat_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-4-laat-2")
		rep_phase_4_laat_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-phase-4-laat-3")


		cis_intro_b1_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-intro-b1-1")
		cis_intro_magna_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-intro-magna-1")

		cis_phase_1_b1_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-phase-1-b1-1")
		cis_phase_1_b2_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-phase-1-b2-1")
		cis_phase_1_b2_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-phase-1-b2-2")
		cis_phase_1_hmp_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-phase-1-hmp-1")
		cis_phase_1_magna_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-phase-1-magna-1")
		cis_phase_1_magna_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-phase-1-magna-2")

		cis_phase_2_persuader_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-phase-1-persuader-1")
		cis_phase_2_persuader_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-phase-1-persuader-2")

		phase_3_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-3-1")
		phase_3_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-3-2")
		phase_3_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-3-3")
		phase_3_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-3-4")
		phase_3_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-3-5")

		phase_4_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-4-1")
		phase_4_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-4-2")
		phase_4_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-4-3")
		phase_4_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-4-4")
		phase_4_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-4-5")

		phase_5_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-5-1")
		phase_5_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-5-2")
		phase_5_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-5-3")

		phase_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-1")
		Register_Prox(phase_1_marker, State_Phase_01, 150, p_republic)

		phase_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-2")
		Register_Prox(phase_2_marker, State_Phase_02, 150, p_republic)

		phase_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "phase-3")
		Register_Prox(phase_3_marker, State_Phase_03, 150, p_republic)

		phase_4_marker_list = Find_All_Objects_With_Hint("phase-4")
		for i,phase_4_marker in pairs(phase_4_marker_list) do
			Register_Prox(phase_4_marker, State_Phase_04, 150, p_republic)
		end

		phase_5_marker_list = Find_All_Objects_With_Hint("phase-5")
		for i,phase_5_marker in pairs(phase_5_marker_list) do
			Register_Prox(phase_5_marker, State_Phase_05, 150, p_republic)
		end

		Set_Cinematic_Environment(true)

		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_01_CIS")
		elseif p_republic.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_01_Rep")
		end
	end
end

function State_Phase_01(prox_obj, trigger_obj)
	if trigger_obj.Get_Owner() == p_republic then
		prox_obj.Cancel_Event_Object_In_Range(State_Phase_01)
	end
end
function State_Phase_02(prox_obj, trigger_obj)
	if trigger_obj.Get_Owner() == p_republic then
		prox_obj.Cancel_Event_Object_In_Range(State_Phase_02)
	end
end
function State_Phase_03(prox_obj, trigger_obj)
	if trigger_obj.Get_Owner() == p_republic then
		prox_obj.Cancel_Event_Object_In_Range(State_Phase_03)
	end
end
function State_Phase_04(prox_obj, trigger_obj)
	if trigger_obj.Get_Owner() == p_republic then
		prox_obj.Cancel_Event_Object_In_Range(State_Phase_04)
	end
end
function State_Phase_05(prox_obj, trigger_obj)
	if trigger_obj.Get_Owner() == p_republic then
		prox_obj.Cancel_Event_Object_In_Range(State_Phase_05)
	end
end

function State_Commence_Evacuation()
	if p_cis.Is_Human() then
		MissionUtil.DisableRetreat("REBEL", false)
		MissionUtil.MissionTextSpeech("CATO_CASTLE_CLASH", 8, 8.0, "So_Billes_Loop", {r = 255, g = 255, b = 255}) -- Nute Gunray
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

				Stop_All_Music()
				Stop_All_Speech()
				Remove_All_Text()
				Stop_Bink_Movie()

				MissionUtil.PlayGenericMusic("Clone_Army_Theme")

				Lua_Space_Acclamator = Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_INTRO")
				Lua_Space_Acclamator.Hide(true)
				Lua_Space_Acclamator.Teleport(cinematic_lua_acclamator_marker)
				Lua_Space_Acclamator.Face_Immediate(space_cinematic_centre_marker)
				Lua_Space_Acclamator.Play_Animation("Cinematic", false, 0)
				Lua_Space_Acclamator.Hide(false)

				cinematic_one = false
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_02_CIS")
			end
		end
		if cinematic_two then
			if not cinematic_two_skipped then
				cinematic_two_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				Stop_All_Music()
				Stop_All_Speech()
				Remove_All_Text()
				Stop_Bink_Movie()

				MissionUtil.PlayGenericMusic("BFII_Geonosis_Trailer_Theme")

				cinematic_two = false
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_03_CIS")
			end
		end
		if cinematic_three then
			if not cinematic_three_skipped then
				cinematic_three_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				Set_Cinematic_Environment(false)
				Weather_Audio_Pause(false)
				Allow_Localized_SFX(true)
				Enable_Fog(true)

				if TestValid(Find_First_Object("SPACE_STARS")) then
					Find_First_Object("SPACE_STARS").Despawn()
				end
				if TestValid(Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT")) then
					Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT").Despawn()
				end
				if TestValid(Find_First_Object("BESPIN_CLOUDS")) then
					Find_First_Object("BESPIN_CLOUDS").Despawn()
				end
				if TestValid(Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_INTRO")) then
					Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_INTRO").Despawn()
				end

				intro_list = Find_All_Objects_Of_Type(p_hostile)
				for i,intro_unit in pairs(intro_list) do
					if TestValid(intro_unit) then
						intro_unit.Despawn()
					end
				end

				if TestValid(MOV_phase_1_rep_laat_01) then
					MOV_phase_1_rep_laat_01.Despawn()
				end
				if TestValid(MOV_phase_1_rep_laat_02) then
					MOV_phase_1_rep_laat_02.Despawn()
				end

				if StoryUtil.GetDifficulty() == "EASY" then
					Register_Timer(State_Commence_Evacuation, 400)
				end
				if StoryUtil.GetDifficulty() == "NORMAL" then
					Register_Timer(State_Commence_Evacuation, 450)
				end
				if StoryUtil.GetDifficulty() == "HARD" then
					Register_Timer(State_Commence_Evacuation, 500)
				end

				MissionUtil.SpawnListSpawner("REPUBLIC_LAAT_COMPANY", rep_phase_1_laat_2_marker, p_republic, 1)
				MissionUtil.SpawnListSpawner("CLONETROOPER_PHASE_TWO_COMPANY", rep_phase_1_laat_1_marker, p_republic, 1)

				Reinforce_Unit(Find_Object_Type("REPUBLIC_BARC_COMPANY"), false, p_republic, true, false)
				Reinforce_Unit(Find_Object_Type("REPUBLIC_AT_RT_COMPANY"), false, p_republic, true, false)
				Reinforce_Unit(Find_Object_Type("REPUBLIC_AT_RT_COMPANY"), false, p_republic, true, false)

				Reinforce_Unit(Find_Object_Type("HAET_COMPANY"), false, p_republic, true, false)

				Reinforce_Unit(Find_Object_Type("CLONE_GALACTIC_MARINE_COMPANY"), false, p_republic, true, false)
				Reinforce_Unit(Find_Object_Type("CLONE_GALACTIC_MARINE_COMPANY"), false, p_republic, true, false)

				MissionUtil.Set_To_Enemies(p_republic, p_cis)

				MissionUtil.SetObjectiveMissionSet("CATO_CASTLE_CLASH", "CIS", 2)
				MissionUtil.CinematicSkippingCleanUp(intro_1_mandalore_marker)
				MissionUtil.VictoryAllowance(true)
				MissionUtil.CinematicEnvironmentOff()

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

				Stop_All_Music()
				Stop_All_Speech()
				Remove_All_Text()
				Stop_Bink_Movie()

				MissionUtil.PlayGenericMusic("Clone_Army_Theme")

				Lua_Space_Acclamator = Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_INTRO")
				Lua_Space_Acclamator.Hide(true)
				Lua_Space_Acclamator.Teleport(cinematic_lua_acclamator_marker)
				Lua_Space_Acclamator.Face_Immediate(space_cinematic_centre_marker)
				Lua_Space_Acclamator.Play_Animation("Cinematic", false, 0)
				Lua_Space_Acclamator.Hide(false)

				cinematic_one = false
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_02_Rep")
			end
		end
		if cinematic_two then
			if not cinematic_two_skipped then
				cinematic_two_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				Stop_All_Music()
				Stop_All_Speech()
				Remove_All_Text()
				Stop_Bink_Movie()

				MissionUtil.PlayGenericMusic("BFII_Geonosis_Trailer_Theme")

				cinematic_two = false
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_03_Rep")
			end
		end
		if cinematic_three then
			if not cinematic_three_skipped then
				cinematic_three_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				Set_Cinematic_Environment(false)
				Weather_Audio_Pause(false)
				Allow_Localized_SFX(true)
				Enable_Fog(true)

				if TestValid(Find_First_Object("SPACE_STARS")) then
					Find_First_Object("SPACE_STARS").Despawn()
				end
				if TestValid(Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT")) then
					Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT").Despawn()
				end
				if TestValid(Find_First_Object("BESPIN_CLOUDS")) then
					Find_First_Object("BESPIN_CLOUDS").Despawn()
				end
				if TestValid(Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_INTRO")) then
					Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_INTRO").Despawn()
				end

				intro_list = Find_All_Objects_Of_Type(p_hostile)
				for i,intro_unit in pairs(intro_list) do
					if TestValid(intro_unit) then
						intro_unit.Despawn()
					end
				end

				if not TestValid(Find_First_Object("Anakin2")) then
					player_anakin = MissionUtil.SpawnUnitGround("ANAKIN2", rep_phase_1_laat_1_marker, p_republic)
				end
				if not TestValid(Find_First_Object("Obi_Wan2")) then
					player_obiwan = MissionUtil.SpawnUnitGround("OBI_WAN2", rep_phase_1_laat_1_marker, p_republic)
				end
				if not TestValid(Find_First_Object("Cody2")) then
					player_cody = MissionUtil.SpawnUnitGround("CODY2", rep_phase_1_laat_1_marker, p_republic)
				end

				if TestValid(MOV_phase_1_rep_laat_01) then
					MOV_phase_1_rep_laat_01.Despawn()
				end
				if TestValid(MOV_phase_1_rep_laat_02) then
					MOV_phase_1_rep_laat_02.Despawn()
				end

				MissionUtil.SpawnListSpawner("REPUBLIC_LAAT_COMPANY", rep_phase_1_laat_1_marker, p_republic, 1)
				MissionUtil.SpawnListSpawner("REPUBLIC_LAAT_COMPANY", rep_phase_1_laat_2_marker, p_republic, 1)
				MissionUtil.SpawnListSpawner("CLONETROOPER_PHASE_TWO_COMPANY", rep_phase_1_laat_1_marker, p_republic, 1)
				MissionUtil.SpawnListSpawner("CLONE_GALACTIC_MARINE_COMPANY", rep_phase_1_laat_2_marker, p_republic, 1)
				MissionUtil.SpawnListSpawner("CLONE_JUMPTROOPER_PHASE_TWO_COMPANY", rep_phase_1_laat_3_marker, p_republic, 2)
				MissionUtil.SpawnListSpawner("REPUBLIC_AT_TE_WALKER_COMPANY", rep_phase_1_atte_1_marker, p_republic, 1)

				MissionUtil.SpawnListSpawner("B1_DROID_COMPANY", cis_phase_1_b1_1_marker, p_cis, 1)
				MissionUtil.SpawnListSpawner("B2_DROID_COMPANY", cis_phase_1_b2_1_marker, p_cis, 1)
				MissionUtil.SpawnListSpawner("B2_DROID_COMPANY", cis_phase_1_b2_2_marker, p_cis, 1)
				MissionUtil.SpawnListSpawner("HMP_COMPANY", cis_phase_1_hmp_1_marker, p_cis, 1)
				MissionUtil.SpawnListSpawner("MAGNA_OCTUPTARRA_COMPANY", cis_phase_1_magna_1_marker, p_cis, 1)
				MissionUtil.SpawnListSpawner("MAGNA_OCTUPTARRA_COMPANY", cis_phase_1_magna_2_marker, p_cis, 1)

				MissionUtil.Set_To_Enemies(p_republic, p_cis)

				MissionUtil.SetObjectiveMissionSet("CATO_CASTLE_CLASH", "REP", 4)
				MissionUtil.CinematicSkippingCleanUp(intro_1_mandalore_marker)
				MissionUtil.VictoryAllowance(true)
				MissionUtil.CinematicEnvironmentOff()

				cinematic_one = false
				act_1_active = true

				Fade_Screen_In(0.5)
			end
		end
	end
end
function Story_Mode_Service()
end

function Start_Cinematic_Intro_01_CIS()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	cinematic_skydome_space = MissionUtil.SpawnUnitGround("SPACE_STARS", space_cinematic_centre_marker, p_republic)

	Weather_Audio_Pause(true)
	Start_Cinematic_Camera(false)
	Allow_Localized_SFX(false)
	Enable_Fog(false)

	MissionUtil.SetCinematicCamera(crawl_cam_1_marker, crawl_cam_target_1_marker, true)
	MissionUtil.TransitionCinematicCamera(crawl_cam_2_marker, crawl_cam_target_2_marker, true, 11.0, nil, nil)

	Lua_Space_Venator = Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_INTRO")
	Lua_Space_Venator.Hide(true)
	Lua_Space_Venator.Teleport(cinematic_lua_venator_marker)
	Lua_Space_Venator.Face_Immediate(cinematic_lua_venator_marker)
	Lua_Space_Venator.Play_Animation("Cinematic", false, 0)
	Lua_Space_Venator.Hide(false)

	cinematic_one = true
	MissionUtil.PlayGenericMusic("Clone_Army_Theme")
	Fade_Screen_In(1.0)
	Letter_Box_In(1.0)
	Sleep(2.0)

	MissionUtil.MissionTextSpeech("CATO_CASTLE_CLASH", 1, 9.5, nil, {r = 255, g = 255, b = 255})
	Story_Event("LIBERATION_01")
	Sleep(10.0)

	Transition_Cinematic_Camera_Key(cinematic_lua_venator_marker, 15, 100, -20, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cinematic_lua_venator_marker, 15, 0, 0, -40, 0, 0, 0, 0)
	MissionUtil.MissionTextSpeech("CATO_CASTLE_CLASH", 2, 8.0, nil, {r = 255, g = 255, b = 255})
	Sleep(2.0)

	MissionUtil.SetCinematicCamera(cam_look_at_fleet1, cinematic_lua_venator_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(cam_look_at_fleet2, cinematic_lua_venator_marker, true, 10.0, nil, nil)
	Sleep(9.0)

	MissionUtil.MissionTextSpeech("CATO_CASTLE_CLASH", 3, 4.5, nil, {r = 255, g = 255, b = 255})
	Sleep(4.0)

	Fade_Screen_Out(1.0)
	Sleep(3.0)

	if not cinematic_one_skipped then
		Create_Thread("Start_Cinematic_Intro_02_CIS")
	end
end
function Start_Cinematic_Intro_02_CIS()
	if TestValid(Find_First_Object("SPACE_STARS")) then
		Find_First_Object("SPACE_STARS").Despawn()
	end
	if TestValid(Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT")) then
		Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT").Despawn()
	end

	cinematic_two = true

	MissionUtil.PlayGenericMusic("BFII_Geonosis_Trailer_Theme")

	cinematic_skydome_clouds = MissionUtil.SpawnUnitGround("BESPIN_CLOUDS", space_cinematic_centre_marker, p_republic)

	Weather_Audio_Pause(true)
	Start_Cinematic_Camera(false)
	Allow_Localized_SFX(false)
	Enable_Fog(false)

	Lua_Space_Acclamator = Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_INTRO")
	Lua_Space_Acclamator.Hide(true)
	Lua_Space_Acclamator.Teleport(cinematic_lua_acclamator_marker)
	Lua_Space_Acclamator.Face_Immediate(space_cinematic_centre_marker)
	Lua_Space_Acclamator.Hide(false)

	Sleep(1.0)

	Set_Cinematic_Camera_Key(cinematic_lua_cam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cinematic_lua_cam_1_target_marker, 0, 0, 0, 0, 0, 0, 0)
	Transition_Cinematic_Camera_Key(cinematic_lua_cam_1_marker, 6, 0, -200, 0, 0, 0, 0, 0)
	MissionUtil.MissionTextSpeech("CATO_CASTLE_CLASH", 4, 5.5, nil, {r = 255, g = 255, b = 255})
	Fade_Screen_In(7.0)
	Sleep(6)

	Set_Cinematic_Camera_Key(cinematic_lua_cam_2_marker, 0, -150, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cinematic_lua_cam_2_target_marker, 0, -150, 0, 0, 0, 0, 0)
	Transition_Cinematic_Camera_Key(cinematic_lua_cam_2_marker, 5, 0, 10, 0, 0, 0, 0, 0)
	MissionUtil.MissionTextSpeech("CATO_CASTLE_CLASH", 5, 8.0, nil, {r = 255, g = 255, b = 255})
	Sleep(5)

	Set_Cinematic_Camera_Key(cinematic_lua_cam_3_marker, 0, -100, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cinematic_lua_cam_2_target_marker, 0, -100, 0, 0, 0, 0, 0)
	Transition_Cinematic_Camera_Key(cinematic_lua_cam_3_marker, 12, 0, 10, 0, 0, 0, 0, 0)
	Sleep(3.5)

	MissionUtil.MissionTextSpeech("CATO_CASTLE_CLASH", 6, 6.0, nil, {r = 255, g = 255, b = 255})
	Sleep(5.5)

	Fade_Screen_Out(2.0)
	Sleep(2.0)

	Set_Cinematic_Environment(false)
	Enable_Fog(true)

	if not cinematic_two_skipped then
		Create_Thread("Start_Cinematic_Intro_03_CIS")
	end
end
function Start_Cinematic_Intro_03_CIS()
	if TestValid(Find_First_Object("SPACE_STARS")) then
		Find_First_Object("SPACE_STARS").Despawn()
	end
	if TestValid(Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT")) then
		Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT").Despawn()
	end
	if TestValid(Find_First_Object("BESPIN_CLOUDS")) then
		Find_First_Object("BESPIN_CLOUDS").Despawn()
	end
	if TestValid(Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_INTRO")) then
		Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_INTRO").Despawn()
	end
	cinematic_three = true

	MissionUtil.Set_To_Enemies(p_republic,p_cis)

	MissionUtil.CinematicEnvironmentOn()
	Set_Cinematic_Environment(false)
	Enable_Fog(true)

	Sleep(1.0)

	MissionUtil.CinematicIntroHeader("CATO_CASTLE_CLASH")
	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, true, 5.5, nil, nil)
	Fade_Screen_In(2.0)
	Sleep(5.0)

	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_4_marker, true, 7.5, nil, nil)
	Sleep(6.5)

	Fade_Screen_Out(0.25)
	Sleep(0.5)

	MOV_phase_1_rep_laat_01 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), rep_phase_1_laat_1_marker, 225, 1,0.25, 20, 1)
	Hide_Sub_Object(MOV_phase_1_rep_laat_01, 1, "Clones")

	MOV_phase_1_rep_laat_02 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), rep_phase_1_laat_2_marker, 225, 1,0.25, 20, 1)
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Boil")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Boil_Carbine")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Boil_Helmet")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Waxer")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Waxer_Carbine")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Waxer_Helmet")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Cody")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Cody_Carbine")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "CodyHelmet")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Obi")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Obi_Clones")

	MOV_phase_1_rep_laat_03 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), rep_phase_1_laat_3_marker, 225, 1,0.25, 20, 0)
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Boil")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Boil_Carbine")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Boil_Helmet")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Waxer")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Waxer_Carbine")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Waxer_Helmet")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Cody")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Cody_Carbine")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "CodyHelmet")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Obi")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Obi_Clones")

	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_6_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_5_marker, true, 5.5, nil, nil)

	MissionUtil.MissionTextSpeech("CATO_CASTLE_CLASH", 7, 9.0, nil, {r = 255, g = 255, b = 255})
	Fade_Screen_In(2.0)
	Sleep(10.0)

	if not cinematic_three_skipped then
		Create_Thread("End_Cinematic_Intro_CIS")
	end
end

function End_Cinematic_Intro_CIS()
	if TestValid(MOV_phase_1_rep_laat_01) then
		MOV_phase_1_rep_laat_01.Despawn()
	end
	if TestValid(MOV_phase_1_rep_laat_02) then
		MOV_phase_1_rep_laat_02.Despawn()
	end

	MissionUtil.SpawnListSpawner("REPUBLIC_LAAT_COMPANY", rep_phase_1_laat_2_marker, p_republic, 1)
	MissionUtil.SpawnListSpawner("CLONETROOPER_PHASE_TWO_COMPANY", rep_phase_1_laat_1_marker, p_republic, 1)

	Reinforce_Unit(Find_Object_Type("REPUBLIC_BARC_COMPANY"), false, p_republic, true, false)
	Reinforce_Unit(Find_Object_Type("REPUBLIC_AT_RT_COMPANY"), false, p_republic, true, false)
	Reinforce_Unit(Find_Object_Type("REPUBLIC_AT_RT_COMPANY"), false, p_republic, true, false)

	Reinforce_Unit(Find_Object_Type("HAET_COMPANY"), false, p_republic, true, false)

	Reinforce_Unit(Find_Object_Type("CLONE_GALACTIC_MARINE_COMPANY"), false, p_republic, true, false)
	Reinforce_Unit(Find_Object_Type("CLONE_GALACTIC_MARINE_COMPANY"), false, p_republic, true, false)

	MissionUtil.EndCinematicCamera(rep_phase_1_laat_1_marker, 3.5)
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.AIActivation()

	MissionUtil.Set_To_Enemies(p_republic, p_cis)

	MissionUtil.SetObjectiveMissionSet("CATO_CASTLE_CLASH", "CIS", 2)
	MissionUtil.VictoryAllowance(true)

	if StoryUtil.GetDifficulty() == "EASY" then
		Register_Timer(State_Commence_Evacuation, 400)
	end
	if StoryUtil.GetDifficulty() == "NORMAL" then
		Register_Timer(State_Commence_Evacuation, 450)
	end
	if StoryUtil.GetDifficulty() == "HARD" then
		Register_Timer(State_Commence_Evacuation, 500)
	end

	cinematic_one = false
	act_1_active = true
end

function Start_Cinematic_Intro_01_Rep()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	cinematic_skydome_space = MissionUtil.SpawnUnitGround("SPACE_STARS", space_cinematic_centre_marker, p_republic)

	Weather_Audio_Pause(true)
	Start_Cinematic_Camera(false)
	Allow_Localized_SFX(false)
	Enable_Fog(false)

	MissionUtil.SetCinematicCamera(crawl_cam_1_marker, crawl_cam_target_1_marker, true)
	MissionUtil.TransitionCinematicCamera(crawl_cam_2_marker, crawl_cam_target_2_marker, true, 11.0, nil, nil)

	Lua_Space_Venator = Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_INTRO")
	Lua_Space_Venator.Hide(true)
	Lua_Space_Venator.Teleport(cinematic_lua_venator_marker)
	Lua_Space_Venator.Face_Immediate(cinematic_lua_venator_marker)
	Lua_Space_Venator.Play_Animation("Cinematic", false, 0)
	Lua_Space_Venator.Hide(false)

	cinematic_one = true
	MissionUtil.PlayGenericMusic("Clone_Army_Theme")
	Fade_Screen_In(1.0)
	Letter_Box_In(1.0)
	Sleep(2.0)

	MissionUtil.MissionTextSpeech("CATO_CASTLE_CLASH", 1, 9.5, nil, {r = 255, g = 255, b = 255})
	Story_Event("LIBERATION_01")
	Sleep(10.0)

	Transition_Cinematic_Camera_Key(cinematic_lua_venator_marker, 15, 100, -20, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cinematic_lua_venator_marker, 15, 0, 0, -40, 0, 0, 0, 0)
	MissionUtil.MissionTextSpeech("CATO_CASTLE_CLASH", 2, 8.0, nil, {r = 255, g = 255, b = 255})
	Sleep(2.0)

	MissionUtil.SetCinematicCamera(cam_look_at_fleet1, cinematic_lua_venator_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(cam_look_at_fleet2, cinematic_lua_venator_marker, true, 10.0, nil, nil)
	Sleep(9.0)

	MissionUtil.MissionTextSpeech("CATO_CASTLE_CLASH", 3, 4.5, nil, {r = 255, g = 255, b = 255})
	Sleep(4.0)

	Fade_Screen_Out(1.0)
	Sleep(3.0)

	if not cinematic_one_skipped then
		Create_Thread("Start_Cinematic_Intro_02_Rep")
	end
end
function Start_Cinematic_Intro_02_Rep()
	if TestValid(Find_First_Object("SPACE_STARS")) then
		Find_First_Object("SPACE_STARS").Despawn()
	end
	if TestValid(Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT")) then
		Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT").Despawn()
	end

	cinematic_two = true

	MissionUtil.PlayGenericMusic("BFII_Geonosis_Trailer_Theme")

	cinematic_skydome_clouds = MissionUtil.SpawnUnitGround("BESPIN_CLOUDS", space_cinematic_centre_marker, p_republic)

	Weather_Audio_Pause(true)
	Start_Cinematic_Camera(false)
	Allow_Localized_SFX(false)
	Enable_Fog(false)

	Lua_Space_Acclamator = Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_INTRO")
	Lua_Space_Acclamator.Hide(true)
	Lua_Space_Acclamator.Teleport(cinematic_lua_acclamator_marker)
	Lua_Space_Acclamator.Face_Immediate(space_cinematic_centre_marker)
	Lua_Space_Acclamator.Hide(false)

	Sleep(1.0)

	Set_Cinematic_Camera_Key(cinematic_lua_cam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cinematic_lua_cam_1_target_marker, 0, 0, 0, 0, 0, 0, 0)
	Transition_Cinematic_Camera_Key(cinematic_lua_cam_1_marker, 6, 0, -200, 0, 0, 0, 0, 0)
	MissionUtil.MissionTextSpeech("CATO_CASTLE_CLASH", 4, 5.5, nil, {r = 255, g = 255, b = 255})
	Fade_Screen_In(7.0)
	Sleep(6)

	Set_Cinematic_Camera_Key(cinematic_lua_cam_2_marker, 0, -150, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cinematic_lua_cam_2_target_marker, 0, -150, 0, 0, 0, 0, 0)
	Transition_Cinematic_Camera_Key(cinematic_lua_cam_2_marker, 5, 0, 10, 0, 0, 0, 0, 0)
	MissionUtil.MissionTextSpeech("CATO_CASTLE_CLASH", 5, 8.0, nil, {r = 255, g = 255, b = 255})
	Sleep(5)

	Set_Cinematic_Camera_Key(cinematic_lua_cam_3_marker, 0, -100, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cinematic_lua_cam_2_target_marker, 0, -100, 0, 0, 0, 0, 0)
	Transition_Cinematic_Camera_Key(cinematic_lua_cam_3_marker, 12, 0, 10, 0, 0, 0, 0, 0)
	Sleep(3.5)

	MissionUtil.MissionTextSpeech("CATO_CASTLE_CLASH", 6, 6.0, nil, {r = 255, g = 255, b = 255})
	Sleep(5.5)

	Fade_Screen_Out(2.0)
	Sleep(2.0)

	Set_Cinematic_Environment(false)
	Enable_Fog(true)

	if not cinematic_two_skipped then
		Create_Thread("Start_Cinematic_Intro_03_Rep")
	end
end
function Start_Cinematic_Intro_03_Rep()
	if TestValid(Find_First_Object("SPACE_STARS")) then
		Find_First_Object("SPACE_STARS").Despawn()
	end
	if TestValid(Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT")) then
		Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_LOW_ORBIT").Despawn()
	end
	if TestValid(Find_First_Object("BESPIN_CLOUDS")) then
		Find_First_Object("BESPIN_CLOUDS").Despawn()
	end
	if TestValid(Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_INTRO")) then
		Find_First_Object("CINEMATIC_CATO_NEIMOIDIA_INTRO").Despawn()
	end
	cinematic_three = true

	MissionUtil.Set_To_Enemies(p_republic,p_cis)

	MissionUtil.CinematicEnvironmentOn()
	Set_Cinematic_Environment(false)
	Enable_Fog(true)

	Sleep(1.0)

	MissionUtil.CinematicIntroHeader("CATO_CASTLE_CLASH")
	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, true, 5.5, nil, nil)
	Fade_Screen_In(2.0)
	Sleep(5.0)

	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_4_marker, true, 7.5, nil, nil)
	Sleep(6.5)

	Fade_Screen_Out(0.25)
	Sleep(0.5)

	MOV_phase_1_rep_laat_01 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), rep_phase_1_laat_1_marker, 225, 1,0.25, 20, 1)
	Hide_Sub_Object(MOV_phase_1_rep_laat_01, 1, "Clones")

	MOV_phase_1_rep_laat_02 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), rep_phase_1_laat_2_marker, 225, 1,0.25, 20, 1)
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Boil")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Boil_Carbine")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Boil_Helmet")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Waxer")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Waxer_Carbine")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Waxer_Helmet")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Cody")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Cody_Carbine")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "CodyHelmet")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Obi")
	Hide_Sub_Object(MOV_phase_1_rep_laat_02, 1, "Obi_Clones")

	MOV_phase_1_rep_laat_03 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), rep_phase_1_laat_3_marker, 225, 1,0.25, 20, 0)
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Boil")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Boil_Carbine")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Boil_Helmet")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Waxer")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Waxer_Carbine")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Waxer_Helmet")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Cody")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Cody_Carbine")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "CodyHelmet")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Obi")
	Hide_Sub_Object(MOV_phase_1_rep_laat_03, 1, "Obi_Clones")

	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_6_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_5_marker, true, 5.5, nil, nil)

	MissionUtil.MissionTextSpeech("CATO_CASTLE_CLASH", 7, 9.0, nil, {r = 255, g = 255, b = 255})
	Fade_Screen_In(2.0)
	Sleep(10.0)

	if not cinematic_three_skipped then
		Create_Thread("End_Cinematic_Intro_Rep")
	end
end

function End_Cinematic_Intro_Rep()
	if not TestValid(Find_First_Object("Anakin2")) then
		player_anakin = MissionUtil.SpawnUnitGround("ANAKIN2", rep_phase_1_laat_1_marker, p_republic)
	end
	if not TestValid(Find_First_Object("Obi_Wan2")) then
		player_obiwan = MissionUtil.SpawnUnitGround("OBI_WAN2", rep_phase_1_laat_1_marker, p_republic)
	end
	if not TestValid(Find_First_Object("Cody2")) then
		player_cody = MissionUtil.SpawnUnitGround("CODY2", rep_phase_1_laat_1_marker, p_republic)
	end

	if TestValid(MOV_phase_1_rep_laat_01) then
		MOV_phase_1_rep_laat_01.Despawn()
	end
	if TestValid(MOV_phase_1_rep_laat_02) then
		MOV_phase_1_rep_laat_02.Despawn()
	end

	MissionUtil.SpawnListSpawner("REPUBLIC_LAAT_COMPANY", rep_phase_1_laat_1_marker, p_republic, 1)
	MissionUtil.SpawnListSpawner("REPUBLIC_LAAT_COMPANY", rep_phase_1_laat_2_marker, p_republic, 1)
	MissionUtil.SpawnListSpawner("CLONETROOPER_PHASE_TWO_COMPANY", rep_phase_1_laat_1_marker, p_republic, 1)
	MissionUtil.SpawnListSpawner("CLONE_GALACTIC_MARINE_COMPANY", rep_phase_1_laat_2_marker, p_republic, 1)
	MissionUtil.SpawnListSpawner("CLONE_JUMPTROOPER_PHASE_TWO_COMPANY", rep_phase_1_laat_3_marker, p_republic, 2)
	MissionUtil.SpawnListSpawner("REPUBLIC_AT_TE_WALKER_COMPANY", rep_phase_1_atte_1_marker, p_republic, 1)

	MissionUtil.SpawnListSpawner("B1_DROID_COMPANY", cis_phase_1_b1_1_marker, p_cis, 1)
	MissionUtil.SpawnListSpawner("B2_DROID_COMPANY", cis_phase_1_b2_1_marker, p_cis, 1)
	MissionUtil.SpawnListSpawner("B2_DROID_COMPANY", cis_phase_1_b2_2_marker, p_cis, 1)
	MissionUtil.SpawnListSpawner("HMP_COMPANY", cis_phase_1_hmp_1_marker, p_cis, 1)
	MissionUtil.SpawnListSpawner("MAGNA_OCTUPTARRA_COMPANY", cis_phase_1_magna_1_marker, p_cis, 1)
	MissionUtil.SpawnListSpawner("MAGNA_OCTUPTARRA_COMPANY", cis_phase_1_magna_2_marker, p_cis, 1)

	MissionUtil.EndCinematicCamera(rep_phase_1_laat_1_marker, 3.5)
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.AIActivation()

	MissionUtil.Set_To_Enemies(p_republic, p_cis)

	MissionUtil.SetObjectiveMissionSet("CATO_CASTLE_CLASH", "REP", 4)
	MissionUtil.VictoryAllowance(true)

	cinematic_one = false
	act_1_active = true
end
