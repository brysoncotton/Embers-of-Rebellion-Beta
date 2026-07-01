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
--*   @Filename:            UnitSwitcher.lua
--*   @Last modified by:    Nojembre
--*   @Last modified time:  
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************


require("PGStateMachine")
require("PGSpawnUnits")
require("SetFighterResearch")

function replace_unit_on_planet(source_object, old_unit, new_unit)

	if Get_Game_Mode() ~= "Galactic" then
        ScriptExit()
    end
	
	local locale = source_object.Get_Planet_Location()

	checkArray = Find_All_Objects_Of_Type(old_unit)
	
        for _, checkObject in pairs(checkArray) do
            if checkObject.Get_Planet_Location() == locale then
                checkObject.Despawn()
				spawn_list_new = { new_unit }
				ReplaceSpawn = SpawnList(spawn_list_new, locale, source_object.Get_Owner(),true,false)
				Transfer_Fighter_Hero(old_unit, new_unit)
				source_object.Despawn()
                ScriptExit()
            end
        end
	
    ScriptExit()
end
