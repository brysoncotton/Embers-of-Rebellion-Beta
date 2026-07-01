require("pgevents")

-- Build a single turret.

function Definitions()
	
	Category = "Build_Sensor_Node"
	TaskForce = {
	{
		"MainForce"					
		,"TaskForceRequired"
		,"UC_Empire_Sensor_Node | UC_Rebel_Sensor_Node = 1"
	}
	}

end

function MainForce_Thread()
	DebugMessage("%s -- Building a sensor node.", tostring(Script))

	-- Build the task force
	-- Blocking shouldn't be necessary, but we'll use it to ease watching the script
	BlockOnCommand(MainForce.Build_All())
	ScriptExit()
end



