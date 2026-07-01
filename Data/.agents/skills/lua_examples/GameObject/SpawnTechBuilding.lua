--/////////////////////////////////////////////////////////////////////////////////////////////////////
--Spawn Tech Buildings for fourth faction
--/////////////////////////////////////////////////////////////////////////////////////////////////////

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")




function Definitions()

	StoryModeEvents = {
				Universal_Story_Start = Begin_GC
				}



	planet_list = {"Coruscant", "Byss", "Abregado_Rae", "Anaxes", "Corulag", "Fresia", "Bothawui", "Corellia", "Kashyyyk", "Kessel", "Kuat", "Hypori", "Mandalore", "Nal_Hutta", "Ryloth", "Shola", "Dagobah", "Geonosis", "Mustafar", "Naboo", "Tatooine", "Utapau", "Atzerri", "Bespin", "Bestine", "Eriadu", "Hoth", "Sullust", "Endor", "Fondor", "Polus", "Taris", "Thyferra", "AlzocIII", "Carida", "Ilum", "Jabiim", "Manaan", "AetenII", "Bonadan", "Dantooine", "Dathomir", "Muunilinst", "Myrkr", "Felucia", "Korriban", "Wayland", "Yavin", "Honoghr", "Kamino", "Mon_Calamari", "Saleucami"}
	
	faction_four = Find_Player("Empire")



	-- the tech buildings shouldn't be buildable!
	tech_buildings = {
				"E_Ground_Barracks", -- Tech 1
				"E_Ground_Light_Vehicle_Factory" -- Tech 2


			

			}


end



function Begin_GC(message)
	if message == OnEnter then


		last_tech_level = faction_four.Get_Tech_Level()
		for i, planetstring in pairs(planet_list) do
			if FindPlanet(planetstring).Get_Owner() == faction_four then
				Spawn_Unit(Find_Object_Type(tech_buildings[last_tech_level]), FindPlanet(planetstring), faction_four)
			end
		end



	elseif message == OnUpdate then


		tech_level = faction_four.Get_Tech_Level()
		if tech_level ~= last_tech_level then
			for i, planetstring in pairs(planet_list) do
				if FindPlanet(planetstring).Get_Owner() == faction_four then
					planet = FindPlanet(planetstring)
					tech_list = Find_All_Objects_Of_Type(tech_buildings[last_tech_level])
					for j, tech in pairs(tech_list) do
						if tech.Get_Planet_Location() == planet then
							tech.Despawn()
							Spawn_Unit(Find_Object_Type(tech_buildings[tech_level]), planet, faction_four)
						end

					end
				end			

			end			


			last_tech_level = tech_level
			
		

		end


		for i, planetstring in pairs(planet_list) do
			if FindPlanet(planetstring).Get_Owner() == faction_four then
				planet = FindPlanet(planetstring)
				Game_Message("TEXT_UNIT_VENGEANCE_FRIGATE")
				rax_list = Find_All_Objects_Of_Type(tech_buildings[tech_level])
				


				for k, rax in pairs(rax_list) do
					if rax.Get_Planet_Location() == planet then
						
						break
 
					elseif k == table.getn(rax_list) and rax.Get_Planet_Location() ~= planet then
						
						Spawn_Unit(Find_Object_Type(tech_buildings[tech_level]), planet, faction_four)

					end
														
	
				
	
				

				end

			end
		end

	end
end