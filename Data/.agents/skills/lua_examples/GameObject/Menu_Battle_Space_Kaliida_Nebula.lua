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

		cis_ship_1_marker = Find_Hint("MARKER_GENERIC_RED", "cis-ship-1")  --Subjugator

		rep_ship_1_marker = Find_Hint("MARKER_GENERIC_RED", "rep-ship-1")  --Venators
		rep_ship_2_marker = Find_Hint("MARKER_GENERIC_RED", "rep-ship-2")
		rep_ship_3_marker = Find_Hint("MARKER_GENERIC_RED", "rep-ship-3")
		rep_ship_4_marker = Find_Hint("MARKER_GENERIC_RED", "rep-ship-4")
		rep_ship_5_marker = Find_Hint("MARKER_GENERIC_RED", "rep-ship-5")
		rep_ship_6_marker = Find_Hint("MARKER_GENERIC_RED", "rep-ship-6")
		rep_ship_7_marker = Find_Hint("MARKER_GENERIC_RED", "rep-ship-7")
		rep_ship_8_marker = Find_Hint("MARKER_GENERIC_RED", "rep-ship-8")
		rep_ship_9_marker = Find_Hint("MARKER_GENERIC_RED", "rep-ship-9")
		rep_ship_10_marker = Find_Hint("MARKER_GENERIC_RED", "rep-ship-10")
		rep_ship_11_marker = Find_Hint("MARKER_GENERIC_RED", "rep-ship-11")

		Create_Thread("State_List_Battle")
		
		Create_Thread("Battle_Begins")
	end
end

function Battle_Cinematic_Camera()
    Start_Cinematic_Mode()
end

function State_List_Battle()
	rep_spawn_list = {
		"LAC",
		"LAC",
		"LAC",
		"LAC",
		"Arquitens",
		"Arquitens",
		"Acclamator_I_Carrier",
		"Acclamator_I_Assault",
	}
end

function State_Spawn_Battle()
	--CIS fleet
	player_malevolence = Spawn_Unit(Find_Object_Type("Subjugator"), cis_ship_1_marker, p_cis)
	player_malevolence = Find_Nearest(cis_ship_1_marker, p_cis, true)
	player_malevolence.Teleport_And_Face(cis_ship_1_marker)
	player_malevolence.Cinematic_Hyperspace_In(50)
	player_malevolence.Set_Importance(10)
	player_malevolence.Make_Invulnerable(true)

	--Republic fleet
	player_rep_ship_1 = Spawn_Unit(Find_Object_Type("Venator_Star_Destroyer"), rep_ship_1_marker, p_republic)
	player_rep_ship_1 = Find_Nearest(rep_ship_1_marker, p_republic, true)
	player_rep_ship_1.Teleport_And_Face(rep_ship_1_marker)
	player_rep_ship_1.Cinematic_Hyperspace_In(0.1)

	player_rep_ship_2 = Spawn_Unit(Find_Object_Type("Venator_Star_Destroyer"), rep_ship_2_marker, p_republic)
	player_rep_ship_2 = Find_Nearest(rep_ship_2_marker, p_republic, true)
	player_rep_ship_2.Teleport_And_Face(rep_ship_2_marker)
	player_rep_ship_2.Cinematic_Hyperspace_In(0.1)

	player_rep_ship_3 = Spawn_Unit(Find_Object_Type("Venator_Star_Destroyer"), rep_ship_3_marker, p_republic)
	player_rep_ship_3 = Find_Nearest(rep_ship_3_marker, p_republic, true)
	player_rep_ship_3.Teleport_And_Face(rep_ship_3_marker)
	player_rep_ship_3.Cinematic_Hyperspace_In(0.1)

	player_rep_ship_4 = Spawn_Unit(Find_Object_Type("Venator_Star_Destroyer"), rep_ship_4_marker, p_republic)
	player_rep_ship_4 = Find_Nearest(rep_ship_4_marker, p_republic, true)
	player_rep_ship_4.Teleport_And_Face(rep_ship_4_marker)
	player_rep_ship_4.Cinematic_Hyperspace_In(0.1)

	player_rep_ship_5 = Spawn_Unit(Find_Object_Type("Venator_Star_Destroyer"), rep_ship_5_marker, p_republic)
	player_rep_ship_5 = Find_Nearest(rep_ship_5_marker, p_republic, true)
	player_rep_ship_5.Teleport_And_Face(rep_ship_5_marker)
	player_rep_ship_5.Cinematic_Hyperspace_In(0.1)

	player_rep_ship_6 = Spawn_Unit(Find_Object_Type("Venator_Star_Destroyer"), rep_ship_6_marker, p_republic)
	player_rep_ship_6 = Find_Nearest(rep_ship_6_marker, p_republic, true)
	player_rep_ship_6.Teleport_And_Face(rep_ship_6_marker)
	player_rep_ship_6.Cinematic_Hyperspace_In(0.1)

	player_rep_ship_7 = Spawn_Unit(Find_Object_Type("Venator_Star_Destroyer"), rep_ship_7_marker, p_republic)
	player_rep_ship_7 = Find_Nearest(rep_ship_7_marker, p_republic, true)
	player_rep_ship_7.Teleport_And_Face(rep_ship_7_marker)
	player_rep_ship_7.Cinematic_Hyperspace_In(0.1)

	player_rep_ship_8 = Spawn_Unit(Find_Object_Type("Venator_Star_Destroyer"), rep_ship_8_marker, p_republic)
	player_rep_ship_8 = Find_Nearest(rep_ship_8_marker, p_republic, true)
	player_rep_ship_8.Teleport_And_Face(rep_ship_8_marker)
	player_rep_ship_8.Cinematic_Hyperspace_In(0.1)

	player_rep_ship_9 = Spawn_Unit(Find_Object_Type("Venator_Star_Destroyer"), rep_ship_9_marker, p_republic)
	player_rep_ship_9 = Find_Nearest(rep_ship_9_marker, p_republic, true)
	player_rep_ship_9.Teleport_And_Face(rep_ship_9_marker)
	player_rep_ship_9.Cinematic_Hyperspace_In(0.1)


	Republic_Fleet_01 = SpawnList(rep_spawn_list, rep_ship_10_marker.Get_Position(), p_republic, true, true)
	Republic_Fleet_01 = Republic_Fleet_01[1]
	Republic_Fleet_01.Teleport_And_Face(rep_ship_10_marker)
	Republic_Fleet_01.Cinematic_Hyperspace_In(0.1)

	Republic_Fleet_02 = SpawnList(rep_spawn_list, rep_ship_11_marker.Get_Position(), p_republic, true, true)
	Republic_Fleet_02 = Republic_Fleet_02[1]
	Republic_Fleet_02.Teleport_And_Face(rep_ship_11_marker)
	Republic_Fleet_02.Cinematic_Hyperspace_In(0.1)
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

        local player_medical_station = Find_First_Object("Haven_Menu_Anim")
        if TestValid(player_medical_station) then
            player_medical_station.Set_Importance(20)
        end

        Fade_Screen_In(10)

        Sleep(5)

        local republic_attack_list = Find_All_Objects_Of_Type(p_republic, "SpaceHero | Corvette | Capital | Frigate | SpaceStructure | SuperCapital")
        for _, rep_attack in pairs(republic_attack_list) do
            if TestValid(rep_attack) and TestValid(player_malevolence) then
                rep_attack.Attack_Move(player_malevolence)
            end
        end

        if TestValid(player_rep_ship_5) then
            player_malevolence.Attack_Move(player_rep_ship_5)
        end

        Sleep(120) -- Length of battle
    end
end