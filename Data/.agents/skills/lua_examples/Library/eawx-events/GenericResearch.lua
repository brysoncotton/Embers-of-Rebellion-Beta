require("deepcore/std/class")
require("PGSpawnUnits")
require("eawx-util/StoryUtil")

---@class VenatorResearch
GenericResearch = class()

function GenericResearch:new(gc, event_name, research_dummy, player, unlock_list, lock_list, spawn_list, spawn_planet, chained_effect, required_planet)
    --Logger:trace("entering GenericResearch:new")
    self.is_complete = false
    self.is_active = false
    self.plot = Get_Story_Plot("Conquests\\Events\\EventLogRepository.XML")

    self.research_dummy = Find_Object_Type(research_dummy)

    self.Start_Text = "TEXT_SPEECH_" .. tostring(event_name)

    self.ForPlayers = player
    self.ai_only = true
    self.HumanPlayer = Find_Player("local")

    self.Story_Tag = event_name

    self.Unlock_Types = unlock_list
    self.Lock_Types = lock_list

    self.Spawn_Types = nil
    if spawn_list ~= nil then
        self.Spawn_Types = spawn_list
    end

    self.Spawn_Planet = spawn_planet

    self.Chained_Event = chained_effect

    self.production_finished_event = gc.Events.GalacticProductionFinished
    self.production_finished_event:attach_listener(self.on_production_finished, self)

    if required_planet ~= nil then
        local SafePlanetTable = StoryUtil.GetSafePlanetTable()
        if SafePlanetTable[required_planet] == nil then
            return
        end
    end

    crossplot:subscribe(self.Story_Tag, self.activate, self)
    crossplot:subscribe(self.Story_Tag.."_FINISHED", self.fulfil, self)
end

function GenericResearch:activate()
    --Logger:trace("entering GenericResearch:activate")
    if (self.is_complete == false) and (self.is_active == false) then
        self.is_active = true

        for _,player in pairs(self.ForPlayers) do
            local player_object = Find_Player(player)
            if player_object == self.HumanPlayer then
                self.ai_only = false
                StoryUtil.Multimedia(self.Start_Text, 15, nil, " ", 0)
                local plot = self.plot
                Story_Event(self.Story_Tag.."_STARTED")

                player_object.Unlock_Tech(self.research_dummy)
            end
        end
        if self.ai_only == true then
            self:fulfil()
        end
    end
end

function GenericResearch:on_production_finished(planet, object_type_name)
    --Logger:trace("entering GenericResearch:on_production_finished")
    if object_type_name ~= self.research_dummy.Get_Name() then
        return
    else
        self:fulfil()
    end
end

function GenericResearch:fulfil()
    --Logger:trace("entering GenericResearch:fulfil")
    if self.is_complete == false then
        self.is_complete = true

        for _,player in pairs(self.ForPlayers) do
            local player_object = Find_Player(player)

            if TestValid(self.research_dummy) then
                player_object.Lock_Tech(self.research_dummy)
            end

            if self.Lock_Types ~= nil then
                for _, unit in pairs(self.Lock_Types) do
                    player_object.Lock_Tech(Find_Object_Type(unit))
                end
            end

            if self.Unlock_Types ~= nil then
                for _, unit in pairs(self.Unlock_Types) do
                    player_object.Unlock_Tech(Find_Object_Type(unit))
                end
            end

            if self.Spawn_Planet ~= nil and self.Spawn_Types ~= nil then
                local spawn = StoryUtil.SpawnAtSafePlanet(self.Spawn_Planet, player_object, StoryUtil.GetSafePlanetTable(), self.Spawn_Types, true, false)
            end

            if self.is_active == true then
                if player_object == self.HumanPlayer then
                    if GetCurrentTime() >= 5 then
                        local plot = self.plot
                        Story_Event(self.Story_Tag.."_COMPLETED")
                        StoryUtil.Multimedia(self.Start_Text .. "_FINISHED", 15, nil, " ", 0)

                        local upgrade_object = Find_First_Object(self.research_dummy.Get_Name())
                        if TestValid(upgrade_object) then
                            upgrade_object.Despawn()
                        end
                    end
                end
            end
        end

        if self.Chained_Event ~= nil then
            for _, event in pairs(self.Chained_Event) do
                crossplot:publish(event, "empty")
            end
        end

        self.production_finished_event:detach_listener(self.on_production_finished)
    end
end

return GenericResearch
