require("pgevents")


function Definitions()	
	Category = "CIS_Upgrade_Grievous"	
	TaskForce = {
	{
		"ReserveForce"
		,"DenyHeroAttach"
		,"TaskForceRequired"
	}
	}
	AllowFreeStoreUnits = false
end

function ReserveForce_Thread()
	ReserveForce.Set_As_Goal_System_Removable(false)
	
	local faction = PlayerObject.Get_Faction_Name()
	
	if faction == "REBEL" then
		Cycle_Hero("Grievous_Munificent", "Grievous_Malevolence")
		Cycle_Hero("Grievous_Recusant", "Grievous_Malevolence")
		Cycle_Hero("Grievous_Invisible_Hand", "Grievous_Malevolence")
	else
		DebugMessage("%s -- Invalid faction, aborting", tostring(Script))
		ScriptExit()
	end
end

function Cycle_Hero(hero_name, ssd)
	local hero = Find_First_Object(hero_name)
	local cost = -15000

	if TestValid(hero) then
		local new_transport = Spawn_Unit(Find_Object_Type(ssd), Target, PlayerObject)
		hero.Despawn()
		new_transport[1].Prevent_AI_Usage(false)
		PlayerObject.Give_Money(cost)
		ReserveForce.Set_Plan_Result(true)
		ScriptExit()
	else
		DebugMessage("%s -- hero %s not found, skipping", tostring(Script), tostring(hero_name))
	end
end