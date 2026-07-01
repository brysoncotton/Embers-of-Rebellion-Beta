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
		local skin_colour = WeightedRandomIndex({1,4,1,1})
		if skin_colour == 1 then
			Hide_Sub_Object(Object, 0, "Nautolan_Blue_Light")

			Hide_Sub_Object(Object, 1, "Nautolan_Green")
			Hide_Sub_Object(Object, 1, "Nautolan_Blue_Dark")
			Hide_Sub_Object(Object, 1, "Nautolan_Violet")
		elseif skin_colour == 2 then
			Hide_Sub_Object(Object, 0, "Nautolan_Green")

			Hide_Sub_Object(Object, 1, "Nautolan_Blue_Light")
			Hide_Sub_Object(Object, 1, "Nautolan_Blue_Dark")
			Hide_Sub_Object(Object, 1, "Nautolan_Violet")
		elseif skin_colour == 3 then
			Hide_Sub_Object(Object, 0, "Nautolan_Blue_Dark")

			Hide_Sub_Object(Object, 1, "Nautolan_Blue_Light")
			Hide_Sub_Object(Object, 1, "Nautolan_Green")
			Hide_Sub_Object(Object, 1, "Nautolan_Violet")
		elseif skin_colour == 4 then
			Hide_Sub_Object(Object, 0, "Nautolan_Violet")

			Hide_Sub_Object(Object, 1, "Nautolan_Blue_Light")
			Hide_Sub_Object(Object, 1, "Nautolan_Green")
			Hide_Sub_Object(Object, 1, "Nautolan_Blue_Dark")
		end
		ScriptExit()
	end
end