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
		local skin_colour = WeightedRandomIndex({4,6,5,5})
		if skin_colour == 1 then
			Hide_Sub_Object(Object, 0, "Duros_M_Blue")

			Hide_Sub_Object(Object, 1, "Duros_M_Cyan")
			Hide_Sub_Object(Object, 1, "Duros_M_Green")
			Hide_Sub_Object(Object, 1, "Duros_M_Olive")
		elseif skin_colour == 2 then
			Hide_Sub_Object(Object, 0, "Duros_M_Cyan")

			Hide_Sub_Object(Object, 1, "Duros_M_Blue")
			Hide_Sub_Object(Object, 1, "Duros_M_Green")
			Hide_Sub_Object(Object, 1, "Duros_M_Olive")
		elseif skin_colour == 3 then
			Hide_Sub_Object(Object, 0, "Duros_M_Green")

			Hide_Sub_Object(Object, 1, "Duros_M_Blue")
			Hide_Sub_Object(Object, 1, "Duros_M_Cyan")
			Hide_Sub_Object(Object, 1, "Duros_M_Olive")
		elseif skin_colour == 4 then
			Hide_Sub_Object(Object, 0, "Duros_M_Olive")

			Hide_Sub_Object(Object, 1, "Duros_M_Blue")
			Hide_Sub_Object(Object, 1, "Duros_M_Cyan")
			Hide_Sub_Object(Object, 1, "Duros_M_Green")
		end
		ScriptExit()
	end
end