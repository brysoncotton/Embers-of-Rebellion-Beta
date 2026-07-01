require("deepcore/std/class")
require("deepcore/std/Observable")
require("eawx-util/StoryUtil")
CONSTANTS = ModContentLoader.get("GameConstants")

---@class FactionSwitching
FactionSwitching = class()

---@param galactic_conquest GalacticConquest
function FactionSwitching:new(galactic_conquest)
	self.galactic_conquest = galactic_conquest
end

function FactionSwitching:update()
    DebugMessage("FactionSwitching::update -- update started")
	StoryUtil.ShowScreenText("it worked?", 20)
end
