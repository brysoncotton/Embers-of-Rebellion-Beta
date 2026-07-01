require("pgevents")

-- Galactic Flush MajorItem Budget Script
--

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	
	Category = "Flush_MajorItem_Budget"
	IgnoreTarget = true
	TaskForce = {
	-- First Task Force
	{
		"MainForce"						-- Name of the MainForce, Variable and thread function.
		, "TaskForceRequired"
	}
	}
	
	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function MainForce_Thread()
	DebugMessage("%s -- In MainForce_Thread.", tostring(Script))
		
	Budget.Flush_Category("MajorItem")
	
	DebugMessage("%s -- MainForce Done!  Exiting Script!", tostring(Script))
	ScriptExit()
end

