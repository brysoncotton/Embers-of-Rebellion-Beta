--//////////////////////////////////////////////////////////////////////////////////////
-- Add Units to the reinforcement pool// This script is part of the Survival Mode
-- © Pox
--//////////////////////////////////////////////////////////////////////////////////////

require("PGBase")
require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("eawx-util/MissionUtil")

function Definitions()
	
	DebugMessage("%s -- In Definitions", tostring(Script))

	-- possible units to spawn
	unit_table = {
	"TEMPLATE_SUPERCAPITAL_TARGET"
	,"TEMPLATE_CAPITAL_TARGET"
	,"TEMPLATE_HEAVYFRIGATE_TARGET"
	,"TEMPLATE_FRIGATE_TARGET"
	,"TEMPLATE_CORVETTE_TARGET"
	,"TEMPLATE_GUNSHIP_TARGET"
	,"TEMPLATE_FIGHTER_TARGET"
	}

	Define_State("State_Init", State_Init);


end


function State_Init(message)
	if message == OnEnter then
		if Get_Game_Mode() ~= "Space" then
			ScriptExit()
		end
		hostile = Find_Player("Hostile")
		my_name = Object.Get_Type().Get_Name()
		target_spawn_marker = Find_First_Object("INSTANTACTION_MARKER_TARGET")
		

		for i, obj in pairs(unit_table) do
			contain_check = string.find(my_name, obj)
			DebugMessage("%s contain_check returns %s for %s against %s", tostring(Script), tostring(contain_check), tostring(my_name), tostring(obj))
	 			if contain_check ~= nil then
					unit = Find_Object_Type(obj)
					Spawn_Unit(unit, target_spawn_marker, hostile, true, false)
					ScriptExit()
				end
			
		end
		ScriptExit()
		
	end
end