require("PGStateMachine")
require("eawx-util/Math")

function Definitions()
	Define_State("State_Init", State_Init)
end

function State_Init(message)
	if Get_Game_Mode() ~= "Land" then
		ScriptExit()
	end

	if message == OnEnter then
		local skin_colour = GameRandom.Free_Random(1, 2)
		if skin_colour == 1 then
			Hide_Sub_Object(Object, 0, "Falleen_M_Green")

			Hide_Sub_Object(Object, 1, "Falleen_F_Green")
		elseif skin_colour == 2 then
			Hide_Sub_Object(Object, 0, "Falleen_F_Green")

			Hide_Sub_Object(Object, 1, "Falleen_M_Green")
		end
		ScriptExit()
	end
end