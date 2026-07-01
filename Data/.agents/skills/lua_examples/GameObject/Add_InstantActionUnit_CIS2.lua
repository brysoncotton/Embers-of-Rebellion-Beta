--//////////////////////////////////////////////////////////////////////////////////////
-- Add Units to the reinforcement pool// This script is part of the Survival Mode
-- � Pox
--//////////////////////////////////////////////////////////////////////////////////////

require("IA_Spawn_Generic")

function Definitions()
	
	DebugMessage("%s -- In Definitions", tostring(Script))

	-- possible units to spawn
	unit_table = {
	"INTERCEPTOR_III_FRIGATE",
	"ACTION_VI_SUPPORT",
	"HARDCELL_TENDER",
	"MARAUDER_CRUISER",
	"CIS_PDF_DHC", --Must be above Dreadnaught so IA_PDF_Dreadnaught doesn't match with Dreadnaught first
	"CIS_DHC",
	"MUNIFICENT_HEAVY_CRUISER",
	"MUNIFICENT_TRANSPORT",
	"MUNIFICENT_TENDER",
	"MUNIFICENT_C3",
	"STORM_FLEET_DESTROYER",
	"LUCREHULK_CORE_DESTROYER",
	"PROVIDENCE_CARRIER",
	"RECUSANT_DREADNOUGHT",
	"PROVIDENCE_DREADNOUGHT",
	"LUCREHULK_BULK_CRUISER",
	"LUCREHULK_AUXILIARY_CONTROL",
	"LUCREHULK_AUXILIARY",
	"LUCREHULK_CARRIER_CONTROL",
}

	Define_State("State_Init", State_Init);


end


function State_Init(message)
	if message == OnEnter then	
		IA_Spawn(Object.Get_Type().Get_Name(), "INSTANTACTION_MARKER_NEWREP_2", "Rebel", unit_table)
		ScriptExit()
		
	end
end