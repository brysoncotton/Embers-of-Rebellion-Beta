require("PGBase")
require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))

    Define_State("State_Init", State_Init);
end

function State_Init(message)
    if Get_Game_Mode() ~= "Space" then
		ScriptExit()
	end

	local ship_list = {
			"PDF_DHC",
			"CEC_Light_Cruiser",
			"Starbolt",
			"Carrack_Cruiser_Lasers",
			"Marauder_Cruiser",
			"CR90",
			"DP20",
			"Consular_Refit",
			"Gozanti_Cruiser_Raider_Group",
			"Gozanti_Cruiser_Group",
			"Citadel_Cruiser_Group",
			"Cloakshape_Stock_Squadron",
			"Cloakshape_Squadron",
			"T19_Squadron",
			"PDF_Z95_Headhunter_Squadron",
			"N1_Squadron",
			"Early_Skipray_Squadron",
			"Firespray_Squadron", --placeholder for S40k
			}

	local hero_list = {
			"Zozridor_Slayke_Carrack",
			"Zozridor_Slayke_CR90",
			}

	for i, hero in pairs(hero_list) do
		local active_hero = Find_First_Object(hero)
		if active_hero then
			local squad_count = GameRandom(3, 6)
			for spawn = 1, squad_count do
				local ShipIndex = GameRandom.Free_Random(1, table.getn(ship_list))
				local ShipGamble = ship_list[ShipIndex]
				Reinforce_Unit(Find_Object_Type(ShipGamble), false, active_hero.Get_Owner())
			end
		end
	end
	
	Object.Despawn()
	ScriptExit()
end