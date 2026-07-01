require("deepcore/std/class")
require("deepcore/crossplot/crossplot")
require("eawx-util/PopulatePlanetUtilities")
require("PGStoryMode")
require("eawx-util/StoryUtil")
require("eawx-util/UnitUtil")

---@class GovernmentFavour
GovernmentFavour = class()

function GovernmentFavour:new(gc, gc_name)
    self.gc_name = gc_name

    self.human_player = Find_Player("local")

    self.FavourTables = require("FavourRewards")

    gc.Events.GalacticProductionFinished:attach_listener(self.on_production_finished, self)
    gc.Events.GalacticProductionStarted:attach_listener(self.on_production_queued, self)
    gc.Events.GalacticProductionCanceled:attach_listener(self.on_production_canceled, self)
    gc.Events.PlanetOwnerChanged:attach_listener(self.on_planet_owner_changed, self)

    crossplot:subscribe("INCREASE_FAVOUR", self.AdjustFavour, self)
    crossplot:subscribe("FAVOUR_REWARD_SPAWNED", self.MarkFavourRewardSpawned, self)

    self.Events = {}
    self.Events.SupportReached = Observable()

    for faction, tables in pairs(self.FavourTables) do
        for group, data in pairs(tables) do
            self:RewardLocks(faction, group)
        end
    end

    --FOTR: in Foerost GC, disable Republic integration of Sector Forces planets
    if self.gc_name == "FOEROST" then
        self.FavourTables["EMPIRE"]["SECTOR_FORCES"].integrates = false
    end
end

function GovernmentFavour:update()
    --Logger:trace("entering GovernmentFavour:Update")

    for faction, tables in pairs(self.FavourTables) do
        for group, data in pairs(tables) do
            if data.cycle_increase ~= 0 then
                self:AdjustFavour(group, data.cycle_increase)
                self:RewardLocks(faction, group)
            end
            if data.integrates == true then
                if data.integration_data.integrating == true then
                    self:Absorb_Planet(faction, group)
                end
            end
        end
    end
end

function GovernmentFavour:Absorb_Planet(controlling_faction, group_name)
    --Logger:trace("entering GovernmentFavour:Absorb_Planet")

    local group_faction = Find_Player(group_name)
    local faction_owned_planets = EvaluatePerception("Planet_Ownership", group_faction)

    if faction_owned_planets >= 1 then
        for _, planet in pairs(FindPlanet.Get_All_Planets()) do
            if planet.Get_Owner() == group_faction and StoryUtil.CheckPlanetRestricted(planet.Get_Type().Get_Name()) == false then
                ChangePlanetOwnerAndReplace(planet, self.FavourTables[controlling_faction][group_name].faction,1)
                break
            end
        end
    end

    if faction_owned_planets <= 1 then
        Transfer_All_Units(group_faction,self.FavourTables[controlling_faction][group_name].faction)
        self:set_group_integrated(controlling_faction, group_name)
    end
end

function GovernmentFavour:set_group_integrated(controlling_faction, group_name)
    if self.FavourTables[controlling_faction][group_name].integration_data.integrating == true then
        self.FavourTables[controlling_faction][group_name].integration_data.integrating = false 
        self.FavourTables[controlling_faction][group_name].integration_data.integrated = true
    end
end

function GovernmentFavour:RewardLocks(owner, group, show_text)
    --Logger:trace("entering GovernmentFavour:RewardLocks")
    if self.FavourTables[owner][group] then
        for i, unit in pairs(self.FavourTables[owner][group].reward_list) do
            if self.FavourTables[owner][group].favour < unit.threshold then
                self.FavourTables[owner][group].reward_list[i].buildable = false
            else
                if unit.limit > 0 and (unit.built + unit.building) >= unit.limit then
                    self.FavourTables[owner][group].reward_list[i].buildable = false
                else
                    if self.FavourTables[owner][group].faction == self.human_player and self.FavourTables[owner][group].reward_list[i].buildable == false then
                        if unit.text ~= nil and show_text ~= false then
                            self.Events.SupportReached:notify {
                                added = unit.text
                            }
                        end
                    end
                end
                self.FavourTables[owner][group].reward_list[i].buildable = true
            end
            UnitUtil.SetBuildable(self.FavourTables[owner][group].faction, unit.unit, unit.buildable)
            crossplot:publish("UPDATE_AVAILABILITY", "empty")
            if unit.locks == true then
                -- Some rewards remain visible, so don't lock, only set unbuildable.
                UnitUtil.SetLockList(self.FavourTables[owner][group].faction_name, {unit.unit}, unit.buildable)
            end
        end
    end
end

function GovernmentFavour:RewardSpawns(owner, group)
    --Logger:trace("entering GovernmentFavour:RewardSpawns")
    for reward, reward_data in pairs(self.FavourTables[owner][group].spawned_rewards) do
        if self.FavourTables[owner][group].favour >= reward_data.threshold and reward_data.spawned == false then
            self.FavourTables[owner][group].spawned_rewards[reward].spawned = true
            if StoryUtil.SpawnAtSafePlanet(nil,self.FavourTables[owner][group].faction,{},{reward},true,false) then
                if self.FavourTables[owner][group].faction == self.human_player then
                    if self.FavourTables[owner][group].spawned_rewards[reward].text ~= nil then
                        self.Events.SupportReached:notify {
                            added = self.FavourTables[owner][group].spawned_rewards[reward].text
                        }
                    end
                end
            end
        end
    end
end

function GovernmentFavour:RewardCrossplots(owner, group)
    --Logger:trace("entering GovernmentFavour:RewardCrossplots")
    for reward, reward_data in pairs(self.FavourTables[owner][group].crossplot_rewards) do
        if self.FavourTables[owner][group].favour >= reward_data.threshold and reward_data.triggered == false then
            self.FavourTables[owner][group].crossplot_rewards[reward].triggered = true
            --if self.FavourTables[owner][group].crossplot_rewards[reward].crossplot ~= nil then
                crossplot:publish(self.FavourTables[owner][group].crossplot_rewards[reward].crossplot, "empty")
            --end
            if self.FavourTables[owner][group].faction == self.human_player then
                if self.FavourTables[owner][group].crossplot_rewards[reward].text ~= nil then
                    self.Events.SupportReached:notify {
                        added = self.FavourTables[owner][group].crossplot_rewards[reward].text
                    }
                end
            end
        end
    end
end

function GovernmentFavour:on_production_finished(planet, game_object_type_name)
    -- DebugMessage("In GovernmentFavour:on_production_finished")
    --Logger:trace("entering GovernmentFavour:on_production_finished")
    local owner = planet:get_owner().Get_Faction_Name()
    if self.FavourTables[owner] then
        for group, data in pairs(self.FavourTables[owner]) do
            if planet:get_owner() == data.faction then
                for i, unit in pairs(data.reward_list) do
                    if unit.unit == game_object_type_name then
                        self.FavourTables[owner][group].reward_list[i].built = self.FavourTables[owner][group].reward_list[i].built + 1
                        self.FavourTables[owner][group].reward_list[i].building = self.FavourTables[owner][group].reward_list[i].building - 1
                    end
                end
                local favour_adjustment = 0
                if data.support_structures_perception then
                    favour_adjustment = EvaluatePerception(data.support_structures_perception, data.faction, planet:get_game_object())
                end
                for i, support_object in pairs(data.support_buildables) do
                    if support_object.name == game_object_type_name then
                        favour_adjustment = favour_adjustment + support_object.value
                    end
                end
                if favour_adjustment ~= 0 then
                    self:AdjustFavour(group, favour_adjustment)
                end
            end
        end
    end
end

function GovernmentFavour:on_production_queued(planet, game_object_type_name)
    -- DebugMessage("In GovernmentFavour:on_production_queued")
    local multiplier = -1
    self:UnitFavourAdjustments(planet, game_object_type_name, multiplier, false)
end

function GovernmentFavour:on_production_canceled(planet, game_object_type_name)
    -- DebugMessage("In GovernmentFavour:on_production_canceled")
    --Logger:trace("entering GovernmentFavour:on_production_canceled")
    local multiplier = 1
    self:UnitFavourAdjustments(planet, game_object_type_name, multiplier, false)
end

function GovernmentFavour:on_planet_owner_changed(planet, new_owner_name, old_owner_name)
    --Logger:trace("entering GovernmentRepublic:ApprovalRating")
    if self.FavourTables[new_owner_name] then
        for group, data in pairs(self.FavourTables[new_owner_name]) do
            if group ~= old_owner_name then
                if data.increase_on_capture > 0 then
                    self:AdjustFavour(group, data.increase_on_capture, false)
                end
            end
        end
    end

    if self.FavourTables[old_owner_name] then
        for group, data in pairs(self.FavourTables[old_owner_name]) do
            if data.decrease_on_loss then
                if data.decrease_on_loss > 0 then
                    self:AdjustFavour(group, -data.decrease_on_loss, false)
                end
            end
        end
    end
end

function GovernmentFavour:UnitFavourAdjustments(planet, game_object_type_name, multiplier, show_text)
    -- DebugMessage("In GovernmentFavour:UnitFavourAdjustments")
    --Logger:trace("entering GovernmentFavour:UnitFavourAdjustments")
    local owner = planet:get_owner().Get_Faction_Name()
    if self.FavourTables[owner] then
        for group, data in pairs(self.FavourTables[owner]) do
            for i, unit in pairs(data.reward_list) do
                if unit.unit == game_object_type_name then
                    self.FavourTables[owner][group].reward_list[i].building = self.FavourTables[owner][group].reward_list[i].building + (-1 * multiplier)
                    local favour_adjustment = 0
                    if unit.remove_cost == true then
                        favour_adjustment = (multiplier * unit.threshold)
                    end
                    self:AdjustFavour(group, favour_adjustment, nil, show_text)
                end
            end
        end
    end
end

function GovernmentFavour:AdjustFavour(tag, amount, integrate_planet, show_text)
    -- DebugMessage("In GovernmentFavour:AdjustFavour")
    --Logger:trace("entering GovernmentFavour:AdjustFavour")
    for faction, tables in pairs(self.FavourTables) do
        for group, data in pairs(tables) do
            if tag == group then
                local old_favour = self.FavourTables[faction][group].favour
                local max_favour = self.FavourTables[faction][group].max_value

                if old_favour == data.max_value then
                    break
                end

                if old_favour == 0 and amount < 0 then
                    break
                end

                local new_favour = old_favour + amount

                if new_favour < 0 then
                    self.FavourTables[faction][group].favour = 0
                    new_favour = 0
                elseif new_favour > max_favour and max_favour > 0 then
                    self.FavourTables[faction][group].favour = max_favour
                    new_favour = max_favour
                else
                    self.FavourTables[faction][group].favour = new_favour
                end

                if old_favour ~= new_favour then
                    if new_favour >= max_favour then
                       if data.max_crossplot ~= nil then
                            crossplot:publish(data.max_crossplot, "empty")
                       end
                    end
                    if amount < 0 and data.reduction_speech ~= nil then
                        StoryUtil.Multimedia(data.reduction_speech, 15, nil, data.leader_holo, 0)
                    end

                    if integrate_planet ~= false and amount > 0 and data.integrates == true then
                        if new_favour >= max_favour
                            and self.FavourTables[faction][group].integration_data.integrated == false
                            and self.FavourTables[faction][group].integration_data.integrating == false then
                            if data.faction.Is_Human() and data.integration_data.integration_speech then
                                StoryUtil.Multimedia(self.FavourTables[faction][group].integration_data.integration_speech, 15, nil, self.FavourTables[faction][group].leader_holo, 0)
                            end
                            self.FavourTables[faction][group].integration_data.integrating = true

                            for i, unit in pairs(data.support_buildables) do
                                if unit.locks == true then
                                    UnitUtil.SetLockList(data.faction_name, {unit.name}, false)
                                end
                            end
                        end

                        if GetCurrentTime() > 10 then
                            self:Absorb_Planet(faction, group)
                        end
                    end

                    self:RewardLocks(faction, group, show_text)
                    self:RewardSpawns(faction, group)
                    self:RewardCrossplots(faction, group)
                end
                break
            end
        end
    end
end

function GovernmentFavour:MarkFavourRewardSpawned(unit_name,owner_name)
    --Logger:trace("entering GovernmentFavour:MarkFavourRewardSpawned")
    for group,data in pairs(self.FavourTables[owner_name]) do
        for reward_name,_ in pairs(data.spawned_rewards) do
            if reward_name == unit_name then
                self.FavourTables[owner_name][group].spawned_rewards[reward_name].spawned = true
                break
            end
        end
    end
end

return GovernmentFavour
