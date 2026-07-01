--//////////////////////////////////////////////////////////////////////////////////////
-- Add Units to the reinforcement pool// This script is part of the Survival Mode
-- � Pox
--//////////////////////////////////////////////////////////////////////////////////////

require("IA_Spawn_Generic")

function Definitions()
	
	DebugMessage("%s -- In Definitions", tostring(Script))

	-- possible units to spawn
	unit_table = {
	"CR90",
	"DP20",
	"CHARGER_C70",
	"ARQUITENS",
	"CARRACK_CRUISER_LASERS",
	"ACCLAMATOR_II",
	"ACCLAMATOR_I_ASSAULT",
	"ACCLAMATOR_I_CARRIER",
	"REP_DHC",
	"VICTORY_II_STAR_DESTROYER",
	"VICTORY_I_STAR_DESTROYER",
	"VENATOR_STAR_DESTROYER",
	"INVINCIBLE_CRUISER",
	"IMPERATOR_STAR_DESTROYER",
	"SECUTOR_STAR_DESTROYER",
	"TECTOR_STAR_DESTROYER",
	"MAELSTROM_BATTLECRUISER",
	"PROCURATOR_BATTLECRUISER",
	"PRAETOR_I_BATTLECRUISER",
	"PELTA_ASSAULT",
	"PELTA_SUPPORT",
	"NEUTRON_STAR",
	"MANDATOR_II_DREADNOUGHT",
	"MANDATOR_I_DREADNOUGHT",
}

	Define_State("State_Init", State_Init);


end


function State_Init(message)
	if message == OnEnter then
		IA_Spawn(Object.Get_Type().Get_Name(), "INSTANTACTION_MARKER_EMPIRE", "Empire", unit_table)
		ScriptExit()
		
	end
end