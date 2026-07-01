--//////////////////////////////////////////////////////////////////////////////////////
-- Add Units to the reinforcement pool// This script is part of the Survival Mode
-- © Pox
--//////////////////////////////////////////////////////////////////////////////////////

require("PGBase")
require("PGStateMachine")
require("PGStoryMode")
require("eawx-util/MissionUtil")

function Definitions()
	
	DebugMessage("%s -- In Definitions", tostring(Script))

	Define_State("State_Init", State_Init);


end


function State_Init(message)
	if message == OnEnter then
		if Get_Game_Mode() ~= "Space" then
			ScriptExit()
		end
		local factional = GlobalValue.Get("FACTIONAL_FIGHTERS")
		if factional then
			factional = nil
			Story_Event("AI_NOTIF_IA_FF_OFF")
		else
			factional = true
			Story_Event("AI_NOTIF_IA_FF_ON")
		end
		GlobalValue.Set("FACTIONAL_FIGHTERS", factional)
		ScriptExit()
		
	end
end