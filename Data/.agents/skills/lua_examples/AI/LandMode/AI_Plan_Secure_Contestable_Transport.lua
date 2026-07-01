require("pgevents")

function Definitions()

	Category = "Secure_Contestable | Secure_Contestable_Escorted"
	IgnoreTarget = true
	TaskForce = 
	{
		{
			"MainForce"		
			,"Infantry | InfantryHero = 1,4"
			,"-Mandalorian_Commando_Container"
			,"-B2_RP_Droid_Container"
			,"-Clone_Jumptrooper_One_Container"
			,"-Clone_Jumptrooper_Two_Container"
			,"-Juggernaut_War_Droid_Container"
			,"-CorSec_Combat_Probot_Container"
			,"-Imperial_Jumptrooper_Container"
		},
		{
			"EscortForce"
			,"PAC | MAF"..
			"| Luxury_Barge | VAAT | LAAT | Gallofree_HTT_Transport | A4_Juggernaut | A5_Juggernaut | A6_Juggernaut | A5RX | JX30"..
			"| Morut_Gun_Platform | Bral_APC"..
			"| Civil_Gunship"..
			"| Teklos"..
			"| GX12_Hovervan | JX40"..
			"| Rana_APC | Vhork_Gunship"..
			"| A9_Floating_Fortress | PX4 | PX7 | Imperial_Dropship_Transport | MAAT | Reconnaissance_Troop_Transporter | Imperial_APC | B5_Juggernaut"..
			"| AA5_Truck = 1"
		}
	}
	
	garrisoned = false
	unloaded = false
	wait_for_escort = true

	AllowEngagedUnits = false
	
	wait_for_build_time = 10
end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())
	
	QuickReinforce(PlayerObject, AITarget, MainForce, EscortForce)
	
	MainForce.Set_As_Goal_System_Removable(false)
	
	MainForce.Activate_Ability("SPREAD_OUT", false)
	
	while wait_for_escort do
		Sleep(0.5)
	end
	
	-- make sure transports are alive before trying to garrison them
	if TestValid(transport) then
		unit_table = MainForce.Get_Unit_Table()
		for _, unit in pairs(unit_table) do
			DebugMessage("%s -- MainForce checking garrison space in %s", tostring(Script), tostring(transport))
			if unit.Can_Garrison(transport) then
				DebugMessage("%s -- MainForce trying to garrison %s", tostring(Script), tostring(transport))
				unit.Garrison(transport)
			else
				MainForce.Release_Unit(unit)
			end
		end
		
		DebugMessage("%s -- MainForce garrisoned %s", tostring(Script), tostring(transport))
		garrisoned = true
		
		-- keep thread going
		while not unloaded do
			DebugMessage("%s -- MainForce waiting to unload from %s", tostring(Script), tostring(transport))
			Sleep(1)
		end
	else
		BlockOnCommand(MainForce.Move_To(AITarget, MainForce.Get_Self_Threat_Max()))
	end
	
	DebugMessage("%s -- MainForce now at target %s", tostring(Script), tostring(AITarget))
	
	if TestValid(Target) then
        if (EvaluatePerception("Is_Build_Pad", PlayerObject, Target) == 1) then

			-- Build pads may have an existing enemy structure than needs to be removed
			-- Note that the enemy player can build structures late or rebuild destroyed structures, thus the need to repeat.
			structure = Target.Get_Build_Pad_Contents()
			if (structure == nil) or
				(TestValid(structure) and PlayerObject.Get_Faction_Name() ~= structure.Get_Owner().Get_Faction_Name()) then
				
				--Wait for control to transition
				DebugMessage("%s, %s--Guarding for transition", tostring(Script), tostring(Target))
				BlockOnCommand(MainForce.Guard_Target(AITarget), 60, Target_Has_Structure)
				
				--It's been a minute.  If we still don't have control then give up
				if Target.Get_Owner() ~= PlayerObject then
					ScriptExit()
				end				
				
				-- Attack any structure that might be there
				if TestValid(structure) then
					BlockOnCommand(MainForce.Attack_Target(structure))
				end

				-- Guard the spot to give another plan the chance to can something here
				-- Wait indefinately, if this is a refinery pad.
				if EvaluatePerception("Is_Refinery_Pad", PlayerObject, Target) == 1 or
					EvaluatePerception("Is_Outpost_Pad", PlayerObject, Target) == 1 then
					wait_for_build_time = -1
				end
				DebugMessage("%s, %s--Guarding for %d", tostring(Script), tostring(Target), wait_for_build_time)
				BlockOnCommand(MainForce.Guard_Target(AITarget), wait_for_build_time, Target_Has_Structure)
				
			end

		else
			-- Stand guard so that we can retain usage of this structure
			MainForce.Guard_Target(AITarget)
			if EvaluatePerception("Is_Victory_Point", PlayerObject, Target) == 1 then
				Sleep(90)
			else
				Sleep(15)
			end
		end
	end
	
	MainForce.Set_Plan_Result(true)

	ScriptExit()
end

-- Override default handling, which will kill the plan
function MainForce_Original_Target_Owner_Changed(tf, old_player, new_player)
end

-- Does the plan's original Target have a friendlystructure on it?
function Target_Has_Structure()
	if TestValid(Target) then
		structure = Target.Get_Build_Pad_Contents()
        if TestValid(structure) then
			--MessageBox("%s, %s-- Target has structure, abandonning guard.", tostring(Script), tostring(Target))
			return true
		end
	end
	return false
end

function EscortForce_Thread()
	BlockOnCommand(EscortForce.Produce_Force())
	
	QuickReinforce(PlayerObject, AITarget, EscortForce, MainForce)
	
	wait_for_escort = false
	
	Set_Land_AI_Targeting_Priorities(EscortForce)
	
	transport = EscortForce.Get_Unit_Table()[1]
	
	DebugMessage("%s -- EscortForce waiting for garrison", tostring(Script))
	while not garrisoned do
		Sleep(1)
	end
	
	DebugMessage("%s -- EscortForce moving to target %s", tostring(Script), tostring(AITarget))	
	-- move to contestables	
	BlockOnCommand(EscortForce.Move_To(AITarget))
	
	DebugMessage("%s -- EscortForce guarding MainForce at %s", tostring(Script), tostring(AITarget))
	
	EscortAlive = true
	while EscortAlive do
		Escort(EscortForce, MainForce)
	end
end

function EscortForce_Unit_Move_Finished(tf, unit)
	if unit.Has_Garrison() then
		DebugMessage("%s -- EscortForce ejecting garrison", tostring(Script))
		unit.Eject_Garrison()
		unloaded = true
	end
end

function EscortForce_Unit_Damaged(tf, unit, attacker, deliberate)
	if unit.Hull() < 0.5 then
		Default_Unit_Damaged(tf, unit, attacker, deliberate)
	end
end

function EscortForce_No_Units_Remaining()
	EscortAlive = false
	wait_for_escort = false
end

-- Override default handling, which will kill the plan
function EscortForce_Original_Target_Owner_Changed(tf, old_player, new_player)
end