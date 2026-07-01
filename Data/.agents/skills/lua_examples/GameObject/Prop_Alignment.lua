require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")
require("eawx-util/MissionUtil")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	Define_State("State_Init", State_Init)
end

function State_Init(message)
	if message == OnEnter then
		if Get_Game_Mode() ~= "Land" then
			return
		end
		local p_defender = MissionUtil.Find_Defending_Player()
		if p_defender == Find_Player("Empire") then
			local cis_object_list = Find_All_Objects_With_Hint("1")
			for i,cis_object in pairs(cis_object_list) do
				if TestValid(cis_object) then
					cis_object.Despawn()
				end	
			end
			local rep_object_list = Find_All_Objects_With_Hint("2")
			for i,rep_object in pairs(rep_object_list) do
				if TestValid(rep_object) then
					rep_object.Change_Owner(Find_Player("Neutral"))
				end	
			end
			local neutral_object_list = Find_All_Objects_With_Hint("3")
			for i,neutral_object in pairs(neutral_object_list) do
				if TestValid(neutral_object) then
					neutral_object.Despawn()
				end	
			end
			ScriptExit()
		end
		if p_defender == Find_Player("Rebel")
		or p_defender == Find_Player("Trade_Federation")
		or p_defender == Find_Player("Techno_Union")
		or p_defender == Find_Player("Banking_Clan")
		or p_defender == Find_Player("Commerce_Guild") then
			local cis_object_list = Find_All_Objects_With_Hint("1")
			for i,cis_object in pairs(cis_object_list) do
				if TestValid(cis_object) then
					cis_object.Change_Owner(Find_Player("Neutral"))
				end	
			end
			local rep_object_list = Find_All_Objects_With_Hint("2")
			for i,rep_object in pairs(rep_object_list) do
				if TestValid(rep_object) then
					rep_object.Despawn()
				end	
			end
			local neutral_object_list = Find_All_Objects_With_Hint("3")
			for i,neutral_object in pairs(neutral_object_list) do
				if TestValid(neutral_object) then
					neutral_object.Despawn()
				end	
			end
			ScriptExit()
		end
		if p_defender ~= Find_Player("Rebel")
		or p_defender ~= Find_Player("Trade_Federation")
		or p_defender ~= Find_Player("Techno_Union")
		or p_defender ~= Find_Player("Banking_Clan")
		or p_defender ~= Find_Player("Commerce_Guild")
		or p_defender ~= Find_Player("Empire") then
			local cis_object_list = Find_All_Objects_With_Hint("1")
			for i,cis_object in pairs(cis_object_list) do
				if TestValid(cis_object) then
					cis_object.Despawn()
				end	
			end
			local rep_object_list = Find_All_Objects_With_Hint("2")
			for i,rep_object in pairs(rep_object_list) do
				if TestValid(rep_object) then
					rep_object.Despawn()
				end	
			end
			local neutral_object_list = Find_All_Objects_With_Hint("3")
			for i,neutral_object in pairs(neutral_object_list) do
				if TestValid(neutral_object) then
					neutral_object.Change_Owner(Find_Player("Neutral"))
				end	
			end
			ScriptExit()
		end
	end
end
