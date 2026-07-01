require("pgevents")

function Definitions()
	
	Category = "Land_Units_Groundwar"
	TaskForce = {
	{
		"MainForce"					
		,"DenyHeroAttach"
		,"Wall = 1,5"
	}
	}
	
	IgnoreTarget = true
	AllowEngagedUnits = false
end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())

	-- find something to reinforce near
	friendly_loc = FindTarget(MainForce, "Current_Friendly_Location", "Tactical_Location", 1.0)
	if not TestValid(friendly_loc) then
		friendly_loc = FindTarget(MainForce, "Is_Friendly_Start", "Tactical_Location", 1.0)
	end
	if not TestValid(friendly_loc) then
		ScriptExit()
	end
	
	WaitForAllReinforcements(MainForce, friendly_loc)
	
	MainForce.Release_Forces(1)
    MainForce.Set_Plan_Result(true)
	Sleep(15)
end




