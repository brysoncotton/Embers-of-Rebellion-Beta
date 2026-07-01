require("pgevents")


function Definitions()	
	Category = "AlwaysOff"
	TaskForce = {
	{
		"ReserveForce"
		,"DenyHeroAttach"
		,"TaskForceRequired"
	}
	}
end

function ReserveForce_Thread()		
	ScriptExit()
end