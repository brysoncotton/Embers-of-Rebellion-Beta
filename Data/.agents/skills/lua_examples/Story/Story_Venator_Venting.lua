
--*****************************************************--
--********* Foerost Campaign: Venator Venting *********--
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

	b1_squad_list =	{"B1_DROID_COMPANY"}
	b1_marine_squad_list = ("B1_DROID_MARINE_COMPANY")
	b2_squad_list =	{"B2_DROID_COMPANY"}
	bx_squad_list =	{"BX_COMMANDO_TEAM"}
	crab_squad_list = {"CRAB_DROID_COMPANY"}
	dsd_squad_list = {"DWARF_SPIDER_DROID_COMPANY"}
	magna_squad_list = {"MAGNAGUARD_SQUAD"}

	arc_squad_list = {"ARC_PHASE_TWO_COMPANY"}
	clone_squad_list = {"CLONETROOPER_PHASE_TWO_COMPANY"}
	sd_6_squad_list = {"REPUBLIC_SD_6_DROID_COMPANY"}
	barc_squad_list = {"REPUBLIC_BARC_COMPANY"}
	atpt_squad_list = {"REPUBLIC_AT_PT_COMPANY"}
	atrt_squad_list = {"REPUBLIC_AT_RT_COMPANY"}

	act_1_active = false

	cinematic_one = false
	cinematic_one_skipped = false
end
function Begin_Battle(message)
	if message == OnEnter then
		MissionUtil.VictoryAllowance(false)

		MissionUtil.DisableRetreat("REBEL", true)
		MissionUtil.DisableRetreat("EMPIRE", true)

		MissionUtil.AllowOrbitalSupport(p_cis, false)
		MissionUtil.AllowOrbitalSupport(p_republic, false)

		p_cis.Disable_Bombing_Run(false)
		p_republic.Disable_Bombing_Run(false)

		p_cis.Disable_Orbital_Bombardment(true)
		p_republic.Disable_Orbital_Bombardment(true)

		deactivated_table = Find_All_Objects_With_Hint("deactivated")
		for i,attes in pairs(deactivated_table) do
			attes.Suspend_Locomotor(true)
		end

		attacker_marker = Find_First_Object("Attacker Entry Position")

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-2")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")

		defender_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-1")
		defender_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-2")
		defender_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-3")
		defender_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-4")
		defender_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-5")
		defender_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-6")
		defender_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-7")
		defender_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-8")
		defender_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-9")
		defender_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "defender-10")

		terminal_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "terminal")
		terminal_marker.Highlight(true)
		Add_Radar_Blip(terminal_marker, "terminal_blip")

		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
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

				if StoryUtil.GetDifficulty() == "EASY" then
					Reinforce_Unit(Find_Object_Type("B2_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B2_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B2_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B2_DROID_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("B1_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B1_DROID_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("ELITE_MERCENARY_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("ELITE_MERCENARY_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("PAC_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("BX_COMMANDO_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("BX_COMMANDO_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)


					SpawnList(arc_squad_list, defender_1_marker, p_republic, true, true)
					SpawnList(arc_squad_list, defender_2_marker, p_republic, true, true)
					SpawnList(clone_squad_list, defender_3_marker, p_republic, true, true)
					SpawnList(clone_squad_list, defender_4_marker, p_republic, true, true)
					SpawnList(atpt_squad_list, defender_5_marker, p_republic, true, true)
					SpawnList(sd_6_squad_list, defender_6_marker, p_republic, true, true)
					SpawnList(atrt_squad_list, defender_7_marker, p_republic, true, true)
					SpawnList(barc_squad_list, defender_8_marker, p_republic, true, true)
					SpawnList(arc_squad_list, defender_9_marker, p_republic, true, true)

				end
				if StoryUtil.GetDifficulty() == "NORMAL" then
					Reinforce_Unit(Find_Object_Type("B2_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B2_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B2_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B2_DROID_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("B1_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B1_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B1_DROID_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("ELITE_MERCENARY_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("ELITE_MERCENARY_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("BX_COMMANDO_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("BX_COMMANDO_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)


					SpawnList(arc_squad_list, defender_1_marker, p_republic, true, true)
					SpawnList(arc_squad_list, defender_2_marker, p_republic, true, true)
					SpawnList(clone_squad_list, defender_3_marker, p_republic, true, true)
					SpawnList(clone_squad_list, defender_4_marker, p_republic, true, true)
					SpawnList(atpt_squad_list, defender_5_marker, p_republic, true, true)
					SpawnList(sd_6_squad_list, defender_6_marker, p_republic, true, true)
					SpawnList(atrt_squad_list, defender_7_marker, p_republic, true, true)
					SpawnList(barc_squad_list, defender_8_marker, p_republic, true, true)
					SpawnList(arc_squad_list, defender_9_marker, p_republic, true, true)
					SpawnList(arc_squad_list, defender_10_marker, p_republic, true, true)
				end
				if StoryUtil.GetDifficulty() == "HARD" then
					Reinforce_Unit(Find_Object_Type("B2_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B2_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B2_DROID_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("B1_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B1_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B1_DROID_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("ELITE_MERCENARY_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("ELITE_MERCENARY_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("BX_COMMANDO_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("BX_COMMANDO_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)

					Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
					Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)


					SpawnList(arc_squad_list, defender_1_marker, p_republic, true, true)
					SpawnList(arc_squad_list, defender_2_marker, p_republic, true, true)
					SpawnList(clone_squad_list, defender_3_marker, p_republic, true, true)
					SpawnList(clone_squad_list, defender_4_marker, p_republic, true, true)
					SpawnList(sd_6_squad_list, defender_5_marker, p_republic, true, true)
					SpawnList(sd_6_squad_list, defender_6_marker, p_republic, true, true)
					SpawnList(barc_squad_list, defender_7_marker, p_republic, true, true)
					SpawnList(barc_squad_list, defender_8_marker, p_republic, true, true)
					SpawnList(atpt_squad_list, defender_9_marker, p_republic, true, true)
					SpawnList(atrt_squad_list, defender_10_marker, p_republic, true, true)

				end

				MissionUtil.CinematicSkippingCleanUp(attacker_marker)
				MissionUtil.SetObjectiveMissionSet("VENATOR_VENTING", "CIS", 1)

				MissionUtil.MissionTextSpeech("VENATOR_VENTING", 1, 8.0, nil, {r = 255, g = 0, b = 0})

				cinematic_one = false
				act_1_active = true

				Fade_Screen_In(0.5)
			end
		end
	end
end
function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_1_active then
			terminal_list = Find_All_Objects_Of_Type("MISSION_CONTROL_PANEL")
			if (table.getn(terminal_list) == 0) then
				GlobalValue.Set("Foerost_CIS_Renown_Conquered", 1)
				StoryUtil.TriggerScriptedBattle("CARIDA_CATACLYSM", "CARIDA", "SPACE", "REBEL", "EMPIRE", false)
				StoryUtil.DeclareVictory(p_cis, false)

				MissionUtil.AllowOrbitalSupport(p_cis, true)
				MissionUtil.AllowOrbitalSupport(p_republic, true)
				act_1_active = false
			end

			local cis_list = Find_All_Objects_Of_Type(p_cis, "Vehicle | Infantry | AirGunship | AirSpeeder | InfantryHero | VehicleHero")
			if (table.getn(cis_list) == 0) then
				StoryUtil.DeclareVictory(p_cis, false)

				MissionUtil.AllowOrbitalSupport(p_cis, true)
				MissionUtil.AllowOrbitalSupport(p_republic, true)
				act_1_active = false
			end
		end
	end
end

function Start_Cinematic_Intro_CIS()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()
	Fade_On()

	cinematic_one = true

	MissionUtil.PlayGenericMusic("CIS_Tactical_Battle")
	MissionUtil.CinematicIntroHeader("VENATOR_VENTING")
	Sleep(3.0)

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_1_marker, true, 7.5, nil, nil)

	Fade_Screen_In(0.5)
	Letter_Box_In(0.5)
	Sleep(6.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end
function End_Cinematic_Intro_CIS()
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(attacker_marker, 3.5)

	MissionUtil.SetObjectiveMissionSet("VENATOR_VENTING", "CIS", 1)

	MissionUtil.MissionTextSpeech("VENATOR_VENTING", 1, 8.0, nil, {r = 255, g = 0, b = 0})

	if StoryUtil.GetDifficulty() == "EASY" then
		Reinforce_Unit(Find_Object_Type("B2_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_COMPANY"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("B1_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_COMPANY"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_COMPANY"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("ELITE_MERCENARY_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("ELITE_MERCENARY_COMPANY"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("PAC_COMPANY"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("BX_COMMANDO_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("BX_COMMANDO_COMPANY"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)


		SpawnList(arc_squad_list, defender_1_marker, p_republic, true, true)
		SpawnList(arc_squad_list, defender_2_marker, p_republic, true, true)
		SpawnList(clone_squad_list, defender_3_marker, p_republic, true, true)
		SpawnList(clone_squad_list, defender_4_marker, p_republic, true, true)
		SpawnList(atpt_squad_list, defender_5_marker, p_republic, true, true)
		SpawnList(sd_6_squad_list, defender_6_marker, p_republic, true, true)
		SpawnList(atrt_squad_list, defender_7_marker, p_republic, true, true)
		SpawnList(barc_squad_list, defender_8_marker, p_republic, true, true)
		SpawnList(arc_squad_list, defender_9_marker, p_republic, true, true)

	end
	if StoryUtil.GetDifficulty() == "NORMAL" then
		Reinforce_Unit(Find_Object_Type("B2_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_COMPANY"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("B1_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_COMPANY"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_COMPANY"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("ELITE_MERCENARY_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("ELITE_MERCENARY_COMPANY"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("BX_COMMANDO_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("BX_COMMANDO_COMPANY"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)


		SpawnList(arc_squad_list, defender_1_marker, p_republic, true, true)
		SpawnList(arc_squad_list, defender_2_marker, p_republic, true, true)
		SpawnList(clone_squad_list, defender_3_marker, p_republic, true, true)
		SpawnList(clone_squad_list, defender_4_marker, p_republic, true, true)
		SpawnList(atpt_squad_list, defender_5_marker, p_republic, true, true)
		SpawnList(sd_6_squad_list, defender_6_marker, p_republic, true, true)
		SpawnList(atrt_squad_list, defender_7_marker, p_republic, true, true)
		SpawnList(barc_squad_list, defender_8_marker, p_republic, true, true)
		SpawnList(arc_squad_list, defender_9_marker, p_republic, true, true)
		SpawnList(arc_squad_list, defender_10_marker, p_republic, true, true)
	end
	if StoryUtil.GetDifficulty() == "HARD" then
		Reinforce_Unit(Find_Object_Type("B2_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B2_DROID_COMPANY"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("B1_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_COMPANY"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("B1_DROID_MARINE_COMPANY"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("ELITE_MERCENARY_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("ELITE_MERCENARY_COMPANY"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("BX_COMMANDO_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("BX_COMMANDO_COMPANY"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("CRAB_DROID_COMPANY"), false, p_cis, true, false)

		Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)
		Reinforce_Unit(Find_Object_Type("DWARF_SPIDER_DROID_COMPANY"), false, p_cis, true, false)


		SpawnList(arc_squad_list, defender_1_marker, p_republic, true, true)
		SpawnList(arc_squad_list, defender_2_marker, p_republic, true, true)
		SpawnList(clone_squad_list, defender_3_marker, p_republic, true, true)
		SpawnList(clone_squad_list, defender_4_marker, p_republic, true, true)
		SpawnList(sd_6_squad_list, defender_5_marker, p_republic, true, true)
		SpawnList(sd_6_squad_list, defender_6_marker, p_republic, true, true)
		SpawnList(barc_squad_list, defender_7_marker, p_republic, true, true)
		SpawnList(barc_squad_list, defender_8_marker, p_republic, true, true)
		SpawnList(atpt_squad_list, defender_9_marker, p_republic, true, true)
		SpawnList(atrt_squad_list, defender_10_marker, p_republic, true, true)

	end

	cinematic_one = false
	act_1_active = true
end
