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
		local skin_colour = WeightedRandomIndex({2,1,6,1})
		if skin_colour == 1 then
			Hide_Sub_Object(Object, 0, "Togruta_F_Blue")

			Hide_Sub_Object(Object, 1, "Togruta_F_Green")
			Hide_Sub_Object(Object, 1, "Togruta_F_Red")
			Hide_Sub_Object(Object, 1, "Togruta_F_Yellow")
		elseif skin_colour == 2 then
			Hide_Sub_Object(Object, 0, "Togruta_F_Green")

			Hide_Sub_Object(Object, 1, "Togruta_F_Blue")
			Hide_Sub_Object(Object, 1, "Togruta_F_Red")
			Hide_Sub_Object(Object, 1, "Togruta_F_Yellow")
		elseif skin_colour == 3 then
			Hide_Sub_Object(Object, 0, "Togruta_F_Red")

			Hide_Sub_Object(Object, 1, "Togruta_F_Blue")
			Hide_Sub_Object(Object, 1, "Togruta_F_Green")
			Hide_Sub_Object(Object, 1, "Togruta_F_Yellow")
		elseif skin_colour == 4 then
			Hide_Sub_Object(Object, 0, "Togruta_F_Yellow")

			Hide_Sub_Object(Object, 1, "Togruta_F_Blue")
			Hide_Sub_Object(Object, 1, "Togruta_F_Green")
			Hide_Sub_Object(Object, 1, "Togruta_F_Red")
		end
		ScriptExit()
	end
end