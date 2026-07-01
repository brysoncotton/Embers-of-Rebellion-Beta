require("PGBase")
require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("eawx-util/MissionUtil")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))
    Define_State("State_Init", State_Init);
end

function State_Init(message)
    if Get_Game_Mode() ~= "Land" then
		ScriptExit()
	end

	Sleep(1.0)
	local p_attacker = MissionUtil.Find_Attacking_Player()
	local p_defender = MissionUtil.Find_Defending_Player()
	local p_hostile = Find_Player("Independent_Forces")

	local defender_object_list = Find_All_Objects_With_Hint("defender")
	for i,defender_object in pairs(defender_object_list) do
		if TestValid(defender_object) then
			defender_object.Change_Owner(p_defender)
			defender_object.Set_Garrison_Spawn(true)
		end	
	end

	local attacker_object_list = Find_All_Objects_With_Hint("attacker")
	for i,attacker_object in pairs(attacker_object_list) do
		if TestValid(attacker_object) then
			attacker_object.Change_Owner(p_attacker)
			attacker_object.Set_Garrison_Spawn(true)
		end	
	end

	local hostile_object_list = Find_All_Objects_With_Hint("Independent_Forces")
	for i,hostile_object in pairs(hostile_object_list) do
		if TestValid(hostile_object) then
			hostile_object.Change_Owner(p_hostile)
			hostile_object.Set_Garrison_Spawn(true)
		end	
	end
	ScriptExit()
end
