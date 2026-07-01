require("deepcore/std/class")
require("deepcore/std/callable")
require("eawx-util/ChangeOwnerUtilities")
require("eawx-util/PopulatePlanetUtilities")
require("eawx-statemachine/dsl/conditions")
require("eawx-util/StoryUtil")

---@class PlanetTransferBuilder
PlanetTransferBuilder = class()

---@vararg string
function PlanetTransferBuilder:new(...)
    ---@type table<number, string>
    self.planets = arg

    self.Active_Planets = {}

    ---@type PlayerObject
    self.target_owner = nil

    ---@type bool
    self.integrate_forces = nil

    ---@type fun(): boolean
    self.condition = function()
        return true
    end
end

---@param keep_forces bool
function PlanetTransferBuilder:to_owner(faction_name, keep_forces)
    self.target_owner = Find_Player(faction_name)
    self.integrate_forces = keep_forces
    return self
end

---@param condition fun(): boolean
function PlanetTransferBuilder:if_(condition)
    self.condition = condition
    return self
end

function PlanetTransferBuilder:build()
    return callable {
        planets = self.planets,
        new_owner = self.target_owner,
        condition = self.condition,
        Active_Planets = self.Active_Planets,
        integrate_forces = self.integrate_forces,
        call = function(self) 
            self.Active_Planets = StoryUtil.GetSafePlanetTable()      
            for _, planet in ipairs(self.planets) do
                local planet_name = planet
                if type(planet_name) ~= "string" then
                    planet_name = planet.Get_Type().Get_Name()
                end
                if self.Active_Planets[planet_name] then
                    local planet_object = self:get_planet(planet_name)
                    if self.condition(planet_object) then
                        if self.integrate_forces == true then
                            ChangePlanetOwnerAndReplace(planet_object, self.new_owner)
                        else
                            ChangePlanetOwnerAndPopulate(planet_object, self.new_owner)
                        end
                    end
                end
            end
        end,
        get_planet = function(self, planet_like)
            if type(planet_like) == "userdata" then
                return planet_like
            end

            if type(planet_like) == "table" and planet_like.get_game_object then
                return planet_like:get_game_object()
            end

            return FindPlanet(planet_like)
        end
    }
end

return PlanetTransferBuilder
