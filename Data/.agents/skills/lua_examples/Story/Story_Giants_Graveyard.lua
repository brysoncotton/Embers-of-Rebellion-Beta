
--****************************************************--
--******** Outer Rim Sieges: Giants Graveyard ********--
--****************************************************--

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

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_neutral = Find_Player("Neutral")
	p_hostile = Find_Player("Hostile")

	current_cinematic_thread_id = nil

	act_1_active = false
	act_2_active = false
	act_3_active = false
	act_4_active = false

	cinematic_crawl = false
	cinematic_one = false
	cinematic_two = false
	cinematic_three = false

	cinematic_crawl_skipped = false
	cinematic_one_skipped = false
	cinematic_two_skipped = false
	cinematic_three_skipped = false
end
function Begin_Battle(message)
	if message == OnEnter then
		MissionUtil.VictoryAllowance(false)
		MissionUtil.DisableRetreat("REBEL", true)
		MissionUtil.DisableRetreat("EMPIRE", true)

		MissionUtil.AllowOrbitalSupport(p_cis, false)
		MissionUtil.AllowOrbitalSupport(p_republic, false)

		GlobalValue.Set("MissionOutcome_GIANTS_GRAVEYARD", 0)

		MissionUtil.Set_To_Allies(p_republic, p_cis)

		space_cinematic_centre_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "space-centre")
		Promote_To_Space_Cinematic_Layer(space_cinematic_centre_marker)

		cinematic_lua_venator_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-venator-start")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_venator_marker)

		cinematic_lua_cis_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cis-start")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cis_marker)

		crawl_cam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawl-cam-1-alt")
		Promote_To_Space_Cinematic_Layer(crawl_cam_1_marker)

		crawl_cam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawl-cam-2")
		Promote_To_Space_Cinematic_Layer(crawl_cam_2_marker)

		crawl_cam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawl-cam-target-1")
		Promote_To_Space_Cinematic_Layer(crawl_cam_target_1_marker)

		crawl_cam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawl-cam-target-2")
		Promote_To_Space_Cinematic_Layer(crawl_cam_target_2_marker)

		cinematic_lua_cam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-1")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_1_marker)

		cinematic_lua_cam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-2")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_2_marker)

		cinematic_lua_cam_1_target_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-target-1")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_1_target_marker)

		cinematic_lua_cam_2_target_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-target-2-alt")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_2_target_marker)

		local cis_fleet = Find_All_Objects_Of_Type("CINEMATIC_BOZ_PITY_INTRO_STATIC_CIS")
		for _,cis_unit in pairs(cis_fleet) do
			if TestValid(cis_unit) then
				Promote_To_Space_Cinematic_Layer(cis_unit)
			end
		end

		local rep_fleet = Find_All_Objects_Of_Type("CINEMATIC_BOZ_PITY_INTRO_STATIC_REP")
		for _,rep_unit in pairs(rep_fleet) do
			if TestValid(rep_unit) then
				Promote_To_Space_Cinematic_Layer(rep_unit)
			end
		end

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
		introcam_target_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-6")

		outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-1")
		outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-2")

		outrocam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-1")
		outrocam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-2")

		player_dooku = Find_First_Object("Dooku")
		Register_Death_Event(player_dooku, State_Hero_Death_Dooku)

		player_grievous = Find_First_Object("General_Grievous")
		Register_Death_Event(player_grievous, State_Hero_Death_Grievous)

		player_ventress = Find_First_Object("Ventress")
		Register_Death_Event(player_ventress, State_Hero_Death_Ventress)

		Set_Cinematic_Environment(true)

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

				Fade_Screen_In(0.1)
				cinematic_crawl = false
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_01_CIS")
			end
		end
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

				Lua_Space_Venator = Find_First_Object("CINEMATIC_BOZ_PITY_INTRO")
				Lua_Space_Venator.Hide(true)
				Lua_Space_Venator.Teleport_And_Face(cinematic_lua_venator_marker)
				Lua_Space_Venator.Play_Animation("Cinematic", false, 0)
				Lua_Space_Venator.Hide(false)

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

				Set_Cinematic_Environment(false)
				Weather_Audio_Pause(false)
				Allow_Localized_SFX(true)
				Enable_Fog(true)

				if TestValid(Find_First_Object("SPACE_STARS")) then
					Find_First_Object("SPACE_STARS").Despawn()
				end
				if TestValid(Find_First_Object("CINEMATIC_BOZ_PITY_INTRO")) then
					Find_First_Object("CINEMATIC_BOZ_PITY_INTRO").Despawn()
				end

				MissionUtil.Set_To_Enemies(p_republic, p_cis)

				MissionUtil.AddToReinforcementPool("B1_DROID_COMPANY", p_cis, 3)
				MissionUtil.AddToReinforcementPool("B2_DROID_COMPANY", p_cis, 3)
				MissionUtil.AddToReinforcementPool("MANDALORIAN_COMMANDO_COMPANY", p_cis, 3)
				MissionUtil.AddToReinforcementPool("NEIMOIDIAN_GUARD_COMPANY", p_cis, 3)
				MissionUtil.AddToReinforcementPool("CIS_AAT_COMPANY", p_cis, 3)
				MissionUtil.AddToReinforcementPool("HAILFIRE_COMPANY", p_cis, 3)
				MissionUtil.AddToReinforcementPool("DWARF_SPIDER_DROID_COMPANY", p_cis, 3)

				MissionUtil.AddToReinforcementPool("CLONETROOPER_PHASE_TWO_COMPANY", p_republic, 3)
				MissionUtil.AddToReinforcementPool("ARC_PHASE_TWO_COMPANY", p_republic, 3)
				MissionUtil.AddToReinforcementPool("CLONE_AIRBORNE_TROOPER_COMPANY", p_republic, 3)
				MissionUtil.AddToReinforcementPool("REPUBLIC_AT_TE_WALKER_COMPANY", p_republic, 3)
				MissionUtil.AddToReinforcementPool("REPUBLIC_ISP_COMPANY", p_republic, 3)
				MissionUtil.AddToReinforcementPool("HAET_COMPANY", p_republic, 3)
				MissionUtil.AddToReinforcementPool("REPUBLIC_TX130T_COMPANY", p_republic, 3)

				MissionUtil.SetObjectiveMissionSet("GIANTS_GRAVEYARD", "CIS", 4)
				MissionUtil.CinematicSkippingCleanUp(intro_1_mandalore_marker)

				MissionUtil.MissionTextSpeech("GIANTS_GRAVEYARD", 9, 10.0, "Dooku_Loop", {r = 255, g = 255, b = 255})

				cinematic_one = false
				act_1_active = true

				Fade_Screen_In(0.5)
			end
		end
		if cinematic_three then
			if not cinematic_three_skipped then
				cinematic_three_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				MissionUtil.AllowOrbitalSupport(p_cis, true)
				MissionUtil.AllowOrbitalSupport(p_republic, true)

				MissionUtil.DisableRetreat("REBEL", false)
				MissionUtil.DisableRetreat("EMPIRE", false)

				MissionUtil.CinematicEnvironmentOff()
				StoryUtil.DeclareVictory(p_republic, false)
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

				Fade_Screen_In(0.1)
				cinematic_crawl = false
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_01_Rep")
			end
		end
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

				Lua_Space_Venator = Find_First_Object("CINEMATIC_BOZ_PITY_INTRO")
				Lua_Space_Venator.Hide(true)
				Lua_Space_Venator.Teleport_And_Face(space_cinematic_centre_marker)
				Lua_Space_Venator.Play_Animation("Cinematic", false, 0)
				Lua_Space_Venator.Hide(false)

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

				Set_Cinematic_Environment(false)
				Weather_Audio_Pause(false)
				Allow_Localized_SFX(true)
				Enable_Fog(true)

				if TestValid(Find_First_Object("SPACE_STARS")) then
					Find_First_Object("SPACE_STARS").Despawn()
				end
				if TestValid(Find_First_Object("CINEMATIC_BOZ_PITY_INTRO")) then
					Find_First_Object("CINEMATIC_BOZ_PITY_INTRO").Despawn()
				end

				MissionUtil.Set_To_Enemies(p_republic, p_cis)

				MissionUtil.AddToReinforcementPool("B1_DROID_COMPANY", p_cis, 3)
				MissionUtil.AddToReinforcementPool("B2_DROID_COMPANY", p_cis, 3)
				MissionUtil.AddToReinforcementPool("MANDALORIAN_COMMANDO_COMPANY", p_cis, 3)
				MissionUtil.AddToReinforcementPool("NEIMOIDIAN_GUARD_COMPANY", p_cis, 3)
				MissionUtil.AddToReinforcementPool("CIS_AAT_COMPANY", p_cis, 3)
				MissionUtil.AddToReinforcementPool("HAILFIRE_COMPANY", p_cis, 3)
				MissionUtil.AddToReinforcementPool("DWARF_SPIDER_DROID_COMPANY", p_cis, 3)

				MissionUtil.AddToReinforcementPool("CLONETROOPER_PHASE_TWO_COMPANY", p_republic, 3)
				MissionUtil.AddToReinforcementPool("ARC_PHASE_TWO_COMPANY", p_republic, 3)
				MissionUtil.AddToReinforcementPool("CLONE_AIRBORNE_TROOPER_COMPANY", p_republic, 3)
				MissionUtil.AddToReinforcementPool("REPUBLIC_AT_TE_WALKER_COMPANY", p_republic, 3)
				MissionUtil.AddToReinforcementPool("REPUBLIC_ISP_COMPANY", p_republic, 3)
				MissionUtil.AddToReinforcementPool("HAET_COMPANY", p_republic, 3)
				MissionUtil.AddToReinforcementPool("REPUBLIC_TX130T_COMPANY", p_republic, 3)

				MissionUtil.SetObjectiveMissionSet("GIANTS_GRAVEYARD", "REP", 5)
				MissionUtil.CinematicSkippingCleanUp(intro_1_mandalore_marker)

				MissionUtil.MissionTextSpeech("GIANTS_GRAVEYARD", 8, 10.0, "Mace_Loop", {r = 255, g = 255, b = 255})

				cinematic_one = false
				act_1_active = true

				Fade_Screen_In(0.5)
			end
		end
		if cinematic_three then
			if not cinematic_three_skipped then
				cinematic_three_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				MissionUtil.AllowOrbitalSupport(p_cis, true)
				MissionUtil.AllowOrbitalSupport(p_republic, true)

				MissionUtil.DisableRetreat("REBEL", false)
				MissionUtil.DisableRetreat("EMPIRE", false)

				MissionUtil.CinematicEnvironmentOff()
				StoryUtil.DeclareVictory(p_republic, false)
			end
		end
	end
end
function Story_Mode_Service()
	if act_1_active then
		local cis_list = Find_All_Objects_Of_Type(p_cis, "Vehicle | Infantry | AirGunship | AirSpeeder | InfantryHero | VehicleHero")
		if table.getn(cis_list) == 0 then
			if not cinematic_three then
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
			end
		end
	end
	if act_1_active then
		local rep_list = Find_All_Objects_Of_Type(p_republic, "Vehicle | Infantry | AirGunship | AirSpeeder | InfantryHero | VehicleHero")
		if table.getn(rep_list) == 0 then
			if not cinematic_three then
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
			end
		end
	end
end

function State_Hero_Death_Dooku()
	if p_cis.Is_Human() then
		MissionUtil.SetMissionObjectiveFailed("GIANTS_GRAVEYARD", "CIS", 2)
	elseif p_republic.Is_Human() then
		MissionUtil.SetMissionObjectiveComplete("GIANTS_GRAVEYARD", "REP", 3)
	end
end
function State_Hero_Death_Grievous()
	if p_cis.Is_Human() then
		MissionUtil.SetMissionObjectiveFailed("GIANTS_GRAVEYARD", "CIS", 3)
	elseif p_republic.Is_Human() then
		MissionUtil.SetMissionObjectiveComplete("GIANTS_GRAVEYARD", "REP", 4)
	end
end
function State_Hero_Death_Ventress()
	if p_cis.Is_Human() then
		MissionUtil.SetMissionObjectiveFailed("GIANTS_GRAVEYARD", "CIS", 4)
	elseif p_republic.Is_Human() then
		MissionUtil.SetMissionObjectiveComplete("GIANTS_GRAVEYARD", "REP", 5)
	end
end


function Start_Cinematic_Crawl_CIS()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	cinematic_skydome_space = MissionUtil.SpawnUnitGround("SPACE_STARS", space_cinematic_centre_marker, p_republic)

	Weather_Audio_Pause(true)
	Start_Cinematic_Camera(false)
	Allow_Localized_SFX(false)
	Enable_Fog(false)

	Lua_Space_Venator = Find_First_Object("CINEMATIC_BOZ_PITY_INTRO")
	Lua_Space_Venator.Hide(true)
	Lua_Space_Venator.Teleport(cinematic_lua_venator_marker)

	cinematic_crawl = true
	MissionUtil.SetCinematicCamera(crawl_cam_1_marker, crawl_cam_target_1_marker, true)

	cinematic_crawl = true
	MissionUtil.PlayCinematicMovieCrawl("Outer_Rim_Sieges_Campaign_Intro", "Clone_Wars_Crawl_Theme")

	if not cinematic_crawl_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_01_CIS")
	end
end

function Start_Cinematic_Intro_01_CIS()
	MissionUtil.TransitionCinematicCamera(crawl_cam_2_marker, crawl_cam_target_2_marker, true, 11.0, nil, nil)

	cinematic_crawl = false
	cinematic_one = true

	MissionUtil.PlayGenericMusic("CW_KenobiVsDurge_Theme")
	MissionUtil.PlayGenericSpeech("Alarm_Sound")
	Letter_Box_In(1.0)
	Sleep(2.0)

	Lua_Space_Venator = Find_First_Object("CINEMATIC_BOZ_PITY_INTRO")
	Lua_Space_Venator.Teleport_And_Face(cinematic_lua_venator_marker)
	Lua_Space_Venator.Hide(true)
	Lua_Space_Venator.Play_Animation("Cinematic", false, 0)
	Lua_Space_Venator.Hide(false)

	MissionUtil.CinematicIntroHeader("GIANTS_GRAVEYARD")
	Sleep(10.0)

	MissionUtil.SetCinematicCamera(cinematic_lua_cam_1_marker, cinematic_lua_cam_1_target_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(cinematic_lua_cam_2_marker, cinematic_lua_cam_1_target_marker, true, 13.0, nil, nil)

	MissionUtil.MissionTextSpeech("GIANTS_GRAVEYARD", 1, 9.0, nil, {r = 255, g = 255, b = 255})
	Sleep(10.0)

	Fade_Screen_Out(3.0)
	MissionUtil.MissionTextSpeech("GIANTS_GRAVEYARD", 2, 6.0, nil, {r = 255, g = 255, b = 255})
	Sleep(6.0)

	MissionUtil.MissionTextSpeech("GIANTS_GRAVEYARD", 3, 4.0, nil, {r = 255, g = 255, b = 255})
	Sleep(4.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_02_CIS")
	end
end
function Start_Cinematic_Intro_02_CIS()
	if TestValid(Find_First_Object("SPACE_STARS")) then
		Find_First_Object("SPACE_STARS").Despawn()
	end
	if TestValid(Find_First_Object("CINEMATIC_BOZ_PITY_INTRO")) then
		Find_First_Object("CINEMATIC_BOZ_PITY_INTRO").Despawn()
	end

	local cis_fleet = Find_All_Objects_Of_Type("CINEMATIC_BOZ_PITY_INTRO_STATIC_CIS")
	for _,cis_unit in pairs(cis_fleet) do
		if TestValid(cis_unit) then
			cis_unit.Despawn()
		end
	end

	local rep_fleet = Find_All_Objects_Of_Type("CINEMATIC_BOZ_PITY_INTRO_STATIC_REP")
	for _,rep_unit in pairs(rep_fleet) do
		if TestValid(rep_unit) then
			rep_unit.Despawn()
		end
	end

	cinematic_one = false
	cinematic_two = true

	Stop_All_Speech()
	MissionUtil.Set_To_Enemies(p_republic, p_cis)

	MissionUtil.CinematicEnvironmentOn()
	Set_Cinematic_Environment(false)
	Enable_Fog(true)
	Sleep(1.0)

	MissionUtil.CinematicMidtroHeader("GIANTS_GRAVEYARD")
	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, true, 10.0, nil, nil)
	Fade_Screen_In(2.0)
	Sleep(9.0)

	Remove_All_Text()
	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_4_marker, true, 15.0, nil, nil)

	MissionUtil.MissionTextSpeech("GIANTS_GRAVEYARD", 4, 4.0, nil, {r = 255, g = 255, b = 255})
	Sleep(5.0)

	MissionUtil.MissionTextSpeech("GIANTS_GRAVEYARD", 5, 5.0, nil, {r = 255, g = 255, b = 255})
	Sleep(6.0)

	MissionUtil.MissionTextSpeech("GIANTS_GRAVEYARD", 6, 4.0, nil, {r = 255, g = 255, b = 255})
	Sleep(5.0)

	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_5_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_6_marker, true, 15.0, nil, nil)
	MissionUtil.MissionTextSpeech("GIANTS_GRAVEYARD", 7, 6.0, nil, {r = 255, g = 255, b = 255})
	Sleep(7.0)
	
	MissionUtil.MissionTextSpeech("GIANTS_GRAVEYARD", 8, 5.0, nil, {r = 255, g = 255, b = 255})
	Sleep(6.0)

	if not cinematic_three_skipped then
		Create_Thread("End_Cinematic_Intro_CIS")
	end
end
function End_Cinematic_Intro_CIS()
	MissionUtil.EndCinematicCamera(Find_First_Object("ATTACKER ENTRY POSITION"), 3.5)
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.AIActivation()

	MissionUtil.Set_To_Enemies(p_cis, p_republic)

	MissionUtil.SetObjectiveMissionSet("GIANTS_GRAVEYARD", "CIS", 4)
	MissionUtil.MissionTextSpeech("GIANTS_GRAVEYARD", 10, 10.0, "Dooku_Loop", {r = 255, g = 255, b = 255})

	MissionUtil.AddToReinforcementPool("B1_DROID_COMPANY", p_cis, 3)
	MissionUtil.AddToReinforcementPool("B2_DROID_COMPANY", p_cis, 3)
	MissionUtil.AddToReinforcementPool("MANDALORIAN_COMMANDO_COMPANY", p_cis, 3)
	MissionUtil.AddToReinforcementPool("NEIMOIDIAN_GUARD_COMPANY", p_cis, 3)
	MissionUtil.AddToReinforcementPool("CIS_AAT_COMPANY", p_cis, 3)
	MissionUtil.AddToReinforcementPool("HAILFIRE_COMPANY", p_cis, 3)
	MissionUtil.AddToReinforcementPool("DWARF_SPIDER_DROID_COMPANY", p_cis, 3)

	MissionUtil.AddToReinforcementPool("CLONETROOPER_PHASE_TWO_COMPANY", p_republic, 3)
	MissionUtil.AddToReinforcementPool("ARC_PHASE_TWO_COMPANY", p_republic, 3)
	MissionUtil.AddToReinforcementPool("CLONE_AIRBORNE_TROOPER_COMPANY", p_republic, 3)
	MissionUtil.AddToReinforcementPool("REPUBLIC_AT_TE_WALKER_COMPANY", p_republic, 3)
	MissionUtil.AddToReinforcementPool("REPUBLIC_ISP_COMPANY", p_republic, 3)
	MissionUtil.AddToReinforcementPool("HAET_COMPANY", p_republic, 3)
	MissionUtil.AddToReinforcementPool("REPUBLIC_TX130T_COMPANY", p_republic, 3)

	cinematic_one = false
	act_1_active = true
end

function Start_Cinematic_Outro_CIS()
	act_1_active = false
	cinematic_three = true

	GlobalValue.Set("MissionOutcome_GIANTS_GRAVEYARD", 1)

	MissionUtil.AllowOrbitalSupport(p_cis, true)
	MissionUtil.AllowOrbitalSupport(p_republic, true)

	MissionUtil.MissionTextSpeech("GIANTS_GRAVEYARD", 13, 8.0, nil, {r = 255, g = 255, b = 255})

	Fade_Screen_Out(3.0)
	Sleep(8.0)

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	MissionUtil.SetCinematicCamera(outrocam_1_marker, outrocam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outrocam_target_2_marker, true, 10.0, nil, nil)

	MissionUtil.MissionTextSpeech("GIANTS_GRAVEYARD", 14, 8.0, nil, {r = 255, g = 255, b = 255})

	Fade_Screen_In(2.0)
	Letter_Box_In(2.0)
	Sleep(9.0)

	Fade_Screen_Out(1.0)
	Sleep(2.0)

	MissionUtil.DisableRetreat("REBEL", false)
	MissionUtil.DisableRetreat("EMPIRE", false)

	MissionUtil.CinematicEnvironmentOff()
	StoryUtil.DeclareVictory(p_republic, false)
end


function Start_Cinematic_Crawl_Rep()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	cinematic_skydome_space = MissionUtil.SpawnUnitGround("SPACE_STARS", space_cinematic_centre_marker, p_republic)

	Weather_Audio_Pause(true)
	Start_Cinematic_Camera(false)
	Allow_Localized_SFX(false)
	Enable_Fog(false)

	Lua_Space_Venator = Find_First_Object("CINEMATIC_BOZ_PITY_INTRO")
	Lua_Space_Venator.Hide(true)
	Lua_Space_Venator.Teleport(cinematic_lua_venator_marker)

	cinematic_crawl = true
	MissionUtil.SetCinematicCamera(crawl_cam_1_marker, crawl_cam_target_1_marker, true)

	cinematic_crawl = true
	MissionUtil.PlayCinematicMovieCrawl("Outer_Rim_Sieges_Campaign_Intro", "Clone_Wars_Crawl_Theme")

	if not cinematic_crawl_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_01_Rep")
	end
end

function Start_Cinematic_Intro_01_Rep()
	MissionUtil.TransitionCinematicCamera(crawl_cam_2_marker, crawl_cam_target_2_marker, true, 11.0, nil, nil)

	cinematic_crawl = false
	cinematic_one = true

	MissionUtil.PlayGenericMusic("CW_KenobiVsDurge_Theme")
	MissionUtil.PlayGenericSpeech("Alarm_Sound")
	Letter_Box_In(1.0)
	Sleep(2.0)

	Lua_Space_Venator = Find_First_Object("CINEMATIC_BOZ_PITY_INTRO")
	Lua_Space_Venator.Teleport_And_Face(cinematic_lua_venator_marker)
	Lua_Space_Venator.Hide(true)
	Lua_Space_Venator.Play_Animation("Cinematic", false, 0)
	Lua_Space_Venator.Hide(false)

	MissionUtil.CinematicIntroHeader("GIANTS_GRAVEYARD")
	Sleep(10.0)

	MissionUtil.SetCinematicCamera(cinematic_lua_cam_1_marker, cinematic_lua_cam_1_target_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(cinematic_lua_cam_2_marker, cinematic_lua_cam_1_target_marker, true, 13.0, nil, nil)

	MissionUtil.MissionTextSpeech("GIANTS_GRAVEYARD", 1, 9.0, nil, {r = 255, g = 255, b = 255})
	Sleep(10.0)

	Fade_Screen_Out(3.0)
	MissionUtil.MissionTextSpeech("GIANTS_GRAVEYARD", 2, 6.0, nil, {r = 255, g = 255, b = 255})
	Sleep(6.0)

	MissionUtil.MissionTextSpeech("GIANTS_GRAVEYARD", 3, 4.0, nil, {r = 255, g = 255, b = 255})
	Sleep(4.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_02_Rep")
	end
end
function Start_Cinematic_Intro_02_Rep()
	if TestValid(Find_First_Object("SPACE_STARS")) then
		Find_First_Object("SPACE_STARS").Despawn()
	end
	if TestValid(Find_First_Object("CINEMATIC_BOZ_PITY_INTRO")) then
		Find_First_Object("CINEMATIC_BOZ_PITY_INTRO").Despawn()
	end

	local cis_fleet = Find_All_Objects_Of_Type("CINEMATIC_BOZ_PITY_INTRO_STATIC_CIS")
	for _,cis_unit in pairs(cis_fleet) do
		if TestValid(cis_unit) then
			cis_unit.Despawn()
		end
	end

	local rep_fleet = Find_All_Objects_Of_Type("CINEMATIC_BOZ_PITY_INTRO_STATIC_REP")
	for _,rep_unit in pairs(rep_fleet) do
		if TestValid(rep_unit) then
			rep_unit.Despawn()
		end
	end

	cinematic_one = false
	cinematic_two = true

	Stop_All_Speech()
	MissionUtil.Set_To_Enemies(p_republic, p_cis)

	MissionUtil.CinematicEnvironmentOn()
	Set_Cinematic_Environment(false)
	Enable_Fog(true)
	Sleep(1.0)

	MissionUtil.CinematicMidtroHeader("GIANTS_GRAVEYARD")
	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, true, 10.0, nil, nil)
	Fade_Screen_In(2.0)
	Sleep(9.0)

	Remove_All_Text()
	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_4_marker, true, 15.0, nil, nil)

	MissionUtil.MissionTextSpeech("GIANTS_GRAVEYARD", 4, 4.0, nil, {r = 255, g = 255, b = 255})
	Sleep(5.0)

	MissionUtil.MissionTextSpeech("GIANTS_GRAVEYARD", 5, 5.0, nil, {r = 255, g = 255, b = 255})
	Sleep(6.0)

	MissionUtil.MissionTextSpeech("GIANTS_GRAVEYARD", 6, 4.0, nil, {r = 255, g = 255, b = 255})
	Sleep(5.0)

	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_5_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_6_marker, true, 15.0	, nil, nil)
	MissionUtil.MissionTextSpeech("GIANTS_GRAVEYARD", 7, 6.0, nil, {r = 255, g = 255, b = 255})
	Sleep(7.0)
	
	MissionUtil.MissionTextSpeech("GIANTS_GRAVEYARD", 8, 5.0, nil, {r = 255, g = 255, b = 255})
	Sleep(6.0)

	if not cinematic_three_skipped then
		Create_Thread("End_Cinematic_Intro_Rep")
	end
end
function End_Cinematic_Intro_Rep()
	MissionUtil.EndCinematicCamera(Find_First_Object("ATTACKER ENTRY POSITION"), 3.5)
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.AIActivation()

	MissionUtil.Set_To_Enemies(p_cis, p_republic)

	MissionUtil.SetObjectiveMissionSet("GIANTS_GRAVEYARD", "REP", 5)
	MissionUtil.MissionTextSpeech("GIANTS_GRAVEYARD", 9, 10.0, "Mace_Loop", {r = 255, g = 255, b = 255})

	MissionUtil.AddToReinforcementPool("B1_DROID_COMPANY", p_cis, 3)
	MissionUtil.AddToReinforcementPool("B2_DROID_COMPANY", p_cis, 3)
	MissionUtil.AddToReinforcementPool("MANDALORIAN_COMMANDO_COMPANY", p_cis, 3)
	MissionUtil.AddToReinforcementPool("NEIMOIDIAN_GUARD_COMPANY", p_cis, 3)
	MissionUtil.AddToReinforcementPool("CIS_AAT_COMPANY", p_cis, 3)
	MissionUtil.AddToReinforcementPool("HAILFIRE_COMPANY", p_cis, 3)
	MissionUtil.AddToReinforcementPool("DWARF_SPIDER_DROID_COMPANY", p_cis, 3)

	MissionUtil.AddToReinforcementPool("CLONETROOPER_PHASE_TWO_COMPANY", p_republic, 3)
	MissionUtil.AddToReinforcementPool("ARC_PHASE_TWO_COMPANY", p_republic, 3)
	MissionUtil.AddToReinforcementPool("CLONE_AIRBORNE_TROOPER_COMPANY", p_republic, 3)
	MissionUtil.AddToReinforcementPool("REPUBLIC_AT_TE_WALKER_COMPANY", p_republic, 3)
	MissionUtil.AddToReinforcementPool("REPUBLIC_ISP_COMPANY", p_republic, 3)
	MissionUtil.AddToReinforcementPool("HAET_COMPANY", p_republic, 3)
	MissionUtil.AddToReinforcementPool("REPUBLIC_TX130T_COMPANY", p_republic, 3)

	cinematic_one = false
	act_1_active = true
end

function Start_Cinematic_Outro_Rep()
	act_1_active = false
	cinematic_three = true

	GlobalValue.Set("MissionOutcome_GIANTS_GRAVEYARD", 0)

	MissionUtil.AllowOrbitalSupport(p_cis, true)
	MissionUtil.AllowOrbitalSupport(p_republic, true)

	MissionUtil.MissionTextSpeech("GIANTS_GRAVEYARD", 11, 8.0, nil, {r = 255, g = 255, b = 255})

	Fade_Screen_Out(3.0)
	Sleep(8.0)

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	MissionUtil.SetCinematicCamera(outrocam_1_marker, outrocam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outrocam_target_2_marker, true, 10.0, nil, nil)

	MissionUtil.MissionTextSpeech("GIANTS_GRAVEYARD", 12, 8.0, nil, {r = 255, g = 255, b = 255})

	Fade_Screen_In(2.0)
	Letter_Box_In(2.0)
	Sleep(9.0)


	Fade_Screen_Out(1.0)
	Sleep(2.0)

	MissionUtil.DisableRetreat("REBEL", false)
	MissionUtil.DisableRetreat("EMPIRE", false)

	MissionUtil.CinematicEnvironmentOff()
	StoryUtil.DeclareVictory(p_republic, false)
end
