require("eawx-util/StoryUtil")
require("eawx-util/PopulatePlanetUtilities")
require("UnitSpawnerTables")

function PopulateGalaxy(ssd_meme_table, start_planet)
	--Randomly spawn units at all planets owned by neutral or hostile
	--Probably want some screen text to tell the player the game is loading still
	local p_independent = Find_Player("Independent_Forces")
	local p_neutral = Find_Player("Neutral")
	local planet = nil
	local scaled_combat_power = 7500
	
	for _, planet in pairs(FindPlanet.Get_All_Planets()) do	
		if planet.Get_Owner() == (p_neutral or p_independent) then	
			scaled_combat_power = 7500 * EvaluatePerception("GenericPlanetValue", p_independent, planet) * (1.5 - EvaluatePerception("Is_Connected_To_Player", p_independent, planet))
			ChangePlanetOwnerAndPopulate(planet, p_independent, scaled_combat_power, "RANDOM", true)
		end
	end
	
	if ssd_meme_table ~= nil then
		local max_ssd = 4
		local spawned_ssd = 0
		if p_independent.Get_Difficulty() == "Easy" then
			max_ssd = 2
		elseif p_independent.Get_Difficulty() == "Hard" then
			max_ssd = 8
		end
		
		for _, pair in pairs(ssd_meme_table) do
			if GameRandom.Free_Random(1, pair[2]) == 1 then
				local ssd_planet = nil
				local iterations = 0
				while ssd_planet == nil do
					iterations = iterations + 1
					ssd_planet = StoryUtil.FindFriendlyPlanet(p_independent)
					if iterations > 50 then
						break
					end
					if start_planet then
						local path = Find_Path(p_independent, start_planet, ssd_planet)
						if table.getn(path) == 2 then
							ssd_planet = nil
						end
					else
						if EvaluatePerception("Is_Connected_To_Player", p_independent, ssd_planet) > 0 then
							ssd_planet = nil
						end
					end
				end
				if ssd_planet ~= nil then	
					SpawnList({pair[1]}, ssd_planet, p_independent,false,false)
					spawned_ssd = spawned_ssd + 1
					if spawned_ssd >= max_ssd then
						break
					end
				end
			end
		end
	end
end