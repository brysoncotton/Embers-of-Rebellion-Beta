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
--*   @Date:                2017-08-20T21:31:11+02:00
--*   @Project:             Imperial Civil War
--*   @Filename:            Despawn_Items.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2017-12-21T12:35:50+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************



require("PGBase")
require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")

function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))

	Define_State("State_Init", State_Init);
end



function State_Init(message)
	if message == OnEnter then

		if Object.Get_Type().Get_Name() == "ITEM_DUMMY" then
			Object.Highlight(true)
			Register_Timer(Despawn_Item, 100)
		else
			Register_Timer(Despawn_Item, 300)
		end
	end
end


function Despawn_Item()

	if Object.Get_Type().Get_Name() == "ITEM_DUMMY" then
		Object.Despawn()
	else
		Game_Message("TEXT_ATTACK_BONUS_GONE")
	end
	ScriptExit()

end
