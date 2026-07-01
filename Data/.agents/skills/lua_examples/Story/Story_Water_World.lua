
--*****************************************************--
--**************** Rimward: Water World ***************--
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
	p_neutral = Find_Player("Neutral")

	cis_attacker_list = {
		"HOME_ONE_TYPE_LINER",
		"MUNIFICENT_SUBFACTION",
		"MUNIFICENT_SUBFACTION",
		"MUNIFICENT_SUBFACTION",
		"LIBERTY_LINER",
		"C9979_CARRIER",
		"C9979_CARRIER",
		"C9979_CARRIER",
		"HARDCELL",
		"HARDCELL",
		"HARDCELL",
		"HARDCELL",
		"DH_OMNI",
		"DH_OMNI",
		"PROVIDENCE_CARRIER_DESTROYER",
		"RECUSANT_LIGHT_DESTROYER",
		"RECUSANT_LIGHT_DESTROYER",
		"LUCREHULK_CORE_DESTROYER",
	}

	act_1_active = false

	cinematic_one = false
	cinematic_two_alt_01 = false
	cinematic_two_alt_02 = false

	cinematic_one_skipped = false
	cinematic_two_alt_01_skipped = false
	cinematic_two_alt_02_skipped = false

	grievous_soulless_one_active = false
	grievous_renitor_active = false
	grievous_munificent_active = false
	grievous_invisible_hand_active = false
	grievous_malevolence_active = false

	cis_fleet_dead = false
	rep_fleet_dead = false

	current_cinematic_thread_id = nil

	mission_started = false
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

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")

		outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-1")
		outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-2")

		outrocam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-1")

		rep_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-1")
		rep_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-2")
		rep_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-3")
		rep_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-4")
		rep_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-5")
		rep_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-6")
		rep_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-7")

		cis_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-1")
		cis_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-2")
		cis_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-3")
		cis_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-4")
		cis_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-5")
		cis_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-6")
		cis_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-7")

		mission_started = true

		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
		elseif p_republic.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
		end
	end
end

function State_Hero_Death()
	if p_cis.Is_Human() then
		if not TestValid(player_grievous) then
			MissionUtil.SetMissionObjectiveFailed("WATER_WORLD", "CIS", 2)
		end
		if not TestValid(Find_First_Object("MERAI_FREE_DAC")) then
			MissionUtil.SetMissionObjectiveFailed("WATER_WORLD", "CIS", 3)
		end
	elseif p_republic.Is_Human() then
		if not TestValid(Find_First_Object("MERAI_FREE_DAC")) then
			MissionUtil.SetMissionObjectiveComplete("WATER_WORLD", "REP", 2)
		end
	end
end
function State_Among_Us()
	MissionUtil.PlayGenericSpeech("Water_World_02")
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

				MissionUtil.MissionTextSpeech("WATER_WORLD", 1, 8.0, "Anakin_Loop", {r = 255, g = 255, b = 255})

				MissionUtil.SetObjectiveMissionSet("WATER_WORLD", "CIS", 3)
				MissionUtil.CinematicSkippingCleanUp(cis_1_marker)
				Register_Timer(State_Among_Us, 60)

				cinematic_one = false
				act_1_active = true

				Fade_Screen_In(0.5)
			end
		end
		if cinematic_two_alt_01 then
			if not cinematic_two_alt_01_skipped then
				cinematic_two_alt_01_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				MissionUtil.CinematicEnvironmentOff()
				MissionUtil.DisableRetreat("REBEL", false)
				MissionUtil.DisableRetreat("EMPIRE", false)

				StoryUtil.DeclareVictory(p_cis, false)
			end
		end
		if cinematic_two_alt_02 then
			if not cinematic_two_alt_02_skipped then
				cinematic_two_alt_02_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				MissionUtil.CinematicEnvironmentOff()
				MissionUtil.DisableRetreat("REBEL", false)
				MissionUtil.DisableRetreat("EMPIRE", false)

				StoryUtil.DeclareVictory(p_cis, false)
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

				MissionUtil.MissionTextSpeech("WATER_WORLD", 1, 8.0, "Anakin_Loop", {r = 255, g = 255, b = 255})
				Register_Timer(State_Among_Us, 60)

				if not TestValid(Find_First_Object("MERAI_FREE_DAC")) then
					if StoryUtil.GetDifficulty() == "EASY" then
						MissionUtil.SpawnUnitSpace("MERAI_FREE_DAC", cis_1_marker, p_cis, 300)
						MissionUtil.SpawnUnitSpace("HOME_ONE_TYPE_LINER", cis_2_marker, p_cis, 300)
						MissionUtil.SpawnUnitSpace("MUNIFICENT_SUBFACTION", cis_3_marker, p_cis, 300)
						MissionUtil.SpawnUnitSpace("MUNIFICENT_SUBFACTION", cis_4_marker, p_cis, 300)
					end
					if StoryUtil.GetDifficulty() == "NORMAL" then
						MissionUtil.SpawnUnitSpace("MERAI_FREE_DAC", cis_1_marker, p_cis, 300)
						MissionUtil.SpawnUnitSpace("HOME_ONE_TYPE_LINER", cis_2_marker, p_cis, 300)
						MissionUtil.SpawnUnitSpace("MUNIFICENT_SUBFACTION", cis_3_marker, p_cis, 300)
						MissionUtil.SpawnUnitSpace("MUNIFICENT_SUBFACTION", cis_4_marker, p_cis, 300)
					end
					if StoryUtil.GetDifficulty() == "HARD" then
						MissionUtil.SpawnUnitSpace("MERAI_FREE_DAC", cis_1_marker, p_cis, 300)
						MissionUtil.SpawnUnitSpace("HOME_ONE_TYPE_LINER", cis_2_marker, p_cis, 300)
						MissionUtil.SpawnUnitSpace("MUNIFICENT_SUBFACTION", cis_3_marker, p_cis, 300)
						MissionUtil.SpawnUnitSpace("MUNIFICENT_SUBFACTION", cis_4_marker, p_cis, 300)
					end

					if StoryUtil.GetDifficulty() == "EASY" then
						MissionUtil.SpawnUnitSpace("HARDCELL_TENDER", cis_4_marker, p_cis, 300)
						MissionUtil.SpawnUnitSpace("C9979_CARRIER", cis_5_marker, p_cis, 300)
						MissionUtil.SpawnUnitSpace("C9979_CARRIER", cis_6_marker, p_cis, 300)
						MissionUtil.SpawnUnitSpace("PROVIDENCE_CARRIER_DESTROYER", cis_6_marker, p_cis, 300)
					end
					if StoryUtil.GetDifficulty() == "NORMAL" then
						MissionUtil.SpawnUnitSpace("HARDCELL_TENDER", cis_4_marker, p_cis, 300)
						MissionUtil.SpawnUnitSpace("C9979_CARRIER", cis_5_marker, p_cis, 300)
						MissionUtil.SpawnUnitSpace("C9979_CARRIER", cis_6_marker, p_cis, 300)
						MissionUtil.SpawnUnitSpace("RECUSANT_DREADNOUGHT", cis_7_marker, p_cis, 300)
					end
					if StoryUtil.GetDifficulty() == "HARD" then
						MissionUtil.SpawnUnitSpace("HARDCELL_TENDER", cis_4_marker, p_cis, 300)
						MissionUtil.SpawnUnitSpace("C9979_CARRIER", cis_5_marker, p_cis, 300)
						MissionUtil.SpawnUnitSpace("C9979_CARRIER", cis_5_marker, p_cis, 300)
						MissionUtil.SpawnUnitSpace("PROVIDENCE_CARRIER_DESTROYER", cis_6_marker, p_cis, 300)
						MissionUtil.SpawnUnitSpace("RECUSANT_DREADNOUGHT", cis_7_marker, p_cis, 300)
					end
				end

				AI_Fleet = SpawnList(cis_attacker_list, Find_First_Object("ATTACKER ENTRY POSITION").Get_Position(), p_cis, true, true)
				AI_Fleet = AI_Fleet[1]
				AI_Fleet.Teleport_And_Face(Find_First_Object("ATTACKER ENTRY POSITION"))

				MissionUtil.SetObjectiveMissionSet("WATER_WORLD", "REP", 2)
				MissionUtil.CinematicSkippingCleanUp(rep_1_marker)

				cinematic_one = false
				act_1_active = true

				Fade_Screen_In(0.5)
			end
		end
		if cinematic_two_alt_01 then
			if not cinematic_two_alt_01_skipped then
				cinematic_two_alt_01_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				MissionUtil.CinematicEnvironmentOff()
				MissionUtil.DisableRetreat("REBEL", false)
				MissionUtil.DisableRetreat("EMPIRE", false)

				StoryUtil.DeclareVictory(p_cis, false)
			end
		end
		if cinematic_two_alt_02 then
			if not cinematic_two_alt_02_skipped then
				cinematic_two_alt_02_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				MissionUtil.CinematicEnvironmentOff()
				MissionUtil.DisableRetreat("REBEL", false)
				MissionUtil.DisableRetreat("EMPIRE", false)

				StoryUtil.DeclareVictory(p_cis, false)
			end
		end
	end
end
function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_1_active then
			cis_list = Find_All_Objects_Of_Type(p_cis, "SpaceHero | Corvette | Capital | Frigate | SuperCapital")
			if (table.getn(cis_list) == 0) then
				if not cis_fleet_dead then
					cis_fleet_dead = true
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_01_CIS")
				end
			end

			rep_list = Find_All_Objects_Of_Type(p_republic, "SpaceHero | Corvette | Capital | Frigate | SuperCapital")
			if (table.getn(rep_list) == 0) then
				if not rep_fleet_dead then
					rep_fleet_dead = true
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_02_CIS")
				end
			end
		end
	elseif p_republic.Is_Human() then
		if act_1_active then
			cis_list = Find_All_Objects_Of_Type(p_cis, "SpaceHero | Corvette | Capital | Frigate | SuperCapital")
			if (table.getn(cis_list) == 0) then
				if not cis_fleet_dead then
					cis_fleet_dead = true
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_01_Rep")
				end
			end

			rep_list = Find_All_Objects_Of_Type(p_republic, "SpaceHero | Corvette | Capital | Frigate | SuperCapital")
			if (table.getn(rep_list) == 0) then
				if not rep_fleet_dead then
					rep_fleet_dead = true
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_02_Rep")
				end
			end
		end
	end
end

function Start_Cinematic_Intro_CIS()
	if StoryUtil.GetDifficulty() == "EASY" then
		MissionUtil.SpawnUnitSpace("BYLUIR_VENATOR", rep_1_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("VENATOR_STAR_DESTROYER", rep_2_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("VENATOR_STAR_DESTROYER", rep_3_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("VENATOR_STAR_DESTROYER", rep_4_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("VENATOR_STAR_DESTROYER", rep_5_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("VENATOR_STAR_DESTROYER", rep_6_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("VENATOR_STAR_DESTROYER", rep_7_marker, p_republic, nil)

		MissionUtil.SpawnUnitSpace("CHARGER_C70", rep_1_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("CHARGER_C70", rep_2_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("CHARGER_C70", rep_3_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("CHARGER_C70", rep_4_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("CHARGER_C70", rep_5_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("CHARGER_C70", rep_6_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("CHARGER_C70", rep_7_marker, p_republic, nil)

		MissionUtil.AddToReinforcementPool("VENATOR_STAR_DESTROYER", p_republic, 2)
		MissionUtil.AddToReinforcementPool("CHARGER_C70", p_republic, 4)
	end
	if StoryUtil.GetDifficulty() == "NORMAL" then
		MissionUtil.SpawnUnitSpace("VENATOR_STAR_DESTROYER", rep_1_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("BYLUIR_VENATOR", rep_2_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("VENATOR_STAR_DESTROYER", rep_3_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("VENATOR_STAR_DESTROYER", rep_4_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("VENATOR_STAR_DESTROYER", rep_5_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("VENATOR_STAR_DESTROYER", rep_6_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("VENATOR_STAR_DESTROYER", rep_7_marker, p_republic, nil)

		MissionUtil.SpawnUnitSpace("CHARGER_C70", rep_1_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("CHARGER_C70", rep_2_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("CHARGER_C70", rep_3_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("CHARGER_C70", rep_4_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("CHARGER_C70", rep_5_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("CHARGER_C70", rep_6_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("CHARGER_C70", rep_7_marker, p_republic, nil)

		MissionUtil.AddToReinforcementPool("VENATOR_STAR_DESTROYER", p_republic, 3)
		MissionUtil.AddToReinforcementPool("CHARGER_C70", p_republic, 6)
	end
	if StoryUtil.GetDifficulty() == "HARD" then
		MissionUtil.SpawnUnitSpace("VENATOR_STAR_DESTROYER", rep_1_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("BYLUIR_VENATOR", rep_2_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("VENATOR_STAR_DESTROYER", rep_3_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("VENATOR_STAR_DESTROYER", rep_4_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("VENATOR_STAR_DESTROYER", rep_5_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("VENATOR_STAR_DESTROYER", rep_6_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("VENATOR_STAR_DESTROYER", rep_7_marker, p_republic, nil)

		MissionUtil.SpawnUnitSpace("CHARGER_C70", rep_1_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("CHARGER_C70", rep_2_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("CHARGER_C70", rep_3_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("CHARGER_C70", rep_4_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("CHARGER_C70", rep_5_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("CHARGER_C70", rep_6_marker, p_republic, nil)
		MissionUtil.SpawnUnitSpace("CHARGER_C70", rep_7_marker, p_republic, nil)

		MissionUtil.AddToReinforcementPool("VENATOR_STAR_DESTROYER", p_republic, 4)
		MissionUtil.AddToReinforcementPool("CHARGER_C70", p_republic, 8)
	end

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
		Spawn_From_Reinforcement_Pool(Find_Object_Type(GrievousObjectName), cis_1_marker, Find_Player("Rebel"))
		GrievousObject = Find_First_Object(GrievousObjectName)
		if TestValid(GrievousObject) then
			player_grievous = GrievousObject
		end
	end
	if not TestValid(player_grievous) then
		player_grievous = MissionUtil.SpawnUnitSpace("GRIEVOUS_INVISIBLE_HAND", cis_1_marker, p_cis, 300)
	end

	player_merai = Find_First_Object("MERAI_FREE_DAC")
	if not TestValid(player_merai) then
		player_merai = Spawn_From_Reinforcement_Pool(Find_Object_Type("MERAI_FREE_DAC"), cis_2_marker, p_cis)
		if player_merai then
			player_merai = player_merai[1]
		else
			player_merai = MissionUtil.SpawnUnitSpace("MERAI_FREE_DAC", cis_2_marker, p_cis, 300)
		end
	end

	Register_Death_Event(player_merai, State_Hero_Death)
	Register_Death_Event(player_grievous, State_Hero_Death)
	cinematic_one = true

	MissionUtil.PlayGenericMusic("CW_ARC_Trooper_Theme")
	Sleep(1.0)

	Fade_Screen_In(5.0)
	MissionUtil.CinematicIntroHeader("WATER_WORLD")

	MissionUtil.PlayGenericSpeech("Water_World_01")

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_1_marker, true, 9.0, nil, nil)
	Sleep(9.0)

	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_1_marker, true, 9.0, nil, nil)
	Sleep(9.0)

	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_2_marker, true, 9.0, nil, nil)
	Sleep(9.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end
function End_Cinematic_Intro_CIS()
	MissionUtil.EndCinematicCamera(cis_1_marker, 3.0)
	MissionUtil.CinematicEnvironmentOff()

	MissionUtil.MissionTextSpeech("WATER_WORLD", 1, 8.0, "Anakin_Loop", {r = 255, g = 255, b = 255})
	Register_Timer(State_Among_Us, 60)

	MissionUtil.SetObjectiveMissionSet("WATER_WORLD", "CIS", 3)
	MissionUtil.AIActivation()

	current_cinematic_thread_id = nil

	cinematic_one = false
	act_1_active = true
end

function Start_Cinematic_Outro_01_CIS()
	act_1_active = false
	cinematic_two_alt_01 = true

	Fade_Screen_Out(0.5)
	Sleep(0.5)

	MissionUtil.CinematicEnvironmentOn()
	MissionUtil.StartCinematicCamera()
	Sleep(0.5)

	Fade_Screen_In(0.5)
	Letter_Box_In(0.5)

	MissionUtil.PlayGenericSpeech("Water_World_03")

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
function Start_Cinematic_Outro_02_CIS()
	act_1_active = false
	cinematic_two_alt_02 = true

	Fade_Screen_Out(0.5)
	Sleep(0.5)

	MissionUtil.CinematicEnvironmentOn()
	MissionUtil.StartCinematicCamera()
	Sleep(0.5)

	Fade_Screen_In(0.5)
	Letter_Box_In(0.5)

	MissionUtil.MissionTextSpeech("WATER_WORLD", 2, 8.0, "Anakin_Loop", {r = 255, g = 255, b = 255})

	MissionUtil.SetCinematicCamera(outrocam_1_marker, outrocam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outrocam_target_1_marker, true, 8.0, nil, nil)
	Sleep(3.0)

	Fade_Screen_Out(4.0)
	Sleep(5.0)

	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.DisableRetreat("REBEL", false)
	MissionUtil.DisableRetreat("EMPIRE", false)

	StoryUtil.DeclareVictory(p_cis, false)
end

function Start_Cinematic_Intro_Rep()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	player_yularen = Find_First_Object("Yularen_Resolute")
	if not TestValid(player_yularen) then
		player_yularen = Find_First_Object("Yularen_Integrity")
		if not TestValid(player_yularen) then
			player_yularen = Spawn_From_Reinforcement_Pool(Find_Object_Type("Yularen_Resolute"), rep_1_marker, p_republic)
			if player_yularen then
				player_yularen = player_yularen[1]
				player_yularen = Spawn_Unit(Find_Object_Type("Yularen_Resolute"), rep_1_marker, p_republic)
			end
		end
		if not TestValid(player_yularen) then
			player_yularen = Spawn_From_Reinforcement_Pool(Find_Object_Type("Yularen_Integrity"), rep_1_marker, p_republic)
			if player_yularen then
				player_yularen = player_yularen[1]
				player_yularen = Spawn_Unit(Find_Object_Type("Yularen_Integrity"), rep_1_marker, p_republic)
				player_yularen = Find_Nearest(rep_1_marker, p_republic, true)
				player_yularen.Teleport_And_Face(rep_1_marker)	
			end
		end
	end

	player_byluir = Find_First_Object("Byluir_Venator")
	if not TestValid(player_byluir) then
		player_byluir = Spawn_From_Reinforcement_Pool(Find_Object_Type("Byluir_Venator"), rep_2_marker, p_republic)
		if player_byluir then
			player_byluir = player_byluir[1]
			player_byluir = Spawn_Unit(Find_Object_Type("Byluir_Venator"), rep_2_marker, p_republic)
		end
	end

	cinematic_one = true

	MissionUtil.PlayGenericMusic("CW_ARC_Trooper_Theme")
	Sleep(1.0)

	Fade_Screen_In(5.0)
	MissionUtil.CinematicIntroHeader("WATER_WORLD")

	MissionUtil.PlayGenericSpeech("Water_World_01")

	if StoryUtil.GetDifficulty()== "EASY" then
		MissionUtil.SpawnUnitSpace("MERAI_FREE_DAC", cis_1_marker, p_cis, 300)
		MissionUtil.SpawnUnitSpace("MUNIFICENT_SUBFACTION", cis_2_marker, p_cis, 300)
		MissionUtil.SpawnUnitSpace("MUNIFICENT_SUBFACTION", cis_3_marker, p_cis, 300)
		MissionUtil.SpawnUnitSpace("MUNIFICENT_SUBFACTION", cis_4_marker, p_cis, 300)
	end
	if StoryUtil.GetDifficulty()== "NORMAL" then
		MissionUtil.SpawnUnitSpace("MERAI_FREE_DAC", cis_1_marker, p_cis, 300)
		MissionUtil.SpawnUnitSpace("MUNIFICENT_SUBFACTION", cis_2_marker, p_cis, 300)
		MissionUtil.SpawnUnitSpace("MUNIFICENT_SUBFACTION", cis_3_marker, p_cis, 300)
		MissionUtil.SpawnUnitSpace("MUNIFICENT_SUBFACTION", cis_4_marker, p_cis, 300)
	end
	if StoryUtil.GetDifficulty()== "HARD" then
		MissionUtil.SpawnUnitSpace("MERAI_FREE_DAC", cis_1_marker, p_cis, 300)
		MissionUtil.SpawnUnitSpace("MUNIFICENT_SUBFACTION", cis_2_marker, p_cis, 300)
		MissionUtil.SpawnUnitSpace("MUNIFICENT_SUBFACTION", cis_3_marker, p_cis, 300)
		MissionUtil.SpawnUnitSpace("MUNIFICENT_SUBFACTION", cis_4_marker, p_cis, 300)
	end

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_1_marker, true, 9.0, nil, nil)
	Sleep(9.0)

	if StoryUtil.GetDifficulty()== "EASY" then
		MissionUtil.SpawnUnitSpace("HARDCELL_TENDER", cis_4_marker, p_cis, 300)
		MissionUtil.SpawnUnitSpace("C9979_CARRIER", cis_5_marker, p_cis, 300)
		MissionUtil.SpawnUnitSpace("C9979_CARRIER", cis_6_marker, p_cis, 300)
		MissionUtil.SpawnUnitSpace("PROVIDENCE_CARRIER_DESTROYER", cis_6_marker, p_cis, 300)
	end
	if StoryUtil.GetDifficulty()== "NORMAL" then
		MissionUtil.SpawnUnitSpace("HARDCELL_TENDER", cis_4_marker, p_cis, 300)
		MissionUtil.SpawnUnitSpace("C9979_CARRIER", cis_5_marker, p_cis, 300)
		MissionUtil.SpawnUnitSpace("C9979_CARRIER", cis_6_marker, p_cis, 300)
		MissionUtil.SpawnUnitSpace("RECUSANT_DREADNOUGHT", cis_7_marker, p_cis, 300)
	end
	if StoryUtil.GetDifficulty()== "HARD" then
		MissionUtil.SpawnUnitSpace("HARDCELL_TENDER", cis_4_marker, p_cis, 300)
		MissionUtil.SpawnUnitSpace("C9979_CARRIER", cis_5_marker, p_cis, 300)
		MissionUtil.SpawnUnitSpace("C9979_CARRIER", cis_5_marker, p_cis, 300)
		MissionUtil.SpawnUnitSpace("PROVIDENCE_CARRIER_DESTROYER", cis_6_marker, p_cis, 300)
		MissionUtil.SpawnUnitSpace("RECUSANT_DREADNOUGHT", cis_7_marker, p_cis, 300)
	end

	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_1_marker, true, 9.0, nil, nil)
	Sleep(9.0)

	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_2_marker, true, 9.0, nil, nil)
	Sleep(9.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Rep")
	end
end
function End_Cinematic_Intro_Rep()
	MissionUtil.EndCinematicCamera(rep_1_marker, 3.0)
	MissionUtil.CinematicEnvironmentOff()

	AI_Fleet = SpawnList(cis_attacker_list, Find_First_Object("ATTACKER ENTRY POSITION").Get_Position(), p_cis, true, true)
	AI_Fleet = AI_Fleet[1]
	AI_Fleet.Teleport_And_Face(Find_First_Object("ATTACKER ENTRY POSITION"))

	MissionUtil.MissionTextSpeech("WATER_WORLD", 1, 8.0, "Anakin_Loop", {r = 255, g = 255, b = 255})
	Register_Timer(State_Among_Us, 120)

	MissionUtil.SetObjectiveMissionSet("WATER_WORLD", "REP", 2)
	MissionUtil.AIActivation()

	if TestValid(Find_First_Object("MERAI_FREE_DAC")) then
		Register_Death_Event(Find_First_Object("MERAI_FREE_DAC"), State_Hero_Death)
	end

	current_cinematic_thread_id = nil

	cinematic_one = false
	act_1_active = true
end

function Start_Cinematic_Outro_01_Rep()
	act_1_active = false
	cinematic_two_alt_01 = true

	Fade_Screen_Out(0.5)
	Sleep(0.5)

	MissionUtil.CinematicEnvironmentOn()
	MissionUtil.StartCinematicCamera()
	Sleep(0.5)

	Fade_Screen_In(0.5)
	Letter_Box_In(0.5)

	MissionUtil.PlayGenericSpeech("Water_World_03")

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
function Start_Cinematic_Outro_02_Rep()
	act_1_active = false
	cinematic_two_alt_02 = true

	Fade_Screen_Out(0.5)
	Sleep(0.5)

	MissionUtil.CinematicEnvironmentOn()
	MissionUtil.StartCinematicCamera()
	Sleep(0.5)

	Fade_Screen_In(0.5)
	Letter_Box_In(0.5)

	MissionUtil.MissionTextSpeech("WATER_WORLD", 2, 8.0, "Anakin_Loop", {r = 255, g = 255, b = 255})

	MissionUtil.SetCinematicCamera(outrocam_1_marker, outrocam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outrocam_target_1_marker, true, 8.0, nil, nil)
	Sleep(3.0)

	Fade_Screen_Out(4.0)
	Sleep(5.0)

	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.DisableRetreat("REBEL", false)
	MissionUtil.DisableRetreat("EMPIRE", false)

	StoryUtil.DeclareVictory(p_cis, false)
end
