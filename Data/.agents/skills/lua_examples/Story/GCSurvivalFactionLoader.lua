require("PGStoryMode")
require("PGBase")
require("PGSpawnUnits")
require("eawx-util/ChangeOwnerUtilities")
require("eawx-util/StoryUtil")
require("deepcore/crossplot/crossplot")
require("deepcore/std/class")
require("deepcore/std/Observable")
require("eawx-util/GalacticUtil")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	StoryModeEvents = {
		Universal_Story_Start = Begin_GC
	}
end

function Begin_GC(message)
	if message == OnEnter then
		--UnitUtil.SetLockList("REBEL", {"Tallon_Battalion_Upgrade", "Neutron_Star"}, false) -- put in here every generic stuff you don't want in the GC
		--UnitUtil.SetLockList("REBEL", {"Faction_Dummy_CIS", "Faction_Dummy_Republic", "Faction_Dummy_Hutts"}) -- put in here every faction dummy you need
	end
end
