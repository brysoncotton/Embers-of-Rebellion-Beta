
--*****************************************************--
--**** Operation Durge's Lance: Killing Kaikielius ****--
--*****************************************************--

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")
require("eawx-util/StoryUtil")
require("eawx-util/MissionUtil")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	StoryModeEvents =
	{
		Battle_Start = Begin_Battle,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")

	camera_offset = 125
	mission_started = false

end

function Begin_Battle(message)
	if message == OnEnter then
		MissionUtil.AddToReinforcementPool("GRIEVOUS_TEAM", p_cis, 1)
		MissionUtil.AIActivation()
	end
end
