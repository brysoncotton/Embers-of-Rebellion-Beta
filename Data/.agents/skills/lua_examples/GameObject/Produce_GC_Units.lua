--//////////////////////////////////////////////////////////////////////////////////////
-- Spawns units for pirate faction in GC mode
-- © SmallPox
--//////////////////////////////////////////////////////////////////////////////////////

require("PGStateMachine")
require("PGSpawnUnits")



function Definitions()
	
	DebugMessage("%s -- In Definitions", tostring(Script))

	-- possible units to spawn
	unit_table = {"MC80_Liberty", "Nebulon_B_Frigate" }


	Define_State("State_Init", State_Init);


end


function State_Init(message)
	if message == OnUpdate then
		if Get_Game_Mode() == "Land" or Get_Game_Mode() == "Space" then
			ScriptExit()
		end
		rebel = Find_Player("Rebel")
		planet = Object.Get_Planet_Location()


		spawned_something = false		
		randunit = GameRandom(1, table.getn(unit_table))
		spawn_list = {}
		--chosen_unit = Find_Object_Type(unit_table[randunit])
		chosen_unit = unit_table[randunit]
		chosen_unit_list = Find_All_Objects_Of_Type(chosen_unit)
		chosen_units_on_planet = 0
		table.insert(spawn_list, chosen_unit)

		for i, unit in pairs(chosen_unit_list) do
			if unit.Get_Planet_Location() == planet then
				
				chosen_units_on_planet = chosen_units_on_planet + 1
			end
		end


		if table.getn(chosen_unit_list) < 100 then
			if chosen_units_on_planet < 10 then
				--Spawn_Unit(chosen_unit, planet, rebel)
				SpawnList(spawn_list, planet, rebel,false,false)
				spawned_something = true
			end
		end

		-- wait if something was spawned on the map
		if spawned_something then
			Sleep(5)
		end

	end
end