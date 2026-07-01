require("PGStateMachine")
require("SetFighterResearch")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))

    Define_State("State_Init", State_Init);
end

function State_Init(message)
    if message == OnEnter then
        if Get_Game_Mode() ~= "Galactic" then
            ScriptExit()
        end

		Clear_Fighter_Research("RepublicWarpods")
		Set_Fighter_Hero("BROADSIDE_SHADOW_SQUADRON","YULAREN_RESOLUTE")
        Object.Despawn()
        ScriptExit()
    end
end
