
--*****************************************************--
--******* Operation Durge's Lance: Crazy Clone ********--
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
		Trigger_Mady_Captured = State_Mady_Captured
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")

	clone_commando_list = {"CLONE_COMMANDO_SQUAD"}
	clone_commando_full_list = {"CLONE_COMMANDO_COMPANY"}
	bx_squad_list = {"BX_COMMANDO_COMPANY"}

	current_cinematic_thread_id = nil

	act_1_active = false
	act_2_active = false

	cinematic_one = false
	cinematic_two = false
	cinematic_three = false
	cinematic_four = false

	cinematic_one_skipped = false
	cinematic_two_skipped = false
	cinematic_three_skipped = false
	cinematic_four_skipped = false

	mady_reached = false
	mady_captured = false

	mission_started = false
end

function Begin_Battle(message)
	if message == OnEnter then
		GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 0)

		player_mady = Find_First_Object("MAD_CLONE_OF_KAIKIELIUS")

		intro_1_mady_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-mady")
		intro_2_mady_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-mady")
		intro_3_mady_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-3-mady")
		intro_4_mady_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-4-mady")

		intro_1_clone_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-clone-1")
		intro_2_clone_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-clone-1")
		intro_3_clone_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-3-clone-1")
		intro_4_clone_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-4-clone-1")

		intro_1_clone_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-clone-2")
		intro_2_clone_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-clone-2")

		intro_1_clone_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-clone-3")
		intro_2_clone_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-clone-3")

		intro_1_clone_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-clone-4")
		intro_2_clone_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-clone-4")

		intro_1_clone_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-clone-5")
		intro_2_clone_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-clone-5")

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-4")
		introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-5")
		introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-6")
		introcam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-7")
		introcam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-8")
		introcam_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-9")
		introcam_10_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-10-1")
		introcam_10_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-10-2")
		introcam_10_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-10-3")
		introcam_11_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-11")
		introcam_12_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-12")
		introcam_13_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-13")
		introcam_14_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-14")
		introcam_15_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-15")
		introcam_16_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-16")
		introcam_17_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-17")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")
		introcam_target_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-4")
		introcam_target_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-5")
		introcam_target_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-6")

		midtro_1_probe_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-1-probe")

		midtro_1_mady_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-1-mady")
		midtro_2_mady_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-2-mady")

		midtro_1_clone_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-1-clone-1")
		midtro_2_clone_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-2-clone-1")

		midtro_1_clone_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-1-clone-2")
		midtro_1_clone_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-1-clone-3")

		midtro_1_bx_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-1-bx-1")
		midtro_1_bx_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-1-bx-2")
		midtro_1_bx_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-1-bx-3")

		squad_1_rep_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "squad-1-rep")
		squad_2_rep_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "squad-2-rep")

		squad_1_cis_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "squad-1-cis")
		squad_2_cis_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "squad-2-cis")

		rep_squad_move_to_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-squad-move-to")

		shuttle_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "shuttle")

		midtrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-1")
		midtrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-2")
		midtrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-3")
		midtrocam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-4")
		midtrocam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-5")
		midtrocam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-6")
		midtrocam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-7")
		midtrocam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-8")
		midtrocam_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-9")
		midtrocam_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-10")
		midtrocam_11_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-11")
		midtrocam_12_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-12")
		midtrocam_13_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-13")
		midtrocam_14_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-14")
		midtrocam_15_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-15")
		midtrocam_16_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-16")

		midtrocam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-target-1")
		midtrocam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-target-2")
		midtrocam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-target-3")
		midtrocam_target_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-target-4")
		midtrocam_target_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-target-5")

		outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-1")
		outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-2")

		p_cis.Make_Ally(p_republic)
		p_republic.Make_Ally(p_cis)

		p_invaders.Make_Enemy(p_republic)
		p_republic.Make_Enemy(p_invaders)

		p_cis.Disable_Bombing_Run(false)
		p_republic.Disable_Bombing_Run(false)

		p_cis.Disable_Orbital_Bombardment(true)
		p_republic.Disable_Orbital_Bombardment(true)

		mission_started = true
		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_01_CIS")
		elseif p_republic.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
		end
	end
end


function State_Shuttle_Escape(prox_obj, trigger_obj)
	if mady_captured then
		if trigger_obj == player_mady then
			mady_reached = true
		end
		if mady_reached then
			Remove_Radar_Blip("shuttle_blip")
			shuttle_marker.Highlight(false)
			Story_Event("SHUTTLE_REACHED")
			prox_obj.Cancel_Event_Object_In_Range(State_Shuttle_Escape)
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
		end
	end
end

function State_Mady_Captured(message)
	if message == OnEnter then
		player_mady_position = Find_First_Object("MAD_CLONE_OF_KAIKIELIUS")
		Find_First_Object("MAD_CLONE_OF_KAIKIELIUS").Despawn()
		mady_unit = Find_Object_Type("MAD_CLONE_OF_KAIKIELIUS")
		mady_list = Spawn_Unit(mady_unit, player_mady_position, p_cis)
		player_mady = mady_list[1]
		player_mady.Teleport_And_Face(player_mady_position)
		player_mady.Prevent_All_Fire(true)
		player_mady.Prevent_Opportunity_Fire(true)
		player_mady.Set_Cannot_Be_Killed(false)

		Add_Radar_Blip(shuttle_marker, "shuttle_blip")
		shuttle_marker.Highlight(true)

		Story_Event("TRUST_NO_ONE_25")
		Story_Event("GOAL_TRIGGER_CIS_II")
	end
end


function Story_Handle_Esc()
	if mission_started then
		if p_cis.Is_Human() then
			if cinematic_one then
				if not cinematic_one_skipped then
					cinematic_one_skipped = true
	
					if current_cinematic_thread_id ~= nil then
						Thread.Kill(current_cinematic_thread_id)
						current_cinematic_thread_id = nil
					end
					if TestValid(player_mady) then
						player_mady.Despawn()
					end
					if TestValid(player_clone_1) then
						player_clone_1.Despawn()
					end
					if TestValid(player_clone_3) then
						player_clone_3.Despawn()
					end
					if TestValid(player_clone_5) then
						player_clone_5.Despawn()
					end
					Stop_All_Speech()
					Remove_All_Text()
					Fade_On()
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
					if TestValid(player_mady) then
						player_mady.Despawn()
					end
					if TestValid(player_midtro_clone_1) then
						player_midtro_clone_1.Despawn()
					end
					if TestValid(player_midtro_clone_2) then
						player_midtro_clone_2.Despawn()
					end
					if TestValid(player_midtro_clone_3) then
						player_midtro_clone_3.Despawn()
					end

					p_cis.Make_Enemy(p_republic)
					p_republic.Make_Enemy(p_cis)

					Stop_All_Speech()
					Remove_All_Text()
					Fade_On()
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

					Fade_Screen_Out(0)
					Stop_All_Music()
					Stop_All_Speech()
					Remove_All_Text()
					Stop_Bink_Movie()

					MissionUtil.CinematicEnvironmentOff()
					Story_Event("COMMENCE_ASSAULT")

					GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)

					StoryUtil.DeclareVictory(p_republic, false)

					Fade_Screen_In(0.5)
					Sleep(0.5)
				end
			end
		elseif p_republic.Is_Human() then
		end
	end
end

function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_1_active then
			if not mady_captured then
				if Find_First_Object("MAD_CLONE_OF_KAIKIELIUS").Get_Health() <= 0.1 then
					Story_Event("MADY_CAPTURED")
					mady_captured = true
				end
			end
		end
	elseif p_republic.Is_Human() then
	end
end


function Start_Cinematic_Intro_01_CIS()
	Start_Cinematic_Camera()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()
	Stop_All_Music()
	Fade_On()

	case_unit = Find_Object_Type("MAD_CLONE_OF_KAIKIELIUS")
	case_list = Spawn_Unit(case_unit, intro_1_clone_1_marker, p_republic)
	player_clone_1 = case_list[1]
	player_clone_1.Teleport_And_Face(intro_1_clone_1_marker)

	clone_3_list = Spawn_Unit(case_unit, intro_1_clone_3_marker, p_republic)
	player_clone_3 = clone_3_list[1]
	player_clone_3.Teleport_And_Face(intro_1_clone_3_marker)

	coop_list = Spawn_Unit(case_unit, intro_1_clone_5_marker, p_republic)
	player_clone_5 = coop_list[1]
	player_clone_5.Teleport_And_Face(intro_1_clone_5_marker)

	cinematic_one = true
	Play_Music("RotJ_Shuttle_Tydirium_Approaches_Endor_Theme_Crazy_Clone")

	player_mady.Teleport_And_Face(intro_1_mady_marker)
	player_clone_3.Teleport_And_Face(intro_1_clone_3_marker)
	player_clone_5.Teleport_And_Face(intro_1_clone_5_marker)

	Story_Event("CINEMATIC_INTRO_01")
	Sleep(1.0)

	Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 11.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 11.0, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)

	Fade_Screen_In(5.0)
	Letter_Box_In(5.0)
	Sleep(2.0)

	Story_Event("CINEMATIC_INTRO_02")
	Sleep(3.0)

	player_clone_1.Move_To(intro_2_clone_1_marker)
	Sleep(5.0)

	Transition_Cinematic_Camera_Key(introcam_3_marker, 12.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_3_marker, 12.0, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)

	player_mady.Play_Animation("Idle", false, 1)
	player_clone_1.Play_Animation("Talk", false, 2)
	Story_Event("TRUST_NO_ONE_01")
	MissionUtil.PlayGenericSpeech("Crazy_Clone_01")
	Sleep(5.0)

	Story_Event("TRUST_NO_ONE_02")
	MissionUtil.PlayGenericSpeech("Crazy_Clone_02")
	player_clone_1.Play_Animation("Talk", false, 0)
	Sleep(8.0)

	Set_Cinematic_Camera_Key(introcam_6_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_6_marker, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_7_marker, 10.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_7_marker, 10.5, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)

	Story_Event("TRUST_NO_ONE_02_1")
	player_mady.Play_Animation("Idle", false, 4)
	Sleep(3.5)

	player_clone_1.Turn_To_Face(player_mady)
	player_clone_1.Play_Animation("Talk", false, 1)
	Story_Event("TRUST_NO_ONE_03")
	MissionUtil.PlayGenericSpeech("Crazy_Clone_03")
	Sleep(7.0)

	Set_Cinematic_Camera_Key(introcam_4_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_4_marker, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_5_marker, 8.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_5_marker, 8.5, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Sleep(0.5)

	player_mady.Play_Animation("Idle", false, 3)
	Story_Event("TRUST_NO_ONE_04")
	MissionUtil.PlayGenericSpeech("Crazy_Clone_04")
	Sleep(5.0)

	player_mady.Move_To(intro_2_mady_marker)
	player_clone_1.Turn_To_Face(player_mady)
	Sleep(0.5)

	player_clone_1.Move_To(intro_3_clone_1_marker)
	Sleep(0.5)

	Fade_Screen_Out(1.5)
	Sleep(2.0)

	Play_Music("AOTC_Ambush_On_Coruscant_Theme_Crazy_Clone")

	player_mady.Teleport_And_Face(intro_2_mady_marker)
	player_clone_1.Teleport_And_Face(intro_3_clone_1_marker)

	player_mady.Turn_To_Face(player_clone_5)
	player_clone_1.Turn_To_Face(player_clone_5)
	player_clone_3.Turn_To_Face(player_clone_5)
	player_clone_5.Turn_To_Face(intro_1_clone_2_marker)

	Set_Cinematic_Camera_Key(introcam_8_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_8_marker, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_9_marker, 8.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_9_marker, 8.0, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)

	player_clone_5.Play_Animation("Talk_Gesture", false, 0)
	Story_Event("TRUST_NO_ONE_05")
	MissionUtil.PlayGenericSpeech("Crazy_Clone_05")
	Fade_Screen_In(0.5)
	Sleep(1.5)

	player_mady.Turn_To_Face(player_clone_5)
	player_clone_1.Turn_To_Face(player_clone_5)
	Sleep(6.5)

	Set_Cinematic_Camera_Key(introcam_10_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_10_1_marker, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_10_2_marker, 7.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_10_2_marker, 7.5, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)

	player_clone_5.Play_Animation("Talk", false, 0)
	Story_Event("TRUST_NO_ONE_06")
	MissionUtil.PlayGenericSpeech("Crazy_Clone_06")
	Sleep(5.5)

	player_clone_5.Play_Animation("Talk_Gesture", false, 0)
	Sleep(2.0)

	Set_Cinematic_Camera_Key(introcam_10_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_10_3_marker, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_11_marker, 6.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_11_marker, 6.5, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	Sleep(0.5)

	Story_Event("TRUST_NO_ONE_07")
	MissionUtil.PlayGenericSpeech("Crazy_Clone_07")
	Sleep(4.5)

	Fade_Screen_Out(1.5)
	Sleep(3.5)

	player_mady.Teleport_And_Face(intro_3_mady_marker)
	player_clone_1.Teleport_And_Face(intro_4_clone_1_marker)
	player_clone_3.Teleport_And_Face(intro_2_clone_3_marker)
	player_clone_5.Teleport_And_Face(intro_2_clone_5_marker)

	Set_Cinematic_Camera_Key(introcam_12_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_12_marker, 0, 0, 0, 0, introcam_target_5_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_13_marker, 5.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_13_marker, 5.5, 0, 0, 0, 0, introcam_target_5_marker, 1, 0)

	player_mady.Play_Animation("Talk", false, 1)
	Story_Event("TRUST_NO_ONE_08")
	MissionUtil.PlayGenericSpeech("Crazy_Clone_08")
	Fade_Screen_In(0.5)
	Sleep(5.5)

	Set_Cinematic_Camera_Key(introcam_14_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_14_marker, 0, 0, 0, 0, introcam_target_6_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_15_marker, 6.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_15_marker, 6.5, 0, 0, 0, 0, introcam_target_6_marker, 1, 0)

	Story_Event("TRUST_NO_ONE_09")
	MissionUtil.PlayGenericSpeech("Crazy_Clone_09")
	Sleep(6.5)

	Fade_On()

	p_invaders.Make_Enemy(p_republic)
	p_republic.Make_Enemy(p_invaders)

	player_mady.Set_Cannot_Be_Killed(true)
	player_mady.Change_Owner(p_invaders)

	Story_Event("TRUST_NO_ONE_10")
	MissionUtil.PlayGenericSpeech("Crazy_Clone_10")
	Sleep(4.0)

	player_clone_1.Take_Damage(999)
	player_clone_3.Take_Damage(999)
	player_clone_5.Take_Damage(999)
	Sleep(2.0)

	Set_Cinematic_Camera_Key(introcam_16_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_16_marker, 0, 0, 0, 0, introcam_target_6_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_17_marker, 7.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_17_marker, 7.5, 0, 0, 0, 0, introcam_target_6_marker, 1, 0)
	Story_Event("TRUST_NO_ONE_11")
	MissionUtil.PlayGenericSpeech("Crazy_Clone_11")
	Fade_Screen_In(0.5)
	Sleep(3.5)

	Fade_Screen_Out(3.0)
	Sleep(3.5)

	Story_Event("TRUST_NO_ONE_12")
	MissionUtil.PlayGenericSpeech("Crazy_Clone_12")
	Sleep(8.5)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_02_CIS")
	end
end

function Start_Cinematic_Intro_02_CIS()
	if TestValid(player_mady) then
		player_mady.Despawn()
	end
	if TestValid(player_clone_1) then
		player_clone_1.Despawn()
	end
	if TestValid(player_clone_3) then
		player_clone_3.Despawn()
	end
	if TestValid(player_clone_5) then
		player_clone_5.Despawn()
	end

	mady_unit = Find_Object_Type("MAD_CLONE_OF_KAIKIELIUS")
	mady_list = Spawn_Unit(mady_unit, midtro_1_mady_marker, p_republic)
	player_mady = mady_list[1]
	player_mady.Teleport_And_Face(midtro_1_mady_marker)

	midtro_clone_1_list = Spawn_Unit(mady_unit, midtro_1_clone_1_marker, p_republic)
	player_midtro_clone_1 = midtro_clone_1_list[1]
	player_midtro_clone_1.Teleport_And_Face(midtro_1_clone_1_marker)

	midtro_clone_2_list = Spawn_Unit(mady_unit, midtro_1_clone_2_marker, p_republic)
	player_midtro_clone_2 = midtro_clone_2_list[1]
	player_midtro_clone_2.Teleport_And_Face(midtro_1_clone_2_marker)

	midtro_clone_3_list = Spawn_Unit(mady_unit, midtro_1_clone_3_marker, p_republic)
	player_midtro_clone_3 = midtro_clone_3_list[1]
	player_midtro_clone_3.Teleport_And_Face(midtro_1_clone_3_marker)

	cinematic_one = false
	cinematic_two = true
	Play_Music("TCW_Luminara_Theme_Crazy_Clone")

	player_mady.Turn_To_Face(player_midtro_clone_1)
	player_midtro_clone_1.Turn_To_Face(player_mady)
	player_midtro_clone_2.Turn_To_Face(player_midtro_clone_1)
	player_midtro_clone_3.Turn_To_Face(player_midtro_clone_1)

	Set_Cinematic_Camera_Key(midtrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_1_marker, 0, 0, 0, 0, midtrocam_target_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_2_marker, 12.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_2_marker, 12.0, 0, 0, 0, 0, midtrocam_target_2_marker, 1, 0)

	player_midtro_clone_1.Play_Animation("Talk", false, 0)
	player_midtro_clone_2.Play_Animation("Attention", true)
	player_midtro_clone_3.Play_Animation("Attention", true)
	Story_Event("TRUST_NO_ONE_13")
	MissionUtil.PlayGenericSpeech("Crazy_Clone_13")
	Fade_Screen_In(0.5)
	Letter_Box_In(0.5)
	Sleep(4.5)

	player_mady.Play_Animation("Talk", false, 1)
	Story_Event("TRUST_NO_ONE_14")
	MissionUtil.PlayGenericSpeech("Crazy_Clone_14")
	Sleep(6.5)

	Set_Cinematic_Camera_Key(midtrocam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_3_marker, 0, 0, 0, 0, midtrocam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_4_marker, 5.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_4_marker, 5.5, 0, 0, 0, 0, midtrocam_target_1_marker, 1, 0)
	player_midtro_clone_1.Play_Animation("Talk", false, 0)
	Story_Event("TRUST_NO_ONE_15")
	MissionUtil.PlayGenericSpeech("Crazy_Clone_15")
	Sleep(6.0)

	Set_Cinematic_Camera_Key(midtrocam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_5_marker, 0, 0, 0, 0, midtrocam_target_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_6_marker, 17.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_6_marker, 17.0, 0, 0, 0, 0, midtrocam_target_2_marker, 1, 0)
	player_mady.Play_Animation("Talk", false, 2)
	Story_Event("TRUST_NO_ONE_16")
	MissionUtil.PlayGenericSpeech("Crazy_Clone_16")
	Sleep(8.5)

	Story_Event("TRUST_NO_ONE_17")
	MissionUtil.PlayGenericSpeech("Crazy_Clone_17")
	Sleep(11.5)

	Set_Cinematic_Camera_Key(midtrocam_7_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_7_marker, 0, 0, 0, 0, midtrocam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_8_marker, 12.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_8_marker, 12.0, 0, 0, 0, 0, midtrocam_target_3_marker, 1, 0)
	Story_Event("TRUST_NO_ONE_18")
	MissionUtil.PlayGenericSpeech("Crazy_Clone_18")

	BlockOnCommand(player_midtro_clone_1.Move_To(midtro_2_clone_1_marker))
	player_midtro_clone_1.Play_Animation("Talk", false, 0)
	Sleep(4.0)

	player_mady.Play_Animation("Talk", false, 1)
	Story_Event("TRUST_NO_ONE_19")
	MissionUtil.PlayGenericSpeech("Crazy_Clone_19")
	Sleep(7.0)

	Set_Cinematic_Camera_Key(midtrocam_9_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_9_marker, 0, 0, 0, 0, midtrocam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_10_marker, 11.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_10_marker, 11.0, 0, 0, 0, 0, midtrocam_target_3_marker, 1, 0)

	player_midtro_clone_1.Turn_To_Face(player_midtro_clone_2)
	Story_Event("TRUST_NO_ONE_20")
	MissionUtil.PlayGenericSpeech("Crazy_Clone_20")
	Sleep(8.0)

	Fade_Screen_Out(3.0)
	Sleep(4.0)

	if not cinematic_two_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_03_CIS")
	end
end

function Start_Cinematic_Intro_03_CIS()
	if TestValid(player_mady) then
		player_mady.Despawn()
	end
	if TestValid(player_midtro_clone_1) then
		player_midtro_clone_1.Despawn()
	end
	if TestValid(player_midtro_clone_2) then
		player_midtro_clone_2.Despawn()
	end
	if TestValid(player_midtro_clone_3) then
		player_midtro_clone_3.Despawn()
	end

	p_cis.Make_Enemy(p_republic)
	p_republic.Make_Enemy(p_cis)

	GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)

	cinematic_two = false
	cinematic_three = true

	Set_Cinematic_Camera_Key(midtrocam_11_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_11_marker, 0, 0, 0, 0, midtrocam_target_4_marker, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_12_marker, 8.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_12_marker, 8.0, 0, 0, 0, 0, midtrocam_target_4_marker, 1, 0)
	Story_Event("TRUST_NO_ONE_21")
	Fade_Screen_In(0.5)
	Letter_Box_In(0.5)
	Sleep(8.0)

	Set_Cinematic_Camera_Key(midtrocam_13_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_13_marker, 0, 0, 0, 0, midtrocam_target_5_marker, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_14_marker, 5.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_14_marker, 5.0, 0, 0, 0, 0, midtrocam_target_5_marker, 1, 0)
	Story_Event("TRUST_NO_ONE_22")
	Sleep(5.0)

	Set_Cinematic_Camera_Key(midtrocam_15_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_15_marker, 0, 0, 0, 0, midtrocam_target_5_marker, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_16_marker, 11.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_16_marker, 11.0, 0, 0, 0, 0, midtrocam_target_5_marker, 1, 0)
	Story_Event("TRUST_NO_ONE_23")
	Sleep(7.5)

	MissionUtil.CinematicEnvironmentOff()
	Story_Event("COMMENCE_ASSAULT")

	Fade_Screen_Out(2.0)
	Sleep(3)

	StoryUtil.DeclareVictory(p_republic, false)
end
