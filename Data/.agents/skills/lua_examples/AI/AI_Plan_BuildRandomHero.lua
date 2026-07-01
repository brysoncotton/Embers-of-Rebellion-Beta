require("pgevents")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	Category = "Build_Capital"
	IgnoreTarget = true
	TaskForce = {
	{
		"ReserveForce",
		"Random_Clone_Assign | Random_Commando_Assign | Random_Admiral_Assign | Random_Moff_Assign | Random_Council_Assign = 1"
	}
	}

	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function ReserveForce_Thread()
	DebugMessage("%s -- In ReserveForce_Thread.", tostring(Script))	
	ReserveForce.Set_As_Goal_System_Removable(false)
	AssembleForce(ReserveForce)
	
	ReserveForce.Set_Plan_Result(true)

	DebugMessage("%s -- ReserveForce done!", tostring(Script));
	ScriptExit()
end

function ReserveForce_Production_Failed(tf, failed_object_type)
	DebugMessage("%s -- Abandonning plan owing to production failure.", tostring(Script))
	ScriptExit()
end