
--****************************************************--
--************** Rimward: Perfect Piracy *************--
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
		Heroes_Death = State_Heroes_Death,
		Trigger_Reactor_Reached = State_Reactor_Reached,
		Trigger_Pirates_Reached = State_Pirates_Reached,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_pirates = Find_Player("Hostile")
	p_neutral = Find_Player("Neutral")

	wlo5_list = {"WLO5_TANK_COMPANY"}
	pirate_list = {"PIRATE_SOLDIER_SQUAD"}
	clone1_list = {"ARC_PHASE_ONE_SQUAD"}
	clone2_list = {"ARC_PHASE_ONE_HEAVY_SQUAD"}
	explosion_list = {"HUGE_EXPLOSION_LAND"}

	current_cinematic_thread_id = nil

	act_1_active = false
	act_2_active = false

	cinematic_one = false
	cinematic_two = false
	cinematic_three = false

	cinematic_one_skipped = false
	cinematic_two_skipped = false
	cinematic_three_skipped = false

	anakin_reached_escape = false
	obiwan_reached_escape = false
	dooku_reached_escape = false

	controls_destroyed = false
	generator_reached = false
	hangar_reached = false
	tank_reached = false
	base_reached = false

	mission_started = false

end
function Begin_Battle(message)
	if message == OnEnter then
		anakin_move_to = Find_Hint("STORY_TRIGGER_ZONE_00", "anakinmoveto")
		obiwan_move_to = Find_Hint("STORY_TRIGGER_ZONE_00", "obimoveto")
		dooku_move_to = Find_Hint("STORY_TRIGGER_ZONE_00", "dookumoveto")

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam4")
		introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam5")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget1")

		midtrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam1")
		midtrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam2")
		midtrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam3")
		midtrocam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam4")
		midtrocam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam5")
		midtrocam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam6")

		midtrocam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-target-1")
		midtrocam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-target-2")

		outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-1")
		outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-2")
		outrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-3")
		outrocam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-4")
		outrocam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-5")
		outrocam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-6")
		outrocam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-7")
		outrocam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-8")
		outrocam_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-9")
		outrocam_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-10")
		outrocam_11_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-11")
		outrocam_12_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-12")
		outrocam_13_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-13")
		outrocam_14_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-14")
		outrocam_15_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-15")
		outrocam_16_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-16")
		outrocam_17_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-17")
		outrocam_18_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-18")

		outrocam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-1")
		outrocam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-2")
		outrocam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-3")
		outrocam_target_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-4")

		outro_anakin_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-anakin")
		outro_obiwan_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-obiwan")
		outro_hondo_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-hondo")
		outro_jarjar_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-jarjar")
		outro_tank_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-tank")

		outro_pirates_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-pirates-1")
		outro_pirates_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-pirates-2")
		outro_clones_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-clone")

		pirate_tank_1_spawn = Find_Hint("STORY_TRIGGER_ZONE_00", "piratetank1")
		pirate_tank_2_spawn = Find_Hint("STORY_TRIGGER_ZONE_00", "piratetank2")
		pirate_tank_3_spawn = Find_Hint("STORY_TRIGGER_ZONE_00", "piratetank3")

		shuttle_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "shuttle")
		twilight_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "twilight")
		crash_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "crash")

		anakin_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "anakinmarker")
		obiwan_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "obimarker")
		dooku_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "dookumarker")

		jarjar_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "jarjarmarker")
		shock1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "shock1marker")
		shock2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "shock2marker")

		door_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "door")
		generator_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "generator")
		base_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "base")

		player_tank_1 = Find_Hint("WLO5_TANK", "tank-1")
		player_tank_2 = Find_Hint("WLO5_TANK", "tank-2")
		player_tank_3 = Find_Hint("WLO5_TANK", "tank-3")

		p_cis.Disable_Bombing_Run(false)
		p_republic.Disable_Bombing_Run(false)
		p_pirates.Disable_Bombing_Run(false)

		p_cis.Disable_Orbital_Bombardment(true)
		p_republic.Disable_Orbital_Bombardment(true)
		p_pirates.Disable_Orbital_Bombardment(true)

		p_republic.Make_Ally(p_pirates)
		p_pirates.Make_Ally(p_republic)

		p_cis.Make_Ally(p_pirates)
		p_pirates.Make_Ally(p_cis)

		mission_started = true
		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_01_CIS")
		elseif p_republic.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_01_Rep")
		end
	end
end


function State_Escape_Reached(prox_obj, trigger_obj)
	if trigger_obj == player_anakin then
		anakin_reached_escape = true
	end
	if trigger_obj == player_obiwan then
		obiwan_reached_escape = true
	end
	if trigger_obj == player_dooku then
		dooku_reached_escape = true
	end

	if anakin_reached_escape and obiwan_reached_escape and dooku_reached_escape then
		Remove_Radar_Blip("door_blip")
		door_marker.Highlight(false)
		Story_Event("ESCAPE_REACHED")
		prox_obj.Cancel_Event_Object_In_Range(State_Escape_Reached)
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
	end
end
function State_Generator_Reached(prox_obj, trigger_obj)
	if trigger_obj == Find_First_Object("JAR_JAR_BINKS") then
		generator_reached = true
	end

	if generator_reached and not tank_reached then
		prox_obj.Cancel_Event_Object_In_Range(State_Generator_Reached)
		Story_Event("GENERATOR_REACHED")
	end
end
function State_Tanks_Reached(prox_obj, trigger_obj)
	if trigger_obj == Find_First_Object("JAR_JAR_BINKS") then
		prox_obj.Cancel_Event_Object_In_Range(State_Tanks_Reached)
		Story_Event("GOAL_TRIGGER_III")
		Story_Event("TANK_REACHED")
	end
end
function State_Base_Reached(prox_obj, trigger_obj)
	if trigger_obj == player_jar_jar_i then
		base_reached = true
	end
	if trigger_obj == player_jar_jar_t then
		base_reached = true
	end
	if base_reached then
		Remove_Radar_Blip("base_blip")
		base_marker.Highlight(false)
		Story_Event("BASE_REACHED")
		prox_obj.Cancel_Event_Object_In_Range(State_Base_Reached)
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
	end
end

function State_Tank_Destroyed()
	Story_Event("TANK_DESTROYED")
end
function State_Terminal_Destroyed()
	blast_door_list = Find_All_Objects_Of_Type("MISSION_MAGNETIC_BLAST_DOOR_BIG")
	for k, blast_doors in pairs(blast_door_list) do
		if TestValid(blast_doors) then
			blast_doors.Play_SFX_Event("SFX_UMP_EmpireKesselAlarm")
			blast_doors.Play_Animation("Cinematic", false, 1)
			Sleep(3.0)
			blast_doors.Despawn()
		end
	end
end

function State_Heroes_Death(message)
	if message == OnEnter then
		StoryUtil.DeclareVictory(p_pirates, false)
	end
end
function State_Reactor_Reached(message)
	if message == OnEnter then
		generator_reached = false
		Remove_Radar_Blip("generator_blip")
		generator_marker.Highlight(false)

		Stop_All_Music()
		MissionUtil.CinematicEnvironmentOn()

		MissionUtil.PlayGenericSpeech("Perfect_Piracy_03")
		Stop_All_Music()
		Play_Music("Silence_Theme")

		Sleep(8.0)

		Add_Radar_Blip(base_marker, "base_blip")
		base_marker.Highlight(true)

		MissionUtil.CinematicEnvironmentOff()

		player_tank_1.Change_Owner(p_pirates)
		player_tank_2.Change_Owner(p_pirates)
		player_tank_3.Change_Owner(p_pirates)

		player_tank_1.Move_To(player_jar_jar_i)
		player_tank_2.Move_To(player_jar_jar_i)
		player_tank_3.Move_To(player_jar_jar_i)
	end
end
function State_Pirates_Reached(message)
	if message == OnEnter then
		player_tank_1.Stop()
		player_tank_2.Stop()
		player_tank_3.Stop()

		Stop_All_Music()
		MissionUtil.CinematicEnvironmentOn()

		MissionUtil.PlayGenericSpeech("Perfect_Piracy_04")
		Stop_All_Music()
		Play_Music("Silence_Theme")

		Sleep(38.0)

		player_pirate_tank_1 = Find_Nearest(player_jar_jar_i, "WLO5_TANK")

		player_jar_jar_i.Despawn()

		pirate_tank_1_position = player_pirate_tank_1.Get_Position()
		player_pirate_tank_1.Despawn()

		jar_jar_t_unit = Find_Object_Type("Jar_Jar_WLO5_Tank")
		jar_jar_t_list = Spawn_Unit(jar_jar_t_unit, pirate_tank_1_position, p_republic)
		player_jar_jar_t = jar_jar_t_list[1]
		player_jar_jar_t.Teleport_And_Face(pirate_tank_1_position)

		Register_Death_Event(player_jar_jar_t, State_Tank_Destroyed)

		p_republic.Make_Enemy(p_pirates)
		p_pirates.Make_Enemy(p_republic)

		MissionUtil.CinematicEnvironmentOff()
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

					cinematic_one = false

					Fade_On()
					Stop_All_Music()
					Stop_All_Speech()
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

					Hide_Sub_Object(player_dooku, 0, "lightsaber");
					Hide_Sub_Object(player_obiwan, 0, "lightsaber");
					Hide_Sub_Object(player_anakin, 0, "lightsaber");

					Add_Radar_Blip(door_marker, "door_blip")
					door_marker.Highlight(true)

					p_terminal = Find_First_Object("MISSION_CONTROL_PANEL")
					Register_Death_Event(p_terminal, State_Terminal_Destroyed)
					Add_Radar_Blip(p_terminal, "controls_blip")
					p_terminal.Highlight(true)

					MissionUtil.Set_To_Enemies(p_pirates, p_cis)

					Register_Prox(door_marker, State_Escape_Reached, 130, p_cis)

					MissionUtil.CinematicSkippingCleanUp(player_obiwan)
					MissionUtil.SetObjectiveMissionSet("PERFECT_PIRACY", "CIS", 4)

					cinematic_two = false
					act_1_active = true

					Fade_Screen_In(0.5)
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

					cinematic_one = false

					Fade_On()
					Stop_All_Music()
					Stop_All_Speech()
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_02_Rep")
				end
			end
			if cinematic_two then
				if not cinematic_two_skipped then
					cinematic_two_skipped = true
	
					if current_cinematic_thread_id ~= nil then
						Thread.Kill(current_cinematic_thread_id)
						current_cinematic_thread_id = nil
					end

					Hide_Sub_Object(player_dooku, 0, "lightsaber");
					Hide_Sub_Object(player_obiwan, 0, "lightsaber");
					Hide_Sub_Object(player_anakin, 0, "lightsaber");

					Add_Radar_Blip(door_marker, "door_blip")
					door_marker.Highlight(true)

					p_terminal = Find_First_Object("MISSION_CONTROL_PANEL")
					Register_Death_Event(p_terminal, State_Terminal_Destroyed)
					Add_Radar_Blip(p_terminal, "controls_blip")
					p_terminal.Highlight(true)

					MissionUtil.Set_To_Enemies(p_pirates, p_republic)

					Register_Prox(door_marker, State_Escape_Reached, 130, p_republic)

					MissionUtil.CinematicSkippingCleanUp(player_obiwan)
					MissionUtil.SetObjectiveMissionSet("PERFECT_PIRACY", "REP", 4)

					cinematic_two = false
					act_1_active = true

					Fade_Screen_In(0.5)
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

					StoryUtil.DeclareVictory(p_republic, false)
				end
			end
		end
	end
end
function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_1_active then
		end
		if act_2_active then
		end
	elseif p_republic.Is_Human() then
		if act_1_active then
		end
		if act_2_active then
		end
	end
end


function Start_Cinematic_Intro_01_CIS()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()
	Sleep(0.5)

	player_jar_jar_i = Find_First_Object("JAR_JAR_BINKS")
	player_jar_jar_i.Teleport_And_Face(jarjar_marker)

	player_arc1 = Find_Hint("SHOCK_CLONE_PHASE_ONE", "binks")	
	player_arc2 = Find_Hint("CLONE_PHASE_ONE_CARBINE", "binks")	

	cinematic_one = true

	MissionUtil.CinematicIntroHeader("PERFECT_PIRACY")
	MissionUtil.PlayGenericSpeech("Perfect_Piracy_02")
	MissionUtil.PlayGenericMusic("Silence_Theme")

	MissionUtil.SetCinematicCamera(midtrocam_1_marker, jarjar_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(midtrocam_2_marker, jarjar_marker, true, 8.0, nil, nil)
	Fade_Screen_In(0.5)
	Letter_Box_In(0.5)

	player_arc2.Turn_To_Face(player_arc1)
	player_arc2.Play_Animation("Idle", false, 2)
	Sleep(2.0)

	player_arc2.Stop()

	player_arc1.Turn_To_Face(player_arc2)
	player_arc1.Play_Animation("Talk", false, 0)
	Sleep(4.5)

	MissionUtil.SetCinematicCamera(midtrocam_3_marker, player_jar_jar_i, true, nil, nil)

	player_jar_jar_i.Turn_To_Face(player_arc1)
	player_arc1.Turn_To_Face(player_jar_jar_i)
	player_arc2.Turn_To_Face(player_jar_jar_i)
	Sleep(1.0)

	player_jar_jar_i.Play_Animation("Idle", false, 4)

	MissionUtil.SetCinematicCamera(midtrocam_4_marker, player_jar_jar_i, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(midtrocam_1_marker, player_jar_jar_i, true, 50.0, nil, nil)
	Sleep(5.5)

	player_arc2.Turn_To_Face(player_arc1)
	player_arc2.Play_Animation("Talk", false, 1)

	MissionUtil.SetCinematicCamera(midtrocam_5_marker, midtrocam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(midtrocam_6_marker, midtrocam_target_2_marker, true, 13.0, nil, nil)
	Sleep(4.0)

	player_arc1.Turn_To_Face(player_arc2)
	player_arc1.Play_Animation("Talk", false, 0)
	Sleep(6.0)

	Fade_Screen_Out(1.5)
	Sleep(4.6)

	binks_table = Find_All_Objects_With_Hint("binks")
	for i,unit in pairs(binks_table) do
		unit.Despawn()
	end

	MissionUtil.Set_To_Allies(p_cis, p_pirates)
	MissionUtil.Set_To_Allies(p_republic, p_pirates)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_02_CIS")
	end
end
function Start_Cinematic_Intro_02_CIS()
	dooku_unit = Find_Object_Type("DOOKU")
	dooku_list = Spawn_Unit(dooku_unit, dooku_marker, p_cis)
	player_dooku = dooku_list[1]
	player_dooku.Teleport_And_Face(dooku_marker)
	Hide_Sub_Object(player_dooku, 1, "lightsaber");

	obiwan_unit = Find_Object_Type("OBI_WAN")
	obiwan_list = Spawn_Unit(obiwan_unit, obiwan_marker, p_cis)
	player_obiwan = obiwan_list[1]
	player_obiwan.Teleport_And_Face(obiwan_marker)
	Hide_Sub_Object(player_obiwan, 1, "lightsaber");

	anakin_unit = Find_Object_Type("ANAKIN")
	anakin_list = Spawn_Unit(anakin_unit, anakin_marker, p_cis)
	player_anakin = anakin_list[1]
	player_anakin.Teleport_And_Face(anakin_marker)
	Hide_Sub_Object(player_anakin, 1, "lightsaber");

	cinematic_one = false
	cinematic_two = true

	MissionUtil.CinematicMidtroHeader("PERFECT_PIRACY")
	Sleep(0.5)

	MissionUtil.PlayGenericSpeech("Perfect_Piracy_01")
	MissionUtil.PlayGenericMusic("Silence_Theme")

	MissionUtil.SetCinematicCamera(introcam_1_marker, player_obiwan, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, player_obiwan, true, 8.0, nil, nil)

	player_obiwan.Turn_To_Face(player_anakin)
	player_obiwan.Play_Animation("Talk", false)
	player_anakin.Turn_To_Face(player_obiwan)
	player_dooku.Turn_To_Face(player_obiwan)

	Letter_Box_In(0.5)
	Fade_Screen_In(0.5)
	Sleep(3.8)

	player_obiwan.Turn_To_Face(player_dooku)
	Sleep(0.2)

	player_obiwan.Stop()
	player_dooku.Play_Animation("Talk", false, 2)
	Sleep(3.0)

	Fade_Screen_Out(1.0)
	Sleep(3.0)

	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_1_marker, true, 17.0, nil, nil)

	Fade_Screen_In(4.5)
	Sleep(15.0)

	Find_Hint("PROP_SHIELD_RECTANGLE_SMALL", "door-cell").Despawn()

	player_anakin.Move_To(anakin_move_to)
	player_obiwan.Move_To(obiwan_move_to)
	player_dooku.Move_To(dooku_move_to)

	Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 5, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_5_marker, 0, 0, 0, 0, player_obiwan, 1, 0)
	Sleep(2.0)

	MissionUtil.Set_To_Enemies(p_cis, p_pirates)
	MissionUtil.Set_To_Enemies(p_republic, p_pirates)

	player_dooku.Change_Owner(p_cis)
	player_obiwan.Change_Owner(p_cis)
	player_anakin.Change_Owner(p_cis)

	if not cinematic_two_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_02_CIS")
	end
end
function End_Cinematic_Intro_02_CIS()
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(player_obiwan, 4.5)
	Sleep(4.5)

	MissionUtil.SetObjectiveMissionSet("PERFECT_PIRACY", "CIS", 4)
	MissionUtil.AIActivation()

	Register_Prox(door_marker, State_Escape_Reached, 130, p_cis)

	cinematic_two = false
	act_1_active = true

	p_terminal = Find_First_Object("MISSION_CONTROL_PANEL")
	Register_Death_Event(p_terminal, State_Terminal_Destroyed)
	Add_Radar_Blip(p_terminal, "controls_blip")
	p_terminal.Highlight(true)

	Add_Radar_Blip(door_marker, "door_blip")
	door_marker.Highlight(true)

	Hide_Sub_Object(player_dooku, 0, "lightsaber");
	Hide_Sub_Object(player_obiwan, 0, "lightsaber");
	Hide_Sub_Object(player_anakin, 0, "lightsaber");

	Sleep(29.0)
	MissionUtil.CinematicEnvironmentOff()
end

function Start_Cinematic_Outro_CIS()
	act_2_active = false
	cinematic_three = true

	MissionUtil.Set_To_Allies(p_cis, p_pirates)
	MissionUtil.Set_To_Allies(p_republic, p_pirates)

	Fade_Screen_Out(0.5)
	Sleep(1.0)

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	final_anakin_unit = Find_Object_Type("Anakin")
	final_anakin_list = Spawn_Unit(final_anakin_unit, outro_anakin_marker, p_cis)
	player_final_anakin = final_anakin_list[1]
	player_final_anakin.Teleport_And_Face(outro_anakin_marker)

	final_obiwan_unit = Find_Object_Type("Obi_Wan")
	final_obiwan_list = Spawn_Unit(final_obiwan_unit, outro_obiwan_marker, p_cis)
	player_final_obiwan = final_obiwan_list[1]
	player_final_obiwan.Teleport_And_Face(outro_obiwan_marker)

	final_hondo_unit = Find_Object_Type("Hondo_Ohnaka")
	final_hondo_list = Spawn_Unit(final_hondo_unit, outro_hondo_marker, p_cis)
	player_final_hondo = final_hondo_list[1]
	player_final_hondo.Teleport_And_Face(outro_hondo_marker)

	final_jarjar_unit = Find_Object_Type("JAR_JAR_BINKS")
	final_jarjar_list = Spawn_Unit(final_jarjar_unit, outro_jarjar_marker, p_cis)
	player_final_jarjar = final_jarjar_list[1]
	player_final_jarjar.Teleport_And_Face(outro_jarjar_marker)

	Sleep(1.0)

	MissionUtil.PlayGenericSpeech("Perfect_Piracy_05")
	MissionUtil.PlayGenericMusic("Silence_Theme")

	MissionUtil.SetCinematicCamera(outrocam_1_marker, outrocam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outrocam_target_1_marker, true, 6.0, nil, nil)

	Fade_Screen_In(2.5)
	Sleep(1.0)

	player_final_anakin.Turn_To_Face(player_final_jarjar)
	player_final_obiwan.Turn_To_Face(player_final_jarjar)
	player_final_hondo.Turn_To_Face(player_final_jarjar)
	Sleep(5.0)

	player_final_obiwan.Play_Animation("Talk", false)

	MissionUtil.SetCinematicCamera(outrocam_4_marker, outrocam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_8_marker, outrocam_target_2_marker, true, 10.0, nil, nil)
	Sleep(1.5)

	player_final_anakin.Turn_To_Face(player_final_hondo)
	player_final_obiwan.Turn_To_Face(player_final_hondo)
	Sleep(3.0)

	player_escape_shuttle = Create_Cinematic_Transport("Stock_Sheathipede_Landing_Craft_Landing", p_pirates.Get_ID(), shuttle_marker, 90, 0, 2.0, 8, 0)
	Sleep(2.0)

	player_final_anakin.Turn_To_Face(shuttle_marker)
	player_final_obiwan.Turn_To_Face(shuttle_marker)
	player_final_hondo.Turn_To_Face(shuttle_marker)
	player_final_jarjar.Turn_To_Face(shuttle_marker)

	MissionUtil.SetCinematicCamera(outrocam_5_marker, shuttle_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_6_marker, shuttle_marker, true, 5.0, nil, nil)
	Sleep(4.5)

	player_final_anakin.Turn_To_Face(player_final_obiwan)
	player_final_obiwan.Turn_To_Face(player_final_anakin)
	Sleep(6.0)

	MissionUtil.SetCinematicCamera(outrocam_9_marker, outrocam_target_4_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_10_marker, outrocam_target_4_marker, true, 8.0, nil, nil)
	Sleep(0.5)

	player_final_anakin.Turn_To_Face(player_final_hondo)
	player_final_obiwan.Turn_To_Face(player_final_hondo)
	Sleep(0.5)
	
	player_final_hondo.Turn_To_Face(player_final_obiwan)
	player_final_obiwan.Play_Animation("Talk", false)
	Sleep(1.5)
	
	player_final_hondo.Play_Animation("Talk", false, 0)
	Sleep(6.0)

	MissionUtil.SetCinematicCamera(outrocam_8_marker, outrocam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_7_marker, outrocam_target_3_marker, true, 12.0, nil, nil)
	Sleep(1.0)

	Hide_Sub_Object(player_final_obiwan, 1, "lightsaber")
	Sleep(1.5)

	player_final_obiwan.Play_Animation("Talk", false)
	player_final_anakin.Turn_To_Face(player_final_obiwan)
	player_final_obiwan.Stop()

	player_final_hondo.Turn_To_Face(player_final_obiwan)
	player_final_hondo.Play_Animation("Talk", false, 0)
	Sleep(6.0)

	MissionUtil.SetCinematicCamera(outrocam_16_marker, outrocam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_10_marker, outrocam_target_3_marker, true, 15.0, nil, nil)

	player_final_jarjar.Turn_To_Face(player_final_anakin)
	Sleep(4.0)

	player_final_anakin.Turn_To_Face(player_final_jarjar)	
	Sleep(2.0)

	player_final_obiwan.Play_Animation("Talk", false)
	Sleep(3.0)

	player_final_obiwan.Turn_To_Face(player_final_jarjar)

	Hide_Sub_Object(player_final_anakin, 1, "lightsaber")

	MissionUtil.SetCinematicCamera(outrocam_14_marker, outrocam_target_4_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_16_marker, outrocam_target_4_marker, true, 20.0, nil, nil)
	Sleep(4.5)

	player_final_hondo.Play_Animation("Talk", false, 2)

	player_final_anakin.Turn_To_Face(player_final_hondo)
	player_final_obiwan.Turn_To_Face(player_final_hondo)
	Sleep(6.0)

	MissionUtil.SetCinematicCamera(outrocam_3_marker, outrocam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_10_marker, outrocam_target_2_marker, true, 30.0, nil, nil)
	Sleep(1.0)

	player_final_obiwan.Play_Animation("Talk", false)
	Sleep(2.5)

	player_final_hondo.Play_Animation("Talk", false, 2)

	MissionUtil.SetCinematicCamera(outrocam_17_marker, outrocam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_18_marker, outrocam_target_3_marker, true, 40.0, nil, nil)
	Sleep(1.0)

	player_final_obiwan.Play_Animation("Talk", true)
	Sleep(2.0)

	Fade_Screen_Out(5.5)
	Sleep(7.0)

	MissionUtil.CinematicEnvironmentOff()
	StoryUtil.DeclareVictory(p_cis, false)
end


function Start_Cinematic_Intro_01_Rep()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()
	Sleep(0.5)

	player_jar_jar_i = Find_First_Object("JAR_JAR_BINKS")
	player_jar_jar_i.Teleport_And_Face(jarjar_marker)

	player_arc1 = Find_Hint("SHOCK_CLONE_PHASE_ONE", "binks")	
	player_arc2 = Find_Hint("CLONE_PHASE_ONE_CARBINE", "binks")	

	cinematic_one = true

	MissionUtil.CinematicIntroHeader("PERFECT_PIRACY")
	MissionUtil.PlayGenericSpeech("Perfect_Piracy_02")
	MissionUtil.PlayGenericMusic("Silence_Theme")

	MissionUtil.SetCinematicCamera(midtrocam_1_marker, jarjar_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(midtrocam_2_marker, jarjar_marker, true, 8.0, nil, nil)
	Fade_Screen_In(0.5)
	Letter_Box_In(0.5)

	player_arc2.Turn_To_Face(player_arc1)
	player_arc2.Play_Animation("Idle", false, 2)
	Sleep(2.0)

	player_arc2.Stop()

	player_arc1.Turn_To_Face(player_arc2)
	player_arc1.Play_Animation("Talk", false, 0)
	Sleep(4.5)

	MissionUtil.SetCinematicCamera(midtrocam_3_marker, player_jar_jar_i, true, nil, nil)

	player_jar_jar_i.Turn_To_Face(player_arc1)
	player_arc1.Turn_To_Face(player_jar_jar_i)
	player_arc2.Turn_To_Face(player_jar_jar_i)
	Sleep(1.0)

	player_jar_jar_i.Play_Animation("Idle", false, 4)

	MissionUtil.SetCinematicCamera(midtrocam_4_marker, player_jar_jar_i, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(midtrocam_1_marker, player_jar_jar_i, true, 50.0, nil, nil)
	Sleep(5.5)

	player_arc2.Turn_To_Face(player_arc1)
	player_arc2.Play_Animation("Talk", false, 1)

	MissionUtil.SetCinematicCamera(midtrocam_5_marker, midtrocam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(midtrocam_6_marker, midtrocam_target_2_marker, true, 13.0, nil, nil)
	Sleep(4.0)

	player_arc1.Turn_To_Face(player_arc2)
	player_arc1.Play_Animation("Talk", false, 0)
	Sleep(6.0)

	Fade_Screen_Out(1.5)
	Sleep(4.6)

	binks_table = Find_All_Objects_With_Hint("binks")
	for i,unit in pairs(binks_table) do
		unit.Despawn()
	end

	MissionUtil.Set_To_Allies(p_cis, p_pirates)
	MissionUtil.Set_To_Allies(p_republic, p_pirates)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_02_Rep")
	end
end
function Start_Cinematic_Intro_02_Rep()
	dooku_unit = Find_Object_Type("DOOKU")
	dooku_list = Spawn_Unit(dooku_unit, dooku_marker, p_republic)
	player_dooku = dooku_list[1]
	player_dooku.Teleport_And_Face(dooku_marker)
	Hide_Sub_Object(player_dooku, 1, "lightsaber");

	obiwan_unit = Find_Object_Type("OBI_WAN")
	obiwan_list = Spawn_Unit(obiwan_unit, obiwan_marker, p_republic)
	player_obiwan = obiwan_list[1]
	player_obiwan.Teleport_And_Face(obiwan_marker)
	Hide_Sub_Object(player_obiwan, 1, "lightsaber");

	anakin_unit = Find_Object_Type("ANAKIN")
	anakin_list = Spawn_Unit(anakin_unit, anakin_marker, p_republic)
	player_anakin = anakin_list[1]
	player_anakin.Teleport_And_Face(anakin_marker)
	Hide_Sub_Object(player_anakin, 1, "lightsaber");

	cinematic_one = false
	cinematic_two = true

	cinematic_one = false
	cinematic_two = true

	MissionUtil.CinematicMidtroHeader("PERFECT_PIRACY")
	Sleep(0.5)

	MissionUtil.PlayGenericSpeech("Perfect_Piracy_01")
	MissionUtil.PlayGenericMusic("Silence_Theme")

	MissionUtil.SetCinematicCamera(introcam_1_marker, player_obiwan, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, player_obiwan, true, 8.0, nil, nil)

	player_obiwan.Turn_To_Face(player_anakin)
	player_obiwan.Play_Animation("Talk", false)
	player_anakin.Turn_To_Face(player_obiwan)
	player_dooku.Turn_To_Face(player_obiwan)

	Letter_Box_In(0.5)
	Fade_Screen_In(0.5)
	Sleep(3.8)

	player_obiwan.Turn_To_Face(player_dooku)
	Sleep(0.2)

	player_obiwan.Stop()
	player_dooku.Play_Animation("Talk", false, 2)
	Sleep(3.0)

	Fade_Screen_Out(1.0)
	Sleep(3.0)

	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_1_marker, true, 17.0, nil, nil)

	Fade_Screen_In(4.5)
	Sleep(15.0)

	Find_Hint("PROP_SHIELD_RECTANGLE_SMALL", "door-cell").Despawn()

	player_anakin.Move_To(anakin_move_to)
	player_obiwan.Move_To(obiwan_move_to)
	player_dooku.Move_To(dooku_move_to)

	Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 5, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_5_marker, 0, 0, 0, 0, player_obiwan, 1, 0)
	Sleep(2.0)

	MissionUtil.Set_To_Enemies(p_cis, p_pirates)
	MissionUtil.Set_To_Enemies(p_republic, p_pirates)

	player_dooku.Change_Owner(p_republic)
	player_obiwan.Change_Owner(p_republic)
	player_anakin.Change_Owner(p_republic)

	if not cinematic_two_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_02_Rep")
	end
end
function End_Cinematic_Intro_02_Rep()
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(player_obiwan, 4.5)
	Sleep(4.5)

	MissionUtil.SetObjectiveMissionSet("PERFECT_PIRACY", "REP", 4)
	MissionUtil.AIActivation()

	Register_Prox(door_marker, State_Escape_Reached, 130, p_republic)

	cinematic_two = false
	act_1_active = true

	p_terminal = Find_First_Object("MISSION_CONTROL_PANEL")
	Register_Death_Event(p_terminal, State_Terminal_Destroyed)
	Add_Radar_Blip(p_terminal, "controls_blip")
	p_terminal.Highlight(true)

	Add_Radar_Blip(door_marker, "door_blip")
	door_marker.Highlight(true)

	Hide_Sub_Object(player_dooku, 0, "lightsaber");
	Hide_Sub_Object(player_obiwan, 0, "lightsaber");
	Hide_Sub_Object(player_anakin, 0, "lightsaber");

	Sleep(29.0)
	MissionUtil.CinematicEnvironmentOff()
end

function Start_Cinematic_Outro_Rep()
	act_2_active = false
	cinematic_three = true

	MissionUtil.Set_To_Allies(p_cis, p_pirates)
	MissionUtil.Set_To_Allies(p_republic, p_pirates)

	Fade_Screen_Out(0.5)
	Sleep(1.0)

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	final_anakin_unit = Find_Object_Type("Anakin")
	final_anakin_list = Spawn_Unit(final_anakin_unit, outro_anakin_marker, p_republic)
	player_final_anakin = final_anakin_list[1]
	player_final_anakin.Teleport_And_Face(outro_anakin_marker)

	final_obiwan_unit = Find_Object_Type("Obi_Wan")
	final_obiwan_list = Spawn_Unit(final_obiwan_unit, outro_obiwan_marker, p_republic)
	player_final_obiwan = final_obiwan_list[1]
	player_final_obiwan.Teleport_And_Face(outro_obiwan_marker)

	final_hondo_unit = Find_Object_Type("Hondo_Ohnaka")
	final_hondo_list = Spawn_Unit(final_hondo_unit, outro_hondo_marker, p_republic)
	player_final_hondo = final_hondo_list[1]
	player_final_hondo.Teleport_And_Face(outro_hondo_marker)

	final_jarjar_unit = Find_Object_Type("JAR_JAR_BINKS")
	final_jarjar_list = Spawn_Unit(final_jarjar_unit, outro_jarjar_marker, p_republic)
	player_final_jarjar = final_jarjar_list[1]
	player_final_jarjar.Teleport_And_Face(outro_jarjar_marker)

	Sleep(1.0)

	MissionUtil.PlayGenericSpeech("Perfect_Piracy_05")
	MissionUtil.PlayGenericMusic("Silence_Theme")

	MissionUtil.SetCinematicCamera(outrocam_1_marker, outrocam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outrocam_target_1_marker, true, 6.0, nil, nil)

	Fade_Screen_In(2.5)
	Sleep(1.0)

	player_final_anakin.Turn_To_Face(player_final_jarjar)
	player_final_obiwan.Turn_To_Face(player_final_jarjar)
	player_final_hondo.Turn_To_Face(player_final_jarjar)
	Sleep(5.0)

	player_final_obiwan.Play_Animation("Talk", false)

	MissionUtil.SetCinematicCamera(outrocam_4_marker, outrocam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_8_marker, outrocam_target_2_marker, true, 10.0, nil, nil)
	Sleep(1.5)

	player_final_anakin.Turn_To_Face(player_final_hondo)
	player_final_obiwan.Turn_To_Face(player_final_hondo)
	Sleep(3.0)

	player_escape_shuttle = Create_Cinematic_Transport("Stock_Sheathipede_Landing_Craft_Landing", p_pirates.Get_ID(), shuttle_marker, 90, 0, 2.0, 8, 0)
	Sleep(2.0)

	player_final_anakin.Turn_To_Face(shuttle_marker)
	player_final_obiwan.Turn_To_Face(shuttle_marker)
	player_final_hondo.Turn_To_Face(shuttle_marker)
	player_final_jarjar.Turn_To_Face(shuttle_marker)

	MissionUtil.SetCinematicCamera(outrocam_5_marker, shuttle_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_6_marker, shuttle_marker, true, 5.0, nil, nil)
	Sleep(4.5)

	player_final_anakin.Turn_To_Face(player_final_obiwan)
	player_final_obiwan.Turn_To_Face(player_final_anakin)
	Sleep(6.0)

	MissionUtil.SetCinematicCamera(outrocam_9_marker, outrocam_target_4_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_10_marker, outrocam_target_4_marker, true, 8.0, nil, nil)
	Sleep(0.5)

	player_final_anakin.Turn_To_Face(player_final_hondo)
	player_final_obiwan.Turn_To_Face(player_final_hondo)
	Sleep(0.5)
	
	player_final_hondo.Turn_To_Face(player_final_obiwan)
	player_final_obiwan.Play_Animation("Talk", false)
	Sleep(1.5)
	
	player_final_hondo.Play_Animation("Talk", false, 0)
	Sleep(6.0)

	MissionUtil.SetCinematicCamera(outrocam_8_marker, outrocam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_7_marker, outrocam_target_3_marker, true, 12.0, nil, nil)
	Sleep(1.0)

	Hide_Sub_Object(player_final_obiwan, 1, "lightsaber")
	Sleep(1.5)

	player_final_obiwan.Play_Animation("Talk", false)
	player_final_anakin.Turn_To_Face(player_final_obiwan)
	player_final_obiwan.Stop()

	player_final_hondo.Turn_To_Face(player_final_obiwan)
	player_final_hondo.Play_Animation("Talk", false, 0)
	Sleep(6.0)

	MissionUtil.SetCinematicCamera(outrocam_16_marker, outrocam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_10_marker, outrocam_target_3_marker, true, 15.0, nil, nil)

	player_final_jarjar.Turn_To_Face(player_final_anakin)
	Sleep(4.0)

	player_final_anakin.Turn_To_Face(player_final_jarjar)	
	Sleep(2.0)

	player_final_obiwan.Play_Animation("Talk", false)
	Sleep(3.0)

	player_final_obiwan.Turn_To_Face(player_final_jarjar)

	Hide_Sub_Object(player_final_anakin, 1, "lightsaber")

	MissionUtil.SetCinematicCamera(outrocam_14_marker, outrocam_target_4_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_16_marker, outrocam_target_4_marker, true, 20.0, nil, nil)
	Sleep(4.5)

	player_final_hondo.Play_Animation("Talk", false, 2)

	player_final_anakin.Turn_To_Face(player_final_hondo)
	player_final_obiwan.Turn_To_Face(player_final_hondo)
	Sleep(6.0)

	MissionUtil.SetCinematicCamera(outrocam_3_marker, outrocam_target_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_10_marker, outrocam_target_2_marker, true, 30.0, nil, nil)
	Sleep(1.0)

	player_final_obiwan.Play_Animation("Talk", false)
	Sleep(2.5)

	player_final_hondo.Play_Animation("Talk", false, 2)

	MissionUtil.SetCinematicCamera(outrocam_17_marker, outrocam_target_3_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_18_marker, outrocam_target_3_marker, true, 40.0, nil, nil)
	Sleep(1.0)

	player_final_obiwan.Play_Animation("Talk", true)
	Sleep(2.0)

	Fade_Screen_Out(5.5)
	Sleep(7.0)

	MissionUtil.CinematicEnvironmentOff()
	StoryUtil.DeclareVictory(p_republic, false)
end
