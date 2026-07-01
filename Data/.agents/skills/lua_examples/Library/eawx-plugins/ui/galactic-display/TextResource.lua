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
-- *       File:              TextResource.lua                                                      *
-- *       File Created:      Sunday, 23rd February 2020 02:46                                      *
-- *       Author:            [TR] Pox                                                              *
-- *       Last Modified:     Sunday, 23rd February 2020 02:47                                      *
-- *       Modified By:       [TR] Pox                                                              *
-- *       Copyright:         Thrawns Revenge Development Team                                      *
-- *       License:           This code may not be used without the author's explicit permission    *
-- **************************************************************************************************
require("eawx-util/StoryUtil")
require("eawx-plugins/ui/galactic-display/TextResourcePool")

---@class TextResource
TextResource = class()

---@param base_text_entry string
function TextResource:new(base_text_entry)
    self.base_text = base_text_entry

    ---@type string
    self.real_text = nil

    ---@public
    self.visible = false

    self:request_new()
end

function TextResource:request_new()
    if self.real_text then
        DebugMessage(
            "Warning: TextResource %s is being requested while still holding a resource. Aborting",
            tostring(self.base_text))
        return
    end

    local resource_tab = TextResourcePool[self.base_text]
    if not resource_tab or table.getn(resource_tab) == 0 then
        DebugMessage("Warning: No TextResource available for %s",
                     tostring(self.base_text))
        self.real_text = self.base_text
        return
    end

    self.real_text = table.remove(resource_tab)
    DebugMessage("Information: TextResource contains %s",
                 tostring(self.real_text))
end

---@param duration number
---@param var string|GameObject|GameObjectType
---@param color table
---@param teletype boolean
function TextResource:show(duration, var, color, teletype)
    if not self.real_text then return end

    StoryUtil.ShowScreenText(self.real_text, duration, var, color, teletype)
    self.visible = true
end

function TextResource:release()
    local resource_tab = TextResourcePool[self.base_text]

    if not resource_tab then return end

    if self.visible then
        DebugMessage("Warning: TextResource %s is being released while visible",
                     tostring(self.base_text))
    end

    table.insert(resource_tab, self.real_text)
    self.real_text = nil
end

function TextResource:remove()
    if not self.real_text then return end

    StoryUtil.RemoveScreenText(self.real_text)
    self.visible = false
end

function TextResource:remove_and_release()
    self:remove()
    self:release()
end
