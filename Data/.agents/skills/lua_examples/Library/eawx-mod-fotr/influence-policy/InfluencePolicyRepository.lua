InfluencePolicyRepository = {
    DEFAULT = function(planet)
        return 0
    end
}

---@param planet Planet
function InfluencePolicyRepository.kashyyyk(planet)
    if planet:get_owner() ~= Find_Player("Empire") then
        return -2
    end

    return 0
end

---@param planet Planet
function InfluencePolicyRepository.geonosis(planet)
    if planet:get_owner() ~= Find_Player("Rebel") then
        return -2
    end
    return 0
end

---@param planet Planet
function InfluencePolicyRepository.nal_hutta(planet)
    if planet:get_owner() ~= Find_Player("Hutt_Cartels") then
        return -2
    end

    return 0
end
