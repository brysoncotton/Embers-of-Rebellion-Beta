
--*****************************************************--
--****** Tennuutta Skirmishes: Maridun Marauder *******--
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

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")
	p_neutral = Find_Player("Neutral")

	act_1_active = false

	cinematic_one = false
	cinematic_two = false

	cinematic_one_skipped = false
	cinematic_two_skipped = false

	anakin_hangar_reached = false
	ahsoka_hangar_reached = false
	aayla_hangar_reached = false
	rex_hangar_reached = false
	bly_hangar_reached = false

	mission_started = false
	mission_over = false
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

		outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-1")
		outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-2")
		outrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-3")
		outrocam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-4")
		outrocam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-5")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")
		introcam_target_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-4")
		introcam_target_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-5")

		outrocam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-1")
		outrocam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-2")

		intro_1_anakin_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-anakin")
		outro_1_anakin_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-1-anakin")

		intro_1_ahsoka_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-ahsoka")
		outro_1_ahsoka_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-1-ahsoka")

		intro_1_aayla_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-aayla")
		outro_1_aayla_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-1-aayla")

		intro_1_rex_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-rex")
		intro_1_bly_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bly")

		intro_1_lurmen_leader_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-lurmen-leader")
		outro_1_lurmen_leader_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-1-lurmen-leader")

		intro_1_lurmen_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-lurmen-1")
		outro_1_lurmen_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-1-lurmen-1")

		intro_1_lurmen_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-lurmen-2")

		intro_1_durd_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "durd")

		c9979_lander_1_marker = Find_Hint("PROP_C9979_LANDER_FULL", "lander-1")
		c9979_lander_2_marker = Find_Hint("PROP_C9979_LANDER_FULL", "lander-2")
		c9979_lander_3_marker = Find_Hint("PROP_C9979_LANDER_FULL", "lander-3")

		player_lurmen_leader = Find_Hint("PARTISAN_EWOK_CHIEFTAIN", "lurmen-leader")
		player_lurmen_1 = Find_Hint("PARTISAN_EWOK_WARRIOR", "lurmen-1")
		player_lurmen_2 = Find_Hint("PARTISAN_EWOK_BRAVE", "lurmen-2")

		player_anakin = Find_First_Object("ANAKIN")
		Register_Death_Event(player_anakin, State_Hero_Death)
		FogOfWar.Reveal(p_republic, player_anakin, 5000)

		player_ahsoka = Find_First_Object("AHSOKA")
		Register_Death_Event(player_ahsoka, State_Hero_Death)

		if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
			Find_First_Object("REX").Despawn()

			player_rex = Find_First_Object("REX2")
			Register_Death_Event(player_rex, State_Hero_Death)
		else
			Find_First_Object("REX2").Despawn()

			player_rex = Find_First_Object("REX")
			Register_Death_Event(player_rex, State_Hero_Death)
		end

		player_aayla = Find_First_Object("AAYLA_SECURA")
		Register_Death_Event(player_aayla, State_Hero_Death)

		if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
			Find_First_Object("BLY").Despawn()

			player_bly = Find_First_Object("BLY2")
			Register_Death_Event(player_bly, State_Hero_Death)
		else
			Find_First_Object("BLY2").Despawn()

			player_bly = Find_First_Object("BLY")
			Register_Death_Event(player_bly, State_Hero_Death)
		end

		player_durd = Find_First_Object("LOK_DURD_DEFOLIATOR")
		Register_Death_Event(player_durd, State_Hero_Death)

		if p_cis.Is_Human() then
			mission_started = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
		elseif p_republic.Is_Human() then
			mission_started = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
		end
	end
end

function State_Hero_Death()
	if p_cis.Is_Human() then
		if not TestValid(player_durd) then
			MissionUtil.SetMissionObjectiveFailed("MARIDUN_MARAUDER", "CIS", 3)
			StoryUtil.TriggerScriptedBattle("MARIDUN_MARAUDER", "MARIDUN", "LAND", "EMPIRE", "REBEL", false)
			StoryUtil.DeclareVictory(p_republic, false)
		end
	elseif p_republic.Is_Human() then
		if not TestValid(player_aayla) then
			MissionUtil.SetMissionObjectiveFailed("MARIDUN_MARAUDER", "REP", 3)
			StoryUtil.TriggerScriptedBattle("MARIDUN_MARAUDER", "MARIDUN", "LAND", "EMPIRE", "REBEL", false)
			StoryUtil.DeclareVictory(p_cis, false)
		end
		if not TestValid(player_anakin) then
			MissionUtil.SetMissionObjectiveFailed("MARIDUN_MARAUDER", "REP", 4)
			StoryUtil.TriggerScriptedBattle("MARIDUN_MARAUDER", "MARIDUN", "LAND", "EMPIRE", "REBEL", false)
			StoryUtil.DeclareVictory(p_cis, false)
		end
		if not TestValid(player_ahsoka) then
			MissionUtil.SetMissionObjectiveFailed("MARIDUN_MARAUDER", "REP", 5)
			StoryUtil.TriggerScriptedBattle("MARIDUN_MARAUDER", "MARIDUN", "LAND", "EMPIRE", "REBEL", false)
			StoryUtil.DeclareVictory(p_cis, false)
		end
		if not TestValid(player_bly) then
			MissionUtil.SetMissionObjectiveFailed("MARIDUN_MARAUDER", "REP", 6)
			StoryUtil.TriggerScriptedBattle("MARIDUN_MARAUDER", "MARIDUN", "LAND", "EMPIRE", "REBEL", false)
			StoryUtil.DeclareVictory(p_cis, false)
		end
		if not TestValid(player_rex) then
			MissionUtil.SetMissionObjectiveFailed("MARIDUN_MARAUDER", "REP", 7)
			StoryUtil.TriggerScriptedBattle("MARIDUN_MARAUDER", "MARIDUN", "LAND", "EMPIRE", "REBEL", false)
			StoryUtil.DeclareVictory(p_cis, false)
		end

		if not TestValid(player_durd) then
			MissionUtil.SetMissionObjectiveComplete("MARIDUN_MARAUDER", "REP", 2)
		end
	end
end
function State_CIS_Spawner()
	MissionUtil.AddToReinforcementPool("B1_DROID_COMPANY", p_cis, 2)
	MissionUtil.AddToReinforcementPool("B2_DROID_COMPANY", p_cis, 2)
	MissionUtil.AddToReinforcementPool("DEFOLIATOR_COMPANY", p_cis, 1)
	MissionUtil.AddToReinforcementPool("DEFOLIATOR_COMPANY", p_cis, 1)
	Sleep(6.0)
	act_1_active = true
	MissionUtil.CinematicEnvironmentOff()

	if p_cis.Is_Human() then
		MissionUtil.AddToReinforcementPool("B1_DROID_COMPANY", p_cis, 3)
		MissionUtil.AddToReinforcementPool("B2_DROID_COMPANY", p_cis, 3)
		MissionUtil.AddToReinforcementPool("DEFOLIATOR_COMPANY", p_cis, 2)
		MissionUtil.AddToReinforcementPool("STAP_COMPANY", p_cis, 2)

		local marker_list = Find_All_Objects_With_Hint("clone")
		for k, marker in pairs(marker_list) do
			if TestValid(marker) then
				MissionUtil.SpawnListSpawner("ARC_PHASE_ONE_COMPANY", marker, p_republic, 1)
			end
		end
	elseif p_republic.Is_Human() then
		MissionUtil.SpawnListSpawner("LOK_DURD_DEFOLIATOR_TEAM", intro_1_durd_marker, p_cis, 1)

		local marker_list = Find_All_Objects_With_Hint("b1")
		for k, marker in pairs(marker_list) do
			if TestValid(marker) then
				MissionUtil.SpawnListSpawner("B1_DROID_COMPANY", marker, p_cis, 1)
			end
		end

		local marker_list = Find_All_Objects_With_Hint("b2")
		for k, marker in pairs(marker_list) do
			if TestValid(marker) then
				MissionUtil.SpawnListSpawner("B2_DROID_COMPANY", marker, p_cis, 1)
			end
		end

		local marker_list = Find_All_Objects_With_Hint("aat")
		for k, marker in pairs(marker_list) do
			if TestValid(marker) then
				MissionUtil.SpawnListSpawner("DEFOLIATOR_COMPANY", marker, p_cis, 1)
			end
		end
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

				MissionUtil.CinematicSkippingCleanUp(intro_1_durd_marker)

				MissionUtil.SetObjectiveMissionSet("MARIDUN_MARAUDER", "CIS", 3)

				if not TestValid(player_durd) then
					player_durd = MissionUtil.SpawnUnitGround("LOK_DURD_DEFOLIATOR_TEAM", intro_1_durd_marker, p_cis)
				end

				player_lurmen_leader.Despawn()
				player_lurmen_1.Despawn()
				player_lurmen_2.Despawn()

				Create_Thread("State_CIS_Spawner")

				dwelling_list = Find_All_Objects_Of_Type("MISSION_LURMEN_DWELLING")
				for _,p_dwelling in pairs(dwelling_list) do
					MissionUtil.HighlightObject(true, p_dwelling, "p_dwelling_blip")
				end

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

				MissionUtil.CinematicSkippingCleanUp(player_anakin)

				MissionUtil.SetObjectiveMissionSet("MARIDUN_MARAUDER", "REP", 7)

				player_lurmen_leader.Despawn()
				player_lurmen_1.Despawn()
				player_lurmen_2.Despawn()

				Create_Thread("State_CIS_Spawner")

				cinematic_one = false

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

				MissionUtil.CinematicSkippingCleanUp(player_anakin)

				StoryUtil.DeclareVictory(p_republic, false)
			end
		end
	end
end
function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_1_active then
			dwelling_list = Find_All_Objects_Of_Type("MISSION_LURMEN_DWELLING")
			if (table.getn(dwelling_list) == 0) then
				StoryUtil.DeclareVictory(p_cis, false)
			end
		end
	elseif p_republic.Is_Human() then
		if act_1_active then
			local cis_list = Find_All_Objects_Of_Type(p_cis, "Vehicle | InfantryHero | VehicleHero")
			local cis_list2 = Find_All_Objects_Of_Type("AAT")
			if (table.getn(cis_list) == 0) and (table.getn(cis_list2) == 0) and not TestValid(player_durd) then
				if not mission_over then
					mission_over = true
					act_1_active = false
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
				end
			end
			dwelling_list = Find_All_Objects_Of_Type("MISSION_LURMEN_DWELLING")
			if (table.getn(dwelling_list) == 0) then
				act_1_active = false
				MissionUtil.SetMissionObjectiveFailed("MARIDUN_MARAUDER", "REP", 1)
				StoryUtil.TriggerScriptedBattle("MARIDUN_MARAUDER", "MARIDUN", "LAND", "REBEL", "EMPIRE", false)
				MissionUtil.VictoryAllowance(true)
				StoryUtil.DeclareVictory(p_cis, false)
			end
		end
	end
end

function Start_Cinematic_Intro_CIS()
	cinematic_one = true

	player_aayla.Teleport_And_Face(intro_1_aayla_marker)
	player_anakin.Teleport_And_Face(intro_1_anakin_marker)
	player_ahsoka.Teleport_And_Face(intro_1_ahsoka_marker)
	player_bly.Teleport_And_Face(intro_1_bly_marker)
	player_rex.Teleport_And_Face(intro_1_rex_marker)

	player_lurmen_leader.Teleport_And_Face(intro_1_lurmen_leader_marker)
	player_lurmen_1.Teleport_And_Face(intro_1_lurmen_1_marker)
	player_lurmen_2.Teleport_And_Face(intro_1_lurmen_2_marker)

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	Sleep(1.0)

	MissionUtil.PlayGenericSpeech("Maridun_Marauder_01")
	MissionUtil.PlayGenericMusic("Silence_Theme")

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, true, 7.5, nil, nil)

	Fade_Screen_In(3.0)
	Letter_Box_In(3.0)
	Sleep(7.5)

	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_2_marker, true, 8.5, nil, nil)
	Sleep(8.5)

	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_3_marker, true, 8.0, nil, nil)
	Sleep(8.0)

	MissionUtil.SetCinematicCamera(introcam_7_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_8_marker, introcam_target_2_marker, true, 8.0, nil, nil)
	Sleep(6.0)

	MissionUtil.CreateCinematicLander("C9979_CARRIER_LANDING_FULL", c9979_lander_1_marker, p_cis, 11, true, "LANDING", 60)
	MissionUtil.CreateCinematicLander("C9979_CARRIER_LANDING_FULL", c9979_lander_2_marker, p_cis, 8.5, true, "LANDING", 91)
	MissionUtil.CreateCinematicLander("C9979_CARRIER_LANDING_FULL", c9979_lander_3_marker, p_cis, 9.5, true, "LANDING", 123)

	c9979_lander_1_marker.Despawn()
	c9979_lander_2_marker.Despawn()
	c9979_lander_3_marker.Despawn()

	Sleep(2.0)

	MissionUtil.SetCinematicCamera(introcam_9_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_10_marker, introcam_target_2_marker, true, 8.0, nil, nil)
	Sleep(3.0)

	MissionUtil.CinematicIntroHeader("MARIDUN_MARAUDER")
	MissionUtil.PlayGenericMusic("Trade_Federation_Theme")
	Sleep(5.0)

	MissionUtil.SetCinematicCamera(introcam_11_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_12_marker, introcam_target_2_marker, true, 7.0, nil, nil)
	Sleep(7.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end
function End_Cinematic_Intro_CIS()
	MissionUtil.EndCinematicCamera(player_durd, 2.0)
	Sleep(2.0)

	player_lurmen_leader.Despawn()
	player_lurmen_1.Despawn()
	player_lurmen_2.Despawn()

	p_republic.Make_Enemy(p_cis)
	p_cis.Make_Enemy(p_republic)

	Create_Thread("State_CIS_Spawner")

	if not TestValid(player_durd) then
		player_durd = MissionUtil.SpawnUnitGround("LOK_DURD_DEFOLIATOR_TEAM", intro_1_durd_marker, p_cis)
	end

	dwelling_list = Find_All_Objects_Of_Type("MISSION_LURMEN_DWELLING")
	for _,p_dwelling in pairs(dwelling_list) do
		MissionUtil.HighlightObject(true, p_dwelling, "p_dwelling_blip")
	end

	MissionUtil.SetObjectiveMissionSet("MARIDUN_MARAUDER", "CIS", 3)
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.AIActivation()

	MissionUtil.VictoryAllowance(true)

	current_cinematic_thread_id = nil

	cinematic_one = false
	act_1_active = true
end

function Start_Cinematic_Intro_Rep()
	cinematic_one = true

	player_aayla.Teleport_And_Face(intro_1_aayla_marker)
	player_anakin.Teleport_And_Face(intro_1_anakin_marker)
	player_ahsoka.Teleport_And_Face(intro_1_ahsoka_marker)
	player_bly.Teleport_And_Face(intro_1_bly_marker)
	player_rex.Teleport_And_Face(intro_1_rex_marker)

	player_lurmen_leader.Teleport_And_Face(intro_1_lurmen_leader_marker)
	player_lurmen_1.Teleport_And_Face(intro_1_lurmen_1_marker)
	player_lurmen_2.Teleport_And_Face(intro_1_lurmen_2_marker)

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	Sleep(1.0)

	MissionUtil.PlayGenericSpeech("Maridun_Marauder_01")
	MissionUtil.PlayGenericMusic("Silence_Theme")

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, true, 7.5, nil, nil)

	Fade_Screen_In(3.0)
	Letter_Box_In(3.0)
	Sleep(7.5)

	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_2_marker, true, 8.5, nil, nil)
	Sleep(8.5)

	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_3_marker, true, 8.0, nil, nil)
	Sleep(8.0)

	MissionUtil.SetCinematicCamera(introcam_7_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_8_marker, introcam_target_2_marker, true, 8.0, nil, nil)
	Sleep(4.0)

	MissionUtil.CreateCinematicLander("C9979_CARRIER_LANDING_FULL", c9979_lander_2_marker, p_cis, 8.5, true, "LANDING", 91)
	Sleep(1.0)
	MissionUtil.CreateCinematicLander("C9979_CARRIER_LANDING_FULL", c9979_lander_1_marker, p_cis, 11, true, "LANDING", 60)
	Sleep(1.0)
	MissionUtil.CreateCinematicLander("C9979_CARRIER_LANDING_FULL", c9979_lander_3_marker, p_cis, 9.5, true, "LANDING", 123)

	c9979_lander_1_marker.Despawn()
	c9979_lander_2_marker.Despawn()
	c9979_lander_3_marker.Despawn()

	Sleep(2.0)

	MissionUtil.SetCinematicCamera(introcam_9_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_10_marker, introcam_target_2_marker, true, 8.0, nil, nil)
	Sleep(3.0)

	MissionUtil.CinematicIntroHeader("MARIDUN_MARAUDER")
	MissionUtil.PlayGenericMusic("Trade_Federation_Theme")
	Sleep(5.0)

	MissionUtil.SetCinematicCamera(introcam_11_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_12_marker, introcam_target_2_marker, true, 7.0, nil, nil)
	Sleep(7.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Rep")
	end
end
function End_Cinematic_Intro_Rep()
	MissionUtil.EndCinematicCamera(player_anakin, 2.0)
	Sleep(2.0)

	player_lurmen_leader.Despawn()
	player_lurmen_1.Despawn()
	player_lurmen_2.Despawn()

	p_republic.Make_Enemy(p_cis)
	p_cis.Make_Enemy(p_republic)

	Create_Thread("State_CIS_Spawner")

	MissionUtil.SetObjectiveMissionSet("MARIDUN_MARAUDER", "REP", 7)
	MissionUtil.CinematicEnvironmentOff()

	MissionUtil.AIActivation()

	current_cinematic_thread_id = nil

	cinematic_one = false
end

function Start_Cinematic_Outro_Rep()
	act_1_active = false
	cinematic_two = true

	Fade_Screen_Out(0.5)
	Sleep(1.0)

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	Do_End_Cinematic_Cleanup()

	player_aayla = MissionUtil.SpawnUnitGround("AAYLA_SECURA", outro_1_aayla_marker, p_republic)
	player_anakin = MissionUtil.SpawnUnitGround("ANAKIN", outro_1_anakin_marker, p_republic)
	player_ahsoka = MissionUtil.SpawnUnitGround("AHSOKA", outro_1_ahsoka_marker, p_republic)

	player_lurmen_leader = MissionUtil.SpawnUnitGround("PARTISAN_EWOK_CHIEFTAIN", outro_1_lurmen_leader_marker, p_republic)
	player_lurmen_1 = MissionUtil.SpawnUnitGround("PARTISAN_EWOK_WARRIOR", outro_1_lurmen_1_marker, p_republic)

	MissionUtil.PlayGenericSpeech("Maridun_Marauder_02")
	MissionUtil.PlayGenericMusic("Silence_Theme")

	MissionUtil.SetCinematicCamera(outrocam_1_marker, outrocam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outrocam_target_1_marker, true, 9.0, nil, nil)

	Fade_Screen_In(3.0)
	Letter_Box_In(3.0)
	Sleep(9.0)

	MissionUtil.SetCinematicCamera(outrocam_3_marker, outrocam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_4_marker, outrocam_target_2_marker, true, 7.0, nil, nil)
	Sleep(5.0)

	MissionUtil.SetCinematicCamera(outrocam_3_marker, outrocam_target_2_marker, true, nil, nil)
	Cinematic_Zoom(15, 5)
	Sleep(6.0)

	Fade_Screen_Out(3.0)
	Sleep(2.0)

	MissionUtil.CinematicEnvironmentOff()

	MissionUtil.DisableRetreat("REBEL", false)
	MissionUtil.DisableRetreat("EMPIRE", false)

	StoryUtil.DeclareVictory(p_republic, false)
end
