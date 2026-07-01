require("PGStateMachine")
require("PGStoryMode")
require("TRCommands")

function Definitions()
	Define_State("State_Init", State_Init)
	skirmish_battle = false
end

function State_Init(message)
	if message == OnEnter then
		if Get_Game_Mode() ~= "Land" then
			ScriptExit()
		end	
		if EvaluatePerception("Is_Campaign") == 0 then
			skirmish_battle = true
		end

		Hide_Sub_Object(Object, 1, "Container_Ridges_Arakyd")
		Hide_Sub_Object(Object, 1, "Container_Ridges_Baktoid")
		Hide_Sub_Object(Object, 1, "Container_Ridges_Balmorran")
		Hide_Sub_Object(Object, 1, "Container_Ridges_Blasttech")
		Hide_Sub_Object(Object, 1, "Container_Ridges_CEC")
		Hide_Sub_Object(Object, 1, "Container_Ridges_CoreGalaxySystems")
		Hide_Sub_Object(Object, 1, "Container_Ridges_CryonCorp")
		Hide_Sub_Object(Object, 1, "Container_Ridges_Damorian")
		Hide_Sub_Object(Object, 1, "Container_Ridges_Gallofree")
		Hide_Sub_Object(Object, 1, "Container_Ridges_Golan")
		Hide_Sub_Object(Object, 1, "Container_Ridges_HK")
		Hide_Sub_Object(Object, 1, "Container_Ridges_IncomGCW")
		Hide_Sub_Object(Object, 1, "Container_Ridges_KDY")
		Hide_Sub_Object(Object, 1, "Container_Ridges_RSD")
		Hide_Sub_Object(Object, 1, "Container_Ridges_KSE")
		Hide_Sub_Object(Object, 1, "Container_Ridges_Loronar")
		Hide_Sub_Object(Object, 1, "Container_Ridges_Moncal")
		Hide_Sub_Object(Object, 1, "Container_Ridges_OlanjiCharubah")
		Hide_Sub_Object(Object, 1, "Container_Ridges_RSD")
		Hide_Sub_Object(Object, 1, "Container_Ridges_SFS")
		Hide_Sub_Object(Object, 1, "Container_Ridges_Slayn")
		Hide_Sub_Object(Object, 1, "Container_Ridges_Sorosuub")
		Hide_Sub_Object(Object, 1, "Container_Ridges_TaimAndBak")
		Hide_Sub_Object(Object, 1, "Container_Ridges_Ubrikkian")
		Hide_Sub_Object(Object, 1, "Container_Ridges_Xizor")

		if skirmish_battle then
			Hide_Sub_Object(Object, 0, "Container_Ridges_KDY")
			ScriptExit()
		end

		company_table = {
			"Arakyd",
			"Baktoid",
			"Balmorran",
			"Blasttech",
			"CEC",
			"CoreGalaxySystems",
			"CryonCorp",
			"Damorian",
			"Gallofree",
			"Golan",
			"HK",
			"IncomGCW",
			"KDY",
			"RSD",
			"KSE",
			"Loronar",
			"Moncal",
			"OlanjiCharubah",
			"RSD",
			"SFS",
			"Slayn",
			"Sorosuub",
			"TaimAndBak",
			"Ubrikkian",
			"Xizor",
		}

		local CompanyIndex = GameRandom.Free_Random(1, table.getn(company_table))
		local Company = company_table[CompanyIndex]

		Hide_Sub_Object(Object, 0, "Container_Ridges_"..Company.."")

	end
end
