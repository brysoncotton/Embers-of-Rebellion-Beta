require("deepcore/std/class")
require("PGSpawnUnits")
require("eawx-util/StoryUtil")

---@class GenericConquer
GenericConquer = class()

function GenericConquer:new(gc, event_name, planet, players, spawn_list, show_holocron, movie_name, unlock_list, lock_list, chained_effect)
    --Logger:trace("entering GenericConquer:new")
    self.is_complete = false
    self.is_active = false
    self.plot = Get_Story_Plot("Conquests\\Events\\EventLogRepository.XML")

    self.Planets = gc.Planets

    self.show_holocron = show_holocron

    if movie_name then
        self.movie_name = movie_name
    else
        self.movie_name = " "
    end

    self.planet_name = planet
    self.planet_object = FindPlanet(planet)

    self.Start_Text = "TEXT_SPEECH_" .. tostring(event_name)

    self.HumanPlayer = Find_Player("local")
    self.ForPlayer = players
    self.ForAnyPlayer = false
    self.ForHumanPlayer = false
    for _, player in pairs(self.ForPlayer) do
        if self.HumanPlayer.Get_Faction_Name() ==  string.upper(player) then
            self.ForHumanPlayer = true
        end
    end  
    if table.getn(self.ForPlayer) == 0 then
        self.ForAnyPlayer = true
        self.ForHumanPlayer = true
    end  

    self.Winner = nil

    self.Story_Tag = event_name

    if unlock_list ~= nil then
        self.Unlock_Types = unlock_list
    end

    if lock_list ~= nil then
        self.Lock_Types = lock_list
    end

    if spawn_list ~=nil then
        self.Spawn_Types = spawn_list
        self.Spawn_Planet = FindPlanet(planet)
    end

    self.Chained_Event = chained_effect

    crossplot:subscribe(self.Story_Tag, self.activate, self)
    crossplot:subscribe(self.Story_Tag.."_FINISHED", self.fulfil, self)
    crossplot:subscribe(self.Story_Tag.."_FAILED", self.fail, self)

    self.planet_owner_changed_event = gc.Events.PlanetOwnerChanged
    self.planet_owner_changed_event:attach_listener(self.planet_owner_changed, self)
end

function GenericConquer:activate()
    --Logger:trace("entering GenericConquer:activate")
    if (self.is_complete == false) and (self.is_active == false) then
        self.is_active = true
        for _, player in pairs(self.ForPlayer) do
            if Find_Player(player) == self.HumanPlayer then
                if self.show_holocron == true then
                    StoryUtil.Multimedia(self.Start_Text.."_STARTED", 15, nil, " ", 0)
                    local plot = self.plot
                    Story_Event(self.Story_Tag.."_STARTED")
                end
            end
        end
    end
end

function GenericConquer:planet_owner_changed(planet, new_owner_name, old_owner_name)
    --Logger:trace("entering GenericConquer:planet_owner_changed")
    if self.is_active == true then
        if planet:get_name() ~= self.planet_name then
            return
        else
            if self.ForAnyPlayer == false then
                local intended_faction = false
                for _, player in pairs(self.ForPlayer) do
                    if new_owner_name == string.upper(player) then
                        self.Winner = Find_Player(player)
                        intended_faction = true
                        self:fulfil()
                    end
                end
                if intended_faction == false then
                    self:fail()
                end
            else
                self.Winner = Find_Player(new_owner_name)
                self:fulfil()
            end
        end
    else
        return
    end
end

function GenericConquer:fulfil()
    --Logger:trace("entering GenericConquer:fulfil")
    if self.is_complete == false then
        self.is_complete = true


        if self.Winner then
            if self.Unlock_Types ~= nil then
                for _, unit in pairs(self.Unlock_Types) do
                    self.Winner.Unlock_Tech(Find_Object_Type(unit))
                end
            end
        
            if self.Lock_Types ~= nil then
                for _, unit in pairs(self.Lock_Types) do
                    self.Winner.Lock_Tech(Find_Object_Type(unit))
                end
            end

            if self.Spawn_Planet ~= nil then

                if not StoryUtil.CheckFriendlyPlanet(self.Spawn_Planet,self.Winner) then
                    self.Spawn_Planet = StoryUtil.FindFriendlyPlanet(self.Winner)
                end
                if self.Spawn_Types ~= nil then
                    local spawn = SpawnList(self.Spawn_Types, self.Spawn_Planet, self.Winner, true, false)
                end 
            end

            if self.is_active == true then
                if self.Winner == self.HumanPlayer then
                    StoryUtil.Multimedia(self.Start_Text.."_FINISHED", 15, nil, self.movie_name, 0)
                    local plot = self.plot
                    Story_Event(self.Story_Tag.."_COMPLETED")
                else
                    if self.ForHumanPlayer == true then
                        self:fail()
                    end
                end
            end

            if self.Chained_Event ~= nil then
                for _, event in pairs(self.Chained_Event) do
                    crossplot:publish(event, "empty")
                end
            end
        end
    end
end

function GenericConquer:fail()
    --Logger:trace("entering GenericConquer:fail")

    if self.is_complete == false then
        self.is_complete = true
        
        if self.is_active == true then
            for _, player in pairs(self.ForPlayer) do
                if Find_Player(player) == self.HumanPlayer then
                    if self.show_holocron == true then

                        StoryUtil.Multimedia(self.Start_Text.."_FAILED", 15, nil, " ", 0)
                        local plot = self.plot
                        Story_Event(self.Story_Tag.."_COMPLETED")
                    end
                end
            end
        end

        self.planet_owner_changed_event:detach_listener(self.planet_owner_changed)

    end

end

return GenericConquer
