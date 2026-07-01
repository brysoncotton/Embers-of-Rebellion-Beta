require("deepcore/std/class")
require("PGStateMachine")
require("PGSpawnUnits")
require("eawx-util/StoryUtil")

---@class CompanySpawn
CompanySpawn = class()

function CompanySpawn:new(unit_entry)
    self.is_active = true

    ---@private
    self.unit_entry = unit_entry

    Object.Prevent_AI_Usage(true)
    Object.Set_Selectable(false)
    Object.Make_Invulnerable(true)
	Object.Hide(true)
	Object.Set_Importance(0)

    self.location = Object.Get_Position()
    self.location_table = self:get_location_table()
    self.location_index = 1
    self.killable = true

    self.attrition_rate = 0.4

    ---@private
    self.object_name = Object.Get_Type().Get_Name()

    

    ---@private
    self.spawn_data = {}
    if self.object_name == "EBON_HAWK_CREW_DUMMY" then
        self.killable = false
        local hawk_data = GlobalValue.Get("EBON_HAWK_CREW")
        local hawk_spawns = {}
        for _, member in pairs(hawk_data) do
            hawk_spawns[member] = {DEFAULT = {Initial = 1, Reserve = 0}}
        end

        self.spawn_data = hawk_spawns

    else
        self.spawn_data = unit_entry.Spawn_Units
    end

    ---@private
    ---@type PlayerObject
    self.original_owner = Object.Get_Owner()

    ---@private
    self.spawned_units = self:get_initial_company(self.spawn_data, self.original_owner) or {}
    self.total_spawned_units = table.getn(self.spawned_units)

    for i, data in pairs(self.spawned_units) do
        if not data.UnitType or not TestValid(data.UnitType) then
            local delay = 1+i
            Register_Timer(self.spawn, delay, {self, data})
        end
    end
    Object.Teleport(Create_Position(-1000,-1000,0))
end

function CompanySpawn:update()
    if not self.is_active then
        return
    end

    self:check_company()
end

function CompanySpawn:get_location_table()
    local origin_x = 0
    local origin_y = 0
    local origin_z = 0
    local spacing = 5
    local position = nil

    origin_x, origin_y, origin_z = self.location.Get_XYZ()
    local location_matrix = {}
    local gridSize = 5

    local halfGridSize = Dirty_Floor(gridSize / 2)
    
    local startX = origin_x - halfGridSize * spacing
    local startY = origin_y - halfGridSize * spacing
    
    for i = 0, gridSize - 1 do
        for j = 0, gridSize - 1 do
            local x = startX + i * spacing
            local y = startY + j * spacing
            local z = origin_z
            position = Create_Position(x, y, z)
            table.insert(location_matrix, position)
        end
    end

    return location_matrix
end

---@private
function CompanySpawn:check_company()
    local active_units = 0
    for i, data in pairs(self.spawned_units) do
        if not data.UnitType or not TestValid(data.UnitType) then
            table.remove(self.spawned_units, i)
        else
            active_units = active_units +1
        end
    end
    if self.killable then
        if active_units / self.total_spawned_units <= self.attrition_rate then
            Object.Take_Damage(999999)
        end
    end
end

---@private
function CompanySpawn:get_initial_company(company_data, original_owner)
    local initial_spawns = {}

    for type_string, tab in pairs(company_data) do
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

function CompanySpawn:get_spawn_entry(tab)
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
	
	dospawn = (spawn_tab.ResearchType == nil) or self:evaluate_research(spawn_tab.ResearchType)
	
	if dospawn then
	    return spawn_tab
	end
	
	return nil
end

---@private
function CompanySpawn.spawn(wrapper)
    local self = wrapper[1]
    local data = wrapper[2]
    local objectType = data.ObjectType
	local RefString = data.RefString
	local TypeString = data.TypeString
    local tab = self.spawn_data[data.RefString]
    local entry = self:get_spawn_entry(tab)

     if not entry then
        DebugMessage(
            "Could not find Company Entry for %s on Spawner %s",
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
        local company = Spawn_Unit(unitType, self.location_table[self.location_index], self.original_owner, true, false)[1]
        self.location_index = self.location_index + 1
        if self.location_index > 25 then
            self.location_index = 1
        end
		
        data.UnitType = company
        table.insert(self.spawned_units, data)
        entry.Reserve = entry.Reserve - 1
    end
end

function CompanySpawn:evaluate_research(rtable)
    local levels = GlobalValue.Get("FIGHTER_RESEARCH")
    if type(rtable) ~= "table" then
        rtable = {rtable}
    end

    for i, rtype in pairs(rtable) do
        local isNegative = false
        local truthDeferred = false
        local containCheck = string.find(rtype, "~")
        if containCheck ~= nil then
            isNegative = true
            rtype = string.gsub(rtype, "~", "")
        end
        if levels == nil then
            if not isNegative then
                return false
            end
        else
            for index, obj in pairs(levels) do
                if obj == rtype then
                    if isNegative then
                        return false
                    else
                        truthDeferred = true
                        break
                    end
                end
            end
        end
        if not truthDeferred and not isNegative then
            return false
        end
    end
    return true
end

return CompanySpawn
