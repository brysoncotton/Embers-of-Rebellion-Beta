require("PGStateMachine")
require("PGStoryMode")
require("TRCommands")

function Definitions()
	Define_State("State_Init", State_Init)
end

function State_Init(message)
	if message == OnEnter then
		if Get_Game_Mode() ~= "Land" then
			ScriptExit()
		end	

		p_republic = Find_Player("Empire")
		p_pdf = Find_Player("Sector_Forces")
		p_cis = Find_Player("Rebel")
		p_tradefed = Find_Player("Trade_Federation")
		p_techno = Find_Player("Techno_Union")
		p_commerce = Find_Player("Commerce_Guild")

		if EvaluatePerception("Is_Defender", p_republic) == 1 then
			Hide_Sub_Object(Object, 1, "Container_Ridges_Generic")	 --Nothing
			Hide_Sub_Object(Object, 1, "Container_Ridges_CIS") --CIS
			Hide_Sub_Object(Object, 0, "Container_Ridges_Republic") --Republic
			Hide_Sub_Object(Object, 1, "Container_Ridges_RepublicSectorForces") --Sector Forces
			Hide_Sub_Object(Object, 1, "Container_Ridges_TradeFederation") --Trade Federation
			Hide_Sub_Object(Object, 1, "Container_Ridges_TechnoUnion") --Techno Union
			Hide_Sub_Object(Object, 1, "Container_Ridges_CommerceGuild") --Commerce Guild
		elseif EvaluatePerception("Is_Defender", p_pdf) == 1 then
			Hide_Sub_Object(Object, 1, "Container_Ridges_Generic")	 --Nothing
			Hide_Sub_Object(Object, 1, "Container_Ridges_CIS") --CIS
			Hide_Sub_Object(Object, 1, "Container_Ridges_Republic") --Republic
			Hide_Sub_Object(Object, 0, "Container_Ridges_RepublicSectorForces") --Sector Forces
			Hide_Sub_Object(Object, 1, "Container_Ridges_TradeFederation") --Trade Federation
			Hide_Sub_Object(Object, 1, "Container_Ridges_TechnoUnion") --Techno Union
			Hide_Sub_Object(Object, 1, "Container_Ridges_CommerceGuild") --Commerce Guild
		elseif EvaluatePerception("Is_Defender", p_cis) == 1 then
			Hide_Sub_Object(Object, 1, "Container_Ridges_Generic")	 --Nothing
			Hide_Sub_Object(Object, 0, "Container_Ridges_CIS") --CIS
			Hide_Sub_Object(Object, 1, "Container_Ridges_Republic") --Republic
			Hide_Sub_Object(Object, 1, "Container_Ridges_RepublicSectorForces") --Sector Forces
			Hide_Sub_Object(Object, 1, "Container_Ridges_TradeFederation") --Trade Federation
			Hide_Sub_Object(Object, 1, "Container_Ridges_TechnoUnion") --Techno Union
			Hide_Sub_Object(Object, 1, "Container_Ridges_CommerceGuild") --Commerce Guild
		elseif EvaluatePerception("Is_Defender", p_tradefed) == 1 then
			Hide_Sub_Object(Object, 1, "Container_Ridges_Generic")	 --Nothing
			Hide_Sub_Object(Object, 1, "Container_Ridges_CIS") --CIS
			Hide_Sub_Object(Object, 1, "Container_Ridges_Republic") --Republic
			Hide_Sub_Object(Object, 1, "Container_Ridges_RepublicSectorForces") --Hutts
			Hide_Sub_Object(Object, 0, "Container_Ridges_TradeFederation") --Trade Federation
			Hide_Sub_Object(Object, 1, "Container_Ridges_TechnoUnion") --Techno Union
			Hide_Sub_Object(Object, 1, "Container_Ridges_CommerceGuild") --Commerce Guild
		elseif EvaluatePerception("Is_Defender", p_techno) == 1 then
			Hide_Sub_Object(Object, 1, "Container_Ridges_Generic")	 --Nothing
			Hide_Sub_Object(Object, 1, "Container_Ridges_CIS") --CIS
			Hide_Sub_Object(Object, 1, "Container_Ridges_Republic") --Republic
			Hide_Sub_Object(Object, 1, "Container_Ridges_RepublicSectorForces") --Sector Forces
			Hide_Sub_Object(Object, 1, "Container_Ridges_TradeFederation") --Trade Federation
			Hide_Sub_Object(Object, 0, "Container_Ridges_TechnoUnion") --Techno Union
			Hide_Sub_Object(Object, 1, "Container_Ridges_CommerceGuild") --Commerce Guild
		elseif EvaluatePerception("Is_Defender", p_commerce) == 1 then
			Hide_Sub_Object(Object, 1, "Container_Ridges_Generic")	 --Nothing
			Hide_Sub_Object(Object, 1, "Container_Ridges_CIS") --CIS
			Hide_Sub_Object(Object, 1, "Container_Ridges_Republic") --Republic
			Hide_Sub_Object(Object, 1, "Container_Ridges_RepublicSectorForces") --Sector Forces
			Hide_Sub_Object(Object, 1, "Container_Ridges_TradeFederation") --Trade Federation
			Hide_Sub_Object(Object, 1, "Container_Ridges_TechnoUnion") --Techno Union
			Hide_Sub_Object(Object, 0, "Container_Ridges_CommerceGuild") --Commerce Guild
		else
			Hide_Sub_Object(Object, 0, "Container_Ridges_Generic")	 --Nothing
			Hide_Sub_Object(Object, 1, "Container_Ridges_CIS") --CIS
			Hide_Sub_Object(Object, 1, "Container_Ridges_Republic") --Republic
			Hide_Sub_Object(Object, 1, "Container_Ridges_RepublicSectorForces") --Sector Forces
			Hide_Sub_Object(Object, 1, "Container_Ridges_TradeFederation") --Trade Federation
			Hide_Sub_Object(Object, 1, "Container_Ridges_TechnoUnion") --Techno Union
			Hide_Sub_Object(Object, 1, "Container_Ridges_CommerceGuild") --Commerce Guild
		end
		ScriptExit()
	end
end
