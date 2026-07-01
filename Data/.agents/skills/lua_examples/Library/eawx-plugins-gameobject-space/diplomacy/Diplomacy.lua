require("PGBase")
require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
CONSTANTS = ModContentLoader.get("GameConstants")
require("deepcore/std/class")

---@class Diplomacy
Diplomacy = class()

function Diplomacy:new()
    self.isActive = true
	
end

function Diplomacy:update()
	
	-- if Object.Is_Ability_Ready("HARMONIC_BOMB") then
	if Object.Is_Ability_Ready("WEAKEN_ENEMY") then
        self.onCooldown = false
		
    end

    if not self.onCooldown then
	
		-- if not Object.Is_Ability_Ready("HARMONIC_BOMB") then
		if not Object.Is_Ability_Ready("WEAKEN_ENEMY") then
		
			for _, faction in pairs(CONSTANTS.ALL_FACTIONS_NOT_NEUTRAL) do
				local faction_object = Find_Player(faction)
				for _, second_faction in pairs(CONSTANTS.ALL_FACTIONS_NOT_NEUTRAL) do
					if faction ~= second_faction then
						local second_faction_object = Find_Player(second_faction)
						faction_object.Make_Ally(second_faction_object)
					end
				end
			end
			
			-- local object_owner = Object.GetOwner()			
			Story_Event("NO_RETREAT")
			
			Sleep(15)
			
			for _, faction in pairs(CONSTANTS.ALL_FACTIONS_NOT_NEUTRAL) do
				local faction_object = Find_Player(faction)
				for _, second_faction in pairs(CONSTANTS.ALL_FACTIONS_NOT_NEUTRAL) do
					if faction ~= second_faction then
						local second_faction_object = Find_Player(second_faction)
						faction_object.Make_Enemy(second_faction_object)
					end
				end
			end
			
			Story_Event("YES_RETREAT")
			
			Sleep(15)
			
			-- object_owner.Retreat(true)
			
			self.onCooldown = true
			
			-- local i = 2
			-- local j = 1
			
			-- local rebels = Find_Player("Rebel")
			-- local empire = Find_Player("Empire")
			-- local hutt_cartels = Find_Player("Hutt_Cartels")
			-- local eoth = Find_Player("EmpireoftheHand")
			-- local underworld = Find_Player("Underworld")
			-- local pirates = Find_Player("Pirates")
			-- local hutts = Find_Player("Hutts")
			-- local chiss = Find_Player("Chiss")
			-- local corellia = Find_Player("Corellia")
			-- local ssiruuvi = Find_Player("SsiRuuvi_Imperium")
			-- local hapes = Find_Player("Hapes_Consortium")
			-- local csa = Find_Player("Corporate_Sector")
			-- local pentastar = Find_Player("Pentastar")
			-- local teradoc = Find_Player("Teradoc")
			-- local warlords = Find_Player("Warlords")
			
			-- factions = {rebels, empire, hutt_cartels, eoth, underworld, pirates, hutts, chiss, corellia, ssiruuvi, hapes, csa, pentastar, teradoc, warlords}
			-- factions_size = tablelength(factions)
			-- factions_size = 10
			
			-- for i=1,factions_size,1 do
			
				-- for j=i+1,factions_size,1 do
				
					-- factions[i].Make_Ally(factions[j])	
				
				-- end
				
			-- end
			
			-- object_owner.Retreat() = false
			-- Sleep(30)
				
			-- for i=1,factions_size,1 do
			
				-- for j=i+1,factions_size,1 do
				
					-- factions[i].Make_Enemy(factions[j])	
				
				-- end
				
			-- end
			
			-- object_owner.Retreat() = true
			
		end
		
    end
	
end

-- function tablelength(x)

	-- local size = 0
	-- for _ in pairs(x) do
	
		-- size = size + 1
		
	-- end
	-- return size
	
-- end

return Diplomacy
