require("deepcore/std/class")
require("eawx-util/GalacticUtil")

---@class KeyDummyLifeCycleHandler
KeyDummyLifeCycleHandler = class()

---@param planets table<string, Planet>
---@param planet_owner_changed_event PlanetOwnerChangedEvent
---@param interval number
function KeyDummyLifeCycleHandler:new(planets, planet_owner_changed_event, interval)
    planet_owner_changed_event:attach_listener(self.on_planet_owner_changed, self)

    ---@private
    ---@type function[]
    self.key_functions = {}
    self:add_key_provider_function(
        function(planet)
            local is_human = planet:get_owner().Is_Human()
            if is_human then
                return "HUMAN_PLANET"
            elseif planet:get_owner() == Find_Player("Neutral") then
                return "NEUTRAL_PLANET"
            else
                return "AI_PLANET"
            end
        end
    )

    self:add_key_provider_function(
        function(planet)
            return planet:get_owner()
        end
    )

    self:add_key_provider_function(
        function(planet)
            return planet
        end
    )

    ---@private
    self.key_table = {}

    ---@private
    self.changed_keys_for_current_cycle = {}

    ---@private
    self.changed_keys_for_next_cycle = {}

    ---@private
    ---@type table<Planet, table<any, boolean>>
    self.current_applied_keys_per_planet = {}

    ---@private
    self.number_of_planets = 0
    for _, planet in pairs(planets) do
        self.number_of_planets = self.number_of_planets + 1
        self.current_applied_keys_per_planet[planet] = {}
    end

    ---@private
    self.planet_cycle_index = 0

    ---@private
    self.interval = 10

    ---@private
    self.last_update = nil
end

---@param key_function function
function KeyDummyLifeCycleHandler:add_key_provider_function(key_function)
    table.insert(self.key_functions, key_function)
end

---@param key any
---@param new_dummy_entries table<string, number>
function KeyDummyLifeCycleHandler:add_to_dummy_set(key, new_dummy_entries)
    --Logger:trace("entering KeyDummyLifeCycleHandler:add_to_dummy_set")
    if not self.key_table[key] then
        self:add_new_key(key)
    end

    local key_data = self.key_table[key]
    local dummy_set = key_data.dummy_set
    for dummy_name, amount in pairs(new_dummy_entries) do
        if not dummy_set[dummy_name] then
            dummy_set[dummy_name] = 0
        end

        dummy_set[dummy_name] = dummy_set[dummy_name] + amount
    end

    self.changed_keys_for_next_cycle[key] = true
end

---@param key any
---@param dummy_entries_to_remove table<string, number>
function KeyDummyLifeCycleHandler:remove_from_dummy_set(key, dummy_entries_to_remove)
    --Logger:trace("entering KeyDummyLifeCycleHandler:remove_from_dummy_set")
    local key_data = self.key_table[key]
    if not key_data then
        DebugMessage(
            "KeyDummyLifeCycleHandler::remove_from_dummy_set -- No new entry for key %s. Aborting.",
            tostring(key)
        )
        return
    end

    local dummy_set = key_data.dummy_set
    for dummy_name, amount in pairs(dummy_entries_to_remove) do
        if dummy_set[dummy_name] then
            dummy_set[dummy_name] = dummy_set[dummy_name] - amount

            if dummy_set[dummy_name] <= 0 then
                dummy_set[dummy_name] = nil
            end
        end
    end

    self.changed_keys_for_next_cycle[key] = true
end

---@param planet Planet
function KeyDummyLifeCycleHandler:update(planet)
    if not self:should_update() then
        return
    end

    if self.planet_cycle_index == 0 then
        self.changed_keys_for_current_cycle = self.changed_keys_for_next_cycle
        self.changed_keys_for_next_cycle = {}
    end

    self.planet_cycle_index = self.planet_cycle_index + 1

    local invalid_keys_for_next_cycle = self.current_applied_keys_per_planet[planet]
    self.current_applied_keys_per_planet[planet] = {}

    for _, key_function in ipairs(self.key_functions) do
        local key = key_function(planet)
        local key_data = self.key_table[key]
        if key_data then
            invalid_keys_for_next_cycle[key] = nil
            self.current_applied_keys_per_planet[planet][key] = true
            self:handle_respawn(planet, key)
        end
    end

    for key, _ in pairs(invalid_keys_for_next_cycle) do
        DebugMessage(
            "KeyDummyLifeCycleHandler::update -- Key %s for planet %s no longer valid for next cycle, clearing dummies",
            tostring(key),
            tostring(planet:get_name())
        )
        self:clear_dummies(self.key_table[key].planet_dummy_objects, planet)
    end

    if self.planet_cycle_index == self.number_of_planets then
        self.last_update = GetCurrentTime()
        self.planet_cycle_index = 0
    end
end

---@private
function KeyDummyLifeCycleHandler:should_update()
    return not self.last_update or GetCurrentTime() - self.last_update > self.interval
end

---@private
function KeyDummyLifeCycleHandler:handle_respawn(planet, key)
    if not key then
        DebugMessage("KeyDummyLifeCycleHandler::handle_respawn -- key is nil. Aborting.")
        return
    end
    --Logger:trace("entering KeyDummyLifeCycleHandler:handle_respawn")
    local key_data = self.key_table[key]

    if not key_data.planet_dummy_objects[planet] then
        key_data.planet_dummy_objects[planet] = {}
    end

    local dummy_object_table = key_data.planet_dummy_objects
    local dummy_set = key_data.dummy_set
    if self.changed_keys_for_current_cycle[key] then
        self:force_respawn_dummies(dummy_object_table, dummy_set, planet)
    else
        self:spawn_dummies_when_missing(dummy_object_table, dummy_set, planet)
    end
end

---@private
---@param planet Planet
---@param new_owner_name string
---@param old_owner_name string
function KeyDummyLifeCycleHandler:on_planet_owner_changed(planet, new_owner_name, old_owner_name)
    if not planet then
        return
    end
    --Logger:trace("entering KeyDummyLifeCycleHandler:on_planet_owner_changed")
    for key, _ in pairs(self.current_applied_keys_per_planet[planet]) do
        local key_data = self.key_table[key]
        if key_data.planet_dummy_objects[planet] then
            DebugMessage(
                "KeyDummyLifeCycleHandler::on_planet_owner_changed --  About to clear dummies on planet %s.",
                tostring(planet:get_name())
            )
            self:clear_dummies(key_data.planet_dummy_objects, planet)
        end
    end

    self.current_applied_keys_per_planet[planet] = {}

    for _, key_function in ipairs(self.key_functions) do
        local key = key_function(planet)
        local key_data = self.key_table[key]
        if key_data then
            self.current_applied_keys_per_planet[planet][key] = true
            key_data.planet_dummy_objects[planet] = self:spawn_dummies_on_planet(planet, self.key_table[key].dummy_set)
        end
    end
end

function KeyDummyLifeCycleHandler:add_new_key(key)
    DebugMessage("KeyDummyLifeCycleHandler -- Adding new entry for key %s.", tostring(key))

    self.key_table[key] = {
        dummy_set = {},
        planet_dummy_objects = {}
    }
end

---@private
---@param dummy_object_table table<Planet, GameObjectWrapper[]>
---@param dummy_set table<string, number>
---@param planet Planet
function KeyDummyLifeCycleHandler:force_respawn_dummies(dummy_object_table, dummy_set, planet)
    if not (dummy_object_table and dummy_set) then
        DebugMessage(
            "KeyDummyLifeCycleHandler::force_respawn_dummies -- Got nil argument. dummy_object_table: %s ; dummy_set: %s",
            tostring(dummy_object_table),
            tostring(dummy_set)
        )
        return
    end
    --Logger:trace("entering KeyDummyLifeCycleHandler:force_respawn_dummies")
    DebugMessage(
        "KeyDummyLifeCycleHandler::force_respawn_dummies -- force respawning dummies on planet %s",
        tostring(planet:get_name())
    )
    self:clear_dummies(dummy_object_table, planet)
    dummy_object_table[planet] = self:spawn_dummies_on_planet(planet, dummy_set)
end

---@private
---@param dummy_object_table table<Planet, GameObjectWrapper[]>
---@param planet Planet
function KeyDummyLifeCycleHandler:clear_dummies(dummy_object_table, planet)
    --Logger:trace("entering KeyDummyLifeCycleHandler:clear_dummies")
    for _, dummy in pairs(dummy_object_table[planet]) do
        if TestValid(dummy) then
            dummy.Despawn()
        end
    end

    dummy_object_table[planet] = {}
end

---@private
---@param dummy_object_table table<Planet, GameObjectWrapper[]>
---@param dummy_set table<string, number>
---@param planet Planet
function KeyDummyLifeCycleHandler:spawn_dummies_when_missing(dummy_object_table, dummy_set, planet)
    if not (dummy_object_table and dummy_set) then
        return
    end
    --Logger:trace("entering KeyDummyLifeCycleHandler:spawn_dummies_when_missing")
    local dummies_on_planet = dummy_object_table[planet]
    self:remove_invalid_entries(dummies_on_planet)

    if table.getn(dummies_on_planet) > 0 then
        return
    end

    DebugMessage("KeyDummyLifeCycleHandler -- respawning missing dummies on planet %s", tostring(planet:get_name()))
    dummy_object_table[planet] = self:spawn_dummies_on_planet(planet, dummy_set)
end

---@private
function KeyDummyLifeCycleHandler:remove_invalid_entries(tab)
    for i, object in pairs(tab) do
        if not TestValid(object) then
            table.remove(tab, i)
        end
    end
end

---@private
---@param planet Planet
function KeyDummyLifeCycleHandler:spawn_dummies_on_planet(planet, dummy_set)
    --Logger:trace("entering KeyDummyLifeCycleHandler:spawn_dummies_on_planet")
    local units =
        GalacticUtil.spawn {
        location = planet:get_name(),
        objects = dummy_set,
        owner = planet:get_owner().Get_Faction_Name()
    }

    return units
end
