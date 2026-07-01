require("pgevents")

-- Build a field base.

function Definitions()
	
	Category = "Build_Field_Base"
	TaskForce = {
	{
		"MainForce"					
		,"TaskForceRequired"
		,"UC_Republic_Field_Commando_Base | UC_Republic_Field_Scout_Base | UC_Sector_Forces_Field_Commando_Base | UC_Sector_Forces_Field_Scout_Base | UC_CIS_Field_Commando_Base | UC_CIS_Field_Scout_Base | UC_CIS_Subfaction_Field_Scout_Base = 1"
	}
	}

end

function MainForce_Thread()
	-- Build the task force
	-- Blocking shouldn't be necessary, but we'll use it to ease watching the script
	MainForce.Set_Plan_Result(true)
	BlockOnCommand(MainForce.Build_All())
	ScriptExit()
end



