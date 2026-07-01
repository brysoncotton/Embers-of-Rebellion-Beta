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
--*       File:              InfluenceService.lua                                                  *
--*       File Created:      Sunday, 23rd February 2020 08:26                                      *
--*       Author:            [TR] Pox                                                              *
--*       Last Modified:     Sunday, 23rd February 2020 10:22                                      *
--*       Modified By:       [TR] Pox                                                              *
--*       Copyright:         Thrawns Revenge Development Team                                      *
--*       License:           This code may not be used without the author's explicit permission    *
--**************************************************************************************************
require("PGSpawnUnits")
require("deepcore/std/class")
require("eawx-util/ChangeOwnerUtilities")
ModContentLoader.get("influence-policy/InfluencePolicyRepository")

---@class InfluenceService
InfluenceService = class()

---@param human_player PlayerObject
---@param planets table<string, Planet>
---@param dummy_lifecycle_handler KeyDummyLifeCycleHandler
---@param blockade_attrition BlockadeAttrition
function InfluenceService:new(human_player, planets, dummy_lifecycle_handler, blockade_attrition, options_handler)
    self.human_player = human_player
    self.planets = {}
    self.dummy_lifecycle_handler = dummy_lifecycle_handler
    self.blockade_attrition = blockade_attrition
    self.options_handler = options_handler

    self.LoyaltyTable = ModContentLoader.get("influence-policy/LoyaltyTable")

    self.planets_in_crisis = 0

    self.ai_difficulty_modifier = 0

    self.mod_name = nil
    local mod_objects = {"rev","fotr","icw"}
    for _,object_name in pairs(mod_objects) do
        if Find_Object_Type(object_name) ~= nil then
            self.mod_name = object_name
            break
        end
    end

    local computer_player = nil
    local p_rebel = Find_Player("Rebel")
    if human_player == p_rebel then
        computer_player = Find_Player("Empire")
    else
        computer_player = p_rebel
    end

    self.ai_difficulty_modifier = 2
    if computer_player.Get_Difficulty() == "Easy" then
        self.ai_difficulty_modifier = 1
    elseif computer_player.Get_Difficulty() == "Hard" then
        self.ai_difficulty_modifier = 3
    end

    for _, planet in pairs(planets) do
        self.planets[planet] = {
            __current_influence_dummies = {},
            -- cyclesControlled = 0,
            ownerInfluence = 0,
            oldInfluence = 0,
            unrestLevel = 0,
            taxationLevel = 0,
            blockadeModifier = 0,
            cyclesBlockaded = 0,
            crisis_level = 0,
            oldOwner = nil,
            newOwner = nil,
            name = planet:get_readable_name(),
            object_name = planet:get_name()
        }
    end

    self.influence_unrest_growing = Observable()
    self.influence_revolt_occured = Observable()

    crossplot:subscribe("ADJUST_UNREST", self.adjust_unrest, self)
end

---@param planet Planet
function InfluenceService:get_influence_for_planet(planet)
    --Logger:trace("entering InfluenceService:get_influence_for_planet")
    return self.planets[planet].ownerInfluence
end

function InfluenceService:get_unrest_for_planet(planet)
    --Logger:trace("entering InfluenceService:get_unrest_for_planet")
    return self.planets[planet].unrestLevel
end

function InfluenceService:get_tax_for_planet(planet)
    --Logger:trace("entering InfluenceService:get_tax_for_planet")
    local planet_stats = self.planets[planet]
    planet_stats.taxationLevel = EvaluatePerception("Tax_Level", self.human_player, planet:get_game_object())
    return self.planets[planet].taxationLevel
end

---@param planet Planet
function InfluenceService:update(planet)
    --Logger:trace("entering InfluenceService:update")
    local planet_stats = self.planets[planet]

    planet_stats.newOwner = planet:get_owner()

    if planet_stats.newOwner == Find_Player("Neutral") then
        return
    elseif planet_stats.newOwner == Find_Player("Independent_Forces") then
        planet_stats.ownerInfluence = 10
    else
        local base_influence_human = 5

        local planet_game_object = planet:get_game_object()

        planet_stats.taxationLevel = EvaluatePerception("Tax_Level", self.human_player, planet_game_object)

        if planet_stats.newOwner == planet_stats.oldOwner then
            -- planet_stats.cyclesControlled = planet_stats.cyclesControlled + 1
            if planet_stats.unrestLevel == 3 then
                if planet_stats.newOwner == Find_Player("local") then
                    self.influence_revolt_occured:notify(planet)
                end
                self:revolt(planet)
                -- planet_stats.cyclesControlled = 0
                planet_stats.unrestLevel = 0
            end
        else
            -- if planet_stats.crisis_level < 0 then
            --     planet_stats.crisis_level = 0
            --     self.planets_in_crisis = self.planets_in_crisis - 1
            -- end

            -- planet_stats.cyclesControlled = 0
            planet_stats.unrestLevel = 0
        end

        local structure_influence = EvaluatePerception("Structure_Influence", self.human_player, planet_game_object)

        if EvaluatePerception("Blockaded", planet_stats.newOwner, planet_game_object) > 0 then
            if planet_stats.cyclesBlockaded >= 1 then
                self.blockade_attrition:attrition(planet)
            end
            planet_stats.cyclesBlockaded = planet_stats.cyclesBlockaded + 1
            if EvaluatePerception("Ground_Base_Level", self.human_player, planet_game_object) < 4 then
                if GameRandom(1, 100) < 20 then
                    planet_stats.blockadeModifier = planet_stats.blockadeModifier + 1
                end
            end
        else
            planet_stats.blockadeModifier = 0
            planet_stats.cyclesBlockaded = 0
        end

        local hero_influence = self:influence_hero_effects(planet_stats.newOwner,planet_game_object)

        --self:apply_week_controlled_influence(planet_stats)

        planet_stats.ownerInfluence = base_influence_human + structure_influence + hero_influence - planet_stats.blockadeModifier -- planet_stats.crisis_level

        local planetary_influence_policy = InfluencePolicyRepository[string.lower(planet:get_name())] or InfluencePolicyRepository.DEFAULT

        planet_stats.ownerInfluence = planet_stats.ownerInfluence + planetary_influence_policy(planet)

        if planet_stats.newOwner ~= Find_Player("local") then
            planet_stats.ownerInfluence = planet_stats.ownerInfluence + self.ai_difficulty_modifier
        elseif self.options_handler.cheat_influence_on == true then
            planet_stats.ownerInfluence = 10
            planet_stats.unrestLevel = 0
        end

        if planet_stats.ownerInfluence <= 1 then
            planet_stats.unrestLevel = planet_stats.unrestLevel + 1
            if planet_stats.newOwner == Find_Player("local") then
                self.influence_unrest_growing:notify(planet, planet_stats.unrestLevel)
            end
        elseif planet_stats.ownerInfluence == 2 then
            if GameRandom(1, 100) > 50 then
                planet_stats.unrestLevel = planet_stats.unrestLevel + 1
                if planet_stats.newOwner == Find_Player("local") then
                    self.influence_unrest_growing:notify(planet, planet_stats.unrestLevel)
                end
            end
        elseif planet_stats.ownerInfluence == 3 then
            if GameRandom(1, 100) > 66 then
                planet_stats.unrestLevel = planet_stats.unrestLevel + 1
                if planet_stats.newOwner == Find_Player("local") then
                    self.influence_unrest_growing:notify(planet, planet_stats.unrestLevel)
                end
            end
        elseif planet_stats.ownerInfluence >= 6 then
            planet_stats.unrestLevel = planet_stats.unrestLevel - 1
        end
        self:normalize_influence(planet_stats)
    end

    planet_stats.oldOwner = planet_stats.newOwner

    self:attach_particle(planet, planet_stats)
    self:apply_loyalty_modifiers(planet)

    planet_stats.oldInfluence = planet_stats.ownerInfluence
end

---@private
---@param planet_stats table<string, any>
-- function InfluenceService:apply_week_controlled_influence(planet_stats)
    -- if planet_stats.newOwner == planet_stats.oldOwner then
        -- planet_stats.cyclesControlled = planet_stats.cyclesControlled + 1
    -- else
        -- planet_stats.cyclesControlled = 0
    -- end

    -- for i = 10, 50, 20 do
        -- if planet_stats.cyclesControlled < i then
            -- break
        -- end

        -- planet_stats.ownerInfluence = planet_stats.ownerInfluence + 1
    -- end
-- end

function InfluenceService:attach_particle(planet, planet_stats)
    local planet_owner = planet:get_owner()
    if planet_owner == Find_Player("Neutral") then
        return
    end

    local planet_game_object = planet:get_game_object()

    planet_game_object.Attach_Particle_Effect("Display_Influence_" .. tostring(planet_stats.ownerInfluence))

    if planet_stats.unrestLevel <= 3 and planet_stats.unrestLevel >= 1 then
        planet_game_object.Attach_Particle_Effect("Display_Unrest_" .. tostring(planet_stats.unrestLevel))
    end

    --faction teams that use corruption use that to attach particles (gameconstants.xml <Corruption_Particle_Name>)
    --Rev: Republic + Sector Forces, FotR: CIS + corporations, TR: unused

    local faction_particle_table = {
        ["rev"] = {
            -- ["EMPIRE"] = "Old_Republic_Allies",
            ["REBEL"] = "Sith_Empire_Allies",
            ["UNDERWORLD"] = "Mando_Allies",
            ["HUTT_CARTELS"] = "Hutt_Allies",
            ["ALSAKAN_REPUBLIC"] = "Alsakan_Allies",
            ["CHISS"] = "Chiss_Allies",
            ["ETERNAL_EMPIRE"] = "Eternal_Empire_Allies",
            ["HAPES_CONSORTIUM"] = "HC_Allies",
            ["KILLIK_HIVES"] = "Killik_Allies",
            ["KRATH"] = "Krath_Allies",
            ["MON_CAL_KINGDOM"] = "Mon_Cal_Allies",
            ["RAKATA_EMPIRE"] = "Rakata_Allies",
            -- ["SECTOR_FORCES"] = "Old_Republic_Allies",
            ["SITH_WARLORDS"] = "Sith_Warlords_Allies",
            ["TION_HEGEMONY"] = "Tion_Allies",
        },
        ["fotr"] = {
            ["EMPIRE"] = "Republic_Allies",
            -- ["REBEL"] = "CIS_Allies",
            ["HUTT_CARTELS"] = "Hutt_Allies",
            -- ["BANKING_CLAN"] = "CIS_Allies",
            -- ["COMMERCE_GUILD"] = "CIS_Allies",
            ["MANDALORIANS"] = "Mando_Allies",
            ["SECTOR_FORCES"] = "Republic_Allies",
            -- ["TECHNO_UNION"] = "CIS_Allies",
            -- ["TRADE_FEDERATION"] = "CIS_Allies",
        },
        ["icw"] = {
            ["EMPIRE"] = "Empire_Allies",
            ["REBEL"] = "NR_Allies",
            ["CHISS"] = "Chiss_Allies",
            ["CORELLIA"] = "Corellia_Allies",
            ["CORPORATE_SECTOR"] = "CSA_Allies",
            ["EMPIREOFTHEHAND"] = "EotH_Allies",
            ["ERIADU_AUTHORITY"] = "EA_Allies",
            ["GREATER_MALDROOD"] = "GM_Allies",
            ["HAPES_CONSORTIUM"] = "HC_Allies",
            ["HUTT_CARTELS"] = "Hutt_Allies",
            ["KILLIK_HIVES"] = "Killik_Allies",
            ["PENTASTAR"] = "PA_Allies",
            ["SSIRUUVI_IMPERIUM"] = "Ssi_Allies",
            ["YEVETHA"] = "DL_Allies",
            ["ZSINJ_EMPIRE"] = "ZE_Allies",
            ["MANDALORIANS"] = "Mando_Allies",
        },
    }

    if faction_particle_table[self.mod_name][planet_owner.Get_Faction_Name()] == nil then
        return
    end

    planet_game_object.Attach_Particle_Effect(faction_particle_table[self.mod_name][planet_owner.Get_Faction_Name()])
end

---@private
---@param planet Planet
function InfluenceService:apply_loyalty_modifiers(planet)
    local planet_stats = self.planets[planet]
    if planet_stats.oldInfluence == planet_stats.ownerInfluence then
        return
    end

    local influence_structure_table = {
        {INFLUENCE_ONE = 1},
        {INFLUENCE_TWO = 1},
        {INFLUENCE_THREE = 1},
        {INFLUENCE_FOUR = 1},
        {INFLUENCE_FIVE = 1},
        {INFLUENCE_SIX = 1},
        {INFLUENCE_SEVEN = 1},
        {INFLUENCE_EIGHT = 1},
        {INFLUENCE_NINE = 1},
        {INFLUENCE_TEN = 1}
    }

    self.dummy_lifecycle_handler:remove_from_dummy_set(planet, planet_stats.__current_influence_dummies)

    planet_stats.__current_influence_dummies = influence_structure_table[planet_stats.ownerInfluence]
    self.dummy_lifecycle_handler:add_to_dummy_set(planet, planet_stats.__current_influence_dummies)
end

---@private
---@param planet_stats table<string, any>
function InfluenceService:normalize_influence(planet_stats)
    if planet_stats.ownerInfluence > 10 then
        planet_stats.ownerInfluence = 10
    end

    if planet_stats.ownerInfluence < 1 then
        planet_stats.ownerInfluence = 1
    end

    if planet_stats.unrestLevel > 3 then
        planet_stats.unrestLevel = 3
    end

    if planet_stats.unrestLevel < 0 then
        planet_stats.unrestLevel = 0
    end
end

---@private
---@param planet Planet
function InfluenceService:revolt(planet)
    --Logger:trace("entering InfluenceService:revolt")
    local planet_object = planet:get_game_object()

    local new_owner = self.LoyaltyTable[planet:get_name()]
    if new_owner == nil then
        new_owner = "Independent_Forces"
    end
    new_owner = Find_Player(new_owner)

    --planets owned by IF cannot revolt (see InfluenceService:update)
    if new_owner == planet:get_owner() then
        new_owner = Find_Player("Independent_Forces")
    end

    ChangePlanetOwnerAndPopulate(planet_object, new_owner, 4500)
end

function InfluenceService:adjust_unrest(planet_name,amount)
    local planet_struct = nil
    for planet, entry in pairs(self.planets) do
        if entry.object_name == planet_name then
            self.planets[planet].unrestLevel = self.planets[planet].unrestLevel + amount
            planet_struct = planet
            break
        end
    end

    self:normalize_influence(self.planets[planet_struct])
    self:attach_particle(planet_struct, self.planets[planet_struct])
end

--currently only non-stacking +1 influence traits exist so this might need to be expanded in future ~Mord
function InfluenceService:influence_hero_effects(planet_owner,planet_game_object)
    local plus_one_list = {
        "Haydel_Goravvus_At_Planet_Galactic", --Rev
        "Koa_Delko_At_Planet_Galactic",
        "Bail_Organa_At_Planet_Galactic", --FotR
        "Garm_Bel_Iblis_At_Planet_Galactic",
        "Giddean_Danu_At_Planet_Galactic",
        "Ask_Aak_At_Planet_Galactic",
        "Orn_Free_Taa_At_Planet_Galactic",
        "Paige_Tarkin_At_Planet_Galactic",
        "Padme_Amidala_At_Planet_Galactic",
        "Onaconda_Farr_At_Planet_Galactic",
        "Leia_At_Planet_Galactic", --TR
    }

    for _,perception_name in pairs(plus_one_list) do
        if EvaluatePerception(perception_name,planet_owner,planet_game_object) == 1 then
            return 1
        end
    end

    return 0
end
