require("pgevents")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	Category = "Build_Special_Item"
	IgnoreTarget = true
	TaskForce = {
	{
		"MainForce",
		"Upgrade = 1"
	}
	}

	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function MainForce_Thread()
	DebugMessage("%s -- In MainForce_Thread.", tostring(Script))
	
	MainForce.Set_As_Goal_System_Removable(false)
	BlockOnCommand(MainForce.Produce_Force())
	MainForce.Set_Plan_Result(true)
	
	DebugMessage("%s -- MainForce done!", tostring(Script));
	ScriptExit()
end

function MainForce_Production_Failed(tf, failed_object_type)
	DebugMessage("%s -- Abandonning plan owing to production failure.", tostring(Script))
	ScriptExit()
end