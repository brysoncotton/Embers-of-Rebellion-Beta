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
		local skin_colour = WeightedRandomIndex({1,1,6,3,1,1,10,   1,1,6,3,1,1,10})
		if skin_colour == 1 then
			Hide_Sub_Object(Object, 0, "NI_Twilek_M_Blue")

			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Cyan")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Green")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Orange")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Red")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Violet")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Yellow")

			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Blue")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Green")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Orange")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Red")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Violet_Dark")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Violet_Light")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Yellow")
		elseif skin_colour == 2 then
			Hide_Sub_Object(Object, 0, "NI_Twilek_M_Cyan")

			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Blue")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Green")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Orange")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Red")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Violet")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Yellow")

			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Blue")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Green")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Orange")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Red")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Violet_Dark")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Violet_Light")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Yellow")
		elseif skin_colour == 3 then
			Hide_Sub_Object(Object, 0, "NI_Twilek_M_Green")

			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Blue")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Cyan")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Orange")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Red")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Violet")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Yellow")

			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Blue")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Green")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Orange")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Red")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Violet_Dark")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Violet_Light")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Yellow")
		elseif skin_colour == 4 then
			Hide_Sub_Object(Object, 0, "NI_Twilek_M_Orange")

			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Blue")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Cyan")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Green")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Red")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Violet")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Yellow")

			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Blue")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Green")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Orange")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Red")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Violet_Dark")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Violet_Light")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Yellow")
		elseif skin_colour == 5 then
			Hide_Sub_Object(Object, 0, "NI_Twilek_M_Red")

			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Blue")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Cyan")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Green")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Orange")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Violet")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Yellow")

			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Blue")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Green")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Orange")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Red")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Violet_Dark")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Violet_Light")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Yellow")
			elseif skin_colour == 6 then
			Hide_Sub_Object(Object, 0, "NI_Twilek_M_Violet")

			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Blue")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Cyan")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Green")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Orange")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Red")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Yellow")

			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Blue")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Green")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Orange")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Red")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Violet_Dark")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Violet_Light")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Yellow")
		elseif skin_colour == 7 then
			Hide_Sub_Object(Object, 0, "NI_Twilek_M_Yellow")

			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Blue")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Cyan")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Green")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Orange")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Red")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Violet")

			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Blue")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Green")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Orange")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Red")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Violet_Dark")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Violet_Light")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Yellow")
		elseif skin_colour == 8 then
			Hide_Sub_Object(Object, 0, "NI_Twilek_F_Blue")

			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Blue")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Cyan")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Green")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Orange")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Red")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Violet")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Yellow")

			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Green")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Orange")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Red")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Violet_Dark")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Violet_Light")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Yellow")
			elseif skin_colour == 9 then
			Hide_Sub_Object(Object, 0, "NI_Twilek_F_Green")

			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Blue")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Cyan")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Green")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Orange")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Red")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Violet")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Yellow")

			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Blue")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Orange")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Red")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Violet_Dark")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Violet_Light")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Yellow")
		elseif skin_colour == 10 then
			Hide_Sub_Object(Object, 0, "NI_Twilek_F_Orange")

			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Blue")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Cyan")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Green")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Orange")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Red")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Violet")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Yellow")

			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Blue")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Green")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Red")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Violet_Dark")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Violet_Light")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Yellow")
		elseif skin_colour == 11 then
			Hide_Sub_Object(Object, 0, "NI_Twilek_F_Red")

			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Blue")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Cyan")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Green")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Orange")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Red")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Violet")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Yellow")

			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Blue")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Green")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Orange")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Violet_Dark")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Violet_Light")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Yellow")
			elseif skin_colour == 12 then
			Hide_Sub_Object(Object, 0, "NI_Twilek_F_Violet_Dark")

			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Blue")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Cyan")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Green")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Orange")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Red")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Violet")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Yellow")

			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Blue")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Green")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Orange")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Red")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Violet_Light")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Yellow")
		elseif skin_colour == 13 then
			Hide_Sub_Object(Object, 0, "NI_Twilek_F_Violet_Light")

			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Blue")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Cyan")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Green")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Orange")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Red")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Violet")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Yellow")

			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Blue")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Green")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Orange")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Red")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Violet_Dark")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Yellow")
		elseif skin_colour == 14 then
			Hide_Sub_Object(Object, 0, "NI_Twilek_F_Yellow")

			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Blue")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Cyan")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Green")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Orange")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Red")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Violet")
			Hide_Sub_Object(Object, 1, "NI_Twilek_M_Yellow")

			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Blue")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Green")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Orange")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Red")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Violet_Dark")
			Hide_Sub_Object(Object, 1, "NI_Twilek_F_Violet_Light")
		end
		ScriptExit()
	end
end
