
--****************************************************--
--*************** Rimward: Ryloth Remedy *************--
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
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_neutral = Find_Player("Neutral")

	PrimarySkydomeList = {"Bespin_Clouds"}
	SpaceLuaShuttleList = {"Cinematic_Ryloth_Intro"}

	J1_Team_List = {"J1_Cannon_Artillery_Anim"}

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

	first_twilek_freed = false

	mission_started = false
end
function Begin_Battle(message)
	if message == OnEnter then
		GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 0)

		MissionUtil.DisableRetreat("REBEL", true)
		MissionUtil.DisableRetreat("EMPIRE", true)
		MissionUtil.AllowOrbitalSupport(p_republic, false)

		if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
			Clone_Team_List = {"Clonetrooper_Phase_Two_Company"}
		else
			Clone_Team_List = {"Clonetrooper_Phase_One_Company"}
		end

		landing_zone_marker = Find_Hint("REINFORCEMENT_POINT_PLUS5_CAP", "start")
		player_cis_field_base = Find_Hint("CIS_FIELD_COMMANDO_BASE", "start")

		tx_20_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "tx-20")

		clone_spawn_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "clone-spawn")
		obi_shuttle_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "212st-shuttle")
		shuttle_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "shuttle-1")
		shuttle_02_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "shuttle-2")
		shuttle_03_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "shuttle-3")
		shuttle_04_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "shuttle-4")

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-2")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")

		shuttlecam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "shuttlecam-1")
		shuttlecam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "shuttlecam-2")

		midtrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-1")
		midtrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-2")

		midtrocam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam-target-1")

		space_cinematic_center = Find_Hint("STORY_TRIGGER_ZONE_00", "spacecinematiccenter")
		Promote_To_Space_Cinematic_Layer(space_cinematic_center)

		cinematic_lua_shuttle_pos = Find_Hint("STORY_TRIGGER_ZONE_00", "luashuttlestart")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_shuttle_pos)

		--Camera Markers
		cinematic_lua_cam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-1")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_1_marker)

		cinematic_lua_cam_1_target_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-1-target")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_1_target_marker)

		cinematic_lua_cam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-2")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_2_marker)

		cinematic_lua_cam_2_target_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-2-target")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_2_target_marker)

		cinematic_lua_cam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-3")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_3_marker)

		cinematic_lua_cam_3_target_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-3-target")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_3_target_marker)

		cinematic_lua_cam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-4")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_4_marker)

		cinematic_lua_cam_4_target_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "lua-cam-4-target")
		Promote_To_Space_Cinematic_Layer(cinematic_lua_cam_4_target_marker)

		Register_Death_Event(Find_First_Object("Labour_Camp"), State_Hero_Death_Labour_Camp)

		Set_Cinematic_Environment(true)

		mission_started = true
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
	end
end

function State_Hero_Death_Labour_Camp()
	MissionUtil.MissionTextSpeech("RYLOTH_REMEDY", 6, 10.0, "ObiWan2_Loop", {r = 250, g = 44, b = 44}) -- Obi-Wan
	MissionUtil.SetMissionObjectiveComplete("RYLOTH_REMEDY", "REP", 2)
end
function State_Hero_Death_TX_20()
	MissionUtil.SetMissionObjectiveComplete("RYLOTH_REMEDY", "REP", 4)
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

					if TestValid(cinematic_skydome) then
						cinematic_skydome.Despawn()
					end
					if TestValid(Lua_Space_Shuttle) then
						Lua_Space_Shuttle.Despawn()
					end

					phase_1_list = Find_All_Objects_With_Hint("phase-1")
					for i,phase_1_unit in pairs(phase_1_list) do
						Add_Radar_Blip(phase_1_unit, "phase_1_unit_blip")
						phase_1_unit.Highlight(true)
					end

					Clone_Spawn_List_01 = SpawnList(Clone_Team_List, clone_spawn_marker, p_republic, true, false)
					Clone_Squad_01 = Clone_Spawn_List_01[1]

					Clone_Spawn_List_02 = SpawnList(Clone_Team_List, clone_spawn_marker, p_republic, true, false)
					Clone_Squad_02 = Clone_Spawn_List_02[1]

					if not TestValid(Find_First_Object("Obi_Wan")) then
						obiwan_unit = Find_Object_Type("Obi_Wan")
						obiwan_list = Spawn_Unit(obiwan_unit, clone_spawn_marker, p_republic)
						player_obiwan = obiwan_list[1]
						player_obiwan.Teleport_And_Face(clone_spawn_marker)
					end

					if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
						if not TestValid(Find_First_Object("Cody2")) then
							player_cody = MissionUtil.SpawnUnitGround("CODY2", clone_spawn_marker, p_republic)
						end

						if not TestValid(Find_First_Object("Waxer2")) then
							player_waxer = MissionUtil.SpawnUnitGround("WAXER2", clone_spawn_marker, p_republic)
						end

						if not TestValid(Find_First_Object("Boil2")) then
							player_boil = MissionUtil.SpawnUnitGround("BOIL2", clone_spawn_marker, p_republic)
						end
					else
						if not TestValid(Find_First_Object("Cody")) then
							player_cody = MissionUtil.SpawnUnitGround("CODY", clone_spawn_marker, p_republic)
						end

						if not TestValid(Find_First_Object("Waxer")) then
							player_waxer = MissionUtil.SpawnUnitGround("WAXER", clone_spawn_marker, p_republic)
						end

						if not TestValid(Find_First_Object("Boil")) then
							player_boil = MissionUtil.SpawnUnitGround("BOIL", clone_spawn_marker, p_republic)
						end
					end

					if not TestValid(obiwan_shuttle) then
						obiwan_shuttle = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), obi_shuttle_marker, 54, 1,0.25, 0.5, 1)
					end
					Hide_Sub_Object(obiwan_shuttle, 1, "Clones")
					Hide_Sub_Object(obiwan_shuttle, 1, "Boil")
					Hide_Sub_Object(obiwan_shuttle, 1, "Boil_Carbine")
					Hide_Sub_Object(obiwan_shuttle, 1, "Boil_Helmet")
					Hide_Sub_Object(obiwan_shuttle, 1, "Waxer")
					Hide_Sub_Object(obiwan_shuttle, 1, "Waxer_Carbine")
					Hide_Sub_Object(obiwan_shuttle, 1, "Waxer_Helmet")
					Hide_Sub_Object(obiwan_shuttle, 1, "Cody")
					Hide_Sub_Object(obiwan_shuttle, 1, "Cody_Carbine")
					Hide_Sub_Object(obiwan_shuttle, 1, "CodyHelmet")
					Hide_Sub_Object(obiwan_shuttle, 1, "Obi")
					Hide_Sub_Object(obiwan_shuttle, 1, "Obi_Clones")
					obiwan_shuttle.Set_Selectable(false)

					if not TestValid(player_shuttle_01) then
						player_shuttle_01 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), shuttle_01_marker, 54, 1,0.25, 0.5, 1)
					end
					Hide_Sub_Object(player_shuttle_01, 1, "Clones")
					Hide_Sub_Object(player_shuttle_01, 1, "Boil")
					Hide_Sub_Object(player_shuttle_01, 1, "Boil_Carbine")
					Hide_Sub_Object(player_shuttle_01, 1, "Boil_Helmet")
					Hide_Sub_Object(player_shuttle_01, 1, "Waxer")
					Hide_Sub_Object(player_shuttle_01, 1, "Waxer_Carbine")
					Hide_Sub_Object(player_shuttle_01, 1, "Waxer_Helmet")
					Hide_Sub_Object(player_shuttle_01, 1, "Cody")
					Hide_Sub_Object(player_shuttle_01, 1, "Cody_Carbine")
					Hide_Sub_Object(player_shuttle_01, 1, "CodyHelmet")
					Hide_Sub_Object(player_shuttle_01, 1, "Obi")
					Hide_Sub_Object(player_shuttle_01, 1, "Obi_Clones")
					player_shuttle_01.Set_Selectable(false)

					if not TestValid(player_shuttle_02) then
						player_shuttle_02 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), shuttle_02_marker, 54, 1,0.25, 0.5, 1)
					end
					Hide_Sub_Object(player_shuttle_02, 1, "Clones")
					Hide_Sub_Object(player_shuttle_02, 1, "Boil")
					Hide_Sub_Object(player_shuttle_02, 1, "Boil_Carbine")
					Hide_Sub_Object(player_shuttle_02, 1, "Boil_Helmet")
					Hide_Sub_Object(player_shuttle_02, 1, "Waxer")
					Hide_Sub_Object(player_shuttle_02, 1, "Waxer_Carbine")
					Hide_Sub_Object(player_shuttle_02, 1, "Waxer_Helmet")
					Hide_Sub_Object(player_shuttle_02, 1, "Cody")
					Hide_Sub_Object(player_shuttle_02, 1, "Cody_Carbine")
					Hide_Sub_Object(player_shuttle_02, 1, "CodyHelmet")
					Hide_Sub_Object(player_shuttle_02, 1, "Obi")
					Hide_Sub_Object(player_shuttle_02, 1, "Obi_Clones")
					player_shuttle_02.Set_Selectable(false)

					if not TestValid(player_shuttle_03) then
						player_shuttle_03 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), shuttle_03_marker, 54, 1,0.25, 0.5, 1)
					end
					Hide_Sub_Object(player_shuttle_03, 1, "Clones")
					Hide_Sub_Object(player_shuttle_03, 1, "Boil")
					Hide_Sub_Object(player_shuttle_03, 1, "Boil_Carbine")
					Hide_Sub_Object(player_shuttle_03, 1, "Boil_Helmet")
					Hide_Sub_Object(player_shuttle_03, 1, "Waxer")
					Hide_Sub_Object(player_shuttle_03, 1, "Waxer_Carbine")
					Hide_Sub_Object(player_shuttle_03, 1, "Waxer_Helmet")
					Hide_Sub_Object(player_shuttle_03, 1, "Cody")
					Hide_Sub_Object(player_shuttle_03, 1, "Cody_Carbine")
					Hide_Sub_Object(player_shuttle_03, 1, "CodyHelmet")
					Hide_Sub_Object(player_shuttle_03, 1, "Obi")
					Hide_Sub_Object(player_shuttle_03, 1, "Obi_Clones")
					player_shuttle_03.Set_Selectable(false)

					if not TestValid(player_shuttle_04) then
						player_shuttle_04 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), shuttle_04_marker, 54, 1,0.25, 0.5, 1)
					end
					Hide_Sub_Object(player_shuttle_04, 1, "Clones")
					Hide_Sub_Object(player_shuttle_04, 1, "Boil")
					Hide_Sub_Object(player_shuttle_04, 1, "Boil_Carbine")
					Hide_Sub_Object(player_shuttle_04, 1, "Boil_Helmet")
					Hide_Sub_Object(player_shuttle_04, 1, "Waxer")
					Hide_Sub_Object(player_shuttle_04, 1, "Waxer_Carbine")
					Hide_Sub_Object(player_shuttle_04, 1, "Waxer_Helmet")
					Hide_Sub_Object(player_shuttle_04, 1, "Cody")
					Hide_Sub_Object(player_shuttle_04, 1, "Cody_Carbine")
					Hide_Sub_Object(player_shuttle_04, 1, "CodyHelmet")
					Hide_Sub_Object(player_shuttle_04, 1, "Obi")
					Hide_Sub_Object(player_shuttle_04, 1, "Obi_Clones")
					player_shuttle_04.Set_Selectable(false)

					MissionUtil.SetObjectiveMissionSet("RYLOTH_REMEDY", "REP", 2)
					MissionUtil.CinematicSkippingCleanUp(clone_spawn_marker)
					MissionUtil.Set_To_Enemies(p_republic, p_cis)

					cinematic_one = false
					act_1_active = true

					-- StoryUtil.DeclareVictory(p_republic, false)

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

					GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)

					MissionUtil.SetMissionObjectiveComplete("RYLOTH_REMEDY", "REP", 1)
					MissionUtil.SetMissionObjectiveNew("RYLOTH_REMEDY", "REP", 3)
					MissionUtil.SetMissionObjectiveNew("RYLOTH_REMEDY", "REP", 4)

					MissionUtil.CinematicSkippingCleanUp(landing_zone_marker)

					cinematic_two = false
					act_2_active = true

					Fade_Screen_In(0.5)
				end
			end
		end
	end
end
function Story_Mode_Service()
	if p_republic.Is_Human() then
		if act_1_active then
			local phase_1_list = Find_All_Objects_With_Hint("phase-1")
			j1_list = Find_All_Objects_Of_Type("J1_CANNON_ARTILLERY_ANIM")
			if (table.getn(phase_1_list) == 0) and (table.getn(j1_list) == 0) then
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_Rep")
				act_1_active = false
			end
		end
		if act_2_active then
			local j1_list = Find_All_Objects_Of_Type("J1_CANNON_ARTILLERY_ANIM")
			local fieldbase_list = Find_All_Objects_Of_Type("CIS_FIELD_COMMANDO_BASE")
			if (table.getn(fieldbase_list) == 0) and (table.getn(j1_list) == 0) and not TestValid(Find_First_Object("TX_20_AAT")) then
				StoryUtil.DeclareVictory(p_republic, false)

				MissionUtil.DisableRetreat("REBEL", false)
				MissionUtil.DisableRetreat("EMPIRE", false)
				MissionUtil.AllowOrbitalSupport(p_republic, true)
			end
		end
	end
end

function Start_Cinematic_Intro_Rep()
	Obi_Wan_Spawning = Spawn_From_Reinforcement_Pool(Find_Object_Type("Obi_Wan_Delta_Team"), clone_spawn_marker, p_republic)
	if Obi_Wan_Spawning then
		player_obiwan = Obi_Wan_Spawning[1]
		player_obiwan.Teleport_And_Face(clone_spawn_marker)
	end

	if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
		Cody_Spawning = Spawn_From_Reinforcement_Pool(Find_Object_Type("Cody2_Team"), clone_spawn_marker, p_republic)
		if Cody_Spawning then
			player_cody = Cody_Spawning[1]
			player_cody.Teleport_And_Face(clone_spawn_marker)
		end
	else
		Cody_Spawning = Spawn_From_Reinforcement_Pool(Find_Object_Type("Cody_Team"), clone_spawn_marker, p_republic)
		if Cody_Spawning then
			player_cody = Cody_Spawning[1]
			player_cody.Teleport_And_Face(clone_spawn_marker)
		end
	end

	j1_marker_list = Find_All_Objects_With_Hint("j1-phase-1")
	for i,j1_marker in pairs(j1_marker_list) do
		J1_Spawn_List = SpawnList(J1_Team_List, j1_marker, p_cis, false, false)
		for i,J1_Unit in pairs(J1_Spawn_List) do
			MissionUtil.HighlightObject(true, J1_Unit, "J1_Unit_blip")
		end
	end

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

	Lua_Space_Shuttle_List = Find_All_Objects_Of_Type("CINEMATIC_RYLOTH_INTRO")
	Lua_Space_Shuttle = Lua_Space_Shuttle_List[1]

	Lua_Space_Shuttle.Hide(true)
	Lua_Space_Shuttle.Teleport(cinematic_lua_shuttle_pos)
	Lua_Space_Shuttle.Face_Immediate(space_cinematic_center)
	Lua_Space_Shuttle.Play_Animation("Cinematic", false, 0)
	Lua_Space_Shuttle.Hide(false)

	Sleep(1.0)

	MissionUtil.CinematicIntroHeader("RYLOTH_REMEDY")
	MissionUtil.PlayGenericMusic("Teth_Theme")
	Fade_Screen_In(7.0)
	Letter_Box_In(7.0)

	--Set_Cinematic_Camera_Key(target_pos, xoffset_dist, yoffset_pitch, zoffset_yaw, angles?, attach_object, use_object_rotation, cinematic_animation)
	Set_Cinematic_Camera_Key(cinematic_lua_cam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cinematic_lua_cam_1_target_marker, 0, 0, 0, 0, 0, 0, 0)
	Transition_Cinematic_Camera_Key(cinematic_lua_cam_1_marker, 15, 0, -200, 0, 0, 0, 0, 0)
	Sleep(12.0)

	Set_Cinematic_Camera_Key(cinematic_lua_cam_2_marker, 0, -150, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cinematic_lua_cam_2_target_marker, 0, -150, 0, 0, 0, 0, 0)
	Transition_Cinematic_Camera_Key(cinematic_lua_cam_2_marker, 15, 0, 10, 0, 0, 0, 0, 0)
	MissionUtil.MissionTextSpeech("RYLOTH_REMEDY", 1, 9.5, "ObiWan2_Loop", {r = 250, g = 44, b = 44}) -- Obi-Wan
	Sleep(10.0)

	Set_Cinematic_Camera_Key(cinematic_lua_cam_3_marker, 0, -100, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cinematic_lua_cam_3_target_marker, 0, -100, 0, 0, 0, 0, 0)
	Transition_Cinematic_Camera_Key(cinematic_lua_cam_3_marker, 15, 0, 10, 0, 0, 0, 0, 0)
	MissionUtil.MissionTextSpeech("RYLOTH_REMEDY", 2, 10.0, "Mace_Loop", {r = 198, g = 73, b = 164}) -- Mace Windu
	Sleep(10.5)

	Fade_Screen_Out(2.0)
	Sleep(2.0)

	cinematic_skydome.Despawn()
	Lua_Space_Shuttle.Despawn()
	Set_Cinematic_Environment(false)
	Enable_Fog(true)
	Sleep(2.0)

	obiwan_shuttle = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), obi_shuttle_marker, 54, 1,0.25, 20, 1)
	Hide_Sub_Object(obiwan_shuttle, 1, "Clones")
	obiwan_shuttle.Set_Selectable(false)

	MissionUtil.MissionTextSpeech("RYLOTH_REMEDY", 3, 5.5, "ObiWan2_Loop", {r = 250, g = 44, b = 44}) -- Obi-Wan

	player_shuttle_01 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), shuttle_01_marker, 54, 1,0.25, 20, 1)
	Hide_Sub_Object(player_shuttle_01, 1, "Boil")
	Hide_Sub_Object(player_shuttle_01, 1, "Boil_Carbine")
	Hide_Sub_Object(player_shuttle_01, 1, "Boil_Helmet")
	Hide_Sub_Object(player_shuttle_01, 1, "Waxer")
	Hide_Sub_Object(player_shuttle_01, 1, "Waxer_Carbine")
	Hide_Sub_Object(player_shuttle_01, 1, "Waxer_Helmet")
	Hide_Sub_Object(player_shuttle_01, 1, "Cody")
	Hide_Sub_Object(player_shuttle_01, 1, "Cody_Carbine")
	Hide_Sub_Object(player_shuttle_01, 1, "CodyHelmet")
	Hide_Sub_Object(player_shuttle_01, 1, "Obi")
	Hide_Sub_Object(player_shuttle_01, 1, "Obi_Clones")
	player_shuttle_01.Set_Selectable(false)

	player_shuttle_02 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), shuttle_02_marker, 54, 1,0.25, 20, 1)
	Hide_Sub_Object(player_shuttle_02, 1, "Boil")
	Hide_Sub_Object(player_shuttle_02, 1, "Boil_Carbine")
	Hide_Sub_Object(player_shuttle_02, 1, "Boil_Helmet")
	Hide_Sub_Object(player_shuttle_02, 1, "Waxer")
	Hide_Sub_Object(player_shuttle_02, 1, "Waxer_Carbine")
	Hide_Sub_Object(player_shuttle_02, 1, "Waxer_Helmet")
	Hide_Sub_Object(player_shuttle_02, 1, "Cody")
	Hide_Sub_Object(player_shuttle_02, 1, "Cody_Carbine")
	Hide_Sub_Object(player_shuttle_02, 1, "CodyHelmet")
	Hide_Sub_Object(player_shuttle_02, 1, "Obi")
	Hide_Sub_Object(player_shuttle_02, 1, "Obi_Clones")
	player_shuttle_02.Set_Selectable(false)

	player_shuttle_03 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), shuttle_03_marker, 54, 1,0.25, 20, 1)
	Hide_Sub_Object(player_shuttle_03, 1, "Boil")
	Hide_Sub_Object(player_shuttle_03, 1, "Boil_Carbine")
	Hide_Sub_Object(player_shuttle_03, 1, "Boil_Helmet")
	Hide_Sub_Object(player_shuttle_03, 1, "Waxer")
	Hide_Sub_Object(player_shuttle_03, 1, "Waxer_Carbine")
	Hide_Sub_Object(player_shuttle_03, 1, "Waxer_Helmet")
	Hide_Sub_Object(player_shuttle_03, 1, "Cody")
	Hide_Sub_Object(player_shuttle_03, 1, "Cody_Carbine")
	Hide_Sub_Object(player_shuttle_03, 1, "CodyHelmet")
	Hide_Sub_Object(player_shuttle_03, 1, "Obi")
	Hide_Sub_Object(player_shuttle_03, 1, "Obi_Clones")
	player_shuttle_03.Set_Selectable(false)

	player_shuttle_04 = Create_Cinematic_Transport("LAAT_Lander_Landing_Cinematic", p_republic.Get_ID(), shuttle_04_marker, 54, 1,0.25, 20, 1)
	Hide_Sub_Object(player_shuttle_04, 1, "Boil")
	Hide_Sub_Object(player_shuttle_04, 1, "Boil_Carbine")
	Hide_Sub_Object(player_shuttle_04, 1, "Boil_Helmet")
	Hide_Sub_Object(player_shuttle_04, 1, "Waxer")
	Hide_Sub_Object(player_shuttle_04, 1, "Waxer_Carbine")
	Hide_Sub_Object(player_shuttle_04, 1, "Waxer_Helmet")
	Hide_Sub_Object(player_shuttle_04, 1, "Cody")
	Hide_Sub_Object(player_shuttle_04, 1, "Cody_Carbine")
	Hide_Sub_Object(player_shuttle_04, 1, "CodyHelmet")
	Hide_Sub_Object(player_shuttle_04, 1, "Obi")
	Hide_Sub_Object(player_shuttle_04, 1, "Obi_Clones")
	player_shuttle_04.Set_Selectable(false)

	Set_Cinematic_Camera_Key(obiwan_shuttle, 200, 5, 200, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(obiwan_shuttle, 0, 0, 0, 0, obiwan_shuttle, 0, 1)	
	Transition_Cinematic_Camera_Key(obiwan_shuttle, 5, 210, 4, 275, 1, 0, 0, 0)

	Weather_Audio_Pause(false)
	Allow_Localized_SFX(true)
	Fade_Screen_In(2.0)
	Sleep(10.0)

	MissionUtil.MissionTextSpeech("RYLOTH_REMEDY", 4, 7.5, "ObiWan2_Loop", {r = 250, g = 44, b = 44}) -- Obi-Wan

	Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 5.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 5.5, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Sleep(5.5)

	if not cinematic_one_skipped then
		Create_Thread("End_Cinematic_Intro_Rep")
	end
end
function End_Cinematic_Intro_Rep()
	if not TestValid(Find_First_Object("Obi_Wan")) then
		obiwan_unit = Find_Object_Type("Obi_Wan")
		obiwan_list = Spawn_Unit(obiwan_unit, clone_spawn_marker, p_republic)
		player_obiwan = obiwan_list[1]
		player_obiwan.Teleport_And_Face(clone_spawn_marker)
	end

	if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
		if not TestValid(Find_First_Object("Cody2")) then
			cody_unit = Find_Object_Type("Cody2")
			cody_list = Spawn_Unit(cody_unit, clone_spawn_marker, p_republic)
			player_cody = cody_list[1]
			player_cody.Teleport_And_Face(clone_spawn_marker)
		end
	else
		if not TestValid(Find_First_Object("Cody")) then
			cody_unit = Find_Object_Type("Cody")
			cody_list = Spawn_Unit(cody_unit, clone_spawn_marker, p_republic)
			player_cody = cody_list[1]
			player_cody.Teleport_And_Face(clone_spawn_marker)
		end
	end

	Clone_Spawn_List_01 = SpawnList(Clone_Team_List, clone_spawn_marker, p_republic, false, false)
	Clone_Squad_01 = Clone_Spawn_List_01[1]

	Clone_Spawn_List_02 = SpawnList(Clone_Team_List, clone_spawn_marker, p_republic, false, false)
	Clone_Squad_02 = Clone_Spawn_List_02[1]

	if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
		if not TestValid(Find_First_Object("Waxer2")) then
			player_waxer = MissionUtil.SpawnUnitGround("WAXER2", clone_spawn_marker, p_republic)
		end

		if not TestValid(Find_First_Object("Boil2")) then
			player_boil = MissionUtil.SpawnUnitGround("BOIL2", clone_spawn_marker, p_republic)
		end
	else
		if not TestValid(Find_First_Object("Waxer")) then
			player_waxer = MissionUtil.SpawnUnitGround("WAXER", clone_spawn_marker, p_republic)
		end

		if not TestValid(Find_First_Object("Boil")) then
			player_boil = MissionUtil.SpawnUnitGround("BOIL", clone_spawn_marker, p_republic)
		end
	end

	Hide_Sub_Object(obiwan_shuttle, 1, "Boil")
	Hide_Sub_Object(obiwan_shuttle, 1, "Boil_Carbine")
	Hide_Sub_Object(obiwan_shuttle, 1, "Boil_Helmet")
	Hide_Sub_Object(obiwan_shuttle, 1, "Waxer")
	Hide_Sub_Object(obiwan_shuttle, 1, "Waxer_Carbine")
	Hide_Sub_Object(obiwan_shuttle, 1, "Waxer_Helmet")
	Hide_Sub_Object(obiwan_shuttle, 1, "Cody")
	Hide_Sub_Object(obiwan_shuttle, 1, "Cody_Carbine")
	Hide_Sub_Object(obiwan_shuttle, 1, "CodyHelmet")
	Hide_Sub_Object(obiwan_shuttle, 1, "Obi")
	Hide_Sub_Object(obiwan_shuttle, 1, "Obi_Clones")

	Hide_Sub_Object(player_shuttle_01, 1, "Clones")
	Hide_Sub_Object(player_shuttle_02, 1, "Clones")
	Hide_Sub_Object(player_shuttle_03, 1, "Clones")
	Hide_Sub_Object(player_shuttle_04, 1, "Clones")

	MissionUtil.EndCinematicCamera(clone_spawn_marker, 3.5)
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.AIActivation()

	MissionUtil.SetObjectiveMissionSet("RYLOTH_REMEDY", "REP", 2)

	current_cinematic_thread_id = nil

	cinematic_one = false
	act_1_active = true

	phase_1_list = Find_All_Objects_With_Hint("phase-1")
	for i,phase_1_unit in pairs(phase_1_list) do
		MissionUtil.HighlightObject(true, phase_1_unit, "phase_1_unit_blip")
	end
end

function Start_Cinematic_Midtro_Rep()
	player_tx_20 = MissionUtil.SpawnUnitGround("TX_20_TEAM", tx_20_marker, p_cis)
	Register_Death_Event(player_tx_20, State_Hero_Death_TX_20)

	j1_marker_list = Find_All_Objects_With_Hint("j1-phase-4")
	for i,j1_marker in pairs(j1_marker_list) do
		J1_Spawn_List = SpawnList(J1_Team_List, j1_marker, p_cis, false, false)
		for i,J1_Unit in pairs(J1_Spawn_List) do
			MissionUtil.HighlightObject(true, J1_Unit, "J1_Unit_blip")
		end
	end

	j1_marker_list = Find_All_Objects_With_Hint("j1-phase-3-optional")
	for i,j1_marker in pairs(j1_marker_list) do
		J1_Spawn_List = SpawnList(J1_Team_List, j1_marker, p_cis, false, false)
		J1_Unit = J1_Spawn_List[1]
		MissionUtil.HighlightObject(true, J1_Unit, "J1_Unit_blip")
	end

	j1_marker_list = Find_All_Objects_With_Hint("j1-phase-2-optional")
	for i,j1_marker in pairs(j1_marker_list) do
		J1_Spawn_List = SpawnList(J1_Team_List, j1_marker, p_cis, false, false)
		J1_Unit = J1_Spawn_List[1]
		MissionUtil.HighlightObject(true, J1_Unit, "J1_Unit_blip")
	end

	fieldbase_marker_list = Find_All_Objects_With_Hint("phase-3-optional")
	for i,fieldbase_unit in pairs(fieldbase_marker_list) do
		MissionUtil.HighlightObject(true, fieldbase_unit, "fieldbase_unit_blip")
	end

	fieldbase_marker_list = Find_All_Objects_With_Hint("phase-2-optional")
	for i,fieldbase_unit in pairs(fieldbase_marker_list) do
		MissionUtil.HighlightObject(true, fieldbase_unit, "fieldbase_unit_blip")
	end

	act_1_active = false
	cinematic_two = true
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	Fade_Screen_Out(1.0)
	Sleep(1.5)

	MissionUtil.SetCinematicCamera(midtrocam_1_marker, midtrocam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(midtrocam_2_marker, midtrocam_target_1_marker, true, 10.0, nil, nil)

	Fade_Screen_In(1.0)
	Letter_Box_In(1.0)
	Sleep(0.25)

	MissionUtil.MissionTextSpeech("RYLOTH_REMEDY", 5, 9.5, "ObiWan_Loop", {r = 250, g = 44, b = 44}) -- Obi-Wan
	Sleep(7.0)

	if not cinematic_two_skipped then
		Create_Thread("End_Cinematic_Midtro_Rep")
	end
end
function End_Cinematic_Midtro_Rep()
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(landing_zone_marker, 3.5)

	current_cinematic_thread_id = nil

	cinematic_two = false
	act_2_active = true

	MissionUtil.SetMissionObjectiveComplete("RYLOTH_REMEDY", "REP", 1)
	MissionUtil.SetMissionObjectiveNew("RYLOTH_REMEDY", "REP", 3)
	MissionUtil.SetMissionObjectiveNew("RYLOTH_REMEDY", "REP", 4)

	GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)
end
