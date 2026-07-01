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
--*       File:              Box.lua                                                               *
--*       File Created:      Tuesday, 7th July 2020 03:10                                          *
--*       Author:            [TR] Pox                                                              *
--*       Last Modified:     Tuesday, 7th July 2020 03:16                                          *
--*       Modified By:       [TR] Pox                                                              *
--*       Copyright:         Thrawns Revenge Development Team                                      *
--*       License:           This code may not be used without the author's explicit permission    *
--**************************************************************************************************

require("deepcore/std/class")
require("eawx-plugins/ui/galactic-display/LineSpacer")

---@class ContentBox
ContentBox = class()

---@param display_component DisplayComponent
---@param lines_after number
function ContentBox:new(display_component, lines_after)
    self.display_component = display_component
    self.spacer = LineSpacer(lines_after)
end

---@return boolean
function ContentBox:needs_update()
    return self.display_component:needs_update()
end

function ContentBox:render()
    self.display_component:render()
    self.spacer:render()
end
