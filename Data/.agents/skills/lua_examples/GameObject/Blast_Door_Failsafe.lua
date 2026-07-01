require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")
require("eawx-util/StoryUtil")
require("deepcore/crossplot/crossplot")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	Define_State("State_Init", State_Init);
end


function State_Init(message)
	if message == OnEnter then
		if Get_Game_Mode() ~= "Land" then
			ScriptExit()
		end
		local terminal_list = Find_All_Objects_Of_Type("GENERIC_CONTROL_PANEL")
		for i, p_terminal in pairs(terminal_list) do
			if TestValid(p_terminal) then
				if p_terminal.Get_Hint() == Object.Get_Hint() then
					Register_Death_Event(p_terminal, State_Terminal_Destroyed)
				end
			end
		end
	end
end

function State_Terminal_Destroyed()
	Object.Play_SFX_Event("SFX_UMP_EmpireKesselAlarm")
	Object.Play_Animation("Cinematic", false, 1)
	Sleep(3.0)
	Object.Despawn()
	ScriptExit()
end