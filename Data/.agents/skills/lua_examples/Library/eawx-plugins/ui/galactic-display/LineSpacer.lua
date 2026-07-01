-- **************************************************************************************************
-- *    _______ __                                                                                  *
-- *   |_     _|  |--.----.---.-.--.--.--.-----.-----.                                              *
-- *     |   | |     |   _|  _  |  |  |  |     |__ --|                                              *
-- *     |___| |__|__|__| |___._|________|__|__|_____|                                              *
-- *    ______                                                                                      *
-- *   |   __ \.-----.--.--.-----.-----.-----.-----.                                                *
-- *   |      <|  -__|  |  |  -__|     |  _  |  -__|                                                *
-- *   |___|__||_____|\___/|_____|__|__|___  |_____|                                                *
-- *                                   |_____|                                                      *
-- *                                                                                                *
-- *                                                                                                *
-- *       File:              LineSpacer.lua                                                        *
-- *       File Created:      Tuesday, 7th July 2020 02:44                                          *
-- *       Author:            [TR] Pox                                                              *
-- *       Last Modified:     Tuesday, 7th July 2020 02:44                                          *
-- *       Modified By:       [TR] Pox                                                              *
-- *       Copyright:         Thrawns Revenge Development Team                                      *
-- *       License:           This code may not be used without the author's explicit permission    *
-- **************************************************************************************************
require("deepcore/std/class")
require("eawx-plugins/ui/galactic-display/TextResource")

---@class LineSpacer
LineSpacer = class()

---@param number_of_lines string
function LineSpacer:new(number_of_lines)
    ---@type TextResource[]
    self.text_resources = {}

    for _ = 1, number_of_lines do
        table.insert(self.text_resources, TextResource("TEXT_SPACER"))
    end
end

function LineSpacer:render()
    for _, text_resource in ipairs(self.text_resources) do
        text_resource:remove()
        text_resource:show(-1)
    end
end

return LineSpacer
