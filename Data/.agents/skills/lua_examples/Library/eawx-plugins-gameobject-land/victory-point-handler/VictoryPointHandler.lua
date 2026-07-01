require("deepcore/std/class")
require("PGStateMachine")
require("PGSpawnUnits")
require("eawx-util/StoryUtil")
require("eawx-util/MissionUtil")

---@class VictoryPointHandler
VictoryPointHandler = class()

function VictoryPointHandler:new()
	if not ModContentLoader then
		ModContentLoader = require("eawx-std/ModContentLoader")
	end
	CONSTANTS = ModContentLoader.get("GameConstants")

	self.is_active = true
	self.attacker = MissionUtil.Find_Attacking_Player()

	Object.Highlight(true)
end

function VictoryPointHandler:update()
	if self.is_active == false then
		return
	end

	if (Object.Get_Owner() == self.attacker) and (EvaluatePerception("Disable_VictoryPoint", self.attacker) == 0) then
		self.is_active = false

		if self.attacker.Is_Human() then
			MissionUtil.SetObjectiveComplete("TEXT_TACTICAL_VICTORY_POINT_CAPTURE_DESCRIPTION")
		else
			MissionUtil.SetObjectiveFailed("TEXT_TACTICAL_VICTORY_POINT_DEFEND_DESCRIPTION")
		end
		StoryUtil.DeclareVictory(self.attacker, true)

		Point_Camera_At(Object)
		Create_Cinematic_Transport(CONSTANTS.TRANSPORTS[self.attacker.Get_Faction_Name()], self.attacker.Get_ID(), Object.Get_Position(), 0, 1, 0.25, 60, 1)
	end
end

return VictoryPointHandler
