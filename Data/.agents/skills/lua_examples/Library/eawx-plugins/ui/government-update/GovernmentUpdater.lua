require("deepcore/std/class")
---@class GovernmentUpdater
GovernmentUpdater = class()

function GovernmentUpdater:new()

    local plot_name = StoryUtil.PlayerAgnosticPlots.Galactic
    local plot = Get_Story_Plot(plot_name)

    local click_event = plot.Get_Event("Government_Display_Clicked")
    click_event.Set_Reward_Parameter(1, Find_Player("local").Get_Faction_Name())
end

function GovernmentUpdater:update()
    DebugMessage("GovernmentUpdater:update -- update started")

    crossplot:publish("UPDATE_GOVERNMENT", "empty")
	
	trigger_unit = Find_First_Object("Event_Trigger")
	if trigger_unit ~= nil then
		trigger_unit_fleet = Assemble_Fleet({trigger_unit})
		trigger_unit_fleet.Activate_Ability()
	end

end

return GovernmentUpdater
