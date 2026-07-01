
--*****************************************************--
--****** Tennuutta Skirmishes: Venator Venture ********--
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
		Battle_Start = Begin_Battle
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")
	p_neutral = Find_Player("Neutral")

	explosion_list = {"HUGE_EXPLOSION_LAND"}

	PrimarySkydomeList_Phase_01 = {"Space_Stars"}

	act_1_active = false

	battle_over = false

	cinematic_one = false
	cinematic_two = false

	cinematic_one_skipped = false
	cinematic_two_skipped = false

	mission_started = false
end
function Begin_Battle(message)
	if message == OnEnter then

		MissionUtil.VictoryAllowance(false)

		MissionUtil.DisableRetreat("REBEL", true)
		MissionUtil.DisableRetreat("EMPIRE", true)

		MissionUtil.AllowOrbitalSupport(p_cis, false)
		MissionUtil.AllowOrbitalSupport(p_republic, false)

		p_cis.Make_Ally(p_republic)
		p_republic.Make_Ally(p_cis)

		space_cinematic_centre_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cinematic-centre")
		Promote_To_Space_Cinematic_Layer(space_cinematic_centre_marker)

		cinematic_lua_venator_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "venator-start")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_venator_marker)

		crawl_cam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawl-cam-1")
		Promote_To_Space_Cinematic_Layer(crawl_cam_1_marker)

		crawl_cam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawl-cam-2")
		Promote_To_Space_Cinematic_Layer(crawl_cam_2_marker)

		crawl_cam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawl-cam-target-1")
		Promote_To_Space_Cinematic_Layer(crawl_cam_target_1_marker)

		crawl_cam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crawl-cam-target-2")
		Promote_To_Space_Cinematic_Layer(crawl_cam_target_2_marker)

		attacker_marker = Find_Hint("ATTACKER ENTRY POSITION")

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-4")
		introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-5")
		introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-6")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")

		outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-1")
		outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-2")
		outrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-3")

		outrocam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-1")
		outrocam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-2")

		defender_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-1")
		defender_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-2")
		defender_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-3")
		defender_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-4")
		defender_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-5")
		defender_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-6")
		defender_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-7")

		p_generator = Find_Hint("POWER_GENERATOR", "generator")

		Set_Cinematic_Environment(true)
		Fade_On()

		if p_cis.Is_Human() then
			mission_started = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Crawl_CIS")
		elseif p_republic.Is_Human() then
			mission_started = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Crawl_Rep")
		end
	end
end


function State_Hero_Death()
	if not TestValid(player_anakin) then
		MissionUtil.SetMissionObjectiveFailed("VENATOR_VENTURE", "REP", 3)
	end
	if not TestValid(player_ahsoka) then
		MissionUtil.SetMissionObjectiveFailed("VENATOR_VENTURE", "REP", 4)
	end
	if not TestValid(player_rex) then
		MissionUtil.SetMissionObjectiveFailed("VENATOR_VENTURE", "REP", 5)
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

				if TestValid(Find_First_Object("SPACE_STARS")) then
					Find_First_Object("SPACE_STARS").Despawn()
				end
				if TestValid(Find_First_Object("CINEMATIC_QUELL_LOW_ORBIT")) then
					Find_First_Object("CINEMATIC_QUELL_LOW_ORBIT").Despawn()
				end

				MissionUtil.Set_To_Enemies(p_cis, p_republic)
				MissionUtil.CinematicSkippingCleanUp(attacker_marker)

				MissionUtil.SpawnListSpawner("B2_RP_DROID_COMPANY", attacker_marker, p_cis, 3, true)
				MissionUtil.SpawnListSpawner("B2_DROID_COMPANY", attacker_marker, p_cis, 3, true)

				MissionUtil.SetObjectiveMissionSet("VENATOR_VENTURE", "CIS", 2)

				cinematic_two = false
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

				MissionUtil.AllowOrbitalSupport(p_cis, true)
				MissionUtil.AllowOrbitalSupport(p_republic, true)

				MissionUtil.DisableRetreat("REBEL", false)
				MissionUtil.DisableRetreat("EMPIRE", false)

				MissionUtil.CinematicSkippingCleanUp(attacker_marker)

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

					--StoryUtil.DeclareVictory(p_republic, false)

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

				if TestValid(Find_First_Object("SPACE_STARS")) then
					Find_First_Object("SPACE_STARS").Despawn()
				end
				if TestValid(Find_First_Object("CINEMATIC_QUELL_LOW_ORBIT")) then
					Find_First_Object("CINEMATIC_QUELL_LOW_ORBIT").Despawn()
				end

				MissionUtil.Set_To_Enemies(p_cis, p_republic)
				MissionUtil.CinematicSkippingCleanUp(attacker_marker)

				UnitUtil.DespawnList({"LAAT_LANDING_CRAFT_LANDING"})
				MissionUtil.SpawnListSpawner("REPUBLIC_LAAT_COMPANY", attacker_marker, p_republic, 1, true)

				player_anakin = MissionUtil.SpawnUnitGround("ANAKIN", attacker_marker, p_republic)
				Register_Death_Event(player_anakin, State_Hero_Death)
				player_ahsoka = MissionUtil.SpawnUnitGround("AHSOKA", attacker_marker, p_republic)
				Register_Death_Event(player_ahsoka, State_Hero_Death)

				if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
					player_rex = MissionUtil.SpawnUnitGround("REX2", attacker_marker, p_republic)
					Register_Death_Event(player_rex, State_Hero_Death)

				else
					player_rex = MissionUtil.SpawnUnitGround("REX", attacker_marker, p_republic)
					Register_Death_Event(player_rex, State_Hero_Death)

				end
				MissionUtil.SetObjectiveMissionSet("VENATOR_VENTURE", "REP", 4)

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

				MissionUtil.AllowOrbitalSupport(p_cis, true)
				MissionUtil.AllowOrbitalSupport(p_republic, true)

				MissionUtil.DisableRetreat("REBEL", false)
				MissionUtil.DisableRetreat("EMPIRE", false)

				MissionUtil.CinematicSkippingCleanUp(attacker_marker)

				StoryUtil.DeclareVictory(p_republic, false)
			end
		end
	end
end
function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_1_active then
			local cis_list = Find_All_Objects_Of_Type(p_cis, "Vehicle | Infantry | AirGunship | AirSpeeder | Structure")
			if (table.getn(cis_list) == 0) then
				act_1_active = false
				if not battle_over then
					battle_over = true
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
				end
			end
			if not TestValid(p_generator) then
				if not battle_over then
					battle_over = true
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
				end
			end
		end
	elseif p_republic.Is_Human() then
		if act_1_active then
			local cis_list = Find_All_Objects_Of_Type(p_cis, "Vehicle | Infantry | AirGunship | AirSpeeder")
			if (table.getn(cis_list) == 0) then
				if not battle_over then
					battle_over = true
					StoryUtil.TriggerScriptedBattle("CRASH_COURSE", "QUELL", "LAND", "EMPIRE", "REBEL", false)
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
				end
			end
			local rep_list = Find_All_Objects_Of_Type(p_republic, "Vehicle | Infantry | AirGunship | AirSpeeder | InfantryHero | VehicleHero")
			if (table.getn(rep_list) == 0) then
				if not battle_over then
					battle_over = true
					StoryUtil.TriggerScriptedBattle("VENATOR_VENTURE", "QUELL", "LAND", "EMPIRE", "REBEL", false)
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
				end
			end
		end
	end
end


function Start_Cinematic_Crawl_CIS()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	primary_space_skydome_list = SpawnList(PrimarySkydomeList_Phase_01, space_cinematic_centre_marker, p_republic, false, false)
	cinematic_skydome_01 = primary_space_skydome_list[1]
	cinematic_skydome_01.Teleport_And_Face(space_cinematic_centre_marker)

	Weather_Audio_Pause(true)
	Start_Cinematic_Camera(false)
	Allow_Localized_SFX(false)
	Enable_Fog(false)

	Lua_Space_Venator_List = Find_All_Objects_Of_Type("CINEMATIC_QUELL_LOW_ORBIT")
	Lua_Space_Venator = Lua_Space_Venator_List[1]

	Lua_Space_Venator.Hide(true)
	Lua_Space_Venator.Teleport(cinematic_lua_venator_marker)

	cinematic_crawl = true
	MissionUtil.SetCinematicCamera(crawl_cam_1_marker, crawl_cam_target_1_marker, true, nil, nil)

	if (GlobalValue.Get("Tennuutta_CIS_GC_Version") == 0) then
		MissionUtil.PlayCinematicMovieCrawl("Tennuutta_Skirmishes_Campaign_Intro", "Clone_Wars_Crawl_Theme")
	else
		MissionUtil.PlayCinematicMovieCrawl("Tennuutta_Skirmishes_CIS_AU_Campaign_Intro", "Clone_Wars_Crawl_Theme")
	end

	Set_Cinematic_Environment(false)
	if not cinematic_crawl_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
	end
end

function Start_Cinematic_Intro_CIS()
	MissionUtil.TransitionCinematicCamera(crawl_cam_2_marker, crawl_cam_target_2_marker, true, 10.0, nil, nil)

	Lua_Space_Venator_List = Find_All_Objects_Of_Type("CINEMATIC_QUELL_LOW_ORBIT")
	Lua_Space_Venator = Lua_Space_Venator_List[1]

	Lua_Space_Venator.Play_Animation("Cinematic", false, 0)
	Lua_Space_Venator.Hide(false)

	MissionUtil.AddToReinforcementPool("CIS_STAP_COMPANY", p_cis, 2)
	MissionUtil.AddToReinforcementPool("B1_DROID_MARINE_COMPANY", p_cis, 3)
	MissionUtil.AddToReinforcementPool("B2_RP_DROID_COMPANY", p_cis, 3)
	MissionUtil.AddToReinforcementPool("B2_DROID_COMPANY", p_cis, 3)
	MissionUtil.AddToReinforcementPool("MAGNA_OCTUPTARRA_COMPANY", p_cis, 2)

	MissionUtil.SpawnListSpawner("REPUBLIC_NAVY_TROOPER_COMPANY", defender_1_marker, p_republic, 2, true)
	MissionUtil.SpawnListSpawner("REPUBLIC_LAAT_COMPANY", defender_2_marker, p_republic, 1, true)
	MissionUtil.SpawnListSpawner("CLONE_JUMPTROOPER_PHASE_ONE_COMPANY", defender_3_marker, p_republic, 3, true)
	MissionUtil.SpawnListSpawner("CLONE_JUMPTROOPER_PHASE_ONE_COMPANY", defender_4_marker, p_republic, 3, true)
	MissionUtil.SpawnListSpawner("CLONETROOPER_PHASE_ONE_COMPANY", defender_7_marker, p_republic, 2, true)

	cinematic_crawl = false
	cinematic_one = true

	MissionUtil.PlayGenericSpeech("Venator_Venture_01")
	MissionUtil.PlayGenericMusic("Silence_Theme")
	Letter_Box_In(1.0)
	Sleep(9.0)

	Fade_Screen_Out(1)
	Sleep(3.0)

	if TestValid(Find_First_Object("SPACE_STARS")) then
		Find_First_Object("SPACE_STARS").Despawn()
	end
	if TestValid(Find_First_Object("CINEMATIC_QUELL_LOW_ORBIT")) then
		Find_First_Object("CINEMATIC_QUELL_LOW_ORBIT").Despawn()
	end

	Enable_Fog(true)

	Sleep(1.0)

	MissionUtil.CinematicIntroHeader("VENATOR_VENTURE")

	Fade_Screen_In(2.5)
	Letter_Box_In(2.5)
	Sleep(9.0)

	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_1_marker, true, 4.0, nil, nil)
	Sleep(4.0)

	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_2_marker, true, 6.0, nil, nil)
	Sleep(4.0)

	MissionUtil.SetCinematicCamera(introcam_target_2_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(attacker_marker, introcam_target_1_marker, true, 5.5, nil, nil)
	Sleep(5.0)

	MissionUtil.SpawnListSpawner("B2_RP_DROID_COMPANY", attacker_marker, p_cis, 3, true)
	MissionUtil.SpawnListSpawner("B2_DROID_COMPANY", attacker_marker, p_cis, 3, true)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end
function End_Cinematic_Intro_CIS()
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(attacker_marker, 3.0)
	Sleep(3.0)

	p_republic.Make_Enemy(p_cis)
	p_cis.Make_Enemy(p_republic)

	MissionUtil.SetObjectiveMissionSet("VENATOR_VENTURE", "CIS", 2)
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.AIActivation()

	current_cinematic_thread_id = nil

	cinematic_one = false
	act_1_active = true
end

function Start_Cinematic_Outro_CIS()
	MissionUtil.AllowOrbitalSupport(p_cis, true)
	MissionUtil.AllowOrbitalSupport(p_republic, true)

	act_1_active = false
	cinematic_two = true

	Fade_Screen_Out(3.0)
	Sleep(3.0)

	MissionUtil.CinematicEnvironmentOn()
	MissionUtil.StartCinematicCamera()
	Do_End_Cinematic_Cleanup()
	Fade_Screen_In(2.0)

	MissionUtil.PlayGenericSpeech("Venator_Venture_03")
	MissionUtil.PlayGenericMusic("Silence_Theme")

	MissionUtil.SetCinematicCamera(outrocam_1_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_2_marker, introcam_target_2_marker, true, 8.0, nil, nil)
	Sleep(8.0)

	--MissionUtil.PlayAnimation(Find_First_Object("TR_SHIP_Venator_Damaged_Small"), "Cinematic")

	MissionUtil.SetCinematicCamera(outrocam_3_marker, introcam_target_1_marker, true, nil, nil)
	Cinematic_Zoom(12, 6.0)

	MissionUtil.CinematicEnvironmentOff()
	Fade_Screen_Out(4.0)
	Sleep(5.0)

	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.DisableRetreat("REBEL", false)
	MissionUtil.DisableRetreat("EMPIRE", false)

	StoryUtil.DeclareVictory(p_cis, false)
end


function Start_Cinematic_Crawl_Rep()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	primary_space_skydome_list = SpawnList(PrimarySkydomeList_Phase_01, space_cinematic_centre_marker, p_republic, false, false)
	cinematic_skydome_01 = primary_space_skydome_list[1]
	cinematic_skydome_01.Teleport_And_Face(space_cinematic_centre_marker)

	Weather_Audio_Pause(true)
	Start_Cinematic_Camera(false)
	Allow_Localized_SFX(false)
	Enable_Fog(false)

	Lua_Space_Venator_List = Find_All_Objects_Of_Type("CINEMATIC_QUELL_LOW_ORBIT")
	Lua_Space_Venator = Lua_Space_Venator_List[1]

	Lua_Space_Venator.Hide(true)
	Lua_Space_Venator.Teleport(cinematic_lua_venator_marker)

	cinematic_crawl = true
	MissionUtil.SetCinematicCamera(crawl_cam_1_marker, crawl_cam_target_1_marker, true, nil, nil)

	if (GlobalValue.Get("Tennuutta_Rep_GC_Version") == 0) then
		MissionUtil.PlayCinematicMovieCrawl("Tennuutta_Skirmishes_Campaign_Intro", "Clone_Wars_Crawl_Theme")
	else
		MissionUtil.PlayCinematicMovieCrawl("Tennuutta_Skirmishes_Rep_AU_Campaign_Intro", "Clone_Wars_Crawl_Theme")
	end

	Set_Cinematic_Environment(false)
	if not cinematic_crawl_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
	end
end

function Start_Cinematic_Intro_Rep()
	MissionUtil.TransitionCinematicCamera(crawl_cam_2_marker, crawl_cam_target_2_marker, true, 10.0, nil, nil)

	Lua_Space_Venator_List = Find_All_Objects_Of_Type("CINEMATIC_QUELL_LOW_ORBIT")
	Lua_Space_Venator = Lua_Space_Venator_List[1]

	Lua_Space_Venator.Play_Animation("Cinematic", false, 0)
	Lua_Space_Venator.Hide(false)

	MissionUtil.AddToReinforcementPool("REPUBLIC_LAAT_COMPANY", p_republic, 2)

	if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
		MissionUtil.AddToReinforcementPool("CLONE_JUMPTROOPER_PHASE_TWO_COMPANY", p_republic, 3)
		MissionUtil.AddToReinforcementPool("CLONETROOPER_PHASE_TWO_COMPANY", p_republic, 3)
		MissionUtil.AddToReinforcementPool("ARC_PHASE_TWO_COMPANY", p_republic, 4)

	else
		MissionUtil.AddToReinforcementPool("CLONE_JUMPTROOPER_PHASE_ONE_COMPANY", p_republic, 3)
		MissionUtil.AddToReinforcementPool("CLONETROOPER_PHASE_ONE_COMPANY", p_republic, 3)
		MissionUtil.AddToReinforcementPool("ARC_PHASE_ONE_COMPANY", p_republic, 4)

	end

	--MissionUtil.SpawnListSpawner("B1_DROID_COMPANY", defender_1_marker, p_cis, 1, true)
	--MissionUtil.SpawnListSpawner("MAGNA_OCTUPTARRA_COMPANY", defender_2_marker, p_cis, 1, true)
	--MissionUtil.SpawnListSpawner("B2_RP_DROID_COMPANY", defender_3_marker, p_cis, 2, true)
	--MissionUtil.SpawnListSpawner("B2_DROID_COMPANY", defender_4_marker, p_cis, 1, true)
	--MissionUtil.SpawnListSpawner("B2_DROID_COMPANY", defender_5_marker, p_cis, 2, true)
	--MissionUtil.SpawnListSpawner("MAGNA_OCTUPTARRA_COMPANY", defender_6_marker, p_cis, 1, true)

	if TestValid(p_generator) then
		p_generator.Despawn()
	end

	cinematic_crawl = false
	cinematic_one = true

	MissionUtil.PlayGenericSpeech("Venator_Venture_02")
	MissionUtil.PlayGenericMusic("Silence_Theme")
	Letter_Box_In(1.0)
	Sleep(9.0)

	Fade_Screen_Out(1.0)
	Sleep(4.0)

	if TestValid(Find_First_Object("SPACE_STARS")) then
		Find_First_Object("SPACE_STARS").Despawn()
	end
	if TestValid(Find_First_Object("CINEMATIC_QUELL_LOW_ORBIT")) then
		Find_First_Object("CINEMATIC_QUELL_LOW_ORBIT").Despawn()
	end

	Enable_Fog(true)

	Sleep(1.0)

	MissionUtil.CinematicIntroHeader("VENATOR_VENTURE")

	MissionUtil.SetCinematicCamera(introcam_6_marker, introcam_target_1_marker, true, nil, nil)
	Transition_Cinematic_Camera_Key(introcam_5_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_5_marker, 10.0, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)

	Fade_Screen_In(2.5)
	Letter_Box_In(2.5)
	Sleep(9.0)

	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_1_marker, true, 4.0, nil, nil)
	Sleep(4.0)

	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_2_marker, true, 6.0, nil, nil)
	Sleep(3.0)

	laat_lander = MissionUtil.CreateCinematicLander("LAAT_Landing_Craft_Landing", attacker_marker, p_republic, 5.0, false, "LANDING", 0)

	MissionUtil.SetCinematicCamera(introcam_target_2_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(attacker_marker, introcam_target_1_marker, true, 5.5, nil, nil)
	Sleep(5.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Rep")
	end
end
function End_Cinematic_Intro_Rep()
	UnitUtil.DespawnList({"LAAT_LANDING_CRAFT_LANDING"})
	MissionUtil.SpawnListSpawner("REPUBLIC_LAAT_COMPANY", attacker_marker, p_republic, 1, true)

	player_anakin = MissionUtil.SpawnUnitGround("ANAKIN", attacker_marker, p_republic)
	Register_Death_Event(player_anakin, State_Hero_Death)
	player_ahsoka = MissionUtil.SpawnUnitGround("AHSOKA", attacker_marker, p_republic)
	Register_Death_Event(player_ahsoka, State_Hero_Death)

	if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
		player_rex = MissionUtil.SpawnUnitGround("REX2", attacker_marker, p_republic)
		Register_Death_Event(player_rex, State_Hero_Death)

	else
		player_rex = MissionUtil.SpawnUnitGround("REX", attacker_marker, p_republic)
		Register_Death_Event(player_rex, State_Hero_Death)

	end

	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(attacker_marker, 2.0)
	Sleep(2.0)

	p_republic.Make_Enemy(p_cis)
	p_cis.Make_Enemy(p_republic)

	MissionUtil.SetObjectiveMissionSet("VENATOR_VENTURE", "REP", 4)
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.AIActivation()

	current_cinematic_thread_id = nil

	cinematic_one = false
	act_1_active = true
end

function Start_Cinematic_Outro_Rep()
	MissionUtil.AllowOrbitalSupport(p_cis, true)
	MissionUtil.AllowOrbitalSupport(p_republic, true)

	Fade_Screen_Out(3.0)
	Sleep(3.0)

	MissionUtil.DisableRetreat("REBEL", false)
	MissionUtil.DisableRetreat("EMPIRE", false)

	StoryUtil.DeclareVictory(p_republic, false)

	act_1_active = false
	cinematic_two = true
end
