
--*****************************************************--
--************* Rimward: Venator Ventress *************--
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
		Trigger_Plan_B = State_Plan_B,
		Escape_Reached = State_Escape_Reached,
		CIS_Heroes_Death = State_CIS_Heroes_Death,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")
	p_neutral = Find_Player("Neutral")

	clone_trooper_list = {"CLONETROOPER_PHASE_ONE_COMPANY"}
	clone_guard_list = {"ARC_PHASE_ONE_SQUAD"}
	explosion_list = {"HUGE_EXPLOSION_LAND"}

	bx_commando_list = {"BX_COMMANDO_COMPANY"}
	B2_Jetpack_Team_List = {"B2_RP_Droid_Squad"}
	B2_Team_List = {"B2_DROID_COMPANY"}

	droids_dead = false
	argyus_dead = false

	patrol_loop_range = 100
	notice_range = 150
	control_panel_range = 50
	notice_range_large = 300
	start_service = false

	boarding_begins = false
	reaction_trigger = false

	gunray_rescued = false
	reactor_sabotaged = false
	prison_reached = false
	hangar_reached = false

	gunray_arrived = false
	ventress_arrived = false
	argyus_arrived = false

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

	mission_started = false
end
function Begin_Battle(message)
	if message == OnEnter then
		patrol_loop1_mark0 = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop1-mark0")
		patrol_loop1_mark1 = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop1-mark1")
		patrol_loop1_mark2 = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop1-mark2")
		patrol_loop1_mark3 = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop1-mark3")
		patrol_loop1_mark4 = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop1-mark4")
		patrol_loop1_mark5 = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop1-mark5")

		patrol_loop2_mark0 = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop2-mark0")
		patrol_loop2_mark1 = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop2-mark1")
		patrol_loop2_mark2 = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop2-mark2")

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam4")

		midtrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam1")
		midtrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam2")
		midtrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam3")
		midtrocam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam4")
		midtrocam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam5")
		midtrocam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam6")

		outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam1")
		outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam2")
		outrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam3")
		outrocam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam4")
		outrocam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam5")
		outrocam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam6")
		outrocam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam7")
		outrocam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam8")

		ventress_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "ventressmarker")
		argyus_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "argyusmarker")
		gunray_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "gunraymarker")

		senate_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "senate1")
		senate_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "senate2")
		argyus_runto_gunray = Find_Hint("STORY_TRIGGER_ZONE_00", "argyusruntogunray")
		arc_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "arcmarker")

		finale_ventress_spawn = Find_Hint("STORY_TRIGGER_ZONE_00", "finalventress")
		finale_argyus_spawn = Find_Hint("STORY_TRIGGER_ZONE_00", "finalargyus")
		finale_gunray_spawn = Find_Hint("STORY_TRIGGER_ZONE_00", "finalgunray")

		finale_ventress_runto = Find_Hint("STORY_TRIGGER_ZONE_00", "finalventressrunto")
		finale_argyus_runto = Find_Hint("STORY_TRIGGER_ZONE_00", "finalargyusrunto")
		finale_gunray_runto = Find_Hint("STORY_TRIGGER_ZONE_00", "finalgunrayrunto")

		shuttle_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "shuttle")
		hangar_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "hangar")
		prison_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "prison")
		reactor_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "reactor")
		cafeteria_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "cafeteria")

		Register_Prox(hangar_marker, State_Hangar_Reached, notice_range_large, p_cis)

		guard_table = Find_All_Objects_With_Hint("guards")
		for i,unit in pairs(guard_table) do
			unit.Guard_Target(unit.Get_Position())
		end

		deactivated_table = Find_All_Objects_With_Hint("deactivated")
		for i,attes in pairs(deactivated_table) do
			attes.Suspend_Locomotor(true)
		end

		control_table = Find_All_Objects_Of_Type("GENERIC_CONTROL_PANEL")
		for i,controls in pairs(control_table) do
			controls.Make_Invulnerable(true)
		end

		p_cis.Make_Ally(p_invaders)
		p_invaders.Make_Ally(p_cis)

		p_republic.Make_Ally(p_invaders)
		p_invaders.Make_Ally(p_republic)

		p_cis.Disable_Bombing_Run(false)
		p_republic.Disable_Bombing_Run(false)

		p_cis.Disable_Orbital_Bombardment(true)
		p_republic.Disable_Orbital_Bombardment(true)

		mission_started = true
		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
		end
	end
end

function State_Hangar_Reached(prox_obj, trigger_obj)
	if gunray_rescued and argyus_dead then
		if trigger_obj == player_ventress then
			ventress_arrived = true
		end
		if trigger_obj == player_gunray then
			gunray_arrived = true
		end

		if ventress_arrived and gunray_arrived then
			prox_obj.Cancel_Event_Object_In_Range(State_Hangar_Reached)
			Story_Event("HANGAR_PROX_TRIGGER")
			Remove_Radar_Blip("hangar_blip")
		end
	elseif gunray_rescued and not argyus_dead then
		if trigger_obj == player_ventress then
			ventress_arrived = true
		end
		if trigger_obj == player_gunray then
			gunray_arrived = true
		end
		if trigger_obj == player_argyus then
			argyus_arrived = true
		end

		if ventress_arrived and gunray_arrived and argyus_arrived then
			prox_obj.Cancel_Event_Object_In_Range(State_Hangar_Reached)
			Story_Event("HANGAR_PROX_TRIGGER")
			Remove_Radar_Blip("hangar_blip")
			hangar_reached = true
		end
	end
end

function f_Patrol_Loop1_Mark0(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("CLONETROOPER_PHASE_ONE_COMPANY") then
			clone_team = trigger_obj.Get_Parent_Object()
			if TestValid(clone_team) then
				if not clone_team.Has_Active_Orders() then
					clone_team.Attack_Move(patrol_loop1_mark1.Get_Position())
				end
			end
		end
	end
end
function f_Patrol_Loop1_Mark1(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("CLONETROOPER_PHASE_ONE_COMPANY") then
			clone_team = trigger_obj.Get_Parent_Object()
			if TestValid(clone_team) then
				if not clone_team.Has_Active_Orders() then
					clone_team.Attack_Move(patrol_loop1_mark2.Get_Position())
				end
			end
		end
	end
end
function f_Patrol_Loop1_Mark2(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("CLONETROOPER_PHASE_ONE_COMPANY") then
			clone_team = trigger_obj.Get_Parent_Object()
			if TestValid(clone_team) then
				if not clone_team.Has_Active_Orders() then
					clone_team.Attack_Move(patrol_loop1_mark3.Get_Position())
				end
			end
		end
	end
end
function f_Patrol_Loop1_Mark3(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("CLONETROOPER_PHASE_ONE_COMPANY") then
			clone_team = trigger_obj.Get_Parent_Object()
			if TestValid(clone_team) then
				if not clone_team.Has_Active_Orders() then
					clone_team.Attack_Move(patrol_loop1_mark4.Get_Position())
				end
			end
		end
	end
end
function f_Patrol_Loop1_Mark4(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("CLONETROOPER_PHASE_ONE_COMPANY") then
			clone_team = trigger_obj.Get_Parent_Object()
			if TestValid(clone_team) then
				if not clone_team.Has_Active_Orders() then
					clone_team.Attack_Move(patrol_loop1_mark5.Get_Position())
				end
			end
		end
	end
end
function f_Patrol_Loop1_Mark5(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("CLONETROOPER_PHASE_ONE_COMPANY") then
			clone_team = trigger_obj.Get_Parent_Object()
			if TestValid(clone_team) then
				if not clone_team.Has_Active_Orders() then
					clone_team.Attack_Move(patrol_loop1_mark0.Get_Position())
				end
			end
		end
	end
end
function f_Patrol_Loop2_Mark0(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("CLONETROOPER_PHASE_ONE_COMPANY") then
			clone_team = trigger_obj.Get_Parent_Object()
			if TestValid(clone_team) then
				if not clone_team.Has_Active_Orders() then
					clone_team.Attack_Move(patrol_loop2_mark1.Get_Position())
				end
			end
		end
	end
end
function f_Patrol_Loop2_Mark1(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("CLONETROOPER_PHASE_ONE_SQUAD") then
			clone_team = trigger_obj.Get_Parent_Object()
			if TestValid(clone_team) then
				if not clone_team.Has_Active_Orders() then
					clone_team.Attack_Move(patrol_loop2_mark2.Get_Position())
				end
			end
		end
	end
end
function f_Patrol_Loop2_Mark2(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("CLONETROOPER_PHASE_ONE_SQUAD") then
			clone_team = trigger_obj.Get_Parent_Object()
			if TestValid(clone_team) then
				if not clone_team.Has_Active_Orders() then
					clone_team.Attack_Move(patrol_loop2_mark0.Get_Position())
				end
			end
		end
	end
end

function Tell_Units_To_Guard(unit_list)

	for i, unit in pairs(unit_list) do
		if unit.Get_Hint() == "guard" then
			unit.Guard_Target(unit.Get_Position())
		end
	end
	
end


function State_CIS_Heroes_Death(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			GlobalValue.Set("Rimward_CIS_Venator_Ventress_Outcome", 1) -- 0 = CIS Victory; 1 = Republic Victory
			--crossplot:publish("CIS_REDUCE_SUPPORT", Find_Player("Trade_Federation"))
			StoryUtil.DeclareVictory(p_republic, false)
		end
	end
end

function State_Plan_B(message)
	if message == OnEnter then
		ventress_unit = Find_Object_Type("Ventress")
		ventress_list = Spawn_Unit(ventress_unit, ventress_marker, p_cis)
		player_ventress = ventress_list[1]
		player_ventress.Teleport_And_Face(ventress_marker)
		Sleep(1.0)

		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_01_CIS")
		Sleep(10.0)

		Register_Prox(patrol_loop1_mark0, f_Patrol_Loop1_Mark0, patrol_loop_range, p_republic)
		Register_Prox(patrol_loop1_mark1, f_Patrol_Loop1_Mark1, patrol_loop_range, p_republic)
		Register_Prox(patrol_loop1_mark2, f_Patrol_Loop1_Mark2, patrol_loop_range, p_republic)
		Register_Prox(patrol_loop1_mark3, f_Patrol_Loop1_Mark3, patrol_loop_range, p_republic)
		Register_Prox(patrol_loop1_mark4, f_Patrol_Loop1_Mark4, patrol_loop_range, p_republic)
		Register_Prox(patrol_loop1_mark5, f_Patrol_Loop1_Mark5, patrol_loop_range, p_republic)

		Register_Prox(patrol_loop2_mark0, f_Patrol_Loop2_Mark0, patrol_loop_range, p_republic)
		Register_Prox(patrol_loop2_mark1, f_Patrol_Loop2_Mark1, patrol_loop_range, p_republic)
		Register_Prox(patrol_loop2_mark2, f_Patrol_Loop2_Mark2, patrol_loop_range, p_republic)
	end
end
function State_Escape_Reached(message)
	if message == OnEnter then
		if not argyus_dead then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
		else
			GlobalValue.Set("Rimward_CIS_Venator_Ventress_Outcome", 0) -- 0 = CIS Victory; 1 = Republic Victory

			StoryUtil.DeclareVictory(p_republic, false)
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

				MissionUtil.CinematicEnvironmentOff()

				MissionUtil.Set_To_Allies(p_republic, p_invaders)

				MissionUtil.CinematicSkippingCleanUp(shuttle_marker)
				Story_Event("GOAL_TRIGGER_CIS_I")

				SpawnList(B2_Team_List, shuttle_marker, p_cis, true, true)
				SpawnList(B2_Team_List, shuttle_marker, p_cis, true, true)
				SpawnList(B2_Team_List, shuttle_marker, p_cis, true, true)

				cinematic_one = false
				act_1_active = true
				reaction_trigger = true

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

				act_1_active = false
				act_2_active = false
				cinematic_two = false

				local guard_party = SpawnList(clone_guard_list, arc_marker.Get_Position(), p_republic, false, true)
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_02_CIS")
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

				MissionUtil.Set_To_Allies(p_republic, p_invaders)

				MissionUtil.CinematicSkippingCleanUp(player_argyus)

				player_argyus.Change_Owner(p_cis)
				player_gunray.Change_Owner(p_cis)
				player_ventress.Teleport_And_Face(reactor_marker)

				Story_Event("GOAL_TRIGGER_CIS_III")

				Add_Radar_Blip(shuttle_marker, "hangar_blip")
				shuttle_marker.Highlight(true)

				gunray_rescued = true

				cinematic_three = false
				act_3_active = true

				Fade_Screen_In(0.5)
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

				GlobalValue.Set("Rimward_CIS_Venator_Ventress_Outcome", 0) -- 0 = CIS Victory; 1 = Republic Victory
				--crossplot:publish("CIS_SUPPORT", Find_Player("Trade_Federation"))
				StoryUtil.DeclareVictory(p_republic, false)
			end
		end
	end
end
function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_1_active then
			if not droids_dead then
				cis_list = Find_All_Objects_Of_Type(p_cis, "Infantry | AntiInfantry")
				if (table.getn(cis_list) == 0) then
					droids_dead = true
					Story_Event("PLAN_B_TRIGGER")
				end
				if TestValid(Find_First_Object("Luminara_Unduli")) and TestValid(Find_First_Object("B2_Droid")) then
					Find_First_Object("Luminara_Unduli").Move_To(Find_First_Object("B2_Droid"))
				end
				if TestValid(Find_First_Object("AHSOKA")) and TestValid(Find_First_Object("B2_Droid")) then
					Find_First_Object("AHSOKA").Move_To(Find_First_Object("B2_Droid"))
				end
			end
			if not argyus_dead then
				if not TestValid(player_argyus) then
					argyus_dead = true
				end
			end
		end
		if act_2_active then
			if not argyus_dead then
				if not TestValid(player_argyus) then
					argyus_dead = true
				end
			end
		end
		if act_3_active then
			if not argyus_dead then
				if not TestValid(player_argyus) then
					argyus_dead = true
				end
			end
		end
	end
end


function Start_Cinematic_Intro_CIS()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()
	Fade_On()

	player_argyus = Find_First_Object("FARO_ARGYUS")
	if not player_argyus then
		argyus_unit = Find_Object_Type("Faro_Argyus")
		argyus_list = Spawn_Unit(argyus_unit, argyus_marker, p_invaders)
		player_argyus = argyus_list[1]
		player_argyus.Teleport_And_Face(argyus_marker)
	end

	player_gunray = Find_First_Object("NUTE_GUNRAY")
	if not player_gunray then
		gunray_unit = Find_Object_Type("NUTE_GUNRAY")
		gunray_list = Spawn_Unit(gunray_unit, gunray_marker, p_invaders)
		player_gunray = gunray_list[1]
		player_gunray.Teleport_And_Face(gunray_marker)
	end

	cinematic_one = true

	MissionUtil.PlayGenericSpeech("Venator_Ventress_01")
	MissionUtil.PlayGenericMusic("Silence_Theme")

	MissionUtil.CinematicIntroHeader("VENATOR_VENTRESS")
	Sleep(3.0)

	Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 8, 0, senate_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 7, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 7, 0, 0, 8, 0, argyus_marker, 1, 0)
	Letter_Box_In(0.5)
	Fade_Screen_In(0.5)
	Sleep(2.0)

	if TestValid(player_argyus) then
		player_argyus.Play_Animation("Talk_Gesture", false)
	end

	Sleep(4.0)

	Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, shuttle_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_4_marker, 3, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_4_marker, 3, 0, 0, 0, 0, shuttle_marker, 1, 0)
	Sleep(3.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end
function End_Cinematic_Intro_CIS()
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(shuttle_marker, 3.5)
	Sleep(3.5)

	Story_Event("GOAL_TRIGGER_CIS_I")
	MissionUtil.AIActivation()

	p_republic.Make_Ally(p_invaders)
	p_invaders.Make_Ally(p_republic)

	SpawnList(B2_Team_List, shuttle_marker, p_cis, true, true)
	SpawnList(B2_Team_List, shuttle_marker, p_cis, true, true)
	SpawnList(B2_Team_List, shuttle_marker, p_cis, true, true)

	cinematic_one = false
	act_1_active = true
	reaction_trigger = true
end

function Start_Cinematic_Midtro_01_CIS()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()
	Fade_On()

	control_table = Find_All_Objects_Of_Type("GENERIC_CONTROL_PANEL")
	for i,controls in pairs(control_table) do
		controls.Make_Invulnerable(false)
	end

	act_1_active = false
	cinematic_two = true

	Set_Cinematic_Camera_Key(midtrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_1_marker, 0, 0, 8, 0, ventress_marker, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_2_marker, 4.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_2_marker, 4.0, 0, 0, 8, 0, player_ventress, 1, 0)

	player_ventress.Move_To(reactor_marker)

	Letter_Box_In(1.5)
	Fade_Screen_In(1.5)
	Sleep(5.0)

	local guard_party = SpawnList(clone_guard_list, arc_marker.Get_Position(), p_republic, false, true)

	Fade_Screen_Out(1.5)
	Sleep(2.0)

	if not cinematic_two_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_02_CIS")
	end
end
function Start_Cinematic_Midtro_02_CIS()
	Stop_All_Music()
	Fade_On()

	MissionUtil.PlayGenericSpeech("Venator_Ventress_02")
	MissionUtil.PlayGenericMusic("Silence_Theme")

	player_ventress.Teleport_And_Face(reactor_marker)

	Set_Cinematic_Camera_Key(midtrocam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_3_marker, 0, 0, 0, 0, player_argyus, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_4_marker, 13.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_4_marker, 13.0, 0, 0, 0, 0, player_argyus, 1, 0)

	cinematic_two = false
	act_2_active = false
	cinematic_three = true

	Letter_Box_In(1.5)
	Fade_Screen_In(1.5)
	Sleep(4.0)

	player_argyus.Turn_To_Face(senate_1_marker)
	player_argyus.Play_Animation("Talk", false, 0)
	Sleep(2.0)

	player_argyus.Change_Owner(p_cis)
	Sleep(6.0)

	player_argyus.Move_To(argyus_runto_gunray)

	Set_Cinematic_Camera_Key(midtrocam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_5_marker, 0, 0, 0, 0, player_gunray, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_6_marker, 13.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_6_marker, 13.0, 0, 0, 0, 0, player_gunray, 1, 0)
	Sleep(5.0)

	player_argyus.Play_Animation("Talk", false, 1)
	player_gunray.Change_Owner(p_cis)
	Sleep(3.0)

	player_argyus.Move_To(argyus_runto_gunray)
	player_gunray.Move_To(argyus_runto_gunray)

	if not cinematic_three_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Midtro_02_CIS")
	end
end
function End_Cinematic_Midtro_02_CIS()
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(player_argyus, 3.5)
	Sleep(3.5)

	Story_Event("GOAL_TRIGGER_CIS_III")

	Add_Radar_Blip(shuttle_marker, "hangar_blip")
	shuttle_marker.Highlight(true)

	gunray_rescued = true

	cinematic_three = false
	act_3_active = true

	Sleep(10.0)
	MissionUtil.CinematicEnvironmentOff()
end

function Start_Cinematic_Outro_CIS()
	act_3_active = false
	cinematic_four = true

	Fade_Screen_Out(0.5)
	Sleep(1.0)

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	MissionUtil.PlayGenericSpeech("Venator_Ventress_03")
	MissionUtil.PlayGenericMusic("Silence_Theme")

	player_argyus = Find_First_Object("FARO_ARGYUS")
	if not player_argyus then
		argyus_unit = Find_Object_Type("Faro_Argyus")
		argyus_list = Spawn_Unit(argyus_unit, argyus_marker, p_cis)
		player_argyus = argyus_list[1]
		player_argyus.Teleport_And_Face(argyus_marker)
	end

	player_gunray = Find_First_Object("NUTE_GUNRAY")
	if not player_gunray then
		gunray_unit = Find_Object_Type("NUTE_GUNRAY")
		gunray_list = Spawn_Unit(gunray_unit, gunray_marker, p_cis)
		player_gunray = gunray_list[1]
		player_gunray.Teleport_And_Face(gunray_marker)
	end

	player_ventress = Find_First_Object("VENTRESS")
	if not player_ventress then
		ventress_unit = Find_Object_Type("Ventress")
		ventress_list = Spawn_Unit(ventress_unit, ventress_marker, p_cis)
		player_ventress = ventress_list[1]
		player_ventress.Teleport_And_Face(ventress_marker)
	end

	player_ventress.In_End_Cinematic(true)
	player_argyus.In_End_Cinematic(true)
	player_gunray.In_End_Cinematic(true)

	Do_End_Cinematic_Cleanup()

	player_ventress.Teleport_And_Face(finale_ventress_spawn)
	player_argyus.Teleport_And_Face(finale_argyus_spawn)
	player_gunray.Teleport_And_Face(finale_gunray_spawn)

	player_ventress.Make_Invulnerable(true)
	player_argyus.Make_Invulnerable(true)
	player_gunray.Make_Invulnerable(true)

	Set_Cinematic_Camera_Key(outrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_1_marker, 0, 0, 5, 0, player_argyus, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_2_marker, 7.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_2_marker, 7.0, 0, 0, 5, 0, player_argyus, 1, 0)

	player_ventress.Move_To(finale_ventress_runto)
	player_argyus.Move_To(finale_argyus_runto)
	player_gunray.Move_To(finale_gunray_runto)

	Hide_Sub_Object(player_ventress, 1, "lightsaber");
	Hide_Sub_Object(player_ventress, 1, "lightsaber01");

	player_argyus.Change_Owner(p_invaders)

	player_gunray.Prevent_All_Fire(true)

	Fade_Screen_In(0.5)
	Sleep(8.5)

	Set_Cinematic_Camera_Key(outrocam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_3_marker, 0, 0, 5, 0, player_argyus, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_4_marker, 12.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_4_marker, 12.5, 0, 0, 5, 0, player_argyus, 1, 0)

	player_argyus.Turn_To_Face(player_ventress)
	player_argyus.Play_Animation("Talk", false, 2)
	Sleep(4.0)

	Sleep(0.5)
	player_ventress.Turn_To_Face(player_argyus)
	player_ventress.Play_Animation("FB_Release", false)	
	Sleep(2.0)

	player_argyus.Play_Animation("Talk", false, 0)
	Sleep(1.0)
	player_argyus.Turn_To_Face(shuttle_marker)
	Sleep(5.0)

	p_cis.Make_Enemy(p_invaders)
	p_invaders.Make_Enemy(p_cis)

	Set_Cinematic_Camera_Key(outrocam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_5_marker, 0, 0, 5, 0, player_ventress, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_6_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_6_marker, 10.0, 0, 0, 5, 0, player_ventress, 1, 0)
	Sleep(1.0)

	Hide_Sub_Object(player_ventress, 0, "lightsaber");
	Hide_Sub_Object(player_ventress, 0, "lightsaber01");
	Sleep(4.0)

	player_argyus.Take_Damage(100000)
	Hide_Sub_Object(player_ventress, 1, "lightsaber");
	Hide_Sub_Object(player_ventress, 1, "lightsaber01");
	Sleep(3.0)

	player_ventress.Turn_To_Face(player_gunray)
	Sleep(0.5)

	player_gunray.Turn_To_Face(player_ventress)
	Sleep(0.5)

	Set_Cinematic_Camera_Key(outrocam_7_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_7_marker, 0, 0, 5, 0, player_ventress, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_8_marker, 6.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_8_marker, 6.0, 0, 0, 5, 0, player_ventress, 1, 0)
	Sleep(1.0)

	Fade_Screen_Out(6.0)
	Sleep(7.0)

	GlobalValue.Set("Rimward_CIS_Venator_Ventress_Outcome", 0) -- 0 = CIS Victory; 1 = Republic Victory
	MissionUtil.CinematicEnvironmentOff()
	StoryUtil.DeclareVictory(p_republic, false)
end
