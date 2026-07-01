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
		local skin_colour = GameRandom.Free_Random(1, 3)
		if skin_colour == 1 then
			Hide_Sub_Object(Object, 0, "Zabrak_M_Grey")

			Hide_Sub_Object(Object, 1, "Zabrak_M_Orange")
			Hide_Sub_Object(Object, 1, "Zabrak_M_Yellow")
		elseif skin_colour == 2 then
			Hide_Sub_Object(Object, 0, "Zabrak_M_Orange")

			Hide_Sub_Object(Object, 1, "Zabrak_M_Grey")
			Hide_Sub_Object(Object, 1, "Zabrak_M_Yellow")
		elseif skin_colour == 3 then
			Hide_Sub_Object(Object, 0, "Zabrak_M_Yellow")

			Hide_Sub_Object(Object, 1, "Zabrak_M_Grey")
			Hide_Sub_Object(Object, 1, "Zabrak_M_Orange")
		end
		ScriptExit()
	end
end