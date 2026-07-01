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
		local skin_colour = GameRandom.Free_Random(1, 6)
		if skin_colour == 1 then
			Hide_Sub_Object(Object, 0, "Chiss_M_Blue_Light")

			Hide_Sub_Object(Object, 1, "Chiss_M_01_Blue_Dark")
			Hide_Sub_Object(Object, 1, "Chiss_M_02_Blue_Dark")
			Hide_Sub_Object(Object, 1, "Chiss_M_03_Blue_Dark")
			Hide_Sub_Object(Object, 1, "Chiss_F_Blue_Light")
			Hide_Sub_Object(Object, 1, "Chiss_F_Violet")
		elseif skin_colour == 2 then
			Hide_Sub_Object(Object, 0, "Chiss_M_01_Blue_Dark")

			Hide_Sub_Object(Object, 1, "Chiss_M_Blue_Light")
			Hide_Sub_Object(Object, 1, "Chiss_M_02_Blue_Dark")
			Hide_Sub_Object(Object, 1, "Chiss_M_03_Blue_Dark")
			Hide_Sub_Object(Object, 1, "Chiss_F_Blue_Light")
			Hide_Sub_Object(Object, 1, "Chiss_F_Violet")
		elseif skin_colour == 3 then
			Hide_Sub_Object(Object, 0, "Chiss_M_02_Blue_Dark")

			Hide_Sub_Object(Object, 1, "Chiss_M_Blue_Light")
			Hide_Sub_Object(Object, 1, "Chiss_M_01_Blue_Dark")
			Hide_Sub_Object(Object, 1, "Chiss_M_03_Blue_Dark")
			Hide_Sub_Object(Object, 1, "Chiss_F_Blue_Light")
			Hide_Sub_Object(Object, 1, "Chiss_F_Violet")
		elseif skin_colour == 4 then
			Hide_Sub_Object(Object, 0, "Chiss_M_03_Blue_Dark")

			Hide_Sub_Object(Object, 1, "Chiss_M_Blue_Light")
			Hide_Sub_Object(Object, 1, "Chiss_M_01_Blue_Dark")
			Hide_Sub_Object(Object, 1, "Chiss_M_02_Blue_Dark")
			Hide_Sub_Object(Object, 1, "Chiss_F_Blue_Light")
			Hide_Sub_Object(Object, 1, "Chiss_F_Violet")
		elseif skin_colour == 5 then
			Hide_Sub_Object(Object, 0, "Chiss_F_Blue_Light")

			Hide_Sub_Object(Object, 1, "Chiss_M_Blue_Light")
			Hide_Sub_Object(Object, 1, "Chiss_M_01_Blue_Dark")
			Hide_Sub_Object(Object, 1, "Chiss_M_02_Blue_Dark")
			Hide_Sub_Object(Object, 1, "Chiss_M_03_Blue_Dark")
			Hide_Sub_Object(Object, 1, "Chiss_F_Violet")
		elseif skin_colour == 6 then
			Hide_Sub_Object(Object, 0, "Chiss_F_Violet")

			Hide_Sub_Object(Object, 1, "Chiss_M_Blue_Light")
			Hide_Sub_Object(Object, 1, "Chiss_M_01_Blue_Dark")
			Hide_Sub_Object(Object, 1, "Chiss_M_02_Blue_Dark")
			Hide_Sub_Object(Object, 1, "Chiss_M_03_Blue_Dark")
			Hide_Sub_Object(Object, 1, "Chiss_F_Blue_Light")
		end
		ScriptExit()
	end
end