GalacticUtil = {
    __important = true
}

---@param data SpawnData
function GalacticUtil.spawn(data)
    if not data.location or not data.objects or not data.owner then
        error("Incomplete data for spawn function", 2)
    end

    local location
    if type(data.location) == "userdata" then
        location = data.location
    elseif GalacticUtil.in_galactic_mode() then
        location = FindPlanet(data.location)
    else
        location = Find_First_Object(data.location)
    end

    if type(data.objects) == "string" then
        local object_type = data.objects
        data.objects = {}
        data.objects[object_type] = 1
    end

    local faction
    if type(data.owner) == "userdata" then
        faction = data.owner
    elseif type(data.owner) == "string" then
        faction = Find_Player(data.owner)
    else
        error("Invalid owner data type")
    end

    if data.fallback and GalacticUtil.in_galactic_mode() then
        if location.Get_Owner() ~= faction then
            location = GalacticUtil.find_friendly_planet(faction)
        end
    end

    if not location then
        error("Location " .. tostring(data.location) .. " is not valid", 2)
    end

    local units = {}
    for object_type_name, amount in pairs(data.objects) do
        DebugMessage(
            "GalacticUtil::spawn -- Spawning %s instances of %s at %s",
            tostring(amount),
            tostring(object_type_name),
            tostring(location.Get_Type().Get_Name())
        )
        local object_type = Find_Object_Type(object_type_name)
        for _ = 1, amount do
            table.insert(units, Spawn_Unit(object_type, location, faction)[1])
        end
    end

    return units
end

function GalacticUtil.in_galactic_mode()
    return Get_Game_Mode() == "Galactic"
end

function GalacticUtil.find_friendly_planet(player)
    if type(player) == "string" then
        player = Find_Player(player)
    end

    local allPlanets = FindPlanet.Get_All_Planets()

    local random = 0
    local planet = nil

    while table.getn(allPlanets) > 0 do
        random = GameRandom(1, table.getn(allPlanets))
        planet = allPlanets[random]
        table.remove(allPlanets, random)

        if planet.Get_Owner() == player then
            return planet
        end
    end

    return nil
end

return GalacticUtil
