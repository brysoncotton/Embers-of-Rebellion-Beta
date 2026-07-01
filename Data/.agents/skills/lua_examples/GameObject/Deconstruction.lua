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
--*   @Author:              [TR]Pox
--*   @Date:                2018-03-20T01:27:01+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            Deconstruction.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2018-03-26T09:58:14+02:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************


require("PGStateMachine")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))

    Define_State("State_Init", State_Init);
end


function State_Init(message)
    if message == OnEnter then
        if Get_Game_Mode() ~= "Galactic" then
            ScriptExit()
        end

        local planet = Object.Get_Planet_Location()
        local deconstructionTypeName = Object.Get_Type().Get_Name()
		local deconstructionSellValue = 0.0
        local structure_category = string.gsub(deconstructionTypeName, "DECONSTRUCT_", "")
		local Structure_Table = require("StructureCategoryLists")

		for _, objectTypeName in pairs(Structure_Table[structure_category]) do
			
			local allObjects = Find_All_Objects_Of_Type(objectTypeName)

			for _, structure in pairs(allObjects) do
				if structure.Get_Planet_Location() == planet then
					deconstructionSellValue = structure.Get_Game_Scoring_Type().Get_Build_Cost() / 2.0 + 1.0
					structure.Get_Owner().Give_Money(deconstructionSellValue)
					structure.Despawn()
					
					Object.Despawn()
					ScriptExit()
				end
			end
		end

        Object.Despawn()
        ScriptExit()
    end
end
