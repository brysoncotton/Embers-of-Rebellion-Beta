
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
		Trigger_Rep_Heroes_Death = State_Rep_Heroes_Death
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_hostile = Find_Player("Hostile")
	p_neutral = Find_Player("Neutral")

	PrimarySkydomeList = {"SPACE_STARS"}
	SpaceLuaShuttleList = {"CINEMATIC_NU_CLASS_LANDING_BARREN"}
	B1SquadList = {"B1_DROID_SQUAD"}
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

	cinematic_one_skipped = false
	cinematic_two_skipped = false
	cinematic_three_skipped = false

	rex_centre_reached = false
	cody_centre_reached = false
	echo_centre_reached = false
	fives_centre_reached = false

	centre_reached = false

	centre_defender_dead = false
	platform_defender_dead = false

	self_destruct_active = false

	rex_escape_reached = false
	cody_escape_reached = false
	echo_escape_reached = false
	fives_escape_reached = false

	escape_reached = false

	mission_started = false
end
function Begin_Battle(message)
	if message == OnEnter then
		GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 0)
		GlobalValue.Set("Rimward_Rishi_Rookie_Outcome", 0)

		MissionUtil.Set_To_Allies(p_cis, p_hostile)
		MissionUtil.Set_To_Allies(p_republic, p_hostile)

		disabled_phase_1_list = Find_All_Objects_With_Hint("phase-1")
		for i,p_disabled_phase_1 in pairs(disabled_phase_1_list) do
			p_disabled_phase_1.Change_Owner(p_neutral)
			p_disabled_phase_1.Suspend_Locomotor(true)
		end

		if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
			Find_First_Object("CODY").Despawn()
			player_cody = Find_First_Object("CODY2")

			Find_First_Object("REX").Despawn()
			player_rex = Find_First_Object("REX2")
		else
			Find_First_Object("CODY2").Despawn()
			player_cody = Find_First_Object("CODY")

			Find_First_Object("REX2").Despawn()
			player_rex = Find_First_Object("REX")
		end

		player_rex.Set_Cannot_Be_Killed(true)
		player_cody.Set_Cannot_Be_Killed(true)

		player_echo = Find_First_Object("ECHO_ROOKIE")
		player_echo.Set_Cannot_Be_Killed(true)
		player_fives = Find_First_Object("FIVES_ROOKIE")
		player_fives.Set_Cannot_Be_Killed(true)
		player_heavy = Find_First_Object("HEVY_ROOKIE")
		player_heavy.Set_Cannot_Be_Killed(true)

		player_bx = Find_Hint("CLONE_PHASE_ONE_CARBINE", "bx")

		player_rep_shuttle = Find_Hint("NU_SHUTTLE_LANDING_CRAFT_LANDING_CINEMATIC", "shuttle")

		command_centre_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "command-centre-1")
		command_centre_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "command-centre-2")
		escape_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "escape")

		cis_army_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-army")
		cis_shuttle_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cis-shuttle")
		rep_shuttle_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-shuttle")

		elevator_entry_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "elevator-entry-1")
		elevator_entry_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "elevator-entry-2")
		elevator_entry_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "elevator-entry-3")

		intro_1_rex_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-rex")
		intro_2_rex_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-rex")

		intro_1_cody_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-cody")
		intro_2_cody_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-cody")

		intro_1_fives_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-fives")
		intro_2_fives_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-fives")

		intro_1_echo_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-echo")
		intro_2_echo_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-echo")

		intro_1_heavy_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-heavy")
		intro_2_heavy_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-heavy")

		intro_1_bx_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bx")
		intro_2_bx_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-bx")

		midtro_1_rex_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-1-rex")
		midtro_1_cody_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-1-cody")
		midtro_1_fives_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-1-fives")
		midtro_1_echo_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-1-echo")
		midtro_1_heavy_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro-1-heavy")

		signal_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "signal")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")
		introcam_target_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-4")

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
		introcam_13_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-13")
		introcam_14_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-14")
		introcam_15_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-15")
		introcam_16_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-16")
		introcam_17_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-17")
		introcam_18_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-18")

		midtrocam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-target-1")
		midtrocam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-target-2")
		midtrocam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-target-3")
		midtrocam_target_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-target-4")

		midtrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-1")
		midtrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-2")
		midtrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-3")
		midtrocam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-4")
		midtrocam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-5")
		midtrocam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-6")
		midtrocam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-7")
		midtrocam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-8")

		space_cinematic_center = Find_Hint("STORY_TRIGGER_ZONE_00", "spacecinematiccenter")
		Promote_To_Space_Cinematic_Layer(space_cinematic_center)

		cinematic_lua_shuttle_pos = Find_Hint("STORY_TRIGGER_ZONE_00", "luashuttlestart")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_shuttle_pos)

		Set_Cinematic_Environment(true)

		p_republic.Disable_Bombing_Run(false)
		p_cis.Disable_Bombing_Run(false)

		p_republic.Disable_Orbital_Bombardment(true)
		p_cis.Disable_Orbital_Bombardment(true)

		mission_started = true
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
	end
end

function State_Centre_1_Reached(prox_obj, trigger_obj)
	if trigger_obj == player_rex then
		rex_centre_reached = true
	end
	if trigger_obj == player_cody then
		cody_centre_reached = true
	end
	if trigger_obj == player_fives then
		fives_centre_reached = true
	end
	if trigger_obj == player_echo then
		echo_centre_reached = true
	end
	if rex_centre_reached and cody_centre_reached and fives_centre_reached and echo_centre_reached then
		prox_obj.Cancel_Event_Object_In_Range(State_Centre_1_Reached)
		Story_Event("CENTRE_REACHED")
		centre_reached = true

		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_Rep")
	end
end
function State_Centre_2_Reached(prox_obj, trigger_obj)
	if trigger_obj == player_rex or trigger_obj == player_cody or trigger_obj == player_fives or trigger_obj == player_echo or trigger_obj == player_heavy then
		prox_obj.Cancel_Event_Object_In_Range(State_Centre_2_Reached)
		Story_Event("SELF_DESTRUCTION_ACTIVE")
		Story_Event("SABOTAGE_04")
		Remove_Radar_Blip("centre_2_blip")
		command_centre_2_marker.Highlight(false)
		Add_Radar_Blip(escape_marker, "escape_blip")
		escape_marker.Highlight(true)
		self_destruct_active = true
	end
end
function State_Escape_Reached(prox_obj, trigger_obj)
	if trigger_obj == player_rex then
		rex_escape_reached = true
	end
	if trigger_obj == player_cody then
		cody_escape_reached = true
	end
	if trigger_obj == player_fives then
		fives_escape_reached = true
	end
	if trigger_obj == player_echo then
		echo_escape_reached = true
	end
	if rex_escape_reached and cody_escape_reached and self_destruct_active then
		prox_obj.Cancel_Event_Object_In_Range(State_Escape_Reached)
		Story_Event("ESCAPE_COMPLETE")
		escape_reached = true

		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
	end
end

function State_Rep_Heroes_Death(message)
	if message == OnEnter then
		GlobalValue.Set("Rimward_Rishi_Rookie_Outcome", 0)
		GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)
		StoryUtil.DeclareVictory(p_cis, false)
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
					Enable_Fog(true)
					Weather_Audio_Pause(false)
					Allow_Localized_SFX(true)

					disabled_phase_1_list = Find_All_Objects_With_Hint("phase-1")
					for i,p_disabled_phase_1 in pairs(disabled_phase_1_list) do
						p_disabled_phase_1.Change_Owner(p_cis)
						p_disabled_phase_1.Suspend_Locomotor(false)
					end

					Add_Radar_Blip(command_centre_1_marker, "centre_1_blip")
					command_centre_1_marker.Highlight(true)
					Register_Prox(command_centre_1_marker, State_Centre_1_Reached, 150, p_republic)

					if TestValid(player_bx) then
						player_bx.Change_Owner(p_cis)
					end

					if TestValid(player_rep_shuttle_cinematic) then
						player_rep_shuttle_cinematic.Despawn()
					end

					player_rep_shuttle = Find_Hint("NU_SHUTTLE_LANDING_CRAFT_LANDING_CINEMATIC", "shuttle")
					player_rep_shuttle.Teleport_And_Face(rep_shuttle_marker)
					player_rep_shuttle.Despawn()
					explosion_01 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), rep_shuttle_marker, p_neutral)

					if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
						if TestValid(Find_First_Object("CODY")) then
							Find_First_Object("CODY").Despawn()
						end
						player_cody = Find_First_Object("CODY2")

						if TestValid(Find_First_Object("REX")) then
							Find_First_Object("REX").Despawn()
						end
						player_rex = Find_First_Object("REX2")
					else
						if TestValid(Find_First_Object("CODY2")) then
							Find_First_Object("CODY2").Despawn()
						end
						player_cody = Find_First_Object("CODY")

						if TestValid(Find_First_Object("REX2")) then
							Find_First_Object("REX2").Despawn()
						end
						player_rex = Find_First_Object("REX")
					end

					player_echo = Find_First_Object("ECHO_ROOKIE")
					player_fives = Find_First_Object("FIVES_ROOKIE")
					player_heavy = Find_First_Object("HEVY_ROOKIE")

					player_rex.Teleport_And_Face(intro_2_rex_marker)
					player_cody.Teleport_And_Face(intro_2_cody_marker)
					player_fives.Teleport_And_Face(intro_2_fives_marker)
					player_echo.Teleport_And_Face(intro_2_echo_marker)
					player_heavy.Teleport_And_Face(intro_2_heavy_marker)

					platform_defender_marker_list = Find_All_Objects_With_Hint("bx-spawn")
					for i,platform_defender_marker in pairs(platform_defender_marker_list) do
						BX_Spawn_List = SpawnList(BXSquadList, platform_defender_marker, p_cis, true, true)
					end

					Story_Event("GOAL_TRIGGER_REP_I")

					Story_Event("SABOTAGE_01")

					MissionUtil.CinematicSkippingCleanUp(player_rex)

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

					disabled_phase_1_list = Find_All_Objects_With_Hint("phase-1")
					for i,p_disabled_phase_1 in pairs(disabled_phase_1_list) do
						p_disabled_phase_1.Despawn()
					end

					Remove_Radar_Blip("centre_1_blip")
					command_centre_1_marker.Highlight(false)

					Add_Radar_Blip(command_centre_2_marker, "centre_2_blip")
					command_centre_2_marker.Highlight(true)

					if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
						player_rex = Find_First_Object("REX2")
						if not TestValid(player_rex) then
							player_rex = MissionUtil.SpawnUnitGround("REX2", midtro_1_rex_marker, p_republic)
						end
					else
						player_rex = Find_First_Object("REX")
						if not TestValid(player_rex) then
							player_rex = MissionUtil.SpawnUnitGround("REX", midtro_1_rex_marker, p_republic)
						end
					end
					player_rex.Teleport_And_Face(midtro_1_rex_marker)
					player_rex.In_End_Cinematic(true)

					if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
						player_cody = Find_First_Object("CODY2")
						if not TestValid(player_cody) then
							player_cody = MissionUtil.SpawnUnitGround("CODY2", midtro_1_cody_marker, p_republic)
						end
					else
						player_cody = Find_First_Object("CODY")
						if not TestValid(player_cody) then
							player_cody = MissionUtil.SpawnUnitGround("CODY", midtro_1_cody_marker, p_republic)
						end
					end
					player_cody.Teleport_And_Face(midtro_1_cody_marker)
					player_cody.In_End_Cinematic(true)

					player_echo = Find_First_Object("ECHO_ROOKIE")
					if not TestValid(player_echo) then
						echo_unit = Find_Object_Type("ECHO_ROOKIE")
						echo_list = Spawn_Unit(echo_unit, midtro_1_echo_marker, p_republic)
						player_echo = echo_list[1]
					end
					player_echo.Teleport_And_Face(midtro_1_echo_marker)
					player_echo.In_End_Cinematic(true)

					player_fives = Find_First_Object("FIVES_ROOKIE")
					if not TestValid(player_fives) then
						fives_unit = Find_Object_Type("FIVES_ROOKIE")
						fives_list = Spawn_Unit(fives_unit, midtro_1_fives_marker, p_republic)
						player_fives = fives_list[1]
					end
					player_fives.Teleport_And_Face(midtro_1_fives_marker)
					player_fives.In_End_Cinematic(true)

					player_heavy = Find_First_Object("HEVY_ROOKIE")
					if not TestValid(player_heavy) then
						heavy_unit = Find_Object_Type("HEVY_ROOKIE")
						heavy_list = Spawn_Unit(heavy_unit, midtro_1_heavy_marker, p_republic)
						player_heavy = heavy_list[1]
					end
					player_heavy.Teleport_And_Face(midtro_1_heavy_marker)
					player_heavy.In_End_Cinematic(true)

					Do_End_Cinematic_Cleanup()

					if not TestValid(player_cis_shuttle_cinematic) then
						player_cis_shuttle_cinematic = Create_Cinematic_Transport("C9979_CARRIER_LANDING_FULL", p_cis.Get_ID(), cis_shuttle_marker, 180.0, 1, 1.0, 2.0, 0)
						FogOfWar.Reveal(p_republic, player_cis_shuttle_cinematic, 400)
					end

					cis_army_marker_list = Find_All_Objects_With_Hint("cis-army")
					for i,cis_army_marker in pairs(cis_army_marker_list) do
						B1_Spawn_List = SpawnList(B1SquadList, cis_army_marker, p_cis, true, true)
					end

					Register_Prox(command_centre_2_marker, State_Centre_2_Reached, 150, p_republic)
					Register_Prox(escape_marker, State_Escape_Reached, 150, p_republic)
					GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)

					Story_Event("GOAL_TRIGGER_REP_II")
					Story_Event("SABOTAGE_03")

					MissionUtil.CinematicSkippingCleanUp(player_rex)

					cinematic_two = false
					act_2_active = true

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
					GlobalValue.Set("Rimward_Rishi_Rookie_Outcome", 1)
					StoryUtil.DeclareVictory(p_republic, false)
				end
			end
		end
	end
end
function Story_Mode_Service()
	if p_republic.Is_Human() then
		if act_1_active then
		end
		if act_2_active then
		end
		if act_3_active then
		end
	end
end

function Start_Cinematic_Intro_Rep()
	cinematic_one = true

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()
	Fade_On()

	primary_space_skydome_list = SpawnList(PrimarySkydomeList, space_cinematic_center, p_republic, false, false)
	cinematic_skydome = primary_space_skydome_list[1]
	cinematic_skydome.Teleport_And_Face(space_cinematic_center)

	Weather_Audio_Pause(true)
	Start_Cinematic_Camera(false)
	Allow_Localized_SFX(false)
	Enable_Fog(false)

	Lua_Space_Shuttle_List = Find_All_Objects_Of_Type("CINEMATIC_NU_CLASS_LANDING_BARREN")
	Lua_Space_Shuttle = Lua_Space_Shuttle_List[1]

	Lua_Space_Shuttle.Hide(true)
	Lua_Space_Shuttle.Teleport(cinematic_lua_shuttle_pos)
	Lua_Space_Shuttle.Face_Immediate(space_cinematic_center)
	Lua_Space_Shuttle.Play_Animation("Cinematic", false, 0)
	Lua_Space_Shuttle.Hide(false)

	Set_Cinematic_Camera_Key(cinematic_lua_shuttle_pos, 100, -40, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cinematic_lua_shuttle_pos, 0, 0, -27, 0, 0, 0, 0)
	Transition_Cinematic_Camera_Key(cinematic_lua_shuttle_pos, 10, 100, -20, 0, 1, 0, 0, 0)

	MissionUtil.PlayGenericMusic("The_Tractor_Beam_Theme")
	Fade_Screen_In(7.0)
	Letter_Box_In(7.0)

	Story_Event("CINEMATIC_CRAWL_01")
	Story_Event("CINEMATIC_CRAWL_02")
	Sleep(9)

	Transition_Cinematic_Camera_Key(cinematic_lua_shuttle_pos, 18, 100, -20, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cinematic_lua_shuttle_pos, 18, 0, 0, -40, 0, 0, 0, 0)

	Sleep(10)

	Fade_Screen_Out(4)
	Sleep(4)
	cinematic_skydome.Despawn()
	Lua_Space_Shuttle.Despawn()
	Set_Cinematic_Environment(false)
	Enable_Fog(true)

	Sleep(1)

	player_fives.Turn_To_Face(player_echo)
	player_echo.Turn_To_Face(player_fives)
	player_heavy.Turn_To_Face(player_echo)

	player_rep_shuttle_cinematic = Create_Cinematic_Transport("NU_SHUTTLE_LANDING_CRAFT_LANDING_CINEMATIC", p_republic.Get_ID(), rep_shuttle_marker, 240.0, 1, 1.0, 13.0, 0)

	Set_Cinematic_Camera_Key(player_rep_shuttle_cinematic, 200, 5, 200, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(player_rep_shuttle_cinematic, 0, 0, 0, 0, player_rep_shuttle_cinematic, 0, 1)	
	Transition_Cinematic_Camera_Key(player_rep_shuttle_cinematic, 15, 210, 4, 275, 1, 0, 0, 0)

	Weather_Audio_Pause(false)
	Allow_Localized_SFX(true)

	player_rep_shuttle_cinematic.Despawn()
	player_rep_shuttle.Teleport_And_Face(rep_shuttle_marker)

	MissionUtil.PlayGenericSpeech("Rishi_Rookie_01")
	MissionUtil.PlayGenericMusic("Silence_Theme")
	Fade_Screen_In(12)
	Sleep(15)

	player_rex.Teleport_And_Face(intro_1_rex_marker)
	player_cody.Teleport_And_Face(intro_1_cody_marker)
	player_bx.Teleport_And_Face(intro_1_bx_marker)

	Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_4_marker, 7.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_4_marker, 7.5, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	Sleep(7.0)

	player_fives.Turn_To_Face(player_echo)
	player_fives.Play_Animation("Talk_Gesture", false, 0)
	player_echo.Turn_To_Face(player_fives)
	player_heavy.Turn_To_Face(player_echo)

	player_rex.Teleport_And_Face(intro_2_rex_marker)
	player_cody.Teleport_And_Face(intro_2_cody_marker)
	player_bx.Teleport_And_Face(intro_2_bx_marker)

	player_rex.Turn_To_Face(player_bx)
	player_cody.Turn_To_Face(player_bx)
	player_bx.Turn_To_Face(player_rex)

	Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_5_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_6_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_6_marker, 10.0, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Sleep(3.0)

	Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_8_marker, 6.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_8_marker, 6.0, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	player_bx.Play_Animation("Talk", false, 2)
	Sleep(3.0)

	player_bx.Play_Animation("Talk", false, 1)
	Sleep(3.0)

	Set_Cinematic_Camera_Key(introcam_9_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_9_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_10_marker, 6.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_10_marker, 6.0, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	player_bx.Play_Animation("Talk", false, 0)
	Sleep(5.0)

	Set_Cinematic_Camera_Key(introcam_11_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_11_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_12_marker, 7.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_12_marker, 7.0, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	player_rex.Play_Animation("Talk", false, 1)
	Sleep(3.0)

	player_bx.Play_Animation("Talk", false, 2)
	Sleep(4.0)

	Set_Cinematic_Camera_Key(introcam_13_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_13_marker, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_14_marker, 8.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_14_marker, 8.0, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	Sleep(3.0)

	player_fives.Play_Animation("Talk", false, 2)
	Sleep(3.0)

	player_echo.Play_Animation("Talk_Gesture", false, 0)
	Sleep(4.0)

	Set_Cinematic_Camera_Key(introcam_15_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_15_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_16_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_16_marker, 10.0, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	player_rex.Play_Animation("Talk_Gesture", false, 0)
	Sleep(3.0)

	player_bx.Play_Animation("Talk", false, 2)
	Sleep(3.0)

	explosion = Spawn_Unit(Find_Object_Type("Small_Explosion_Land"), signal_marker, p_neutral)

	player_rex.Turn_To_Face(signal_marker)
	player_cody.Turn_To_Face(signal_marker)
	player_bx.Turn_To_Face(signal_marker)

	player_rex.Play_Animation("Talk", false, 1)
	Sleep(2.0)

	player_bx.Change_Owner(p_cis)

	if not cinematic_one_skipped then
		Create_Thread("End_Cinematic_Intro_Rep")
	end
end
function End_Cinematic_Intro_Rep()
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(player_rex, 3.5)
	MissionUtil.AIActivation()
	Sleep(3.5)

	player_rep_shuttle = Find_Hint("NU_SHUTTLE_LANDING_CRAFT_LANDING_CINEMATIC", "shuttle")
	player_rep_shuttle.Teleport_And_Face(rep_shuttle_marker)
	player_rep_shuttle.Change_Owner(p_neutral)
	explosion_01 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), rep_shuttle_marker, p_neutral)

	if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
		player_cody = Find_First_Object("CODY2")
		player_rex = Find_First_Object("REX2")
	else
		player_cody = Find_First_Object("CODY")
		player_rex = Find_First_Object("REX")
	end

	player_echo = Find_First_Object("ECHO_ROOKIE")
	player_fives = Find_First_Object("FIVES_ROOKIE")
	player_heavy = Find_First_Object("HEVY_ROOKIE")

	player_rex.Teleport_And_Face(intro_2_rex_marker)
	player_cody.Teleport_And_Face(intro_2_cody_marker)
	player_fives.Teleport_And_Face(intro_2_fives_marker)
	player_echo.Teleport_And_Face(intro_2_echo_marker)
	player_heavy.Teleport_And_Face(intro_2_heavy_marker)

	platform_defender_marker_list = Find_All_Objects_With_Hint("bx-spawn")
	for i,platform_defender_marker in pairs(platform_defender_marker_list) do
		BX_Spawn_List = SpawnList(BXSquadList, platform_defender_marker, p_cis, true, true)
	end

	Story_Event("GOAL_TRIGGER_REP_I")

	Story_Event("SABOTAGE_01")

	disabled_phase_1_list = Find_All_Objects_With_Hint("phase-1")
	for i,p_disabled_phase_1 in pairs(disabled_phase_1_list) do
		p_disabled_phase_1.Change_Owner(p_cis)
		p_disabled_phase_1.Suspend_Locomotor(false)
	end

	Add_Radar_Blip(command_centre_1_marker, "centre_1_blip")
	command_centre_1_marker.Highlight(true)
	Register_Prox(command_centre_1_marker, State_Centre_1_Reached, 150, p_republic)

	cinematic_one = false
	act_1_active = true
end

function Start_Cinematic_Midtro_Rep()
	act_1_active = false
	cinematic_two = true

	Start_Cinematic_Camera()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()
	Stop_All_Music()
	Fade_Screen_Out(0.5)
	Sleep(0.5)

	Remove_Radar_Blip("centre_1_blip")
	command_centre_1_marker.Highlight(false)

	MissionUtil.PlayGenericSpeech("Rishi_Rookie_02")
	MissionUtil.PlayGenericMusic("Silence_Theme")

	if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
		player_rex = Find_First_Object("REX2")
		if not TestValid(player_rex) then
			player_rex = MissionUtil.SpawnUnitGround("REX2", midtro_1_rex_marker, p_republic)
		end
	else
		player_rex = Find_First_Object("REX")
		if not TestValid(player_rex) then
			player_rex = MissionUtil.SpawnUnitGround("REX", midtro_1_rex_marker, p_republic)
		end
	end
	player_rex.Teleport_And_Face(midtro_1_rex_marker)
	player_rex.In_End_Cinematic(true)

	if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
		player_cody = Find_First_Object("CODY2")
		if not TestValid(player_cody) then
			player_cody = MissionUtil.SpawnUnitGround("CODY2", midtro_1_cody_marker, p_republic)
		end
	else
		player_cody = Find_First_Object("CODY")
		if not TestValid(player_cody) then
			player_cody = MissionUtil.SpawnUnitGround("CODY", midtro_1_cody_marker, p_republic)
		end
	end
	player_cody.Teleport_And_Face(midtro_1_cody_marker)
	player_cody.In_End_Cinematic(true)

	player_echo = Find_First_Object("ECHO_ROOKIE")
	if not TestValid(player_echo) then
		echo_unit = Find_Object_Type("ECHO_ROOKIE")
		echo_list = Spawn_Unit(echo_unit, midtro_1_echo_marker, p_republic)
		player_echo = echo_list[1]
	end
	player_echo.Teleport_And_Face(midtro_1_echo_marker)
	player_echo.In_End_Cinematic(true)

	player_fives = Find_First_Object("FIVES_ROOKIE")
	if not TestValid(player_fives) then
		fives_unit = Find_Object_Type("FIVES_ROOKIE")
		fives_list = Spawn_Unit(fives_unit, midtro_1_fives_marker, p_republic)
		player_fives = fives_list[1]
	end
	player_fives.Teleport_And_Face(midtro_1_fives_marker)
	player_fives.In_End_Cinematic(true)

	player_heavy = Find_First_Object("HEVY_ROOKIE")
	if not TestValid(player_heavy) then
		heavy_unit = Find_Object_Type("HEVY_ROOKIE")
		heavy_list = Spawn_Unit(heavy_unit, midtro_1_heavy_marker, p_republic)
		player_heavy = heavy_list[1]
	end
	player_heavy.Teleport_And_Face(midtro_1_heavy_marker)
	player_heavy.In_End_Cinematic(true)

	Do_End_Cinematic_Cleanup()

	Sleep(0.5)
	Letter_Box_In(1.0)
	Fade_Screen_In(1.0)
	Set_Cinematic_Camera_Key(midtrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_1_marker, 0, 0, 0, 0, midtrocam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_2_marker, 10, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_2_marker, 10, 0, 0, 0, 0, midtrocam_target_1_marker, 1, 0)

	player_heavy.Turn_To_Face(player_rex)
	player_fives.Turn_To_Face(player_rex)
	player_echo.Turn_To_Face(player_rex)
	player_cody.Turn_To_Face(player_rex)
	player_rex.Turn_To_Face(player_cody)
	player_rex.Play_Animation("Talk", false, 1)
	Sleep(2)
	
	player_cody.Play_Animation("Talk", false, 0)
	Sleep(1)

	Set_Cinematic_Camera_Key(midtrocam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_3_marker, 0, 0, 0, 0, midtrocam_target_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_4_marker, 9, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_4_marker, 9, 0, 0, 0, 0, midtrocam_target_2_marker, 1, 0)
	player_fives.Play_Animation("Talk", false, 1)
	Sleep(4.0)

	player_cis_shuttle_cinematic = Create_Cinematic_Transport("C9979_CARRIER_LANDING_FULL", p_cis.Get_ID(), cis_shuttle_marker, 180.0, 1, 1.0, 10.0, 0)

	Set_Cinematic_Camera_Key(midtrocam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_5_marker, 0, 0, 0, 0, midtrocam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_6_marker, 7.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_6_marker, 7.5, 0, 0, 0, 0, midtrocam_target_1_marker, 1, 0)
	
	player_rex.Play_Animation("Talk", false, 0)
	Sleep(3.5)

	Set_Cinematic_Camera_Key(midtrocam_7_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_7_marker, 0, 0, 0, 0, midtrocam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_8_marker, 10, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_8_marker, 10, 0, 0, 0, 0, midtrocam_target_3_marker, 1, 0)
	player_heavy.Turn_To_Face(player_fives)
	player_echo.Turn_To_Face(player_fives)
	player_cody.Turn_To_Face(player_fives)
	player_rex.Turn_To_Face(player_fives)
	player_fives.Play_Animation("Talk", false, 0)
	Sleep(10.0)

	MissionUtil.CinematicEnvironmentOff()

	if not cinematic_two_skipped then
		Create_Thread("End_Cinematic_Midtro_Rep")
	end
end
function End_Cinematic_Midtro_Rep()
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(player_rex, 3.5)
	MissionUtil.AIActivation()
	Sleep(3.5)

	Story_Event("SABOTAGE_03")
	Story_Event("GOAL_TRIGGER_REP_II")

	cis_army_marker_list = Find_All_Objects_With_Hint("cis-army")
	for i,cis_army_marker in pairs(cis_army_marker_list) do
		B1_Spawn_List = SpawnList(B1SquadList, cis_army_marker, p_cis, true, true)
	end

	Register_Prox(command_centre_2_marker, State_Centre_2_Reached, 150, p_republic)
	Register_Prox(escape_marker, State_Escape_Reached, 150, p_republic)
	GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)

	FogOfWar.Reveal(p_republic, player_cis_shuttle_cinematic, 400)

	Add_Radar_Blip(command_centre_2_marker, "centre_2_blip")
	command_centre_2_marker.Highlight(true)

	cinematic_two = false
	act_2_active = true
end

function Start_Cinematic_Outro_Rep()
	act_3_active = false
	cinematic_three = true
	Fade_Screen_Out(0.5)
	Sleep(1.0)

	GlobalValue.Set("Rimward_Rishi_Rookie_Outcome", 1)
	StoryUtil.DeclareVictory(p_republic, false)
	MissionUtil.CinematicEnvironmentOff()
end
