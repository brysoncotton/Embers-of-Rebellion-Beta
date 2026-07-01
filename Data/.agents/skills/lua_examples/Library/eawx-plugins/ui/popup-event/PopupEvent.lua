
require("deepcore/std/class")
require("eawx-events/GenericPopup")
require("eawx-util/StoryUtil")
---@class PopupEvent
PopupEvent = class()

function PopupEvent:new()
	local plot = Get_Story_Plot("Conquests\\Player_Agnostic_Plot.xml")
	--Logger:trace("entering PopupEvent:new()")

    if plot ~= nil then
		local click_event = plot.Get_Event("Click_Current_Event_Button_Event")
		click_event.Set_Reward_Parameter(1, Find_Player("local").Get_Faction_Name())
	end
	
	crossplot:subscribe("POPUPEVENT", self.PopupCall, self)
end

function PopupEvent:update()
    DebugMessage("PopupEvent:update -- update started")
	--Logger:trace("entering PopupEvent:update()")
	local trigger_unit_fleet = Assemble_Fleet({Find_First_Object("Event_Trigger")})
	
	if trigger_unit_fleet ~= nil then
		trigger_unit_fleet.Activate_Ability()
	end

end

function PopupEvent:PopupCall(event_name, options_table, planet_list, player_list, spawn_list, show_holocron_list, movie_name_list, unlock_list, lock_list, crossplot_event) --active_planets, 
	StoryUtil.ShowScreenText(" ", 5)
	GenericPopup(StoryUtil.GetSafePlanetTable(), event_name, options_table, planet_list, player_list, spawn_list, show_holocron_list, movie_name_list, unlock_list, lock_list, crossplot_event)
	StoryUtil.ShowScreenText("  ", 5) --Apparently there needs to be a slight delay?
end

return PopupEvent