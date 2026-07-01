require("PGBase")
require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("eawx-util/StoryUtil")

function Definitions()
	Define_State("State_Init", State_Init)
end

function State_Init(message)
	if message == OnEnter then
		if Get_Game_Mode() == "Galactic" then
			ScriptExit()
		end
		Sleep(3.0)
		Object.Change_Owner(Find_Player("Neutral"))
		ScriptExit()
	end
end
