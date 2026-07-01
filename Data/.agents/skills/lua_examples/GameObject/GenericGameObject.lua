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
--*   @Date:                2017-12-14T10:54:01+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            GenericGameObject.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2018-03-24T02:18:16+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************

require("PGCommands")
require("PGStateMachine")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))
    ServiceRate = 1
    Define_State("State_Init", State_Init)
end

function State_Init(message)
    if message == OnEnter then
        if Get_Game_Mode() == "Galactic" then
            ScriptExit()
        end

        if not ModContentLoader then
            ModContentLoader = require("eawx-std/ModContentLoader")
        end
        
        GameObjectLibrary = ModContentLoader.get("GameObjectLibrary")
        
        -- local typeEntry = GameObjectLibrary.Units[Object.Get_Type().Get_Name()]
        local typeEntry = ModContentLoader.get_object_script(Object.Get_Type().Get_Name())

		if not typeEntry then
            ScriptExit()
        end
		
        if not typeEntry.Scripts then
            ScriptExit()
        end

        local deepcore = require("deepcore/std/deepcore")
        EawXObj = deepcore:game_object {
            context = {},
            plugins = typeEntry.Scripts,
            plugin_folder = "eawx-plugins-gameobject-space"
        }

        Sleep(5)
    elseif message == OnUpdate then
        EawXObj:update()
    end
end
