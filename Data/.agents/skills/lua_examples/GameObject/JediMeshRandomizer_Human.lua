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
		local skin_colour = GameRandom.Free_Random(1, 9)
		if skin_colour == 1 then
			Hide_Sub_Object(Object, 0, "Human_F_01")

			Hide_Sub_Object(Object, 1, "Human_F_02")

			Hide_Sub_Object(Object, 1, "Human_M_01")
			Hide_Sub_Object(Object, 1, "Human_M_02")
			Hide_Sub_Object(Object, 1, "Human_M_03")
			Hide_Sub_Object(Object, 1, "Human_M_04")
			Hide_Sub_Object(Object, 1, "Human_M_05")
			Hide_Sub_Object(Object, 1, "Human_M_06")
			Hide_Sub_Object(Object, 1, "Human_M_07")
		elseif skin_colour == 2 then
			Hide_Sub_Object(Object, 0, "Human_F_02")

			Hide_Sub_Object(Object, 1, "Human_F_01")

			Hide_Sub_Object(Object, 1, "Human_M_01")
			Hide_Sub_Object(Object, 1, "Human_M_02")
			Hide_Sub_Object(Object, 1, "Human_M_03")
			Hide_Sub_Object(Object, 1, "Human_M_04")
			Hide_Sub_Object(Object, 1, "Human_M_05")
			Hide_Sub_Object(Object, 1, "Human_M_06")
			Hide_Sub_Object(Object, 1, "Human_M_07")
		elseif skin_colour == 3 then
			Hide_Sub_Object(Object, 0, "Human_M_01")

			Hide_Sub_Object(Object, 1, "Human_F_01")
			Hide_Sub_Object(Object, 1, "Human_F_02")

			Hide_Sub_Object(Object, 1, "Human_M_02")
			Hide_Sub_Object(Object, 1, "Human_M_03")
			Hide_Sub_Object(Object, 1, "Human_M_04")
			Hide_Sub_Object(Object, 1, "Human_M_05")
			Hide_Sub_Object(Object, 1, "Human_M_06")
			Hide_Sub_Object(Object, 1, "Human_M_07")
		elseif skin_colour == 4 then
			Hide_Sub_Object(Object, 0, "Human_M_02")

			Hide_Sub_Object(Object, 1, "Human_F_01")
			Hide_Sub_Object(Object, 1, "Human_F_02")

			Hide_Sub_Object(Object, 1, "Human_M_01")
			Hide_Sub_Object(Object, 1, "Human_M_03")
			Hide_Sub_Object(Object, 1, "Human_M_04")
			Hide_Sub_Object(Object, 1, "Human_M_05")
			Hide_Sub_Object(Object, 1, "Human_M_06")
			Hide_Sub_Object(Object, 1, "Human_M_07")
		elseif skin_colour == 5 then
			Hide_Sub_Object(Object, 0, "Human_M_03")

			Hide_Sub_Object(Object, 1, "Human_F_01")
			Hide_Sub_Object(Object, 1, "Human_F_02")

			Hide_Sub_Object(Object, 1, "Human_M_01")
			Hide_Sub_Object(Object, 1, "Human_M_02")
			Hide_Sub_Object(Object, 1, "Human_M_04")
			Hide_Sub_Object(Object, 1, "Human_M_05")
			Hide_Sub_Object(Object, 1, "Human_M_06")
			Hide_Sub_Object(Object, 1, "Human_M_07")
		elseif skin_colour == 6 then
			Hide_Sub_Object(Object, 0, "Human_M_04")

			Hide_Sub_Object(Object, 1, "Human_F_01")
			Hide_Sub_Object(Object, 1, "Human_F_02")

			Hide_Sub_Object(Object, 1, "Human_M_01")
			Hide_Sub_Object(Object, 1, "Human_M_02")
			Hide_Sub_Object(Object, 1, "Human_M_03")
			Hide_Sub_Object(Object, 1, "Human_M_05")
			Hide_Sub_Object(Object, 1, "Human_M_06")
			Hide_Sub_Object(Object, 1, "Human_M_07")
			elseif skin_colour == 7 then
			Hide_Sub_Object(Object, 0, "Human_M_05")

			Hide_Sub_Object(Object, 1, "Human_F_01")
			Hide_Sub_Object(Object, 1, "Human_F_02")

			Hide_Sub_Object(Object, 1, "Human_M_01")
			Hide_Sub_Object(Object, 1, "Human_M_02")
			Hide_Sub_Object(Object, 1, "Human_M_03")
			Hide_Sub_Object(Object, 1, "Human_M_04")
			Hide_Sub_Object(Object, 1, "Human_M_06")
			Hide_Sub_Object(Object, 1, "Human_M_07")
		elseif skin_colour == 8 then
			Hide_Sub_Object(Object, 0, "Human_M_06")

			Hide_Sub_Object(Object, 1, "Human_F_01")
			Hide_Sub_Object(Object, 1, "Human_F_02")

			Hide_Sub_Object(Object, 1, "Human_M_01")
			Hide_Sub_Object(Object, 1, "Human_M_02")
			Hide_Sub_Object(Object, 1, "Human_M_03")
			Hide_Sub_Object(Object, 1, "Human_M_04")
			Hide_Sub_Object(Object, 1, "Human_M_05")
			Hide_Sub_Object(Object, 1, "Human_M_07")
		elseif skin_colour == 9 then
			Hide_Sub_Object(Object, 0, "Human_M_07")

			Hide_Sub_Object(Object, 1, "Human_F_01")
			Hide_Sub_Object(Object, 1, "Human_F_02")

			Hide_Sub_Object(Object, 1, "Human_M_01")
			Hide_Sub_Object(Object, 1, "Human_M_02")
			Hide_Sub_Object(Object, 1, "Human_M_03")
			Hide_Sub_Object(Object, 1, "Human_M_04")
			Hide_Sub_Object(Object, 1, "Human_M_05")
			Hide_Sub_Object(Object, 1, "Human_M_06")
		end

		local lightsaber_type = GameRandom.Free_Random(1, 6)
		if lightsaber_type == 1 then
			Hide_Sub_Object(Object, 0, "Blade_Front_Blue")

			Hide_Sub_Object(Object, 1, "Blade_Back_Blue")
			Hide_Sub_Object(Object, 1, "Blade_Front_Green")
			Hide_Sub_Object(Object, 1, "Blade_Back_Green")
			Hide_Sub_Object(Object, 1, "Blade_Front_Yellow")
			Hide_Sub_Object(Object, 1, "Blade_Back_Yellow")
		elseif lightsaber_type == 2 then
			Hide_Sub_Object(Object, 0, "Blade_Front_Blue")
			Hide_Sub_Object(Object, 0, "Blade_Back_Blue")

			Hide_Sub_Object(Object, 1, "Blade_Front_Green")
			Hide_Sub_Object(Object, 1, "Blade_Back_Green")
			Hide_Sub_Object(Object, 1, "Blade_Front_Yellow")
			Hide_Sub_Object(Object, 1, "Blade_Back_Yellow")
		elseif lightsaber_type == 3 then
			Hide_Sub_Object(Object, 0, "Blade_Front_Yellow")

			Hide_Sub_Object(Object, 1, "Blade_Back_Yellow")
			Hide_Sub_Object(Object, 1, "Blade_Front_Green")
			Hide_Sub_Object(Object, 1, "Blade_Back_Green")
			Hide_Sub_Object(Object, 1, "Blade_Front_Blue")
			Hide_Sub_Object(Object, 1, "Blade_Back_Blue")
		elseif lightsaber_type == 4 then
			Hide_Sub_Object(Object, 0, "Blade_Front_Yellow")
			Hide_Sub_Object(Object, 0, "Blade_Back_Yellow")

			Hide_Sub_Object(Object, 1, "Blade_Front_Green")
			Hide_Sub_Object(Object, 1, "Blade_Back_Green")
			Hide_Sub_Object(Object, 1, "Blade_Front_Blue")
			Hide_Sub_Object(Object, 1, "Blade_Back_Blue")
		elseif lightsaber_type == 5 then
			Hide_Sub_Object(Object, 0, "Blade_Front_Green")

			Hide_Sub_Object(Object, 1, "Blade_Back_Green")
			Hide_Sub_Object(Object, 1, "Blade_Front_Blue")
			Hide_Sub_Object(Object, 1, "Blade_Back_Blue")
			Hide_Sub_Object(Object, 1, "Blade_Front_Yellow")
			Hide_Sub_Object(Object, 1, "Blade_Back_Yellow")
		elseif lightsaber_type == 6 then
			Hide_Sub_Object(Object, 0, "Blade_Front_Green")
			Hide_Sub_Object(Object, 0, "Blade_Back_Green")

			Hide_Sub_Object(Object, 1, "Blade_Front_Blue")
			Hide_Sub_Object(Object, 1, "Blade_Back_Blue")
			Hide_Sub_Object(Object, 1, "Blade_Front_Yellow")
			Hide_Sub_Object(Object, 1, "Blade_Back_Yellow")
		end

		ScriptExit()
	end
end