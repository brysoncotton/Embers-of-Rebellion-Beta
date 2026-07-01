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
--*       File:              AbstractResourceManager.lua                                           *
--*       File Created:      Sunday, 23rd February 2020 08:26                                      *
--*       Author:            [TR] Corey                                                            *
--*       Last Modified:     Sunday, 23rd February 2020 10:22                                      *
--*       Modified By:       [TR] Corey                                                            *
--*       Copyright:         Thrawns Revenge Development Team                                      *
--*       License:           This code may not be used without the author's explicit permission    *
--**************************************************************************************************
require("pgevents")
require("pgbase")
require("deepcore/std/class")
require("deepcore/std/Observable")
require("eawx-std/HelperDialogue")
require("eawx-util/StoryUtil")
CONSTANTS = ModContentLoader.get("GameConstants")

---@class AbstractResourceManager
AbstractResourceManager = class()

---@param gc GalacticConquest
---@param dummy_lifecycle_handler KeyDummyLifeCycleHandler
---@param resource_manager LockBasedResourceManager
function AbstractResourceManager:new(gc, dummy_lifecycle_handler, resource_manager, options_handler, influence_service, patron_handler)
    self.plot = Get_Story_Plot("Conquests\\Player_Agnostic_Plot.xml")

    self.galactic_conquest = gc
    self.human_player = gc.HumanPlayer 

    self.computer_player = Find_Player("Empire")
    if self.computer_player == self.human_player then
        self.computer_player = Find_Player("Rebel")
    end

    self.human_player_name = self.human_player.Get_Name()
    self.dummy_lifecycle_handler = dummy_lifecycle_handler
    self.resource_manager = resource_manager
    self.options_handler = options_handler
    self.influence_service = influence_service
    self.patron_handler = patron_handler

    self.AllPlanets = FindPlanet.Get_All_Planets()

    self.id = string.lower(GlobalValue.Get("MOD_ID"))
    self.DevastatorTable ={"KLEV_SILENCER_7_FRIGATE", "KLEV_SILENCER_7_DESTROYER", "WORLD_DEVASTATOR_FRIGATE", "WORLD_DEVASTATOR_DESTROYER"}

    self.ShipCrewIncome = 0
    self.ShipCrewIncomeDisplay = ""

    self.CrewValueColony1 = 15
    self.CrewValueColony2 = 30
    self.CrewValueNavalAcademy = 75
    self.CrewValueCloningFacility = 75
    self.CrewValueMothmaChiefOfState = 150
    if Find_Object_Type("rev") then
        self.CrewValueColony1 = 5
        self.CrewValueColony2 = 10
        self.CrewValueNavalAcademy = 25
        self.CrewValueCloningFacility = 25
    end

    self.InfrastructureDisplayInitialized = false
    self.InfrastructureScore = "Pending"
    self.InfrastructureScoreEffect = nil
    self.InfrastructureScoreEffectLabel = nil
    self.InfrastructureOpenSlotsDisplay = ""

    self.extension_bonus = 10
    self.open_slots = 0
    self.total_slots = 0
    self.open_slot_percentage = 0 

    self.UpkeepDisplayInitialized = false
    self.UpkeepCost = "Pending"
    self.NetIncome = 0
    self.SmugglingIncome = 0
    self.Initialized = false

    gc.Events.PlanetOwnerChanged:attach_listener(self.on_planet_owner_changed, self)
    gc.Events.GalacticProductionFinished:attach_listener(self.on_production_finished, self)
    gc.Events.TacticalBattleEnded:attach_listener(self.on_battle_end, self)
   
    crossplot:subscribe("UPDATE_RESOURCES", self.UpdateDisplay, self)
    crossplot:subscribe("SMUGGLING_INCOME", self.on_smuggling_changed, self)
    crossplot:subscribe("UPDATE_INFRA", self.update_infrastructure, self)
    crossplot:subscribe("CALCULATE_CREW_INCOME", self.calculate_ship_crew_income, self)
    crossplot:subscribe("CHECK_UPKEEP", self.check_upkeep, self)

    self.abstract_changed_event = Observable()
    self.infrastructure_event = Observable()
end

function AbstractResourceManager:update()
    --Logger:trace("entering AbstractResourceManager:update")

    self:accrue_ship_crew_income()
    self:update_infrastructure()
    self:charge_upkeep()
    self:check_upkeep()
end

function AbstractResourceManager:on_planet_owner_changed(planet, new_owner_name, old_owner_name)
    --Logger:trace("entering AbstractResourceManager:on_planet_owner_changed")
    if new_owner_name ~= self.human_player_name and old_owner_name ~= self.human_player_name then
        return
    end

    self:check_upkeep()
end

function AbstractResourceManager:on_production_finished(planet, game_object_type_name)
    --Logger:trace("entering AbstractResourceManager:on_production_finished")
    if planet:get_owner() ~= self.human_player then
        return
    end

    self:check_upkeep()
end

function AbstractResourceManager:on_battle_end(mode)
    --Logger:trace("entering AbstractResourceManager:on_battle_end")
    self:check_upkeep()
end

function AbstractResourceManager:check_upkeep(initialize_display)
    --Logger:trace("entering AbstractResourceManager:check_upkeep")

    if initialize_display == true then
        self.UpkeepDisplayInitialized = true
    end

    if self.UpkeepDisplayInitialized ~= true then
        return
    end

    self.UpkeepCost =   tonumber(Dirty_Floor(EvaluatePerception("Total_Maintenance", self.human_player))) 
                      - (10 * EvaluatePerception("LightFactory_Count", self.human_player)) 
                      - (20 * EvaluatePerception("HeavyFactory_Count", self.human_player)) 
                      - (30 * EvaluatePerception("AdvFactory_Count", self.human_player))
    if self.UpkeepCost < 0 then
        self.UpkeepCost = 0
    end
    self.NetIncome = tonumber(Dirty_Floor(EvaluatePerception("Current_Income", self.human_player) - self.UpkeepCost + self.SmugglingIncome))

    GlobalValue.Set("HUMAN_CURRENT_NET_INCOME",self.NetIncome)

    if self.UpkeepDisplayInitialized == true then
        self.abstract_changed_event:notify(self.UpkeepCost, self.InfrastructureScore, self.InfrastructureScoreEffectLabel, self.NetIncome, self.SmugglingIncome)
    end
end

function AbstractResourceManager:update_infrastructure(initialize_display)
    --update infrastructure score
    if initialize_display == true then
        self.InfrastructureDisplayInitialized = true
    end

    if self.InfrastructureDisplayInitialized ~= true then
        return
    end

    self.extension_bonus = 10
    self.open_slots = 0
    self.total_slots = 0
    self.InfrastructureScore = 0

    for _, planet in pairs(self.AllPlanets) do
        if planet.Get_Owner() == self.human_player then
            self.extension_bonus = self.extension_bonus - 2
            self.total_slots = self.total_slots + EvaluatePerception("Total_Slots", self.human_player, planet)
            self.open_slots = self.open_slots + EvaluatePerception("Open_Slots", self.human_player, planet)
            self.InfrastructureScore = self.InfrastructureScore + EvaluatePerception("Infrastructure_Score", self.human_player, planet)
        end
    end
    self.open_slot_percentage = tonumber(Dirty_Floor((self.open_slots / self.total_slots) * 100))
    self.InfrastructureScore = self.InfrastructureScore + self.extension_bonus

    self.InfrastructureOpenSlotsDisplay = "Open slots: " .. tostring(self.open_slot_percentage).."%% ("..tostring(self.open_slots).." / "..tostring(self.total_slots)..")"

    GlobalValue.Set("CURRENT_INFRASTRUCTURE", self.InfrastructureScore)
    GlobalValue.Set("OPEN_INFRASTRUCTURE_SLOTS", self.open_slots)

    --update infrastructure effects (if any)
    local InfrastructureScoreEffectLabelOld = self.InfrastructureScoreEffectLabel
    self.InfrastructureScoreEffectLabel = nil
    
    if self.InfrastructureScoreEffect ~= nil then
        self.dummy_lifecycle_handler:remove_from_dummy_set(self.human_player, self.InfrastructureScoreEffect)
    end

    local resource_effect_table = {
        {["INFRASTRUCTURE_DEFICIT_SEVERE"] = 1},
        {["INFRASTRUCTURE_DEFICIT_SMALL"] = 1},
        {["INFRASTRUCTURE_SURPLUS"] = 1},
        {["CHEAT_DUMMY_INFRA_AND_DISCOUNT"] = 1},
    }

    if self.InfrastructureScore == "Pending" then
        self.InfrastructureScoreEffect = nil
    elseif self.options_handler.cheat_infra_and_discount_on == true then
        self.InfrastructureScoreEffect = resource_effect_table[4]
    elseif self.InfrastructureScore <= -30 then
        self.InfrastructureScoreEffect = resource_effect_table[1]
    elseif self.InfrastructureScore < 0 then
        self.InfrastructureScoreEffect = resource_effect_table[2] 
    elseif self.open_slot_percentage < 5 then
        self.InfrastructureScoreEffect = resource_effect_table[3]
    else
        self.InfrastructureScoreEffect = nil
    end

    if self.InfrastructureScoreEffect ~= nil then
        self.dummy_lifecycle_handler:add_to_dummy_set(self.human_player, self.InfrastructureScoreEffect)
        
        for k,v in pairs(self.InfrastructureScoreEffect) do
            self.InfrastructureScoreEffectLabel = k
        end
    end

    if InfrastructureScoreEffectLabelOld ~= self.InfrastructureScoreEffectLabel then
        local ChangeNotice = nil
        if self.InfrastructureScoreEffectLabel == nil then
            ChangeNotice = "INFRASTRUCTURE_NORMAL"
        else
            ChangeNotice = self.InfrastructureScoreEffectLabel
        end

        self.infrastructure_event:notify(ChangeNotice)
        self:check_upkeep()
    end

    if initialize_display == true then
        self.abstract_changed_event:notify(self.UpkeepCost, self.InfrastructureScore, self.InfrastructureScoreEffectLabel, self.NetIncome, self.SmugglingIncome)
    end
end

function AbstractResourceManager:accrue_ship_crew_income()
    --Logger:trace("entering AbstractResourceManager:shipcrews")
    self:calculate_ship_crew_income()
    self.resource_manager:add_ship_crews(self.ShipCrewIncome)
end

function AbstractResourceManager:calculate_ship_crew_income(initialize_display)
    --Logger:trace("entering AbstractResourceManager:shipcrews")

    self.ShipCrewIncome =   (self.CrewValueColony1 * EvaluatePerception("Colony1_Count", self.human_player))
                          + (self.CrewValueColony2 * EvaluatePerception("Colony2_Count", self.human_player))
                          + (self.CrewValueNavalAcademy * EvaluatePerception("Capital_Count", self.human_player))
                          + (self.CrewValueNavalAcademy * EvaluatePerception("UniqueAcademy_Count", self.human_player))
                          + (self.CrewValueNavalAcademy * EvaluatePerception("NavalAcademy_Count", self.human_player))
                          + (self.CrewValueCloningFacility * EvaluatePerception("CloningFacility_Count", self.human_player))
    self.ShipCrewIncome = self.ShipCrewIncome + self:calculate_ship_crew_income_from_influence()

    if self.human_player == Find_Player("Rebel") then
        local chief_of_state = GlobalValue.Get("ChiefOfState")
        if chief_of_state ==  "DUMMY_CHIEFOFSTATE_MOTHMA" then
            self.ShipCrewIncome = self.ShipCrewIncome + self.CrewValueMothmaChiefOfState
        end
    end

    GlobalValue.Set("CURRENT_CREW_INCOME",self.ShipCrewIncome)

    self.ShipCrewIncomeDisplay = "Ship Crews per cycle: " .. tostring(self.ShipCrewIncome)

    self.resource_manager:set_ship_crew_income(self.ShipCrewIncome,initialize_display)
end

function AbstractResourceManager:calculate_ship_crew_income_from_influence()
    local crews_from_influence = 0
    local human_owned_planets = self.galactic_conquest:get_all_planets_by_faction(self.human_player)

    for _,planet in pairs(human_owned_planets) do
        local influence = self.influence_service:get_influence_for_planet(planet)
        if influence > 4 then
            local marginal_crews = (influence - 4) * 2
            if Find_Object_Type("icw") or Find_Object_Type("fotr") then
                marginal_crews = marginal_crews * 3
            end
            crews_from_influence = crews_from_influence + marginal_crews
        end
    end

    return crews_from_influence
end

function AbstractResourceManager:charge_upkeep()
    if self.Initialized ~= true then
        self.Initialized = true
        return
    end

    local EffectiveUpkeepCost = self.UpkeepCost
    if type(EffectiveUpkeepCost) ~= "number" then
        EffectiveUpkeepCost = 0
    end

    if EffectiveUpkeepCost > EvaluatePerception("Current_Credits", self.human_player) then
        self.InfrastructureScore = self.InfrastructureScore - 50
    end

    self.human_player.Give_Money(-1 * EffectiveUpkeepCost)

    local cruel_on = GlobalValue.Get("CRUEL_ON")
    local difficulty = self.computer_player.Get_Difficulty()

    for _, faction_name in pairs(CONSTANTS.PLAYABLE_FACTIONS) do
        local player = Find_Player(faction_name)
        if player ~= self.human_player then
            local ai_credits = tonumber(Dirty_Floor(EvaluatePerception("Current_Credits", player)))
            local ai_revenue = EvaluatePerception("Current_Income", player)

            local ai_maintenance = tonumber(Dirty_Floor(EvaluatePerception("Total_Maintenance", player)))
            local ai_net_income = ai_revenue - ai_maintenance 

            --there are 2 safety rails here:
            local ai_upkeep_to_pay = 0
            --1. on Easy mode, when an AI's net income exceeds 150% human net income, upkeep costs are used to cap it
            if difficulty == "Easy" and cruel_on == 0 and ai_net_income > ( 1.5 * self.NetIncome) then
                ai_upkeep_to_pay = ai_net_income - (1.5 * self.NetIncome)
            --2. else when an AI is short on cash *and* its maintenance exceeds 50% of revenue, upkeep is capped at 50% of revenue
            elseif ai_credits < 10000 and (0.5 * ai_revenue) < ai_maintenance then 
                ai_upkeep_to_pay = 0.5 * ai_revenue
            else 
                ai_upkeep_to_pay = ai_maintenance
            end

            player.Give_Money(-1 * ai_upkeep_to_pay)
        end
    end
end

function AbstractResourceManager:on_smuggling_changed(smuggling_income)
    --Logger:trace("entering LockBasedResourceManager:on_smuggling_changed")
    self.SmugglingIncome = smuggling_income
    self:check_upkeep()
end

function AbstractResourceManager:UpdateDisplay()
    --Logger:trace("entering AbstractResourceManager:UpdateDisplay")
   
    local resource_display_event = self.plot.Get_Event("Resource_Display")

    resource_display_event.Clear_Dialog_Text()
    resource_display_event.Add_Dialog_Text("TEXT_RESOURCES_OVERVIEW")
    resource_display_event.Add_Dialog_Text("TEXT_RESOURCES_OVERVIEW_1")
    resource_display_event.Add_Dialog_Text("TEXT_RESOURCES_OVERVIEW_2")
    resource_display_event.Add_Dialog_Text("TEXT_RESOURCES_OVERVIEW_3")
    resource_display_event.Add_Dialog_Text("TEXT_RESOURCES_OVERVIEW_4")
    resource_display_event.Add_Dialog_Text("TEXT_RESOURCES_OVERVIEW_5")
    resource_display_event.Add_Dialog_Text("TEXT_NONE")

    if self.id == "icw" then
        if Find_Player("Empire").Is_Human() or Find_Player("Pentastar").Is_Human() or Find_Player("Eriadu_Authority").Is_Human() or Find_Player("Zsinj_Empire").Is_Human() or Find_Player("Greater_Maldrood").Is_Human() then
            for _, devastator in pairs(self.DevastatorTable) do
                local devastator_object = Find_First_Object(devastator)
                if devastator_object then
                    resource_display_event.Add_Dialog_Text("TEXT_RESOURCES_OVERVIEW_TEMPORARY")
                    resource_display_event.Add_Dialog_Text("TEXT_RESOURCES_OVERVIEW_6")
                    resource_display_event.Add_Dialog_Text("TEXT_NONE")

                    resource_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
                    resource_display_event.Add_Dialog_Text("TEXT_STAT_WORLD_DEVASTATOR_MATERIALS_NAME")
                    resource_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_SEPARATOR_MEDIUM")
                    resource_display_event.Add_Dialog_Text("TEXT_STAT_WORLD_DEVASTATOR_MATERIALS_DESCRIPTION_1")
                    resource_display_event.Add_Dialog_Text("TEXT_STAT_WORLD_DEVASTATOR_MATERIALS_DESCRIPTION_2")
                    resource_display_event.Add_Dialog_Text("TEXT_NONE")

                    resource_display_event.Add_Dialog_Text("Active World Devastator Materials Collected: " .. tostring(GlobalValue.Get(devastator)))
                    resource_display_event.Add_Dialog_Text("TEXT_NONE")
                end
            end
        end
    end

    resource_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_NAME")
    resource_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_SEPARATOR_MEDIUM")
    resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_DESCRIPTION_1") 
    resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_DESCRIPTION_2") 
    resource_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_SCORE", self.InfrastructureScore)
    resource_display_event.Add_Dialog_Text(self.InfrastructureOpenSlotsDisplay)
    resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_EXTENSION", self.extension_bonus)
    resource_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    resource_display_event.Add_Dialog_Text("TEXT_NONE")

    resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_FACTORS")
    resource_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_BASE")
    resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_CONTROL")
    resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_EMPTY_SLOTS")
    resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_FILLED_SLOTS")
    resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_STRUCTURES")
    resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_SHIPYARDS")
    resource_display_event.Add_Dialog_Text("TEXT_NONE")

    resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_EFFECTS")
    resource_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_NEGATIVE_1")
    resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_NEGATIVE_2")
    resource_display_event.Add_Dialog_Text("STAT_INFRASTRUCTURE_POSITIVE")
    resource_display_event.Add_Dialog_Text("TEXT_NONE")

    resource_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    resource_display_event.Add_Dialog_Text("STAT_SHIPCREWS_NAME")
    resource_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_SEPARATOR_MEDIUM")
    resource_display_event.Add_Dialog_Text("STAT_SHIPCREWS_DESCRIPTION")
    resource_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    resource_display_event.Add_Dialog_Text(self.ShipCrewIncomeDisplay)
    resource_display_event.Add_Dialog_Text("TEXT_NONE")
    resource_display_event.Add_Dialog_Text("STAT_SHIPCREWS_INCOME")
    resource_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    resource_display_event.Add_Dialog_Text("STAT_SHIPCREWS_1")
    resource_display_event.Add_Dialog_Text("STAT_SHIPCREWS_2")
    resource_display_event.Add_Dialog_Text("STAT_SHIPCREWS_3")
    resource_display_event.Add_Dialog_Text("STAT_SHIPCREWS_4")
    resource_display_event.Add_Dialog_Text("STAT_SHIPCREWS_5")
    resource_display_event.Add_Dialog_Text("STAT_SHIPCREWS_6")
    resource_display_event.Add_Dialog_Text("TEXT_NONE")
    resource_display_event.Add_Dialog_Text("STAT_SHIPCREWS_7")
    resource_display_event.Add_Dialog_Text("STAT_SHIPCREWS_8")
    resource_display_event.Add_Dialog_Text("STAT_SHIPCREWS_9")
    resource_display_event.Add_Dialog_Text("STAT_SHIPCREWS_10")
    resource_display_event.Add_Dialog_Text("STAT_SHIPCREWS_11")
    
    resource_display_event.Add_Dialog_Text("TEXT_NONE")

    resource_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    resource_display_event.Add_Dialog_Text("STAT_UPKEEP_NAME")
    resource_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_SEPARATOR_MEDIUM")
    resource_display_event.Add_Dialog_Text("STAT_UPKEEP_DESCRIPTION") 
    resource_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    resource_display_event.Add_Dialog_Text("STAT_UPKEEP_TOTAL", self.UpkeepCost)
    resource_display_event.Add_Dialog_Text("STAT_NET_CREDITS", self.NetIncome)
    resource_display_event.Add_Dialog_Text("TEXT_NONE")
    resource_display_event.Add_Dialog_Text("STAT_UPKEEP_FACTORS")
    resource_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    resource_display_event.Add_Dialog_Text("STAT_UPKEEP_1")
    resource_display_event.Add_Dialog_Text("STAT_UPKEEP_2")
    resource_display_event.Add_Dialog_Text("STAT_UPKEEP_3")
    resource_display_event.Add_Dialog_Text("STAT_UPKEEP_4")
    resource_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
    resource_display_event.Add_Dialog_Text("TEXT_NONE")

    if GlobalValue.Get("PATRON_PLAYTHROUGH") == true then

        resource_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        resource_display_event.Add_Dialog_Text("TEXT_NONE")
        resource_display_event.Add_Dialog_Text("TEXT_NONE")
        resource_display_event.Add_Dialog_Text("TEXT_NONE")

        for name, stats in pairs(self.patron_handler.patron_list) do
            if stats.alive == true then
                resource_display_event.Add_Dialog_Text(stats.custom_name .. " | "  .. Find_Object_Type(stats.unit_name).Get_Name())
            end
        end

        resource_display_event.Add_Dialog_Text("TEXT_NONE")
        resource_display_event.Add_Dialog_Text("TEXT_NONE")
        resource_display_event.Add_Dialog_Text("TEXT_NONE")

        for name, stats in pairs(self.patron_handler.patron_list) do
            if stats.alive == false then
                resource_display_event.Add_Dialog_Text(stats.custom_name .. " | ".. Find_Object_Type(stats.unit_name).Get_Name())
            end
        end
    end

    Story_Event("RESOURCE_DISPLAY")
end

return AbstractResourceManager
