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
--*       File:              SelectedPlanetChangedEvent.lua                                        *
--*       File Created:      Sunday, 23rd February 2020 05:33                                      *
--*       Author:            [TR] Pox                                                              *
--*       Last Modified:     Sunday, 23rd February 2020 06:16                                      *
--*       Modified By:       [TR] Pox                                                              *
--*       Copyright:         Thrawns Revenge Development Team                                      *
--*       License:           This code may not be used without the author's explicit permission    *
--**************************************************************************************************

require("deepcore/std/class")
require("deepcore/std/Observable")

---@class SelectedPlanetChangedEvent : Observable
SelectedPlanetChangedEvent = class(Observable)

function SelectedPlanetChangedEvent:new(player, planets)
    self.player = player
    self.planets = planets
end

function SelectedPlanetChangedEvent:update(planet)
    if Check_Story_Flag(self.player, "ZOOMED_INTO_" .. planet:get_name(), nil, true) then
        GlobalValue.Set("SELECTED_PLANET", planet:get_name())
        self:notify(planet)
    end
end
