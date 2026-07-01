require("deepcore/std/class")

---@class InterdictorAi
InterdictorAi = class()


function InterdictorAi:new()
    if Get_Game_Mode() ~= "Space" then
        self.isActive = false
        return
    end
    
    InterdictorAi.isActive = true
    
	-- Bail out if this is a human player
	if Object.Get_Owner().Is_Human() then
		self.isActive = false
		return
	end

    interdicting = false
    using_missile_shield = false
    cancelling_shield = false
end

function InterdictorAi:update()
	if not self.isActive then
		return
	end
	
    repeat
        -- The AI may not yet be initialized
        Sleep(1)
        enemy_is_retreating = EvaluatePerception("Enemy_Retreating", Object.Get_Owner())
    until (enemy_is_retreating ~= nil)

    -- Prevent the enemy from retreating, if they're trying to
    if (enemy_is_retreating ~= 0) and (not interdicting) then
        interdicting = true
        Sleep(GameRandom(3,8))
        --MessageBox("trying to interdict")
        Object.Activate_Ability("INTERDICT", true)
        Register_Timer(Cancel_Interdiction, 20)
    end

    -- Use the missile shield if we're being attacked by a rocket boat
    if Under_Missile_Attack() and (not using_missile_shield) then
        using_missile_shield = true
        Object.Activate_Ability("MISSILE_SHIELD", true)
    elseif using_missile_shield and (not cancelling_shield) then
        cancelling_shield = true
        Register_Timer(Cancel_Missile_Shield, 30)
    end
end

function Cancel_Interdiction()
    Object.Activate_Ability("INTERDICT", false)
    interdicting = false
end

function Under_Missile_Attack()
    deadly_enemy = FindDeadlyEnemy(Object)
	if TestValid(deadly_enemy) then
		projectile_types = deadly_enemy.Get_All_Projectile_Types()
		for _, projectile in pairs(projectile_types) do
			if projectile.Is_Affected_By_Laser_Defense() or projectile.Is_Affected_By_Missile_Shield() then
				return true
			end
		end
	end
    return false
end

function Cancel_Missile_Shield()
    cancelling_shield = false

    if Under_Missile_Attack() then
        return
    end

    Object.Activate_Ability("MISSILE_SHIELD", false)
    using_missile_shield = false
end

return InterdictorAi
