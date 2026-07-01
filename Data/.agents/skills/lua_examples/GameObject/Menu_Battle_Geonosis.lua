--***************************************************--
--*********** Main Menu Geonosis Script *************--
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
		cis_hailfire_1_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_hailfire_1")
		cis_hailfire_2_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_hailfire_2")
		cis_hailfire_3_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_hailfire_3")
		cis_hailfire_4_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_hailfire_4")
		
		cis_og9_1_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_og9_1")
		cis_og9_2_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_og9_2")
		cis_og9_3_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_og9_3")
		cis_og9_4_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_og9_4")
		cis_og9_5_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_og9_5")
		cis_og9_6_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_og9_6")
		cis_og9_7_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_og9_7")
		
		cis_persuader_1_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_persuader_1")
		cis_persuader_2_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_persuader_2")
		
		cis_aat_1_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_aat_1")
		cis_aat_2_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_aat_2")
		cis_aat_3_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_aat_3")
		cis_aat_4_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_aat_4")
		cis_aat_5_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_aat_5")
		cis_aat_6_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_aat_6")
		
		cis_b1_1_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b1_1")
		cis_b1_2_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b1_2")
		cis_b1_3_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b1_3")
		cis_b1_4_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b1_4")
		cis_b1_5_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b1_5")
		cis_b1_6_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b1_6")
		cis_b1_7_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b1_7")
		cis_b1_8_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b1_8")
		cis_b1_9_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b1_9")
		
		cis_stap_1_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_stap_1")
		
		cis_b2_1_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b2_1")
		cis_b2_2_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b2_2")
		cis_b2_3_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b2_3")
		cis_b2_4_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b2_4")
		cis_b2_5_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis_b2_5")
		
		-- Markers GAR
		command_post_1_marker = Find_Hint("MARKER_GENERIC_PURPLE", "base1")
		command_post_2_marker = Find_Hint("MARKER_GENERIC_PURPLE", "base2")
		command_post_3_marker = Find_Hint("MARKER_GENERIC_PURPLE", "base3")

		mace_windu_marker = Find_Hint("MARKER_GENERIC_PURPLE", "mace-windu")
		kit_fisto_marker = Find_Hint("MARKER_GENERIC_PURPLE", "kit-fisto")
		shaak_ti_marker = Find_Hint("MARKER_GENERIC_PURPLE", "shaak-ti")
		plo_koon_marker = Find_Hint("MARKER_GENERIC_PURPLE", "plo-koon")
		aayla_secura_marker = Find_Hint("MARKER_GENERIC_PURPLE", "aayla-secura")

		republic_atte_1_marker = Find_Hint("ATTE_SPAWN_MARKER", "republic_atte_1")
		republic_atte_2_marker = Find_Hint("ATTE_SPAWN_MARKER", "republic_atte_2")
		republic_atte_3_marker = Find_Hint("ATTE_SPAWN_MARKER", "republic_atte_3")
		republic_atte_4_marker = Find_Hint("ATTE_SPAWN_MARKER", "republic_atte_4")
		republic_atte_5_marker = Find_Hint("ATTE_SPAWN_MARKER", "republic_atte_5")
		republic_atte_6_marker = Find_Hint("ATTE_SPAWN_MARKER", "republic_atte_6")
		republic_atte_7_marker = Find_Hint("ATTE_SPAWN_MARKER", "republic_atte_7")
		
		republic_atrt_1_marker = Find_Hint("MARKER_GENERIC_RED", "republic_atrt_1")
		republic_atrt_2_marker = Find_Hint("MARKER_GENERIC_RED", "republic_atrt_2")
		republic_atrt_3_marker = Find_Hint("MARKER_GENERIC_RED", "republic_atrt_3")
		republic_atrt_4_marker = Find_Hint("MARKER_GENERIC_RED", "republic_atrt_4")
		republic_atrt_5_marker = Find_Hint("MARKER_GENERIC_RED", "republic_atrt_5")
		republic_atrt_6_marker = Find_Hint("MARKER_GENERIC_RED", "republic_atrt_6")
		republic_atrt_7_marker = Find_Hint("MARKER_GENERIC_RED", "republic_atrt_7")
		republic_atrt_8_marker = Find_Hint("MARKER_GENERIC_RED", "republic_atrt_8")
		republic_atrt_9_marker = Find_Hint("MARKER_GENERIC_RED", "republic_atrt_9")
		republic_atrt_10_marker = Find_Hint("MARKER_GENERIC_RED", "republic_atrt_10")
		republic_atrt_11_marker = Find_Hint("MARKER_GENERIC_RED", "republic_atrt_11")
		republic_atrt_12_marker = Find_Hint("MARKER_GENERIC_RED", "republic_atrt_12")
		republic_atrt_13_marker = Find_Hint("MARKER_GENERIC_RED", "republic_atrt_13")
		
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
		
		republic_arc_phase1_1_marker = Find_Hint("MARKER_GENERIC_RED", "republic_arc_phase1_1")
		
		--Unit List CIS
		hailfire_list =
		{
			"HAILFIRE"
		}
		
		og9_list =
		{
			"OG9"
		}
		
		persuader_list =
		{
			"PERSUADER"
		}
		
		aat_list =
		{
			"AAT"
		}
		
		b1_droid_list =
		{
			"B1_GEO_DROID_COMPANY"
		}

		stap_list =
		{
			"STAP_COMPANY"
		}
		
		b2_droid_list =
		{
			"B2_DROID_COMPANY"
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
		
		arc_phase1_list =
		{
			"ARC_PHASE_ONE_COMPANY"
		}
		
		--Camera Markers
		cam_1_start_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam1start")
		cam_1_mid_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam1mid")
		cam_1_end_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam1end")
		
		cam_2_start_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam2start")
		cam_2_mid_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam2mid")
		cam_2_end_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam2end")
		
		cam_3_start_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam3start")
		cam_3_mid_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam3mid")
		cam_3_end_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam3end")
		
		cam_4_start_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam4start")
		cam_4_mid_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam4mid")
		cam_4_end_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam4end")
		
		cam_atte_start_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam_atte_start")
		cam_atte_end_marker = Find_Hint("MARKER_GENERIC_WHITE", "cam_atte_end")

		Create_Thread("Battle_One_Begins")
	end
end

function State_Spawn_Battle_01()
	
	--CIS Army
	--Hailfire
	hailfire_01 = SpawnList(hailfire_list, cis_hailfire_1_marker.Get_Position(), p_cis, true, true)
	hailfire_02 = SpawnList(hailfire_list, cis_hailfire_2_marker.Get_Position(), p_cis, true, true)
	hailfire_03 = SpawnList(hailfire_list, cis_hailfire_3_marker.Get_Position(), p_cis, true, true)
	hailfire_04 = SpawnList(hailfire_list, cis_hailfire_4_marker.Get_Position(), p_cis, true, true)
	
	--OG9
	og9_01 = SpawnList(og9_list, cis_og9_1_marker.Get_Position(), p_cis, true, true)
	og9_02 = SpawnList(og9_list, cis_og9_2_marker.Get_Position(), p_cis, true, true)
	og9_03 = SpawnList(og9_list, cis_og9_3_marker.Get_Position(), p_cis, true, true)
	og9_04 = SpawnList(og9_list, cis_og9_4_marker.Get_Position(), p_cis, true, true)
	og9_05 = SpawnList(og9_list, cis_og9_5_marker.Get_Position(), p_cis, true, true)
	og9_06 = SpawnList(og9_list, cis_og9_6_marker.Get_Position(), p_cis, true, true)
	og9_07 = SpawnList(og9_list, cis_og9_7_marker.Get_Position(), p_cis, true, true)
	
	--Persuader
	persuader_01 = SpawnList(persuader_list, cis_persuader_1_marker.Get_Position(), p_cis, true, true)
	persuader_02 = SpawnList(persuader_list, cis_persuader_2_marker.Get_Position(), p_cis, true, true)
	
	--AAT
	aat_01 = SpawnList(aat_list, cis_aat_1_marker.Get_Position(), p_cis, true, true)
	aat_02 = SpawnList(aat_list, cis_aat_2_marker.Get_Position(), p_cis, true, true)
	aat_03 = SpawnList(aat_list, cis_aat_3_marker.Get_Position(), p_cis, true, true)
	aat_04 = SpawnList(aat_list, cis_aat_4_marker.Get_Position(), p_cis, true, true)
	aat_05 = SpawnList(aat_list, cis_aat_5_marker.Get_Position(), p_cis, true, true)
	aat_06 = SpawnList(aat_list, cis_aat_6_marker.Get_Position(), p_cis, true, true)
	
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
	
	--Stap
	stap_01 = SpawnList(stap_list, cis_stap_1_marker.Get_Position(), p_cis, true, true)
	
	--B2
	b2_01 = SpawnList(b2_droid_list, cis_b2_1_marker.Get_Position(), p_cis, true, true)
	b2_02 = SpawnList(b2_droid_list, cis_b2_2_marker.Get_Position(), p_cis, true, true)
	b2_03 = SpawnList(b2_droid_list, cis_b2_3_marker.Get_Position(), p_cis, true, true)
	b2_04 = SpawnList(b2_droid_list, cis_b2_4_marker.Get_Position(), p_cis, true, true)
	b2_05 = SpawnList(b2_droid_list, cis_b2_5_marker.Get_Position(), p_cis, true, true)
	
	
	--Republic Army

	command_post = Find_Object_Type("REPUBLIC_FIELD_COMMANDO_BASE")

	command_post_1_list = Spawn_Unit(command_post, command_post_1_marker, p_republic)
	player_command_base_1 = command_post_1_list[1]
	player_command_base_1.Teleport_And_Face(command_post_1_marker)
	player_command_base_1.Set_Cannot_Be_Killed(true)

	command_post_2_list = Spawn_Unit(command_post, command_post_2_marker, p_republic)
	player_command_base_2 = command_post_2_list[1]
	player_command_base_2.Teleport_And_Face(command_post_2_marker)
	player_command_base_2.Set_Cannot_Be_Killed(true)

	command_post_3_list = Spawn_Unit(command_post, command_post_3_marker, p_republic)
	player_command_base_3 = command_post_3_list[1]
	player_command_base_3.Teleport_And_Face(command_post_3_marker)
	player_command_base_3.Set_Cannot_Be_Killed(true)

	--AT-TE
	atte_01 = SpawnList(atte_list, republic_atte_1_marker.Get_Position(),p_republic, true, true)
	atte_02 = SpawnList(atte_list, republic_atte_2_marker.Get_Position(),p_republic, true, true)
	atte_03 = SpawnList(atte_list, republic_atte_3_marker.Get_Position(),p_republic, true, true)
	atte_04 = SpawnList(atte_list, republic_atte_4_marker.Get_Position(),p_republic, true, true)
	atte_05 = SpawnList(atte_list, republic_atte_5_marker.Get_Position(),p_republic, true, true)
	atte_06 = SpawnList(atte_list, republic_atte_6_marker.Get_Position(),p_republic, true, true)
	atte_07 = SpawnList(atte_list, republic_atte_7_marker.Get_Position(),p_republic, true, true)
	
	--AT-RT
	atrt_01 = SpawnList(atrt_list, republic_atrt_1_marker.Get_Position(),p_republic, true, true)
	atrt_02 = SpawnList(atrt_list, republic_atrt_2_marker.Get_Position(),p_republic, true, true)
	atrt_03 = SpawnList(atrt_list, republic_atrt_3_marker.Get_Position(),p_republic, true, true)
	atrt_04 = SpawnList(atrt_list, republic_atrt_4_marker.Get_Position(),p_republic, true, true)
	atrt_05 = SpawnList(atrt_list, republic_atrt_5_marker.Get_Position(),p_republic, true, true)
	atrt_06 = SpawnList(atrt_list, republic_atrt_6_marker.Get_Position(),p_republic, true, true)
	atrt_07 = SpawnList(atrt_list, republic_atrt_7_marker.Get_Position(),p_republic, true, true)
	atrt_08 = SpawnList(atrt_list, republic_atrt_8_marker.Get_Position(),p_republic, true, true)
	atrt_09 = SpawnList(atrt_list, republic_atrt_9_marker.Get_Position(),p_republic, true, true)
	atrt_10 = SpawnList(atrt_list, republic_atrt_10_marker.Get_Position(),p_republic, true, true)
	atrt_11 = SpawnList(atrt_list, republic_atrt_11_marker.Get_Position(),p_republic, true, true)
	atrt_12 = SpawnList(atrt_list, republic_atrt_12_marker.Get_Position(),p_republic, true, true)
	atrt_13 = SpawnList(atrt_list, republic_atrt_13_marker.Get_Position(),p_republic, true, true)
	
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
	
	--Arc Phase 1
	arc_01 = SpawnList(arc_phase1_list, republic_arc_phase1_1_marker.Get_Position(),p_republic, true, true)

	Create_Thread("State_Attack_Target")
end

function State_Spawn_Battle_02()

		mace_windu = Find_Object_Type("Mace_Windu")
		mace_windu_list = Spawn_Unit(mace_windu, mace_windu_marker, p_republic)
		player_mace_windu = mace_windu_list[1]
		player_mace_windu.Teleport_And_Face(mace_windu_marker)
		player_mace_windu.Move_To(cis_og9_5_marker)

		plo_koon = Find_Object_Type("Plo_Koon")
		plo_koon_list = Spawn_Unit(plo_koon, plo_koon_marker, p_republic)
		player_plo_koon = plo_koon_list[1]
		player_plo_koon.Teleport_And_Face(plo_koon_marker)
		player_plo_koon.Move_To(cis_og9_5_marker)

		aayla_secura = Find_Object_Type("Aayla_Secura")
		aayla_secura_list = Spawn_Unit(aayla_secura, aayla_secura_marker, p_republic)
		player_aayla_secura = aayla_secura_list[1]
		player_aayla_secura.Teleport_And_Face(aayla_secura_marker)
		player_aayla_secura.Move_To(cis_og9_5_marker)

		shaak_ti = Find_Object_Type("Shaak_Ti")
		shaak_ti_list = Spawn_Unit(shaak_ti, shaak_ti_marker, p_republic)
		player_shaak_ti = shaak_ti_list[1]
		player_shaak_ti.Teleport_And_Face(shaak_ti_marker)
		player_shaak_ti.Move_To(cis_og9_5_marker)

		kit_fisto = Find_Object_Type("Kit_Fisto")
		kit_fisto_list = Spawn_Unit(kit_fisto, kit_fisto_marker, p_republic)
		player_kit_fisto = kit_fisto_list[1]
		player_kit_fisto.Teleport_And_Face(kit_fisto_marker)
		player_kit_fisto.Move_To(cis_og9_5_marker)

end

function State_Spawn_Battle_03()
	
	--CIS Army
	--Hailfire
	hailfire_01 = SpawnList(hailfire_list, cis_hailfire_1_marker.Get_Position(), p_cis, true, true)
	hailfire_02 = SpawnList(hailfire_list, cis_hailfire_2_marker.Get_Position(), p_cis, true, true)
	
	--OG9
	og9_01 = SpawnList(og9_list, cis_og9_1_marker.Get_Position(), p_cis, true, true)
	og9_02 = SpawnList(og9_list, cis_og9_2_marker.Get_Position(), p_cis, true, true)
	og9_03 = SpawnList(og9_list, cis_og9_3_marker.Get_Position(), p_cis, true, true)
	
	--Persuader
	persuader_01 = SpawnList(persuader_list, cis_persuader_1_marker.Get_Position(), p_cis, true, true)

	--B1
	b1_01 = SpawnList(b1_droid_list, cis_b1_1_marker.Get_Position(), p_cis, true, true)
	b1_02 = SpawnList(b1_droid_list, cis_b1_2_marker.Get_Position(), p_cis, true, true)
	b1_03 = SpawnList(b1_droid_list, cis_b1_3_marker.Get_Position(), p_cis, true, true)
	b1_04 = SpawnList(b1_droid_list, cis_b1_4_marker.Get_Position(), p_cis, true, true)
	b1_05 = SpawnList(b1_droid_list, cis_b1_5_marker.Get_Position(), p_cis, true, true)
	
	--Stap
	stap_01 = SpawnList(stap_list, cis_stap_1_marker.Get_Position(), p_cis, true, true)
	
	--B2
	b2_01 = SpawnList(b2_droid_list, cis_b2_1_marker.Get_Position(), p_cis, true, true)
	b2_02 = SpawnList(b2_droid_list, cis_b2_2_marker.Get_Position(), p_cis, true, true)
	b2_03 = SpawnList(b2_droid_list, cis_b2_3_marker.Get_Position(), p_cis, true, true)
	b2_04 = SpawnList(b2_droid_list, cis_b2_4_marker.Get_Position(), p_cis, true, true)

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
	
	--Arc Phase 1
	arc_01 = SpawnList(arc_phase1_list, republic_arc_phase1_1_marker.Get_Position(),p_republic, true, true)

end

function State_Attack_Target()

	-- Attack AT-TE 1
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
	
	for i,unit in pairs(hailfire_01) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_1_marker)
		end
	end
	
	for i,unit in pairs(b2_01) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_1_marker)
		end
	end
	
	for i,unit in pairs(b1_03) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_1_marker)
		end
	end
	
	for i,unit in pairs(og9_01) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_1_marker)
		end
	end
	
	for i,unit in pairs(aat_01) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_1_marker)
		end
	end
	
	-- Attack AT-TE 2
	for i,unit in pairs(b2_02) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_2_marker)
		end
	end
	
	for i,unit in pairs(persuader_01) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_2_marker)
		end
	end
	
	for i,unit in pairs(hailfire_01) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_2_marker)
		end
	end
	
	for i,unit in pairs(og9_02) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_2_marker)
		end
	end
	
	for i,unit in pairs(aat_02) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_2_marker)
		end
	end
	
	for i,unit in pairs(stap_01) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_2_marker)
		end
	end
	
	-- Attack AT-TE 3
	for i,unit in pairs(aat_03) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_3_marker)
		end
	end
	
	for i,unit in pairs(og9_03) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_3_marker)
		end
	end
	
	for i,unit in pairs(b1_04) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_3_marker)
		end
	end
	
	-- Attack AT-TE 4
	for i,unit in pairs(b1_05) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_4_marker)
		end
	end
	
	for i,unit in pairs(og9_04) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_4_marker)
		end
	end
	
	for i,unit in pairs(b1_06) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_4_marker)
		end
	end
	
	for i,unit in pairs(b2_03) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_4_marker)
		end
	end
	
	-- Attack AT-TE 5
	for i,unit in pairs(og9_05) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_5_marker)
		end
	end
	
	for i,unit in pairs(aat_04) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_5_marker)
		end
	end
	
	for i,unit in pairs(hailfire_02) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_5_marker)
		end
	end
	
	-- Attack AT-TE 6
	for i,unit in pairs(b2_04) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_6_marker)
		end
	end
	
	for i,unit in pairs(hailfire_03) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_6_marker)
		end
	end
	
	for i,unit in pairs(aat_05) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_6_marker)
		end
	end
	
	for i,unit in pairs(b1_07) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_6_marker)
		end
	end
	
	for i,unit in pairs(og9_06) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_6_marker)
		end
	end
	
	for i,unit in pairs(persuader_02) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_6_marker)
		end
	end
	
	-- Attack AT-TE 7
	for i,unit in pairs(b1_05) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_7_marker)
		end
	end
	
	for i,unit in pairs(aat_06) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_7_marker)
		end
	end
	
	for i,unit in pairs(hailfire_04) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_7_marker)
		end
	end
	
	for i,unit in pairs(b1_08) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_7_marker)
		end
	end
	
	for i,unit in pairs(b2_05) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_7_marker)
		end
	end
	
	for i,unit in pairs(og9_07) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_7_marker)
		end
	end
	
	for i,unit in pairs(b1_09) do
		if TestValid(unit) then
			unit.Attack_Move(republic_atte_7_marker)
		end
	end

end

function Battle_Cinematic_Camera()
    Start_Cinematic_Camera()
	
	Fade_On()	
	Fade_Screen_In(2)
	
	Set_Cinematic_Camera_Key(cam_1_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_1_start_marker, 0, 0, 0, 0, cam_1_mid_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_1_end_marker, 12, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_1_end_marker, 12, 0, 0, 0, 0, cam_1_mid_marker, 1, 0)
	Sleep(10)

	local cis_attack_one_list = Find_All_Objects_Of_Type(p_cis)
	for g,cisattack01 in pairs(cis_attack_one_list) do
		if TestValid(cisattack01) then
			if TestValid(player_command_base_1) then
				cisattack01.Attack_Move(player_command_base_1)
			end
		end
	end

	Set_Cinematic_Camera_Key(cam_2_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_2_start_marker, 0, 0, 0, 0, cam_2_mid_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_2_end_marker, 12, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_2_end_marker, 12, 0, 0, 0, 0, cam_2_mid_marker, 1, 0)
	Sleep(10)

--	Create_Thread("State_Spawn_Battle_02")

	Set_Cinematic_Camera_Key(cam_4_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_4_start_marker, 0, 0, 0, 0, cam_4_mid_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_4_end_marker, 12, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_4_end_marker, 12, 0, 0, 0, 0, cam_4_mid_marker, 1, 0)
	Sleep(10)

	Set_Cinematic_Camera_Key(cam_3_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_3_start_marker, 0, 0, 0, 0, cam_3_mid_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_3_end_marker, 12, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_3_end_marker, 12, 0, 0, 0, 0, cam_3_mid_marker, 1, 0)
	Sleep(10)
	
	Create_Thread("State_Spawn_Battle_03")
	closest_atte = Find_Nearest(cam_1_mid_marker, "REPUBLIC_AT_TE_WALKER")

	Set_Cinematic_Camera_Key(cam_atte_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_atte_start_marker, 0, 0, 0, 0, closest_atte, 1, 0)
	Transition_Cinematic_Camera_Key(cam_atte_end_marker, 12, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_atte_end_marker, 12, 0, 0, 0, 0, closest_atte, 1, 0)
	Sleep(10)
	
	Set_Cinematic_Camera_Key(cam_1_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_1_start_marker, 0, 0, 0, 0, cam_1_mid_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_1_end_marker, 12, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_1_end_marker, 12, 0, 0, 0, 0, cam_1_mid_marker, 1, 0)
	Sleep(10)
	
	Set_Cinematic_Camera_Key(cam_2_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_2_start_marker, 0, 0, 0, 0, cam_2_mid_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_2_end_marker, 12, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_2_end_marker, 12, 0, 0, 0, 0, cam_2_mid_marker, 1, 0)
	Sleep(10)
	
	Set_Cinematic_Camera_Key(cam_4_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_4_start_marker, 0, 0, 0, 0, cam_4_mid_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_4_end_marker, 12, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_4_end_marker, 12, 0, 0, 0, 0, cam_4_mid_marker, 1, 0)
	Sleep(10)

	Set_Cinematic_Camera_Key(cam_3_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_3_start_marker, 0, 0, 0, 0, cam_3_mid_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_3_end_marker, 12, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_3_end_marker, 12, 0, 0, 0, 0, cam_3_mid_marker, 1, 0)
	Sleep(10)

	local cis_attack_two_list = Find_All_Objects_Of_Type(p_cis)
	for g,cisattack02 in pairs(cis_attack_two_list) do
		if TestValid(cisattack02) then
			if TestValid(player_command_base_1) then
				cisattack02.Attack_Move(player_command_base_1)
			end
		end
	end	
	--Total 60 secs
    current_cinematic_thread_id = Create_Thread("Battle_Cinematic_Camera_Loop")

	Fade_Screen_Out(4)
	
end

function Battle_Cinematic_Camera_Loop()

	Set_Cinematic_Camera_Key(cam_1_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_1_start_marker, 0, 0, 0, 0, cam_1_mid_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_1_end_marker, 12, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_1_end_marker, 12, 0, 0, 0, 0, cam_1_mid_marker, 1, 0)
	Sleep(10)

	local cis_attack_one_list = Find_All_Objects_Of_Type(p_cis)
	for g,cisattack01 in pairs(cis_attack_one_list) do
		if TestValid(cisattack01) then
			if TestValid(player_command_base_1) then
				cisattack01.Attack_Move(player_command_base_1)
			end
		end
	end

	Set_Cinematic_Camera_Key(cam_2_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_2_start_marker, 0, 0, 0, 0, cam_2_mid_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_2_end_marker, 12, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_2_end_marker, 12, 0, 0, 0, 0, cam_2_mid_marker, 1, 0)
	Sleep(10)

	Set_Cinematic_Camera_Key(cam_4_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_4_start_marker, 0, 0, 0, 0, cam_4_mid_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_4_end_marker, 12, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_4_end_marker, 12, 0, 0, 0, 0, cam_4_mid_marker, 1, 0)
	Sleep(10)

	Set_Cinematic_Camera_Key(cam_3_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_3_start_marker, 0, 0, 0, 0, cam_3_mid_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_3_end_marker, 12, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_3_end_marker, 12, 0, 0, 0, 0, cam_3_mid_marker, 1, 0)
	Sleep(10)
	
	closest_atte = Find_Nearest(cam_1_mid_marker, "REPUBLIC_AT_TE_WALKER")

	Set_Cinematic_Camera_Key(cam_atte_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_atte_start_marker, 0, 0, 0, 0, closest_atte, 1, 0)
	Transition_Cinematic_Camera_Key(cam_atte_end_marker, 12, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_atte_end_marker, 12, 0, 0, 0, 0, closest_atte, 1, 0)
	Sleep(10)
	
	Set_Cinematic_Camera_Key(cam_1_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_1_start_marker, 0, 0, 0, 0, cam_1_mid_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_1_end_marker, 12, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_1_end_marker, 12, 0, 0, 0, 0, cam_1_mid_marker, 1, 0)
	Sleep(10)
	
	Set_Cinematic_Camera_Key(cam_2_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_2_start_marker, 0, 0, 0, 0, cam_2_mid_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_2_end_marker, 12, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_2_end_marker, 12, 0, 0, 0, 0, cam_2_mid_marker, 1, 0)
	Sleep(10)
	
	Set_Cinematic_Camera_Key(cam_4_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_4_start_marker, 0, 0, 0, 0, cam_4_mid_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_4_end_marker, 12, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_4_end_marker, 12, 0, 0, 0, 0, cam_4_mid_marker, 1, 0)
	Sleep(10)

	Set_Cinematic_Camera_Key(cam_3_start_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(cam_3_start_marker, 0, 0, 0, 0, cam_3_mid_marker, 1, 0)
	Transition_Cinematic_Camera_Key(cam_3_end_marker, 12, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(cam_3_end_marker, 12, 0, 0, 0, 0, cam_3_mid_marker, 1, 0)
	Sleep(10)

	local cis_attack_two_list = Find_All_Objects_Of_Type(p_cis)
	for g,cisattack02 in pairs(cis_attack_two_list) do
		if TestValid(cisattack02) then
			if TestValid(player_command_base_1) then
				cisattack02.Attack_Move(player_command_base_1)
			end
		end
	end	

    current_cinematic_thread_id = Create_Thread("Battle_Cinematic_Camera_Loop")
end

function Battle_One_Begins()
	battle_one_active = true

	Create_Thread("State_Spawn_Battle_01")

	if not cinematic_cam_active then
        current_cinematic_thread_id = Create_Thread("Battle_Cinematic_Camera")
        cinematic_cam_active = true
    end

	battle_one_active = false

end