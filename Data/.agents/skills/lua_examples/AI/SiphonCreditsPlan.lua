require("pgevents")

function Definitions()
	Category = "Deploy_Smuggler"
	
	IgnoreTarget = true
	
	TaskForce = {
	{
		"SmugglerForce",						
		"DenyHeroAttach",
		"Smuggler = 1"
	}
	}
end

function SmugglerForce_Thread()
	
	SmugglerForce.Set_As_Goal_System_Removable(false)
	
	Sleep(1)

	AssembleForce(SmugglerForce)
	Sleep(1)
	BlockOnCommand(SmugglerForce.Move_To(Target))
	
	SmugglerForce.Set_Plan_Result(true)
	
	-- Make sure the smuggler taskforce isn't dropped into the freestore before deploying
	Sleep(40)
	
	DebugMessage("%s -- SmugglerForce Done!  Exiting Script!", tostring(Script))
	ScriptExit()
end