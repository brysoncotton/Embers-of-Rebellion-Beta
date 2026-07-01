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
--*   @Date:                2017-12-14T10:54:01+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            TRTacticalFreeStore.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2017-12-21T12:36:19+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************



function TR_On_Unit_Service(object)
    if Get_Game_Mode() ~= "Space" then
        return false
    end

    local TR_ATTACK_RANGE = 5000

	if object.Is_Category("Bomber") then
        if AttackNearestWhenInRange(object, "SuperCapital", TR_ATTACK_RANGE) then
            return true
        end

        if AttackNearestWhenInRange(object, "Capital", TR_ATTACK_RANGE - 3000) then
            return true
        end

        if AttackNearestWhenInRange(object, "Frigate", TR_ATTACK_RANGE - 3000) then
            return true
        end
		
		if AttackNearestWhenInRange(object, "SpaceStructure", TR_ATTACK_RANGE) then
            return true
        end
		
    elseif object.Is_Category("AntiBomber") or object.Is_Category("AntiFighter") then
        if AttackNearestWhenInRange(object, "Bomber", TR_ATTACK_RANGE - 3000) then
            return true
        end
		
		if AttackNearestWhenInRange(object, "Fighter", TR_ATTACK_RANGE - 3000) then
            return true
        end
		
	elseif object.Is_Category("AntiCorvette") then
		if AttackNearestWhenInRange(object, "Corvette", TR_ATTACK_RANGE) then
            return true
        end
		
		if AttackNearestWhenInRange(object, "Frigate", TR_ATTACK_RANGE) then
            return true
        end
		
    elseif object.Is_Category("AntiFrigate") then
        if AttackNearestWhenInRange(object, "Frigate", TR_ATTACK_RANGE) then
            return true
        end

        if AttackNearestWhenInRange(object, "Corvette", TR_ATTACK_RANGE) then
            return true
        end

        if AttackNearestWhenInRange(object, "Capital", TR_ATTACK_RANGE) then
            return true
        end

    elseif object.Is_Category("AntiCapital") then
        if AttackNearestWhenInRange(object, "SuperCapital", TR_ATTACK_RANGE + 3000) then
            return true
        end

        if AttackNearestWhenInRange(object, "Capital", TR_ATTACK_RANGE + 1500) then
            return true
        end

        if AttackNearestWhenInRange(object, "Frigate", TR_ATTACK_RANGE) then
            return true
        end
		
		if AttackNearestWhenInRange(object, "SpaceStructure", TR_ATTACK_RANGE) then
            return true
        end
    end

    return false
end

function AttackNearestWhenInRange(object, category, range)
    local target = Find_Nearest(object, category, object.Get_Owner(), false)

    if not TestValid(target) then
        return false
    end

    if object.Get_Distance(target) <= range then
        object.Attack_Target(target)
        return true
    end

    return false
end
