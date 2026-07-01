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
		local skin_colour = WeightedRandomIndex({3,1,12,5,3})
		if skin_colour == 1 then
			Hide_Sub_Object(Object, 0, "Mon_Calamari_Blue")

			Hide_Sub_Object(Object, 1, "Mon_Calamari_Green")
			Hide_Sub_Object(Object, 1, "Mon_Calamari_Orange")
			Hide_Sub_Object(Object, 1, "Mon_Calamari_Red")
			Hide_Sub_Object(Object, 1, "Mon_Calamari_White")
		elseif skin_colour == 2 then
			Hide_Sub_Object(Object, 0, "Mon_Calamari_Green")

			Hide_Sub_Object(Object, 1, "Mon_Calamari_Blue")
			Hide_Sub_Object(Object, 1, "Mon_Calamari_Orange")
			Hide_Sub_Object(Object, 1, "Mon_Calamari_Red")
			Hide_Sub_Object(Object, 1, "Mon_Calamari_White")
		elseif skin_colour == 3 then
			Hide_Sub_Object(Object, 0, "Mon_Calamari_Orange")

			Hide_Sub_Object(Object, 1, "Mon_Calamari_Blue")
			Hide_Sub_Object(Object, 1, "Mon_Calamari_Green")
			Hide_Sub_Object(Object, 1, "Mon_Calamari_Red")
			Hide_Sub_Object(Object, 1, "Mon_Calamari_White")
		elseif skin_colour == 4 then
			Hide_Sub_Object(Object, 0, "Mon_Calamari_Red")

			Hide_Sub_Object(Object, 1, "Mon_Calamari_Blue")
			Hide_Sub_Object(Object, 1, "Mon_Calamari_Green")
			Hide_Sub_Object(Object, 1, "Mon_Calamari_Orange")
			Hide_Sub_Object(Object, 1, "Mon_Calamari_White")
		elseif skin_colour == 5 then
			Hide_Sub_Object(Object, 0, "Mon_Calamari_White")

			Hide_Sub_Object(Object, 1, "Mon_Calamari_Blue")
			Hide_Sub_Object(Object, 1, "Mon_Calamari_Green")
			Hide_Sub_Object(Object, 1, "Mon_Calamari_Orange")
			Hide_Sub_Object(Object, 1, "Mon_Calamari_Red")
		end
		ScriptExit()
	end
end