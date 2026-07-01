require("deepcore/std/class")

StabilityManager = class()

function StabilityManager:new(ctx, influence)
    self.InfluenceService = influence
    self.ctx = ctx
    self.factionStability = {}
    self.factions = ModContentLoader.get("GameConstants")
    for i, faction in pairs(self.factions) do
        self.factionStability[faction] = self:get_stability(Find_Player(faction))
    end
end

function StabilityManager:get_stability(faction)
    --Logger:trace("entering StabilityManager:get_stability")
    local numOfPlanetsOwned = self.ctx.galactic_conquest:get_number_of_planets_owned_by_faction(faction)
    if numOfPlanetsOwned <= 0 then 
        return 
    end
    local maxLoyalty = numOfPlanetsOwned * 10
    local totalLoyalty = 0

    for _, planet in pairs(self.ctx.galactic_conquest:get_all_planets_by_faction(faction)) do
        totalLoyalty = totalLoyalty + self.loyaltyinfo[planet].LoyaltyLevel
    end

    local stabilityPercentage = tonumber(Dirty_Floor((totalLoyalty/maxLoyalty)*100))

    return stabilityPercentage
end

function StabilityManager:update()
    --Logger:trace("entering StabilityManager:planetary_revolt")
    for i, faction in pairs(self.factions) do
        self.factionStability[faction] = self:get_stability(Find_Player(faction))
        GlobalValue.Set("STABILITY_" .. faction, self.factionStability[faction])
    end
end

return StabilityManager