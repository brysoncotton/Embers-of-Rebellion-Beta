require("PGStateMachine")

function Definitions()
    ServiceRate = 1
    Define_State("State_Init", State_Init)

    layer_manager = require("eaw-layerz/layermanager")
end

function State_Init(message)
    if message == OnEnter then
        if Get_Game_Mode() ~= "Space" then
            ScriptExit()
        end
        layer_manager:update_unit_layer(Object)
    end
end