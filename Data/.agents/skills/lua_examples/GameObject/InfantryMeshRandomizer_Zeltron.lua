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
		local skin_colour = GameRandom.Free_Random(1, 4)
		if skin_colour == 1 then
			Hide_Sub_Object(Object, 0, "Zeltron_F_Pink")

			Hide_Sub_Object(Object, 1, "Zeltron_M_01_Pink")
			Hide_Sub_Object(Object, 1, "Zeltron_M_02_Pink")
			Hide_Sub_Object(Object, 1, "Zeltron_M_03_Pink")
		elseif skin_colour == 2 then
			Hide_Sub_Object(Object, 0, "Zeltron_M_01_Pink")

			Hide_Sub_Object(Object, 1, "Zeltron_F_Pink")
			Hide_Sub_Object(Object, 1, "Zeltron_M_02_Pink")
			Hide_Sub_Object(Object, 1, "Zeltron_M_03_Pink")
		elseif skin_colour == 3 then
			Hide_Sub_Object(Object, 0, "Zeltron_M_02_Pink")

			Hide_Sub_Object(Object, 1, "Zeltron_F_Pink")
			Hide_Sub_Object(Object, 1, "Zeltron_M_01_Pink")
			Hide_Sub_Object(Object, 1, "Zeltron_M_03_Pink")
		elseif skin_colour == 4 then
			Hide_Sub_Object(Object, 0, "Zeltron_M_03_Pink")

			Hide_Sub_Object(Object, 1, "Zeltron_F_Pink")
			Hide_Sub_Object(Object, 1, "Zeltron_M_01_Pink")
			Hide_Sub_Object(Object, 1, "Zeltron_M_02_Pink")
		end
		ScriptExit()
	end
end