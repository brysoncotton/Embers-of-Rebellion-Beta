--***************************************************--
--*********** Main Menu Space Script ****************--
--***************************************************--

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")

function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))

	Define_State("State_Init", State_Init)

	battle_active = false
	
	cinematic_cam_active = false

	-- Players
	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")

end

function State_Init(message)
	if message == OnEnter then

		if Get_Game_Mode() ~= "Space" then
			return
		end

		cis_ship_1_marker = Find_Hint("MARKER_GENERIC_GREEN", "cis-ship-1")
		cis_ship_2_marker = Find_Hint("MARKER_GENERIC_GREEN", "cis-ship-2")
		cis_ship_3_marker = Find_Hint("MARKER_GENERIC_GREEN", "cis-ship-3")
		cis_ship_4_marker = Find_Hint("MARKER_GENERIC_GREEN", "cis-ship-4")
		cis_ship_5_marker = Find_Hint("MARKER_GENERIC_GREEN", "cis-ship-5")
		
		rep_ship_1_marker = Find_Hint("MARKER_GENERIC_GREEN", "rep-ship-1")
		rep_ship_2_marker = Find_Hint("MARKER_GENERIC_GREEN", "rep-ship-2")

		Create_Thread("State_List_Battle")

		Create_Thread("Battle_Begins")
	end
end

function Battle_Cinematic_Camera()
    Start_Cinematic_Mode()
end

function State_List_Battle()
	rep_spawn_list = {
		"Acclamator_I_Carrier",
		"Acclamator_I_Carrier",
		"Acclamator_I_Carrier",
		"Acclamator_I_Carrier",
		"Acclamator_I_Assault",
		"Acclamator_I_Assault",
		"Venator_Star_Destroyer",
		"Venator_Star_Destroyer",
		"Venator_Star_Destroyer",
		"Venator_Star_Destroyer",
		"Venator_Star_Destroyer",
		"REP_DHC",
		"REP_DHC",
		"Victory_I_Star_Destroyer",
		"Victory_I_Star_Destroyer",
	}
	cis_spawn_list = {
		"Lucrehulk_Carrier",
		"Munificent",
		"Munificent",
		"Munificent",
		"Munificent",
		"Munificent",
		"Hardcell",
		"Hardcell",
		"Hardcell",
		"Hardcell",
		"Hardcell",
		"Recusant_Light_Destroyer",
		"Recusant_Light_Destroyer",
		"Recusant_Light_Destroyer",
	}
end

function State_Spawn_Battle()
	--CIS fleet
	CIS_Fleet = SpawnList(cis_spawn_list, cis_ship_1_marker.Get_Position(), p_cis, true, true)
	CIS_Fleet = CIS_Fleet[1]
	CIS_Fleet.Teleport_And_Face(cis_ship_1_marker)
	CIS_Fleet.Cinematic_Hyperspace_In(0.1)
	
	player_cis_ship_1 = Spawn_Unit(Find_Object_Type("Providence_Carrier_Destroyer"), cis_ship_2_marker, p_cis)
	player_cis_ship_1 = Find_Nearest(cis_ship_2_marker, p_cis, true)
	player_cis_ship_1.Teleport_And_Face(cis_ship_2_marker)
	player_cis_ship_1.Cinematic_Hyperspace_In(0.1)
	
	player_cis_ship_2 = Spawn_Unit(Find_Object_Type("Providence_Carrier_Destroyer"), cis_ship_3_marker, p_cis)
	player_cis_ship_2 = Find_Nearest(cis_ship_3_marker, p_cis, true)
	player_cis_ship_2.Teleport_And_Face(cis_ship_3_marker)
	player_cis_ship_2.Cinematic_Hyperspace_In(0.1)
	
	player_cis_ship_3 = Spawn_Unit(Find_Object_Type("Providence_Carrier_Destroyer"), cis_ship_4_marker, p_cis)
	player_cis_ship_3 = Find_Nearest(cis_ship_4_marker, p_cis, true)
	player_cis_ship_3.Teleport_And_Face(cis_ship_4_marker)
	player_cis_ship_3.Cinematic_Hyperspace_In(0.1)
	
--	player_cis_ship_4 = Spawn_Unit(Find_Object_Type("Grievous_Invisible_Hand"), cis_ship_5_marker, p_cis)
--	player_cis_ship_4 = Find_Nearest(cis_ship_5_marker, p_cis, true)
--	player_cis_ship_4.Teleport_And_Face(cis_ship_5_marker)
--	player_cis_ship_4.Cinematic_Hyperspace_In(0.1)

	--Republic fleet
	Republic_Fleet = SpawnList(rep_spawn_list, rep_ship_1_marker.Get_Position(), p_republic, true, true)
	Republic_Fleet = Republic_Fleet[1]
	Republic_Fleet.Teleport_And_Face(rep_ship_1_marker)
	Republic_Fleet.Cinematic_Hyperspace_In(0.1)
	
	player_rep_ship_1 = Spawn_Unit(Find_Object_Type("Procurator_Battlecruiser"), rep_ship_2_marker, p_republic)
	player_rep_ship_1 = Find_Nearest(rep_ship_2_marker, p_republic, true)
	player_rep_ship_1.Teleport_And_Face(rep_ship_2_marker)
	player_rep_ship_1.Cinematic_Hyperspace_In(0.1)
end

function Battle_Begins()
	if not battle_active then
        battle_active = true
		
		Fade_On()

		Create_Thread("State_Spawn_Battle")

		if not cinematic_cam_active then
            Create_Thread("Battle_Cinematic_Camera")
            cinematic_cam_active = true
        end
		
		player_lucrehulk_carrier = Find_First_Object("Lucrehulk_Carrier")
		if TestValid(player_lucrehulk_carrier) then
			player_lucrehulk_carrier.Set_Importance(20)
		end

		Fade_Screen_In(10)
		
		Sleep (5)

		local republic_attack_list = Find_All_Objects_Of_Type(p_republic, "SpaceHero | Corvette | Capital | Frigate | SuperCapital")
		for g,repattack in pairs(republic_attack_list) do
			if TestValid(repattack) then
				if TestValid(Find_First_Object("Lucrehulk_Carrier")) then
					repattack.Attack_Move(Find_First_Object("Lucrehulk_Carrier"))
				end
			end
		end

		local cis_attack_list = Find_All_Objects_Of_Type(p_cis, "SpaceHero | Corvette | Capital | Frigate | SuperCapital")
		for g,cisattack in pairs(cis_attack_list) do
			if TestValid(cisattack) then
				if TestValid(Find_First_Object("Procurator_Battlecruiser")) then
					cisattack.Attack_Move(Find_First_Object("Procurator_Battlecruiser"))
				end
			end
		end

		Sleep(120) --Length of battle
	end
end