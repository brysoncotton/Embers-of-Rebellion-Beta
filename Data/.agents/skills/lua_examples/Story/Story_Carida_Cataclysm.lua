
--*****************************************************--
--******** Foerost Campaign: Carida Cataclysm *********--
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

	republic_defender_list = {
		"Victory_I_Fleet_Star_Destroyer",
		"Victory_I_Fleet_Star_Destroyer",
		"Victory_I_Fleet_Star_Destroyer",
		"PDF_DHC",
		"PDF_DHC",
		"PDF_DHC",
		"Customs_Corvette",
		"Customs_Corvette",
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")

	act_1_active = false

	cinematic_one = false
	cinematic_one_skipped = false

	current_cinematic_thread_id = nil
end

function Begin_Battle(message)
	if message == OnEnter then
		attacker_marker = Find_First_Object("Attacker Entry Position")

		rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-1")
		rep_fleet_02_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-2")
		rep_fleet_03_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-3")
		rep_fleet_04_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-4")
		rep_fleet_05_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-5")

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-4")
		introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-5")
		introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-6")
		introcam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-7")
		introcam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-8")
		introcam_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-9")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")
		introcam_target_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-4")

		intro_1_renown_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-renown")
		intro_2_renown_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-renown")
		intro_3_renown_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-3-renown")

		player_station = Find_Hint("EMPIRE_STAR_BASE_5", "station")

		p_cis.Make_Ally(p_republic)
		p_republic.Make_Ally(p_cis)

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

				Fade_Screen_Out(0)
				Stop_All_Music()
				Stop_All_Speech()
				Remove_All_Text()
				Stop_Bink_Movie()
				MissionUtil.CinematicEnvironmentOff()

				StoryUtil.DeclareVictory(p_cis, false)
			end
		end
	end
end

function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_1_active then
		end
	end
end


function Start_Cinematic_Intro_CIS()
	Start_Cinematic_Camera()
	Stop_All_Music()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()
	Fade_On()
	Sleep(0.5)

	player_renown = Find_First_Object("Venator_Renown")

	cinematic_one = true

	Letter_Box_In(3)
	Fade_Screen_In(5)
	Play_Music("ESB_The_Ice_Planet_Hoth")

	Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 13.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 13.5, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Sleep(2.0)

	Story_Event("CINEMATIC_CRAWL_01")
	Sleep(3.0)

	Story_Event("CINEMATIC_CRAWL_02")
	Sleep(6.5)

	Fade_Screen_Out(2)
	Sleep(3.5)

	player_renown.Cinematic_Hyperspace_In(50)

	Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_4_marker, 10, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_4_marker, 10, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Story_Event("SHOWDOWN_01")
	Fade_Screen_In(2)
	Sleep(8)

	Set_Cinematic_Camera_Key(introcam_6_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_6_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_5_marker, 7, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_5_marker, 7, 0, 0, 0, 0, intro_3_renown_marker, 1, 0)
	Story_Event("SHOWDOWN_02")
	Sleep(6.5)
	
	player_renown.Teleport_And_Face(intro_2_renown_marker)
	player_renown.Move_To(intro_3_renown_marker)

	MissionUtil.PlayGenericSpeech("Alarm_Sound")

	Set_Cinematic_Camera_Key(introcam_8_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_8_marker, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_9_marker, 15, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_9_marker, 15, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	Sleep(1.0)

	Story_Event("SHOWDOWN_03")
	Sleep(3.0)

	Stop_All_Speech()

	if TestValid(player_renown) then
		Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), player_renown, p_invaders)
		player_renown.Take_Damage(100000)
	end

	if TestValid(player_station) then
		Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), player_station, p_invaders)
		player_station.Take_Damage(100000)
	end

	venator_list = Find_All_Objects_With_Hint("1")
		for i,venator_unit in pairs(venator_list) do
		if TestValid(venator_unit) then
			Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), venator_unit, p_invaders)
			venator_unit.Take_Damage(100000)
		end
	end

	explosion_list = Find_All_Objects_With_Hint("explosion-1")
		for i,explosion_unit in pairs(explosion_list) do
		if TestValid(explosion_unit) then
			Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), explosion_unit, p_invaders)
		end
	end
	Sleep(4.0)

	Play_Music("Grievous_Theme")
	Story_Event("SHOWDOWN_04")
	Sleep(6.0)
	Fade_Screen_Out(6.0)
	Sleep(5.0)
	StoryUtil.DeclareVictory(p_cis, false)
end
