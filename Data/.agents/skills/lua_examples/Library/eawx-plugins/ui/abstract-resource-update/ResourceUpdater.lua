require("deepcore/std/class")
---@class ResourceUpdater
ResourceUpdater = class()

function ResourceUpdater:new()

    local plot_name = StoryUtil.PlayerAgnosticPlots.Galactic
    local plot = Get_Story_Plot(plot_name)

    local click_event = plot.Get_Event("Resource_Display_Clicked")
    click_event.Set_Reward_Parameter(1, Find_Player("local").Get_Faction_Name())
end

function ResourceUpdater:update()
    DebugMessage("ResourceUpdater:update -- update started")
    crossplot:publish("UPDATE_RESOURCES", "empty")

end


return ResourceUpdater
