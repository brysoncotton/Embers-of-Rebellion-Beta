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
--*   @Date:                2025-02-18T01:27:01+01:00
--*   @Project:             Fall of the Republic
--*   @Filename:            GrievousReveal.lua
--*   @Last modified by:    [TR]Jorritkarwehr
--*   @Last modified time:  2018-03-26T09:58:14+02:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************

require("PGStateMachine")
require("PGSpawnUnits")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))

    Define_State("State_Init", State_Init);
end


function State_Init(message)
    if message == OnEnter then
        if Get_Game_Mode() ~= "Galactic" then
            ScriptExit()
        end

		local player = Object.Get_Owner()
		local Grievous_Table = {"GRIEVOUS_MUNIFICENT","GRIEVOUS_INVISIBLE_HAND","GRIEVOUS_RECUSANT","GRIEVOUS_MALEVOLENCE","GRIEVOUS_MALEVOLENCE_2"}

		for _, objectTypeName in pairs(Grievous_Table) do
			
			local griev = Find_First_Object(objectTypeName)

			if griev ~= nil then
				--Move decoy to Grievous's location
				local old = griev.Get_Planet_Location()
				if old then
					local decoy_name = string.gsub(Object.Get_Type().Get_Name(), "GRIEVOUS_REVEAL_", "")
					Find_First_Object(decoy_name).Despawn()
					SpawnList({decoy_name}, old, player,true,false)
				end
				
				--Move Grievous to decoy's location
				griev.Despawn()
				SpawnList({objectTypeName}, Object.Get_Planet_Location(), player,true,false)
				break
			end
		end

        Object.Despawn()
        ScriptExit()
    end
end
