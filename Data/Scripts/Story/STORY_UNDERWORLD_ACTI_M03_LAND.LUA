-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_ActI_M03_LAND.lua#1 $
--/////////////////////////////////////////////////////////////////////////////////////////////////
--
-- (C) Petroglyph Games, Inc.
--
--
--  *****           **                          *                   *
--  *   **          *                           *                   *
--  *    *          *                           *                   *
--  *    *          *     *                 *   *          *        *
--  *   *     *** ******  * **  ****      ***   * *      * *****    * ***
--  *  **    *  *   *     **   *   **   **  *   *  *    * **   **   **   *
--  ***     *****   *     *   *     *  *    *   *  *   **  *    *   *    *
--  *       *       *     *   *     *  *    *   *   *  *   *    *   *    *
--  *       *       *     *   *     *  *    *   *   * **   *   *    *    *
--  *       **       *    *   **   *   **   *   *    **    *  *     *   *
-- **        ****     **  *    ****     *****   *    **    ***      *   *
--                                          *        *     *
--                                          *        *     *
--                                          *       *      *
--                                      *  *        *      *
--                                      ****       *       *
--
--/////////////////////////////////////////////////////////////////////////////////////////////////
-- C O N F I D E N T I A L   S O U R C E   C O D E -- D O   N O T   D I S T R I B U T E
--/////////////////////////////////////////////////////////////////////////////////////////////////
--
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Underworld_ActI_M03_LAND.lua $
--
--    Original Author: Jeff_Stewart
--
--            $Author: Brian_Hayes $
--
--            $Change: 637819 $
--
--          $DateTime: 2017/03/22 10:16:16 $
--
--          $Revision: #1 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("JGS_FunctionLib") -- added library of commonly used functions
require("PGSpawnUnits")
require("PGStoryMode")

function Definitions()
	StoryModeEvents = 
	{
		Underworld_A01M03_Begin = State_Underworld_A01M03_Begin
	}
	
	hutt_defense_team_01 = 
	{
		"Hutt_Soldier_Squad"
	}

	hutt_defense_team_02 = 
	{
		"Hutt_PLEX_Soldier_Squad"
	}

	hutt_defense_team_03 = 
	{
		"Hutt_PLEX_Soldier_Squad",
		"Hutt_Pod_Walker_Team"
	}

	hutt_defense_team_04 = 
	{
		"Hutt_Soldier_Squad"
	}

	hutt_defense_team_05 = 
	{
		"Hutt_Skiff_Team"
	}

	hutt_assault_team_01 = 
	{
		"Hutt_Swamp_Speeder_Team"
	}
	
	hutt_assault_team_02 = 
	{
		"Hutt_Soldier_Squad"
	}
	
	hutt_assault_team_03 = 
	{
		"Hutt_Soldier_Squad"
	}
end

function State_Underworld_A01M03_Begin(message)
	if message == OnEnter then
	
		Initialize_Mission_Variables()
		Initialize_Cinematic_Variables()
		if TestValid(urai_fen) then
			current_cine_id = Create_Thread("CINE_Start_Mission")
		end
		
	elseif message == OnUpdate then
	
		if not VictoryStarted and not DefeatStarted then
			if not hutts_near_reinforcement and not hutt_midtro_complete then
				hutt_midtro_complete = true
				cm_uraimove.Cancel_Event_Object_In_Range(Prox_Check_For_Hutts)
				Story_Event("MIDTRO_DIALOG_DONE")
			end
			if DefeatCondition_UraiDead then
				DefeatStarted = true
				Create_Thread("EndMissionDefeat")
			end
			local hutt_check = Find_Nearest(ci_urai, hutt_player, true)
			if not TestValid(hutt_check) then
				VictoryStarted = true
				Create_Thread("EndMissionVictory")				
			end
			if midtro_cinematic_done then
				hutts_near_reinforcement = false
			end
		end
				
	end
end

function Initialize_Mission_Variables()

	VictoryStarted = false
	DefeatStarted = false
	DefeatCondition_UraiDead = false
	
	neutral_player = Find_Player("Neutral")
	underworld_player = Find_Player("Underworld")
	hutt_player = Find_Player("Hutts")

	palace = Find_Hint("HUTT_COMMAND_CENTER_PALACE","huttpalace")

	hu_infantry1 = Find_Hint("STORY_TRIGGER_ZONE", "hu-infantry1")
	hu_infantry2 = Find_Hint("STORY_TRIGGER_ZONE", "hu-infantry2")
	hu_infantry3 = Find_Hint("STORY_TRIGGER_ZONE", "hu-infantry3")
	hu_guard1 = Find_Hint("STORY_TRIGGER_ZONE", "hu-guard1")
	hu_guard2 = Find_Hint("STORY_TRIGGER_ZONE", "hu-guard2")
	hu_guard3 = Find_Hint("STORY_TRIGGER_ZONE", "hu-guard3")
	hu_point1 = Find_Hint("STORY_TRIGGER_ZONE", "hu-point1")
	hu_point2 = Find_Hint("STORY_TRIGGER_ZONE", "hu-point2")
	hu_point3 = Find_Hint("STORY_TRIGGER_ZONE", "hu-point3")
	hu_point4 = Find_Hint("STORY_TRIGGER_ZONE", "hu-point4")
	hu_point5 = Find_Hint("STORY_TRIGGER_ZONE", "hu-point5")
	
	ci_urai = Find_Hint("STORY_TRIGGER_ZONE", "ci-urai")
	ci_soldiers1 = Find_Hint("STORY_TRIGGER_ZONE", "ci-soldiers1")
	ci_soldiers2 = Find_Hint("STORY_TRIGGER_ZONE", "ci-soldiers2")
	ci_rpguys = Find_Hint("STORY_TRIGGER_ZONE", "ci-rpguys")

	ci_soldiers1move = Find_Hint("STORY_TRIGGER_ZONE", "ci-soldiers1move")
	ci_soldiers2move = Find_Hint("STORY_TRIGGER_ZONE", "ci-soldiers2move")
	ci_camera1 = Find_Hint("STORY_TRIGGER_ZONE", "ci-camera1")
	ci_uraimove = Find_Hint("STORY_TRIGGER_ZONE", "ci-uraimove")
	ci_camera2 = Find_Hint("STORY_TRIGGER_ZONE", "ci-camera2")
	ci_mine1 = Find_Hint("STORY_TRIGGER_ZONE", "ci-mine1")
	ci_mine2 = Find_Hint("STORY_TRIGGER_ZONE", "ci-mine2")
	ci_mine3 = Find_Hint("STORY_TRIGGER_ZONE", "ci-mine3")
	ci_mine4 = Find_Hint("STORY_TRIGGER_ZONE", "ci-mine4")
	ci_mine5 = Find_Hint("STORY_TRIGGER_ZONE", "ci-mine5")
	ci_camera3 = Find_Hint("STORY_TRIGGER_ZONE", "ci-camera3")
	ci_bombsound = Find_Hint("STORY_TRIGGER_ZONE", "bombsound")

	cm_prox = Find_Hint("STORY_TRIGGER_ZONE", "cm-prox")
	cm_uraimove = Find_Hint("STORY_TRIGGER_ZONE", "cm-uraimove")
	cm_camera1 = Find_Hint("STORY_TRIGGER_ZONE", "cm-camera1")
	cm_hutts1 = Find_Hint("STORY_TRIGGER_ZONE", "cm-hutts1")
	cm_hutts2 = Find_Hint("STORY_TRIGGER_ZONE", "cm-hutts2")
	cm_hutts3 = Find_Hint("STORY_TRIGGER_ZONE", "cm-hutts3")
	cm_hutts4 = Find_Hint("STORY_TRIGGER_ZONE", "cm-hutts4")
	cm_hutts5 = Find_Hint("STORY_TRIGGER_ZONE", "cm-hutts5")
	cm_camera2 = Find_Hint("STORY_TRIGGER_ZONE", "cm-camera2")
	
	urai_fen = Find_First_Object("URAI_FEN")
	urai_soldiers_01_list = Spawn_Unit(Find_Object_Type("UNDERWORLD_MERC_SQUAD"), ci_soldiers1.Get_Position(), underworld_player)
	urai_soldiers_01 = urai_soldiers_01_list[1]
	urai_soldiers_02_list = Spawn_Unit(Find_Object_Type("UNDERWORLD_MERC_SQUAD"), ci_soldiers2.Get_Position(), underworld_player)
	urai_soldiers_02 = urai_soldiers_02_list[1]
	local urai_soldiers = Spawn_Unit(Find_Object_Type("UNDERWORLD_MERC_SQUAD"), ci_soldiers1move.Get_Position(), underworld_player)
	urai_soldiers = Spawn_Unit(Find_Object_Type("UNDERWORLD_MERC_SQUAD"), ci_camera1.Get_Position(), underworld_player)
	urai_soldiers = Spawn_Unit(Find_Object_Type("Underworld_Disruptor_Merc_Squad"), ci_soldiers2move.Get_Position(), underworld_player)
	
	spawn_hutt_speeders	= false
	midtro_cinematic_done = false
	enable_hutt_ai = false
	hutts_near_reinforcement = true
	hutt_midtro_complete = false
	
	Register_Death_Event(urai_fen, Urai_Fen_Destroyed)

	Register_Prox(hu_point4, Prox_Enable_Hutt_AI, 175, underworld_player)
end

function Initialize_Cinematic_Variables()
	CINE_Intro_Active = false
	
	kill_prox_active = false
		
	mine1 = nil
	mine2 = nil
	mine3 = nil
	mine4 = nil
	mine5 = nil	
end

---------------------------------------------------------------------------------
-- COMMON FUNCTIONS

function Prox_Enable_Hutt_AI(prox_obj, trigger_obj)

	enable_hutt_ai = false
	
	if TestValid(trigger_obj) then
		if trigger_obj.Has_Ability("STEALTH") then
			if trigger_obj.Is_Ability_Active("STEALTH") then
				trigger_obj.Activate_Ability("STEALTH", false)
				enable_hutt_ai = true
			end
		end
		enable_hutt_ai = true
	end
	
	if enable_hutt_ai then
		prox_obj.Cancel_Event_Object_In_Range(Prox_Enable_Hutt_AI)
		hutt_unit_list = Find_All_Objects_Of_Type(hutt_player)
		for i,unit in pairs (hutt_unit_list) do
			unit.Prevent_AI_Usage(false)
		end
	end
end

function Urai_Fen_Destroyed()
	DefeatCondition_UraiDead = true
end

function Timer_Spawn_Hutt_Defenses()

	-- HU_POINT1
	local closest_enemy = Find_Nearest(hu_point1, underworld_player, true)
	local closest_friend = Find_Nearest(hu_point1, hutt_player, true)
	if TestValid(closest_enemy) and TestValid(closest_friend) then
		local distance_hu_point1_hutt = hu_point1.Get_Distance(closest_friend)
		local distance_hu_point1_under = hu_point1.Get_Distance(closest_enemy)
		if distance_hu_point1_hutt > 50 then
			if distance_hu_point1_under > 200 then
				local hutt_defense_team = SpawnList(hutt_defense_team_01, hu_point1.Get_Position(), hutt_player, false, true)
				for i, unit in pairs (hutt_defense_team) do
					unit.Guard_Target(hu_point1.Get_Position())
				end
			end
		end
	end

	-- HU_POINT3
	local closest_enemy = Find_Nearest(hu_point3, underworld_player, true)
	local closest_friend = Find_Nearest(hu_point3, hutt_player, true)
	if TestValid(closest_enemy) and TestValid(closest_friend) then
		local distance_hu_point3_hutt = hu_point3.Get_Distance(closest_friend)
		local distance_hu_point3_under = hu_point3.Get_Distance(closest_enemy)
		if distance_hu_point3_hutt > 50 then
			if distance_hu_point3_under > 200 then
				local hutt_defense_team = SpawnList(hutt_defense_team_03, hu_point3.Get_Position(), hutt_player, false, true)
				for i, unit in pairs (hutt_defense_team) do
					unit.Guard_Target(hu_point3.Get_Position())
				end
			end
		end
	end

	-- HU_POINT4
	local closest_enemy = Find_Nearest(hu_point4, underworld_player, true)
	local closest_friend = Find_Nearest(hu_point4, hutt_player, true)
	if TestValid(closest_enemy) and TestValid(closest_friend) then
		local distance_hu_point4_hutt = hu_point4.Get_Distance(closest_friend)
		local distance_hu_point4_under = hu_point4.Get_Distance(closest_enemy)
		if distance_hu_point4_hutt > 50 then
			if distance_hu_point4_under > 200 then
				local hutt_defense_team = SpawnList(hutt_defense_team_04, hu_point4.Get_Position(), hutt_player, false, true)
				for i, unit in pairs (hutt_defense_team) do
					unit.Guard_Target(hu_point4.Get_Position())
				end
			end
		end
	end
	
	-- HU_GUARD1
	local closest_enemy = Find_Nearest(hu_infantry1, underworld_player, true)
	local closest_friend = Find_Nearest(hu_guard1, hutt_player, true)
	if TestValid(closest_enemy) and TestValid(closest_friend) then
		local distance_hu_guard1_hutt = hu_guard1.Get_Distance(closest_friend)
		local distance_hu_guard1_under = hu_infantry1.Get_Distance(closest_enemy)
		if distance_hu_guard1_hutt > 50 then
			if distance_hu_guard1_under > 200 then
				local hutt_defense_team = SpawnList(hutt_defense_team_01, hu_guard1.Get_Position(), hutt_player, false, true)
				for i, unit in pairs (hutt_defense_team) do
					unit.Guard_Target(hu_guard1.Get_Position())
				end
			end
		end
	end
	
	-- HU_GUARD3
	local closest_enemy = Find_Nearest(hu_infantry3, underworld_player, true)
	local closest_friend = Find_Nearest(hu_guard3, hutt_player, true)
	if TestValid(closest_enemy) and TestValid(closest_friend) then
		local distance_hu_guard3_hutt = hu_guard3.Get_Distance(closest_friend)
		local distance_hu_guard3_under = hu_infantry3.Get_Distance(closest_enemy)
		if distance_hu_guard3_hutt > 50 then
			if distance_hu_guard3_under > 200 then
				local hutt_defense_team = SpawnList(hutt_defense_team_03, hu_guard3.Get_Position(), hutt_player, false, true)
				for i, unit in pairs (hutt_defense_team) do
					unit.Guard_Target(hu_guard3.Get_Position())
				end
			end
		end
	end	

end

function Timer_Spawn_Hutt_Assault()
	local closest_enemy = Find_Nearest(hu_infantry1, underworld_player, true)
	if TestValid(closest_enemy) then
	
		if spawn_hutt_speeders then
			local distance_hu_infantry1_under = hu_infantry1.Get_Distance(closest_enemy)
			if distance_hu_infantry1_under > 200 then
				local hutt_assault_team = SpawnList(hutt_assault_team_01, hu_infantry1.Get_Position(), hutt_player, false, true)
				for i, unit in pairs (hutt_assault_team) do
					unit.Attack_Move(ci_uraimove.Get_Position())
				end
			end
		end

		local distance_hu_infantry2_under = hu_infantry2.Get_Distance(closest_enemy)
		if distance_hu_infantry2_under > 200 then
			local hutt_assault_team = SpawnList(hutt_assault_team_02, hu_infantry2.Get_Position(), hutt_player, false, true)
			for i, unit in pairs (hutt_assault_team) do
				unit.Attack_Move(ci_uraimove.Get_Position())
			end
		end
	end
end

function Timer_Spawn_Hutt_Speeders()
	spawn_hutt_speeders = true
end

function Prox_Check_For_Hutts(prox_obj, trigger_obj)
	hutts_near_reinforcement = true
end

---------------------------------------------------------------------------------
-- MIDTRO CINEMATIC

function Prox_Midtro_Cinematic(prox_obj, trigger_obj)
	if trigger_obj == urai_fen then
		prox_obj.Cancel_Event_Object_In_Range(Prox_Midtro_Cinematic)
		Create_Thread("Midtro_Cinematic")
	else
		trigger_obj.Take_Damage(10000)
	end
end

function Midtro_Cinematic()
	if not DefeatStarted then
		Cancel_Fast_Forward()
		Suspend_AI(1)
		Lock_Controls(1)
		Fade_Screen_Out(1)
		Sleep(1)
		Letter_Box_In(0)
		Start_Cinematic_Camera()

		urai_fen.Teleport_And_Face(cm_prox)
		urai_fen.Move_To(cm_uraimove.Get_Position())
		urai_fen.Activate_Ability("STEALTH", false)
		urai_fen.Prevent_Opportunity_Fire(true)
		urai_fen.Make_Invulnerable(true)
		urai_fen.Set_Cannot_Be_Killed(true)

		Set_Cinematic_Camera_Key(cm_camera1.Get_Position(), 0, 0, 0, 0, 0, 0, 0)
		Set_Cinematic_Target_Key(urai_fen, 0, 0, 0, 0, urai_fen, 0, 0)
		Fade_Screen_In(2)
		Sleep(3)
		
		local hutt_assault_team1 = SpawnList(hutt_assault_team_03, cm_hutts1.Get_Position(), hutt_player, false, true)
		for i,unit in pairs (hutt_assault_team1) do
			unit.Prevent_Opportunity_Fire(true)
			unit.Turn_To_Face(urai_fen)
		end
		local hutt_assault_team2 = SpawnList(hutt_assault_team_03, cm_hutts2.Get_Position(), hutt_player, false, true)
		for i,unit in pairs (hutt_assault_team2) do
			unit.Prevent_Opportunity_Fire(true)
			unit.Turn_To_Face(urai_fen)
		end
		
		Set_Cinematic_Camera_Key(cm_camera2.Get_Position(), 0, 0, 0, 0, 0, 0, 0)
		Set_Cinematic_Target_Key(cm_hutts1.Get_Position(), 0, 0, 0, 0, 0, 0, 0, 0)
		Transition_Cinematic_Target_Key(cm_hutts2.Get_Position(), 8, 0, 0, 0, 0, 0, 0, 0)
		Story_Event("MIDTRO_DIALOG_00")
		Sleep(6)
		
		Set_Cinematic_Target_Key(urai_fen, 0, 0, 0, 0, 0, 0, 0, 0)
		Story_Event("MIDTRO_DIALOG_01")
		Sleep(5)
		
		Transition_To_Tactical_Camera(2)
		Letter_Box_Out(1)
		Sleep(2)
		End_Cinematic_Camera()
		Lock_Controls(0)
		Suspend_AI(0)

		Remove_Radar_Blip("destination")
		Register_Prox(cm_uraimove, Prox_Check_For_Hutts, 200, hutt_player)
		
		hutt_unit_list = Find_All_Objects_Of_Type(hutt_player)
		for i,unit in pairs (hutt_unit_list) do
			unit.Prevent_Opportunity_Fire(false)
		end
		urai_fen.Prevent_Opportunity_Fire(false)
		urai_fen.Make_Invulnerable(false)
		urai_fen.Set_Cannot_Be_Killed(false)
		midtro_cinematic_done = true
	end
end

---------------------------------------------------------------------------------
-- INTRO CINEMATIC

function CINE_Start_Mission()
	
	CINE_Intro_Active = true
	
	Cancel_Fast_Forward()
	
	intro_camera_start = Find_Hint("STORY_TRIGGER_ZONE_00","introcamerastart")
	transport_land = Find_Hint("STORY_TRIGGER_ZONE","transportland")
	intro_goto = Find_Hint("STORY_TRIGGER_ZONE","introgoto")
	intro_spawn = Find_Hint("STORY_TRIGGER_ZONE","introspawn")
		
	Suspend_AI(1)
	Lock_Controls(1)
	Fade_Screen_Out(0)
	Letter_Box_In(0)
	Fade_Screen_In(1)
	Start_Cinematic_Camera()
	
	transport = Create_Cinematic_Transport("Underworld_Vehicle_Transport_Landing_Saleucami_CIN", underworld_player.Get_ID(), transport_land, 20, 1, .3, 17, 0)
	transport.Play_SFX_Event("Unit_Star_Destroyer_Cinematic_Engine_Loop")
	Transition_Cinematic_Camera_Key(intro_camera_start, 0, 0, 0, 40, 0, 0, 0, 0)
	Set_Cinematic_Target_Key(transport, 0, 0, 0, 0, transport, 0, 1)
	
	--Sleep(2)
	Transition_Cinematic_Camera_Key(transport_land, 10, 500, 65, 10, 1, 0, 0, 0)

	Sleep(7)
	Transition_Cinematic_Target_Key(transport_land, 4, 50, 0, 180, 1, 0, 0, 0)
	if TestValid(urai_fen) then
		urai_fen.Teleport_And_Face(intro_spawn)
		Sleep(1)
		urai_fen.Move_To(intro_goto)
	end
	
	rp_soldiers0 = Spawn_Unit(Find_Object_Type("UNDERWORLD_MERC_SQUAD"), intro_spawn.Get_Position(), underworld_player)
	Sleep(1)
	for i,unit in pairs(rp_soldiers0) do
		if TestValid(unit) then
			--MessageBox("moving units")
			unit.Move_To(intro_goto)
		end
	end
	Sleep(1)
	rp_soldiers1 = Spawn_Unit(Find_Object_Type("UNDERWORLD_MERC_SQUAD"), intro_spawn.Get_Position(), underworld_player)
	Sleep(1)
	for i,unit in pairs(rp_soldiers1) do
		if TestValid(unit) then
			--MessageBox("moving units")
			unit.Move_To(intro_goto)
		end
	end
	Allow_Localized_SFX(true)
	transport_land.Play_SFX_Event("Saleucami_Attack_Move_00")
	Allow_Localized_SFX(false)
	Sleep(1)
	rp_soldiers2 = Spawn_Unit(Find_Object_Type("UNDERWORLD_MERC_SQUAD"), intro_spawn.Get_Position(), underworld_player)
	Sleep(1)
	for i,unit in pairs(rp_soldiers2) do
		if TestValid(unit) then
			--MessageBox("moving units")
			unit.Move_To(intro_goto)
		end
	end
	Sleep(1)
	rp_soldiers3 = Spawn_Unit(Find_Object_Type("UNDERWORLD_MERC_SQUAD"), intro_spawn.Get_Position(), underworld_player)
	
	Allow_Localized_SFX(true)
	transport_land.Play_SFX_Event("Saleucami_Attack_Move_01")
	Allow_Localized_SFX(false)

	Sleep(8)
	for i,unit in pairs(urai_soldiers_01_list) do
		if TestValid(unit) then
			unit.Attack_Target(palace)
		end
	end
	
	for i,unit in pairs(urai_soldiers_02_list) do
		if TestValid(unit) then
			unit.Attack_Target(palace)
		end
	end
	Sleep(2)
	Set_Cinematic_Camera_Key(ci_camera1.Get_Position(), 0, 0, 0, 0, 0, 0, 0)
	Set_Cinematic_Target_Key(urai_fen, 0, 0, 0, 0, urai_fen, 0, 0)
	
	for i,unit in pairs(rp_soldiers0) do
		if TestValid(unit) then
			unit.Despawn()
		end
	end
	for i,unit in pairs(rp_soldiers1) do
		if TestValid(unit) then
			unit.Despawn()
		end
	end
	for i,unit in pairs(rp_soldiers2) do
		if TestValid(unit) then
			unit.Despawn()
		end
	end
	
	-- Urai moves up the hill with infantry behind.
	urai_fen.Teleport_And_Face(ci_urai)
	urai_fen.Move_To(ci_uraimove.Get_Position())
	
	--urai_soldiers_01.Move_To(ci_soldiers1move.Get_Position())
	--urai_soldiers_02.Move_To(ci_soldiers2move.Get_Position())
	Sleep(1)
	
	Story_Event("INTRO_DIALOG_00")
	Sleep(15)
	
	mine1 = Create_Generic_Object("DEMOLITION_BOMB", ci_mine1.Get_Position(), underworld_player)
	mine2 = Create_Generic_Object("DEMOLITION_BOMB", ci_mine2.Get_Position(), underworld_player)
	mine3 = Create_Generic_Object("DEMOLITION_BOMB", ci_mine3.Get_Position(), underworld_player)
	mine4 = Create_Generic_Object("DEMOLITION_BOMB", ci_mine4.Get_Position(), underworld_player)
	mine5 = Create_Generic_Object("DEMOLITION_BOMB", ci_mine5.Get_Position(), underworld_player)
	
	Set_Cinematic_Camera_Key(ci_camera2.Get_Position(), 0, 0, 0, 0, 0, 0, 0)
	Set_Cinematic_Target_Key(ci_rpguys.Get_Position(), 0, 0, 0, 0, 0, 0, 0)
	Transition_Cinematic_Camera_Key(ci_camera2.Get_Position(), 6, 0, 0, 50, 0, 0, 0, 0)
	Transition_Cinematic_Target_Key(ci_mine5.Get_Position(), 6, 0, 0, 0, 0, 0, 0, 0)

	urai_fen.Teleport_And_Face(ci_uraimove)
	
	Story_Event("INTRO_DIALOG_01")
	Sleep(10)

	mine1.Take_Damage(10000)
	Create_Generic_Object("HUGE_EXPLOSION_LAND", ci_mine1.Get_Position(), underworld_player)
	mine1.Despawn()
	mine2.Take_Damage(10000)
	--Create_Generic_Object("HUGE_EXPLOSION_LAND", ci_mine2.Get_Position(), underworld_player)
	mine2.Despawn()
	mine3.Take_Damage(10000)
	Create_Generic_Object("HUGE_EXPLOSION_LAND", ci_mine3.Get_Position(), underworld_player)
	mine3.Despawn()
	mine4.Take_Damage(10000)
	--Create_Generic_Object("HUGE_EXPLOSION_LAND", ci_mine4.Get_Position(), underworld_player)
	mine4.Despawn()
	mine5.Take_Damage(10000)
	Create_Generic_Object("HUGE_EXPLOSION_LAND", ci_mine5.Get_Position(), underworld_player)
	mine5.Despawn()
	
	reinforce_point = Find_All_Objects_With_Hint("entryspot")
	reinforce_point[1].Change_Owner(neutral_player)
	
	for i,unit in pairs(rp_soldiers3) do
		if TestValid(unit) then
			unit.Take_Damage(10000)
		end
	end
	
	local mine_list = Find_All_Objects_Of_Type("DEMOLITION_BOMB")
	for i,unit in pairs (mine_list) do
		if TestValid(unit) then
			unit.Despawn()
		end
	end
	
	if TestValid(palace) then
		palace.Take_Damage(10000)
	end
	
	Create_Thread("M03_Audio_Repeat")
	
	Sleep(3)
	Set_Cinematic_Camera_Key(ci_camera3.Get_Position(), 0, 0, 0, 0, 0, 0, 0)
	Set_Cinematic_Target_Key(urai_fen.Get_Position(), 0, 0, 10, 0, 0, 0, 0)
	
	kill_prox_active = true
	Register_Prox(ci_rpguys, Prox_Kill_Cinematic_Guys, 500, underworld_player)
	Register_Timer(Timer_Stop_Killing, 5)
	
	Story_Event("INTRO_DIALOG_02")
	Sleep(8)
	
	Create_Thread("IntroCineCleanup")
end

function M03_Audio_Repeat()
	ci_camera3.Play_SFX_Event("Unit_Katarn_Building_Bomb_SFX")
	Sleep(0.3)
	ci_camera3.Play_SFX_Event("Unit_Katarn_Building_Bomb_SFX")
	Sleep(0.3)
	ci_camera3.Play_SFX_Event("Unit_Katarn_Building_Bomb_SFX")
end

function Story_Handle_Esc()
	if CINE_Intro_Active then 
		CINE_Intro_Active = false
		Thread.Kill(current_cine_id)
		Create_Thread("IntroCineCleanup")
	end
end

function IntroCineCleanup()

	current_cine_id = nil
	CINE_Intro_Active = false

	-- Move all player units to appropriate locations.
	urai_fen.Teleport_And_Face(ci_uraimove)
	urai_soldiers_01.Move_To(ci_soldiers1move.Get_Position())
	urai_soldiers_02.Move_To(ci_soldiers2move.Get_Position())
	
	if not kill_prox_active then 
		Register_Prox(ci_rpguys, Prox_Kill_Cinematic_Guys, 500, underworld_player)
		Register_Timer(Timer_Stop_Killing, 5)
	end
	
	Register_Timer(Timer_Spawn_Hutt_Defenses, 5)
	Register_Timer(Timer_Spawn_Hutt_Assault, 5)
	Register_Timer(Timer_Spawn_Hutt_Speeders, 1)
			
	if TestValid (mine1) then
		mine1.Hide(true)
		mine1.Despawn()
	end
	if TestValid (mine2) then
		mine2.Hide(true)
		mine2.Despawn()
	end
	if TestValid (mine3) then
		mine3.Hide(true)
		mine3.Despawn()
	end
	if TestValid (mine4) then
		mine4.Hide(true)
		mine4.Despawn()
	end
	if TestValid (mine5) then
		mine5.Hide(true)
		mine5.Despawn()
	end
	
	local mine_list = Find_All_Objects_Of_Type("DEMOLITION_BOMB")
	for i,unit in pairs (mine_list) do
		if TestValid(unit) then
			unit.Despawn()
		end
	end

	Add_Radar_Blip(cm_uraimove, "destination")

	reinforce_point = Find_All_Objects_With_Hint("entryspot")
	reinforce_point[1].Change_Owner(neutral_player)
		
	local mine_list = Find_All_Objects_Of_Type("DEMOLITION_BOMB")
	for i,unit in pairs (mine_list) do
		if TestValid(unit) then
			unit.Despawn()
		end
	end
	
	if TestValid(palace) then
		palace.Take_Damage(10000)
	end
	
	Stop_All_Music()
	Stop_All_Speech()
	Remove_All_Text()
	Allow_Localized_SFX(true)
	Transition_To_Tactical_Camera(2)
	Letter_Box_Out(1)	
	Sleep(2)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Suspend_AI(0)	
end

function Prox_Kill_Cinematic_Guys(prox_obj, trigger_obj)
	trigger_obj.Take_Damage(10000)
end

function Timer_Stop_Killing()
	ci_rpguys.Cancel_Event_Object_In_Range(Prox_Kill_Cinematic_Guys)
	Register_Prox(cm_prox, Prox_Midtro_Cinematic, 150, underworld_player)
end

---------------------------------------------------------------------------------
-- VICTORY AND DEFEAT

function EndMissionVictory()
	Cancel_Fast_Forward()
	Story_Event("UM03_ENDMISSION_VICTORY")	
end

function EndMissionDefeat()
	Cancel_Fast_Forward()
	Story_Event("UM03_ENDMISSION_DEFEAT")
end
