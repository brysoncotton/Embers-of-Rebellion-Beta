--**************************************************************************************************
--*    _______ __                                                                                  *
--*   |_     _|  |--.----.---.-.--.--.--.-----.-----.                                              *
--*     |   | |     |   _|  _  |  |  |  |     |__ --|                                              *
--*     |___| |__|__|__| |___._|________|__|__|_____|                                              *
--*    ______                                                                                      *
--*   |   __ \.-----.--.--.-----.-----.-----.-----.                                                *
--*   |      <|  -__|  |  |  -__|     |  _  |  -__|                                                *
--*   |___|__||_____|\___/|_____|__|__|___  |_____|                                                *
--*                                   |_____|                                                      *
--*                                                                                                *
--*                                                                                                *
--*       File:              IncomingFleetEvent.lua                                                *
--*       File Created:      Monday, 24th February 2020 01:26                                      *
--*       Author:            [TR] Pox                                                              *
--*       Last Modified:     Monday, 24th February 2020 01:34                                      *
--*       Modified By:       [TR] Pox                                                              *
--*       Copyright:         Thrawns Revenge Development Team                                      *
--*       License:           This code may not be used without the author's explicit permission    *
--**************************************************************************************************

require("deepcore/std/class")
require("deepcore/std/Observable")
require("eawx-util/StoryUtil")

---@class IncomingFleetEvent
IncomingFleetEvent = class(Observable)

function IncomingFleetEvent:new(planets)
    self.planets = planets
end

function IncomingFleetEvent:update()
    local planet_name = GlobalValue.Get("CONQUER_OPPONENT")
    if StoryUtil.ValidGlobalValue(planet_name) then
        local planet = self.planets[planet_name]
        self:notify(planet)
        GlobalValue.Set("CONQUER_OPPONENT", "")
    end
end
