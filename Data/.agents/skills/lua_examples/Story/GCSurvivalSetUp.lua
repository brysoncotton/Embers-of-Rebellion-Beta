
require("PGStateMachine")
require("PGStoryMode")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	StoryModeEvents = {
		Universal_Story_Start = Begin_GC
	}
end

function Begin_GC(message)
	if message == OnEnter then
		GlobalValue.Set("CURRENT_ERA", 4)

		Story_Event("START_SURVIVAL")
	elseif message == OnUpdate then
		Story_Event("MODE_END")
	end
end
