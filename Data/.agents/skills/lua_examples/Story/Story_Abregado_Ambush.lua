
--*****************************************************--
--***** Hunt for the Malevolence: Abregado Ambush *****--
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
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")
	p_neutral = Find_Player("Hostile")

	mission_started = false

	player_plo = nil
	venator_1 = nil
	venator_2 = nil

	act_1_active = false
	act_2_active = false
	act_3_active = false

	cinematic_crawl = false
	cinematic_one = false
	cinematic_two = false
	cinematic_three = false
	cinematic_four = false

	cinematic_crawl_skipped = false
	cinematic_one_skipped = false
	cinematic_two_skipped = false
	cinematic_three_skipped = false
	cinematic_four_skipped = false

	current_cinematic_thread_id = nil

	pods_rescued = 0
	pods_killed = 0

	pod_plo_spawned = false
	pod_plo_rescued = false

	pod_1_killed = false
	pod_2_killed = false
	pod_3_killed = false
	pod_4_killed = false
	pod_5_killed = false
	pod_plo_killed = false

	last_scene = false
end
function Begin_Battle(message)
	if message == OnEnter then
		MissionUtil.VictoryAllowance(false)

		MissionUtil.DisableRetreat("REBEL", true)
		MissionUtil.DisableRetreat("EMPIRE", true)

		MissionUtil.Set_To_Allies(p_republic, p_neutral)

		GlobalValue.Set("HfM_Plo_Rescued", 0)
		GlobalValue.Set("Saved_Escape_Pods_Counter", 0)


		intro_malevolence_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intromalevolence")

		venator_plo_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "venatorplo")
		venator_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "venator1")
		venator_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "venator2")

		player_plo = Find_Hint("VENATOR_STAR_DESTROYER", "venatorplo")
		venator_1 = Find_Hint("VENATOR_STAR_DESTROYER", "venator1")
		venator_2 = Find_Hint("VENATOR_STAR_DESTROYER", "venator2")

		player_plo_intro = Find_Hint("SKIRMISH_VENATOR_STAR_DESTROYER", "venatorplointro")
		venator_1_intro = Find_Hint("SKIRMISH_VENATOR_STAR_DESTROYER", "venator1intro")
		venator_2_intro = Find_Hint("SKIRMISH_VENATOR_STAR_DESTROYER", "venator2intro")

		player_intro_malevolence = Find_Hint("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN", "malevolence")

		twilight_move_to = Find_Hint("STORY_TRIGGER_ZONE_00", "twilightmoveto")
		venator_plo_move_to = Find_Hint("STORY_TRIGGER_ZONE_00", "venatorplomoveto")
		venator_1_move_to = Find_Hint("STORY_TRIGGER_ZONE_00", "venator1moveto")
		venator_2_move_to = Find_Hint("STORY_TRIGGER_ZONE_00", "venator2moveto")
		malevolence_move_to = Find_Hint("STORY_TRIGGER_ZONE_00", "malevolencemoveto")

		introcam_target_malevolence_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtargetmalevolence")
		introcam_target_venator_plo_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtargetvenatorplo")
		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget1")

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam4")
		introcam_4a_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam4a")
		introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam5")
		introcam_5a_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam5a")
		introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam6")
		introcam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam7")
		introcam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam8")

		twilight_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "twilight")
		midtro_1_malevolence_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtromalevolence1")
		midtro_2_malevolence_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtromalevolence2")
		midtrocam_target_malevolence_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocamtargetmalevolence")

		midtrocam_target_twilight_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocamtargettwilight")

		midtrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam1")
		midtrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam2")
		midtrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam3")
		midtrocam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam4")
		midtrocam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam5")
		midtrocam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam6")

		pod_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "pod1")
		pod_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "pod2")
		pod_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "pod3")
		pod_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "pod4")
		pod_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "pod5")
		pod_plo_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "podplo")

		hunter_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "hunter1")
		hunter_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "hunter2")
		hunter_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "hunter3")

		droch_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "droch")
		drochcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "drochcam1")
		drochcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "drochcam2")
		drochcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "drochcam3")
		drochcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "drochcam4")

		droch_twilight_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "drochtwilight")
		droch_twilight_move_to_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "drochtwilightmoveto")

		escape_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "escape")
		outro_twilight_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrotwilight")
		outro_malevolence_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outromalevolence")

		outrocam_target_malevolence_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocamtargetmalevolence")

		outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam1")
		outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam2")
		outrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam4")

		p_republic.Make_Ally(p_cis)
		p_cis.Make_Ally(p_republic)

		plo_hide_table = Find_All_Objects_Of_Type("VENATOR_STAR_DESTROYER")
		for y,plohiding in pairs(plo_hide_table) do
			if TestValid(plohiding) then
				Hide_Object(plohiding, 1)
			end	
		end

		junk_list_01 = Find_All_Objects_Of_Type("SPACE_JUNK_LARGE")
		for h,junks1 in pairs(junk_list_01) do
			if TestValid(junks1) then
				Hide_Object(junks1, 1)
			end	
		end

		junk_list_02 = Find_All_Objects_Of_Type("SPACE_JUNK_HUGE")
		for i,junks2 in pairs(junk_list_02) do
			if TestValid(junks2) then
				Hide_Object(junks2, 1)
			end	
		end

		if p_cis.Is_Human() then
			mission_started = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Crawl_CIS")
		elseif p_republic.Is_Human() then
			mission_started = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Crawl_Rep")
		end
	end
end

function State_Proximity_Escape_Marker(prox_obj, trigger_obj)
	if p_cis.Is_Human() then
		if trigger_obj == Find_First_Object("Twilight_Mission") then
			prox_obj.Cancel_Event_Object_In_Range(State_Proximity_Escape_Marker)

			if TestValid(Find_First_Object("Twilight_Mission")) then
				Find_First_Object("Twilight_Mission").Unlock_Current_Orders()
			end
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
		end
	elseif p_republic.Is_Human() then
		if trigger_obj == Find_First_Object("Twilight_Mission") then
			prox_obj.Cancel_Event_Object_In_Range(State_Proximity_Escape_Marker)

			if TestValid(Find_First_Object("Twilight_Mission")) then
				Find_First_Object("Twilight_Mission").Unlock_Current_Orders()
			end
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
		end
	end
end

function State_Proximity_Pod_1(prox_obj, trigger_obj)
	if trigger_obj == Find_First_Object("Twilight_Mission") then
		prox_obj.Cancel_Event_Object_In_Range(State_Proximity_Pod_1)
		Create_Thread("Handle_Pods_Rescue_Thread", prox_obj)
	elseif trigger_obj.Get_Owner() == p_cis then
		prox_obj.Cancel_Event_Object_In_Range(State_Proximity_Pod_1)
		pod_1_killed = true
		Create_Thread("Handle_Pods_Destruction_Thread", prox_obj)
	end
end
function State_Proximity_Pod_2(prox_obj, trigger_obj)
	if trigger_obj == Find_First_Object("Twilight_Mission") then
		prox_obj.Cancel_Event_Object_In_Range(State_Proximity_Pod_2)
		Create_Thread("Handle_Pods_Rescue_Thread", prox_obj)
	elseif trigger_obj.Get_Owner() == p_cis then
		prox_obj.Cancel_Event_Object_In_Range(State_Proximity_Pod_2)
		pod_2_killed = true
		Create_Thread("Handle_Pods_Destruction_Thread", prox_obj)
	end
end
function State_Proximity_Pod_3(prox_obj, trigger_obj)
	if trigger_obj == Find_First_Object("Twilight_Mission") then
		prox_obj.Cancel_Event_Object_In_Range(State_Proximity_Pod_3)
		Create_Thread("Handle_Pods_Rescue_Thread", prox_obj)
	elseif trigger_obj.Get_Owner() == p_cis then
		prox_obj.Cancel_Event_Object_In_Range(State_Proximity_Pod_3)
		pod_3_killed = true
		Create_Thread("Handle_Pods_Destruction_Thread", prox_obj)
	end
end
function State_Proximity_Pod_4(prox_obj, trigger_obj)
	if trigger_obj == Find_First_Object("Twilight_Mission") then
		prox_obj.Cancel_Event_Object_In_Range(State_Proximity_Pod_4)
		Create_Thread("Handle_Pods_Rescue_Thread", prox_obj)
	elseif trigger_obj.Get_Owner() == p_cis then
		prox_obj.Cancel_Event_Object_In_Range(State_Proximity_Pod_4)
		pod_4_killed = true
		Create_Thread("Handle_Pods_Destruction_Thread", prox_obj)
	end
end
function State_Proximity_Pod_5(prox_obj, trigger_obj)
	if trigger_obj == Find_First_Object("Twilight_Mission") then
		prox_obj.Cancel_Event_Object_In_Range(State_Proximity_Pod_5)
		Create_Thread("Handle_Pods_Rescue_Thread", prox_obj)
	elseif trigger_obj.Get_Owner() == p_cis then
		prox_obj.Cancel_Event_Object_In_Range(State_Proximity_Pod_5)
		pod_5_killed = true
		Create_Thread("Handle_Pods_Destruction_Thread", prox_obj)
	end
end

function Handle_Pods_Rescue_Thread(pod_obj)
	pods_rescued = pods_rescued + 1	

	if pods_rescued == 1 then
		GlobalValue.Set("Saved_Escape_Pods_Counter", 2)
	elseif pods_rescued == 2 then
		GlobalValue.Set("Saved_Escape_Pods_Counter", 4)
	elseif pods_rescued == 3 then
		GlobalValue.Set("Saved_Escape_Pods_Counter", 6)
		if not pod_plo_rescued and not cinematic_three then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_02_Rep")
		end
	elseif pods_rescued == 4 then
		GlobalValue.Set("Saved_Escape_Pods_Counter", 8)
	elseif pods_rescued == 5 then
		GlobalValue.Set("Saved_Escape_Pods_Counter", 10)
	end

	pod_obj.Highlight(false)
	pod_obj.Make_Invulnerable(true)
	pod_obj.Prevent_All_Fire(true)

	pod_obj.Attach_Particle_Effect("Rescue_Effect")
	Sleep(1.0)

	pod_obj.Despawn()
end
function Handle_Pods_Destruction_Thread(pod_obj)
	pods_killed = pods_killed + 1	

	if pods_killed == 1 then
		MissionUtil.SetObjectiveUpdate("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_CIS_03_1", "TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_CIS_03_2")
	elseif pods_killed == 2 then
		MissionUtil.SetObjectiveUpdate("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_CIS_03_2", "TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_CIS_03_3")
	elseif pods_killed == 3 then
		MissionUtil.SetObjectiveUpdate("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_CIS_03_3", "TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_CIS_03_4")
	elseif pods_killed == 4 then
		MissionUtil.SetObjectiveUpdate("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_CIS_03_4", "TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_CIS_03_5")
	elseif pods_killed == 5 then
		MissionUtil.SetObjectiveUpdate("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_CIS_03_5", "TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_CIS_03_6")
	end

	pod_obj.Highlight(false)
	pod_obj.Make_Invulnerable(true)
	pod_obj.Prevent_All_Fire(true)

	pod_obj.Attach_Particle_Effect("Small_Explosion_Space")
	Sleep(1)

	pod_obj.Despawn()
	local pod_list = Find_All_Objects_Of_Type("Republic_Escape_Pod_Big")
	if (table.getn(pod_list) <= 1) then
		if act_2_active then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_02_CIS")
		end
	end
end


function Story_Handle_Esc()
	if p_cis.Is_Human() then
		if cinematic_crawl then
			if not cinematic_crawl_skipped then
				cinematic_crawl_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				Stop_All_Music()
				Stop_All_Speech()
				Remove_All_Text()
				Stop_Bink_Movie()

				cinematic_crawl = false
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
			end
		end
		if cinematic_one then
			if not cinematic_one_skipped then
				cinematic_one_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				if TestValid(player_plo_intro) then
					player_plo_intro.Despawn()
				end
				if TestValid(venator_1_intro) then
					venator_1_intro.Despawn()
				end
				if TestValid(venator_2_intro) then
					venator_2_intro.Despawn()
				end
				if not TestValid(player_plo) then
					p_republic = Find_Player("Empire")
					player_plo = MissionUtil.SpawnUnitSpace("Venator_Star_Destroyer", venator_plo_move_to, p_republic, 1)
				else
					player_plo.Despawn()
					player_plo = MissionUtil.SpawnUnitSpace("Venator_Star_Destroyer", venator_plo_move_to, p_republic, 1)
				end
				if not TestValid(venator_1) then
					p_republic = Find_Player("Empire")
					venator_1 = MissionUtil.SpawnUnitSpace("Venator_Star_Destroyer", venator_1_move_to, p_republic, nil)
				else
					venator_1.Despawn()
					venator_1 = MissionUtil.SpawnUnitSpace("Venator_Star_Destroyer", venator_1_move_to, p_republic, 1)
				end
				if not TestValid(venator_2) then
					p_republic = Find_Player("Empire")
					venator_2 = MissionUtil.SpawnUnitSpace("Venator_Star_Destroyer", venator_2_move_to, p_republic, nil)
				else
					venator_2.Despawn()
					venator_2 = MissionUtil.SpawnUnitSpace("Venator_Star_Destroyer", venator_2_move_to, p_republic, 1)
				end
				if not TestValid(player_intro_malevolence) then
					p_cis = Find_Player("Rebel")
					player_intro_malevolence = MissionUtil.SpawnUnitSpace("Grievous_Malevolence_Hunt_Campaign", intro_malevolence_marker, p_cis, nil)
				end

				rep_fighters = Find_All_Objects_Of_Type(p_republic, "Fighter | Bomber")
				for _,repfighters in pairs(rep_fighters) do
					if TestValid(repfighters) then
						repfighters.Despawn()
					end
				end

				MissionUtil.CinematicSkippingCleanUp(venator_plo_move_to)

				MissionUtil.AIActivation()
				MissionUtil.SetObjectiveNew("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_CIS_01")
				MissionUtil.SetObjectiveNew("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_CIS_02")

				p_republic.Make_Enemy(p_cis)
				p_cis.Make_Enemy(p_republic)

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

				junk_list_05 = Find_All_Objects_Of_Type("SPACE_JUNK_LARGE")
				for x,junks5 in pairs(junk_list_05) do
					if TestValid(junks5) then
						Hide_Object(junks5, 0)
					end
				end

				junk_list_06 = Find_All_Objects_Of_Type("SPACE_JUNK_HUGE")
				for s,junks6 in pairs(junk_list_06) do
					if TestValid(junks6) then
						Hide_Object(junks6, 0)
					end
				end

				republic_unit_list_skip = Find_All_Objects_Of_Type(p_republic)
				for g,repunitsskip in pairs(republic_unit_list_skip) do
					if TestValid(repunitsskip) then
						repunitsskip.Despawn()
					end
				end

				cis_unit_list_skip = Find_All_Objects_Of_Type(p_cis)
				for u,skippies in pairs(cis_unit_list_skip) do
					if TestValid(skippies) then
						skippies.Despawn()
					end
				end

				if not TestValid(pod_1) then
					pod_1 = MissionUtil.SpawnUnitSpace("Republic_Escape_Pod_Big", pod_1_marker, p_neutral, nil)
					pod_1.Highlight(true)
					Add_Radar_Blip(pod_1, "pod_1_blip")
					Register_Prox(pod_1, State_Proximity_Pod_1, 300)
				end
				if not TestValid(pod_2) then
					pod_2 = MissionUtil.SpawnUnitSpace("Republic_Escape_Pod_Big", pod_2_marker, p_neutral, nil)
					pod_2.Highlight(true)
					Add_Radar_Blip(pod_2, "pod_2_blip")
					Register_Prox(pod_2, State_Proximity_Pod_2, 300)
				end
				if not TestValid(pod_3) then
					pod_3 = MissionUtil.SpawnUnitSpace("Republic_Escape_Pod_Big", pod_3_marker, p_neutral, nil)
					pod_3.Highlight(true)
					Add_Radar_Blip(pod_3, "pod_3_blip")
					Register_Prox(pod_3, State_Proximity_Pod_3, 300)
				end
				if not TestValid(pod_4) then
					pod_4 = MissionUtil.SpawnUnitSpace("Republic_Escape_Pod_Big", pod_4_marker, p_neutral, nil)
					pod_4.Highlight(true)
					Add_Radar_Blip(pod_4, "pod_4_blip")
					Register_Prox(pod_4, State_Proximity_Pod_4, 300)
				end
				if not TestValid(pod_5) then
					pod_5 = MissionUtil.SpawnUnitSpace("Republic_Escape_Pod_Big", pod_5_marker, p_neutral, nil)
					pod_5.Highlight(true)
					Add_Radar_Blip(pod_5, "pod_5_blip")
					Register_Prox(pod_5, State_Proximity_Pod_5, 300)
				end


				if not TestValid(player_hunter_11) then
					player_hunter_11 = MissionUtil.SpawnUnitSpace("Droch_Boarding_Ship_Squadron", hunter_1_marker, p_cis, nil)
					player_hunter_11.Override_Max_Speed(5)
				end
				if not TestValid(player_hunter_12) then
					player_hunter_12 = MissionUtil.SpawnUnitSpace("Droch_Boarding_Ship_Squadron", hunter_1_marker, p_cis, nil)
					player_hunter_12.Override_Max_Speed(5)
				end
				if not TestValid(player_hunter_13) then
					player_hunter_13 = MissionUtil.SpawnUnitSpace("Droch_Boarding_Ship_Squadron", hunter_1_marker, p_cis, nil)
					player_hunter_13.Override_Max_Speed(5)
				end
				if not TestValid(player_hunter_14) then
					player_hunter_14 = MissionUtil.SpawnUnitSpace("Droch_Boarding_Ship_Squadron", hunter_1_marker, p_cis, nil)
					player_hunter_14.Override_Max_Speed(5)
				end
				if not TestValid(player_hunter_2) then
					player_hunter_2 = MissionUtil.SpawnUnitSpace("Droch_Boarding_Ship_Squadron", hunter_1_marker, p_cis, nil)
					player_hunter_2.Override_Max_Speed(5)
				end
				if not TestValid(player_hunter_3) then
					player_hunter_3 = MissionUtil.SpawnUnitSpace("Droch_Boarding_Ship_Squadron", hunter_1_marker, p_cis, nil)
					player_hunter_3.Override_Max_Speed(5)
				end

				MissionUtil.CinematicSkippingCleanUp(hunter_1_marker)

				MissionUtil.SetObjectiveComplete("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_CIS_01")
				MissionUtil.SetObjectiveComplete("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_CIS_02")

				MissionUtil.SetObjectiveNew("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_CIS_03_1")

				Fade_Screen_In(0.5)

				cinematic_two = false
				act_1_active = false
				act_2_active = true
			end
		end
		if cinematic_three then
			if not cinematic_three_skipped then
				cinematic_three_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				Add_Radar_Blip(escape_marker, "escape_blip")
				escape_marker.Highlight(true)

				if not TestValid(player_midtro_malevolence) then
					player_midtro_malevolence = MissionUtil.SpawnUnitSpace("Grievous_Malevolence_Hunt_Campaign_Mission", midtro_2_malevolence_marker, p_cis, 1)
				end

				escape_pods = Find_All_Objects_Of_Type("Republic_Escape_Pod_Big")
				for s,escape_pod in pairs(escape_pods) do
					if TestValid(escape_pod) then
						escape_pod.Despawn()
					end
				end

				MissionUtil.CinematicSkippingCleanUp(outro_twilight_marker)

				MissionUtil.SetObjectiveComplete("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_CIS_03_6")
				MissionUtil.SetObjectiveNew("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_CIS_04")

				player_twilight.Despawn()
				player_twilight = MissionUtil.SpawnUnitSpace("Twilight_Mission", outro_twilight_marker, p_republic, nil)

				pod_plo_rescued = true
				cinematic_three = false
				act_2_active = false
				act_3_active = true

				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
			end
		end
		if cinematic_four then
			if not cinematic_four_skipped then
				cinematic_four_skipped = true

				act_3_active = false

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				GlobalValue.Set("HfM_Plo_Rescued", 1)

				MissionUtil.CinematicEnvironmentOff()

				--crossplot:tactical()
				--crossplot:publish("CREW_GAIN", pods_rescued)
				--crossplot:update()

				MissionUtil.VictoryAllowance(true)

				MissionUtil.DisableRetreat("REBEL", false)
				MissionUtil.DisableRetreat("EMPIRE", false)

				StoryUtil.DeclareVictory(p_cis, false)
			end
		end
	end
	if p_republic.Is_Human() then
		if cinematic_crawl then
			if not cinematic_crawl_skipped then
				cinematic_crawl_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				Stop_All_Music()
				Stop_All_Speech()
				Remove_All_Text()
				Stop_Bink_Movie()

				cinematic_crawl = false
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
			end
		end
		if cinematic_one then
			if not cinematic_one_skipped then
				cinematic_one_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				if TestValid(player_plo_intro) then
					player_plo_intro.Despawn()
				end
				if TestValid(venator_1_intro) then
					venator_1_intro.Despawn()
				end
				if TestValid(venator_2_intro) then
					venator_2_intro.Despawn()
				end
				if not TestValid(player_plo) then
					p_republic = Find_Player("Empire")
					player_plo = MissionUtil.SpawnUnitSpace("Venator_Star_Destroyer", venator_plo_move_to, p_republic, 1)
				else
					player_plo.Despawn()
					player_plo = MissionUtil.SpawnUnitSpace("Venator_Star_Destroyer", venator_plo_move_to, p_republic, 1)
				end
				if not TestValid(venator_1) then
					p_republic = Find_Player("Empire")
					venator_1 = MissionUtil.SpawnUnitSpace("Venator_Star_Destroyer", venator_1_move_to, p_republic, nil)
				else
					venator_1.Despawn()
					venator_1 = MissionUtil.SpawnUnitSpace("Venator_Star_Destroyer", venator_1_move_to, p_republic, 1)
				end
				if not TestValid(venator_2) then
					p_republic = Find_Player("Empire")
					venator_2 = MissionUtil.SpawnUnitSpace("Venator_Star_Destroyer", venator_2_move_to, p_republic, nil)
				else
					venator_2.Despawn()
					venator_2 = MissionUtil.SpawnUnitSpace("Venator_Star_Destroyer", venator_2_move_to, p_republic, 1)
				end
				if not TestValid(player_intro_malevolence) then
					p_cis = Find_Player("Rebel")
					player_intro_malevolence = MissionUtil.SpawnUnitSpace("Grievous_Malevolence_Hunt_Campaign", intro_malevolence_marker, p_cis, nil)
				end

				rep_fighters = Find_All_Objects_Of_Type(p_republic, "Fighter | Bomber")
				for _,repfighters in pairs(rep_fighters) do
					if TestValid(repfighters) then
						repfighters.Despawn()
					end
				end

				MissionUtil.CinematicSkippingCleanUp(venator_plo_move_to)

				MissionUtil.AIActivation()
				MissionUtil.SetObjectiveNew("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_REP_01")
				MissionUtil.SetObjectiveNew("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_REP_02")

				p_republic.Make_Enemy(p_cis)
				p_cis.Make_Enemy(p_republic)

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

				junk_list_05 = Find_All_Objects_Of_Type("SPACE_JUNK_LARGE")
				for x,junks5 in pairs(junk_list_05) do
					if TestValid(junks5) then
						Hide_Object(junks5, 0)
					end
				end

				junk_list_06 = Find_All_Objects_Of_Type("SPACE_JUNK_HUGE")
				for s,junks6 in pairs(junk_list_06) do
					if TestValid(junks6) then
						Hide_Object(junks6, 0)
					end
				end

				republic_unit_list_skip = Find_All_Objects_Of_Type(p_republic)
				for g,repunitsskip in pairs(republic_unit_list_skip) do
					if TestValid(repunitsskip) then
						repunitsskip.Despawn()
					end
				end

				cis_unit_list_skip = Find_All_Objects_Of_Type(p_cis)
				for u,skippies in pairs(cis_unit_list_skip) do
					if TestValid(skippies) then
						skippies.Despawn()
					end
				end

				if TestValid(player_twilight) then
					player_twilight.Despawn()
				end
				if not TestValid(player_twilight) then
					player_twilight = MissionUtil.SpawnUnitSpace("Twilight_Mission", twilight_move_to, p_republic, nil)
					player_twilight.Override_Max_Speed(8)
				end

				if not TestValid(pod_1) then
					pod_1 = MissionUtil.SpawnUnitSpace("Republic_Escape_Pod_Big", pod_1_marker, p_neutral, nil)
					pod_1.Highlight(true)
					Add_Radar_Blip(pod_1, "pod_1_blip")
					Register_Prox(pod_1, State_Proximity_Pod_1, 300)
				end
				if not TestValid(pod_2) then
					pod_2 = MissionUtil.SpawnUnitSpace("Republic_Escape_Pod_Big", pod_2_marker, p_neutral, nil)
					pod_2.Highlight(true)
					Add_Radar_Blip(pod_2, "pod_2_blip")
					Register_Prox(pod_2, State_Proximity_Pod_2, 300)
				end
				if not TestValid(pod_3) then
					pod_3 = MissionUtil.SpawnUnitSpace("Republic_Escape_Pod_Big", pod_3_marker, p_neutral, nil)
					pod_3.Highlight(true)
					Add_Radar_Blip(pod_3, "pod_3_blip")
					Register_Prox(pod_3, State_Proximity_Pod_3, 300)
				end
				if not TestValid(pod_4) then
					pod_4 = MissionUtil.SpawnUnitSpace("Republic_Escape_Pod_Big", pod_4_marker, p_neutral, nil)
					pod_4.Highlight(true)
					Add_Radar_Blip(pod_4, "pod_4_blip")
					Register_Prox(pod_4, State_Proximity_Pod_4, 300)
				end
				if not TestValid(pod_5) then
					pod_5 = MissionUtil.SpawnUnitSpace("Republic_Escape_Pod_Big", pod_5_marker, p_neutral, nil)
					pod_5.Highlight(true)
					Add_Radar_Blip(pod_5, "pod_5_blip")
					Register_Prox(pod_5, State_Proximity_Pod_5, 300)
				end

				if not TestValid(player_hunter_11) then
					player_hunter_11 = MissionUtil.SpawnUnitSpace("Droch_Boarding_Ship_Squadron", hunter_1_marker, p_cis, nil)
					player_hunter_11.Override_Max_Speed(5)
				end
				if not TestValid(player_hunter_12) then
					player_hunter_12 = MissionUtil.SpawnUnitSpace("Droch_Boarding_Ship_Squadron", hunter_1_marker, p_cis, nil)
					player_hunter_12.Override_Max_Speed(5)
				end
				if not TestValid(player_hunter_13) then
					player_hunter_13 = MissionUtil.SpawnUnitSpace("Droch_Boarding_Ship_Squadron", hunter_1_marker, p_cis, nil)
					player_hunter_13.Override_Max_Speed(5)
				end
				if not TestValid(player_hunter_14) then
					player_hunter_14 = MissionUtil.SpawnUnitSpace("Droch_Boarding_Ship_Squadron", hunter_1_marker, p_cis, nil)
					player_hunter_14.Override_Max_Speed(5)
				end
				if not TestValid(player_hunter_2) then
					player_hunter_2 = MissionUtil.SpawnUnitSpace("Droch_Boarding_Ship_Squadron", hunter_1_marker, p_cis, nil)
					player_hunter_2.Override_Max_Speed(5)
				end
				if not TestValid(player_hunter_3) then
					player_hunter_3 = MissionUtil.SpawnUnitSpace("Droch_Boarding_Ship_Squadron", hunter_1_marker, p_cis, nil)
					player_hunter_3.Override_Max_Speed(5)
				end

				MissionUtil.CinematicSkippingCleanUp(player_twilight)

				MissionUtil.SetObjectiveRemove("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_REP_01")
				MissionUtil.SetObjectiveRemove("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_REP_02")

				MissionUtil.SetObjectiveNew("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_REP_03")
				MissionUtil.SetObjectiveNew("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_REP_04")

				Fade_Screen_In(0.5)

				cinematic_two = false
				act_1_active = false
				act_2_active = true
			end
		end
		if cinematic_three then
			if not cinematic_three_skipped then
				cinematic_three_skipped = true

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				Add_Radar_Blip(escape_marker, "escape_blip")
				escape_marker.Highlight(true)

				escape_pods = Find_All_Objects_Of_Type("Republic_Escape_Pod_Big")
				for s,escape_pod in pairs(escape_pods) do
					if TestValid(escape_pod) then
						escape_pod.Despawn()
					end
				end

				if TestValid(pod_plo) then
					pod_plo.Attach_Particle_Effect("Rescue_Effect")
					pod_plo.Despawn()
				end

				if not TestValid(player_midtro_malevolence) then
					player_midtro_malevolence = MissionUtil.SpawnUnitSpace("Grievous_Malevolence_Hunt_Campaign_Mission", midtro_2_malevolence_marker, p_cis, 1)
				end

				MissionUtil.SetObjectiveComplete("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_REP_03")
				MissionUtil.SetObjectiveComplete("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_REP_04")

				MissionUtil.SetObjectiveNew("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_REP_05")

				if TestValid(Find_First_Object("Twilight_Mission")) then
					Find_First_Object("Twilight_Mission").Despawn()
				end
				player_twilight = MissionUtil.SpawnUnitSpace("TWILIGHT_MISSION", pod_plo_marker, p_republic, nil)

				MissionUtil.CinematicSkippingCleanUp(pod_plo_marker)

				pod_plo_rescued = true
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

				if pod_plo_rescued then
					GlobalValue.Set("HfM_Plo_Rescued", 1)
				end

				MissionUtil.CinematicEnvironmentOff()

				--crossplot:tactical()
				--crossplot:publish("CREW_GAIN", pods_rescued)
				--crossplot:update()

				cinematic_four = false

				MissionUtil.VictoryAllowance(true)

				MissionUtil.DisableRetreat("REBEL", false)
				MissionUtil.DisableRetreat("EMPIRE", false)

				StoryUtil.DeclareVictory(p_cis, false)
			end
		end
	end
end
function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_1_active then
			if TestValid(player_plo) then
				if player_plo.Get_Hull() <= 0.10 then
					player_plo.Set_Cannot_Be_Killed(true)
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_CIS")
					act_1_active = false
				end
			end
		end
		if act_2_active then
			if not TestValid(pod_1) then
				Remove_Radar_Blip("pod_1_blip")
			end
			if not TestValid(pod_2) then
				Remove_Radar_Blip("pod_2_blip")
			end
			if not TestValid(pod_3) then
				Remove_Radar_Blip("pod_3_blip")
			end
			if not TestValid(pod_4) then
				Remove_Radar_Blip("pod_4_blip")
			end
			if not TestValid(pod_5) then
				Remove_Radar_Blip("pod_5_blip")
			end
		end
		if act_3_active then
			if TestValid(Find_First_Object("Twilight_Mission")) then
				Find_First_Object("Twilight_Mission").Move_To(escape_marker)
				Find_First_Object("Twilight_Mission").Lock_Current_Orders()
			end
			if not TestValid(Find_First_Object("Twilight_Mission")) and not last_scene then
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
				pod_plo_rescued = false
				last_scene = true
			end
		end
	elseif p_republic.Is_Human() then
		if act_1_active then
			if TestValid(player_plo) then
				if player_plo.Get_Hull() <= 0.10 then
					player_plo.Set_Cannot_Be_Killed(true)
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_Rep")
					act_1_active = false
				end
			end
		end
		if act_2_active then
			if not TestValid(pod_1) then
				Remove_Radar_Blip("pod_1_blip")
			end
			if not TestValid(pod_2) then
				Remove_Radar_Blip("pod_2_blip")
			end
			if not TestValid(pod_3) then
				Remove_Radar_Blip("pod_3_blip")
			end
			if not TestValid(pod_4) then
				Remove_Radar_Blip("pod_4_blip")
			end
			if not TestValid(pod_5) then
				Remove_Radar_Blip("pod_5_blip")
			end
		end
		if act_3_active then
			if not TestValid(Find_First_Object("Twilight_Mission")) and not last_scene then
				--current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
				pod_plo_rescued = false
				last_scene = true
			end
		end
	end
end


function Start_Cinematic_Crawl_CIS()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)

	cinematic_crawl = true
	MissionUtil.PlayCinematicMovieCrawl("Hunt_for_Malevolence_Campaign_Intro", "Clone_Wars_Crawl_Theme")

	if not cinematic_crawl_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
	end
end

function Start_Cinematic_Intro_CIS()
	cinematic_crawl = false
	cinematic_one = true

	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_venator_plo_marker, true, 8.0, nil, nil)

	MissionUtil.PlayGenericSpeech("Abregado_Ambush_01")
	MissionUtil.PlayGenericMusic("Silence_Theme")
	Letter_Box_In(1.0)

	Sleep(1.5)

	player_plo_intro.Teleport_And_Face(venator_plo_marker)
	player_plo_intro.Cinematic_Hyperspace_In(65)

	venator_1_intro.Teleport_And_Face(venator_1_marker)
	venator_1_intro.Cinematic_Hyperspace_In(65)

	venator_2_intro.Teleport_And_Face(venator_2_marker)
	venator_2_intro.Cinematic_Hyperspace_In(65)

	StoryUtil.Multimedia("TEXT_MISSION_ABREGADO_AMBUSH_INTRO_01", 9.5, nil, nil, 0)
	Sleep(3.0)

	StoryUtil.Multimedia("TEXT_MISSION_ABREGADO_AMBUSH_INTRO_02", 6.5, nil, nil, 0)
	Sleep(3.0)

	MissionUtil.TransitionCinematicCamera(introcam_3_marker, introcam_target_venator_plo_marker, true, 11.0, nil, nil)
	Sleep(11.0)

	Fade_Screen_In(0.01)

	MissionUtil.SetCinematicCamera(introcam_4_marker, introcam_target_malevolence_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_5_marker, introcam_target_malevolence_marker, true, 14.0, nil, nil)
	Sleep(1.0)

	player_plo_intro.Despawn()
	venator_1_intro.Despawn()
	venator_2_intro.Despawn()
	Sleep(1.0)

	player_plo.Teleport_And_Face(venator_plo_marker)
	venator_1.Teleport_And_Face(venator_1_marker)
	venator_2.Teleport_And_Face(venator_2_marker)
	Sleep(1.0)

	player_plo.Move_To(venator_plo_move_to)
	venator_1.Move_To(venator_1_move_to)
	venator_2.Move_To(venator_2_move_to)
	Sleep(4.0)

	MissionUtil.TransitionCinematicCamera(introcam_5_marker, player_plo, true, 7.0, nil, nil)
	Sleep(7.0)

	MissionUtil.SetCinematicCamera(introcam_6_marker, player_plo, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(pod_plo_marker, player_plo, true, 22.0, nil, nil)
	Sleep(11.0)

	MissionUtil.SetCinematicCamera(introcam_7_marker, introcam_target_malevolence_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_8_marker, player_intro_malevolence, true, 11.5, nil, nil)
	Sleep(2.0)

	if TestValid(player_intro_malevolence) then
		player_intro_malevolence.Attack_Move(venator_1)
		rep_fighters = Find_All_Objects_Of_Type(p_republic, "Fighter | Bomber")
		for _,repfighters in pairs(rep_fighters) do
			if TestValid(repfighters) then
				repfighters.Despawn()
			end
		end
	end

	Sleep(8.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end
function End_Cinematic_Intro_CIS()
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(player_intro_malevolence, 4.0)
	Sleep(4.0)

	p_republic.Make_Enemy(p_cis)
	p_cis.Make_Enemy(p_republic)

	--MissionUtil.AIActivation() Republic uses a special AI
	StoryUtil.ChangeAIPlayer("EMPIRE", "RepublicMissionAI")

	Sleep(1.0)

	MissionUtil.SetObjectiveMissionSet("ABREGADO_AMBUSH", "CIS", 2)

	Sleep(5.0)
	MissionUtil.CinematicEnvironmentOff()

	current_cinematic_thread_id = nil

	cinematic_one = false
	act_1_active = true
end

function Start_Cinematic_Midtro_CIS()
	cinematic_two = true

	MissionUtil.CinematicEnvironmentOn()
	MissionUtil.StartCinematicCamera()

	Sleep(0.5)

	MissionUtil.PlayGenericSpeech("Abregado_Ambush_02")
	MissionUtil.PlayGenericMusic("Silence_Theme")
	Fade_Screen_In(2.0)
	Letter_Box_In(2.0)

	MissionUtil.SetCinematicCamera(introcam_8_marker, player_plo, true, {x = -500, y = 300, z = -90}, {x = -60, y = 0, z = -10})
	MissionUtil.TransitionCinematicCamera(introcam_7_marker, player_plo, true, 20.0, {x = -500, y = 300, z = -210}, {x = -60, y = 0, z = -10})
	Sleep(5.0)

	if TestValid(venator_1) then
		venator_1.Take_Damage(999999)
	end

	Sleep(4.0)

	if TestValid(venator_2) then
		venator_2.Take_Damage(999999)
	end

	Sleep(6.0)

	if TestValid(player_plo) then
		player_plo.Set_Cannot_Be_Killed(false)
		player_plo.Take_Damage(999999)
	end

	Sleep(2.0)

	Fade_Screen_Out(3.0)
	Sleep(3.0)

	junk_list_03 = Find_All_Objects_Of_Type("SPACE_JUNK_LARGE")
	for k,junks3 in pairs(junk_list_03) do
		if TestValid(junks3) then
			Hide_Object(junks3, 0)
		end
	end

	junk_list_04 = Find_All_Objects_Of_Type("SPACE_JUNK_HUGE")
	for l,junks4 in pairs(junk_list_04) do
		if TestValid(junks4) then
			Hide_Object(junks4, 0)
		end
	end

	Sleep(1.0)

	republic_unit_list = Find_All_Objects_Of_Type(p_republic)
	for k,repunits in pairs(republic_unit_list) do
		if TestValid(repunits) then
			repunits.Despawn()
		end
	end

	player_intro_malevolence.Teleport_And_Face(midtro_1_malevolence_marker)
	player_intro_malevolence.Suspend_Locomotor(true)

	MissionUtil.SetCinematicCamera(midtrocam_1_marker, midtrocam_target_malevolence_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(midtrocam_2_marker, midtrocam_target_malevolence_marker, true, 14.0, nil, nil)

	Fade_Screen_In(3.0)
	Sleep(11.0)

	Fade_Screen_Out(2.0)
	Sleep(2.0)

	cis_unit_list = Find_All_Objects_Of_Type(p_cis)
	for z,seppies in pairs(cis_unit_list) do
		if TestValid(seppies) then
			seppies.Despawn()
		end
	end

	Stop_All_Music()
	Stop_All_Speech()

	pod_1 = MissionUtil.SpawnUnitSpace("Republic_Escape_Pod_Big", pod_1_marker, p_neutral, nil)
	pod_1.Highlight(true)
	Add_Radar_Blip(pod_1, "pod_1_blip")
	Register_Prox(pod_1, State_Proximity_Pod_1, 300)

	pod_2 = MissionUtil.SpawnUnitSpace("Republic_Escape_Pod_Big", pod_2_marker, p_neutral, nil)
	pod_2.Highlight(true)
	Add_Radar_Blip(pod_2, "pod_2_blip")
	Register_Prox(pod_2, State_Proximity_Pod_2, 300)

	pod_3 = MissionUtil.SpawnUnitSpace("Republic_Escape_Pod_Big", pod_3_marker, p_neutral, nil)
	pod_3.Highlight(true)
	Add_Radar_Blip(pod_3, "pod_3_blip")
	Register_Prox(pod_3, State_Proximity_Pod_3, 300)

	pod_4 = MissionUtil.SpawnUnitSpace("Republic_Escape_Pod_Big", pod_4_marker, p_neutral, nil)
	pod_4.Highlight(true)
	Add_Radar_Blip(pod_4, "pod_4_blip")
	Register_Prox(pod_4, State_Proximity_Pod_4, 300)

	pod_5 = MissionUtil.SpawnUnitSpace("Republic_Escape_Pod_Big", pod_5_marker, p_neutral, nil)
	pod_5.Highlight(true)
	Add_Radar_Blip(pod_5, "pod_5_blip")
	Register_Prox(pod_5, State_Proximity_Pod_5, 300)

	Sleep(1.0)

	player_hunter_11 = MissionUtil.SpawnUnitSpace("Droch_Boarding_Ship_Squadron", hunter_1_marker, p_cis, nil)
	player_hunter_11.Override_Max_Speed(7)

	player_hunter_12 = MissionUtil.SpawnUnitSpace("Droch_Boarding_Ship_Squadron", hunter_1_marker, p_cis, nil)
	player_hunter_12.Override_Max_Speed(7)

	player_hunter_13 = MissionUtil.SpawnUnitSpace("Droch_Boarding_Ship_Squadron", hunter_1_marker, p_cis, nil)
	player_hunter_13.Override_Max_Speed(7)

	player_hunter_14 = MissionUtil.SpawnUnitSpace("Droch_Boarding_Ship_Squadron", hunter_1_marker, p_cis, nil)
	player_hunter_14.Override_Max_Speed(7)

	player_hunter_2 = MissionUtil.SpawnUnitSpace("Droch_Boarding_Ship_Squadron", hunter_1_marker, p_cis, nil)
	player_hunter_2.Override_Max_Speed(7)

	player_hunter_3 = MissionUtil.SpawnUnitSpace("Droch_Boarding_Ship_Squadron", hunter_1_marker, p_cis, nil)
	player_hunter_3.Override_Max_Speed(7)

	Fade_Screen_In(2.0)

	if not cinematic_two_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Midtro_CIS")
	end
end
function End_Cinematic_Midtro_CIS()
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(hunter_1_marker, 4.0)
	Sleep(4.0)

	p_republic.Make_Enemy(p_cis)
	p_cis.Make_Enemy(p_republic)

	MissionUtil.SetObjectiveComplete("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_CIS_01")
	MissionUtil.SetObjectiveComplete("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_CIS_02")

	MissionUtil.SetObjectiveNew("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_CIS_03_1")

	Sleep(3.0)
	MissionUtil.CinematicEnvironmentOff()

	current_cinematic_thread_id = nil

	act_1_active = false
	act_2_active = true
	cinematic_two = false
end

function Start_Cinematic_Midtro_02_CIS()
	act_2_active = false
	cinematic_three = true

	MissionUtil.CinematicEnvironmentOn()
	MissionUtil.StartCinematicCamera()

	MissionUtil.PlayGenericSpeech("Abregado_Ambush_03")
	MissionUtil.PlayGenericMusic("Silence_Theme")

	player_twilight = MissionUtil.SpawnUnitSpace("Twilight_Mission", droch_twilight_marker, p_republic, 1)
	pod_plo = MissionUtil.SpawnUnitSpace("Republic_Escape_Pod_Big", pod_plo_marker, p_republic, 150)

	Fade_Screen_In(0.25)
	Letter_Box_In(0.25)
	Sleep(0.25)

	player_twilight.Teleport_And_Face(droch_twilight_marker)
	player_twilight.Override_Max_Speed(1)

	MissionUtil.SetCinematicCamera(drochcam_1_marker, pod_plo_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(drochcam_2_marker, pod_plo_marker, true, 5.0, nil, nil)
	Sleep(5.0)

	MissionUtil.SetCinematicCamera(drochcam_3_marker, pod_plo_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(drochcam_4_marker, pod_plo_marker, true, 10.0, nil, nil)
	Sleep(0.5)

	pod_plo.Attach_Particle_Effect("Rescue_Effect")
	Sleep(0.25)

	pod_plo.Despawn()
	Sleep(2.0)

	Fade_Screen_Out(0.5)
	Sleep(1.5)

	player_midtro_malevolence = MissionUtil.SpawnUnitSpace("Grievous_Malevolence_Hunt_Campaign_Mission", midtro_2_malevolence_marker, p_cis, 50)

	Fade_Screen_In(2.0)

	Set_Cinematic_Camera_Key(midtrocam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_5_marker, 0, 0, -200, 0, midtro_2_malevolence_marker, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_6_marker, 9, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_6_marker, 9, 0, 0, -200, 0, midtro_2_malevolence_marker, 1, 0)
	Sleep(9.0)

	player_twilight.Move_To(escape_marker)

	Set_Cinematic_Camera_Key(player_twilight, -100, -200, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(player_twilight, 0, 0, 0, 0, player_twilight, 1, 0)
	Sleep(3.0)

	player_twilight.Move_To(escape_marker)

	Fade_Screen_Out(2.0)
	Sleep(3.0)

	if not cinematic_three_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
	end
end
function Start_Cinematic_Outro_CIS()
	act_3_active = false
	cinematic_four = true

	MissionUtil.CinematicEnvironmentOn()
	MissionUtil.StartCinematicCamera()
	Point_Camera_At(Find_First_Object("Twilight_Mission"))

	if pod_plo_rescued then
		GlobalValue.Set("HfM_Plo_Rescued", 1)
	end

	if TestValid(pod_1) then
		pod_1.Highlight(false)
	end
	if TestValid(pod_2) then
		pod_2.Highlight(false)
	end
	if TestValid(pod_3) then
		pod_3.Highlight(false)
	end
	if TestValid(pod_4) then
		pod_4.Highlight(false)
	end
	if TestValid(pod_5) then
		pod_5.Highlight(false)
	end

	Sleep(1.5)

	Find_First_Object("Twilight_Mission").Teleport_And_Face(outro_twilight_marker)

	player_midtro_malevolence.Teleport_And_Face(outro_malevolence_marker)
	player_midtro_malevolence.Suspend_Locomotor(true)

	Remove_Radar_Blip("escape_blip")
	escape_marker.Highlight(false)

	MissionUtil.SetCinematicCamera(outrocam_1_marker, Find_First_Object("Twilight_Mission"), true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_2_marker, Find_First_Object("Twilight_Mission"), true, 50.0, nil, nil)

	MissionUtil.PlayGenericSpeech("Abregado_Ambush_04")
	MissionUtil.PlayGenericMusic("Silence_Theme")
	MissionUtil.CinematicEnvironmentOn()

	Fade_Screen_In(1.5)
	Sleep(0.25)

	if TestValid(player_twilight) then
	--player_twilight.Play_Animation("Deploy", false)
	end

	Sleep(1.25)

	if TestValid(Find_First_Object("Twilight_Mission")) then
		Find_First_Object("Twilight_Mission").Hyperspace_Away(true)
	end

	Sleep(3.0)

	MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outrocam_target_malevolence_marker, true, 8.0, nil, nil)
	Sleep(8.0)

	MissionUtil.TransitionCinematicCamera(outrocam_3_marker, outrocam_target_malevolence_marker, true, 22.0, nil, nil)
	Sleep(18.0)

	Fade_Screen_Out(3.0)
	Sleep(3.0)

	MissionUtil.CinematicEnvironmentOff()

	MissionUtil.VictoryAllowance(true)

	MissionUtil.DisableRetreat("REBEL", false)
	MissionUtil.DisableRetreat("EMPIRE", false)

	StoryUtil.DeclareVictory(p_cis, false)
end


function Start_Cinematic_Crawl_Rep()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true, nil, nil)

	cinematic_crawl = true
	MissionUtil.PlayCinematicMovieCrawl("Hunt_for_Malevolence_Campaign_Intro", "Clone_Wars_Crawl_Theme")

	if not cinematic_crawl_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
	end
end

function Start_Cinematic_Intro_Rep()
	cinematic_crawl = false
	cinematic_one = true

	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_venator_plo_marker, true, 8.0, nil, nil)

	MissionUtil.PlayGenericSpeech("Abregado_Ambush_01")
	MissionUtil.PlayGenericMusic("Silence_Theme")
	Letter_Box_In(1.0)

	Sleep(1.5)

	player_plo_intro.Teleport_And_Face(venator_plo_marker)
	player_plo_intro.Cinematic_Hyperspace_In(65)

	venator_1_intro.Teleport_And_Face(venator_1_marker)
	venator_1_intro.Cinematic_Hyperspace_In(65)

	venator_2_intro.Teleport_And_Face(venator_2_marker)
	venator_2_intro.Cinematic_Hyperspace_In(65)

	StoryUtil.Multimedia("TEXT_MISSION_ABREGADO_AMBUSH_INTRO_01", 9.5, nil, nil, 0)
	Sleep(3.0)

	StoryUtil.Multimedia("TEXT_MISSION_ABREGADO_AMBUSH_INTRO_02", 6.5, nil, nil, 0)
	Sleep(3.0)

	MissionUtil.TransitionCinematicCamera(introcam_3_marker, introcam_target_venator_plo_marker, true, 11.0, nil, nil)
	Sleep(11.0)

	Fade_Screen_In(0.01)

	MissionUtil.SetCinematicCamera(introcam_4_marker, introcam_target_malevolence_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_5_marker, introcam_target_malevolence_marker, true, 14.0, nil, nil)
	Sleep(1.0)

	player_plo_intro.Despawn()
	venator_1_intro.Despawn()
	venator_2_intro.Despawn()
	Sleep(1.0)

	player_plo.Teleport_And_Face(venator_plo_marker)
	venator_1.Teleport_And_Face(venator_1_marker)
	venator_2.Teleport_And_Face(venator_2_marker)
	Sleep(1.0)

	player_plo.Move_To(venator_plo_move_to)
	venator_1.Move_To(venator_1_move_to)
	venator_2.Move_To(venator_2_move_to)
	Sleep(4.0)

	MissionUtil.TransitionCinematicCamera(introcam_5_marker, player_plo, true, 7.0, nil, nil)
	Sleep(7.0)

	MissionUtil.SetCinematicCamera(introcam_6_marker, player_plo, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(pod_plo_marker, player_plo, true, 22.0, nil, nil)
	Sleep(11.0)

	MissionUtil.SetCinematicCamera(introcam_7_marker, introcam_target_malevolence_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_8_marker, player_intro_malevolence, true, 11.5, nil, nil)
	Sleep(2.0)

	if TestValid(player_intro_malevolence) then
		player_intro_malevolence.Attack_Move(venator_1)
		rep_fighters = Find_All_Objects_Of_Type(p_republic, "Fighter | Bomber")
		for _,repfighters in pairs(rep_fighters) do
			if TestValid(repfighters) then
				repfighters.Despawn()
			end
		end
	end

	Sleep(8.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Rep")
	end
end
function End_Cinematic_Intro_Rep()
	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(player_plo, 4.0)
	Sleep(4.0)

	p_republic.Make_Enemy(p_cis)
	p_cis.Make_Enemy(p_republic)

	MissionUtil.AIActivation()
	Sleep(1.0)

	MissionUtil.SetObjectiveMissionSet("ABREGADO_AMBUSH", "REP", 2)

	Sleep(5.0)
	MissionUtil.CinematicEnvironmentOff()

	current_cinematic_thread_id = nil

	cinematic_one = false
	act_1_active = true
end

function Start_Cinematic_Midtro_Rep()
	cinematic_two = true

	MissionUtil.CinematicEnvironmentOn()
	MissionUtil.StartCinematicCamera()
	Sleep(0.5)

	MissionUtil.PlayGenericSpeech("Abregado_Ambush_02")
	MissionUtil.PlayGenericMusic("Silence_Theme")
	Fade_Screen_In(2.0)
	Letter_Box_In(2.0)

	MissionUtil.SetCinematicCamera(introcam_8_marker, player_plo, true, {x = -500, y = 300, z = -90}, {x = -60, y = 0, z = -10})
	MissionUtil.TransitionCinematicCamera(introcam_7_marker, player_plo, true, 20.0, {x = -500, y = 300, z = -210}, {x = -60, y = 0, z = -10})
	Sleep(5.0)

	if TestValid(venator_1) then
		venator_1.Take_Damage(999999)
	end

	Sleep(4.0)

	if TestValid(venator_2) then
		venator_2.Take_Damage(999999)
	end

	Sleep(6.0)

	if TestValid(player_plo) then
		player_plo.Set_Cannot_Be_Killed(false)
		player_plo.Take_Damage(999999)
	end

	Sleep(2.0)

	Fade_Screen_Out(3.0)
	Sleep(3.0)

	junk_list_03 = Find_All_Objects_Of_Type("SPACE_JUNK_LARGE")
	for k,junks3 in pairs(junk_list_03) do
		if TestValid(junks3) then
			Hide_Object(junks3, 0)
		end
	end

	junk_list_04 = Find_All_Objects_Of_Type("SPACE_JUNK_HUGE")
	for l,junks4 in pairs(junk_list_04) do
		if TestValid(junks4) then
			Hide_Object(junks4, 0)
		end
	end

	Sleep(1.0)

	republic_unit_list = Find_All_Objects_Of_Type(p_republic)
	for k,repunits in pairs(republic_unit_list) do
		if TestValid(repunits) then
			repunits.Despawn()
		end
	end

	player_intro_malevolence.Teleport_And_Face(midtro_1_malevolence_marker)
	player_intro_malevolence.Suspend_Locomotor(true)

	MissionUtil.SetCinematicCamera(midtrocam_1_marker, midtrocam_target_malevolence_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(midtrocam_2_marker, midtrocam_target_malevolence_marker, true, 14.0, nil, nil)

	Fade_Screen_In(3.0)
	Sleep(11.0)

	Fade_Screen_Out(2.0)
	Sleep(2.0)

	cis_unit_list = Find_All_Objects_Of_Type(p_cis)
	for z,seppies in pairs(cis_unit_list) do
		if TestValid(seppies) then
			seppies.Despawn()
		end
	end

	player_twilight = MissionUtil.SpawnUnitSpace("Twilight_Mission", twilight_marker, p_republic, 150)
	player_twilight.Override_Max_Speed(8)

	Set_Cinematic_Camera_Key(midtrocam_3_marker, 500, -200, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_3_marker, 0, 0, 0, 0, twilight_marker, 1, 0)
	MissionUtil.TransitionCinematicCamera(midtrocam_3_marker, twilight_marker, true, 5.0, nil, nil)
	Sleep(1.0)

	Fade_Screen_In(2.0)
	Sleep(4.0)

	pod_1 = MissionUtil.SpawnUnitSpace("Republic_Escape_Pod_Big", pod_1_marker, p_neutral, nil)
	pod_1.Highlight(true)
	Add_Radar_Blip(pod_1, "pod_1_blip")
	Register_Prox(pod_1, State_Proximity_Pod_1, 300)

	pod_2 = MissionUtil.SpawnUnitSpace("Republic_Escape_Pod_Big", pod_2_marker, p_neutral, nil)
	pod_2.Highlight(true)
	Add_Radar_Blip(pod_2, "pod_2_blip")
	Register_Prox(pod_2, State_Proximity_Pod_2, 300)

	pod_3 = MissionUtil.SpawnUnitSpace("Republic_Escape_Pod_Big", pod_3_marker, p_neutral, nil)
	pod_3.Highlight(true)
	Add_Radar_Blip(pod_3, "pod_3_blip")
	Register_Prox(pod_3, State_Proximity_Pod_3, 300)

	pod_4 = MissionUtil.SpawnUnitSpace("Republic_Escape_Pod_Big", pod_4_marker, p_neutral, nil)
	pod_4.Highlight(true)
	Add_Radar_Blip(pod_4, "pod_4_blip")
	Register_Prox(pod_4, State_Proximity_Pod_4, 300)

	pod_5 = MissionUtil.SpawnUnitSpace("Republic_Escape_Pod_Big", pod_5_marker, p_neutral, nil)
	pod_5.Highlight(true)
	Add_Radar_Blip(pod_5, "pod_5_blip")
	Register_Prox(pod_5, State_Proximity_Pod_5, 300)

	MissionUtil.TransitionCinematicCamera(midtrocam_4_marker, player_twilight, true, 10.0, nil, nil)
	Sleep(3.0)

	player_twilight.Move_To(twilight_move_to)
	Sleep(2.0)

	player_twilight.Move_To(twilight_move_to)
	Sleep(8.0)

	Set_Cinematic_Camera_Key(player_twilight, -100, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(player_twilight, 0, 0, 0, 0, player_twilight, 1, 0)
	Sleep(4.0)

	Set_Cinematic_Camera_Key(player_twilight, 350, 0, -350, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(player_twilight, 0, 0, 0, 0, player_twilight, 1, 0)
	Sleep(2.0)

	player_twilight.Move_To(venator_2_move_to)
	Sleep(2.0)

	if not cinematic_two_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Midtro_Rep")
	end
end
function End_Cinematic_Midtro_Rep()
	MissionUtil.SetObjectiveRemove("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_REP_01")
	MissionUtil.SetObjectiveRemove("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_REP_02")

	MissionUtil.SetObjectiveNew("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_REP_03")
	MissionUtil.SetObjectiveNew("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_REP_04")

	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(player_twilight, 4.0)
	Sleep(6.0)

	player_hunter_11 = MissionUtil.SpawnUnitSpace("Droch_Boarding_Ship_Squadron", hunter_1_marker, p_cis, nil)
	player_hunter_11.Override_Max_Speed(5)

	player_hunter_12 = MissionUtil.SpawnUnitSpace("Droch_Boarding_Ship_Squadron", hunter_1_marker, p_cis, nil)
	player_hunter_12.Override_Max_Speed(5)

	player_hunter_13 = MissionUtil.SpawnUnitSpace("Droch_Boarding_Ship_Squadron", hunter_1_marker, p_cis, nil)
	player_hunter_13.Override_Max_Speed(5)

	player_hunter_14 = MissionUtil.SpawnUnitSpace("Droch_Boarding_Ship_Squadron", hunter_1_marker, p_cis, nil)
	player_hunter_14.Override_Max_Speed(5)

	player_hunter_2 = MissionUtil.SpawnUnitSpace("Droch_Boarding_Ship_Squadron", hunter_1_marker, p_cis, nil)
	player_hunter_2.Override_Max_Speed(5)

	player_hunter_3 = MissionUtil.SpawnUnitSpace("Droch_Boarding_Ship_Squadron", hunter_1_marker, p_cis, nil)
	player_hunter_3.Override_Max_Speed(5)

	Sleep(4.0)

	act_1_active = false
	act_2_active = true

	Sleep(18.0)

	MissionUtil.CinematicEnvironmentOff()
	cinematic_two = false
end

function Start_Cinematic_Midtro_02_Rep()
	Register_Prox(escape_marker, State_Proximity_Escape_Marker, 600, p_republic)

	if not TestValid(player_twilight) then
		player_twilight = MissionUtil.SpawnUnitSpace("Twilight_Mission", droch_twilight_marker, p_republic, 150)
		player_twilight.Override_Max_Speed(8)
	end
	player_twilight.Set_Cannot_Be_Killed(true)

	act_2_active = false
	cinematic_three = true

	MissionUtil.CinematicEnvironmentOn()
	MissionUtil.StartCinematicCamera()

	MissionUtil.PlayGenericSpeech("Abregado_Ambush_03")
	MissionUtil.PlayGenericMusic("Silence_Theme")

	if TestValid(pod_1) then
		pod_1.Highlight(false)
	end
	if TestValid(pod_2) then
		pod_2.Highlight(false)
	end
	if TestValid(pod_3) then
		pod_3.Highlight(false)
	end
	if TestValid(pod_4) then
		pod_4.Highlight(false)
	end
	if TestValid(pod_5) then
		pod_5.Highlight(false)
	end

	pod_plo = MissionUtil.SpawnUnitSpace("Republic_Escape_Pod_Big", pod_plo_marker, p_republic, 150)

	Fade_Screen_In(0.25)
	Letter_Box_In(0.25)
	Sleep(0.25)

	player_twilight.Teleport_And_Face(droch_twilight_marker)
	player_twilight.Override_Max_Speed(1)

	MissionUtil.SetCinematicCamera(drochcam_1_marker, pod_plo_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(drochcam_2_marker, pod_plo_marker, true, 5.0, nil, nil)
	Sleep(5.0)

	MissionUtil.SetCinematicCamera(drochcam_3_marker, pod_plo_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(drochcam_4_marker, pod_plo_marker, true, 10.0, nil, nil)
	Sleep(0.5)

	pod_plo.Attach_Particle_Effect("Rescue_Effect")
	Sleep(0.25)

	pod_plo.Despawn()
	Sleep(2.0)

	Fade_Screen_Out(0.5)
	Sleep(1.5)

	player_midtro_malevolence = MissionUtil.SpawnUnitSpace("Grievous_Malevolence_Hunt_Campaign_Mission", midtro_2_malevolence_marker, p_cis, 50)

	Fade_Screen_In(2.0)

	Set_Cinematic_Camera_Key(midtrocam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_5_marker, 0, 0, -200, 0, midtro_2_malevolence_marker, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_6_marker, 9, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_6_marker, 9, 0, 0, -200, 0, midtro_2_malevolence_marker, 1, 0)
	Sleep(4.0)

	player_midtro_malevolence.Attack_Move(player_twilight)
	Sleep(5.0)

	player_twilight.Move_To(escape_marker)

	Set_Cinematic_Camera_Key(player_twilight, -100, -200, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(player_twilight, 0, 0, 0, 0, player_twilight, 1, 0)
	Sleep(3.0)

	player_twilight.Move_To(escape_marker)

	if not cinematic_three_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Midtro_02_Rep")
	end
end
function End_Cinematic_Midtro_02_Rep()
	player_twilight.Teleport_And_Face(droch_twilight_marker)
	player_twilight.Override_Max_Speed(8)

	Fade_Screen_In(0.1)

	MissionUtil.CinematicEnvironmentOff()
	MissionUtil.EndCinematicCamera(player_twilight, 3.0)

	act_3_active = true
	cinematic_three = false
	pod_plo_rescued = true

	MissionUtil.SetObjectiveComplete("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_REP_03")
	MissionUtil.SetObjectiveComplete("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_REP_04")

	MissionUtil.SetObjectiveNew("TEXT_MISSION_ABREGADO_AMBUSH_OBJECTIVE_REP_05")

	if TestValid(pod_1) then
		pod_1.Despawn()
	end
	if TestValid(pod_2) then
		pod_2.Despawn()
	end
	if TestValid(pod_3) then
		pod_3.Despawn()
	end
	if TestValid(pod_4) then
		pod_4.Despawn()
	end
	if TestValid(pod_5) then
		pod_5.Despawn()
	end

	Add_Radar_Blip(escape_marker, "escape_blip")
	escape_marker.Highlight(true)

	cis_fleet = Find_All_Objects_Of_Type(p_cis)
	for _,cisships in pairs(cis_fleet) do
		if TestValid(cisships) then
			cisships.Attack_Move(player_twilight)
		end
	end

	Sleep(34.0)

	twilight_position = Find_First_Object("Twilight_Mission")

	player_hunter_4 = MissionUtil.SpawnUnitSpace("Vulture_Squadron_Half", twilight_position, p_cis, nil)
	player_hunter_4.Attack_Move(player_twilight)
	player_hunter_4.Override_Max_Speed(15)
	Sleep(1.0)

	if not act_3_active then
		MissionUtil.CinematicEnvironmentOff()
		MissionUtil.CinematicEnvironmentOff()
	end
end

function Start_Cinematic_Outro_Rep()
	act_3_active = false
	cinematic_four = true

	if not TestValid(Find_First_Object("Twilight_Mission")) then
		player_twilight = MissionUtil.SpawnUnitSpace("TWILIGHT_MISSION", outro_twilight_marker, p_republic, 0)
	end

	MissionUtil.CinematicEnvironmentOn()
	MissionUtil.StartCinematicCamera()
	Point_Camera_At(Find_First_Object("Twilight_Mission"))

	if pod_plo_rescued then
		GlobalValue.Set("HfM_Plo_Rescued", 1)
	end

	if TestValid(pod_1) then
		pod_1.Highlight(false)
	end
	if TestValid(pod_2) then
		pod_2.Highlight(false)
	end
	if TestValid(pod_3) then
		pod_3.Highlight(false)
	end
	if TestValid(pod_4) then
		pod_4.Highlight(false)
	end
	if TestValid(pod_5) then
		pod_5.Highlight(false)
	end

	Fade_Screen_Out(0.5)
	Sleep(0.5)

	Find_First_Object("Twilight_Mission").Teleport_And_Face(outro_twilight_marker)

	player_midtro_malevolence.Teleport_And_Face(outro_malevolence_marker)
	player_midtro_malevolence.Suspend_Locomotor(true)

	Remove_Radar_Blip("escape_blip")
	escape_marker.Highlight(false)

	MissionUtil.SetCinematicCamera(outrocam_1_marker, Find_First_Object("Twilight_Mission"), true, nil, nil)
	MissionUtil.TransitionCinematicCamera(outrocam_2_marker, Find_First_Object("Twilight_Mission"), true, 50.0, nil, nil)

	MissionUtil.PlayGenericSpeech("Abregado_Ambush_04")
	MissionUtil.PlayGenericMusic("Silence_Theme")
	MissionUtil.CinematicEnvironmentOn()

	Fade_Screen_In(0.5)
	Sleep(0.25)

	if TestValid(player_twilight) then
	--player_twilight.Play_Animation("Deploy", false)
	end

	Sleep(1.25)

	if TestValid(Find_First_Object("Twilight_Mission")) then
		Find_First_Object("Twilight_Mission").Hyperspace_Away(true)
	end

	Sleep(3.0)

	MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outrocam_target_malevolence_marker, true, 8.0, nil, nil)
	Sleep(8.0)

	MissionUtil.TransitionCinematicCamera(outrocam_3_marker, outrocam_target_malevolence_marker, true, 22.0, nil, nil)
	Sleep(18.0)

	Fade_Screen_Out(3.0)
	Sleep(3.0)

	MissionUtil.CinematicEnvironmentOff()

	MissionUtil.VictoryAllowance(true)

	MissionUtil.DisableRetreat("REBEL", false)
	MissionUtil.DisableRetreat("EMPIRE", false)

	StoryUtil.DeclareVictory(p_cis, false)
end
