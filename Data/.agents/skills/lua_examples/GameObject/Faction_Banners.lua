require("PGStateMachine")
require("PGStoryMode")
require("eawx-util/MissionUtil")

function Definitions()
	Define_State("State_Init", State_Init)
end

function State_Init(message)
	if Get_Game_Mode() ~= "Land" then
		ScriptExit()
	end	

	local p_defender = MissionUtil.Find_Defending_Player()
	if not TestValid(p_defender) then
		ScriptExit()
	end

	if p_defender == Find_Player("Rebel") then
		Hide_Sub_Object(Object, 1, "banners")	 --Nothing
		Hide_Sub_Object(Object, 0, "banners_01") --CIS
	end
	if p_defender == Find_Player("Empire") or p_defender == Find_Player("Sector_Forces") then
		Hide_Sub_Object(Object, 1, "banners")	 --Nothing
		Hide_Sub_Object(Object, 0, "banners_02") --Republic
	end
	if p_defender == Find_Player("Hutt_Cartels") then
		Hide_Sub_Object(Object, 1, "banners")	 --Nothing
		Hide_Sub_Object(Object, 0, "banners_03") --Hutts
	end
	if p_defender == Find_Player("Trade_Federation") then
		Hide_Sub_Object(Object, 1, "banners")	 --Nothing
		Hide_Sub_Object(Object, 0, "banners_04") --Trade Federation
	end
	if p_defender == Find_Player("Techno_Union") then
		Hide_Sub_Object(Object, 1, "banners")	 --Nothing
		Hide_Sub_Object(Object, 0, "banners_05") --Techno Union
	end
	if p_defender == Find_Player("Commerce_Guild") then
		Hide_Sub_Object(Object, 1, "banners")	 --Nothing
		Hide_Sub_Object(Object, 0, "banners_06") --Commerce Guild
	end
	ScriptExit()
end
