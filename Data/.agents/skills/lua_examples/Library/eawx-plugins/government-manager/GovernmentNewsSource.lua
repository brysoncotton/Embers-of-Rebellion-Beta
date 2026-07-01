require("deepcore/std/class")
require("deepcore/std/Observable")

---@class GovernmentNewsSource : Observable
GovernmentNewsSource = class(Observable)

---@param government_manager GovernmentManager
function GovernmentNewsSource:new(government_manager)
    government_manager.SHIPMARKET.Events.ShipsAdded:attach_listener(self.on_ships_added, self)
    government_manager.FAVOUR.Events.SupportReached:attach_listener(self.on_support_reached, self)
end

function GovernmentNewsSource:on_ships_added(ship_info)
    --Logger:trace("entering GovernmentNewsSource:on_ships_added")
    DebugMessage("GovernmentNewsSource Started")
    self:notify {
        headline = "A(n) "..ship_info.added.." has been added to the ".. ship_info.market_name,
        var = nil,
        color = ship_info.news_colour
    }
    DebugMessage("GovernmentNewsSource Finished")
end

function GovernmentNewsSource:on_support_reached(support_info)
    --Logger:trace("entering GovernmentNewsSource:on_support_reached")
    DebugMessage("GovernmentNewsSource Started")
    self:notify {
        headline = support_info.added,
        var = nil,
        color = {r = 255, g = 255, b = 255}
    }
    DebugMessage("GovernmentNewsSource Finished")
end
