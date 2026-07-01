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
			Hide_Sub_Object(Object, 0, "Arkanian_F_White")

			Hide_Sub_Object(Object, 1, "Arkanian_M_01_White")
			Hide_Sub_Object(Object, 1, "Arkanian_M_02_White")
			Hide_Sub_Object(Object, 1, "Arkanian_M_03_White")
		elseif skin_colour == 2 then
			Hide_Sub_Object(Object, 0, "Arkanian_M_01_White")

			Hide_Sub_Object(Object, 1, "Arkanian_F_White")
			Hide_Sub_Object(Object, 1, "Arkanian_M_02_White")
			Hide_Sub_Object(Object, 1, "Arkanian_M_03_White")
		elseif skin_colour == 3 then
			Hide_Sub_Object(Object, 0, "Arkanian_M_02_White")

			Hide_Sub_Object(Object, 1, "Arkanian_F_White")
			Hide_Sub_Object(Object, 1, "Arkanian_M_01_White")
			Hide_Sub_Object(Object, 1, "Arkanian_M_03_White")
		elseif skin_colour == 4 then
			Hide_Sub_Object(Object, 0, "Arkanian_M_03_White")

			Hide_Sub_Object(Object, 1, "Arkanian_F_White")
			Hide_Sub_Object(Object, 1, "Arkanian_M_01_White")
			Hide_Sub_Object(Object, 1, "Arkanian_M_02_White")
		end
		ScriptExit()
	end
end