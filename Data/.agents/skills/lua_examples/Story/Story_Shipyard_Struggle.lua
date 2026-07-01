
--*****************************************************--
--***** Operation Durge's Lance: Shipyard Struggle ****--
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
		Trigger_Cover_Blown = State_Cover_Blown,
		Trigger_Generator_Reached = State_Generator_Reached,
		Trigger_Control_Room_Reached = State_Control_Room_Reached,
		Trigger_CIS_Heroes_Death = State_CIS_Heroes_Death,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")

	kuat_list = {"MOV_Kuat"}

	clone_phase_i_list = {"CLONETROOPER_PHASE_ONE_COMPANY"}
	clone_phase_i_deployed_list = {"CLONETROOPER_PHASE_ONE_SQUAD"}
	military_soldier_list = {"MILITARY_SOLDIER_COMPANY"}
	military_soldier_deployed_list = {"MILITARY_SOLDIER_SQUAD"}
	police_responder_list = {"POLICE_RESPONDER_COMPANY"}
	police_responder_deployed_list = {"POLICE_RESPONDER_ASSAULT_SQUAD"}
	shock_trooper_phase_i_list = {"SHOCK_CLONETROOPER_PHASE_ONE_SQUAD"}
	early_espo_squad_list = {"ESPO_WALKER_91_COMPANY"}
	overracer_squad_list = {"OVERRACER_SPEEDER_BIKE_COMPANY"}
	atpt_squad_list = {"REPUBLIC_AT_PT_COMPANY"}
	security_trooper_list = {"SECURITY_TROOPER_COMPANY"}
	security_trooper_deployed_list = {"SECURITY_TROOPER_SQUAD"}
	senate_commmando_list = {"SENATE_COMMANDO_COMPANY"}

	current_cinematic_thread_id = nil

	act_1_active = false
	act_2_active = false
	act_3_active = false

	cinematic_one = false
	cinematic_two = false
	cinematic_three = false

	cinematic_one_skipped = false
	cinematic_two_skipped = false
	cinematic_three_skipped = false

	cover_blown = false

	generator_reached = false
	control_room_reached = false

	vazus_generator_reached = false
	dengar_generator_reached = false
	bossk_generator_reached = false

	vazus_control_room_reached = false
	dengar_control_room_reached = false
	bossk_control_room_reached = false

	mission_started = false

end
function Begin_Battle(message)
	if message == OnEnter then
		GlobalValue.Set("ODL_CIS_Shipyard_Struggle_Outcome", 0) -- 0 = CIS Victory; 1 = Republic Victory
		GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 0)
		GlobalValue.Set("Guards_Attacked", 0)

		intro_vazus_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-vazus")
		intro_bossk_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-bossk")
		intro_dengar_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-dengar")
		intro_shahan_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-shahan")
		intro_ig_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-ig-1")
		intro_ig_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-ig-2")
		intro_ig_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-ig-3")

		midtro_vazus_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-vazus")
		midtro_bossk_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-bossk")
		midtro_dengar_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-dengar")
		midtro_shahan_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-shahan")
		midtro_ig_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-ig-1")
		midtro_ig_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-ig-2")
		midtro_ig_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-ig-3")

		midtro_vazus_runto_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-vazus-runto")
		midtro_vazus_runto2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-vazus-runto2")
		midtro_bossk_runto_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-bossk-runto")
		midtro_dengar_runto_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-dengar-runto")
		midtro_shahan_runto_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-shahan-runto")

		midtro_security_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-security")

		outro_vazus_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-vazus-1")
		outro_bossk_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-bossk")
		outro_dengar_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-dengar")
		outro_shahan_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-shahan")
		outro_ig_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-ig-1")
		outro_ig_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-ig-2")
		outro_ig_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-ig-3")

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam4")
		introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam5")
		introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam6")
		introcam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam7")
		introcam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam8")
		introcam_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam9")
		introcam_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam10")
		introcam_11_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam11")
		introcam_12_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam12")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget2")

		midtrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam1")
		midtrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam2")
		midtrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam3")
		midtrocam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam4")
		midtrocam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam5")
		midtrocam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam6")

		midtrocam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocamtarget1")

		outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam1")
		outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam2")
		outrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam3")
		outrocam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam4")
		outrocam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam5")
		outrocam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam6")

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

		control_controls_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "control-controls")
		control_room_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "control-room")

		generator_controls_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "generator-controls")
		generator_room_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "generator-room")

		banter_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "banter-1")
		banter_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "banter-2")
		banter_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "banter-3")
		banter_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "banter-4")
		banter_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "banter-5")
		banter_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "banter-6")
		banter_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "banter-7")

		player_vazus = Find_First_Object("VAZUS_MANDRAKE")
		player_shahan = Find_First_Object("SHAHAN_ALAMA")
		player_dengar = Find_First_Object("DENGAR")
		player_bossk = Find_First_Object("BOSSK")
		player_ig_1 = Find_Hint("HELIOS_IG86", "ig-1")
		player_ig_2 = Find_Hint("HELIOS_IG86", "ig-2")
		player_ig_3 = Find_Hint("HELIOS_IG86", "ig-3")

		Register_Prox(banter_1_marker, State_Banter_1, 50, p_cis)
		Register_Prox(banter_2_marker, State_Banter_2, 50, p_cis)
		Register_Prox(banter_3_marker, State_Banter_3, 50, p_cis)
		Register_Prox(banter_4_marker, State_Banter_4, 50, p_cis)
		Register_Prox(banter_5_marker, State_Banter_5, 50, p_cis)
		Register_Prox(banter_6_marker, State_Banter_6, 50, p_cis)
		Register_Prox(banter_7_marker, State_Banter_7, 50, p_cis)

		Register_Prox(generator_room_marker, State_Prox_Generator, 100, p_cis)

		space_cinematic_center_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "spacecinematiccenter")
		Promote_To_Space_Cinematic_Layer(space_cinematic_center_marker)

		introcam_1_kuat_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam1-kuat")
		Promote_To_Space_Cinematic_Layer(introcam_1_kuat_marker)

		Set_Cinematic_Environment(true)

		p_cis.Disable_Bombing_Run(false)
		p_republic.Disable_Bombing_Run(false)

		p_cis.Disable_Orbital_Bombardment(true)
		p_republic.Disable_Orbital_Bombardment(true)

		mission_started = true

		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
	end
end


function State_Banter_1(prox_obj, trigger_obj)
	if trigger_obj.Get_Owner() == p_cis and not cover_blown then
		Story_Event("BANTER_01")
		prox_obj.Cancel_Event_Object_In_Range(State_Banter_1)
	end
end
function State_Banter_2(prox_obj, trigger_obj)
	if trigger_obj.Get_Owner() == p_cis and not cover_blown then
		Story_Event("BANTER_02")
		prox_obj.Cancel_Event_Object_In_Range(State_Banter_2)
	end
end
function State_Banter_3(prox_obj, trigger_obj)
	if trigger_obj.Get_Owner() == p_cis and not cover_blown then
		Story_Event("BANTER_03")
		prox_obj.Cancel_Event_Object_In_Range(State_Banter_3)
	end
end
function State_Banter_4(prox_obj, trigger_obj)
	if trigger_obj.Get_Owner() == p_cis and not cover_blown then
		Story_Event("BANTER_04")
		prox_obj.Cancel_Event_Object_In_Range(State_Banter_4)
	end
end
function State_Banter_5(prox_obj, trigger_obj)
	if trigger_obj.Get_Owner() == p_cis and not cover_blown then
		Story_Event("BANTER_05")
		prox_obj.Cancel_Event_Object_In_Range(State_Banter_5)
	end
end
function State_Banter_6(prox_obj, trigger_obj)
	if trigger_obj.Get_Owner() == p_cis and not cover_blown then
		Story_Event("BANTER_06")
		prox_obj.Cancel_Event_Object_In_Range(State_Banter_6)
	end
end
function State_Banter_7(prox_obj, trigger_obj)
	if trigger_obj.Get_Owner() == p_cis and not cover_blown then
		Story_Event("BANTER_07")
		prox_obj.Cancel_Event_Object_In_Range(State_Banter_7)
	end
end


function State_Prox_Generator(prox_obj, trigger_obj)
	if trigger_obj == player_vazus then
		vazus_generator_reached = true
	end
	if trigger_obj == player_bossk then
		bossk_generator_reached = true
	end
	if trigger_obj == player_dengar then
		dengar_generator_reached = true
	end
	if vazus_generator_reached and bossk_generator_reached and dengar_generator_reached then
		prox_obj.Cancel_Event_Object_In_Range(State_Prox_Generator)
		Story_Event("SABOTAGE_01")
		Story_Event("GENERATOR_REACHED")
		generator_reached = true
	end
end
function State_Prox_Control_Room(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj == player_vazus then
			vazus_control_room_reached = true
		end
		if trigger_obj == player_bossk then
			bossk_control_room_reached = true
		end
		if trigger_obj == player_dengar then
			dengar_control_room_reached = true
		end
		if vazus_control_room_reached and bossk_control_room_reached and dengar_control_room_reached then
			prox_obj.Cancel_Event_Object_In_Range(State_Prox_Control_Room)
			Story_Event("CONTROL_ROOM_REACHED")
			control_room_reached = true
		end
	end
end


function State_Cover_Blown(message)
	if message == OnEnter then
		Story_Event("INTRUDERS_01")
		Stop_All_Music()
		MissionUtil.CinematicEnvironmentOff()
		--player_vazus.Play_SFX_Event("Unit_Rep_venator_hangar_destroyed")
	end
end

function State_Generator_Reached(message)
	if message == OnEnter then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_CIS")
	end
end
function State_Control_Room_Reached(message)
	if message == OnEnter then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
	end
end

function State_CIS_Heroes_Death(message)
	if message == OnEnter then
		GlobalValue.Set("ODL_CIS_Shipyard_Struggle_Outcome", 1) -- 0 = CIS Victory; 1 = Republic Victory
		Story_Event("CIS_SHIPYARD_SHOWDOWN")
		StoryUtil.DeclareVictory(p_republic, false)
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

					Set_Cinematic_Environment(false)
					Weather_Audio_Pause(false)
					Allow_Localized_SFX(true)
					Enable_Fog(true)

					Fade_Screen_Out(0)
					Stop_All_Music()
					Stop_All_Speech()
					Remove_All_Text()
					Stop_Bink_Movie()

					Play_Music("JFO_Eno_Cordova_Theme")

					Letter_Box_Out(0)
					Point_Camera_At(player_vazus)
					Story_Event("GOAL_TRIGGER_CIS_I")
					Lock_Controls(0)
					Suspend_AI(0)
					End_Cinematic_Camera()

					--GlobalValue.Set("ODL_CIS_Shipyard_Struggle_Outcome", 0) 0 = CIS Victory; 1 = Republic Victory
					--Story_Event("CIS_SHIPYARD_SHOWDOWN")
					--StoryUtil.DeclareVictory(p_republic, false)

					Add_Radar_Blip(generator_room_marker, "generator_room_blip")
					generator_room_marker.Highlight(true)

					cinematic_one = false
					act_1_active = true

					Fade_Screen_In(0.5)
					Sleep(0.5)
				end
			end
			if cinematic_two then
				if not cinematic_two_skipped then
					cinematic_two_skipped = true
	
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

					Remove_Radar_Blip("generator_room_blip")
					generator_room_marker.Highlight(false)

					Add_Radar_Blip(control_room_marker, "control_room_blip")
					control_room_marker.Highlight(true)

					player_vazus.Teleport_And_Face(midtro_vazus_runto2_marker)
					player_shahan.Teleport_And_Face(midtro_shahan_runto_marker)
					player_dengar.Teleport_And_Face(midtro_dengar_runto_marker)
					player_bossk.Teleport_And_Face(midtro_bossk_runto_marker)
					player_ig_1.Teleport_And_Face(midtro_ig_1_marker)
					player_ig_2.Teleport_And_Face(midtro_ig_2_marker)
					player_ig_3.Teleport_And_Face(midtro_ig_3_marker)

					player_vazus.In_End_Cinematic(true)
					player_shahan.In_End_Cinematic(true)
					player_dengar.In_End_Cinematic(true)
					player_bossk.In_End_Cinematic(true)
					player_ig_1.In_End_Cinematic(true)
					player_ig_2.In_End_Cinematic(true)
					player_ig_3.In_End_Cinematic(true)

					Do_End_Cinematic_Cleanup()

					SpawnList(clone_phase_i_list, defender_1_marker.Get_Position(), p_republic, true, true)
					--SpawnList(senate_commmando_list, defender_2_marker.Get_Position(), p_republic, true, true)
					SpawnList(senate_commmando_list, defender_2_marker.Get_Position(), p_republic, true, true)

					SpawnList(military_soldier_list, defender_3_marker.Get_Position(), p_republic, true, true)
					--SpawnList(early_espo_squad_list, defender_4_marker.Get_Position(), p_republic, true, true)

					--SpawnList(police_responder_list, defender_5_marker.Get_Position(), p_republic, true, true)
					SpawnList(overracer_squad_list, defender_6_marker.Get_Position(), p_republic, true, true)

					--SpawnList(shock_trooper_phase_i_list, defender_7_marker.Get_Position(), p_republic, true, true)
					SpawnList(atpt_squad_list, defender_8_marker.Get_Position(), p_republic, true, true)

					SpawnList(security_trooper_list, defender_9_marker.Get_Position(), p_republic, true, true)
					SpawnList(early_espo_squad_list, defender_10_marker.Get_Position(), p_republic, true, true)

					--GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)
					--player_vazus.Play_SFX_Event("Unit_Rep_venator_hangar_destroyed")
					fog_id = FogOfWar.Reveal(p_cis, player_vazus.Get_Position(), 1000, 1000)

					MissionUtil.AIActivation()

					cinematic_two = false
					act_2_active = true

					Letter_Box_Out(0)
					Point_Camera_At(player_vazus)
					Story_Event("GOAL_TRIGGER_CIS_II")
					Lock_Controls(0)
					Suspend_AI(0)
					End_Cinematic_Camera()

					Fade_Screen_In(0.5)
					Sleep(0.5)
				end
			end
			if cinematic_three then
				if not cinematic_three_skipped then
					cinematic_three_skipped = true
	
					if current_cinematic_thread_id ~= nil then
						Thread.Kill(current_cinematic_thread_id)
						current_cinematic_thread_id = nil
					end

					GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)
					GlobalValue.Set("ODL_CIS_Shipyard_Struggle_Outcome", 0) -- 0 = CIS Victory; 1 = Republic Victory
					Story_Event("CIS_SHIPYARD_SHOWDOWN")
					StoryUtil.DeclareVictory(p_republic, false)
				end
			end
		end
	end
end
function Story_Mode_Service()
	if p_cis.Is_Human() then
		if (GlobalValue.Get("Guards_Attacked") == 1) and not cover_blown then
			Story_Event("COVER_BLOWN")
			cover_blown = true
		end
	end
end


function Start_Cinematic_Intro_CIS()
	cinematic_one = true
	Start_Cinematic_Camera()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()
	Stop_All_Music()
	Fade_On()

	Play_Music("TCW_Jedi_Temple_Theme")
	Sleep(0.25)

	cinematic_kuat_list = SpawnList(kuat_list, space_cinematic_center_marker, p_cis, false, false)
	cinematic_kuat = cinematic_kuat_list[1]
 
 	cinematic_kuat.Teleport(space_cinematic_center_marker)
	cinematic_kuat.Play_Animation("Idle", true)

	Weather_Audio_Pause(true)
	Allow_Localized_SFX(false)
	Enable_Fog(false)

	Set_Cinematic_Camera_Key(introcam_1_kuat_marker, 100, -40, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_kuat_marker, 0, 0, -27, 0, cinematic_kuat, 0, 0)
	Transition_Cinematic_Camera_Key(introcam_1_kuat_marker, 40, 500, -300, 453, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_1_kuat_marker, 40, 0, 0, 0, 0, cinematic_kuat, 1, 0)

	Letter_Box_In(4.5)
	Fade_Screen_In(4.5)
	Story_Event("INTRO_CRAWL")

	Sleep(7.5)
	Fade_Screen_Out(2.5)
	Sleep(3.5)

	cinematic_kuat.Despawn()
	Set_Cinematic_Environment(false)
	Weather_Audio_Pause(false)
	Allow_Localized_SFX(true)
	Enable_Fog(true)

	player_vazus.Teleport_And_Face(intro_vazus_marker)
	player_shahan.Teleport_And_Face(intro_shahan_marker)
	player_dengar.Teleport_And_Face(intro_dengar_marker)
	player_bossk.Teleport_And_Face(intro_bossk_marker)

	Play_Music("Han_Solo_Returns_Theme")

	Set_Cinematic_Camera_Key(introcam_11_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_11_marker, 0, 0, 0, 0, player_bossk, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_9_marker, 7.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_9_marker, 7.5, 0, 0, 0, 0, player_bossk, 1, 0)

	Fade_Screen_In(0.5)
	player_bossk.Play_Animation("Talk_Gesture", false, 0)
	Story_Event("INFILTRATION_01")
	Sleep(5.5)

	Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_4_marker, 7.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_4_marker, 7.5, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)

	player_dengar.Turn_To_Face(player_bossk)
	player_dengar.Play_Animation("Idle", false, 2)
	player_bossk.Turn_To_Face(player_dengar)
	Story_Event("INFILTRATION_02")
	Sleep(7.5)

	Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_5_marker, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_6_marker, 7.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_6_marker, 7.0, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)

	player_shahan.Turn_To_Face(player_dengar)
	player_dengar.Play_Animation("Idle", false, 2)
	Story_Event("INFILTRATION_03")
	Sleep(7.0)

	Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_8_marker, 7.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_8_marker, 7.5, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)

	player_bossk.Turn_To_Face(player_vazus)
	player_dengar.Turn_To_Face(player_vazus)
	player_shahan.Turn_To_Face(player_vazus)
	player_vazus.Turn_To_Face(player_dengar)
	player_vazus.Play_Animation("Talk_Gesture", false, 0)
	Story_Event("INFILTRATION_04")
	Sleep(7.5)

	Set_Cinematic_Camera_Key(introcam_9_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_9_marker, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_10_marker, 7.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_10_marker, 7.5, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)

	player_vazus.Turn_To_Face(player_bossk)
	player_vazus.Play_Animation("Talk", false, 1)
	Story_Event("INFILTRATION_05")
	Sleep(7.5)

	Set_Cinematic_Camera_Key(introcam_6_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_6_marker, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_9_marker, 5.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_9_marker, 5.5, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)

	player_bossk.Play_Animation("Talk", false, 0)
	Story_Event("INFILTRATION_06")
	Sleep(3.5)

	Set_Cinematic_Camera_Key(introcam_11_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_11_marker, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_12_marker, 10, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_12_marker, 10, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)

	player_vazus.Turn_To_Face(control_room_marker)
	player_vazus.Play_Animation("Talk_Gesture", false, 0)

	Story_Event("INFILTRATION_07")
	Sleep(7.5)

	if not cinematic_one_skipped then
		Create_Thread("End_Cinematic_Intro_CIS")
	end

end
function End_Cinematic_Intro_CIS()
	Point_Camera_At(player_vazus)
	Transition_To_Tactical_Camera(1.5)
	Sleep(1.5)
	Letter_Box_Out(1.5)
	Sleep(1.5)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Story_Event("GOAL_TRIGGER_CIS_I")
	Suspend_AI(0)

	cinematic_one = false
	act_1_active = true

	Add_Radar_Blip(generator_room_marker, "generator_room_blip")
	generator_room_marker.Highlight(true)

	Play_Music("JFO_Eno_Cordova_Theme")
end

function Start_Cinematic_Midtro_CIS()
	Register_Prox(control_room_marker, State_Prox_Control_Room, 100, p_cis)
	generator_reached = true
	cover_blown = true
	act_1_active = false
	act_2_active = false
	Start_Cinematic_Camera()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()

	Remove_Radar_Blip("generator_room_blip")
	generator_room_marker.Highlight(false)

	Stop_All_Music()
	Fade_On()

	player_vazus = Find_First_Object("VAZUS_MANDRAKE")
	player_shahan = Find_First_Object("SHAHAN_ALAMA")
	player_dengar = Find_First_Object("DENGAR")
	player_bossk = Find_First_Object("BOSSK")
	player_ig_1 = Find_Hint("HELIOS_IG86", "ig-1")
	player_ig_2 = Find_Hint("HELIOS_IG86", "ig-2")
	player_ig_3 = Find_Hint("HELIOS_IG86", "ig-3")

	if TestValid(player_vazus) then
		player_vazus.In_End_Cinematic(true)
		player_vazus.Teleport_And_Face(midtro_vazus_marker)
	else
		vazus_unit = Find_Object_Type("VAZUS_MANDRAKE")
		vazus_list = Spawn_Unit(vazus_unit, midtro_vazus_marker, p_cis)
		player_vazus = vazus_list[1]
		player_vazus.Teleport_And_Face(midtro_vazus_marker)
		player_vazus.In_End_Cinematic(true)
	end
	if TestValid(player_shahan) then
		player_shahan.In_End_Cinematic(true)
		player_shahan.Teleport_And_Face(midtro_shahan_marker)
	else
		shahan_unit = Find_Object_Type("SHAHAN_ALAMA")
		shahan_list = Spawn_Unit(vazus_unit, midtro_shahan_marker, p_cis)
		player_shahan = shahan_list[1]
		player_shahan.Teleport_And_Face(midtro_shahan_marker)
		player_shahan.In_End_Cinematic(true)
	end
	if TestValid(player_dengar) then
		player_dengar.In_End_Cinematic(true)
		player_dengar.Teleport_And_Face(midtro_dengar_marker)
	else
		dengar_unit = Find_Object_Type("DENGAR")
		dengar_list = Spawn_Unit(vazus_unit, midtro_dengar_marker, p_cis)
		player_dengar = dengar_list[1]
		player_dengar.Teleport_And_Face(midtro_dengar_marker)
		player_dengar.In_End_Cinematic(true)
	end
	if TestValid(player_bossk) then
		player_bossk.In_End_Cinematic(true)
		player_bossk.Teleport_And_Face(midtro_bossk_marker)
	else
		bossk_unit = Find_Object_Type("BOSSK")
		bossk_list = Spawn_Unit(vazus_unit, midtro_bossk_marker, p_cis)
		player_bossk = bossk_list[1]
		player_bossk.Teleport_And_Face(midtro_bossk_marker)
		player_bossk.In_End_Cinematic(true)
	end
	if TestValid(player_ig_1) then
		player_ig_1.In_End_Cinematic(true)
		player_ig_1.Teleport_And_Face(midtro_ig_1_marker)
	else
		ig_1_unit = Find_Object_Type("HELIOS_IG86")
		ig_1_list = Spawn_Unit(vazus_unit, midtro_ig_1_marker, p_cis)
		player_ig_1 = ig_1_list[1]
		player_ig_1.Teleport_And_Face(midtro_ig_1_marker)
		player_ig_1.In_End_Cinematic(true)
	end
	if TestValid(player_ig_2) then
		player_ig_2.In_End_Cinematic(true)
		player_ig_2.Teleport_And_Face(midtro_ig_2_marker)
	else
		ig_2_unit = Find_Object_Type("HELIOS_IG86")
		ig_2_list = Spawn_Unit(vazus_unit, midtro_ig_2_marker, p_cis)
		player_ig_2 = ig_2_list[1]
		player_ig_2.Teleport_And_Face(midtro_ig_2_marker)
		player_ig_2.In_End_Cinematic(true)
	end
	if TestValid(player_ig_3) then
		player_ig_3.In_End_Cinematic(true)
		player_ig_3.Teleport_And_Face(midtro_ig_3_marker)
	else
		ig_3_unit = Find_Object_Type("HELIOS_IG86")
		ig_3_list = Spawn_Unit(vazus_unit, midtro_ig_3_marker, p_cis)
		player_ig_3 = ig_3_list[1]
		player_ig_3.Teleport_And_Face(midtro_ig_3_marker)
		player_ig_3.In_End_Cinematic(true)
	end

	Sleep(1.0)

	Do_End_Cinematic_Cleanup()

	guard_unit = Find_Object_Type("Police_Responder")
	guard_list = Spawn_Unit(guard_unit, midtro_security_marker, p_cis)
	player_guard = guard_list[1]
	player_guard.Teleport_And_Face(midtro_security_marker)

	Set_Cinematic_Camera_Key(midtrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_1_marker, 0, 0, 0, 0, player_vazus, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_2_marker, 6, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_2_marker, 6, 0, 0, 0, 0, midtrocam_target_1_marker, 1, 0)

	Play_Music("FoC_Tybers_Plan_Theme")

	Letter_Box_In(0.5)
	Fade_Screen_In(0.5)

	player_shahan.Move_To(midtro_shahan_runto_marker)
	player_dengar.Move_To(midtro_dengar_runto_marker)
	player_bossk.Move_To(midtro_bossk_runto_marker)
	BlockOnCommand(player_vazus.Move_To(midtro_vazus_runto_marker))

	Story_Event("SABOTAGE_02")
	player_guard.Play_Animation("Talk_Gesture", false, 0)
	Sleep(2.5)

	cinematic_two = true
	Sleep(2.5)

	player_guard.Play_Animation("Talk", false, 2)
	Sleep(2.5)

	Set_Cinematic_Camera_Key(midtrocam_3_marker, 0, 0, 5, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_3_marker, 0, 0, 0, 0, midtrocam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_4_marker, 7, 0, 0, 5, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_4_marker, 7, 0, 0, 0, 0, midtrocam_target_1_marker, 1, 0)

	Story_Event("SABOTAGE_03")
	player_vazus.Play_Animation("Talk", false, 0)
	Sleep(2.25)

	player_guard.Change_Owner(p_republic)
	Sleep(0.5)

	player_guard.Take_Damage(9999)
	Sleep(0.25)

	Transition_Cinematic_Camera_Key(midtrocam_4_marker, 4, 0, 0, 5, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_4_marker, 4, 0, 0, 0, 0, player_vazus, 1, 0)

	player_vazus.Move_To(midtro_vazus_runto2_marker)
	Sleep(4.0)

	Set_Cinematic_Camera_Key(midtrocam_target_1_marker, 0, 0, 5, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_target_1_marker, 0, 0, 0, 0, player_vazus, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_2_marker, 8, 0, 0, 5, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_2_marker, 8, 0, 0, 0, 0, player_vazus, 1, 0)
	Story_Event("SABOTAGE_04")
	Sleep(7.5)

	Set_Cinematic_Camera_Key(midtrocam_5_marker, 0, 0, 5, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_5_marker, 0, 0, 0, 0, player_vazus, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_6_marker, 16, 0, 0, 5, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_6_marker, 16, 0, 0, 0, 0, player_vazus, 1, 0)
	player_vazus.Play_Animation("Talk", false, 2)
	Story_Event("SABOTAGE_05")
	Sleep(7.0)

	if not cinematic_two_skipped then
		Create_Thread("End_Cinematic_Midtro_CIS")
	end

end
function End_Cinematic_Midtro_CIS()
	Point_Camera_At(player_vazus)
	Transition_To_Tactical_Camera(3)
	Letter_Box_Out(3)
	Sleep(3.0)

	End_Cinematic_Camera()
	Lock_Controls(0)
	Story_Event("GOAL_TRIGGER_CIS_II")
	Suspend_AI(0)

	cinematic_two = false
	act_2_active = true
	cover_blown = true

	Story_Event("SABOTAGE_06")

	Add_Radar_Blip(control_room_marker, "control_room_blip")
	control_room_marker.Highlight(true)

	SpawnList(clone_phase_i_list, defender_1_marker.Get_Position(), p_republic, true, true)
	--SpawnList(senate_commmando_list, defender_2_marker.Get_Position(), p_republic, true, true)
	--SpawnList(senate_commmando_list, defender_2_marker.Get_Position(), p_republic, true, true)

	--SpawnList(military_soldier_list, defender_3_marker.Get_Position(), p_republic, true, true)
	--SpawnList(early_espo_squad_list, defender_4_marker.Get_Position(), p_republic, true, true)

	--SpawnList(police_responder_list, defender_5_marker.Get_Position(), p_republic, true, true)
	SpawnList(overracer_squad_list, defender_6_marker.Get_Position(), p_republic, true, true)

	--SpawnList(shock_trooper_phase_i_list, defender_7_marker.Get_Position(), p_republic, true, true)
	--SpawnList(atpt_squad_list, defender_8_marker.Get_Position(), p_republic, true, true)

	SpawnList(security_trooper_list, defender_9_marker.Get_Position(), p_republic, true, true)
	SpawnList(early_espo_squad_list, defender_10_marker.Get_Position(), p_republic, true, true)

	--GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)
	fog_id = FogOfWar.Reveal(p_cis, player_vazus.Get_Position(), 1000, 1000)
	MissionUtil.AIActivation()

	MissionUtil.CinematicEnvironmentOff()
	--player_vazus.Play_SFX_Event("Unit_Rep_venator_hangar_destroyed")

end

function Start_Cinematic_Outro_CIS()
	act_2_active = false
	cinematic_three = true
	Fade_Screen_Out(0.5)
	Sleep(1)
	Suspend_AI(1)
	Lock_Controls(1)
	Start_Cinematic_Camera()
	Letter_Box_In(0)
	Stop_All_Music()
	Cancel_Fast_Forward()

	Play_Music("Grievous_Theme")

	player_vazus = Find_First_Object("VAZUS_MANDRAKE")
	player_shahan = Find_First_Object("SHAHAN_ALAMA")
	player_dengar = Find_First_Object("DENGAR")
	player_bossk = Find_First_Object("BOSSK")
	player_ig_1 = Find_Hint("HELIOS_IG86", "ig-1")
	player_ig_2 = Find_Hint("HELIOS_IG86", "ig-2")
	player_ig_3 = Find_Hint("HELIOS_IG86", "ig-3")

	if TestValid(player_vazus) then
		player_vazus.In_End_Cinematic(true)
		player_vazus.Teleport_And_Face(outro_vazus_marker)
	end
	if TestValid(player_shahan) then
		player_shahan.In_End_Cinematic(true)
		player_shahan.Teleport_And_Face(outro_shahan_marker)
	end
	if TestValid(player_dengar) then
		player_dengar.In_End_Cinematic(true)
		player_dengar.Teleport_And_Face(outro_dengar_marker)
	end
	if TestValid(player_bossk) then
		player_bossk.In_End_Cinematic(true)
		player_bossk.Teleport_And_Face(outro_bossk_marker)
	end
	if TestValid(player_ig_1) then
		player_ig_1.In_End_Cinematic(true)
		player_ig_1.Teleport_And_Face(outro_ig_1_marker)
	end
	if TestValid(player_ig_2) then
		player_ig_2.In_End_Cinematic(true)
		player_ig_2.Teleport_And_Face(outro_ig_2_marker)
	end
	if TestValid(player_ig_3) then
		player_ig_3.In_End_Cinematic(true)
		player_ig_3.Teleport_And_Face(outro_ig_3_marker)
	end

	Do_End_Cinematic_Cleanup()

	Set_Cinematic_Camera_Key(outrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_1_marker, 0, 0, 5, 0, player_vazus, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_2_marker, 7.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_2_marker, 7.5, 0, 0, 5, 0, player_vazus, 1, 0)
	Fade_Screen_In(0.5)
	Letter_Box_In(0.5)

	Story_Event("LAST_RESORT_01")
	player_vazus.Play_Animation("Talk_Gesture", false, 0)
	Sleep(7.5)

	Set_Cinematic_Camera_Key(outrocam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_3_marker, 0, 0, 5, 0, player_dengar, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_4_marker, 7.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_4_marker, 7.0, 0, 0, 5, 0, player_dengar, 1, 0)

	player_dengar.Turn_To_Face(player_vazus)
	player_dengar.Play_Animation("Idle", false, 2)
	player_vazus.Turn_To_Face(player_dengar)
	Story_Event("LAST_RESORT_02")
	Sleep(7.0)

	Set_Cinematic_Camera_Key(outrocam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_5_marker, 0, 0, 5, 0, player_vazus, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_6_marker, 6.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_6_marker, 6.5, 0, 0, 5, 0, player_vazus, 1, 0)
	player_vazus.Play_Animation("Talk_Gesture", false, 0)
	Story_Event("LAST_RESORT_03")
	Sleep(5.0)

	Fade_Screen_Out(1.5)
	Sleep(3.0)

	GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)

	GlobalValue.Set("ODL_CIS_Shipyard_Struggle_Outcome", 0) -- 0 = CIS Victory; 1 = Republic Victory
	Story_Event("CIS_SHIPYARD_SHOWDOWN")
	StoryUtil.DeclareVictory(p_republic, false)
end
