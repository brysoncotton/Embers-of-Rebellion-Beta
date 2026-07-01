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

function IA_Spawn(object_name, marker, default_faction, unit_table)
	if Get_Game_Mode() ~= "Space" then
        ScriptExit()
    end
	
	spawn_faction = GlobalValue.Get("IA_FACTION")
	if spawn_faction == nil then
		spawn_faction = default_faction
	end

	spawn_marker = Find_First_Object(marker)
	
	for i, obj in pairs(unit_table) do
			contain_check = string.find(object_name, obj)			
	 			if contain_check ~= nil then
					unit = Find_Object_Type(obj)
					Spawn_Unit(unit, spawn_marker, Find_Player(spawn_faction), true, false)
					ScriptExit()
				end
			
		end
    ScriptExit()
end