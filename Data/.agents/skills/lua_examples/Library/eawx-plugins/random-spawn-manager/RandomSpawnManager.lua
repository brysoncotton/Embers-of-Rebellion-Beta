require("PGSpawnUnits")
require("eawx-util/PopulatePlanetUtilities")
require("eawx-util/StoryUtil")
CONSTANTS = ModContentLoader.get("GameConstants")

---@class RandomSpawnManager
require("deepcore/std/class")

RandomSpawnManager = class()

function RandomSpawnManager:new(gc, generated, id)
    -- table to store infrastructure score per faction
    local p_human = Find_Player("local")

    local infrastructure_table = {}
    local income_table = {}
    local tradestation_table = {}

    for _, faction in pairs(CONSTANTS.PLAYABLE_FACTIONS) do
        local faction_object = Find_Player(faction) 
        local planets_by_faction = gc.Planets_By_Faction[faction]
        local starting_infrastructure = 0

        if planets_by_faction then
            local income = EvaluatePerception("Current_Income", faction_object)
            income_table[faction_object] = income
            tradestation_table[faction_object] = 0

            for _, planet in pairs(planets_by_faction) do
                starting_infrastructure = starting_infrastructure + EvaluatePerception("Infrastructure_Score", faction_object, planet:get_game_object())
            end

            DebugMessage("%s -- Starting infrastructure for %s is %s", tostring(Script), tostring(faction), tostring(starting_infrastructure))

            infrastructure_table[faction_object] = starting_infrastructure
        else
            infrastructure_table[faction_object] = 0
        end
    end

    self.is_generated = generated

    self.Active_Planets = StoryUtil.GetSafePlanetTable()
    self.starting_force_dummies = Find_All_Objects_Of_Type("Generate_Force")
    self.starting_power = 1000

    -- spawn capital if it doesn't exist
    if self.is_generated then
        for faction_name, capital_table in pairs(CONSTANTS.ALL_FACTIONS_CAPITALS) do
            if capital_table.STRUCTURE then
                local capital_spawned = false
                if EvaluatePerception("Planet_Ownership", Find_Player(faction_name)) > 0 then
                    if not Find_First_Object(capital_table.STRUCTURE) then
                        for _, planet in pairs(capital_table.LOCATION) do
                            if self.Active_Planets[planet] then
                                if FindPlanet(planet).Get_Owner() == Find_Player(faction_name) then
                                    SpawnList({capital_table.STRUCTURE}, FindPlanet(planet), Find_Player(faction_name), true, false)
                                    capital_spawned = true
                                    break
                                end
                            end
                        end

                        if capital_spawned == false then
                            StoryUtil.SpawnAtSafePlanet(capital_table.LOCATION, Find_Player(faction_name), self.Active_Planets, {capital_table.STRUCTURE})
                        end
                    end
                end
            end
        end    
    end

    for _, dummy in pairs(self.starting_force_dummies) do
        local planet = dummy.Get_Planet_Location()
        if planet then
            local owner = dummy.Get_Owner()
            local forces = self.starting_power
            DebugMessage("%s -- dummy owner is %s", tostring(Script), tostring(owner.Get_Name()))

            if owner == p_human and id == "FTGU" then
                FTGU_Human_Starting_Forces(planet, owner)
            else
                for _, faction_name in pairs(CONSTANTS.NONPLAYABLE_FACTIONS) do
                    if owner == Find_Player(faction_name) then
                        forces = -1
                    end
                end
    
                if not infrastructure_table[owner] then
                    ChangePlanetOwnerAndPopulate(dummy.Get_Planet_Location(), owner, forces)
                else
                    local infrastructure = 0
                    local limit_spawns = infrastructure_table[owner] > 0
                    
                    -- spawn extra stuff if the infrastructure score for the faction is less than 0
                    infrastructure = ChangePlanetOwnerAndPopulate(planet, owner, self.starting_power, false, limit_spawns)
                    
                    local planet_income = EvaluatePerception("PlanetBaseIncome", owner, planet)
                    local has_groundbase = EvaluatePerception("MaxGroundbaseLevel", owner, planet) > 0
                    local has_open_slots = EvaluatePerception("Open_Ground_Structure_Slots", owner, planet) > 0
        
                    -- if planet's income is greater than 150cr and its owner is poor, give it a tax agency
                    if planet_income > 150 and income_table[owner] < 4000 and has_groundbase and has_open_slots and owner.Get_Faction_Name() ~= "HUTT_CARTELS" then
                        DebugMessage("%s -- spawning tax agency at %s for %s", tostring(Script), tostring(planet), tostring(owner.Get_Name()))
                        Spawn_Unit(Find_Object_Type("Tax_Agency"), planet, owner)
                        infrastructure = infrastructure + 1
                    end
                    
                    infrastructure_table[owner] = infrastructure_table[owner] + infrastructure
                    
                    if tradestation_table[owner] < 10 then
                        if SpawnTradeStation(owner, planet) then
                            tradestation_table[owner] = tradestation_table[owner] + 1
                        end
                    end
                    
                    DebugMessage("%s -- Added infrastructure of value %s for %s, total now %s", tostring(Script), tostring(infrastructure), tostring(owner), tostring(infrastructure_table[owner]))
                end
            end
        end
        dummy.Despawn()
    end
end

function FTGU_Human_Starting_Forces(planet, player)
    local total_spawn_table = DefineUnitTable(player.Get_Faction_Name())

    SpawnStarBase(player, planet, total_spawn_table["Starbase_Table"], false)
    SpawnShipyard(player, planet, total_spawn_table["Shipyard_Table"], total_spawn_table["Defenses_Table"])
    Spawn_Unit(Find_Object_Type("TradeStation"), planet, player)

    local era_tag = "ERA_" .. tostring(GlobalValue.Get("CURRENT_ERA"))
    
    for faction_name, era_table in pairs(CONSTANTS.FTGU_HUMAN_START_FORCES) do
        if Find_Player(faction_name) == player then
            for era_key, spawn_list in pairs(era_table) do
                if era_key == era_tag then 
                    SpawnList(spawn_list, planet, player, true, false)
                end
            end
        end
    end
end
