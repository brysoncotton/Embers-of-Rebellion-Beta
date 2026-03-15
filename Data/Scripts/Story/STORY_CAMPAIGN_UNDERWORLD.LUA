-- $Id: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Campaign_Underworld.lua#1 $
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
--              $File: //depot/Projects/StarWars_Steam/FOC/Run/Data/Scripts/Story/Story_Campaign_Underworld.lua $
--
--    Original Author: Dan Etter
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

require("PGStateMachine")
require("PGStoryMode")

--
-- Definitions -- This function is called once when the script is first created.
-- 
function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))
	
	StoryModeEvents = 
	{
		OK_To_Begin_Underworld_ActII = State_Enable_Scripted_AI_For_ActII,
		OK_To_Begin_Underworld_ActIII = State_Switch_Rebel_HQ_For_ActIII,
		LUA_Link_Trigger_Empire_Attacks_00 = State_Begin_Scripted_Thrawn_Attacks,
		Underworld_Mission_07_Reveal_Bespin = State_Underworld_Mission_07_Reveal_Bespin,
		Underworld_Mission_07_Completed = State_Underworld_Mission_07_Completed,
		Underworld_ActII_Mission_07_Failed = State_Underworld_ActII_Mission_07_Failed,
		Underworld_A02M07_Failed_04 = State_Underworld_ActII_Mission_07_Reset_Variables,
		Underworld_A03M10_Spawn_Rebels_At_Mandalore = State_Underworld_A03M10_Spawn_Rebels_At_Mandalore,
		LUA_Link_Trigger_Empire_Attacks_01 = State_Empire_Attacks_01,
		LUA_Link_Trigger_Empire_Attacks_02 = State_Empire_Attacks_02,
	}
	
	
	underworld = Find_Player("Underworld")
	rebel = Find_Player("Rebel")
	empire = Find_Player("Empire")

	mission_7_triggered = false
	mission_7_ready = false
	mission_7_complete = false
	mission_message_sent = false
	
	bespin_unit_list = {}
	
	mission_ten_rebel_space_fleet = {
		"Y-Wing_Squadron",
		"Y-Wing_Squadron",
		"Y-Wing_Squadron",
		"A_Wing_Squadron",
		"A_Wing_Squadron",
		"A_Wing_Squadron",
		"Rebel_X-Wing_Squadron",
		"Rebel_X-Wing_Squadron",
		"Rebel_X-Wing_Squadron",
		"B-Wing_Squadron",
		"B-Wing_Squadron",
		"B-Wing_Squadron",
		"Corellian_Corvette",
		"Corellian_Corvette",
		"Corellian_Gunboat",
		"Corellian_Gunboat",
		"Marauder_Missile_Cruiser",
		"Marauder_Missile_Cruiser",
		"Marauder_Missile_Cruiser",
		"Marauder_Missile_Cruiser",
		"Alliance_Assault_Frigate",
		"Alliance_Assault_Frigate",
		"Alliance_Assault_Frigate",
		"Alliance_Assault_Frigate",
		"Alliance_Assault_Frigate"
	}
	
	mission_ten_rebel_land_fleet = {		
		"Garm_Bel_Iblis_Team",
		"Rebel_Infantry_Squad",
		"Rebel_Infantry_Squad",
		"Rebel_Tank_Buster_Squad",
		"Rebel_Infiltrator_Team",
		"Rebel_Light_Tank_Brigade",
		"Rebel_Artillery_Brigade",
		"Rebel_Speeder_Wing",
		"Rebel_Heavy_Tank_Brigade",
		"Rebel_Heavy_Tank_Brigade"
	}
	
	rebel_attack_thread_id = -1
	empire_attack_thread_id = -1
	
end

function Story_Mode_Service()
	if mission_7_ready and not mission_7_complete and not mission_message_sent then
		mission_message_sent = true
		bespin = Find_First_Object("Bespin_Story")
		
		underworld_list = Find_All_Objects_Of_Type(underworld)
		for k, unit in pairs(underworld_list) do
			if TestValid(unit) then
				if unit.Get_Planet_Location() == bespin and not (unit.Get_Type() == Find_Object_Type("GALACTIC_FLEET")) then
					parent = unit.Get_Parent_Object()
					if TestValid(parent) and (parent.Get_Type() == Find_Object_Type("GALACTIC_FLEET")) then
						table.insert(bespin_unit_list, unit)
					end
				end
			end
		end
		
		if TestValid(bespin_unit_list[1]) then
			bespin_fleet = Assemble_Fleet(bespin_unit_list)
		end
		
		Story_Event("START_MISSION_7")
	end
	
	if mission_7_triggered then
		tyber = Find_First_Object("TYBER_ZANN_PASSENGER")
		urai_list = Find_All_Objects_Of_Type("Urai_Fen")
		bespin = Find_First_Object("Bespin_Story")
		
		if TestValid(tyber) then
			--MessageBox("Tyber0 found!")
			tyber_loc = tyber.Get_Planet_Location()
		end
		
		urai_loc = nil
		for k, unit in pairs(urai_list) do
			if TestValid(unit) then
				if unit.Get_Planet_Location() == bespin then
					urai_loc = bespin
				end
			end
		end
		
		
		if tyber_loc == bespin and urai_loc == bespin then
			mission_7_ready = true
		end
	end
end

function State_Underworld_Mission_07_Reveal_Bespin(message)

	--It's important that this state function be tied to an XML event that won't be repeated if we fail the mission,
	--otherwise it can squash State_Underworld_ActII_Mission_07_Failed below

	if message == OnEnter then
		mission_7_triggered = true
	end
end

function State_Underworld_ActII_Mission_07_Failed(message)

	--We can't stick around in this state, otherwise a second failure will not cause a state change and we'll never run OnEnter again
end

function State_Underworld_ActII_Mission_07_Reset_Variables(message)
	if message == OnEnter then
		--player failed mission 7, reset all relevant flags!
		mission_7_triggered = true
		mission_7_ready = false
		mission_7_complete = false
		mission_message_sent = false
		
		bespin_unit_list = {}
	end
end

function State_Underworld_Mission_07_Completed(message)
	if message == OnEnter then
		mission_7_complete = true
		
		if Create_Thread.Is_Thread_Active(empire_attack_thread_id) then
			Create_Thread.Kill(empire_attack_thread_id)
		end		
		
		--Generate a big Empire attack here
		empire_attack_thread_id = Create_Thread("Major_Empire_Attack")
	end
end


--MISSION 10 LUA SCRIPTING

function State_Underworld_A03M10_Spawn_Rebels_At_Mandalore(message)
	if message == OnEnter then
		--Spawn in the space fleet!
		mandalore = Find_First_Object("Mandalore")
		rebel_space_fleet_units = SpawnList(mission_ten_rebel_space_fleet,mandalore,rebel,false,false)
		rebel_space_fleet = Assemble_Fleet(rebel_space_fleet_units)
		
		--Spawn in the land fleet!
		rebel_land_fleet_units = SpawnList(mission_ten_rebel_land_fleet,mandalore,rebel,false,false)
	end
end

function State_Begin_Scripted_Thrawn_Attacks(message)
	if message == OnEnter then

		Create_Thread("Thrawn_Attacks_Saleucami")
		Create_Thread("Thrawn_Attacks_Ryloth")
	end
end

function State_Empire_Attacks_01(message)
	if message == OnEnter then
		
		if Create_Thread.Is_Thread_Active(empire_attack_thread_id) then
			Create_Thread.Kill(empire_attack_thread_id)
		end
		
		empire_attack_thread_id = Create_Thread("Major_Empire_Attack")
	end
end

function State_Empire_Attacks_02(message)
	if message == OnEnter then
	
		if Create_Thread.Is_Thread_Active(empire_attack_thread_id) then
			Create_Thread.Kill(empire_attack_thread_id)
		end
	
		empire_attack_thread_id = Create_Thread("Roaming_Empire_Space_Force")
	end
end

function State_Enable_Scripted_AI_For_ActII(message)
	if message == OnEnter then
		--kuat is the source of Empire attacks.  We'll need it from here on out
		kuat = Find_First_Object("Kuat")

		--From this point on the Empire will periodically send smallish forces after Underworld planets
		--Also we'll generate big Empire attacks at various specific story points
		Create_Thread("Periodic_Minor_Empire_Attack")
		
		--Meanwhile the Rebels will only attack in response to the Underworld taking one of their planets		
		rebel_attack_source = Find_First_Object("Hoth")
		Create_Thread("Monitor_Planet_Ownership_For_Rebel_Losses")
	end
end

function State_Switch_Rebel_HQ_For_ActIII(message)
	if message == OnEnter then
		--Rebel attacks now originate at Sullust
		rebel_attack_source = Find_First_Object("Sullust")
	end
end

--Couple of special Empire attacks after Thrawn threatens Tyber
function Thrawn_Attacks_Saleucami()
	saleucami_space_force_definition = {	"Victory_Destroyer",
											"Victory_Destroyer",
											"Acclamator_Assault_Ship",
											"Acclamator_Assault_Ship",
											"Tartan_Patrol_Cruiser",
											"Tartan_Patrol_Cruiser",
											"Tartan_Patrol_Cruiser",
											"Tartan_Patrol_Cruiser",
											"Interdictor_Cruiser",
											"TIE_Interceptor_Squadron",
											"TIE_Interceptor_Squadron",
											"TIE_Interceptor_Squadron",
											"TIE_Interceptor_Squadron",
											"TIE_Interceptor_Squadron",
											"TIE_Interceptor_Squadron" }

	saleucami = Find_First_Object("Saleucami")
	
	saleucami_space_units = SpawnList(saleucami_space_force_definition, kuat, empire, false, false)
	saleucami_space_fleet = Assemble_Fleet(saleucami_space_units)
	BlockOnCommand(saleucami_space_fleet.Move_To(saleucami))
end

function Thrawn_Attacks_Ryloth()
	ryloth_space_force_definition = {	"Star_Destroyer",
										"Acclamator_Assault_Ship",
										"Acclamator_Assault_Ship",
										"Acclamator_Assault_Ship",
										"Tartan_Patrol_Cruiser",
										"Tartan_Patrol_Cruiser",
										"Broadside_Class_Cruiser",
										"Broadside_Class_Cruiser",
										"Broadside_Class_Cruiser",
										"Broadside_Class_Cruiser",
										"Broadside_Class_Cruiser",
										"TIE_Defender_Squadron",
										"TIE_Defender_Squadron",
										"TIE_Defender_Squadron",
										"TIE_Phantom_Squadron",
										"TIE_Phantom_Squadron",
										"TIE_Interceptor_Squadron",
										"TIE_Interceptor_Squadron" }

	ryloth = Find_First_Object("Ryloth")
	
	ryloth_space_units = SpawnList(ryloth_space_force_definition, kuat, empire, false, false)
	ryloth_space_fleet = Assemble_Fleet(ryloth_space_units)
	BlockOnCommand(ryloth_space_fleet.Move_To(ryloth))
end

--Couple of thread functions to run Empire attacks of different sizes
function Minor_Empire_Attack()

	--Might be worth having a few different template forces and randomly selecting one for variety
	minor_empire_space_force_definition = {	"Victory_Destroyer",
											"Acclamator_Assault_Ship",
											"Tartan_Patrol_Cruiser",
											"Tartan_Patrol_Cruiser",
											"Tartan_Patrol_Cruiser",
											"TIE_Interceptor_Squadron",
											"TIE_Interceptor_Squadron",
											"TIE_Interceptor_Squadron" }
	
	minor_empire_land_force_definition = {	"Victory_Destroyer",
											"Acclamator_Assault_Ship",
											"Tartan_Patrol_Cruiser",
											"Imperial_Stormtrooper_Squad",
											"Imperial_Stormtrooper_Squad",
											"DarkTrooper_P1_Company",
											"Noghri_Assassin_Squad",
											"Imperial_Light_Scout_Squad",
											"Imperial_Heavy_Scout_Squad",
											"Imperial_Heavy_Scout_Squad",
											"Imperial_Anti_Infantry_Brigade",
											"Imperial_Anti_Infantry_Brigade" }
	
	Empire_Attack(minor_empire_space_force_definition, minor_empire_land_force_definition)										
end

function Major_Empire_Attack()

	--Might be worth having a few different template forces and randomly selecting one for variety
	major_empire_space_force_definition = {	"Star_Destroyer",
											"Victory_Destroyer",
											"Acclamator_Assault_Ship",
											"Acclamator_Assault_Ship",
											"Tartan_Patrol_Cruiser",
											"Tartan_Patrol_Cruiser",
											"Broadside_Class_Cruiser",
											"Broadside_Class_Cruiser",
											"Broadside_Class_Cruiser",
											"TIE_Defender_Squadron",
											"TIE_Defender_Squadron",
											"TIE_Phantom_Squadron",
											"TIE_Phantom_Squadron",
											"TIE_Interceptor_Squadron",
											"TIE_Interceptor_Squadron" }	
											
	major_empire_land_force_definition = {	"Acclamator_Assault_Ship",
											"Acclamator_Assault_Ship",
											"Tartan_Patrol_Cruiser",
											"TIE_Interceptor_Squadron",
											"TIE_Interceptor_Squadron",												
											"DarkTrooper_P1_Company",
											"DarkTrooper_P1_Company",
											"DarkTrooper_P2_Company",
											"DarkTrooper_P2_Company",
											"DarkTrooper_P2_Company",
											"DarkTrooper_P3_Company",
											"DarkTrooper_P3_Company",
											"Imperial_Armor_Group",
											"Imperial_Armor_Group",
											"Imperial_Heavy_Assault_Company",
											"Imperial_Artillery_Corp",
											"Lancet_Air_Wing" }
	
	Empire_Attack(major_empire_space_force_definition, major_empire_land_force_definition)								
end


--Spawn Empire land and space forces and direct them to attack an Underworld planet
function Empire_Attack(space_force_definition, land_force_definition)

	empire_attack_target = FindTarget.Reachable_Target(empire, "Is_Neglected_By_My_Opponent_Space", "Enemy", "Any", 1.0, kuat)
	if not TestValid(empire_attack_target) then
		return
	end
	
	empire_space_units = SpawnList(space_force_definition, kuat, empire, false, false)
	empire_space_fleet = Assemble_Fleet(empire_space_units)
	BlockOnCommand(empire_space_fleet.Move_To(empire_attack_target))
	
	Sleep(1)	
	
	if TestValid(empire_space_fleet) and empire_space_fleet.Get_Planet_Location() == empire_attack_target.Get_Game_Object() then
		Sleep(1)
		empire_land_units = SpawnList(land_force_definition, kuat, empire, false, false)
		empire_land_fleet = Assemble_Fleet(empire_land_units)
		BlockOnCommand(empire_land_fleet.Move_To(empire_attack_target))
		empire_land_fleet.Invade()
	end
end

function Periodic_Minor_Empire_Attack()
	while true do
		sleep_time = GameRandom(300, 500)
		Sleep(sleep_time)
		
		--Don't overload the player!
		--No attack if there's one already pending
		if Create_Thread.Is_Thread_Active(empire_attack_thread_id) == false then
			--No attack if the player needs some breathing room
			if EvaluatePerception("Should_Shutdown_Offense_For_Story_Campaign", empire) == 0 then
				empire_attack_thread_id = Create_Thread("Minor_Empire_Attack")	
			end
		end
	end
end

--Watch out for Rebel planets being taken by the Underworld.  Each time this happens we should launch
--a retaliatory strike
function Monitor_Planet_Ownership_For_Rebel_Losses()
	complete_planet_list = FindPlanet.Get_All_Planets()
	planet_ownership_table = {}
	
	while true do
		for i, planet in pairs(complete_planet_list) do
			planet_owner = planet.Get_Owner()
			if planet_ownership_table[planet] == rebel and planet_owner == underworld then
				--Don't overload the player!
				--No attack if there's one already pending
				if Create_Thread.Is_Thread_Active(rebel_attack_thread_id) == false then
					--No attack if the player needs some breathing room
					if EvaluatePerception("Should_Shutdown_Offense_For_Story_Campaign", rebel) == 0 then			
						rebel_attack_thread_id = Create_Thread("The_Rebellion_Strikes_Back")
					end
				end
			end
			planet_ownership_table[planet] = planet_owner
			Sleep(0.5)
		end
		Sleep(5)
	end
end

--Thread function to execute the Rebel attack that is triggered when the Underworld takes a Rebel planet
function The_Rebellion_Strikes_Back()
	
	if (not TestValid(rebel_attack_source)) or (rebel_attack_source.Get_Owner() ~= rebel) then
		return
	end
	
	rebel_reaction_space_force_definition = { 	"Y-Wing_Squadron",
												"Y-Wing_Squadron",
												"Rebel_X-Wing_Squadron",
												"Rebel_X-Wing_Squadron",
												"Rebel_X-Wing_Squadron",
												"B-Wing_Squadron",
												"B-Wing_Squadron",
												"Corellian_Corvette",
												"Corellian_Corvette",
												"Corellian_Gunboat",
												"Marauder_Missile_Cruiser",
												"Marauder_Missile_Cruiser",
												"Alliance_Assault_Frigate",
												"MC30_Frigate",
												"Nebulon_B_Frigate",
												"Nebulon_B_Frigate" }
												
	rebel_reaction_land_force_definition = {	"Y-Wing_Squadron",
												"Rebel_X-Wing_Squadron",
												"Rebel_X-Wing_Squadron",
												"Corellian_Corvette",
												"Marauder_Missile_Cruiser",
												"Nebulon_B_Frigate",
												"Nebulon_B_Frigate",
												"Rebel_Infantry_Squad",
												"Rebel_Infantry_Squad",
												"Rebel_Tank_Buster_Squad",
												"Rebel_Infiltrator_Team",
												"Rebel_Light_Tank_Brigade",
												"Rebel_Artillery_Brigade",
												"Gallofree_HTT_Company",
												"Rebel_Heavy_Tank_Brigade",
												"Rebel_Heavy_Tank_Brigade" }
	
	--Only retaliate if we can reach an Underworld planet without engaging the Empire.  May be a bit restrictive since
	--Rebel planets are so dispersed.
	rebel_attack_target = FindTarget.Reachable_Target(rebel, "Is_Neglected_By_My_Opponent_Space", "Enemy", "Enemy_Undefended", 1.0, rebel_attack_source)
	if not TestValid(rebel_attack_target) then
		return
	end
	
	rebel_space_units = SpawnList(rebel_reaction_space_force_definition, rebel_attack_source, rebel, false, false)
	rebel_space_fleet = Assemble_Fleet(rebel_space_units)
	BlockOnCommand(rebel_space_fleet.Move_To(rebel_attack_target))
	
	Sleep(1)
	
	if not TestValid(rebel_attack_source) or rebel_attack_source.Get_Owner() ~= rebel then
		return
	end	
	
	if TestValid(rebel_space_fleet) and rebel_space_fleet.Get_Planet_Location() == rebel_attack_target then
		Sleep(1)
		rebel_land_units = SpawnList(rebel_reaction_land_force_definition, rebel_attack_source, rebel, false, false)
		rebel_land_fleet = Assemble_Fleet(rebel_land_units)
		BlockOnCommand(rebel_land_fleet.Move_To(rebel_attack_target))
		rebel_land_fleet.Invade()
	end	
	
end

--Huge Empire fleet wanders the galaxy squashing stuff until wiped out
function Roaming_Empire_Space_Force()

	roaming_empire_fleet_definition = {	"Star_Destroyer",
										"Star_Destroyer",
										"Star_Destroyer",
										"Star_Destroyer",
										"Victory_Destroyer",
										"Victory_Destroyer",
										"Victory_Destroyer",
										"Acclamator_Assault_Ship",
										"Acclamator_Assault_Ship",
										"Acclamator_Assault_Ship",
										"Acclamator_Assault_Ship",										
										"Acclamator_Assault_Ship",
										"Tartan_Patrol_Cruiser",
										"Tartan_Patrol_Cruiser",
										"Tartan_Patrol_Cruiser",
										"Tartan_Patrol_Cruiser",
										"Tartan_Patrol_Cruiser",
										"Tartan_Patrol_Cruiser",
										"Broadside_Class_Cruiser",
										"Broadside_Class_Cruiser",
										"Broadside_Class_Cruiser",
										"TIE_Defender_Squadron",
										"TIE_Defender_Squadron",
										"TIE_Defender_Squadron",
										"TIE_Defender_Squadron",
										"TIE_Phantom_Squadron",
										"TIE_Phantom_Squadron",
										"TIE_Phantom_Squadron",
										"TIE_Phantom_Squadron",
										"TIE_Interceptor_Squadron",
										"TIE_Interceptor_Squadron",
										"TIE_Interceptor_Squadron",
										"TIE_Interceptor_Squadron",
										"TIE_Interceptor_Squadron",
										"TIE_Interceptor_Squadron" }
										
	roaming_empire_fleet_units = SpawnList(roaming_empire_fleet_definition, kuat, empire, false, false)
	roaming_empire_fleet = Assemble_Fleet(roaming_empire_fleet_units)

	while TestValid(roaming_empire_fleet) do
		roaming_fleet_target = FindTarget.Reachable_Target(empire, "Roaming_Empire_Fleet_Target", "Enemy", "Any", 1.0, roaming_empire_fleet.Get_Planet_Location())
		BlockOnCommand(roaming_empire_fleet.Move_To(roaming_fleet_target))			
	end
	
end

