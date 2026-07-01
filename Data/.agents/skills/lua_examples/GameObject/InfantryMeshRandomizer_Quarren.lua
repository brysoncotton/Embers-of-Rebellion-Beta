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
		local skin_colour = WeightedRandomIndex({1,2,8,5,1})
		if skin_colour == 1 then
			Hide_Sub_Object(Object, 0, "Quarren_M_Blue")

			Hide_Sub_Object(Object, 1, "Quarren_M_Green")
			Hide_Sub_Object(Object, 1, "Quarren_M_Orange")
			Hide_Sub_Object(Object, 1, "Quarren_M_Red")
			Hide_Sub_Object(Object, 1, "Quarren_M_Violet")
		elseif skin_colour == 2 then
			Hide_Sub_Object(Object, 0, "Quarren_M_Green")

			Hide_Sub_Object(Object, 1, "Quarren_M_Blue")
			Hide_Sub_Object(Object, 1, "Quarren_M_Orange")
			Hide_Sub_Object(Object, 1, "Quarren_M_Red")
			Hide_Sub_Object(Object, 1, "Quarren_M_Violet")
		elseif skin_colour == 3 then
			Hide_Sub_Object(Object, 0, "Quarren_M_Orange")

			Hide_Sub_Object(Object, 1, "Quarren_M_Blue")
			Hide_Sub_Object(Object, 1, "Quarren_M_Green")
			Hide_Sub_Object(Object, 1, "Quarren_M_Red")
			Hide_Sub_Object(Object, 1, "Quarren_M_Violet")
		elseif skin_colour == 4 then
			Hide_Sub_Object(Object, 0, "Quarren_M_Red")

			Hide_Sub_Object(Object, 1, "Quarren_M_Blue")
			Hide_Sub_Object(Object, 1, "Quarren_M_Green")
			Hide_Sub_Object(Object, 1, "Quarren_M_Orange")
			Hide_Sub_Object(Object, 1, "Quarren_M_Violet")
		elseif skin_colour == 5 then
			Hide_Sub_Object(Object, 0, "Quarren_M_Violet")

			Hide_Sub_Object(Object, 1, "Quarren_M_Blue")
			Hide_Sub_Object(Object, 1, "Quarren_M_Green")
			Hide_Sub_Object(Object, 1, "Quarren_M_Orange")
			Hide_Sub_Object(Object, 1, "Quarren_M_Red")
		end
		ScriptExit()
	end
end