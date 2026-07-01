require("pgevents")

ScriptPoolCount = 1

function Definitions()
	Category = "CIS_Fund_Subfactions"
	IgnoreTarget = true
	TaskForce = {
	{
		"ReserveForce"
		,"DenyHeroAttach"
		,"Stimulus_IGBC | Stimulus_Commerce | Stimulus_TradeFed | Stimulus_Techno = 1"
	}
	}
	AllowFreeStoreUnits = false
end

function ReserveForce_Thread()	
	ReserveForce.Set_As_Goal_System_Removable(false)
	BlockOnCommand(ReserveForce.Produce_Force())
	ReserveForce.Set_Plan_Result(true)
	ScriptExit()
end

function StructureForce_Production_Failed(tf, failed_object_type)
	DebugMessage("%s -- Abandonning plan owing to production failure.", tostring(Script))
	ScriptExit()
end