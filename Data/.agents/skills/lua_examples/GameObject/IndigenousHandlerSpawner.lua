require("PGBase")
require("PGStateMachine")
require("PGStoryMode")
require("TRCommands")
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

	if message == OnEnter then
		if TestValid(Find_First_Object("SCRIPTED_BATTLE_MARKER")) then
			ScriptExit()
		end
		
		local p_attacker = MissionUtil.Find_Attacking_Player()
		local p_defender = MissionUtil.Find_Defending_Player()

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

			if p_attacker == owner then
				flippedroles = true
			end

			--delete any stations that do not belong to the owner
			local structures = Find_All_Objects_Of_Type(p_defender, "SpaceStructure")
        
			for i, station in pairs(structures) do
				station.Despawn()
			end

			structures = Find_All_Objects_Of_Type(p_defender, "Capital")
			
			for i, station in pairs(structures) do
				if station.Has_Property("IsStarbase") then
					station.Despawn()
				end
			end
		end

		local region = nil
		repeat    
		-- The AI may not yet be initialized
		Sleep(1)
		region = Evaluate_In_Galactic_Context("Regional_Fighter_Planets", p_defender)
		until (region ~= nil)
		
		local regionals = require("RegionalFighterBases")
		
		if regionals[region] then
			
			local influence = nil
			repeat
				-- The AI may not yet be initialized
				Sleep(1)
				influence = Evaluate_In_Galactic_Context("Planet_Influence_Value", p_defender)
			until (influence ~= nil)
			
			local entry_marker = nil

			local locals = nil
			if influence == 0 then --In the first week or other corner cases where no dummies are present, default to IF instead of attacker
				influence = 5
			end
			
			local defenderspawn = false
			local attackerspawn = false
			
			if influence >= 7 then
				if not mismatch then
					defenderspawn = true
				else
					if flippedroles then
						attackerspawn = true
					end
				end
			elseif influence <= 4 then
				if not mismatch then
					attackerspawn = true
				else
					if flippedroles then
						defenderspawn = true
					end
				end
			end
			
			if defenderspawn then
				locals = p_defender
				entry_marker = Find_First_Object("Defending Forces Position")
			elseif attackerspawn then
				locals = p_attacker
				entry_marker = Find_First_Object("Attacker Entry Position")
			else
				locals = Find_Player("Independent_Forces")
				locals.Enable_As_Actor()
				entry_marker = Find_First_Object("Map_Corner")
			end

			local stations = regionals[region]
			local index = GameRandom.Free_Random(1, table.getn(stations))
			SpawnList({stations[index]}, entry_marker.Get_Position(), locals, false, true)
		end
    end
end