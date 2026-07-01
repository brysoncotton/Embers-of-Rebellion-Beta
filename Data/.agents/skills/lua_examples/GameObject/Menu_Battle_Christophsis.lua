--***************************************************--
--********* Main Menu Christophsis Script ***********--
--***************************************************--

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")

function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))

	Define_State("State_Init", State_Init)

	battle_one_active = false
	
	cinematic_cam_active = false

	-- Players
	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")

end

function State_Init(message)
	if message == OnEnter then

		if Get_Game_Mode() ~= "Land" then
			return
		end
		
		-- Markers CIS
		cis_tridroid_1_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_tridroid_1")
		cis_tridroid_2_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_tridroid_2")
		cis_tridroid_3_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_tridroid_3")
		cis_tridroid_4_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_tridroid_4")
		cis_tridroid_5_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_tridroid_5")
		cis_tridroid_6_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_tridroid_6")
		
		cis_b1_1_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b1_1")
		cis_b1_2_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b1_2")
		cis_b1_3_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b1_3")
		cis_b1_4_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b1_4")
		cis_b1_5_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b1_5")
		cis_b1_6_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b1_6")
		cis_b1_7_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b1_7")
		cis_b1_8_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b1_8")
		cis_b1_9_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b1_9")
		cis_b1_10_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b1_10")
		
		cis_b2_1_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b2_1")
		cis_b2_2_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b2_2")
		cis_b2_3_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b2_3")
		cis_b2_4_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b2_4")
		cis_b2_5_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b2_5")
		cis_b2_6_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b2_6")
		
		cis_lr57_1_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_lr57_1")
		cis_lr57_2_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_lr57_2")
		
		-- Markers GAR
		command_post_1_marker = Find_Hint("MARKER_GENERIC_PURPLE", "base1")

		republic_atte_1_marker = Find_Hint("MARKER_GENERIC_RED", "republic_atte_1")
		republic_atte_2_marker = Find_Hint("MARKER_GENERIC_RED", "republic_atte_2")
		republic_atte_3_marker = Find_Hint("MARKER_GENERIC_RED", "republic_atte_3")
		republic_atte_4_marker = Find_Hint("MARKER_GENERIC_RED", "republic_atte_4")
		
		republic_atrt_1_marker = Find_Hint("MARKER_GENERIC_RED", "republic_atrt_1")
		republic_atrt_2_marker = Find_Hint("MARKER_GENERIC_RED", "republic_atrt_2")
		republic_atrt_3_marker = Find_Hint("MARKER_GENERIC_RED", "republic_atrt_3")
		republic_atrt_4_marker = Find_Hint("MARKER_GENERIC_RED", "republic_atrt_4")
		republic_atrt_5_marker = Find_Hint("MARKER_GENERIC_RED", "republic_atrt_5")
		republic_atrt_6_marker = Find_Hint("MARKER_GENERIC_RED", "republic_atrt_6")
		
		republic_clone_phase1_1_marker = Find_Hint("MARKER_GENERIC_RED", "republic_clone_phase1_1")
		republic_clone_phase1_2_marker = Find_Hint("MARKER_GENERIC_RED", "republic_clone_phase1_2")
		republic_clone_phase1_3_marker = Find_Hint("MARKER_GENERIC_RED", "republic_clone_phase1_3")
		republic_clone_phase1_4_marker = Find_Hint("MARKER_GENERIC_RED", "republic_clone_phase1_4")
		republic_clone_phase1_5_marker = Find_Hint("MARKER_GENERIC_RED", "republic_clone_phase1_5")
		republic_clone_phase1_6_marker = Find_Hint("MARKER_GENERIC_RED", "republic_clone_phase1_6")
		republic_clone_phase1_7_marker = Find_Hint("MARKER_GENERIC_RED", "republic_clone_phase1_7")
		republic_clone_phase1_8_marker = Find_Hint("MARKER_GENERIC_RED", "republic_clone_phase1_8")
		republic_clone_phase1_9_marker = Find_Hint("MARKER_GENERIC_RED", "republic_clone_phase1_9")
		republic_clone_phase1_10_marker = Find_Hint("MARKER_GENERIC_RED", "republic_clone_phase1_10")
		
		republic_av7_1_marker = Find_Hint("AV7_SPAWN_MARKER", "republic_av7_1")
		republic_av7_2_marker = Find_Hint("AV7_SPAWN_MARKER", "republic_av7_2")
		republic_av7_3_marker = Find_Hint("AV7_SPAWN_MARKER", "republic_av7_3")
		republic_av7_4_marker = Find_Hint("AV7_SPAWN_MARKER", "republic_av7_4")
		
		--Unit List CIS
		tridroid_list =
		{
			"MAGNA_OCTUPTARRA"
		}
		
		b1_droid_list =
		{
			"B1_GEO_DROID_COMPANY"
		}
		
		b2_droid_list =
		{
			"B2_DROID_COMPANY"
		}
		
		lr57_droid_list =
		{
			"LR_57_COMBAT_DROID_COMPANY"
		}
		
		--Unit List GAR
		
		atte_list = 
		{
			"REPUBLIC_AT_TE_WALKER"
		}
		
		atrt_list =
		{
			"REPUBLIC_AT_RT_WALKER"
		}
		
		clone_phase1_list =
		{
			"CLONETROOPER_PHASE_ONE_COMPANY"
		}
		
		av7_list =
		{
			"AV7"
		}
		
		--Camera Markers
		cam_1_start_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam_1_start_marker")
		cam_1_mid_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam_1_mid_marker")
		cam_1_end_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam_1_end_marker")
		
		cam_2_start_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam_2_start_marker")
		cam_2_mid_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam_2_mid_marker")
		cam_2_end_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam_2_end_marker")
		
		cam_3_start_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam_3_start_marker")
		cam_3_mid_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam_3_mid_marker")
		cam_3_end_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam_3_end_marker")
		
		cam_4_start_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam_4_start_marker")
		cam_4_mid_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam_4_mid_marker")
		cam_4_end_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam_4_end_marker")
		
		cam_av7_start_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam_av7_start_marker")
		cam_av7_end_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam_av7_end_marker")

		Create_Thread("Battle_One_Begins")
	end
end

function State_Spawn_Battle()
	
	--CIS Army
	--Tridroid
	tridroid_01 = SpawnList(tridroid_list, cis_tridroid_1_marker.Get_Position(), p_cis, true, true)
	tridroid_02 = SpawnList(tridroid_list, cis_tridroid_2_marker.Get_Position(), p_cis, true, true)
	tridroid_03 = SpawnList(tridroid_list, cis_tridroid_3_marker.Get_Position(), p_cis, true, true)
	tridroid_04 = SpawnList(tridroid_list, cis_tridroid_4_marker.Get_Position(), p_cis, true, true)
	tridroid_05 = SpawnList(tridroid_list, cis_tridroid_5_marker.Get_Position(), p_cis, true, true)
	tridroid_06 = SpawnList(tridroid_list, cis_tridroid_6_marker.Get_Position(), p_cis, true, true)
	
	--B1
	b1_01 = SpawnList(b1_droid_list, cis_b1_1_marker.Get_Position(), p_cis, true, true)
	b1_02 = SpawnList(b1_droid_list, cis_b1_2_marker.Get_Position(), p_cis, true, true)
	b1_03 = SpawnList(b1_droid_list, cis_b1_3_marker.Get_Position(), p_cis, true, true)
	b1_04 = SpawnList(b1_droid_list, cis_b1_4_marker.Get_Position(), p_cis, true, true)
	b1_05 = SpawnList(b1_droid_list, cis_b1_5_marker.Get_Position(), p_cis, true, true)
	b1_06 = SpawnList(b1_droid_list, cis_b1_6_marker.Get_Position(), p_cis, true, true)
	b1_07 = SpawnList(b1_droid_list, cis_b1_7_marker.Get_Position(), p_cis, true, true)
	b1_08 = SpawnList(b1_droid_list, cis_b1_8_marker.Get_Position(), p_cis, true, true)
	b1_09 = SpawnList(b1_droid_list, cis_b1_9_marker.Get_Position(), p_cis, true, true)
	b1_10 = SpawnList(b1_droid_list, cis_b1_10_marker.Get_Position(), p_cis, true, true)

	--B2
	b2_01 = SpawnList(b2_droid_list, cis_b2_1_marker.Get_Position(), p_cis, true, true)
	b2_02 = SpawnList(b2_droid_list, cis_b2_2_marker.Get_Position(), p_cis, true, true)
	b2_03 = SpawnList(b2_droid_list, cis_b2_3_marker.Get_Position(), p_cis, true, true)
	b2_04 = SpawnList(b2_droid_list, cis_b2_4_marker.Get_Position(), p_cis, true, true)
	b2_05 = SpawnList(b2_droid_list, cis_b2_5_marker.Get_Position(), p_cis, true, true)
	b2_06 = SpawnList(b2_droid_list, cis_b2_6_marker.Get_Position(), p_cis, true, true)
	
	--LR57
	lr57_01 = SpawnList(lr57_droid_list, cis_lr57_1_marker.Get_Position(), p_cis, true, true)
	lr57_02 = SpawnList(lr57_droid_list, cis_lr57_2_marker.Get_Position(), p_cis, true, true)
	
	--Republic Army

	command_post = Find_Object_Type("REPUBLIC_FIELD_COMMANDO_BASE")

	command_post_1_list = Spawn_Unit(command_post, command_post_1_marker, p_republic)
	player_command_base_1 = command_post_1_list[1]
	player_command_base_1.Teleport_And_Face(command_post_1_marker)
	player_command_base_1.Set_Cannot_Be_Killed(true)

	--AT-TE
	atte_01 = SpawnList(atte_list, republic_atte_1_marker.Get_Position(),p_republic, true, true)
	atte_02 = SpawnList(atte_list, republic_atte_2_marker.Get_Position(),p_republic, true, true)
	atte_03 = SpawnList(atte_list, republic_atte_3_marker.Get_Position(),p_republic, true, true)
	atte_04 = SpawnList(atte_list, republic_atte_4_marker.Get_Position(),p_republic, true, true)
	
	--AV7
	av7_01 = SpawnList(av7_list, republic_av7_1_marker.Get_Position(),p_republic, true, true)
	av7_02 = SpawnList(av7_list, republic_av7_2_marker.Get_Position(),p_republic, true, true)
	av7_03 = SpawnList(av7_list, republic_av7_3_marker.Get_Position(),p_republic, true, true)
	av7_04 = SpawnList(av7_list, republic_av7_4_marker.Get_Position(),p_republic, true, true)
	
	--AT-RT
	atrt_01 = SpawnList(atrt_list, republic_atrt_1_marker.Get_Position(),p_republic, true, true)
	atrt_02 = SpawnList(atrt_list, republic_atrt_2_marker.Get_Position(),p_republic, true, true)
	atrt_03 = SpawnList(atrt_list, republic_atrt_3_marker.Get_Position(),p_republic, true, true)
	atrt_04 = SpawnList(atrt_list, republic_atrt_4_marker.Get_Position(),p_republic, true, true)
	atrt_05 = SpawnList(atrt_list, republic_atrt_5_marker.Get_Position(),p_republic, true, true)
	atrt_06 = SpawnList(atrt_list, republic_atrt_6_marker.Get_Position(),p_republic, true, true)
	
	--Clone Phase 1
	clone_01 = SpawnList(clone_phase1_list, republic_clone_phase1_1_marker.Get_Position(),p_republic, true, true)
	clone_02 = SpawnList(clone_phase1_list, republic_clone_phase1_2_marker.Get_Position(),p_republic, true, true)
	clone_03 = SpawnList(clone_phase1_list, republic_clone_phase1_3_marker.Get_Position(),p_republic, true, true)
	clone_04 = SpawnList(clone_phase1_list, republic_clone_phase1_4_marker.Get_Position(),p_republic, true, true)
	clone_05 = SpawnList(clone_phase1_list, republic_clone_phase1_5_marker.Get_Position(),p_republic, true, true)
	clone_06 = SpawnList(clone_phase1_list, republic_clone_phase1_6_marker.Get_Position(),p_republic, true, true)
	clone_07 = SpawnList(clone_phase1_list, republic_clone_phase1_7_marker.Get_Position(),p_republic, true, true)
	clone_08 = SpawnList(clone_phase1_list, republic_clone_phase1_8_marker.Get_Position(),p_republic, true, true)
	clone_09 = SpawnList(clone_phase1_list, republic_clone_phase1_9_marker.Get_Position(),p_republic, true, true)
	clone_10 = SpawnList(clone_phase1_list, republic_clone_phase1_10_marker.Get_Position(),p_republic, true, true)
	
	--Create_Thread("State_Attack_Target")
end

function State_Attack_Target()

	-- Attack AT-TE 1
	for i,unit in pairs(tridroid_01) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_1_marker)
		end
	end
	
	for i,unit in pairs(tridroid_02) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_1_marker)
		end
	end
	
	for i,unit in pairs(tridroid_03) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_1_marker)
		end
	end
	
	for i,unit in pairs(b1_01) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_1_marker)
		end
	end
	
	for i,unit in pairs(b1_02) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_1_marker)
		end
	end
	
	for i,unit in pairs(b1_03) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_1_marker)
		end
	end
	
	for i,unit in pairs(b1_04) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_1_marker)
		end
	end
	
	for i,unit in pairs(b1_05) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_1_marker)
		end
	end
	
	for i,unit in pairs(b2_01) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_1_marker)
		end
	end
	
	for i,unit in pairs(b2_02) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_1_marker)
		end
	end
	
	for i,unit in pairs(b2_03) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_1_marker)
		end
	end
	
	for i,unit in pairs(lr57_01) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_1_marker)
		end
	end
	
	-- Attack AT-TE 2
	for i,unit in pairs(tridroid_04) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_2_marker)
		end
	end
	
	for i,unit in pairs(tridroid_05) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_2_marker)
		end
	end
	
	for i,unit in pairs(tridroid_06) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_2_marker)
		end
	end
	
	for i,unit in pairs(b1_06) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_2_marker)
		end
	end
	
	for i,unit in pairs(b1_07) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_2_marker)
		end
	end
	
	for i,unit in pairs(b1_08) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_2_marker)
		end
	end
	
	for i,unit in pairs(b1_09) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_2_marker)
		end
	end
	
	for i,unit in pairs(b1_10) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_2_marker)
		end
	end
	
	for i,unit in pairs(b2_04) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_2_marker)
		end
	end
	
	for i,unit in pairs(b2_05) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_2_marker)
		end
	end
	
	for i,unit in pairs(b2_06) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_2_marker)
		end
	end
	
	for i,unit in pairs(lr57_02) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_2_marker)
		end
	end
end

function Battle_Cinematic_Camera()
    Start_Cinematic_Camera()

	Fade_On()	
	Fade_Screen_In(2)
	
	Set_Cinematic_Camera_Key(cam_3_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_3_start_marker, 0, 0, 0, 0, cam_3_mid_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_3_end_marker, 12, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_3_end_marker, 12, 0, 0, 0, 0, cam_3_mid_marker, 1, 0)
	Sleep(10)
	
	local cis_attack_list = Find_All_Objects_Of_Type(p_cis)
	for g,cisattack01 in pairs(cis_attack_list) do
		if TestValid(cisattack01) then
			if TestValid(player_command_base_1) then
				cisattack01.Attack_Move(player_command_base_1)
			end
		end
	end

	Set_Cinematic_Camera_Key(cam_1_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_1_start_marker, 0, 0, 0, 0, cam_1_mid_marker, 0, 0)
	Transition_Cinematic_Camera_Key(cam_1_end_marker, 17, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_1_end_marker, 17, 0, 0, 0, 0, cam_1_mid_marker, 1, 0)
	Sleep(15)
	
	Set_Cinematic_Camera_Key(cam_2_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_2_start_marker, 0, 0, 0, 0, cam_2_mid_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_2_end_marker, 17, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_2_end_marker, 17, 0, 0, 0, 0, cam_2_mid_marker, 1, 0)
	Sleep(15)
	
	closest_av7 = Find_Nearest(cam_3_mid_marker, "AV7")

	Set_Cinematic_Camera_Key(cam_av7_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_av7_start_marker, 0, 0, 0, 0, closest_av7, 1, 0)
	Transition_Cinematic_Camera_Key(cam_av7_end_marker, 12, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_av7_end_marker, 12, 0, 0, 0, 0, closest_av7, 1, 0)
	Sleep(10)
	
	Set_Cinematic_Camera_Key(cam_2_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_2_start_marker, 0, 0, 0, 0, cam_2_mid_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_2_end_marker, 17, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_2_end_marker, 17, 0, 0, 0, 0, cam_2_mid_marker, 1, 0)
	Sleep(15)
	
	Set_Cinematic_Camera_Key(cam_1_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_1_start_marker, 0, 0, 0, 0, cam_1_mid_marker, 0, 0)
	Transition_Cinematic_Camera_Key(cam_1_end_marker, 17, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_1_end_marker, 17, 0, 0, 0, 0, cam_1_mid_marker, 1, 0)
	Sleep(15)
	
	Set_Cinematic_Camera_Key(cam_3_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_3_start_marker, 0, 0, 0, 0, cam_3_mid_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_3_end_marker, 12, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_3_end_marker, 12, 0, 0, 0, 0, cam_3_mid_marker, 1, 0)
	Sleep(10)
	
	Set_Cinematic_Camera_Key(cam_1_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_1_start_marker, 0, 0, 0, 0, cam_1_mid_marker, 0, 0)
	Transition_Cinematic_Camera_Key(cam_1_end_marker, 17, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_1_end_marker, 17, 0, 0, 0, 0, cam_1_mid_marker, 1, 0)
	Sleep(15)
	
	Set_Cinematic_Camera_Key(cam_2_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_2_start_marker, 0, 0, 0, 0, cam_2_mid_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_2_end_marker, 17, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_2_end_marker, 17, 0, 0, 0, 0, cam_2_mid_marker, 1, 0)
	Sleep(15)
	
	--Total 80 secs	
    current_cinematic_thread_id = Create_Thread("Battle_Cinematic_Camera_Loop")
end

function Battle_Cinematic_Camera_Loop()
	Set_Cinematic_Camera_Key(cam_3_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_3_start_marker, 0, 0, 0, 0, cam_3_mid_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_3_end_marker, 12, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_3_end_marker, 12, 0, 0, 0, 0, cam_3_mid_marker, 1, 0)
	Sleep(10)
	
	local cis_attack_list = Find_All_Objects_Of_Type(p_cis)
	for g,cisattack01 in pairs(cis_attack_list) do
		if TestValid(cisattack01) then
			if TestValid(player_command_base_1) then
				cisattack01.Attack_Move(player_command_base_1)
			end
		end
	end

	Set_Cinematic_Camera_Key(cam_1_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_1_start_marker, 0, 0, 0, 0, cam_1_mid_marker, 0, 0)
	Transition_Cinematic_Camera_Key(cam_1_end_marker, 17, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_1_end_marker, 17, 0, 0, 0, 0, cam_1_mid_marker, 1, 0)
	Sleep(15)
	
	Set_Cinematic_Camera_Key(cam_2_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_2_start_marker, 0, 0, 0, 0, cam_2_mid_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_2_end_marker, 17, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_2_end_marker, 17, 0, 0, 0, 0, cam_2_mid_marker, 1, 0)
	Sleep(15)
	
	closest_av7 = Find_Nearest(cam_3_mid_marker, "AV7")

	Set_Cinematic_Camera_Key(cam_av7_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_av7_start_marker, 0, 0, 0, 0, closest_av7, 1, 0)
	Transition_Cinematic_Camera_Key(cam_av7_end_marker, 12, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_av7_end_marker, 12, 0, 0, 0, 0, closest_av7, 1, 0)
	Sleep(10)
	
	Set_Cinematic_Camera_Key(cam_2_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_2_start_marker, 0, 0, 0, 0, cam_2_mid_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_2_end_marker, 17, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_2_end_marker, 17, 0, 0, 0, 0, cam_2_mid_marker, 1, 0)
	Sleep(15)
	
	Set_Cinematic_Camera_Key(cam_1_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_1_start_marker, 0, 0, 0, 0, cam_1_mid_marker, 0, 0)
	Transition_Cinematic_Camera_Key(cam_1_end_marker, 17, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_1_end_marker, 17, 0, 0, 0, 0, cam_1_mid_marker, 1, 0)
	Sleep(15)
	
	Set_Cinematic_Camera_Key(cam_3_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_3_start_marker, 0, 0, 0, 0, cam_3_mid_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_3_end_marker, 12, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_3_end_marker, 12, 0, 0, 0, 0, cam_3_mid_marker, 1, 0)
	Sleep(10)
	
	Set_Cinematic_Camera_Key(cam_1_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_1_start_marker, 0, 0, 0, 0, cam_1_mid_marker, 0, 0)
	Transition_Cinematic_Camera_Key(cam_1_end_marker, 17, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_1_end_marker, 17, 0, 0, 0, 0, cam_1_mid_marker, 1, 0)
	Sleep(15)
	
	Set_Cinematic_Camera_Key(cam_2_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_2_start_marker, 0, 0, 0, 0, cam_2_mid_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_2_end_marker, 17, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_2_end_marker, 17, 0, 0, 0, 0, cam_2_mid_marker, 1, 0)
	Sleep(15)
	
	--Total 80 secs	
    current_cinematic_thread_id = Create_Thread("Battle_Cinematic_Camera_Loop")
end

function Battle_One_Begins()
	battle_one_active = true

	if not cinematic_cam_active then
        current_cinematic_thread_id = Create_Thread("Battle_Cinematic_Camera")
        cinematic_cam_active = true
    end
	battle_one_active = false

	Create_Thread("State_Spawn_Battle")

end