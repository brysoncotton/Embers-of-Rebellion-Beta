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
		local skin_colour = WeightedRandomIndex({4,1,1,1,1})
		if skin_colour == 1 then
			Hide_Sub_Object(Object, 0, "Bothan_F_Brown")

			Hide_Sub_Object(Object, 1, "Bothan_M_01_Black")
			Hide_Sub_Object(Object, 1, "Bothan_M_01_White")
			Hide_Sub_Object(Object, 1, "Bothan_M_02_Black")
			Hide_Sub_Object(Object, 1, "Bothan_M_02_White")
		elseif skin_colour == 2 then
			Hide_Sub_Object(Object, 0, "Bothan_M_01_Black")

			Hide_Sub_Object(Object, 1, "Bothan_F_Brown")
			Hide_Sub_Object(Object, 1, "Bothan_M_01_White")
			Hide_Sub_Object(Object, 1, "Bothan_M_02_Black")
			Hide_Sub_Object(Object, 1, "Bothan_M_02_White")
		elseif skin_colour == 3 then
			Hide_Sub_Object(Object, 0, "Bothan_M_01_White")

			Hide_Sub_Object(Object, 1, "Bothan_F_Brown")
			Hide_Sub_Object(Object, 1, "Bothan_M_01_Black")
			Hide_Sub_Object(Object, 1, "Bothan_M_02_Black")
			Hide_Sub_Object(Object, 1, "Bothan_M_02_White")
		elseif skin_colour == 4 then
			Hide_Sub_Object(Object, 0, "Bothan_M_02_Black")

			Hide_Sub_Object(Object, 1, "Bothan_F_Brown")
			Hide_Sub_Object(Object, 1, "Bothan_M_01_Black")
			Hide_Sub_Object(Object, 1, "Bothan_M_01_White")
			Hide_Sub_Object(Object, 1, "Bothan_M_02_White")
		elseif skin_colour == 5 then
			Hide_Sub_Object(Object, 0, "Bothan_M_02_White")

			Hide_Sub_Object(Object, 1, "Bothan_F_Brown")
			Hide_Sub_Object(Object, 1, "Bothan_M_01_Black")
			Hide_Sub_Object(Object, 1, "Bothan_M_01_White")
			Hide_Sub_Object(Object, 1, "Bothan_M_02_Black")
		end
		ScriptExit()
	end
end