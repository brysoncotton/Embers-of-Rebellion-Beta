--//////////////////////////////////////////////////////////////////////////////////////
-- Add Units to the reinforcement pool// This script is part of the Survival Mode
-- � Pox
--//////////////////////////////////////////////////////////////////////////////////////

require("IA_Spawn_Generic")

function Definitions()
	
	DebugMessage("%s -- In Definitions", tostring(Script))

	-- possible units to spawn
	unit_table = {
	"PURSUER_ENFORCEMENT_SHIP_GROUP",
	"GOZANTI_CRUISER_GROUP",
	"DIAMOND_FRIGATE",
	"HARDCELL",
	"LUPUS_MISSILE_FRIGATE",
	"SABAOTH_FRIGATE_SPY",
	"SABAOTH_FRIGATE",
	"SABAOTH_HEX_DEPLOYER",
	"GEONOSIAN_CRUISER",
	"C9979_CARRIER",
	"MUNIFEX",
	"MUNIFICENT",
	"RECUSANT_LIGHT_DESTROYER",
	"CAPTOR",
	"SABAOTH_DESTROYER",
	"BULWARK_II",
	"BULWARK_I",
	"DH_OMNI",
	"PROVIDENCE_DESTROYER",
	"PROVIDENCE_CARRIER_DESTROYER",
	"LUCREHULK_CARRIER",
	"LUCREHULK_BATTLESHIP",
	"AUXILIA",
	"DEVASTATION",
	"SUBJUGATOR",
}

	Define_State("State_Init", State_Init);


end


function State_Init(message)
	if message == OnEnter then	
		IA_Spawn(Object.Get_Type().Get_Name(), "INSTANTACTION_MARKER_NEWREP", "Rebel", unit_table)
		ScriptExit()
		
	end
end