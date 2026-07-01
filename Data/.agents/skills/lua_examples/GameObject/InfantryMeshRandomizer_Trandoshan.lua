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
		local skin_colour = WeightedRandomIndex({1,2,8,4,1,3})
		if skin_colour == 1 then
			Hide_Sub_Object(Object, 0, "Trandoshan_M_Blue")

			Hide_Sub_Object(Object, 1, "Trandoshan_M_Cyan")
			Hide_Sub_Object(Object, 1, "Trandoshan_M_Green")
			Hide_Sub_Object(Object, 1, "Trandoshan_M_Orange")
			Hide_Sub_Object(Object, 1, "Trandoshan_M_Red")
			Hide_Sub_Object(Object, 1, "Trandoshan_M_Yellow")
		elseif skin_colour == 2 then
			Hide_Sub_Object(Object, 0, "Trandoshan_M_Cyan")

			Hide_Sub_Object(Object, 1, "Trandoshan_M_Blue")
			Hide_Sub_Object(Object, 1, "Trandoshan_M_Green")
			Hide_Sub_Object(Object, 1, "Trandoshan_M_Orange")
			Hide_Sub_Object(Object, 1, "Trandoshan_M_Red")
			Hide_Sub_Object(Object, 1, "Trandoshan_M_Yellow")
		elseif skin_colour == 3 then
			Hide_Sub_Object(Object, 0, "Trandoshan_M_Green")

			Hide_Sub_Object(Object, 1, "Trandoshan_M_Blue")
			Hide_Sub_Object(Object, 1, "Trandoshan_M_Cyan")
			Hide_Sub_Object(Object, 1, "Trandoshan_M_Orange")
			Hide_Sub_Object(Object, 1, "Trandoshan_M_Red")
			Hide_Sub_Object(Object, 1, "Trandoshan_M_Yellow")
		elseif skin_colour == 4 then
			Hide_Sub_Object(Object, 0, "Trandoshan_M_Orange")

			Hide_Sub_Object(Object, 1, "Trandoshan_M_Blue")
			Hide_Sub_Object(Object, 1, "Trandoshan_M_Cyan")
			Hide_Sub_Object(Object, 1, "Trandoshan_M_Green")
			Hide_Sub_Object(Object, 1, "Trandoshan_M_Red")
			Hide_Sub_Object(Object, 1, "Trandoshan_M_Yellow")
		elseif skin_colour == 5 then
			Hide_Sub_Object(Object, 0, "Trandoshan_M_Red")

			Hide_Sub_Object(Object, 1, "Trandoshan_M_Blue")
			Hide_Sub_Object(Object, 1, "Trandoshan_M_Cyan")
			Hide_Sub_Object(Object, 1, "Trandoshan_M_Green")
			Hide_Sub_Object(Object, 1, "Trandoshan_M_Orange")
			Hide_Sub_Object(Object, 1, "Trandoshan_M_Yellow")
		elseif skin_colour == 6 then
			Hide_Sub_Object(Object, 0, "Trandoshan_M_Yellow")

			Hide_Sub_Object(Object, 1, "Trandoshan_M_Blue")
			Hide_Sub_Object(Object, 1, "Trandoshan_M_Cyan")
			Hide_Sub_Object(Object, 1, "Trandoshan_M_Green")
			Hide_Sub_Object(Object, 1, "Trandoshan_M_Orange")
			Hide_Sub_Object(Object, 1, "Trandoshan_M_Red")
		end
		ScriptExit()
	end
end