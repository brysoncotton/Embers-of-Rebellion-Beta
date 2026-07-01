require("PGBase")
require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("eawx-util/StoryUtil")
require("eawx-util/MissionUtil")
CONSTANTS = ModContentLoader.get("GameConstants")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))
    Define_State("State_Init", State_Init);
end

function State_Init(message)
    if Get_Game_Mode() ~= "Space" then
		ScriptExit()
	end

	Object.Set_Garrison_Spawn(false)

	local p_attacker = MissionUtil.Find_Attacking_Player()
	local p_defender = MissionUtil.Find_Defending_Player()
	local influence = nil
	
	local ownerid = nil
	local mismatch = false
	local flippedroles = false
	repeat    
	-- The AI may not yet be initialized
	Sleep(1)
	ownerid = Evaluate_In_Galactic_Context("Get_Faction_Index", p_defender)
	until (ownerid ~= nil)
	
	owner = Find_Player(CONSTANTS.ALL_FACTIONS[ownerid])
	
	if p_defender ~= owner then
		mismatch = true
		--todo delete any stations that do not belong to the owenr
		if p_attacker == owner then
			flippedroles = true
		end
	end

	repeat
		-- The AI may not yet be initialized
		Sleep(1)
		influence = Evaluate_In_Galactic_Context("Planet_Influence_Value", p_defender)
	until (influence ~= nil)

	local locals = Find_Player("Independent_Forces")
	if influence == 5 then --In the first week or other corner cases where no dummies are present, default to IF instead of attacker
		influence = 5
	end
	
	if influence >= 7 then
		if not mismatch then
			locals = p_defender
		else
			if flippedroles then
				locals = p_attacker
			end
		end
	elseif influence <= 4 then
		if not mismatch then
			locals = p_attacker
		else
			if flippedroles then
				locals = p_defender
			end
		end
	end

	Object.Change_Owner(locals)
	Object.Set_Garrison_Spawn(true)
	ScriptExit()
end
