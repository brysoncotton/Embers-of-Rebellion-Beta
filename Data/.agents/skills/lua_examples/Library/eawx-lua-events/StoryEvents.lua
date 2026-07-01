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
--*   @Date:                2017-10-05T20:50:45+02:00
--*   @Project:             Imperial Civil War
--*   @Filename:            StoryEvents.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2017-12-21T12:31:50+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************
require("PGCommands")
require("deepcore/std/Observable")

--******************************************************************************
--****************************     Event Builder     ***************************
--******************************************************************************

FunctionObservable =
    Class {
    Extends = Observable,
    Constructor = function(self, func)
        self.func = func
    end,
    evaluate = function(self)
        if self.func() then
            self:notify()
            return true
        end
        return false
    end
}

EventTypeObservable =
    Class {
    Extends = Observable,
    Constructor = function(self, eventType)
        self.eventType = eventType
    end,
    evaluate = function(self)
        if self.eventType:evaluate() then
            self:notify()
            return true
        end
        return false
    end
}

function Event(id)
    return {
        id = id,
        When = function(self, event)
            local observable = nil
            if type(event) == "function" then
                observable = FunctionObservable:New(event)
            elseif type(event) == "table" then
                observable = EventTypeObservable:New(event)
            else
                return nil
            end
            self.event = {
                id = self.id,
                event = observable,
                branch = nil,
                repeatable = false,
                prereqs = nil,
                concluded = false,
                enabled = true
            }
            return self
        end,
        After = function(self, prereq)
            self.event.prereqs = prereq
            return self
        end,
        InBranch = function(self, branch)
            self.event.branch = branch
            return self
        end,
        Repeatable = function(self, bool)
            self.event.repeatable = bool
            return self
        end,
        End = function(self)
            StoryEventManager:RegisterEvent(self.event)
        end,
        Subscribe = function(self, reward)
            local event = StoryEventManager.allEvents[self.id]
            if type(reward) == "function" then
                event.reward = {
                    execute = reward
                }
            elseif type(reward) == "table" then
                event.reward = reward
            end
        end
    }
end

--******************************************************************************
--*****************************     Event Types     ****************************
--******************************************************************************

function Always()
    return {
        evaluate = function(self)
            return true
        end
    }
end

function GameObject(object)
    return {
        reward = nil,
        object = object,
        FirstIsAlive = function(self)
            self.reward = {
                object = self.object,
                evaluate = function(self)
                    return Find_First_Object(self.object) ~= nil
                end
            }
            return self
        end,
        FirstIsDead = function(self)
            self.reward = {
                object = self.object,
                evaluate = function(self)
                    return Find_First_Object(self.object) == nil
                end
            }
            return self
        end,
        IsOnPlanet = function(self, planet)
            self.reward = {
                object = self.object,
                planet = FindPlanet(planet),
                evaluate = function(self)
                    return self.object.Get_Planet_Location() == self.planet
                end
            }
            return self
        end,
        End = function(self)
            return self.reward
        end
    }
end

function Faction(player)
    return {
        reward = nil,
        player = Find_Player(player),
        IsOnTechLevel = function(self, level)
            self.reward = {
                player = self.player,
                level = level,
                evaluate = function(self)
                    return self.player.Get_Tech_Level() == self.level
                end
            }
            return self
        end,
        Owns = function(self, planet)
            self.reward = {
                player = self.player,
                planet = FindPlanet(planet),
                evaluate = function(self)
                    return self.planet.Get_Owner() == self.player
                end
            }
            return self
        end,
        End = function(self)
            return self.reward
        end
    }
end

function Never()
    return {
        evaluate = function(self)
            return false
        end
    }
end

function Planet(planet)
    return {
        reward = nil,
        planet = FindPlanet(planet),
        HasStructure = function(self, structure)
            self.reward = {
                planet = self.planet,
                structureString = structure,
                evaluate = function(self)
                    local structures = Find_All_Objects_Of_Type(self.structureString)
                    for i, struc in pairs(structures) do
                        if struc.Get_Planet_Location() == self.planet then
                            return true
                        end
                    end
                    return false
                end
            }
            return self
        end,
        OwnerChanged = function(self, player)
            self.reward = {
                originalOwner = self.planet.Get_Owner(),
                planet = self.planet,
                player = player,
                evaluate = function(self)
                    if self.planet.Get_Owner() ~= self.originalOwner then
                        self.originalOwner = self.planet.Get_Owner()
                        if self.player then
                            return self.planet.Get_Owner() == Find_Player(self.player)
                        end
                        return true
                    end
                    return false
                end
            }
            return self
        end,
        End = function(self)
            return self.reward
        end
    }
end

function StoryElapsed(time)
    return {
        time = time,
        lastTime = nil,
        evaluate = function(self)
            local currentTime = GetCurrentTime()
            if not self.lastTime then
                self.lastTime = currentTime
            end

            if currentTime - self.lastTime >= self.time then
                return true
            end

            return false
        end
    }
end

function StoryFlag(id)
    return {
        reward = {
            player = nil,
            id = id,
            evaluate = function(self)
                return Check_Story_Flag(self.player, self.id, nil, true)
            end
        },
        ForPlayer = function(self, player)
            self.reward.player = Find_Player(player)
            return self
        end,
        End = function(self)
            return self.reward
        end
    }
end

--******************************************************************************
--****************************     Reward Types     ****************************
--******************************************************************************

function BuildableUnit(unitTypeString)
    return {
        typeString = unitTypeString,
        execute = function(self)
            require("eawx-util/StoryUtil")
            StoryUtil.BuildableUnit(self.typeString)
        end
    }
end

function ChangePlanetOwner(planet)
    return {
        reward = {
            planet = FindPlanet(planet),
            player = nil,
            retreat = false,
            execute = function(self)
                if self.retreat then
                    require("eawx-util/ChangeOwnerUtilities")
                    ChangePlanetOwnerAndRetreat(self.planet, self.player)
                    return
                end
                self.planet.Change_Owner(self.player)
            end
        },
        ToPlayer = function(self, player)
            self.reward.player = Find_Player(player)
            return self
        end,
        WithRetreat = function(self)
            self.reward.retreat = true
            return self
        end,
        End = function(self)
            return self.reward
        end
    }
end

function CompositeReward(first)
    return {
        reward = {
            rewards = {first},
            execute = function(self)
                for _, reward in pairs(self.rewards) do
                    reward:execute()
                end
            end
        },
        And = function(self, next)
            table.insert(self.reward.rewards, next)
            return self
        end,
        End = function(self)
            return self.reward
        end
    }
end

function DespawnHero(hero)
    return {
        hero = hero,
        execute = function(self)
            require("eawx-util/StoryUtil")
            local event = StoryUtil.GetGenericEvent()
            event.Set_Reward_Type("REMOVE_UNIT")
            event.Set_Reward_Parameter(0, self.hero)
            StoryUtil.TriggerGenericEvent()
            StoryUtil.ResetGenericEvent()
        end
    }
end

function KillFirstObject(objectType)
    return {
        typeString = objectType,
        execute = function(self)
            local obj = Find_First_Object(self.typeString)
            if not TestValid(obj) then
                obj = Find_All_Objects_Of_Type(self.typeString)[1]
                if TestValid(obj) then
                    if obj.Is_Category("Fighter") or obj.Is_Category("Bomber") then
                        obj = obj.Get_Parent_Object()
                    end
                end

                if not TestValid(obj) then
                    return
                end
            end

            obj.Despawn()
        end
    }
end

function LockUnit(unitTypeString)
    return {
        typeString = unitTypeString,
        execute = function(self)
            require("eawx-util/StoryUtil")
            StoryUtil.LockUnit(self.typeString)
        end
    }
end

function SetBranch(branch)
    return {
        reward = {
            branch = branch,
            storyEventManager = nil,
            active = nil,
            execute = function(self)
                self.storyEventManager:SetBranchActive(self.branch, self.active)
            end
        },
        InEventManager = function(self, storyEventManager)
            self.reward.storyEventManager = storyEventManager
            return self
        end,
        Enabled = function(self)
            self.reward.active = true
            return self
        end,
        Disabled = function(self)
            self.reward.active = false
            return self
        end,
        End = function(self)
            return self.reward
        end
    }
end

function SetEvent(event)
    return {
        reward = {
            event = event,
            storyEventManager = nil,
            active = nil,
            execute = function(self)
                self.storyEventManager:SetEventActive(self.event, self.active)
            end
        },
        InEventManager = function(self, storyEventManager)
            self.reward.storyEventManager = storyEventManager
            return self
        end,
        Enabled = function(self)
            self.reward.active = true
            return self
        end,
        Disabled = function(self)
            self.reward.active = false
            return self
        end,
        End = function(self)
            return self.reward
        end
    }
end

function SetTechLevel(level)
    return {
        reward = {
            level = level,
            player = nil,
            execute = function(self)
                require("eawx-util/StoryUtil")
                local event = StoryUtil.GetGenericEvent()
                event.Set_Reward_Type("SET_TECH_LEVEL")
                event.Set_Reward_Parameter(0, self.player)
                event.Set_Reward_Parameter(1, level)
                StoryUtil.TriggerGenericEvent()
                StoryUtil.ResetGenericEvent()
            end
        },
        ForPlayer = function(self, player)
            self.reward.player = player
            return self
        end,
        End = function(self)
            return self.reward
        end
    }
end

function SpawnUnits(units)
    return {
        reward = {
            units = units,
            location = nil,
            player = nil,
            withFallback = false,
            onlyFriendy = false,
            execute = function(self)
                if not self.player then
                    return
                end

                self.location = self:determineLocation()

                if not self.location then
                    return
                end

                for _, unit in pairs(self.units) do
                    local objectType = Find_Object_Type(unit)
                    if objectType then
                        Spawn_Unit(objectType, self.location, self.player)
                    end
                end
            end,
            determineLocation = function(self)
                if self.onlyFriendly then
                    if not self.location.Get_Owner() == self.player then
                        return nil
                    end
                end

                if not self.withFallback then
                    return self.location
                end

                if not self.location or self.location.Get_Owner() ~= self.player then
                    require("eawx-util/StoryUtil")
                    return StoryUtil.FindFriendlyPlanet(self.player)
                end

                return self.location
            end
        },
        OnPlanet = function(self, planet)
            self.reward.location = FindPlanet(planet)
            return self
        end,
        ForPlayer = function(self, player)
            self.reward.player = Find_Player(player)
            return self
        end,
        OnlyWhenFriendly = function(self)
            self.reward.onlyFriendy = true
            return self
        end,
        WithFallback = function(self)
            self.reward.withFallback = true
            return self
        end,
        End = function(self)
            return self.reward
        end
    }
end

function TriggerXmlEvent(notification)
    return {
        notification = notification,
        execute = function(self)
            Story_Event(self.notification)
        end
    }
end

-- function ScreenText(textId, time, var, color)
--     return {
--         textId = textId,
--         var = var,
--         color = color,
--         execute = function(self)
--             GLOBALS.ShowScreenText(textId, var, color)
--         end
--     }
-- end

--******************************************************************************
--************************     Conditional Rewards     *************************
--******************************************************************************

function If(eventType)
    return {
        reward = {
            eventType = eventType,
            thenReward = nil,
            elseReward = nil,
            execute = function(self)
                if self.eventType:evaluate() then
                    self.thenReward:execute()
                elseif self.elseReward then
                    self.elseReward:execute()
                end
            end
        },
        Then = function(self, reward)
            self.reward.thenReward = reward
            return self
        end,
        Else = function(self, reward)
            self.reward.elseReward = reward
            return self
        end,
        End = function(self)
            return self.reward
        end
    }
end
