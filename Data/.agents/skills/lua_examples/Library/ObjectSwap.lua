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
--*   @Author:              Jorritkarwehr
--*   @Date:                2018-12-11T20:37:34+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            Class.lua
--*   @Last modified by:    Jorritkarwehr
--*   @Last modified time:  2018-12-11T20:38:04+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************

require("PGStoryMode")
require("PGSpawnUnits")

function Swap_Object(old_object, new_object)
    local oldlist = Find_All_Objects_Of_Type(old_object)
	for _, old in pairs(oldlist) do	
		local planet = old.Get_Planet_Location()			
			local owner = old.Get_Owner()
			old.Despawn()
							
			local spawn_list_new = { new_object }
			local dummies = SpawnList(spawn_list_new, planet, owner, false, false)			
	end
end
