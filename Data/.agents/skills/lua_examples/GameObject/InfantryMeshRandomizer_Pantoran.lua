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
			Hide_Sub_Object(Object, 0, "Pantoran_F_Blue")

			Hide_Sub_Object(Object, 1, "Pantoran_M_01_Blue")
			Hide_Sub_Object(Object, 1, "Pantoran_M_02_Blue")
			Hide_Sub_Object(Object, 1, "Pantoran_M_03_Blue")
		elseif skin_colour == 2 then
			Hide_Sub_Object(Object, 0, "Pantoran_M_01_Blue")

			Hide_Sub_Object(Object, 1, "Pantoran_F_Blue")
			Hide_Sub_Object(Object, 1, "Pantoran_M_02_Blue")
			Hide_Sub_Object(Object, 1, "Pantoran_M_03_Blue")
		elseif skin_colour == 3 then
			Hide_Sub_Object(Object, 0, "Pantoran_M_02_Blue")

			Hide_Sub_Object(Object, 1, "Pantoran_F_Blue")
			Hide_Sub_Object(Object, 1, "Pantoran_M_01_Blue")
			Hide_Sub_Object(Object, 1, "Pantoran_M_03_Blue")
		elseif skin_colour == 4 then
			Hide_Sub_Object(Object, 0, "Pantoran_M_03_Blue")

			Hide_Sub_Object(Object, 1, "Pantoran_F_Blue")
			Hide_Sub_Object(Object, 1, "Pantoran_M_01_Blue")
			Hide_Sub_Object(Object, 1, "Pantoran_M_02_Blue")
		end
		ScriptExit()
	end
end