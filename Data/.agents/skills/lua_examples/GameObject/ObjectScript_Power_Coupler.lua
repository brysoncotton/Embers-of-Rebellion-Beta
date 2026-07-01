require("PGStateMachine")
require("PGStoryMode")
require("TRCommands")

function Definitions()
	Define_State("State_Init", State_Init)
end

function State_Init(message)
	if Get_Game_Mode() ~= "Land" then
		ScriptExit()
	end

	if message == OnEnter then
		Object.Play_Animation("Idle", true, 0)
		local p_power_gen = Find_First_Object("Power_Generator")
		if TestValid(p_power_gen) then
			Register_Death_Event(p_power_gen, State_Power_Generator_Destroyed)
		end
		Sleep(5.0)
		if TestValid(p_power_gen) then
			Register_Death_Event(p_power_gen, State_Power_Generator_Destroyed)
		end
		if not TestValid(p_power_gen) then
			ScriptExit()
		end
	end
end

function State_Power_Generator_Destroyed()
	Object.Take_Damage(999999)
	ScriptExit()
end
