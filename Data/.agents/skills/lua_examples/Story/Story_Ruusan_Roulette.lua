
--****************************************************--
--************* Rimward: Ruusan Roulette *************--
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
		Trigger_Escape_Complete = State_Escape_Complete,
		Trigger_Rep_Heroes_Death = State_Rep_Heroes_Death
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_hostile = Find_Player("Hostile")
	p_neutral = Find_Player("Neutral")

	SkydomeList = {"Bespin_Clouds"}
	skytop_list = {"Cinematic_Skytop_Station"}

	MagnaSquadList = {"MAGNAGUARD_SQUAD"}
	OOMSquadList = {"OOM_SECURITY_SQUAD"}
	B1MarineSquadList = {"B1_DROID_MARINE_SQUAD"}
	B2SquadList = {"B2_DROID_SQUAD"}
	BXSquadList = {"BX_COMMANDO_SQUAD"}
	StapSquadList = {"CIS_STAP_COMPANY"}

	current_cinematic_thread_id = nil

	act_1_active = false
	act_2_active = false
	act_3_active = false

	cinematic_one = false
	cinematic_two = false
	cinematic_three = false
	cinematic_four = false

	cinematic_one_skipped = false
	cinematic_two_skipped = false
	cinematic_three_skipped = false
	cinematic_four_skipped = false

	ahsoka_reactor_reached = false
	rex_reactor_reached = false
	r3_reactor_reached = false
	reactor_sabotage = false

	reactor_defender_dead = false
	reactor_controls_dead = false

	anakin_r2_reached = false
	r2_rescue_failed = false
	r2_defender_dead = false
	r2_rescued = false

	elevator_1_reached = false
	elevator_2_reached = false
	elevator_3_reached = false

	r2_elevator_reached = false
	anakin_elevator_reached = false

	hangar_reached = false
	r3_hangar_reached = false
	rex_hangar_reached = false
	ahsoka_hangar_reached = false

	hangar_defender_dead = false
	hangar_controls_dead = false

	mission_started = false
end
function Begin_Battle(message)
	if message == OnEnter then
		GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 0)
		GlobalValue.Set("Rep_Skytop_Sabotaged", 0)

		disabled_phase_3_list = Find_All_Objects_With_Hint("disabled-phase-3")
		for i,p_disabled_phase_3 in pairs(disabled_phase_3_list) do
			p_disabled_phase_3.Change_Owner(p_neutral)
			p_disabled_phase_3.Suspend_Locomotor(true)
			p_disabled_phase_3.In_End_Cinematic(true)
		end

		player_anakin = Find_First_Object("ANAKIN")
		player_ahsoka = Find_First_Object("AHSOKA")

		if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
			Find_First_Object("REX").Despawn()
			player_rex = Find_First_Object("REX2")
			CloneSquadList = {"ARC_PHASE_TWO_COMPANY"}
		else
			Find_First_Object("REX2").Despawn()
			player_rex = Find_First_Object("REX")
			CloneSquadList = {"ARC_PHASE_ONE_COMPANY"}
		end

		player_r3 = Find_First_Object("R3_S6")

		hangar_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "hangar")
		reactor_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "reactor")
		elevator_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "elevator")
		cis_shuttle_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-shuttle")
		twilight_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "twilight")

		elevator_entry_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "elevator-entry-1")
		elevator_entry_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "elevator-entry-2")
		elevator_entry_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "elevator-entry-3")

		elevator_exit_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "elevator-exit-1")
		elevator_exit_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "elevator-exit-2")
		elevator_exit_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "elevator-exit-3")

		intro_anakin_move_to_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-anakin-move-to")
		midtro_r2_hangar_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-r2-hangar")

		midtro_r2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-r2")
		midtro_magna_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-magna-1")
		midtro_magna_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-magna-2")
		midtro_magna_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-magna-3")

		midtro_r3_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-r3-1")
		midtro_r3_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-r3-2")
		midtro_r3_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-r3-3")
		midtro_r3_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-r3-4")

		midtro_rex_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-rex-1")
		midtro_rex_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-rex-2")
		midtro_rex_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-rex-3")
		midtro_rex_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-rex-4")

		midtro_ahsoka_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-ahsoka-1")
		midtro_ahsoka_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-ahsoka-2")
		midtro_ahsoka_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-ahsoka-3")

		midtro_anakin_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-anakin-1")
		midtro_anakin_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-anakin-2")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-4")
		introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-5")
		introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-6")
		introcam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-7")
		introcam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-8")

		midtrocam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-target-1")

		midtrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-1")
		midtrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-2")
		midtrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-3")
		midtrocam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-4")
		midtrocam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-5")
		midtrocam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-6")

		space_cinematic_center_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "space-cinematic-center")
		Promote_To_Space_Cinematic_Layer(space_cinematic_center_marker)

		skytop_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "skytop")
		Promote_To_Space_Cinematic_Layer(skytop_marker)

		--Camera Markers
		cinematic_lua_cam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-1")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_1_marker)

		cinematic_lua_cam_1_target_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-target-1")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_1_target_marker)

		cinematic_lua_cam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-2")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_2_marker)

		cinematic_lua_cam_2_target_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-target-2")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_2_target_marker)

		cinematic_lua_cam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-3")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_3_marker)

		cinematic_lua_cam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-4")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_4_marker)

		Set_Cinematic_Environment(true)

		p_republic.Disable_Bombing_Run(false)
		p_cis.Disable_Bombing_Run(false)

		p_republic.Disable_Orbital_Bombardment(true)
		p_cis.Disable_Orbital_Bombardment(true)

		mission_started = true

		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
	end
end

function State_Reactor_Reached(prox_obj, trigger_obj)
	if trigger_obj == player_ahsoka then
		ahsoka_reactor_reached = true
	end
	if trigger_obj == player_rex then
		rex_reactor_reached = true
	end
	if trigger_obj == player_r3 then
		r3_reactor_reached = true
	end
	if not TestValid(player_rex) then
		if ahsoka_reactor_reached then
			prox_obj.Cancel_Event_Object_In_Range(State_Reactor_Reached)
			Story_Event("REACTOR_REACHED")
			reactor_sabotage = true

			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_01_Rep")
		end
	else
		if ahsoka_reactor_reached and rex_reactor_reached and reactor_defender_dead then
			prox_obj.Cancel_Event_Object_In_Range(State_Reactor_Reached)
			Story_Event("REACTOR_REACHED")
			reactor_sabotage = true

			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_01_Rep")
		end
	end
end
function State_R2_Reached(prox_obj, trigger_obj)
	if trigger_obj == player_anakin then
		anakin_r2_reached = true
	end
	if anakin_r2_reached and not r2_rescue_failed then
		prox_obj.Cancel_Event_Object_In_Range(State_R2_Reached)
		Story_Event("R2_RESCUED")
		r2_rescued = true

		Stop_All_Music()
		MissionUtil.CinematicEnvironmentOn()

		MissionUtil.PlayGenericSpeech("Ruusan_Roulette_02")
		Stop_All_Music()
		Play_Music("Silence_Theme")

		player_r2.Change_Owner(p_republic)

		Remove_Radar_Blip("r2_blip")
		player_r2.Highlight(false)

		Remove_Radar_Blip("cis_hangar_blip")
		cis_shuttle_marker.Highlight(false)

		Add_Radar_Blip(elevator_marker, "elevator_entry_blip")
		elevator_marker.Highlight(true)

		Story_Event("GOAL_TRIGGER_REP_III")

		Register_Prox(elevator_entry_1_marker, State_Elevator_Reached, 150, p_republic)
		Register_Prox(elevator_entry_2_marker, State_Elevator_Reached, 150, p_republic)
		Register_Prox(elevator_entry_3_marker, State_Elevator_Reached, 150, p_republic)

		Sleep(24)
		MissionUtil.CinematicEnvironmentOff()
	end
end
function State_R2_Kidnapped(prox_obj, trigger_obj)
	if trigger_obj == player_r2 then
		r2_rescue_failed = true
	end
	if r2_rescue_failed and not anakin_r2_reached then
		prox_obj.Cancel_Event_Object_In_Range(State_R2_Kidnapped)
		Story_Event("R2_RESCUE_FAILED")

		player_r2.Despawn()
		cis_shuttle.Despawn()

		cis_shuttle = Create_Cinematic_Transport("CIS_Sheathipede_Landing_Craft_Landing_Cinematic", p_cis.Get_ID(), cis_shuttle_marker, 0, 0, 1.0, 2, 0)

		Remove_Radar_Blip("r2_blip")
		player_r2.Highlight(false)

		Remove_Radar_Blip("cis_hangar_blip")
		cis_shuttle_marker.Highlight(false)

		Add_Radar_Blip(elevator_marker, "elevator_entry_blip")
		elevator_marker.Highlight(true)

		Story_Event("GOAL_TRIGGER_REP_III")
		Story_Event("SABOTAGE_03")

		MissionUtil.CinematicEnvironmentOff()

		Register_Prox(elevator_entry_1_marker, State_Elevator_Reached, 150, p_republic)
		Register_Prox(elevator_entry_2_marker, State_Elevator_Reached, 150, p_republic)
		Register_Prox(elevator_entry_3_marker, State_Elevator_Reached, 150, p_republic)
	end
end
function State_Elevator_Reached(prox_obj, trigger_obj)
	if r2_rescued then
		if prox_obj == elevator_entry_1_marker then
			if trigger_obj == player_anakin then
				anakin_elevator_reached = true
			end
			if trigger_obj == player_r2 then
				r2_elevator_reached = true
			end
			if anakin_elevator_reached and r2_elevator_reached then
				prox_obj.Cancel_Event_Object_In_Range(State_Elevator_Reached)
				Story_Event("ELEVATOR_REACHED")
				elevator_1_reached = true

				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_02_Rep")
			end
		elseif prox_obj == elevator_entry_2_marker then
			if trigger_obj == player_anakin then
				anakin_elevator_reached = true
			end
			if trigger_obj == player_r2 then
				r2_elevator_reached = true
			end
			if anakin_elevator_reached and r2_elevator_reached then
				prox_obj.Cancel_Event_Object_In_Range(State_Elevator_Reached)
				Story_Event("ELEVATOR_REACHED")
				elevator_2_reached = true

				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_02_Rep")
			end
		elseif prox_obj == elevator_entry_3_marker then
			if trigger_obj == player_anakin then
				anakin_elevator_reached = true
			end
			if trigger_obj == player_r2 then
				r2_elevator_reached = true
			end
			if anakin_elevator_reached and r2_elevator_reached then
				prox_obj.Cancel_Event_Object_In_Range(State_Elevator_Reached)
				Story_Event("ELEVATOR_REACHED")
				elevator_3_reached = true

				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_02_Rep")
			end
		end
	elseif r2_rescue_failed then
		if prox_obj == elevator_entry_1_marker then
			if trigger_obj == player_anakin then
				prox_obj.Cancel_Event_Object_In_Range(State_Elevator_Reached)
				Story_Event("ELEVATOR_REACHED")
				elevator_1_reached = true

				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_02_Rep")
			end
		elseif prox_obj == elevator_entry_2_marker then
			if trigger_obj == player_anakin then
				prox_obj.Cancel_Event_Object_In_Range(State_Elevator_Reached)
				Story_Event("ELEVATOR_REACHED")
				elevator_2_reached = true

				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_02_Rep")
			end
		elseif prox_obj == elevator_entry_3_marker then
			if trigger_obj == player_anakin then
				prox_obj.Cancel_Event_Object_In_Range(State_Elevator_Reached)
				Story_Event("ELEVATOR_REACHED")
				elevator_3_reached = true

				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_02_Rep")
			end
		end
	end
end
function State_Hangar_Reached(prox_obj, trigger_obj)
	if trigger_obj == player_ahsoka then
		ahsoka_hangar_reached = true
	end
	if trigger_obj == player_rex then
		rex_hangar_reached = true
	end
	if trigger_obj == player_r3 then
		r3_hangar_reached = true
	end
	if ahsoka_hangar_reached and rex_hangar_reached then
		prox_obj.Cancel_Event_Object_In_Range(State_Hangar_Reached)

		hangar_reached = true
		Story_Event("SABOTAGE_05")
		Story_Event("HANGAR_REACHED")
		Story_Event("GOAL_TRIGGER_REP_V")

		if elevator_1_reached then
			if not TestValid(Find_First_Object("ANAKIN")) then
				anakin_unit = Find_Object_Type("ANAKIN")
				anakin_list = Spawn_Unit(anakin_unit, elevator_exit_1_marker, p_republic)
				player_anakin = anakin_list[1]
				player_anakin.Teleport_And_Face(elevator_exit_1_marker)
			end

			if r2_rescued then
				if not TestValid(Find_First_Object("R2_D2")) then
					r2_unit = Find_Object_Type("R2_D2")
					r2_list = Spawn_Unit(r2_unit, elevator_exit_1_marker, p_republic)
					player_r2 = r2_list[1]
					player_r2.Teleport_And_Face(elevator_exit_1_marker)
				end
			end
		elseif elevator_2_reached then
			if not TestValid(Find_First_Object("ANAKIN")) then
				anakin_unit = Find_Object_Type("ANAKIN")
				anakin_list = Spawn_Unit(anakin_unit, elevator_exit_2_marker, p_republic)
				player_anakin = anakin_list[1]
				player_anakin.Teleport_And_Face(elevator_exit_2_marker)
			end

			if r2_rescued then
				if not TestValid(Find_First_Object("R2_D2")) then
					r2_unit = Find_Object_Type("R2_D2")
					r2_list = Spawn_Unit(r2_unit, elevator_exit_2_marker, p_republic)
					player_r2 = r2_list[1]
					player_r2.Teleport_And_Face(elevator_exit_2_marker)
				end
			end
		elseif elevator_3_reached then
			if not TestValid(Find_First_Object("ANAKIN")) then
				anakin_unit = Find_Object_Type("ANAKIN")
				anakin_list = Spawn_Unit(anakin_unit, elevator_exit_3_marker, p_republic)
				player_anakin = anakin_list[1]
				player_anakin.Teleport_And_Face(elevator_exit_3_marker)
			end

			if r2_rescued then
				if not TestValid(Find_First_Object("R2_D2")) then
					r2_unit = Find_Object_Type("R2_D2")
					r2_list = Spawn_Unit(r2_unit, elevator_exit_3_marker, p_republic)
					player_r2 = r2_list[1]
					player_r2.Teleport_And_Face(elevator_exit_3_marker)
				end
			end
		end

		disabled_phase_3_list = Find_All_Objects_With_Hint("disabled-phase-3")
		for i,p_disabled_phase_3 in pairs(disabled_phase_3_list) do
			p_disabled_phase_3.Change_Owner(p_cis)
			p_disabled_phase_3.Suspend_Locomotor(false)
			p_disabled_phase_3.In_End_Cinematic(false)
		end
	end
end

function State_Rep_Heroes_Death(message)
	if message == OnEnter then
		StoryUtil.DeclareVictory(p_cis, false)
	end
end
function State_Escape_Complete(message)
	if message == OnEnter then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
	end
end

function Story_Handle_Esc()
	if mission_started then
		if p_republic.Is_Human() then
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

					MissionUtil.CinematicEnvironmentOff()

					Letter_Box_Out(0)
					Point_Camera_At(player_ahsoka)
					Lock_Controls(0)
					Suspend_AI(0)
					End_Cinematic_Camera()

					Add_Radar_Blip(reactor_marker, "reactor_blip")
					reactor_marker.Highlight(true)

					if TestValid(lua_cinematicskydome) then
						lua_cinematicskydome.Despawn()
					end
					if TestValid(lua_cinematic_object) then
						lua_cinematic_object.Despawn()
					end
					if TestValid(player_anakin) then
						player_anakin.Despawn()
					end

					if TestValid(player_ahsoka) then
						Hide_Sub_Object(player_ahsoka, 0, "Lightsaber01")
						Hide_Sub_Object(player_ahsoka, 0, "Lightsaber")
					end

					Register_Prox(reactor_marker, State_Reactor_Reached, 150, p_republic)

					Clone_Spawn_List_01 = SpawnList(CloneSquadList, player_rex.Get_Position(), p_republic, false, false)
					Clone_Squad_01 = Clone_Spawn_List_01[1]

					Story_Event("GOAL_TRIGGER_REP_I")

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

					Letter_Box_Out(0)
					Point_Camera_At(player_ahsoka)
					Lock_Controls(0)
					Suspend_AI(0)
					End_Cinematic_Camera()

					Remove_Radar_Blip("reactor_blip")
					reactor_marker.Highlight(false)

					if TestValid(Find_First_Object("AHSOKA")) then
						Find_First_Object("AHSOKA").Despawn()
					end
					if TestValid(Find_First_Object("REX2")) then
						Find_First_Object("REX2").Despawn()
					end
					if TestValid(Find_First_Object("REX")) then
						Find_First_Object("REX").Despawn()
					end
					if TestValid(Find_First_Object("R3_S6")) then
						Find_First_Object("R3_S6").Despawn()
					end

					local rep_list = Find_All_Objects_Of_Type(p_republic, "Infantry, InfantryHero")
					for i,reppies in pairs(rep_list) do
						reppies.Despawn()
					end

					if not TestValid(player_anakin) then
						anakin_unit = Find_Object_Type("ANAKIN")
						anakin_list = Spawn_Unit(anakin_unit, midtro_anakin_1_marker, p_republic)
						player_anakin = anakin_list[1]
						player_anakin.Teleport_And_Face(midtro_anakin_1_marker)
						player_anakin.In_End_Cinematic(true)
						player_anakin.Move_To(midtro_anakin_2_marker)
					end

					skytop_defender_marker_list = Find_All_Objects_With_Hint("phase-2")
					for i,skytop_defender_marker in pairs(skytop_defender_marker_list) do
						BX_Spawn_List = SpawnList(BXSquadList, skytop_defender_marker, p_cis, true, true)
					end

					p_hostile.Make_Ally(p_cis)
					p_cis.Make_Ally(p_hostile)

					p_hostile.Make_Ally(p_republic)
					p_republic.Make_Ally(p_hostile)

					r2_unit = Find_Object_Type("R2_D2")
					r2_list = Spawn_Unit(r2_unit, midtro_r2_marker, p_hostile)
					player_r2 = r2_list[1]
					player_r2.Teleport_And_Face(midtro_r2_marker)
					player_r2.Move_To(cis_shuttle_marker)

					magnaguard_unit = Find_Object_Type("MAGNAGUARD")
					magnaguard_list_01 = Spawn_Unit(magnaguard_unit, midtro_magna_1_marker, p_cis)
					player_magna_01 = magnaguard_list_01[1]
					player_magna_01.Teleport_And_Face(midtro_magna_1_marker)

					Add_Radar_Blip(player_r2, "r2_blip")
					player_r2.Highlight(true)

					Add_Radar_Blip(elevator_marker, "cis_hangar_blip")
					cis_shuttle_marker.Highlight(true)

					--player_anakin.Play_SFX_Event("Unit_Rep_venator_hangar_destroyed")

					Register_Prox(cis_shuttle_marker, State_R2_Kidnapped, 150, p_hostile)
					Register_Prox(player_r2, State_R2_Reached, 150, p_republic)

					Story_Event("GOAL_TRIGGER_REP_II")

					cinematic_two = false
					act_2_active = true

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

					Fade_Screen_Out(0)
					Stop_All_Music()
					Stop_All_Speech()
					Remove_All_Text()
					Stop_Bink_Movie()

					MissionUtil.CinematicEnvironmentOff()

					Letter_Box_Out(0)
					Point_Camera_At(player_ahsoka)
					Lock_Controls(0)
					Suspend_AI(0)
					End_Cinematic_Camera()

					Add_Radar_Blip(hangar_marker, "hangar_blip")
					hangar_marker.Highlight(true)

					hangar_entry_list = Find_All_Objects_With_Hint("hangar-entry")
					for i,hangar_entry_marker in pairs(hangar_entry_list) do
						Register_Prox(hangar_entry_marker, State_Hangar_Reached, 150, p_republic)
					end

					Story_Event("GOAL_TRIGGER_REP_IV")

					cinematic_three = false
					act_3_active = true

					Fade_Screen_In(0.5)
					Sleep(0.5)
				end
			end
			if cinematic_four then
				if not cinematic_four_skipped then
					cinematic_four_skipped = true
	
					if current_cinematic_thread_id ~= nil then
						Thread.Kill(current_cinematic_thread_id)
						current_cinematic_thread_id = nil
					end

					MissionUtil.CinematicEnvironmentOff()
					Set_Cinematic_Environment(false)
					Weather_Audio_Pause(false)
					Allow_Localized_SFX(true)
					Enable_Fog(true)

					GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)

					GlobalValue.Set("Rep_Skytop_Sabotaged", 1)
					StoryUtil.DeclareVictory(p_republic, false)
				end
			end
		end
	end
end
function Story_Mode_Service()
	if p_republic.Is_Human() then
		if act_1_active then
			reactor_defender_list = Find_All_Objects_Of_Type("MAGNAGUARD")
			if (table.getn(reactor_defender_list) == 0) then
				reactor_defender_dead = true
			end
			reactor_controls_list = Find_All_Objects_With_Hint("reactor-controls")
			if (table.getn(reactor_controls_list) == 0) then
				reactor_controls_dead = true
			end
		end
		if act_2_active then
		end
		if act_3_active then
			disabled_phase_3_list = Find_All_Objects_With_Hint("disabled-phase-3")
			if (table.getn(disabled_phase_3_list) == 0) then
				hangar_defender_dead = true
			end
			hangar_controls_list = Find_All_Objects_With_Hint("hangar-controls")
			if (table.getn(hangar_controls_list) == 0) then
				hangar_controls_dead = true
			end
			if hangar_defender_dead and hangar_controls_dead then
				Story_Event("ESCAPE_COMPLETE")
			end
		end
	end
end


function Start_Cinematic_Intro_Rep()
	cinematic_one = true
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()
	Stop_All_Music()
	Fade_On()

	skydome_list = SpawnList(SkydomeList, space_cinematic_center_marker, p_republic, false, false)
	lua_cinematicskydome = skydome_list[1]
	lua_cinematicskydome.Teleport_And_Face(space_cinematic_center_marker)

	Weather_Audio_Pause(true)
	Start_Cinematic_Camera(false)
	Allow_Localized_SFX(false)
	Enable_Fog(false)

	lua_cinematic_object = Find_First_Object("CINEMATIC_SKYTOP_STATION")
	lua_cinematic_object.Hide(true)
	lua_cinematic_object.Teleport(skytop_marker)
	--lua_cinematic_object.Play_Animation("Cinematic", false, 0)
	lua_cinematic_object.Hide(false)
	Sleep(1.0)

	Play_Music("TCW_Jedi_Temple_Theme")
	Fade_Screen_In(7.0)
	Letter_Box_In(7.0)

	Set_Cinematic_Camera_Key(cinematic_lua_cam_1_marker, 100, -40, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cinematic_lua_cam_1_marker, 0, 0, -27, 0, cinematic_lua_cam_1_target_marker, 0, 0)
	Transition_Cinematic_Camera_Key(cinematic_lua_cam_2_marker, 20, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cinematic_lua_cam_2_marker, 20, 0, 0, 0, 0, cinematic_lua_cam_2_target_marker, 1, 0)

	cinematic_lua_cam_1_marker.Play_SFX_Event("Unit_Falcon_Cinematic_Engine_Loop")
	Story_Event("CINEMATIC_CRAWL_01")
	Sleep(3)
	Story_Event("CINEMATIC_CRAWL_02")
	Sleep(9)

	Fade_Screen_Out(2)
	Sleep(2)

	lua_cinematicskydome.Despawn()
	lua_cinematic_object.Despawn()
	Set_Cinematic_Environment(false)
	Enable_Fog(true)
	Sleep(2)

	Hide_Sub_Object(player_anakin, 1, "Lightsaber")
	Hide_Sub_Object(player_anakin, 1, "RI_luke_shadow")

	Hide_Sub_Object(player_ahsoka, 1, "Lightsaber01")
	Hide_Sub_Object(player_ahsoka, 1, "Lightsaber")

	player_r3.Turn_To_Face(player_ahsoka)	
	player_rex.Turn_To_Face(player_r3)
	player_anakin.Turn_To_Face(player_r3)
	player_ahsoka.Turn_To_Face(player_r3)

	MissionUtil.PlayGenericSpeech("Ruusan_Roulette_01")
	MissionUtil.PlayGenericMusic("Silence_Theme")
	Sleep(1.0)

	Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 0, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 6, 0, 0, 0, 0, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 6, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Fade_Screen_In(3.0)
	Letter_Box_In(3.0)


	player_anakin.Play_Animation("Talk", false, 0)
	Sleep(1.0)

	player_r3.Play_Animation("Cinematic", false, 0)
	Sleep(3.0)

	Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 0, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_4_marker, 6, 0, 0, 0, 0, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_4_marker, 6, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Sleep(1.0)

	player_rex.Play_Animation("Talk_Gesture", false, 0)
	Sleep(5.0)

	player_rex.Turn_To_Face(player_anakin)
	player_anakin.Turn_To_Face(player_ahsoka)
	player_ahsoka.Turn_To_Face(player_anakin)

	Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 0, 0, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_5_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_6_marker, 5, 0, 0, 0, 0, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_6_marker, 5, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)

	player_anakin.Play_Animation("Talk", false, 0)
	Sleep(3.0)

	player_anakin.Play_Animation("Talk", false, 0)
	Sleep(2.0)

	Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 0, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_8_marker, 5, 0, 0, 0, 0, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_8_marker, 5, 0, 0, 0, 0, player_anakin, 1, 0)
	Sleep(2.0)

	player_anakin.Move_To(intro_anakin_move_to_marker)
	Sleep(2.0)

	if not cinematic_one_skipped then
		Create_Thread("End_Cinematic_Intro_Rep")
	end
end
function End_Cinematic_Intro_Rep()
	Point_Camera_At(player_ahsoka)
	Transition_To_Tactical_Camera(1.5)
	Sleep(1.5)
	Letter_Box_Out(1.5)
	Sleep(1.5)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Suspend_AI(0)
	MissionUtil.CinematicEnvironmentOff()

	player_anakin.Despawn()

	Hide_Sub_Object(player_ahsoka, 0, "Lightsaber01")
	Hide_Sub_Object(player_ahsoka, 0, "Lightsaber")

	Register_Prox(reactor_marker, State_Reactor_Reached, 150, p_republic)

	Clone_Spawn_List_01 = SpawnList(CloneSquadList, player_rex.Get_Position(), p_republic, false, false)
	Clone_Squad_01 = Clone_Spawn_List_01[1]

	Story_Event("GOAL_TRIGGER_REP_I")

	cinematic_one = false
	act_1_active = true

	Add_Radar_Blip(reactor_marker, "reactor_blip")
	reactor_marker.Highlight(true)
end

function Start_Cinematic_Midtro_01_Rep()
	if TestValid(Find_First_Object("ANAKIN")) then
		Find_First_Object("ANAKIN").Despawn()
	end
	if TestValid(Find_First_Object("CINEMATIC_SKYTOP_STATION")) then
		Find_First_Object("CINEMATIC_SKYTOP_STATION").Despawn()
	end

	act_1_active = false
	cinematic_two = true

	Start_Cinematic_Camera()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()
	Stop_All_Music()
	Fade_On()

	Play_Music("Anakin_vs_ObiWan_Theme")

	Remove_Radar_Blip("reactor_blip")
	reactor_marker.Highlight(false)

	local rep_list = Find_All_Objects_Of_Type(p_republic, "Infantry")
	for i,reppies in pairs(rep_list) do
		reppies.Despawn()
	end

	player_ahsoka = Find_First_Object("AHSOKA")
	player_r3 = Find_First_Object("R3_S6")
	if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
		player_rex = Find_First_Object("REX2")
	else
		player_rex = Find_First_Object("REX")
	end

	if TestValid(player_ahsoka) then
		player_ahsoka.In_End_Cinematic(true)
		player_ahsoka.Teleport_And_Face(midtro_ahsoka_1_marker)
		Hide_Sub_Object(player_ahsoka, 1, "Lightsaber01")
		Hide_Sub_Object(player_ahsoka, 1, "Lightsaber")
	else
		ahsoka_unit = Find_Object_Type("AHSOKA")
		ahsoka_list = Spawn_Unit(ahsoka_unit, midtro_ahsoka_1_marker, p_republic)
		player_ahsoka = ahsoka_list[1]
		player_ahsoka.Teleport_And_Face(midtro_ahsoka_1_marker)
		player_ahsoka.In_End_Cinematic(true)
		Hide_Sub_Object(player_ahsoka, 1, "Lightsaber01")
		Hide_Sub_Object(player_ahsoka, 1, "Lightsaber")
	end
	if TestValid(player_r3) then
		player_r3.In_End_Cinematic(true)
		player_r3.Teleport_And_Face(midtro_r3_1_marker)
	else
		r3_unit = Find_Object_Type("R3_S6")
		r3_list = Spawn_Unit(r3_unit, midtro_r3_1_marker, p_republic)
		player_r3 = r3_list[1]
		player_r3.Teleport_And_Face(midtro_r3_1_marker)
		player_r3.In_End_Cinematic(true)
	end
	if TestValid(player_rex) then
		player_rex.In_End_Cinematic(true)
		player_rex.Teleport_And_Face(midtro_rex_1_marker)
	else
		if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
			player_rex = MissionUtil.SpawnUnitGround("REX2", midtro_rex_1_marker, p_republic)
		else
			player_rex = MissionUtil.SpawnUnitGround("REX", midtro_rex_1_marker, p_republic)
		end
		player_rex.In_End_Cinematic(true)
		player_rex.Set_Garrison_Spawn(false)
	end

	Set_Cinematic_Camera_Key(midtrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_1_marker, 0, 0, 0, 0, player_rex, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_2_marker, 6, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_2_marker, 6, 0, 0, 0, 0, midtrocam_target_1_marker, 1, 0)

	Letter_Box_In(0.5)
	Fade_Screen_In(0.5)

	player_r3.Move_To(midtro_r3_2_marker)
	BlockOnCommand(player_rex.Move_To(midtro_rex_2_marker))

	Story_Event("SABOTAGE_01")
	player_rex.Play_Animation("Talk", false, 0)
	Sleep(6.5)

	anakin_unit = Find_Object_Type("ANAKIN")
	anakin_list = Spawn_Unit(anakin_unit, midtro_anakin_1_marker, p_republic)
	player_anakin = anakin_list[1]
	player_anakin.Teleport_And_Face(midtro_anakin_1_marker)
	player_anakin.In_End_Cinematic(true)
	player_anakin.Move_To(midtro_anakin_2_marker)

	Set_Cinematic_Camera_Key(midtrocam_3_marker, 0, 0, 5, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_3_marker, 0, 0, 0, 0, player_anakin, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_4_marker, 7, 0, 0, 5, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_4_marker, 7, 0, 0, 0, 0, player_anakin, 1, 0)

	Fade_Screen_Out(0.5)
	Sleep(0.75)
	Fade_Screen_In(0.5)

	player_ahsoka.Despawn()
	player_rex.Despawn()
	player_r3.Despawn()

	Story_Event("SABOTAGE_02")
	Sleep(4.0)

	if not cinematic_two_skipped then
		Create_Thread("End_Cinematic_Midtro_01_Rep")
	end
end
function End_Cinematic_Midtro_01_Rep()
	Point_Camera_At(player_anakin)
	Transition_To_Tactical_Camera(3)
	Letter_Box_Out(3)
	Sleep(3.0)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Suspend_AI(0)

	Story_Event("GOAL_TRIGGER_REP_II")

	cinematic_two = false
	act_2_active = true

	p_hostile.Make_Ally(p_cis)
	p_cis.Make_Ally(p_hostile)

	p_hostile.Make_Ally(p_republic)
	p_republic.Make_Ally(p_hostile)

	r2_unit = Find_Object_Type("R2_D2")
	r2_list = Spawn_Unit(r2_unit, midtro_r2_marker, p_hostile)
	player_r2 = r2_list[1]
	player_r2.Teleport_And_Face(midtro_r2_marker)
	player_r2.Move_To(cis_shuttle_marker)

	magnaguard_unit = Find_Object_Type("MAGNAGUARD")
	magnaguard_list_01 = Spawn_Unit(magnaguard_unit, midtro_magna_1_marker, p_cis)
	player_magna_01 = magnaguard_list_01[1]
	player_magna_01.Teleport_And_Face(midtro_magna_1_marker)

	Add_Radar_Blip(player_r2, "r2_blip")
	player_r2.Highlight(true)

	Add_Radar_Blip(cis_shuttle_marker, "cis_hangar_blip")
	cis_shuttle_marker.Highlight(true)

	skytop_defender_marker_list = Find_All_Objects_With_Hint("phase-2")
	for i,skytop_defender_marker in pairs(skytop_defender_marker_list) do
		BX_Spawn_List = SpawnList(BXSquadList, skytop_defender_marker, p_cis, true, true)
	end

	cis_shuttle = Create_Generic_Object("CIS_Sheathipede_Landing_Craft_Landing_Cinematic", cis_shuttle_marker, p_cis)		
	cis_shuttle.Teleport_And_Face(cis_shuttle_marker)

	Register_Prox(cis_shuttle_marker, State_R2_Kidnapped, 150, p_hostile)
	Register_Prox(player_r2, State_R2_Reached, 150, p_republic)

	MissionUtil.CinematicEnvironmentOff()
	--player_anakin.Play_SFX_Event("Unit_Rep_venator_hangar_destroyed")
end

function Start_Cinematic_Midtro_02_Rep()
	if TestValid(Find_First_Object("ANAKIN")) then
		Find_First_Object("ANAKIN").Despawn()
	end
	if TestValid(Find_First_Object("R2_D2")) then
		Find_First_Object("R2_D2").Despawn()
	end
	if TestValid(Find_First_Object("CINEMATIC_SKYTOP_STATION")) then
		Find_First_Object("CINEMATIC_SKYTOP_STATION").Despawn()
	end

	Remove_Radar_Blip("elevator_entry_blip")
	elevator_marker.Highlight(false)

	Start_Cinematic_Camera()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()
	Fade_On()

	player_ahsoka = Find_First_Object("AHSOKA")
	player_r3 = Find_First_Object("R3_S6")

	if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
		player_rex = Find_First_Object("REX2")
	else
		player_rex = Find_First_Object("REX")
	end

	if TestValid(player_ahsoka) then
		player_ahsoka.In_End_Cinematic(true)
		player_ahsoka.Teleport_And_Face(midtro_ahsoka_2_marker)
		Hide_Sub_Object(player_ahsoka, 1, "Lightsaber01")
		Hide_Sub_Object(player_ahsoka, 1, "Lightsaber")
	else
		ahsoka_unit = Find_Object_Type("AHSOKA")
		ahsoka_list = Spawn_Unit(ahsoka_unit, midtro_ahsoka_2_marker, p_republic)
		player_ahsoka = ahsoka_list[1]
		player_ahsoka.Teleport_And_Face(midtro_ahsoka_2_marker)
		player_ahsoka.In_End_Cinematic(true)
		Hide_Sub_Object(player_ahsoka, 1, "Lightsaber01")
		Hide_Sub_Object(player_ahsoka, 1, "Lightsaber")
	end
	if TestValid(player_r3) then
		player_r3.In_End_Cinematic(true)
		player_r3.Teleport_And_Face(midtro_r3_3_marker)
	else
		r3_unit = Find_Object_Type("R3_S6")
		r3_list = Spawn_Unit(r3_unit, midtro_r3_3_marker, p_republic)
		player_r3 = r3_list[1]
		player_r3.Teleport_And_Face(midtro_r3_3_marker)
		player_r3.In_End_Cinematic(true)
	end
	if TestValid(player_rex) then
		player_rex.In_End_Cinematic(true)
		player_rex.Teleport_And_Face(midtro_rex_3_marker)
	else
		if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
			player_rex = MissionUtil.SpawnUnitGround("REX2", midtro_rex_3_marker, p_republic)
		else
			player_rex = MissionUtil.SpawnUnitGround("REX", midtro_rex_3_marker, p_republic)
		end
		player_rex.In_End_Cinematic(true)
		player_rex.Set_Garrison_Spawn(false)
	end

	player_twilight = Create_Generic_Object("Twilight_Landing_Cinematic", twilight_marker, p_neutral)
	player_twilight.Teleport_And_Face(twilight_marker)

	act_2_active = false
	cinematic_three = true

	Set_Cinematic_Camera_Key(midtrocam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_5_marker, 0, 0, 0, 0, player_ahsoka, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_6_marker, 6, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_6_marker, 6, 0, 0, 0, 0, player_ahsoka, 1, 0)
	Fade_Screen_In(0.5)
	Letter_Box_In(0.5)

	player_ahsoka.Move_To(midtro_ahsoka_3_marker)
	player_rex.Move_To(midtro_rex_4_marker)
	player_r3.Move_To(midtro_r3_4_marker)

	Story_Event("SABOTAGE_04")
	Sleep(6.0)

	if not cinematic_three_skipped then
		Create_Thread("End_Cinematic_Midtro_02_Rep")
	end
end
function End_Cinematic_Midtro_02_Rep()
	Point_Camera_At(player_ahsoka)
	Transition_To_Tactical_Camera(3)
	Letter_Box_Out(3)
	Sleep(3.0)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Suspend_AI(0)

	Story_Event("GOAL_TRIGGER_REP_IV")

	hangar_entry_list = Find_All_Objects_With_Hint("hangar-entry")
	for i,hangar_entry_marker in pairs(hangar_entry_list) do
		Register_Prox(hangar_entry_marker, State_Hangar_Reached, 150, p_republic)
	end

	cinematic_three = false
	act_3_active = true

	MissionUtil.CinematicEnvironmentOff()

	Add_Radar_Blip(hangar_marker, "hangar_blip")
	hangar_marker.Highlight(true)
end

function Start_Cinematic_Outro_Rep()
	act_3_active = false
	cinematic_four = true
	Fade_Screen_Out(0.5)
	Sleep(1)
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()
	Stop_All_Music()
	Fade_On()

	skydome_list = SpawnList(SkydomeList, space_cinematic_center_marker, p_republic, false, false)
	lua_cinematicskydome = skydome_list[1]
	lua_cinematicskydome.Teleport_And_Face(space_cinematic_center_marker)

	Set_Cinematic_Environment(true)
	Weather_Audio_Pause(true)
	Start_Cinematic_Camera(false)
	Allow_Localized_SFX(false)
	Enable_Fog(false)

	lua_cinematic_object_list = SpawnList(skytop_list, skytop_marker, p_republic, false, false)
	lua_cinematic_object = lua_cinematic_object_list[1]

	lua_cinematic_object.Hide(true)
	lua_cinematic_object.Teleport(skytop_marker)
	--lua_cinematic_object.Play_Animation("Cinematic", false, 0)
	lua_cinematic_object.Hide(false)
	Sleep(1.0)

	MissionUtil.PlayGenericSpeech("Ruusan_Roulette_03")
	MissionUtil.PlayGenericMusic("Silence_Theme")
	Fade_Screen_In(0.5)
	Letter_Box_In(0.5)

	Set_Cinematic_Camera_Key(cinematic_lua_cam_3_marker, 100, -40, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cinematic_lua_cam_3_marker, 0, 0, -27, 0, cinematic_lua_cam_1_target_marker, 0, 0)
	Transition_Cinematic_Camera_Key(cinematic_lua_cam_4_marker, 20, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cinematic_lua_cam_4_marker, 20, 0, 0, 0, 0, cinematic_lua_cam_2_target_marker, 1, 0)
	--cinematic_lua_cam_3_marker.Play_SFX_Event("Unit_Rep_venator_hangar_destroyed")
	Sleep(5.0)

	Fade_Screen_Out(2.0)
	Sleep(14.0)

	MissionUtil.CinematicEnvironmentOff()
	Set_Cinematic_Environment(false)
	Weather_Audio_Pause(false)
	Allow_Localized_SFX(true)
	Enable_Fog(true)

	MissionUtil.CinematicEnvironmentOff()

	GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)

	GlobalValue.Set("Rep_Skytop_Sabotaged", 1)
	StoryUtil.DeclareVictory(p_republic, false)
end
