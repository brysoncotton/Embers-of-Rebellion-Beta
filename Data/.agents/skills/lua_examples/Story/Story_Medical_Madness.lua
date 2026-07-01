--*****************************************************--
--***** Hunt for the Malevolence: Medical Madness *****--
--*****************************************************--

require("PGBase")
require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")
require("eawx-util/StoryUtil")
require("eawx-util/MissionUtil")
require("SetFighterResearch")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	StoryModeEvents =
	{
		Battle_Start = Begin_Battle,
	}

	yularen_fleet_list = {
		"YULAREN_RESOLUTE",
		"VENATOR_STAR_DESTROYER",
		"VENATOR_STAR_DESTROYER",
		"ACCLAMATOR_I_CARRIER",
		"ACCLAMATOR_I_CARRIER",
		"PELTA_SUPPORT",
		"PELTA_SUPPORT",
		"PELTA_SUPPORT",
		"ARQUITENS",
		"ARQUITENS",
		"ARQUITENS",
		"ARQUITENS"
	}
	luminara_fleet_medium_list = {
		"VENATOR_STAR_DESTROYER",
		"VENATOR_STAR_DESTROYER",
		"VENATOR_STAR_DESTROYER",
		"ACCLAMATOR_I_CARRIER",
		"PELTA_SUPPORT",
		"PELTA_SUPPORT",
		"PELTA_SUPPORT",
		"ARQUITENS",
		"ARQUITENS",
		"ARQUITENS",
		"ARQUITENS",
	}
	luminara_fleet_hard_list = {
		"VENATOR_STAR_DESTROYER",
		"VENATOR_STAR_DESTROYER",
		"VENATOR_STAR_DESTROYER",
		"VENATOR_STAR_DESTROYER",
		"ACCLAMATOR_I_CARRIER",
		"ACCLAMATOR_I_CARRIER",
		"ACCLAMATOR_I_CARRIER",
		"PELTA_SUPPORT",
		"PELTA_SUPPORT",
		"PELTA_SUPPORT",
		"ARQUITENS",
		"ARQUITENS",
		"ARQUITENS",
		"ARQUITENS",
	}
	outro_fleet_list = {
		"VENATOR_STAR_DESTROYER",
		"VENATOR_STAR_DESTROYER",
		"VENATOR_STAR_DESTROYER",
		"VENATOR_STAR_DESTROYER",
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")

	act_1_active = false
	act_2_active = false

	current_cinematic_thread_id = nil

	cinematic_one = false
	cinematic_two = false
	cinematic_three = false

	cinematic_one_skipped = false
	cinematic_two_skipped = false
	cinematic_three_skipped = false

	yularen_protected = false
	kaliida_dead = false
	kaliida_damaged = false
	luminara_arrived = false
	malevolence_disabled = false

	cis_fleet_dead = false
	rep_fleet_dead = false

	mission_started = false
end
function Begin_Battle(message)
	if message == OnEnter then
		Clear_Fighter_Hero("BROADSIDE_SHADOW_SQUADRON")

		MissionUtil.VictoryAllowance(false)
		MissionUtil.DisableRetreat("EMPIRE", true)
		MissionUtil.DisableRetreat("SECTOR_FORCES", true)

		player_kaliida_shoals = Find_First_Object("KALIIDA_SHOALS_MEDCENTER")

		intro_1_malevolence_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-malevolence")
		intro_2_malevolence_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-malevolence")

		intro_1_shadow_squadron_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-shadow")

		republic_fleet_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "republic-fleet-1")
		republic_fleet_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "republic-fleet-2")
		republic_fleet_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "republic-fleet-3")

		outro_1_twilight_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-1-twilight")

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-4")
		introcam_4_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-4-1")
		introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-5")
		introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-6")
		introcam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-7")
		introcam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-8")
		introcam_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-9")
		introcam_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-10")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")
		introcam_target_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-4")

		player_grievous = Find_First_Object("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN")

		MissionUtil.Set_To_Allies(p_cis, p_invaders)
		MissionUtil.Set_To_Allies(p_republic, p_invaders)

		mission_started = true
		
		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
		elseif p_republic.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
		end
	end
end

function State_Luminara_Arrives()
	luminara_arrived = true

	if StoryUtil.GetDifficulty() == "EASY" then
		AI_Republic_Fleet = SpawnList(luminara_fleet_medium_list, republic_fleet_2_marker.Get_Position(), p_republic, true, true)
		Republic_AI_Fleet = AI_Republic_Fleet[1]
		Republic_AI_Fleet.Teleport_And_Face(republic_fleet_2_marker)
		Republic_AI_Fleet.Cinematic_Hyperspace_In(150)
	end
	if StoryUtil.GetDifficulty() == "NORMAL" then
		AI_Republic_Fleet = SpawnList(luminara_fleet_medium_list, republic_fleet_2_marker.Get_Position(), p_republic, true, true)
		Republic_AI_Fleet = AI_Republic_Fleet[1]
		Republic_AI_Fleet.Teleport_And_Face(republic_fleet_2_marker)
		Republic_AI_Fleet.Cinematic_Hyperspace_In(150)
	end
	if StoryUtil.GetDifficulty() == "HARD" then
		AI_Republic_Fleet = SpawnList(luminara_fleet_hard_list, intro_1_malevolence_marker.Get_Position(), p_republic, true, true)
		Republic_AI_Fleet = AI_Republic_Fleet[1]
		Republic_AI_Fleet.Teleport_And_Face(intro_1_malevolence_marker)
		Republic_AI_Fleet.Cinematic_Hyperspace_In(150)
	end

	MissionUtil.MissionTextSpeech("MEDICAL_MADNESS", 1, 9.5, "Grievous_Loop", {r = 255, g = 255, b = 255})
	Find_First_Object("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN").Override_Max_Speed(1.75)
	MissionUtil.CinematicEnvironmentOff()
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

				if not TestValid(player_shadow_squadron) then
					player_shadow_squadron = MissionUtil.SpawnUnitSpace("BROADSIDE_SHADOW_SQUADRON", intro_1_shadow_squadron_marker, p_republic)
				end

				if StoryUtil.GetDifficulty() == "EASY" then
					Register_Timer(State_Luminara_Arrives, 120)
				end
				if StoryUtil.GetDifficulty() == "NORMAL" then
					Register_Timer(State_Luminara_Arrives, 90)
				end
				if StoryUtil.GetDifficulty() == "HARD" then
					Register_Timer(State_Luminara_Arrives, 60)
				end

				republic_defender_list = SpawnList(yularen_fleet_list, republic_fleet_1_marker, p_republic, true, true, false)
				republic_defender = republic_defender_list[1]
				republic_defender.Teleport_And_Face(republic_fleet_1_marker)
				republic_defender.Cinematic_Hyperspace_In(30)

				if TestValid(Find_First_Object("KALIIDA_SHOALS_MEDCENTER")) then
					kaliida_shoals_marker = Find_First_Object("KALIIDA_SHOALS_MEDCENTER").Get_Position()
					Find_First_Object("KALIIDA_SHOALS_MEDCENTER").Despawn()
					if not TestValid(Find_First_Object("Secondary_Haven")) then
						SpawnList({"Secondary_Haven"}, kaliida_shoals_marker, p_republic, true, true)
					end
				end

				MissionUtil.Set_To_Enemies(p_republic, p_cis)

				MissionUtil.CinematicSkippingCleanUp(intro_2_malevolence_marker)
				MissionUtil.SetObjectiveMissionSet("MEDICAL_MADNESS", "CIS", 3)

				--MissionUtil.AIActivation() Republic uses a special AI
				StoryUtil.ChangeAIPlayer("EMPIRE", "RepublicMissionAI")

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

				Fade_On()
				cinematic_two = false
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_02_CIS")
			end
		end
		if cinematic_three then
			if not cinematic_three_skipped then
				cinematic_three_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				MissionUtil.CinematicEnvironmentOff()

				player_grievous.Hyperspace_Away(true)

				act_2_active = false
				StoryUtil.TriggerScriptedBattle("SUBJUGATOR_SABOTAGE", "ABREGADO_RAE", "LAND", "EMPIRE", "REBEL", false)
				if cis_fleet_dead then
					StoryUtil.DeclareVictory(p_republic, false)
				elseif rep_fleet_dead then
					StoryUtil.DeclareVictory(p_cis, false)
				end
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

				if TestValid(Find_First_Object("KALIIDA_SHOALS_MEDCENTER")) then
					kaliida_shoals_marker = Find_First_Object("KALIIDA_SHOALS_MEDCENTER").Get_Position()
					Find_First_Object("KALIIDA_SHOALS_MEDCENTER").Despawn()
					if not TestValid(Find_First_Object("Secondary_Haven")) then
						SpawnList({"Secondary_Haven"}, kaliida_shoals_marker, p_republic, true, true)
					end
				end

				MissionUtil.Set_To_Enemies(p_republic, p_cis)

				MissionUtil.CinematicSkippingCleanUp(Find_First_Object("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN"))
				MissionUtil.SetObjectiveMissionSet("MEDICAL_MADNESS", "REP", 4)

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

				Fade_On()
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_02_Rep")
			end
		end
		if cinematic_three then
			if not cinematic_three_skipped then
				cinematic_three_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				MissionUtil.CinematicEnvironmentOff()

				player_grievous.Hyperspace_Away(true)

				act_2_active = false
				StoryUtil.TriggerScriptedBattle("SUBJUGATOR_SABOTAGE", "ABREGADO_RAE", "LAND", "EMPIRE", "REBEL", false)
				if cis_fleet_dead then
					StoryUtil.DeclareVictory(p_republic, false)
				elseif rep_fleet_dead then
					StoryUtil.DeclareVictory(p_cis, false)
				end
			end
		end
	end
end
function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_1_active then
			if not kaliida_damaged then
				if TestValid(Find_First_Object("SECONDARY_HAVEN")) then
					if Find_First_Object("SECONDARY_HAVEN").Get_Hull() <= 0.99 then --Replace Secondary_Haven with KALIIDA_SHOALS_MEDCENTER when the collision mesh gets made
						kaliida_damaged = true
					end
				end
			end
			if not malevolence_disabled then
				if Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Get_Hull() <= 0.01 then
					GlobalValue.Set("HfM_Malevolence_Alive", 0)
					malevolence_disabled = true
					cis_fleet_dead = true

					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_01_CIS")
				end
				republic_list = Find_All_Objects_Of_Type(p_republic, "Corvette | Capital | Frigate | SpaceHero | SpaceStructure | SuperCapital")
				if (table.getn(republic_list) == 0) then
					GlobalValue.Set("HfM_Malevolence_Alive", 1)
					malevolence_disabled = true
					rep_fleet_dead = true
					
					MissionUtil.VictoryAllowance(true)
					MissionUtil.DisableRetreat("EMPIRE", false)
					MissionUtil.DisableRetreat("SECTOR_FORCES", false)
					StoryUtil.DeclareVictory(p_cis, false)
				end
			end
		end
	end
end

function Start_Cinematic_Intro_CIS()
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
		Spawn_From_Reinforcement_Pool(Find_Object_Type(GrievousObjectName), intro_1_malevolence_marker, Find_Player("Rebel"))
		GrievousObject = Find_First_Object(GrievousObjectName)
		if TestValid(GrievousObject) then
			player_grievous = GrievousObject
		end
	end
	if not TestValid(player_grievous) then
		player_grievous = MissionUtil.SpawnUnitSpace("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN", intro_1_malevolence_marker, p_cis, 300)
	end

	Sleep(0.5)

	cinematic_one = true

	Fade_Screen_In(5.0)
	Letter_Box_In(3.0)

	MissionUtil.PlayGenericSpeech("Medical_Madness_01")
	MissionUtil.CinematicIntroHeader("MEDICAL_MADNESS")

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, true, 18.0, nil, nil)
	Sleep(17.0)

	player_grievous.Turn_To_Face(intro_2_malevolence_marker)

	MissionUtil.TransitionCinematicCamera(introcam_3_marker, introcam_target_2_marker, true, 11.0, nil, nil)
	Sleep(4.0)

	player_grievous.Move_To(intro_2_malevolence_marker)
	Sleep(7.0)

	Fade_Screen_In(6.0)
	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, player_grievous, true, 18.0, nil, nil)
	Sleep(9.0)

	player_grievous.Override_Max_Speed(4.0)

	player_shadow_squadron = MissionUtil.SpawnUnitSpace("BROADSIDE_SHADOW_SQUADRON", intro_1_shadow_squadron_marker, p_republic)
	BlockOnCommand(player_shadow_squadron.Cinematic_Hyperspace_In(50))
	player_shadow_squadron.Attack_Move(player_grievous)
	Sleep(2.0)

	if TestValid(Find_First_Object("BROADSIDE")) then
		MissionUtil.SetCinematicCamera(introcam_7_marker, Find_First_Object("BROADSIDE"), true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_8_marker, Find_First_Object("BROADSIDE"), true, 18.0, nil, nil)
	else
		MissionUtil.SetCinematicCamera(introcam_7_marker, introcam_target_4_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(introcam_8_marker, introcam_target_4_marker, true, 18.0, nil, nil)
	end
	Sleep(5.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end
function End_Cinematic_Intro_CIS()
	republic_defender_list = SpawnList(yularen_fleet_list, republic_fleet_1_marker, p_republic, true, true, false)
	republic_defender = republic_defender_list[1]
	republic_defender.Teleport_And_Face(republic_fleet_1_marker)
	republic_defender.Cinematic_Hyperspace_In(30)

	MissionUtil.EndCinematicCamera(player_grievous, 3.5)
	MissionUtil.SetObjectiveMissionSet("MEDICAL_MADNESS", "CIS", 3)
	MissionUtil.CinematicEnvironmentOff()

	if TestValid(Find_First_Object("KALIIDA_SHOALS_MEDCENTER")) then
		kaliida_shoals_marker = Find_First_Object("KALIIDA_SHOALS_MEDCENTER").Get_Position()
		Find_First_Object("KALIIDA_SHOALS_MEDCENTER").Despawn()
		if not TestValid(Find_First_Object("Secondary_Haven")) then
			SpawnList({"Secondary_Haven"}, kaliida_shoals_marker, p_republic, true, true)
		end
	end

	--MissionUtil.AIActivation() Republic uses a special AI
	StoryUtil.ChangeAIPlayer("EMPIRE", "RepublicMissionAI")

	if StoryUtil.GetDifficulty() == "EASY" then
		Register_Timer(State_Luminara_Arrives, 120)
	end
	if StoryUtil.GetDifficulty() == "NORMAL" then
		Register_Timer(State_Luminara_Arrives, 90)
	end
	if StoryUtil.GetDifficulty() == "HARD" then
		Register_Timer(State_Luminara_Arrives, 60)
	end

	cinematic_one = false
	act_1_active = true
end

function Start_Cinematic_Outro_01_CIS()
	AI_Republic_Fleet = SpawnList(outro_fleet_list, republic_fleet_3_marker.Get_Position(), p_republic, true, true)
	Republic_AI_Fleet = AI_Republic_Fleet[1]
	Republic_AI_Fleet.Teleport_And_Face(republic_fleet_3_marker)
	Republic_AI_Fleet.Cinematic_Hyperspace_In(150)

	act_1_active = false
	cinematic_two = true

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	SFXManager.Allow_Localized_SFXEvents(false)

	hero_list_01 = Find_All_Objects_Of_Type("SpaceHero")
	for h, hero01 in pairs(hero_list_01) do
		if TestValid(hero01) then
			hero01.Make_Invulnerable(true)
		end
	end

	Fade_On()
	MissionUtil.PlayGenericSpeech("Mission_Malevolence_01")
	Sleep(1.0)

	Letter_Box_In(1.0)
	Fade_Screen_In(2.0)

	Set_Cinematic_Camera_Key(player_grievous, 2800, -200, 155, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(player_grievous, 0, 0, -200, 0, 0, 0, 0)
	Transition_Cinematic_Target_Key(player_grievous, 20, 0, -1000, -200, 0, player_grievous, 1, 0)
	Transition_Cinematic_Target_Key(player_grievous, 20, 0, -1000, -200, 0, player_grievous, 1, 0)
	Sleep(15.0)

	p_cis.Make_Ally(p_republic)
	p_republic.Make_Ally(p_cis)

	Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Change_Owner(p_invaders)
	Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Suspend_Locomotor(true)
	Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Prevent_All_Fire(true)
	Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Prevent_Opportunity_Fire(true)

	Set_Cinematic_Camera_Key(republic_fleet_2_marker, 0, 0, -200, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(republic_fleet_2_marker, 0, 0, -200, 0, player_grievous, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 20, 0, 0, -200, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 20, 0, 0, -200, 0, player_grievous, 1, 0)
	Sleep(15.0)

	Set_Cinematic_Camera_Key(intro_1_malevolence_marker, 0, 0, -200, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(intro_1_malevolence_marker, 0, 0, -200, 0, player_grievous, 1, 0)
	Transition_Cinematic_Camera_Key(intro_1_shadow_squadron_marker, 18, 0, 0, -200, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(intro_1_shadow_squadron_marker, 18, 0, 0, -200, 0, player_grievous, 1, 0)
	Sleep(18.0)

	Set_Cinematic_Camera_Key(republic_fleet_3_marker, 0, 0, -200, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(republic_fleet_3_marker, 0, 0, -200, 0, player_grievous, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_target_3_marker, 15, 0, 0, -200, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_target_3_marker, 15, 0, 0, -200, 0, player_grievous, 1, 0)
	Sleep(10.0)

	Fade_Screen_Out(3.0)
	Sleep(5.0)
	MissionUtil.CinematicEnvironmentOff()

	if not cinematic_two_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_02_CIS")
	end
end
function Start_Cinematic_Outro_02_CIS()
	StoryUtil.TriggerScriptedBattle("SUBJUGATOR_SABOTAGE", "ABREGADO_RAE", "LAND", "EMPIRE", "REBEL", false)

	cinematic_two = false
	cinematic_three = true

	player_anakin = Spawn_Unit(Find_Object_Type("Twilight_Mission"), outro_1_twilight_marker, p_republic)
	player_anakin = Find_Nearest(outro_1_twilight_marker, p_republic, true)
	player_anakin.Teleport_And_Face(outro_1_twilight_marker)
	player_anakin.Move_To(player_grievous)

	MissionUtil.PlayGenericSpeech("Mission_Malevolence_02")
	player_anakin.Play_Animation("Undeploy", false)

	Set_Cinematic_Camera_Key(outro_1_twilight_marker, 800, 200, 155, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outro_1_twilight_marker, 0, 0, 0, 0, player_anakin, 1, 0)
	Transition_Cinematic_Camera_Key(outro_1_twilight_marker, 10, 100, 100, -100, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outro_1_twilight_marker, 10, 0, 0, 0, 0, player_grievous, 1, 0)
	Fade_Screen_In(0.5)
	Letter_Box_In(0.5)
	Sleep(8.0)

	player_anakin.Play_Animation("Deploy", false)

	Set_Cinematic_Camera_Key(player_anakin, 0, -50, -700, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(player_anakin, 0, 0, 0, 0, player_anakin, 1, 0)
	Sleep(6.0)

	Fade_Screen_Out(4)
	Sleep(5.0)

	MissionUtil.CinematicEnvironmentOff()

	player_grievous.Hyperspace_Away(true)

	if cis_fleet_dead then
		StoryUtil.DeclareVictory(p_republic, false)
	elseif rep_fleet_dead then
		StoryUtil.DeclareVictory(p_cis, false)
	end
end

function Start_Cinematic_Intro_Rep()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	player_grievous = MissionUtil.SpawnUnitSpace("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN", intro_1_malevolence_marker, p_cis, 300)
	player_grievous.Turn_To_Face(intro_2_malevolence_marker)
	Sleep(0.5)

	cinematic_one = true

	Fade_Screen_In(5.0)
	Letter_Box_In(3.0)

	MissionUtil.PlayGenericSpeech("Medical_Madness_01")
	MissionUtil.CinematicIntroHeader("MEDICAL_MADNESS")

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_2_marker, true, 18.0, nil, nil)
	Sleep(17.0)

	MissionUtil.TransitionCinematicCamera(introcam_3_marker, introcam_target_2_marker, true, 11.0, nil, nil)
	Sleep(4.0)

	player_grievous.Move_To(intro_2_malevolence_marker)
	Sleep(7.0)

	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, player_grievous, true, 11.0, nil, nil)
	Fade_Screen_In(6.0)
	Sleep(9.0)

	player_grievous.Override_Max_Speed(4.0)

	player_shadow_squadron = Spawn_Unit(Find_Object_Type("Broadside_Shadow_Squadron"), intro_1_shadow_squadron_marker, p_republic)
	player_shadow_squadron = Find_Nearest(intro_1_shadow_squadron_marker, p_republic, true)
	player_shadow_squadron.Teleport_And_Face(intro_1_shadow_squadron_marker)
	BlockOnCommand(player_shadow_squadron.Cinematic_Hyperspace_In(50))
	player_shadow_squadron.Attack_Move(player_grievous)
	Sleep(2.0)

	if TestValid(Find_First_Object("BROADSIDE")) then
		Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, Find_First_Object("BROADSIDE"), 1, 0)
		Transition_Cinematic_Camera_Key(introcam_8_marker, 7.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_8_marker, 7.0, 0, 0, 0, 0, Find_First_Object("BROADSIDE"), 1, 0)
	else
		Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
		Transition_Cinematic_Camera_Key(introcam_8_marker, 7.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(introcam_8_marker, 7.0, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	end
	Sleep(5.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Rep")
	end
end
function End_Cinematic_Intro_Rep()

	if TestValid(Find_First_Object("KALIIDA_SHOALS_MEDCENTER")) then
		kaliida_shoals_marker = Find_First_Object("KALIIDA_SHOALS_MEDCENTER").Get_Position()
		Find_First_Object("KALIIDA_SHOALS_MEDCENTER").Despawn()
		if not TestValid(Find_First_Object("Secondary_Haven")) then
			MissionUtil.SpawnUnitSpace("Secondary_Haven", kaliida_shoals_marker, p_republic)
		end
	end

	MissionUtil.EndCinematicCamera(player_grievous, 3.5)
	MissionUtil.SetObjectiveMissionSet("MEDICAL_MADNESS", "REP", 4)

	cinematic_one = false
	act_1_active = true
	Sleep(13.0)

	MissionUtil.CinematicEnvironmentOff()
end

function Start_Cinematic_Outro_01_Rep()
	act_1_active = false
	cinematic_two = true

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	SFXManager.Allow_Localized_SFXEvents(false)

	hero_list_01 = Find_All_Objects_Of_Type("SpaceHero")
	for h, hero01 in pairs(hero_list_01) do
		if TestValid(hero01) then
			hero01.Make_Invulnerable(true)
		end
	end

	Fade_On()
	MissionUtil.PlayGenericSpeech("Mission_Malevolence_01")
	Sleep(1.0)

	Letter_Box_In(1.0)
	Fade_Screen_In(2.0)

	Set_Cinematic_Camera_Key(player_grievous, 2800, -200, 155, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(player_grievous, 0, 0, -200, 0, 0, 0, 0)
	Transition_Cinematic_Target_Key(player_grievous, 20, 0, -1000, -200, 0, player_grievous, 1, 0)
	Transition_Cinematic_Target_Key(player_grievous, 20, 0, -1000, -200, 0, player_grievous, 1, 0)
	Sleep(15.0)

	p_cis.Make_Ally(p_republic)
	p_republic.Make_Ally(p_cis)

	Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Change_Owner(p_invaders)
	Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Suspend_Locomotor(true)
	Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Prevent_All_Fire(true)
	Find_First_Object("Grievous_Malevolence_Hunt_Campaign").Prevent_Opportunity_Fire(true)

	Set_Cinematic_Camera_Key(republic_fleet_2_marker, 0, 0, -200, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(republic_fleet_2_marker, 0, 0, -200, 0, player_grievous, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 20, 0, 0, -200, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 20, 0, 0, -200, 0, player_grievous, 1, 0)
	Sleep(15.0)

	Set_Cinematic_Camera_Key(intro_1_malevolence_marker, 0, 0, -200, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(intro_1_malevolence_marker, 0, 0, -200, 0, player_grievous, 1, 0)
	Transition_Cinematic_Camera_Key(intro_1_shadow_squadron_marker, 18, 0, 0, -200, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(intro_1_shadow_squadron_marker, 18, 0, 0, -200, 0, player_grievous, 1, 0)
	Sleep(18.0)

	Set_Cinematic_Camera_Key(republic_fleet_3_marker, 0, 0, -200, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(republic_fleet_3_marker, 0, 0, -200, 0, player_grievous, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_target_3_marker, 15, 0, 0, -200, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_target_3_marker, 15, 0, 0, -200, 0, player_grievous, 1, 0)
	Sleep(10.0)

	Fade_Screen_Out(3.0)
	Sleep(5.0)

	if not cinematic_two_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_02_Rep")
	end
end
function Start_Cinematic_Outro_02_Rep()
	StoryUtil.TriggerScriptedBattle("SUBJUGATOR_SABOTAGE", "ABREGADO_RAE", "LAND", "EMPIRE", "REBEL", false)

	cinematic_two = false
	cinematic_three = true

	player_anakin = Spawn_Unit(Find_Object_Type("Twilight_Mission"), outro_1_twilight_marker, p_republic)
	player_anakin = Find_Nearest(outro_1_twilight_marker, p_republic, true)
	player_anakin.Teleport_And_Face(outro_1_twilight_marker)
	player_anakin.Move_To(player_grievous)

	MissionUtil.PlayGenericSpeech("Mission_Malevolence_02")
	player_anakin.Play_Animation("Undeploy", false)

	Set_Cinematic_Camera_Key(outro_1_twilight_marker, 800, 200, 155, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outro_1_twilight_marker, 0, 0, 0, 0, player_anakin, 1, 0)
	Transition_Cinematic_Camera_Key(outro_1_twilight_marker, 10, 100, 100, -100, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outro_1_twilight_marker, 10, 0, 0, 0, 0, player_grievous, 1, 0)
	Fade_Screen_In(0.5)
	Letter_Box_In(0.5)
	Sleep(8.0)

	player_anakin.Play_Animation("Deploy", false)

	Set_Cinematic_Camera_Key(player_anakin, 0, -50, -700, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(player_anakin, 0, 0, 0, 0, player_anakin, 1, 0)
	Sleep(6.0)

	Fade_Screen_Out(4.0)
	Sleep(5.0)

	MissionUtil.CinematicEnvironmentOff()

	player_grievous.Hyperspace_Away(true)

	MissionUtil.VictoryAllowance(true)
	MissionUtil.DisableRetreat("EMPIRE", false)
	MissionUtil.DisableRetreat("SECTOR_FORCES", false)

	if cis_fleet_dead then
		StoryUtil.DeclareVictory(p_republic, false)
	elseif rep_fleet_dead then
		StoryUtil.DeclareVictory(p_cis, false)
	end
end
