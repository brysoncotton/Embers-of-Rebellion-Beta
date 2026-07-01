require("deepcore/std/class")
require("eawx-util/StoryUtil")

ShipCrewDisplayComponent = class()

---@param resource_manager LockBasedResourceManager
function ShipCrewDisplayComponent:new(resource_manager, abstract_resources)
    self.__needs_update = true

    self.InfrastructureScore = abstract_resources.InfrastructureScore
    self.InfrastructureScoreEffectLabel = abstract_resources.InfrastructureScoreEffectLabel

    self.ship_crews = resource_manager.ship_crews
    self.ship_crew_income = resource_manager.ship_crew_income

    self.UpkeepCost = abstract_resources.UpkeepCost
    self.HumanIsHutts = Find_Player("Hutt_Cartels").Is_Human()
    self.SmugglingIncome = abstract_resources.SmugglingIncome
    self.NetIncome = abstract_resources.NetIncome

    self.infrastructure_text_id = ""
    self.crews_text_id = ""
    self.credits_text_id = ""

    resource_manager.resources_changed_event:attach_listener(self.on_ship_crews_changed, self)
    abstract_resources.abstract_changed_event:attach_listener(self.on_abstract_changed, self)
end

function ShipCrewDisplayComponent:needs_update()
    return self.__needs_update
end

function ShipCrewDisplayComponent:render()
    self.__needs_update = false
    StoryUtil.RemoveScreenText(self.infrastructure_text_id)
    StoryUtil.RemoveScreenText(self.crews_text_id)
    StoryUtil.RemoveScreenText(self.credits_text_id)

    self.infrastructure_text_id = "INFRASTRUCTURE SCORE: " .. tostring(self.InfrastructureScore)

    local infrastructure_text_color = {r = 255, g = 255, b = 255}
    if self.InfrastructureScoreEffectLabel == "INFRASTRUCTURE_DEFICIT_SEVERE" then
        infrastructure_text_color = {r = 255, g = 0, b = 0}
        self.infrastructure_text_id = self.infrastructure_text_id .. " (SEVERE)"
    elseif self.InfrastructureScoreEffectLabel == "INFRASTRUCTURE_DEFICIT_SMALL" then
        infrastructure_text_color = {r = 255, g = 0, b = 0}
    elseif self.InfrastructureScoreEffectLabel == "INFRASTRUCTURE_SURPLUS" then
        infrastructure_text_color = {r = 0, g = 255, b = 0}
    end

    local ship_crew_income_string = self.ship_crew_income
    if tonumber(self.ship_crew_income) ~= nil then
        ship_crew_income_string = "+"..self.ship_crew_income
    end

    local upkeep_cost_string = "Pending"
    local smuggling_income_string = "Pending"
    local net_income_string = "Pending"
    if tonumber(self.UpkeepCost) ~= nil then
        upkeep_cost_string = "$"..self.UpkeepCost
        smuggling_income_string = "$"..self.SmugglingIncome
        net_income_string = "$"..self.NetIncome
    end

    self.crews_text_id = "SHIP CREWS: " .. tostring(self.ship_crews) .. " | PER CYCLE: " .. ship_crew_income_string

    self.credits_text_id = "SHIP UPKEEP: " .. upkeep_cost_string
    if self.HumanIsHutts == true then
        self.credits_text_id = self.credits_text_id .. " | SMUGGLING: " .. smuggling_income_string
    end
    self.credits_text_id = self.credits_text_id .. " | NET INCOME: " .. net_income_string

    StoryUtil.ShowScreenText("===========  INFRASTRUCTURE & RESOURCES   ===========", -1, nil, {r = 160, g = 160, b = 164}, false)
    StoryUtil.ShowScreenText(self.infrastructure_text_id, -1, nil, infrastructure_text_color, false)
    StoryUtil.ShowScreenText(self.crews_text_id, -1, nil, nil, false)
    StoryUtil.ShowScreenText(self.credits_text_id, -1, nil, nil, false)
end

function ShipCrewDisplayComponent:on_ship_crews_changed(ship_crews, ship_crew_income)
    self.ship_crews = ship_crews
    self.ship_crew_income = ship_crew_income

    self.__needs_update = true
end

function ShipCrewDisplayComponent:on_abstract_changed(upkeep_cost, infrastructure_score, infrastructure_score_effect_label, net_income, smuggling_income)
    self.UpkeepCost = upkeep_cost
    self.SmugglingIncome = smuggling_income
    self.InfrastructureScore = infrastructure_score
    self.InfrastructureScoreEffectLabel = infrastructure_score_effect_label
    self.NetIncome = net_income

    self.__needs_update = true
end
