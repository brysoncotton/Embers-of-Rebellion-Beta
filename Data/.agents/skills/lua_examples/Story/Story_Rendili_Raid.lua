
--*****************************************************--
--********** Foerost Campaign: Rendili Raid ***********--
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
		defender_marker = Find_First_Object("Defending Forces Position")
		player_renown = Find_First_Object("VENATOR_RENOWN")
		player_renown.Highlight(true)
		player_renown.Suspend_Locomotor(true)

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-4")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")

		p_cis.Make_Ally(p_republic)
		p_republic.Make_Ally(p_cis)

		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
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
				p_republic.Make_Enemy(p_cis)
				p_cis.Make_Enemy(p_republic)

				Point_Camera_At(attacker_marker)
				Letter_Box_Out(0)
				Lock_Controls(0)
				Suspend_AI(0)
				End_Cinematic_Camera()

				MissionUtil.AIActivation()
				Story_Event("GOAL_TRIGGER_CIS_I")

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
			if not renown_captured then
				if Find_First_Object("VENATOR_RENOWN").Get_Hull() <= 0.10 then
					renown_captured = true
					Story_Event("RENOWN_CONQUERED")
					Story_Event("SHOWDOWN_02")
					Find_First_Object("VENATOR_RENOWN").Change_Owner(p_cis)
					Find_First_Object("VENATOR_RENOWN").Make_Invulnerable(true)
					Find_First_Object("VENATOR_RENOWN").Set_Selectable(false)
				end
			end
			rep_list = Find_All_Objects_Of_Type(p_republic, "SpaceHero | Corvette | Capital | Frigate | SuperCapital")
			rep2_list = Find_All_Objects_Of_Type("EMPIRE_STAR_BASE_3")
			rep3_list = Find_All_Objects_Of_Type("EMPIRE_STAR_BASE_4")
			if (table.getn(rep_list) == 0) and (table.getn(rep2_list) == 0) and (table.getn(rep3_list) == 0) then
				Story_Event("RENOWN_CONQUERED")
				StoryUtil.DeclareVictory(p_cis, false)
			end
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

	Clone_Saver_Fleet = SpawnList(republic_defender_list, defender_marker, p_republic, false, true)
	Clone_Saver = Clone_Saver_Fleet[1]
	Clone_Saver.Teleport_And_Face(defender_marker)
	Clone_Saver.Cinematic_Hyperspace_In(100)

	cinematic_one = true

	Letter_Box_In(2)
	Fade_Screen_In(2)
	Play_Music("CIS_Tactical_Battle")

	Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 13.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 13.5, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Sleep(2.0)

	Story_Event("CINEMATIC_CRAWL_01")
	Sleep(3.0)

	Story_Event("CINEMATIC_CRAWL_02")
	Sleep(10.0)

	Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_4_marker, 10, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_4_marker, 10, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Story_Event("SHOWDOWN_01")
	Sleep(10.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end
function End_Cinematic_Intro_CIS()
	Point_Camera_At(attacker_marker)
	Transition_To_Tactical_Camera(3)
	Letter_Box_Out(3)
	Sleep(3.0)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Suspend_AI(0)

	p_cis.Make_Enemy(p_republic)
	p_republic.Make_Enemy(p_cis)

	Story_Event("GOAL_TRIGGER_CIS_I")
	MissionUtil.AIActivation()

	cinematic_one = false
	act_1_active = true

	MissionUtil.CinematicEnvironmentOff()
end
