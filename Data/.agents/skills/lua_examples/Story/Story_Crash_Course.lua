
--*****************************************************--
--******** Tennuutta Skirmishes: Crash Course *********--
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
		Battle_Start = Begin_Battle
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_hostile = Find_Player("Sector_Forces")
	p_neutral = Find_Player("Neutral")

	act_1_active = false

	cinematic_one = false
	cinematic_two = false

	cinematic_one_skipped = false
	cinematic_two_skipped = false

	anakin_hangar_reached = false
	ahsoka_hangar_reached = false
	aayla_hangar_reached = false
	rex_hangar_reached = false
	bly_hangar_reached = false

	mission_started = false
end
function Begin_Battle(message)
	if message == OnEnter then
		MissionUtil.VictoryAllowance(false)

		p_republic.Make_Ally(p_hostile)
		p_hostile.Make_Ally(p_republic)

		MissionUtil.DisableRetreat("REBEL", true)
		MissionUtil.DisableRetreat("EMPIRE", true)

		p_cis.Disable_Orbital_Bombardment(true)
		p_republic.Disable_Orbital_Bombardment(true)

		p_republic.Disable_Bombing_Run(false)
		p_cis.Disable_Bombing_Run(false)

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-4")

		intro_1_anakin_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-anakin")
		intro_2_anakin_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-anakin")

		intro_1_ahsoka_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-ahsoka")
		intro_2_ahsoka_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-ahsoka")

		intro_1_rex_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-rex")
		intro_2_rex_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-rex")

		prop_corvette = Find_Hint("TR_SHIP_CHARGER_C70", "corvette")
		prop_hangar_part_1 = Find_Hint("PROP_URBAN_TUNNEL_C", "hangar-bridge")
		prop_hangar_part_2 = Find_Hint("PROP_CIS_DOOR_LARGE", "hangar-door")
		prop_hangar_part_3 = Find_Hint("PROP_URBAN_TUNNEL_A", "hangar-gate")

		hangar_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "hangar")

		prop_corvette.Hide(true)
		prop_hangar_part_1.Hide(true)
		prop_hangar_part_2.Hide(true)
		prop_hangar_part_3.Hide(true)

		player_anakin = Find_First_Object("ANAKIN")
		Register_Death_Event(player_anakin, State_Hero_Death)

		player_ahsoka = Find_First_Object("AHSOKA")
		Register_Death_Event(player_ahsoka, State_Hero_Death)

		if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
			Find_First_Object("REX").Despawn()

			player_rex = Find_First_Object("REX2")
			Register_Death_Event(player_rex, State_Hero_Death)
		else
			Find_First_Object("REX2").Despawn()

			player_rex = Find_First_Object("REX")
			Register_Death_Event(player_rex, State_Hero_Death)
		end

		player_aayla = Find_First_Object("AAYLA_SECURA")
		Register_Prox(player_aayla, Prox_Aayla_Saved, 100, p_republic)
		Register_Death_Event(player_aayla, State_Hero_Death)
		Add_Radar_Blip(player_aayla, "aayla_blip")

		if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
			Find_First_Object("BLY").Despawn()

			player_bly = Find_First_Object("BLY2")
			Register_Death_Event(player_bly, State_Hero_Death)
		else
			Find_First_Object("BLY2").Despawn()

			player_bly = Find_First_Object("BLY")
			Register_Death_Event(player_bly, State_Hero_Death)
		end
		Register_Prox(player_bly, Prox_Bly_Saved, 100, p_republic)

		local unit_list = Find_All_Objects_Of_Type("CLONETROOPER_PHASE_ONE_SQUAD")
		for k, unit in pairs(unit_list) do
			if TestValid(unit) then
				Register_Prox(unit, Prox_Clone_Company_Finder, 75, p_republic)
			end
		end

		local unit_list = Find_All_Objects_Of_Type("CLONETROOPER_PHASE_ONE_ASSAULT_SQUAD")
		for k, unit in pairs(unit_list) do
			if TestValid(unit) then
				Register_Prox(unit, Prox_Clone_Company_Finder, 75, p_republic)
			end
		end

		local unit_list = Find_All_Objects_Of_Type("CLONE_SPECIAL_OPS_SQUAD")
		for k, unit in pairs(unit_list) do
			if TestValid(unit) then
				Register_Prox(unit, Prox_Clone_Company_Finder, 75, p_republic)
			end
		end

		if p_republic.Is_Human() then
			mission_started = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
		end
	end
end


function State_Hero_Death()
	if not TestValid(player_anakin) then
		MissionUtil.SetMissionObjectiveFailed("CRASH_COURSE", "REP", 2)
		--StoryUtil.TriggerScriptedBattle("CRASH_COURSE", "QUELL", "LAND", "EMPIRE", "REBEL", false)
		Do_End_Cinematic_Cleanup()
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
	end
	if not TestValid(player_ahsoka) then
		MissionUtil.SetMissionObjectiveFailed("CRASH_COURSE", "REP", 3)
		--StoryUtil.TriggerScriptedBattle("CRASH_COURSE", "QUELL", "LAND", "EMPIRE", "REBEL", false)
		Do_End_Cinematic_Cleanup()
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
	end
	if not TestValid(player_rex) then
		MissionUtil.SetMissionObjectiveFailed("CRASH_COURSE", "REP", 4)
		--StoryUtil.TriggerScriptedBattle("CRASH_COURSE", "QUELL", "LAND", "EMPIRE", "REBEL", false)
		Do_End_Cinematic_Cleanup()
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
	end
	if not TestValid(player_aayla) then
		MissionUtil.SetMissionObjectiveFailed("CRASH_COURSE", "REP", 5)
		--StoryUtil.TriggerScriptedBattle("CRASH_COURSE", "QUELL", "LAND", "EMPIRE", "REBEL", false)
		Do_End_Cinematic_Cleanup()
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
	end
	if not TestValid(player_bly) then
		MissionUtil.SetMissionObjectiveFailed("CRASH_COURSE", "REP", 6)
		--StoryUtil.TriggerScriptedBattle("CRASH_COURSE", "QUELL", "LAND", "EMPIRE", "REBEL", false)
		Do_End_Cinematic_Cleanup()
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
	end
end

function Prox_Aayla_Saved(self_obj, trigger_obj)
	self_obj.Cancel_Event_Object_In_Range(Prox_Aayla_Saved)
	StoryUtil.Multimedia("TEXT_MISSION_CRASH_COURSE_SPEECH_05", 6, nil, nil, 0)
	player_aayla.Change_Owner(p_republic)
	player_aayla.Set_Selectable(true)
	p_republic.Select_Object(player_aayla)
	Remove_Radar_Blip("aayla_blip")

	Add_Radar_Blip(hangar_marker, "hangar_marker_blip")
	hangar_marker.Highlight(true)

	StoryUtil.Multimedia("TEXT_MISSION_CRASH_COURSE_SPEECH_06", 10, nil, nil, 0)
	Register_Prox(hangar_marker, Prox_Hangar_Reached, 400, p_republic)

	MissionUtil.SetMissionObjectiveUpdate("CRASH_COURSE", "REP", 1, 7)
	MissionUtil.SetMissionObjectiveNew("CRASH_COURSE", "REP", 5)
	MissionUtil.SetMissionObjectiveNew("CRASH_COURSE", "REP", 6)

	prop_corvette.Hide(false)
	prop_hangar_part_1.Hide(false)
	prop_hangar_part_2.Hide(false)
	prop_hangar_part_3.Hide(false)

	local marker_list = Find_All_Objects_With_Hint("b1-phase-2")
	for k, marker in pairs(marker_list) do
		if TestValid(marker) then
			MissionUtil.SpawnListSpawner("B1_DROID_SQUAD", marker, p_cis, 1)
		end
	end

end
function Prox_Bly_Saved(self_obj, trigger_obj)
	self_obj.Cancel_Event_Object_In_Range(Prox_Bly_Saved)
	player_bly.Change_Owner(p_republic)
	player_bly.Set_Selectable(true)
	p_republic.Select_Object(player_bly)
end
function Prox_Hangar_Reached(self_obj, trigger_obj)
	if trigger_obj == player_anakin then
		anakin_hangar_reached = true
	end
	if trigger_obj == player_ahsoka then
		ahsoka_hangar_reached = true
	end
	if trigger_obj == player_aayla then
		aayla_hangar_reached = true
	end
	if trigger_obj == player_rex then
		rex_hangar_reached = true
	end
	if trigger_obj == player_bly then
		bly_hangar_reached = true
	end

	if anakin_hangar_reached and ahsoka_hangar_reached and aayla_hangar_reached and rex_hangar_reached and bly_hangar_reached then
		self_obj.Cancel_Event_Object_In_Range(Prox_Hangar_Reached)

		Do_End_Cinematic_Cleanup()

		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
	end
end


function Prox_Clone_Company_Finder(self_obj, trigger_obj)
	if trigger_obj == player_anakin or trigger_obj == player_ahsoka or trigger_obj == player_rex then
		self_obj.Change_Owner(p_republic)
		self_obj.Set_Selectable(true)
		p_republic.Select_Object(self_obj)
	end
end


function Story_Handle_Esc()
	if p_republic.Is_Human() then
		if cinematic_one then
			if not cinematic_one_skipped then
				cinematic_one_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				MissionUtil.CinematicSkippingCleanUp(player_anakin)

				MissionUtil.SetObjectiveMissionSet("CRASH_COURSE", "REP", 4)

					--StoryUtil.DeclareVictory(p_republic, false)

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

				MissionUtil.DisableRetreat("REBEL", false)
				MissionUtil.DisableRetreat("EMPIRE", false)

				p_cis.Disable_Orbital_Bombardment(false)
				p_republic.Disable_Orbital_Bombardment(false)

				p_republic.Disable_Bombing_Run(true)
				p_cis.Disable_Bombing_Run(true)

				MissionUtil.CinematicSkippingCleanUp(hangar_marker)

				MissionUtil.CinematicEnvironmentOff()
				StoryUtil.DeclareVictory(p_republic, false)
			end
		end
	end
end
function Story_Mode_Service()
	if p_republic.Is_Human() then
		if act_1_active then
		end
	end
end


function Start_Cinematic_Intro_Rep()
	cinematic_one = true

	player_anakin.Teleport_And_Face(intro_1_anakin_marker)
	player_ahsoka.Teleport_And_Face(intro_1_ahsoka_marker)
	player_rex.Teleport_And_Face(intro_1_rex_marker)

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	MissionUtil.PlayGenericSpeech("Alarm_Sound")
	Sleep(1.0)

	StoryUtil.Multimedia("TEXT_MISSION_CRASH_COURSE_SPEECH_01", 5.0, nil, nil, 0)
	MissionUtil.PlayGenericMusic("Christophsis_Clash_Theme")
	Sleep(2.0)

	Stop_All_Speech()
	MissionUtil.SetCinematicCamera(introcam_1_marker, player_anakin, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, player_anakin, true, 10.0, nil, nil)

	Fade_Screen_In(2.0)
	Letter_Box_In(1.0)
	Sleep(3.5)

	player_anakin.Move_To(intro_2_anakin_marker)
	player_ahsoka.Move_To(intro_2_ahsoka_marker)
	player_rex.Move_To(intro_2_rex_marker)

	StoryUtil.Multimedia("TEXT_MISSION_CRASH_COURSE_SPEECH_02", 8.0, nil, nil, 0)
	StoryUtil.Multimedia("TEXT_MISSION_CRASH_COURSE_SPEECH_03", 8.0, nil, nil, 0)
	Sleep(6.5)

	MissionUtil.SetCinematicCamera(introcam_3_marker, player_anakin, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, player_anakin, true, 7.0, nil, nil)
	Sleep(4.5)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Rep")
	end
end
function End_Cinematic_Intro_Rep()
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(player_anakin, 2.0)
	Sleep(2.0)

	p_republic.Make_Enemy(p_cis)
	p_cis.Make_Enemy(p_republic)

	MissionUtil.SetObjectiveMissionSet("CRASH_COURSE", "REP", 4)
	MissionUtil.CinematicEnvironmentOff()
	Stop_All_Speech()

	current_cinematic_thread_id = nil

	cinematic_one = false
	act_1_active = true
end

function Start_Cinematic_Outro_Rep()
	act_1_active = false
	cinematic_two = true

	p_republic.Make_Enemy(p_hostile)
	p_hostile.Make_Enemy(p_republic)

	MissionUtil.CinematicEnvironmentOn()
	MissionUtil.StartCinematicCamera()
	Fade_Screen_Out(0.5)

	MissionUtil.PlayGenericSpeech("Crash_Course_01")
	MissionUtil.PlayGenericMusic("Silence_Theme")
	Sleep(24.0)

	p_cis.Disable_Orbital_Bombardment(false)
	p_republic.Disable_Orbital_Bombardment(false)

	p_republic.Disable_Bombing_Run(true)
	p_cis.Disable_Bombing_Run(true)

	MissionUtil.DisableRetreat("REBEL", false)
	MissionUtil.DisableRetreat("EMPIRE", false)

	MissionUtil.CinematicEnvironmentOff()
	StoryUtil.DeclareVictory(p_republic, false)
end
