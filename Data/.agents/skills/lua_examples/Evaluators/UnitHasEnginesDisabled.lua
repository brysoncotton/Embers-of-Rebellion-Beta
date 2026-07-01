require("PGBaseDefinitions")

function Clean_Up()
	-- any temporary object pointers need to be set to nil in this function.
	-- ie: Target = nil
	supercapitals = nil
	supercapital = nil
	heroes = nil
	hero = nil
end

function Evaluate()

	supercapitals = Find_All_Objects_Of_Type("SuperCapital", PlayerObject)
	
	for _, supercapital in pairs(supercapitals) do
		if TestValid(supercapital) then
			if not supercapital.Are_Engines_Online() then 
				return 1.0
			end
		end
	end

	heroes = Find_All_Objects_Of_Type("SpaceHero", PlayerObject)
	
	for _, hero in pairs(heroes) do
		if TestValid(hero) then
			if not hero.Are_Engines_Online() then 
				return 1.0
			end
		end
	end
	
	return 0.0
end






