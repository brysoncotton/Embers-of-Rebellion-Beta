
--*****************************************************--
--******** Operation Durge's Lance: Duro Drama ********--
--*****************************************************--

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
		Trigger_Keggle_Captured = State_Keggle_Captured,
		Trigger_CIS_Forces_Killed = State_CIS_Forces_Killed,
		Trigger_Republic_Forces_Killed = State_Republic_Forces_Killed,
		Trigger_Grievous_Respawn = State_Grievous_Respawn,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")
	p_neutral = Find_Player("Neutral")

	current_cinematic_thread_id = nil

	act_1_active = false
	act_2_active = false

	cinematic_one = false
	cinematic_two = false
	cinematic_two_alt = false

	cinematic_one_skipped = false
	cinematic_two_skipped = false
	cinematic_two_alt_skipped = false

	mission_over = false
	keggle_captured = false
	cis_forces_killed = false
	republic_forces_killed = false

	initial_units_spawned = false

	num_reinforcements = 0
	allowed_reinforcements = 10
	reinforcement_delay = 90

	mission_started = false

end
function Begin_Battle(message)
	if message == OnEnter then
		outro_keggle_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-keggle")
		outro_grievous_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-grievous")
		outro_tactical_droid_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-tactical-droid")

		outro_squad_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-squad")

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam4")
		introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam5")
		introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam6")
		introcam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam7")
		introcam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam8")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget1")

		outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam1")
		outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam2")
		outrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam3")
		outrocam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam4")

		outrocam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocamtarget1")

		intro_keggle_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-keggle")

		attacker_marker = Find_First_Object("ATTACKER ENTRY POSITION")
		player_keggle = Find_First_Object("HOOLIDAN_KEGGLE")

		p_invaders.Make_Ally(p_cis)
		p_cis.Make_Ally(p_invaders)

		mission_started = true
		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
		end
	end
end


function State_Keggle_Captured(message)
	if message == OnEnter then
		keggle_captured = true
	end
end
function State_CIS_Forces_Killed(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Alt_CIS")
		elseif p_republic.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Alt_Rep")
		end
	end
end
function State_Republic_Forces_Killed(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
		elseif p_republic.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
		end
	end
end

function State_Grievous_Respawn(message)
	if message == OnEnter then
		GlobalValue.Set("ODL_CIS_Grievous_Respawn", 1)
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

					player_keggle = Find_First_Object("HOOLIDAN_KEGGLE")
					player_keggle.Prevent_AI_Usage(true)

					Story_Event("GOAL_TRIGGER_CIS_I")

					Add_Radar_Blip(player_keggle, "keggle_blip")
					player_keggle.Highlight(true)

					MissionUtil.Set_To_Enemies(p_cis, p_republic)

					MissionUtil.CinematicSkippingCleanUp(cis_shuttle_marker)
					MissionUtil.AIActivation()

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

					MissionUtil.CinematicEnvironmentOff()
					MissionUtil.DisableRetreat("REBEL", false)
					MissionUtil.DisableRetreat("EMPIRE", false)

					StoryUtil.DeclareVictory(p_cis, false)
				end
			end
			if cinematic_two_alt then
				if not cinematic_two_alt_skipped then
					cinematic_two_alt_skipped = true
	
					if current_cinematic_thread_id ~= nil then
						Thread.Kill(current_cinematic_thread_id)
						current_cinematic_thread_id = nil
					end

					MissionUtil.CinematicEnvironmentOff()
					MissionUtil.DisableRetreat("REBEL", false)
					MissionUtil.DisableRetreat("EMPIRE", false)

					StoryUtil.DeclareVictory(p_republic, false)
				end
			end
		end
	end
end
function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_1_active then
			rep_list = Find_All_Objects_Of_Type(p_republic, "Infantry, InfantryHero, VehicleHero, Vehicle, AirGunship, AirSpeeder")
			if (table.getn(rep_list) == 0) then
				republic_forces_killed = true
			end
			cis_list = Find_All_Objects_Of_Type(p_cis, "Infantry, InfantryHero, VehicleHero, Vehicle, AirGunship, AirSpeeder")
			if (table.getn(cis_list) == 0) then
				cis_forces_killed = true
			end
			if republic_forces_killed and keggle_captured then
				Story_Event("REPUBLIC_FORCES_KILLED")
			end
			if cis_forces_killed and not keggle_captured then
				Story_Event("CIS_FORCES_KILLED")
			end
		end
	elseif p_republic.Is_Human() then
		if act_1_active then
			rep_list = Find_All_Objects_Of_Type(p_republic, "Infantry, InfantryHero, VehicleHero, Vehicle, AirGunship, AirSpeeder")
			if (table.getn(rep_list) == 0) then
				republic_forces_killed = true
			end
			cis_list = Find_All_Objects_Of_Type(p_cis, "Infantry, InfantryHero, VehicleHero, Vehicle, AirGunship, AirSpeeder")
			if (table.getn(cis_list) == 0) then
				cis_forces_killed = true
			end
			if republic_forces_killed and keggle_captured then
				Story_Event("REPUBLIC_FORCES_KILLED")
			end
			if cis_forces_killed and not keggle_captured then
				Story_Event("CIS_FORCES_KILLED")
			end
		end
	end
end


function Start_Cinematic_Intro_CIS()
	MissionUtil.AddToReinforcementPool("GRIEVOUS_TEAM", p_cis, 1)

	cinematic_one = true

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	player_keggle.Teleport_And_Face(intro_keggle_marker)

	MissionUtil.PlayGenericMusic("TLJ_Trailer_Theme")
	Sleep(0.25)

	Fade_Screen_In(0.5)
	Letter_Box_In(0.5)

	MissionUtil.SetCinematicCamera(introcam_1_marker, player_keggle, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_2_marker, player_keggle, true, 12.5, nil, nil)
	Story_Event("LAST_STAND_01")
	Sleep(5.5)

	Story_Event("LAST_STAND_02")
	Sleep(7.0)

	MissionUtil.SetCinematicCamera(introcam_3_marker, player_keggle, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, player_keggle, true, 8.0, nil, nil)
	Story_Event("LAST_STAND_03")
	Sleep(8.0)

	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_1_marker, true, 5.0, nil, nil)
	Story_Event("LAST_STAND_04")
	Sleep(5.0)

	MissionUtil.SetCinematicCamera(introcam_7_marker, player_keggle, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_8_marker, player_keggle, true, 8.0, nil, nil)
	Story_Event("LAST_STAND_05")
	Sleep(6.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end
function End_Cinematic_Intro_CIS()
	MissionUtil.EndCinematicCamera(attacker_marker, 3.0)
	MissionUtil.CinematicEnvironmentOff()

	Story_Event("GOAL_TRIGGER_CIS_I")

	MissionUtil.AIActivation()

	current_cinematic_thread_id = nil

	cinematic_one = false
	act_1_active = true

	Add_Radar_Blip(player_keggle, "keggle_blip")
	player_keggle.Highlight(true)
	player_keggle.Prevent_AI_Usage(true)
end

function Start_Cinematic_Outro_CIS()
	act_1_active = false
	cinematic_two = true

	Fade_Screen_Out(0.5)
	Sleep(0.5)

	MissionUtil.CinematicEnvironmentOn()
	MissionUtil.StartCinematicCamera()
	Do_End_Cinematic_Cleanup()
	Sleep(0.5)

	republic_unit_list = Find_All_Objects_Of_Type(p_republic)
	for k,repunits in pairs(republic_unit_list) do
		if TestValid(repunits) then
			repunits.Despawn()
		end
	end

	MissionUtil.PlayGenericMusic("Grievous_Theme")

	keggle_unit = Find_Object_Type("HOOLIDAN_KEGGLE")
	keggle_list = Spawn_Unit(keggle_unit, outro_keggle_marker, p_invaders)
	player_keggle = keggle_list[1]
	player_keggle.Teleport_And_Face(outro_keggle_marker)
	player_keggle.Prevent_All_Fire(true)

	grievous_unit = Find_Object_Type("GENERAL_GRIEVOUS")
	grievous_list = Spawn_Unit(grievous_unit, outro_grievous_marker, p_cis)
	player_grievous = grievous_list[1]
	player_grievous.Set_Garrison_Spawn(false)
	player_grievous.Teleport_And_Face(outro_grievous_marker)

	tactical_droid_unit = Find_Object_Type("GENERAL_KALANI")
	tactical_droid_list = Spawn_Unit(tactical_droid_unit, outro_tactical_droid_marker, p_neutral)
	player_tactical_droid = tactical_droid_list[1]
	player_tactical_droid.Set_Garrison_Spawn(false)
	player_tactical_droid.Teleport_And_Face(outro_tactical_droid_marker)

	player_keggle.Turn_To_Face(player_grievous)
	player_grievous.Turn_To_Face(player_keggle)
	player_tactical_droid.Turn_To_Face(player_keggle)
	
	Hide_Sub_Object(player_grievous, 1, "Box01")
	Hide_Sub_Object(player_grievous, 1, "Box02")
	Hide_Sub_Object(player_grievous, 1, "Box03")
	Hide_Sub_Object(player_grievous, 1, "Box04")
	Hide_Sub_Object(player_grievous, 1, "Box05")
	Hide_Sub_Object(player_grievous, 1, "Box06")
	Hide_Sub_Object(player_grievous, 1, "Saber_BR")
	Hide_Sub_Object(player_grievous, 1, "Saber_BR01")
	Hide_Sub_Object(player_grievous, 1, "Saber_TR")
	Hide_Sub_Object(player_grievous, 1, "Saber_TR01")
	Hide_Sub_Object(player_grievous, 1, "Saberglow_BR")
	Hide_Sub_Object(player_grievous, 1, "Wooshglow_TR")

	MissionUtil.SetCinematicCamera(outrocam_1_marker, outrocam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outrocam_target_1_marker, true, 13.5, nil, nil)
	Sleep(0.1)

	player_grievous.Play_Animation("Talk", false, 1)

	Story_Event("LAST_STAND_06")
	Fade_Screen_In(0.5)
	Sleep(8.0)

	Story_Event("LAST_STAND_07")
	Sleep(7.0)

	MissionUtil.SetCinematicCamera(outrocam_2_marker, outrocam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_1_marker, outrocam_target_1_marker, true, 11.0, nil, nil)

	Story_Event("LAST_STAND_08")
	Sleep(4.0)

	player_grievous.Play_Animation("Talk", false, 2)
	Fade_Screen_Out(1.4)

	Story_Event("LAST_STAND_09")
	Sleep(1.2)

	player_keggle.Change_Owner(p_republic)
	player_keggle.Take_Damage(999999)

	Sleep(3.5)
	Fade_Screen_In(3.0)

	MissionUtil.SetCinematicCamera(outrocam_3_marker, outrocam_target_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_4_marker, outrocam_target_1_marker, true, 15.0, nil, nil)

	player_grievous.Turn_To_Face(player_tactical_droid)
	player_tactical_droid.Turn_To_Face(player_grievous)
	Sleep(0.1)

	Story_Event("LAST_STAND_10")
	player_grievous.Play_Animation("Talk", true, 1)
	Sleep(3.0)

	Story_Event("LAST_STAND_11")
	Sleep (3.0)


	Fade_Screen_Out(5.0)
	Sleep(5.0)

	StoryUtil.DeclareVictory(p_cis, false)
	MissionUtil.CinematicEnvironmentOff()
end
function Start_Cinematic_Outro_Alt_CIS()
	act_1_active = false
	cinematic_two_alt = true

	Fade_Screen_Out(0.5)
	Sleep(0.5)

	Story_Event("DISABLE_KEGGLE_DEATH")
	MissionUtil.PlayGenericMusic("Grievous_Theme_Alt_01")
	Story_Event("LAST_STAND_10")
	Sleep(6.5)

	StoryUtil.DeclareVictory(p_republic, false)
	MissionUtil.CinematicEnvironmentOff()
end

