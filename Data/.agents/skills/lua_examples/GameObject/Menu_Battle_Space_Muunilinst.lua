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

		cis_ship_1_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis-ship-1")  -- IGBC's
		cis_ship_2_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis-ship-2")
		cis_ship_3_marker = Find_Hint("MARKER_GENERIC_BLUE", "cis-ship-3")

		rep_ship_1_marker = Find_Hint("MARKER_GENERIC_BLUE", "rep-ship-1")

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
		"Acclamator_I_Carrier",
		"Acclamator_I_Carrier",
		"Acclamator_I_Carrier",
		"Acclamator_I_Carrier",
		"Acclamator_I_Carrier",
		"Acclamator_I_Carrier",
		"Acclamator_I_Carrier",
		"Acclamator_I_Carrier",
		"Acclamator_I_Carrier",
		"Acclamator_I_Carrier",
		"Acclamator_I_Carrier",
		"Acclamator_I_Carrier",
	}
end

function State_Spawn_Battle()
	--CIS fleet
	player_cis_station_1 = Spawn_Unit(Find_Object_Type("Rebel_Star_Base_5"), cis_ship_1_marker, p_cis)
	player_cis_station_1 = Find_Nearest(cis_ship_1_marker, p_cis, true)
	player_cis_station_1.Teleport_And_Face(cis_ship_1_marker)

	player_cis_station_2 = Spawn_Unit(Find_Object_Type("Rebel_Star_Base_5"), cis_ship_2_marker, p_cis)
	player_cis_station_2 = Find_Nearest(cis_ship_2_marker, p_cis, true)
	player_cis_station_2.Teleport_And_Face(cis_ship_2_marker)

	player_cis_station_3 = Spawn_Unit(Find_Object_Type("Rebel_Star_Base_5"), cis_ship_3_marker, p_cis)
	player_cis_station_3 = Find_Nearest(cis_ship_3_marker, p_cis, true)
	player_cis_station_3.Teleport_And_Face(cis_ship_3_marker)

	--Republic fleet
	Republic_Fleet = SpawnList(rep_spawn_list, rep_ship_1_marker.Get_Position(), p_republic, true, true)
	Republic_Fleet = Republic_Fleet[1]
	Republic_Fleet.Teleport_And_Face(rep_ship_1_marker)
	Republic_Fleet.Cinematic_Hyperspace_In(50)
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
		
		Fade_Screen_In(10)
		
		Sleep (5)

		local republic_attack_list = Find_All_Objects_Of_Type(p_republic, "SpaceHero | Corvette | Capital | Frigate | SpaceStructure | SuperCapital")
		for g,repattack in pairs(republic_attack_list) do
			if TestValid(repattack) then
				if TestValid(player_cis_station_2) then
					repattack.Attack_Move(player_cis_station_2)
				end
			end
		end

		Sleep(120) --Length of battles
	end
end