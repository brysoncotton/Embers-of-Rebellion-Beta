require("deepcore/std/class")
require("PGStateMachine")
require("PGSpawnUnits")
require("eawx-util/StoryUtil")

---@class GroupSpawn
GroupSpawn = class()

function GroupSpawn:new(unit_entry)
    self.is_active = true

    ---@private
    self.unit_entry = unit_entry

    Object.Prevent_AI_Usage(true)
    Object.Set_Selectable(false)
    Object.Make_Invulnerable(true)
	
	-- wait for hyperspace
	Sleep(5)

    self.location = Object.Get_Position()

    self.attrition_rate = 0.4

    ---@private
    self.object_name = Object.Get_Type().Get_Name()

    ---@private
    self.spawn_data = unit_entry.Spawn_Units

    ---@private
    ---@type PlayerObject
    self.original_owner = Object.Get_Owner()

    ---@private
    self.spawned_units = self:get_initial_group(self.spawn_data, self.original_owner) or {}
    self.total_spawned_units = table.getn(self.spawned_units)

    for i, data in pairs(self.spawned_units) do
        if not data.UnitType or not TestValid(data.UnitType) then
            self.spawn({self, data})
        end
    end

    Object.Teleport(Create_Position(-40000,-40000,0))
end

function GroupSpawn:update()
    if not self.is_active then
        return
    end

    self:check_group()
end

---@private
function GroupSpawn:check_group()
    local active_units = 0
    for i, data in pairs(self.spawned_units) do
        if not data.UnitType or not TestValid(data.UnitType) then
            table.remove(self.spawned_units, i)
        else
            active_units = active_units +1
        end
    end
    if active_units / self.total_spawned_units <= self.attrition_rate then
        Object.Take_Damage(10000)
    end
end

---@private
function GroupSpawn:get_initial_group(group_data, original_owner)
    local initial_spawns = {}

    for type_string, tab in pairs(group_data) do
        local entry = self:get_spawn_entry(tab)
        if entry then
			local type_string_new = type_string
            local unitType = Find_Object_Type(type_string_new)
            entry.Reserve = entry.Reserve + entry.Initial
            for i = 1, entry.Initial do
                table.insert(initial_spawns, {UnitType = nil, ObjectType = unitType, TypeString = type_string_new, RefString = type_string})
            end
        end
    end

    return initial_spawns
end

function GroupSpawn:get_spawn_entry(tab)
    local owner = self.original_owner
    local ownerName = owner.Get_Faction_Name()
    local gameConstants = ModContentLoader.get("GameConstants")
    local alias = gameConstants.ALIASES[ownerName]

    local spawn_tab
    if tab[ownerName] then
        spawn_tab = tab[ownerName]
    elseif alias and tab[alias] then
        spawn_tab = tab[alias]
    elseif tab["DEFAULT"] then
        spawn_tab = tab["DEFAULT"]
    else
        return nil
    end

    return spawn_tab
end

---@private
function GroupSpawn.spawn(wrapper)
    local self = wrapper[1]
    local data = wrapper[2]
    local objectType = data.ObjectType
	local RefString = data.RefString
	local TypeString = data.TypeString
    local tab = self.spawn_data[data.RefString]
    local entry = self:get_spawn_entry(tab)

     if not entry then
        DebugMessage(
            "Could not find Group Entry for %s on Spawner %s",
            tostring(objectType.Get_Name()),
            tostring(self.object_name)
        )
        return
    end

    if entry.Reserve > 0 then
        Object.Prevent_AI_Usage(true)
        Object.Make_Invulnerable(true)
        Object.Set_Selectable(false)
		local unitType = Find_Object_Type(TypeString)
        local group = Spawn_Unit(unitType, self.location, Object.Get_Owner(), true, false)[1]
		
        data.UnitType = group
        table.insert(self.spawned_units, data)
        entry.Reserve = entry.Reserve - 1
    end
end

return GroupSpawn
