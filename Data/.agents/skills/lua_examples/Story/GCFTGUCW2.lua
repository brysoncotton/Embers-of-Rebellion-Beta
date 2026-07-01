require("PGStoryMode")
require("deepcore/crossplot/crossplot")

function Definitions()

    DebugMessage("%s -- In Definitions", tostring(Script))
    StoryModeEvents = {
		Delayed_Initialize = Initialize
	}
	
end		

function Initialize(message)
    if message == OnEnter then
		crossplot:galactic()
		p_Republic = Find_Player("Empire")
		if p_Republic.Is_Human() then
			crossplot:publish("TIMING_ISSUE", 2, 1)
			crossplot:publish("TIMING_ISSUE2", 2, 1)
			crossplot:publish("TIMING_ISSUE3", 2, 1)
			crossplot:publish("COMMAND_STAFF_DECREMENT", {1,1,1,1,1,1}, 0, false, true)
			crossplot:publish("COMMAND_STAFF_DECREMENT", {1,1,1,1,1,1}, 0, true)
			crossplot:publish("COMMAND_STAFF_EXIT", {"Grumby"}, 1)
			crossplot:publish("COMMAND_STAFF_EXIT", {"Seerdon"}, 2)
		end
		
		if GlobalValue.Get("CURRENT_ERA") > 1 then
			crossplot:publish("VENATOR_HEROES", "empty")
		end
		if GlobalValue.Get("CURRENT_ERA") > 2 then
			crossplot:publish("VICTORY1_HEROES", "empty")
		end
		if GlobalValue.Get("CURRENT_ERA") > 4 then
			crossplot:publish("VICTORY2_HEROES", "empty")
		end

		crossplot:publish("INITIALIZE_AI", "empty")		
	else
		crossplot:update()
    end
end