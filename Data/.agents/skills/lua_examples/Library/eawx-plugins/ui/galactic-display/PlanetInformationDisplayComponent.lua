--******************************************************************************
--     _______ __
--    |_     _|  |--.----.---.-.--.--.--.-----.-----.
--      |   | |     |   _|  _  |  |  |  |     |__ --|
--      |___| |__|__|__| |___._|________|__|__|_____|
--     ______
--    |   __ \.-----.--.--.-----.-----.-----.-----.
--    |      <|  -__|  |  |  -__|     |  _  |  -__|
--    |___|__||_____|\___/|_____|__|__|___  |_____|
--                                    |_____|
--*   @Author:              [TR]Pox
--*   @Date:                2017-12-22T10:19:56+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            DisplayManager.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2018-03-17T02:25:08+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************

require("deepcore/std/class")
require("eawx-util/StoryUtil")
require("eawx-plugins/ui/galactic-display/DisplayStructuresUtilities")

---@class PlanetInformationDisplayComponent
PlanetInformationDisplayComponent = class()

function PlanetInformationDisplayComponent:new(influence_service, selectedPlanetChangedEvent, productionFinishedEvent, options_handler)
    ---@private
    ---@type string[]
    self.current_text = {}

    ---@private
    ---@type Planet
    self.selected_planet = nil

    ---@private
    self.__needs_update = false

    ---@type InfluenceService
    self.influence_service = influence_service

    selectedPlanetChangedEvent:attach_listener(self.on_selected_planet_changed, self)
    productionFinishedEvent:attach_listener(self.on_production_finished, self)

    self.options_handler = options_handler
end

function PlanetInformationDisplayComponent:needs_update()
    return self.__needs_update
end

---@private
---@param planet Planet
function PlanetInformationDisplayComponent:on_production_finished(planet)
    if planet ~= self.selected_planet or not planet:get_owner().Is_Human() then
        return
    end

    self.__needs_update = true
end

---@private
---@param planet Planet
function PlanetInformationDisplayComponent:on_selected_planet_changed(planet)
    self.selected_planet = planet
    self.__needs_update = true
end

function PlanetInformationDisplayComponent:render()
    self.__needs_update = false

    if not self.selected_planet then
        return
    end

    local owner = self.selected_planet:get_owner()
    local owner_name = owner.Get_Faction_Name()
    local color = CONSTANTS.FACTION_COLORS[owner_name]

    self:clear()
    self:render_basic_planet_information(owner_name, color)

    if StoryUtil.CheckPlanetRestricted(self.selected_planet:get_name()) == true then
        self:render_lock_message(owner_name)
        return
    end

    self:render_influence_information(color)

    if not self.selected_planet:get_owner().Is_Human() and self.options_handler.cheat_vision_on == false then
        return
    end

    self:render_structure_information(color)
end

---@private
function PlanetInformationDisplayComponent:render_basic_planet_information(owner_name, color)
    local planet_and_owner = self.selected_planet:get_readable_name() .. " | " .. CONSTANTS.ALL_FACTION_NAMES[owner_name]

    StoryUtil.ShowScreenText("=============   PLANET   INFORMATION   =============", -1, nil, {r = 160, g = 160, b = 164}, false)
    StoryUtil.ShowScreenText(planet_and_owner, -1, nil, color, false)

    self.current_text = {planet_and_owner}
end

---@private
function PlanetInformationDisplayComponent:render_lock_message(owner_name)
    local lock_message1 = "Access to this system is restricted"
    StoryUtil.ShowScreenText(lock_message1, -1, nil, {r = 255, g = 0, b = 0}, false)
    table.insert(self.current_text,lock_message1)

    local lock_message2
    if owner_name == "NEUTRAL" then
        lock_message2 = "Fleets may pass through this system but may not stop here"
    else 
        lock_message2 = "Fleets may not pass through this system"
    end

    StoryUtil.ShowScreenText(lock_message2, -1, nil, {r = 255, g = 0, b = 0}, false)
    table.insert(self.current_text,lock_message2)
end

---@private
function PlanetInformationDisplayComponent:render_structure_information(color)
    local structures_on_planet = self.selected_planet:get_orbital_structure_information()

    for structure_text, amount in pairs(structures_on_planet) do
        table.insert(self.current_text, structure_text)
        local number = GameObjectNumber(amount)
        if number then
            StoryUtil.ShowScreenText(structure_text, -1, number, color, false)
        end
    end
end

---@private
function PlanetInformationDisplayComponent:render_influence_information(color)
    local influence_on_planet = self.influence_service:get_influence_for_planet(self.selected_planet)
    local unrest_on_planet = self.influence_service:get_unrest_for_planet(self.selected_planet)
    local taxation_level = self.influence_service:get_tax_for_planet(self.selected_planet)
    local influence_level = GameObjectNumber(influence_on_planet)

    if influence_on_planet < 4 or unrest_on_planet == 3 then
        color = {r = 255, g = 0, b = 0}
    end

    local influence_tax_and_unrest

    if influence_level then
        influence_tax_and_unrest = "Influence: "..tostring(influence_on_planet)

        if taxation_level > 0 then
            influence_tax_and_unrest = influence_tax_and_unrest .. " | Tax Level: " .. tostring(taxation_level) .. " ( -" .. tostring(2*taxation_level) .. " influence)"
        end

        if unrest_on_planet > 0 then
            influence_tax_and_unrest = influence_tax_and_unrest .. " | Unrest: " .. tostring(unrest_on_planet) .. " / 3"
        end

        if unrest_on_planet == 3 then
            influence_tax_and_unrest = influence_tax_and_unrest .. " (Revolt imminent)"
        end

        StoryUtil.ShowScreenText(influence_tax_and_unrest, -1, nil, color, false)
    end

    table.insert(self.current_text,influence_tax_and_unrest)
end

---@private
function PlanetInformationDisplayComponent:clear()
    for _, text in pairs(self.current_text) do
        StoryUtil.RemoveScreenText(text)
    end
end

return PlanetInformationDisplayComponent
