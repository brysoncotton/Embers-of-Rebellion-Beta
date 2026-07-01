--***************************************************--
--***************** Elevator Script *****************--
--***************************************************--

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	Define_State("State_Init", State_Init)

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")

	armed_police_list = Find_Object_Type("POLICE_RESPONDER")
	armed_shock_trooper_phase_1_list = Find_Object_Type("SHOCK_CLONE_PHASE_ONE")
	armed_duros_list = Find_Object_Type("DUROS_CIVILIAN")
	armed_hutt_list = Find_Object_Type("HUTT_CIVILIAN")
	armed_pyngani_list = Find_Object_Type("PYNGANI_WARRIOR")
	armed_swamp_human_a_list = Find_Object_Type("SWAMP_CIVILIAN_A")
	armed_swamp_human_b_list = Find_Object_Type("SWAMP_CIVILIAN_B")
	armed_swamp_human_c_list = Find_Object_Type("SWAMP_CIVILIAN_C")
	armed_rodian_list = Find_Object_Type("RODIAN_CIVILIAN")
	armed_trandoshan_list = Find_Object_Type("TRANDOSHAN_WARRIOR")
	armed_jawa_list = Find_Object_Type("JAWA_SCOUT")
	armed_wookiee_list = Find_Object_Type("WOOKIEE_WARRIOR")
	armed_moncal_list = Find_Object_Type("MON_CALAMARI_CIVILIAN")
	armed_snow_human_list = Find_Object_Type("SNOW_CIVILIAN_A")
	armed_urban_human_a_list = Find_Object_Type("URBAN_CIVILIAN_A")
	armed_urban_human_b_list = Find_Object_Type("URBAN_CIVILIAN_B")
	armed_urban_human_c_list = Find_Object_Type("URBAN_CIVILIAN_C")
	armed_sullustan_list = Find_Object_Type("SULLUSTAN_CIVILIAN")
	armed_bothan_list = Find_Object_Type("BOTHAN_CIVILIAN")
	armed_twilek_list = Find_Object_Type("TWILEK_COMMANDO")
	armed_weequay_list = Find_Object_Type("PIRATE_SOLDIER")
end

function State_Init(message)
	if message == OnEnter then
		if Get_Game_Mode() ~= "Land" then
			return
		end
		GlobalValue.Set("Guards_Attacked", 0)
		Register_Attacked_Event(Object, State_Guard_Attacked)
	end
end

function State_Guard_Attacked(fell_under_attack, most_deadly_enemy)
	if Object.Get_Type() == Find_Object_Type("Active_Police") then
		armed_object_list = Spawn_Unit(armed_police_list, Object.Get_Position(), p_republic)
		armed_object = armed_object_list[1]
		armed_object.Teleport_And_Face(Object.Get_Position())
		Object.Despawn()
		Story_Event("GUARDS_ATTACKED")
		GlobalValue.Set("Guards_Attacked", 1)
	elseif Object.Get_Type() == Find_Object_Type("Active_Shock_Trooper_Phase_1") then
		armed_object_list = Spawn_Unit(armed_shock_trooper_phase_1_list, Object.Get_Position(), p_republic)
		armed_object = armed_object_list[1]
		armed_object.Teleport_And_Face(Object.Get_Position())
		Object.Despawn()
		Story_Event("GUARDS_ATTACKED")
		GlobalValue.Set("Guards_Attacked", 1)
	elseif Object.Get_Type() == Find_Object_Type("Active_Human_Urban_A") then
		armed_object_list = Spawn_Unit(armed_urban_human_a_list, Object.Get_Position(), p_republic)
		armed_object = armed_object_list[1]
		armed_object.Teleport_And_Face(Object.Get_Position())
		Object.Despawn()
		Story_Event("GUARDS_ATTACKED")
		GlobalValue.Set("Guards_Attacked", 1)
	elseif Object.Get_Type() == Find_Object_Type("Active_Human_Urban_B") then
		armed_object_list = Spawn_Unit(armed_urban_human_b_list, Object.Get_Position(), p_republic)
		armed_object = armed_object_list[1]
		armed_object.Teleport_And_Face(Object.Get_Position())
		Object.Despawn()
		Story_Event("GUARDS_ATTACKED")
		GlobalValue.Set("Guards_Attacked", 1)
	elseif Object.Get_Type() == Find_Object_Type("Active_Human_Urban_C") then
		armed_object_list = Spawn_Unit(armed_urban_human_c_list, Object.Get_Position(), p_republic)
		armed_object = armed_object_list[1]
		armed_object.Teleport_And_Face(Object.Get_Position())
		Object.Despawn()
		Story_Event("GUARDS_ATTACKED")
		GlobalValue.Set("Guards_Attacked", 1)
	elseif Object.Get_Type() == Find_Object_Type("Active_Human_Swamp_A") then
		armed_object_list = Spawn_Unit(armed_swamp_human_a_list, Object.Get_Position(), p_republic)
		armed_object = armed_object_list[1]
		armed_object.Teleport_And_Face(Object.Get_Position())
		Object.Despawn()
		Story_Event("GUARDS_ATTACKED")
		GlobalValue.Set("Guards_Attacked", 1)
	elseif Object.Get_Type() == Find_Object_Type("Active_Human_Swamp_B") then
		armed_object_list = Spawn_Unit(armed_swamp_human_b_list, Object.Get_Position(), p_republic)
		armed_object = armed_object_list[1]
		armed_object.Teleport_And_Face(Object.Get_Position())
		Object.Despawn()
		Story_Event("GUARDS_ATTACKED")
		GlobalValue.Set("Guards_Attacked", 1)
	elseif Object.Get_Type() == Find_Object_Type("Active_Human_Swamp_C") then
		armed_object_list = Spawn_Unit(armed_swamp_human_c_list, Object.Get_Position(), p_republic)
		armed_object = armed_object_list[1]
		armed_object.Teleport_And_Face(Object.Get_Position())
		Object.Despawn()
		Story_Event("GUARDS_ATTACKED")
		GlobalValue.Set("Guards_Attacked", 1)
	elseif Object.Get_Type() == Find_Object_Type("Active_Human_Snow") then
		armed_object_list = Spawn_Unit(armed_snow_human_list, Object.Get_Position(), p_republic)
		armed_object = armed_object_list[1]
		armed_object.Teleport_And_Face(Object.Get_Position())
		Object.Despawn()
		Story_Event("GUARDS_ATTACKED")
		GlobalValue.Set("Guards_Attacked", 1)
	elseif Object.Get_Type() == Find_Object_Type("Active_Mon_Calamari") then
		armed_object_list = Spawn_Unit(armed_moncal_list, Object.Get_Position(), p_republic)
		armed_object = armed_object_list[1]
		armed_object.Teleport_And_Face(Object.Get_Position())
		Object.Despawn()
		Story_Event("GUARDS_ATTACKED")
		GlobalValue.Set("Guards_Attacked", 1)
	elseif Object.Get_Type() == Find_Object_Type("Active_Bothan") then
		armed_object_list = Spawn_Unit(armed_bothan_list, Object.Get_Position(), p_republic)
		armed_object = armed_object_list[1]
		armed_object.Teleport_And_Face(Object.Get_Position())
		Object.Despawn()
		Story_Event("GUARDS_ATTACKED")
		GlobalValue.Set("Guards_Attacked", 1)
	elseif Object.Get_Type() == Find_Object_Type("Active_Hutt") then
		armed_object_list = Spawn_Unit(armed_hutt_list, Object.Get_Position(), p_republic)
		armed_object = armed_object_list[1]
		armed_object.Teleport_And_Face(Object.Get_Position())
		Object.Despawn()
		Story_Event("GUARDS_ATTACKED")
		GlobalValue.Set("Guards_Attacked", 1)
	elseif Object.Get_Type() == Find_Object_Type("Active_Twilek_Female") then
		armed_object_list = Spawn_Unit(armed_twilek_list, Object.Get_Position(), p_republic)
		armed_object = armed_object_list[1]
		armed_object.Teleport_And_Face(Object.Get_Position())
		Object.Despawn()
		Story_Event("GUARDS_ATTACKED")
		GlobalValue.Set("Guards_Attacked", 1)
	elseif Object.Get_Type() == Find_Object_Type("Active_Jawa") then
		armed_object_list = Spawn_Unit(armed_jawa_list, Object.Get_Position(), p_republic)
		armed_object = armed_object_list[1]
		armed_object.Teleport_And_Face(Object.Get_Position())
		Object.Despawn()
		Story_Event("GUARDS_ATTACKED")
		GlobalValue.Set("Guards_Attacked", 1)
	elseif Object.Get_Type() == Find_Object_Type("Active_Sullustan") then
		armed_object_list = Spawn_Unit(armed_sullustan_list, Object.Get_Position(), p_republic)
		armed_object = armed_object_list[1]
		armed_object.Teleport_And_Face(Object.Get_Position())
		Object.Despawn()
		Story_Event("GUARDS_ATTACKED")
		GlobalValue.Set("Guards_Attacked", 1)
	elseif Object.Get_Type() == Find_Object_Type("Active_Pyngani") then
		armed_object_list = Spawn_Unit(armed_pyngani_list, Object.Get_Position(), p_republic)
		armed_object = armed_object_list[1]
		armed_object.Teleport_And_Face(Object.Get_Position())
		Object.Despawn()
		Story_Event("GUARDS_ATTACKED")
		GlobalValue.Set("Guards_Attacked", 1)
	elseif Object.Get_Type() == Find_Object_Type("Active_Duros") then
		armed_object_list = Spawn_Unit(armed_duros_list, Object.Get_Position(), p_republic)
		armed_object = armed_object_list[1]
		armed_object.Teleport_And_Face(Object.Get_Position())
		Object.Despawn()
		Story_Event("GUARDS_ATTACKED")
		GlobalValue.Set("Guards_Attacked", 1)
	elseif Object.Get_Type() == Find_Object_Type("Active_Rodian") then
		armed_object_list = Spawn_Unit(armed_rodian_list, Object.Get_Position(), p_republic)
		armed_object = armed_object_list[1]
		armed_object.Teleport_And_Face(Object.Get_Position())
		Object.Despawn()
		Story_Event("GUARDS_ATTACKED")
		GlobalValue.Set("Guards_Attacked", 1)
	elseif Object.Get_Type() == Find_Object_Type("Active_Wookiee") then
		armed_object_list = Spawn_Unit(armed_wookiee_list, Object.Get_Position(), p_republic)
		armed_object = armed_object_list[1]
		armed_object.Teleport_And_Face(Object.Get_Position())
		Object.Despawn()
		Story_Event("GUARDS_ATTACKED")
		GlobalValue.Set("Guards_Attacked", 1)
	elseif Object.Get_Type() == Find_Object_Type("Active_Trandoshan") then
		armed_object_list = Spawn_Unit(armed_trandoshan_list, Object.Get_Position(), p_republic)
		armed_object = armed_object_list[1]
		armed_object.Teleport_And_Face(Object.Get_Position())
		Object.Despawn()
		Story_Event("GUARDS_ATTACKED")
		GlobalValue.Set("Guards_Attacked", 1)
	elseif Object.Get_Type() == Find_Object_Type("Active_Weequay") then
		armed_object_list = Spawn_Unit(armed_weequay_list, Object.Get_Position(), p_republic)
		armed_object = armed_object_list[1]
		armed_object.Teleport_And_Face(Object.Get_Position())
		Object.Despawn()
		Story_Event("GUARDS_ATTACKED")
		GlobalValue.Set("Guards_Attacked", 1)
	end
end

function Story_Mode_Service()
	if (GlobalValue.Get("Guards_Attacked") == 1) then
		if Object.Get_Type() == Find_Object_Type("Active_Police") then
			armed_object_list = Spawn_Unit(armed_police_list, Object.Get_Position(), p_republic)
			armed_object = armed_object_list[1]
			armed_object.Teleport_And_Face(Object.Get_Position())
			Object.Despawn()
			Story_Event("GUARDS_ATTACKED")
			GlobalValue.Set("Guards_Attacked", 1)
		elseif Object.Get_Type() == Find_Object_Type("Active_Shock_Trooper_Phase_1") then
			armed_object_list = Spawn_Unit(armed_shock_trooper_phase_1_list, Object.Get_Position(), p_republic)
			armed_object = armed_object_list[1]
			armed_object.Teleport_And_Face(Object.Get_Position())
			Object.Despawn()
			Story_Event("GUARDS_ATTACKED")
			GlobalValue.Set("Guards_Attacked", 1)
		elseif Object.Get_Type() == Find_Object_Type("Active_Human_Urban_A") then
			armed_object_list = Spawn_Unit(armed_urban_human_a_list, Object.Get_Position(), p_republic)
			armed_object = armed_object_list[1]
			armed_object.Teleport_And_Face(Object.Get_Position())
			Object.Despawn()
			Story_Event("GUARDS_ATTACKED")
			GlobalValue.Set("Guards_Attacked", 1)
		elseif Object.Get_Type() == Find_Object_Type("Active_Human_Urban_B") then
			armed_object_list = Spawn_Unit(armed_urban_human_b_list, Object.Get_Position(), p_republic)
			armed_object = armed_object_list[1]
			armed_object.Teleport_And_Face(Object.Get_Position())
			Object.Despawn()
			Story_Event("GUARDS_ATTACKED")
			GlobalValue.Set("Guards_Attacked", 1)
		elseif Object.Get_Type() == Find_Object_Type("Active_Human_Urban_C") then
			armed_object_list = Spawn_Unit(armed_urban_human_c_list, Object.Get_Position(), p_republic)
			armed_object = armed_object_list[1]
			armed_object.Teleport_And_Face(Object.Get_Position())
			Object.Despawn()
			Story_Event("GUARDS_ATTACKED")
			GlobalValue.Set("Guards_Attacked", 1)
		elseif Object.Get_Type() == Find_Object_Type("Active_Human_Swamp_A") then
			armed_object_list = Spawn_Unit(armed_swamp_human_a_list, Object.Get_Position(), p_republic)
			armed_object = armed_object_list[1]
			armed_object.Teleport_And_Face(Object.Get_Position())
			Object.Despawn()
			Story_Event("GUARDS_ATTACKED")
			GlobalValue.Set("Guards_Attacked", 1)
		elseif Object.Get_Type() == Find_Object_Type("Active_Human_Swamp_B") then
			armed_object_list = Spawn_Unit(armed_swamp_human_b_list, Object.Get_Position(), p_republic)
			armed_object = armed_object_list[1]
			armed_object.Teleport_And_Face(Object.Get_Position())
			Object.Despawn()
			Story_Event("GUARDS_ATTACKED")
			GlobalValue.Set("Guards_Attacked", 1)
		elseif Object.Get_Type() == Find_Object_Type("Active_Human_Swamp_C") then
			armed_object_list = Spawn_Unit(armed_swamp_human_c_list, Object.Get_Position(), p_republic)
			armed_object = armed_object_list[1]
			armed_object.Teleport_And_Face(Object.Get_Position())
			Object.Despawn()
			Story_Event("GUARDS_ATTACKED")
			GlobalValue.Set("Guards_Attacked", 1)
		elseif Object.Get_Type() == Find_Object_Type("Active_Human_Snow") then
			armed_object_list = Spawn_Unit(armed_snow_human_list, Object.Get_Position(), p_republic)
			armed_object = armed_object_list[1]
			armed_object.Teleport_And_Face(Object.Get_Position())
			Object.Despawn()
			Story_Event("GUARDS_ATTACKED")
			GlobalValue.Set("Guards_Attacked", 1)
		elseif Object.Get_Type() == Find_Object_Type("Active_Mon_Calamari") then
			armed_object_list = Spawn_Unit(armed_moncal_list, Object.Get_Position(), p_republic)
			armed_object = armed_object_list[1]
			armed_object.Teleport_And_Face(Object.Get_Position())
			Object.Despawn()
			Story_Event("GUARDS_ATTACKED")
			GlobalValue.Set("Guards_Attacked", 1)
		elseif Object.Get_Type() == Find_Object_Type("Active_Bothan") then
			armed_object_list = Spawn_Unit(armed_bothan_list, Object.Get_Position(), p_republic)
			armed_object = armed_object_list[1]
			armed_object.Teleport_And_Face(Object.Get_Position())
			Object.Despawn()
			Story_Event("GUARDS_ATTACKED")
			GlobalValue.Set("Guards_Attacked", 1)
		elseif Object.Get_Type() == Find_Object_Type("Active_Hutt") then
			armed_object_list = Spawn_Unit(armed_hutt_list, Object.Get_Position(), p_republic)
			armed_object = armed_object_list[1]
			armed_object.Teleport_And_Face(Object.Get_Position())
			Object.Despawn()
			Story_Event("GUARDS_ATTACKED")
			GlobalValue.Set("Guards_Attacked", 1)
		elseif Object.Get_Type() == Find_Object_Type("Active_Twilek_Female") then
			armed_object_list = Spawn_Unit(armed_twilek_list, Object.Get_Position(), p_republic)
			armed_object = armed_object_list[1]
			armed_object.Teleport_And_Face(Object.Get_Position())
			Object.Despawn()
			Story_Event("GUARDS_ATTACKED")
			GlobalValue.Set("Guards_Attacked", 1)
		elseif Object.Get_Type() == Find_Object_Type("Active_Jawa") then
			armed_object_list = Spawn_Unit(armed_jawa_list, Object.Get_Position(), p_republic)
			armed_object = armed_object_list[1]
			armed_object.Teleport_And_Face(Object.Get_Position())
			Object.Despawn()
			Story_Event("GUARDS_ATTACKED")
			GlobalValue.Set("Guards_Attacked", 1)
		elseif Object.Get_Type() == Find_Object_Type("Active_Sullustan") then
			armed_object_list = Spawn_Unit(armed_sullustan_list, Object.Get_Position(), p_republic)
			armed_object = armed_object_list[1]
			armed_object.Teleport_And_Face(Object.Get_Position())
			Object.Despawn()
			Story_Event("GUARDS_ATTACKED")
			GlobalValue.Set("Guards_Attacked", 1)
		elseif Object.Get_Type() == Find_Object_Type("Active_Pyngani") then
			armed_object_list = Spawn_Unit(armed_pyngani_list, Object.Get_Position(), p_republic)
			armed_object = armed_object_list[1]
			armed_object.Teleport_And_Face(Object.Get_Position())
			Object.Despawn()
			Story_Event("GUARDS_ATTACKED")
			GlobalValue.Set("Guards_Attacked", 1)
		elseif Object.Get_Type() == Find_Object_Type("Active_Duros") then
			armed_object_list = Spawn_Unit(armed_duros_list, Object.Get_Position(), p_republic)
			armed_object = armed_object_list[1]
			armed_object.Teleport_And_Face(Object.Get_Position())
			Object.Despawn()
			Story_Event("GUARDS_ATTACKED")
			GlobalValue.Set("Guards_Attacked", 1)
		elseif Object.Get_Type() == Find_Object_Type("Active_Rodian") then
			armed_object_list = Spawn_Unit(armed_rodian_list, Object.Get_Position(), p_republic)
			armed_object = armed_object_list[1]
			armed_object.Teleport_And_Face(Object.Get_Position())
			Object.Despawn()
			Story_Event("GUARDS_ATTACKED")
			GlobalValue.Set("Guards_Attacked", 1)
		elseif Object.Get_Type() == Find_Object_Type("Active_Wookiee") then
			armed_object_list = Spawn_Unit(armed_wookiee_list, Object.Get_Position(), p_republic)
			armed_object = armed_object_list[1]
			armed_object.Teleport_And_Face(Object.Get_Position())
			Object.Despawn()
			Story_Event("GUARDS_ATTACKED")
			GlobalValue.Set("Guards_Attacked", 1)
		elseif Object.Get_Type() == Find_Object_Type("Active_Trandoshan") then
			armed_object_list = Spawn_Unit(armed_trandoshan_list, Object.Get_Position(), p_republic)
			armed_object = armed_object_list[1]
			armed_object.Teleport_And_Face(Object.Get_Position())
			Object.Despawn()
			Story_Event("GUARDS_ATTACKED")
			GlobalValue.Set("Guards_Attacked", 1)
		elseif Object.Get_Type() == Find_Object_Type("Active_Weequay") then
			armed_object_list = Spawn_Unit(armed_weequay_list, Object.Get_Position(), p_republic)
			armed_object = armed_object_list[1]
			armed_object.Teleport_And_Face(Object.Get_Position())
			Object.Despawn()
			Story_Event("GUARDS_ATTACKED")
			GlobalValue.Set("Guards_Attacked", 1)
		end
	end
end
