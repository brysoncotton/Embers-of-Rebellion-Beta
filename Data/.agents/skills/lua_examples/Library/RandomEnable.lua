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
--*   @Last modified time:  2024-03-04T09:58:14+02:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************


require("PGStateMachine")
require("PGSpawnUnits")
require("eawx-util/StoryUtil")

--check_uniqueness ensures that an option will not be duplicated if it's already on the map, unless all options are present
--for this to work properly for squadrons, make a 2 element table entry of the squadron followed by a unit within it

function Random_Enable(source_object, option_list, Global)
	--local test = SpawnList({ "Commander_Venator_Star_Destroyer_V" }, FindPlanet("Desevro"), Find_Player("Zsinj_Empire"),true,false)
	if Get_Game_Mode() ~= "Galactic" then
        ScriptExit()
    end
	
	local listinuse = GlobalValue.Get(Global)
	local owner = source_object.Get_Owner()
	
	if listinuse == nil then
		listinuse = option_list
	end
	
	if table.getn(listinuse) == 0 then
		StoryUtil.ShowScreenText("No options avaliable", 5)
		owner.Lock_Tech(Find_Object_Type(source_object.Get_Type().Get_Name())) --You'd think you wouldn't need to get the type from the name from the type, but I'm not questioning it
	else
		local rando = GameRandom.Free_Random(1, table.getn(listinuse))
		--local test = SpawnList({listinuse[rando]}, FindPlanet("Desevro"), Find_Player("Zsinj_Empire"),true,false)
		owner.Unlock_Tech(Find_Object_Type(listinuse[rando]))
		table.remove(listinuse,rando)

		GlobalValue.Set(Global, listinuse)
		
		if table.getn(listinuse) == 0 then
			owner.Lock_Tech(Find_Object_Type(source_object.Get_Type().Get_Name()))
		end
	end
	
    source_object.Despawn()
    ScriptExit()
end