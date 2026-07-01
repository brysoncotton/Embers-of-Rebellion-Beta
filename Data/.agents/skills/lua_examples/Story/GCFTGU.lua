require("PGStoryMode")
require("deepcore/crossplot/crossplot")
require("deepcore/std/class")
require("FTGULibrary")
require("eawx-util/FTGUPopulate")

function Definitions()

    DebugMessage("%s -- In Definitions", tostring(Script))
    StoryModeEvents = {
		Universal_Story_Start = Spawn_Starting_Forces
	}
	
end		

function Spawn_Starting_Forces(message)
    if message == OnEnter then	
		Set_Tech()

		PopulateGalaxy(Get_SSDS())
	end
end
