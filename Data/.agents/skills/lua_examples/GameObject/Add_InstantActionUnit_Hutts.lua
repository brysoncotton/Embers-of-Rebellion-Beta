--//////////////////////////////////////////////////////////////////////////////////////
-- Add Units to the reinforcement pool// This script is part of the Survival Mode
-- � Pox
--//////////////////////////////////////////////////////////////////////////////////////

require("IA_Spawn_Generic")

function Definitions()
	
	DebugMessage("%s -- In Definitions", tostring(Script))

	-- possible units to spawn
	unit_table = {
		"LIGHT_MINSTREL_YACHT",
		"HEAVY_MINSTREL_YACHT",
		"RAKA_FREIGHTER_TENDER",
		"KALOTH_BATTLECRUISER",
		"JUVARD_FRIGATE",
		"HUTT_GALLEON",
		"BARABBULA_FRIGATE",
		"KOSSAK_FRIGATE",
		"UBRIKKIAN_CRUISER_CW",
		"TEMPEST_CRUISER",
		"SZAJIN_CRUISER",
		"KARAGGA_DESTROYER",
		"VONTOR_DESTROYER",
		"VORACIOUS_CARRIER",
		"DORBULLA_WARSHIP",
	}

	Define_State("State_Init", State_Init);


end


function State_Init(message)
	if message == OnEnter then
		IA_Spawn(Object.Get_Type().Get_Name(), "INSTANTACTION_MARKER_HUTTS", "Hutt_Cartels", unit_table)
		ScriptExit()
		
	end
end