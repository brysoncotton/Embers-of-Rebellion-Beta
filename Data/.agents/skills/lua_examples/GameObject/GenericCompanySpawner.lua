
require("PGCommands")
require("PGStateMachine")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))
    ServiceRate = 1
    Define_State("State_Init", State_Init)
end

function State_Init(message)
    if message == OnEnter then
        if Get_Game_Mode() == "Galactic" or Get_Game_Mode() == "Space" then
            ScriptExit()
        end


        if not ModContentLoader then
            ModContentLoader = require("eawx-std/ModContentLoader")
        end
        
        GameObjectLibraryGround = ModContentLoader.get("GameObjectLibrary")
        
        -- local typeEntry = GameObjectLibrary.Units[Object.Get_Type().Get_Name()]
        local typeEntry = ModContentLoader.get_ground_object_script(Object.Get_Type().Get_Name())
		
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
            plugin_folder = "eawx-plugins-gameobject-land"
        }

        Sleep(5)
    elseif message == OnUpdate then
        EawXObj:update()
    end
end
