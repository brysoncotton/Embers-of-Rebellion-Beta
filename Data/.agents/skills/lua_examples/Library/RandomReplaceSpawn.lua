--******************************************************************************
--     _______ __
--    |_     _|  |--.----.---.-.--.--.--.-----.-----.
--      |   | |     |   _|  _  |  |  |  |     |__ --|
--      |___| |__|__|__| |___._|________|__|__|_____|
--     ______
--    |   __ \.-----.--.--.-----.-----.-----.-----.
--    |      <|  -__|  |  |  -__|     |  _  |  -__|
--    |___|__||_____|\___/|_____|__|__|___  |_____|
--                                    |_____|
--*   @Author:              [TR]Jorritkarwehr
--*   @Date:                2018-03-20T01:27:01+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            RandomReplaceSpawn.lua
--*   @Last modified by:    [TR]Jorritkarwehr
--*   @Last modified time:  2018-03-26T09:58:14+02:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************


require("PGStateMachine")
require("PGSpawnUnits")

--check_uniqueness ensures that an option will not be duplicated if it's already on the map, unless all options are present
--for this to work properly for squadrons, make a 2 element table entry of the squadron followed by a unit within it

function Random_Replacement(source_object, option_list, check_uniqueness)
	if Get_Game_Mode() ~= "Galactic" then
        ScriptExit()
    end
	
	local locale = source_object.Get_Planet_Location()
	
	local rando = 0
	
	for index=1,table.getn(option_list) do
		if table.getn(option_list[index]) > 1 then
			if type(option_list[index][2]) == "table" then
				for i,world in pairs(option_list[index][2]) do
					if FindPlanet(world) == locale then
						rando = index
						break
					end
				end
			else
				if FindPlanet(option_list[index][2]) == locale then
					rando = index
				end
			end
		end
		if rando > 0 then
			break
		end
	end
	
	if rando > 0 and check_uniqueness then
		if type(option_list[rando][1]) == "table" then
			checkObject = Find_First_Object(option_list[rando][1][2])
		else
			checkObject = Find_First_Object(option_list[rando][1])
		end
			
		if TestValid(checkObject) then
			rando = 0
		end
	end
			
	
	if rando == 0 then
		rando = GameRandom.Free_Random(1, table.getn(option_list))
		
		local iterations = 1
		
		while check_uniqueness do
			if type(option_list[rando][1]) == "table" then
				checkObject = Find_First_Object(option_list[rando][1][2])
			else
				checkObject = Find_First_Object(option_list[rando][1])
			end
			
			if TestValid(checkObject) then
				rando = rando+1
				if rando > table.getn(option_list) then
					rando = 1
				end
			else
				check_uniqueness = false
			end
			
			iterations = iterations+1
			if iterations > table.getn(option_list) then
				check_uniqueness = false
			end
		end
	end
	
	if type(option_list[rando][1]) == "table" then
		spawn_list_random = { option_list[rando][1][1] }
	else
		spawn_list_random = { option_list[rando][1] }
	end
	
	ReplaceSpawn = SpawnList(spawn_list_random, locale, source_object.Get_Owner(),true,false)

    source_object.Despawn()
    ScriptExit()
end