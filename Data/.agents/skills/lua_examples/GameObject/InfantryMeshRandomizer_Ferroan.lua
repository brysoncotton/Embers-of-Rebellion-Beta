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
			Hide_Sub_Object(Object, 0, "Ferroan_F_Orange")

			Hide_Sub_Object(Object, 1, "Ferroan_M_01_Orange")
			Hide_Sub_Object(Object, 1, "Ferroan_M_02_Orange")
			Hide_Sub_Object(Object, 1, "Ferroan_M_03_Orange")
		elseif skin_colour == 2 then
			Hide_Sub_Object(Object, 0, "Ferroan_M_01_Orange")

			Hide_Sub_Object(Object, 1, "Ferroan_F_Orange")
			Hide_Sub_Object(Object, 1, "Ferroan_M_02_Orange")
			Hide_Sub_Object(Object, 1, "Ferroan_M_03_Orange")
		elseif skin_colour == 3 then
			Hide_Sub_Object(Object, 0, "Ferroan_M_02_Orange")

			Hide_Sub_Object(Object, 1, "Ferroan_F_Orange")
			Hide_Sub_Object(Object, 1, "Ferroan_M_01_Orange")
			Hide_Sub_Object(Object, 1, "Ferroan_M_03_Orange")
		elseif skin_colour == 4 then
			Hide_Sub_Object(Object, 0, "Ferroan_M_03_Orange")

			Hide_Sub_Object(Object, 1, "Ferroan_F_Orange")
			Hide_Sub_Object(Object, 1, "Ferroan_M_01_Orange")
			Hide_Sub_Object(Object, 1, "Ferroan_M_02_Orange")
		end
		ScriptExit()
	end
end