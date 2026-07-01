
--****************************************************--
--************ Rimward: Bothawui Business ************--
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
	p_hostile = Find_Player("Hostile")

	cinematic_crawl = false
	cinematic_one = false
	cinematic_two = false

	cinematic_crawl_skipped = false
	cinematic_one_skipped = false
	cinematic_two_skipped = false

	act_1_active = false

	trap_activated = false
	anakin_crashed = false
	anakin_rescued = false
	yularen_escaped = false
	grievous_escaped = false

	current_cinematic_thread_id = nil

	camera_offset = 125
	mission_started = false
end
function Begin_Battle(message)
	if message == OnEnter then
		MissionUtil.VictoryAllowance(false)

		MissionUtil.DisableRetreat("REBEL", true)
		MissionUtil.DisableRetreat("EMPIRE", true)

		yularen_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "yularen")
		dauntless_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "dauntless")
		pioneer_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "pioneer")

		muni1_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "muni-1-1")
		muni1_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "muni-1-2")
		muni2_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "muni-2-1")
		muni2_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "muni-2-2")
		muni3_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "muni-3-1")
		muni3_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "muni-3-2")
		muni4_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "muni-4-1")
		muni4_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "muni-4-2")
		muni5_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "muni-5-1")
		muni5_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "muni-5-2")

		grievous_move_to = Find_Hint("STORY_TRIGGER_ZONE_00", "grievousmoveto")
		muni1_move_to = Find_Hint("STORY_TRIGGER_ZONE_00", "muni1moveto")
		muni2_move_to = Find_Hint("STORY_TRIGGER_ZONE_00", "muni2moveto")
		muni3_move_to = Find_Hint("STORY_TRIGGER_ZONE_00", "muni3moveto")
		muni4_move_to = Find_Hint("STORY_TRIGGER_ZONE_00", "muni4moveto")
		muni5_move_to = Find_Hint("STORY_TRIGGER_ZONE_00", "muni5moveto")

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

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget1")
		introcam_target_yularen_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget-yularen")
		introcam_target_grievous_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget-grievous-1")
		introcam_target_grievous_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget-grievous-2")

		outrocam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-1")
		outrocam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam-target-2")

		outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam1")
		outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam2")
		outrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam3")
		outrocam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam4")
		outrocam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam5")

		outro_1_twilight_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-twilight-1")
		outro_2_twilight_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-twilight-2")

		anakin_crash_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "anakin-crash")
		retreat_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "retreat")

		player_yularen = Find_First_Object("YULAREN_RESOLUTE")
		player_anakin = Find_First_Object("ANAKIN_DELTA")

		player_munificent_1	= Find_Hint("MUNIFICENT_SUBFACTION", "1")
		player_munificent_2 = Find_Hint("MUNIFICENT_SUBFACTION", "2")
		player_munificent_3 = Find_Hint("MUNIFICENT_SUBFACTION", "3")
		player_munificent_4 = Find_Hint("MUNIFICENT_SUBFACTION", "4")
		player_munificent_5 = Find_Hint("MUNIFICENT_SUBFACTION", "5")

		MissionUtil.Set_To_Allies(p_hostile, p_cis)
		MissionUtil.Set_To_Allies(p_republic, p_hostile)

		local space_attes_01 = Find_All_Objects_Of_Type("REPUBLIC_AT_TE_WALKER_SPACE")
		for _,attes_space_01 in pairs(space_attes_01) do
			if TestValid(attes_space_01) then
				attes_space_01.Change_Owner(p_neutral)
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

function State_Trap_Active()
	trap_activated = true

	Stop_All_Music()
	MissionUtil.CinematicEnvironmentOn()

	MissionUtil.PlayGenericSpeech("Bothawui_Business_02")
	MissionUtil.PlayGenericMusic("Silence_Theme")
	Sleep(6.0)

	local space_attes_02 = Find_All_Objects_Of_Type("REPUBLIC_AT_TE_WALKER_SPACE")
	for _,attes_space_02 in pairs(space_attes_02) do
		if TestValid(attes_space_02) then
			attes_space_02.Change_Owner(p_republic)
		end
	end

	if p_cis.Is_Human() then
		player_yularen.Suspend_Locomotor(false)
		player_pioneer.Suspend_Locomotor(false)
		player_dauntless.Suspend_Locomotor(false)
	end

	MissionUtil.CinematicEnvironmentOff()
end

function Story_Handle_Esc()
	if mission_started then
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

					local despawn_me_table = Find_All_Objects_With_Hint("despawn-1")
					for i,despawn_me in pairs(despawn_me_table) do
						if TestValid(despawn_me) then
							despawn_me.Despawn()
						end
					end

					local hide_me_table = Find_All_Objects_Of_Type("Structure", p_republic)
					for i,hide_me in pairs(hide_me_table) do
						hide_me.Hide(false)
						Hide_Object(hide_me, 0)
					end

					player_grievous.Despawn()
					if (GlobalValue.Get("Rimward_CIS_GC_Version") == 0) then
						player_grievous = MissionUtil.SpawnUnitSpace("GRIEVOUS_MUNIFICENT", grievous_2_marker, p_cis, 100)
					else
						player_grievous = MissionUtil.SpawnUnitSpace("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN", grievous_2_marker, p_cis, 100)
					end

					player_munificent_1.Despawn()
					player_munificent_1 = MissionUtil.SpawnUnitSpace("MUNIFICENT_SUBFACTION", muni1_2_marker, p_cis, 100)

					player_munificent_2.Despawn()
					player_munificent_2 = MissionUtil.SpawnUnitSpace("MUNIFICENT_SUBFACTION", muni2_2_marker, p_cis, 100)

					player_munificent_3.Despawn()
					player_munificent_3 = MissionUtil.SpawnUnitSpace("MUNIFICENT_SUBFACTION", muni3_2_marker, p_cis, 100)

					player_munificent_4.Despawn()
					player_munificent_4 = MissionUtil.SpawnUnitSpace("MUNIFICENT_SUBFACTION", muni4_2_marker, p_cis, 100)

					player_munificent_5.Despawn()
					player_munificent_5 = MissionUtil.SpawnUnitSpace("MUNIFICENT_SUBFACTION", muni5_2_marker, p_cis, 100)

					player_yularen.Suspend_Locomotor(true)
					player_pioneer.Suspend_Locomotor(true)
					player_dauntless.Suspend_Locomotor(true)

					player_grievous.Make_Invulnerable(false)
					player_munificent_1.Make_Invulnerable(false)
					player_munificent_2.Make_Invulnerable(false)
					player_munificent_3.Make_Invulnerable(false)
					player_munificent_4.Make_Invulnerable(false)
					player_munificent_5.Make_Invulnerable(false)

					MissionUtil.SetObjectiveMissionSet("BOTHAWUI_BUSINESS", "CIS", 3)
					MissionUtil.CinematicSkippingCleanUp(grievous_2_marker)
					MissionUtil.Set_To_Enemies(p_republic, p_cis)

					Register_Timer(State_Trap_Active, 25)

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

					if yularen_escaped then
						GlobalValue.Set("Rimward_Bothawui_Business_Outcome", 0) -- 0 = CIS Victory, 1 = Republic Victory
						StoryUtil.DeclareVictory(p_cis, false)
					elseif grievous_escaped then
						GlobalValue.Set("Rimward_Bothawui_Business_Outcome", 1) -- 0 = CIS Victory, 1 = Republic Victory
						StoryUtil.DeclareVictory(p_republic, false)
					end
				end
			end
		elseif p_republic.Is_Human() then
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

					local despawn_me_table = Find_All_Objects_With_Hint("despawn-1")
					for i,despawn_me in pairs(despawn_me_table) do
						if TestValid(despawn_me) then
							despawn_me.Despawn()
						end
					end

					local hide_me_table = Find_All_Objects_Of_Type("Structure", p_republic)
					for i,hide_me in pairs(hide_me_table) do
						hide_me.Hide(false)
						Hide_Object(hide_me, 0)
					end

					player_grievous.Despawn()
					player_grievous = MissionUtil.SpawnUnitSpace("GRIEVOUS_MUNIFICENT", grievous_2_marker, p_cis, 100)

					player_munificent_1.Despawn()
					player_munificent_1 = MissionUtil.SpawnUnitSpace("MUNIFICENT_SUBFACTION", muni1_2_marker, p_cis, 100)

					player_munificent_2.Despawn()
					player_munificent_2 = MissionUtil.SpawnUnitSpace("MUNIFICENT_SUBFACTION", muni2_2_marker, p_cis, 100)

					player_munificent_3.Despawn()
					player_munificent_3 = MissionUtil.SpawnUnitSpace("MUNIFICENT_SUBFACTION", muni3_2_marker, p_cis, 100)

					player_munificent_4.Despawn()
					player_munificent_4 = MissionUtil.SpawnUnitSpace("MUNIFICENT_SUBFACTION", muni4_2_marker, p_cis, 100)

					player_munificent_5.Despawn()
					player_munificent_5 = MissionUtil.SpawnUnitSpace("MUNIFICENT_SUBFACTION", muni5_2_marker, p_cis, 100)

					player_grievous.Move_To(grievous_move_to)
					player_munificent_1.Move_To(muni1_move_to)
					player_munificent_2.Move_To(muni2_move_to)
					player_munificent_3.Move_To(muni3_move_to)
					player_munificent_4.Move_To(muni4_move_to)
					player_munificent_5.Move_To(muni5_move_to)

					if TestValid(Find_First_Object("SOULLESS_ONE")) and TestValid(player_anakin) then
						Find_First_Object("SOULLESS_ONE").Attack_Move(player_anakin)
					end

					local rep_fighters = Find_All_Objects_Of_Type(p_republic, "Fighter | Bomber")
					for _,repfighters in pairs(rep_fighters) do
						if TestValid(repfighters) then
							repfighters.Attack_Move(player_munificent_1)
						end
					end

					player_grievous.Make_Invulnerable(false)
					player_munificent_1.Make_Invulnerable(false)
					player_munificent_2.Make_Invulnerable(false)
					player_munificent_3.Make_Invulnerable(false)
					player_munificent_4.Make_Invulnerable(false)
					player_munificent_5.Make_Invulnerable(false)

					MissionUtil.SetObjectiveMissionSet("BOTHAWUI_BUSINESS", "REP", 4)
					MissionUtil.CinematicSkippingCleanUp(yularen_marker)
					MissionUtil.Set_To_Enemies(p_republic, p_cis)

					Register_Timer(State_Trap_Active, 25)

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

					if yularen_escaped then
						GlobalValue.Set("Rimward_Bothawui_Business_Outcome", 0) -- 0 = CIS Victory, 1 = Republic Victory
						StoryUtil.DeclareVictory(p_cis, false)
					elseif grievous_escaped then
						GlobalValue.Set("Rimward_Bothawui_Business_Outcome", 1) -- 0 = CIS Victory, 1 = Republic Victory
						StoryUtil.DeclareVictory(p_republic, false)
					end
				end
			end
		end
	end 
end
function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_1_active then
			if Find_First_Object("YULAREN_RESOLUTE").Get_Hull() <= 0.1 and not yularen_escaped then
				yularen_escaped = true
				Find_First_Object("YULAREN_RESOLUTE").Make_Invulnerable(true)
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
			end
			if not TestValid(Find_First_Object("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN")) and not TestValid(Find_First_Object("GRIEVOUS_MUNIFICENT")) and not TestValid(Find_First_Object("MUNIFICENT_SUBFACTION")) and not grievous_escaped then
				grievous_escaped = true
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
			end
		end
	elseif p_republic.Is_Human() then
		if act_1_active then
			if Find_First_Object("YULAREN_RESOLUTE").Get_Hull() <= 0.1 and not yularen_escaped then
				yularen_escaped = true
				Find_First_Object("YULAREN_RESOLUTE").Make_Invulnerable(true)
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
			end
			if not TestValid(Find_First_Object("ANAKIN_DELTA")) and not anakin_crashed then
				anakin_crashed = true
			end
			if not TestValid(Find_First_Object("GRIEVOUS_MUNIFICENT")) and not TestValid(Find_First_Object("MUNIFICENT_SUBFACTION")) and not grievous_escaped then
				grievous_escaped = true
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
			end
		end
	end
end

function Start_Cinematic_Crawl_CIS()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true)

	cinematic_crawl = true
	if (GlobalValue.Get("Rimward_CIS_GC_Version") == 0) then
		MissionUtil.PlayCinematicMovieCrawl("Rimward_Campaign_Intro", "Clone_Wars_Crawl_Theme")
	else
		MissionUtil.PlayCinematicMovieCrawl("Rimward_Campaign_AU_Intro", "Clone_Wars_Crawl_Theme")
	end

	if not cinematic_crawl_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
	end
end
function Start_Cinematic_Intro_CIS()
	cinematic_crawl = false
	if (GlobalValue.Get("Rimward_CIS_GC_Version") == 0) then
		Find_First_Object("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN").Despawn()
		player_grievous = Find_First_Object("GRIEVOUS_MUNIFICENT")
		grievous_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "grievous-1")
		grievous_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "grievous-2")
	else
		Find_First_Object("GRIEVOUS_MUNIFICENT").Despawn()
		player_grievous = Find_First_Object("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN")
		grievous_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "grievous-1-au")
		grievous_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "grievous-2-au")
	end

	player_dauntless = MissionUtil.SpawnUnitSpace("VENATOR_STAR_DESTROYER", dauntless_marker, p_republic, 1)
	player_pioneer = MissionUtil.SpawnUnitSpace("VENATOR_STAR_DESTROYER", pioneer_marker, p_republic, 1)

	cinematic_one = true

	local hide_me_table = Find_All_Objects_Of_Type("Structure", p_republic)
	for i,hide_me in pairs(hide_me_table) do
		hide_me.Hide(true)
		Hide_Object(hide_me, 1)
	end

	MissionUtil.PlayGenericSpeech("Bothawui_Business_01")
	MissionUtil.PlayGenericMusic("Silence_Theme")

	MissionUtil.TransitionCinematicCamera(introcam_1_marker, introcam_target_yularen_marker, true, 14.0, nil, nil)
	Letter_Box_In(1.0)
	Sleep(14.0)

	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_yularen_marker, true, 13.0, nil, nil)
	Sleep(13.0)

	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_yularen_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_yularen_marker, true, 15.0, nil, nil)
	Sleep(10.0)

	Fade_Screen_Out(3.0)
	Sleep(3.0)

	despawn_me_table = Find_All_Objects_With_Hint("despawn-1")
	for i,despawn_me in pairs(despawn_me_table) do
		despawn_me.Despawn()
	end

	Sleep(1.0)

	MissionUtil.CinematicIntroHeader("BOTHAWUI_BUSINESS")

	player_munificent_1.Teleport_And_Face(muni1_1_marker)
	player_munificent_1.Cinematic_Hyperspace_In(70)

	player_munificent_2.Teleport_And_Face(muni2_1_marker)
	player_munificent_2.Cinematic_Hyperspace_In(70)

	player_munificent_3.Teleport_And_Face(muni3_1_marker)
	player_munificent_3.Cinematic_Hyperspace_In(70)

	player_munificent_4.Teleport_And_Face(muni4_1_marker)
	player_munificent_4.Cinematic_Hyperspace_In(70)

	player_munificent_5.Teleport_And_Face(muni5_1_marker)
	player_munificent_5.Cinematic_Hyperspace_In(70)

	player_grievous.Despawn()
	player_grievous = MissionUtil.SpawnUnitSpace("GRIEVOUS_MUNIFICENT", grievous_1_marker, p_cis, 100)

	Sleep(9.0)

	MissionUtil.TransitionCinematicCamera(introcam_7_marker, introcam_target_grievous_1_marker, true, 9.0, nil, nil)
	Sleep(7.5)

	player_grievous.Move_To(grievous_move_to)
	player_munificent_1.Move_To(muni1_move_to)
	player_munificent_2.Move_To(muni2_move_to)
	player_munificent_3.Move_To(muni3_move_to)
	player_munificent_4.Move_To(muni4_move_to)
	player_munificent_5.Move_To(muni5_move_to)

	Fade_Screen_In(0.1)
	MissionUtil.SetCinematicCamera(introcam_9_marker, introcam_target_grievous_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_10_marker, introcam_target_grievous_2_marker, true, 20.0, nil, nil)
	Sleep(17.0)

	local rep_fighters = Find_All_Objects_Of_Type(p_republic, "Fighter | Bomber")
	for _,repfighters in pairs(rep_fighters) do
		if TestValid(repfighters) then
			repfighters.Attack_Move(player_munificent_1)
		end
	end

	local hide_me_table = Find_All_Objects_Of_Type("Structure", p_republic)
	for i,hide_me in pairs(hide_me_table) do
		hide_me.Hide(false)
		Hide_Object(hide_me, 0)
	end

	player_yularen.Suspend_Locomotor(true)
	player_pioneer.Suspend_Locomotor(true)
	player_dauntless.Suspend_Locomotor(true)

	player_grievous.Make_Invulnerable(false)
	player_munificent_1.Make_Invulnerable(false)
	player_munificent_2.Make_Invulnerable(false)
	player_munificent_3.Make_Invulnerable(false)
	player_munificent_4.Make_Invulnerable(false)
	player_munificent_5.Make_Invulnerable(false)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end
function End_Cinematic_Intro_CIS()
	MissionUtil.EndCinematicCamera(grievous_2_marker, 3.5)
	Sleep(3.5)

	MissionUtil.AIActivation()
	MissionUtil.SetObjectiveMissionSet("BOTHAWUI_BUSINESS", "CIS", 3)

	local cis_fleet = Find_All_Objects_Of_Type(p_cis, "Capital | Frigate")
	for _,cis_ships in pairs(cis_fleet) do
		if TestValid(cis_ships) then
			cis_ships.Attack_Move(player_pioneer)
		end
	end

	if TestValid(Find_First_Object("SOULLESS_ONE")) and TestValid(player_anakin) then
		Find_First_Object("SOULLESS_ONE").Attack_Move(player_anakin)
	end

	Sleep(2.0)

	current_cinematic_thread_id = nil

	cinematic_one = false
	act_1_active = true

	Register_Timer(State_Trap_Active, 25)

	MissionUtil.CinematicEnvironmentOff()
end

function Start_Cinematic_Outro_CIS()
	act_1_active = false
	cinematic_two = true

	Fade_Screen_Out(2.0)
	Sleep(2.5)

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	if not anakin_crashed then
		anakin_crashed = true

		MissionUtil.MissionTextSpeech("BOTHAWUI_BUSINESS", 11, 7.0, nil, {r = 250, g = 44, b = 44}) -- Anakin Skywalker
		MissionUtil.PlayGenericSpeech("Bothawui_Business_03")
		MissionUtil.PlayGenericMusic("Silence_Theme")
		Sleep(8.0)

	end
	if yularen_escaped and not anakin_rescued then
		Fade_Screen_In(1.5)
		Letter_Box_In(1.5)

		MissionUtil.PlayGenericMusic("Trade_Federation_Theme")

		if TestValid(player_yularen) then
			player_yularen.Turn_To_Face(retreat_marker)
		end
		if TestValid(player_pioneer) then
			player_pioneer.Turn_To_Face(retreat_marker)
		end
		if TestValid(player_dauntless) then
			player_dauntless.Turn_To_Face(retreat_marker)
		end

		MissionUtil.SetCinematicCamera(outrocam_1_marker, outrocam_target_1_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outrocam_target_2_marker, true, 25.0, nil, nil)
		MissionUtil.MissionTextSpeech("BOTHAWUI_BUSINESS", 1, 8.0, nil, {r = 250, g = 44, b = 44})
		Sleep(8.5)

		MissionUtil.MissionTextSpeech("BOTHAWUI_BUSINESS", 2, 8.0, nil, {r = 250, g = 44, b = 44})
		Sleep(8.5)

		MissionUtil.MissionTextSpeech("BOTHAWUI_BUSINESS", 3, 7.0, nil, {r = 250, g = 44, b = 44})
		Sleep(1.5)

		if TestValid(player_yularen) then
			player_yularen.Hyperspace_Away(false)
		end
		if TestValid(player_pioneer) then
			player_pioneer.Hyperspace_Away(false)
		end
		if TestValid(player_dauntless) then
			player_dauntless.Hyperspace_Away(false)
		end
		Sleep(2.0)

		Fade_Screen_Out(1.0)
		Sleep(1.5)

		player_twilight = MissionUtil.SpawnUnitSpace("TWILIGHT_MISSION", outro_1_twilight_marker, p_republic, 150)
		player_twilight.Override_Max_Speed(15)
		player_twilight.Move_To(outro_2_twilight_marker)

		Fade_Screen_In(1.0)

		MissionUtil.SetCinematicCamera(outrocam_3_marker, outro_1_twilight_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(outrocam_4_marker, outro_1_twilight_marker, true, 15.0, nil, nil)
		Sleep(2.0)

		MissionUtil.MissionTextSpeech("BOTHAWUI_BUSINESS", 9, 7.0, nil, {r = 250, g = 44, b = 44})
		Sleep(5.0)

		Fade_Screen_Out(1.0)
		Sleep(2.0)

		GlobalValue.Set("Rimward_Bothawui_Business_Outcome", 0) -- 0 = CIS Victory, 1 = Republic Victory
		MissionUtil.CinematicEnvironmentOff()
		StoryUtil.DeclareVictory(p_cis, false)

	elseif yularen_escaped and anakin_rescued then
		Fade_Screen_In(1.5)
		Letter_Box_In(1.5)

		MissionUtil.PlayGenericMusic("Trade_Federation_Theme")

		if TestValid(player_yularen) then
			player_yularen.Turn_To_Face(retreat_marker)
		end
		if TestValid(player_pioneer) then
			player_pioneer.Turn_To_Face(retreat_marker)
		end
		if TestValid(player_dauntless) then
			player_dauntless.Turn_To_Face(retreat_marker)
		end

		MissionUtil.SetCinematicCamera(outrocam_1_marker, outrocam_target_1_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outrocam_target_2_marker, true, 25.0, nil, nil)
		MissionUtil.MissionTextSpeech("BOTHAWUI_BUSINESS", 7, 7.0, nil, {r = 250, g = 44, b = 44})
		Sleep(7.0)

		if TestValid(player_yularen) then
			player_yularen.Hyperspace_Away(false)
		end
		if TestValid(player_pioneer) then
			player_pioneer.Hyperspace_Away(false)
		end
		if TestValid(player_dauntless) then
			player_dauntless.Hyperspace_Away(false)
		end
		Sleep(1.0)

		Fade_Screen_Out(1.0)
		Sleep(2.0)
		MissionUtil.CinematicEnvironmentOff()
		GlobalValue.Set("Rimward_Bothawui_Business_Outcome", 0) -- 0 = CIS Victory, 1 = Republic Victory
		StoryUtil.DeclareVictory(p_cis, false)

	elseif grievous_escaped and not anakin_rescued then
		Fade_Screen_In(1.5)
		Letter_Box_In(1.5)

		MissionUtil.PlayGenericMusic("Trade_Federation_Theme")

		if TestValid(player_yularen) then
			player_yularen.Turn_To_Face(retreat_marker)
		end
		if TestValid(player_pioneer) then
			player_pioneer.Turn_To_Face(retreat_marker)
		end
		if TestValid(player_dauntless) then
			player_dauntless.Turn_To_Face(retreat_marker)
		end

		MissionUtil.SetCinematicCamera(outrocam_1_marker, outrocam_target_1_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outrocam_target_2_marker, true, 25.0, nil, nil)
		MissionUtil.MissionTextSpeech("BOTHAWUI_BUSINESS", 4, 8.0, nil, {r = 250, g = 44, b = 44})
		Sleep(8.5)

		MissionUtil.MissionTextSpeech("BOTHAWUI_BUSINESS", 5, 8.0, nil, {r = 250, g = 44, b = 44})
		Sleep(8.5)

		MissionUtil.MissionTextSpeech("BOTHAWUI_BUSINESS", 6, 7.0, nil, {r = 250, g = 44, b = 44})
		Sleep(3.5)

		Fade_Screen_Out(1.0)
		Sleep(1.5)

		player_twilight = MissionUtil.SpawnUnitSpace("TWILIGHT_MISSION", outro_1_twilight_marker, p_republic, 150)
		player_twilight.Override_Max_Speed(15)
		player_twilight.Move_To(outro_2_twilight_marker)

		Fade_Screen_In(1.0)
		MissionUtil.SetCinematicCamera(outrocam_3_marker, outro_1_twilight_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(outrocam_4_marker, outro_1_twilight_marker, true, 15.0, nil, nil)
		Sleep(2.0)

		MissionUtil.MissionTextSpeech("BOTHAWUI_BUSINESS", 9, 7.0, nil, {r = 250, g = 44, b = 44})
		Sleep(5.0)

		Fade_Screen_Out(1.0)
		Sleep(2.0)

		MissionUtil.CinematicEnvironmentOff()
		GlobalValue.Set("Rimward_Bothawui_Business_Outcome", 1) -- 0 = CIS Victory, 1 = Republic Victory
		StoryUtil.DeclareVictory(p_republic, false)

	elseif grievous_escaped and anakin_rescued then
		Fade_Screen_In(1.5)
		Letter_Box_In(1.5)

		MissionUtil.PlayGenericMusic("Trade_Federation_Theme")

		MissionUtil.SetCinematicCamera(outrocam_1_marker, outrocam_target_1_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outrocam_target_2_marker, true, 25.0, nil, nil)
		MissionUtil.MissionTextSpeech("BOTHAWUI_BUSINESS", 8, 9.0, nil, {r = 250, g = 44, b = 44})
		Sleep(9.5)

		Fade_Screen_Out(2.0)
		Sleep(2.5)

		GlobalValue.Set("Rimward_Bothawui_Business_Outcome", 1) -- 0 = CIS Victory, 1 = Republic Victory
		MissionUtil.CinematicEnvironmentOff()
		StoryUtil.DeclareVictory(p_republic, false)
	end
end

function Start_Cinematic_Crawl_Rep()
	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	MissionUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true)

	cinematic_crawl = true
	MissionUtil.PlayCinematicMovieCrawl("Rimward_Campaign_Intro", "Clone_Wars_Crawl_Theme")

	if not cinematic_crawl_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
	end
end
function Start_Cinematic_Intro_Rep()
	cinematic_crawl = false

	Find_First_Object("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN").Despawn()
	player_grievous = Find_First_Object("GRIEVOUS_MUNIFICENT")
	grievous_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "grievous-1")
	grievous_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "grievous-2")

	player_dauntless = MissionUtil.SpawnUnitSpace("VENATOR_STAR_DESTROYER", dauntless_marker, p_republic, 1)
	player_pioneer = MissionUtil.SpawnUnitSpace("VENATOR_STAR_DESTROYER", pioneer_marker, p_republic, 1)

	cinematic_one = true

	MissionUtil.PlayGenericSpeech("Bothawui_Business_01")
	MissionUtil.PlayGenericMusic("Silence_Theme")

	MissionUtil.TransitionCinematicCamera(introcam_1_marker, introcam_target_yularen_marker, true, 14.0, nil, nil)
	Letter_Box_In(1.0)
	Sleep(14.0)

	MissionUtil.TransitionCinematicCamera(introcam_2_marker, introcam_target_yularen_marker, true, 13.0, nil, nil)
	Sleep(13.0)

	MissionUtil.SetCinematicCamera(introcam_3_marker, introcam_target_yularen_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_4_marker, introcam_target_yularen_marker, true, 15.0, nil, nil)
	Sleep(10.0)

	Fade_Screen_Out(3.0)
	Sleep(3.0)

	local despawn_me_table = Find_All_Objects_With_Hint("despawn-1")
	for i,despawn_me in pairs(despawn_me_table) do
		despawn_me.Despawn()
	end

	Sleep(1.0)

	Fade_Screen_In(1.0)
	MissionUtil.SetCinematicCamera(introcam_5_marker, introcam_target_grievous_1_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_6_marker, introcam_target_grievous_1_marker, true, 11.0, nil, nil)
	Sleep(1.0)

	MissionUtil.CinematicIntroHeader("BOTHAWUI_BUSINESS")

	player_munificent_1.Teleport_And_Face(muni1_1_marker)
	player_munificent_1.Cinematic_Hyperspace_In(70)

	player_munificent_2.Teleport_And_Face(muni2_1_marker)
	player_munificent_2.Cinematic_Hyperspace_In(70)

	player_munificent_3.Teleport_And_Face(muni3_1_marker)
	player_munificent_3.Cinematic_Hyperspace_In(70)

	player_munificent_4.Teleport_And_Face(muni4_1_marker)
	player_munificent_4.Cinematic_Hyperspace_In(70)

	player_munificent_5.Teleport_And_Face(muni5_1_marker)
	player_munificent_5.Cinematic_Hyperspace_In(70)

	player_grievous.Despawn()
	player_grievous = MissionUtil.SpawnUnitSpace("GRIEVOUS_MUNIFICENT", grievous_1_marker, p_cis, 100)

	Sleep(9.0)

	MissionUtil.TransitionCinematicCamera(introcam_7_marker, introcam_target_grievous_1_marker, true, 9.0, nil, nil)
	Sleep(7.5)

	player_grievous.Move_To(grievous_move_to)
	player_munificent_1.Move_To(muni1_move_to)
	player_munificent_2.Move_To(muni2_move_to)
	player_munificent_3.Move_To(muni3_move_to)
	player_munificent_4.Move_To(muni4_move_to)
	player_munificent_5.Move_To(muni5_move_to)

	Fade_Screen_In(0.1)
	MissionUtil.SetCinematicCamera(introcam_9_marker, introcam_target_grievous_2_marker, true, nil, nil)
	MissionUtil.TransitionCinematicCamera(introcam_10_marker, introcam_target_grievous_2_marker, true, 20.0, nil, nil)
	Sleep(17.0)

	local rep_fighters = Find_All_Objects_Of_Type(p_republic, "Fighter | Bomber")
	for _,repfighters in pairs(rep_fighters) do
		if TestValid(repfighters) then
			repfighters.Attack_Move(player_munificent_1)
		end
	end

	local hide_me_table = Find_All_Objects_Of_Type("Structure", p_republic)
	for i,hide_me in pairs(hide_me_table) do
		hide_me.Hide(false)
		Hide_Object(hide_me, 0)
	end

	player_grievous.Make_Invulnerable(false)
	player_munificent_1.Make_Invulnerable(false)
	player_munificent_2.Make_Invulnerable(false)
	player_munificent_3.Make_Invulnerable(false)
	player_munificent_4.Make_Invulnerable(false)
	player_munificent_5.Make_Invulnerable(false)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Rep")
	end
end
function End_Cinematic_Intro_Rep()
	MissionUtil.EndCinematicCamera(yularen_marker, 3.5)
	Sleep(3.5)

	MissionUtil.AIActivation()
	MissionUtil.SetObjectiveMissionSet("BOTHAWUI_BUSINESS", "REP", 4)

	local cis_fleet = Find_All_Objects_Of_Type(p_cis, "Capital | Frigate")
	for _,cis_ships in pairs(cis_fleet) do
		if TestValid(cis_ships) then
			cis_ships.Attack_Move(player_pioneer)
		end
	end

	if TestValid(Find_First_Object("SOULLESS_ONE")) and TestValid(player_anakin) then
		Find_First_Object("SOULLESS_ONE").Attack_Move(player_anakin)
	end

	Register_Timer(State_Trap_Active, 25)

	current_cinematic_thread_id = nil

	cinematic_one = false
	act_1_active = true

	Sleep(2.0)

	MissionUtil.CinematicEnvironmentOff()
end

function Start_Cinematic_Outro_Rep()
	act_1_active = false
	cinematic_two = true

	Fade_Screen_Out(2.0)
	Sleep(2.5)

	MissionUtil.StartCinematicCamera()
	MissionUtil.CinematicEnvironmentOn()

	if not anakin_crashed then
		anakin_crashed = true

		MissionUtil.MissionTextSpeech("BOTHAWUI_BUSINESS", 11, 7.0, nil, {r = 250, g = 44, b = 44}) -- Anakin Skywalker
		MissionUtil.PlayGenericSpeech("Bothawui_Business_03")
		MissionUtil.PlayGenericMusic("Silence_Theme")
		Sleep(8.0)

	end
	if yularen_escaped and not anakin_rescued then
		Fade_Screen_In(1.5)
		Letter_Box_In(1.5)

		MissionUtil.PlayGenericMusic("Trade_Federation_Theme")

		if TestValid(player_yularen) then
			player_yularen.Turn_To_Face(retreat_marker)
		end
		if TestValid(player_pioneer) then
			player_pioneer.Turn_To_Face(retreat_marker)
		end
		if TestValid(player_dauntless) then
			player_dauntless.Turn_To_Face(retreat_marker)
		end

		MissionUtil.SetCinematicCamera(outrocam_1_marker, outrocam_target_1_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outrocam_target_2_marker, true, 25.0, nil, nil)
		MissionUtil.MissionTextSpeech("BOTHAWUI_BUSINESS", 1, 8.0, nil, {r = 250, g = 44, b = 44})
		Sleep(8.5)

		MissionUtil.MissionTextSpeech("BOTHAWUI_BUSINESS", 2, 8.0, nil, {r = 250, g = 44, b = 44})
		Sleep(8.5)

		MissionUtil.MissionTextSpeech("BOTHAWUI_BUSINESS", 3, 7.0, nil, {r = 250, g = 44, b = 44})
		Sleep(1.5)

		if TestValid(player_yularen) then
			player_yularen.Hyperspace_Away(false)
		end
		if TestValid(player_pioneer) then
			player_pioneer.Hyperspace_Away(false)
		end
		if TestValid(player_dauntless) then
			player_dauntless.Hyperspace_Away(false)
		end
		Sleep(2.0)

		Fade_Screen_Out(1.0)
		Sleep(1.5)

		player_twilight = MissionUtil.SpawnUnitSpace("TWILIGHT_MISSION", outro_1_twilight_marker, p_republic, 150)
		player_twilight.Override_Max_Speed(15)
		player_twilight.Move_To(outro_2_twilight_marker)

		Fade_Screen_In(1.0)

		MissionUtil.SetCinematicCamera(outrocam_3_marker, outrocam_target_1_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(outrocam_4_marker, outrocam_target_2_marker, true, 15.0, nil, nil)
		Sleep(2.0)

		MissionUtil.MissionTextSpeech("BOTHAWUI_BUSINESS", 9, 7.0, nil, {r = 250, g = 44, b = 44})
		Sleep(5.0)

		Fade_Screen_Out(1.0)
		Sleep(2.0)

		GlobalValue.Set("Rimward_Bothawui_Business_Outcome", 0) -- 0 = CIS Victory, 1 = Republic Victory
		MissionUtil.CinematicEnvironmentOff()
		StoryUtil.DeclareVictory(p_cis, false)

	elseif yularen_escaped and anakin_rescued then
		Fade_Screen_In(1.5)
		Letter_Box_In(1.5)

		MissionUtil.PlayGenericMusic("Trade_Federation_Theme")

		if TestValid(player_yularen) then
			player_yularen.Turn_To_Face(retreat_marker)
		end
		if TestValid(player_pioneer) then
			player_pioneer.Turn_To_Face(retreat_marker)
		end
		if TestValid(player_dauntless) then
			player_dauntless.Turn_To_Face(retreat_marker)
		end

		MissionUtil.SetCinematicCamera(outrocam_1_marker, outrocam_target_1_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outrocam_target_2_marker, true, 25.0, nil, nil)
		MissionUtil.MissionTextSpeech("BOTHAWUI_BUSINESS", 7, 7.0, nil, {r = 250, g = 44, b = 44})
		Sleep(7.0)

		if TestValid(player_yularen) then
			player_yularen.Hyperspace_Away(false)
		end
		if TestValid(player_pioneer) then
			player_pioneer.Hyperspace_Away(false)
		end
		if TestValid(player_dauntless) then
			player_dauntless.Hyperspace_Away(false)
		end
		Sleep(1.0)

		Fade_Screen_Out(1.0)
		Sleep(2.0)
		MissionUtil.CinematicEnvironmentOff()
		GlobalValue.Set("Rimward_Bothawui_Business_Outcome", 0) -- 0 = CIS Victory, 1 = Republic Victory
		StoryUtil.DeclareVictory(p_cis, false)

	elseif grievous_escaped and not anakin_rescued then
		Fade_Screen_In(1.5)
		Letter_Box_In(1.5)

		MissionUtil.PlayGenericMusic("Trade_Federation_Theme")

		if TestValid(player_yularen) then
			player_yularen.Turn_To_Face(retreat_marker)
		end
		if TestValid(player_pioneer) then
			player_pioneer.Turn_To_Face(retreat_marker)
		end
		if TestValid(player_dauntless) then
			player_dauntless.Turn_To_Face(retreat_marker)
		end

		MissionUtil.SetCinematicCamera(outrocam_1_marker, outrocam_target_1_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outrocam_target_2_marker, true, 25.0, nil, nil)
		MissionUtil.MissionTextSpeech("BOTHAWUI_BUSINESS", 4, 8.0, nil, {r = 250, g = 44, b = 44})
		Sleep(8.5)

		MissionUtil.MissionTextSpeech("BOTHAWUI_BUSINESS", 5, 8.0, nil, {r = 250, g = 44, b = 44})
		Sleep(8.5)

		MissionUtil.MissionTextSpeech("BOTHAWUI_BUSINESS", 6, 7.0, nil, {r = 250, g = 44, b = 44})
		Sleep(3.5)

		Fade_Screen_Out(1.0)
		Sleep(1.5)

		player_twilight = MissionUtil.SpawnUnitSpace("TWILIGHT_MISSION", outro_1_twilight_marker, p_republic, 150)
		player_twilight.Override_Max_Speed(15)
		player_twilight.Move_To(outro_2_twilight_marker)

		Fade_Screen_In(1.0)
		MissionUtil.SetCinematicCamera(outrocam_3_marker, outro_1_twilight_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(outrocam_4_marker, outro_1_twilight_marker, true, 15.0, nil, nil)
		Sleep(2.0)

		MissionUtil.MissionTextSpeech("BOTHAWUI_BUSINESS", 9, 7.0, nil, {r = 250, g = 44, b = 44})
		Sleep(5.0)

		Fade_Screen_Out(1.0)
		Sleep(2.0)

		MissionUtil.CinematicEnvironmentOff()
		GlobalValue.Set("Rimward_Bothawui_Business_Outcome", 1) -- 0 = CIS Victory, 1 = Republic Victory
		StoryUtil.DeclareVictory(p_republic, false)

	elseif grievous_escaped and anakin_rescued then
		Fade_Screen_In(1.5)
		Letter_Box_In(1.5)

		MissionUtil.PlayGenericMusic("Trade_Federation_Theme")

		MissionUtil.SetCinematicCamera(outrocam_1_marker, outrocam_target_1_marker, true, nil, nil)
		MissionUtil.TransitionCinematicCamera(outrocam_2_marker, outrocam_target_2_marker, true, 25.0, nil, nil)
		MissionUtil.MissionTextSpeech("BOTHAWUI_BUSINESS", 8, 9.0, nil, {r = 250, g = 44, b = 44})
		Sleep(9.5)

		Fade_Screen_Out(2.0)
		Sleep(2.5)

		GlobalValue.Set("Rimward_Bothawui_Business_Outcome", 1) -- 0 = CIS Victory, 1 = Republic Victory
		MissionUtil.CinematicEnvironmentOff()
		StoryUtil.DeclareVictory(p_republic, false)
	end
end