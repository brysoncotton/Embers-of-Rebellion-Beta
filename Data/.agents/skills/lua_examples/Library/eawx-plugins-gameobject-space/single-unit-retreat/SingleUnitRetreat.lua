ModContentLoader.get("GameObjectLibrary")
require("deepcore/std/class")

---@class SingleUnitRetreat
SingleUnitRetreat = class()

---@param fighter_spawn FighterSpawn
function SingleUnitRetreat:new(fighter_spawn, HIMS)
    self.isActive = true
    self.fighter_spawn = fighter_spawn
    self.HIMS = HIMS
    self.fighters_recalled = false
    self.jumpInProgress = false
    self.retreatTimerDone = false
    self.owner = Object.Get_Owner()
    self.owner_name = self.owner.Get_Faction_Name()
end

function SingleUnitRetreat:update()
    if self:jump_initialized() then
        self:prepare_jump()
    end

    if not self.jumpInProgress then
        return
    end

    if self:jump_prevented() then
        self:cancel_jump()
        return
    end

    if self.retreatTimerDone then
        if not self.fighter_spawn:all_fighters_docked() then
            self.fighter_spawn:despawn_all_squadrons()
        end
        self:jump_to_hyperspace()
        return
    end

    if not self.fighters_recalled then
        self.fighter_spawn:dock_fighters()
        self.fighters_recalled = true
    end
end

function SingleUnitRetreat:jump_initialized()
    return Object.Are_Engines_Online() and Object.Is_Ability_Active("TURBO") and not self.jumpInProgress
end

function SingleUnitRetreat:prepare_jump()
    Object.Stop()
    Register_Timer(self.retreat_timer, 9, self)
    self.jumpInProgress = true
end

function SingleUnitRetreat:jump_prevented()
    return not Object.Are_Engines_Online() or not Object.Is_Ability_Active("TURBO") or
        self.owner_name == "WARLORDS" or
        self.owner_name == "HOSTILE" or
        EvaluatePerception("Enemy_Retreating", self.owner) == 1 or
        EvaluatePerception("Self_Retreating", self.owner) == 1 or
        (not self.HIMS and self:hostile_interdictor_active())
end

function SingleUnitRetreat:cancel_jump()
    self.fighter_spawn:release_fighters()
    Object.Activate_Ability("TURBO", false)
    Cancel_Timer(self.retreat_timer)
    self.jumpInProgress = false
    self.retreatTimerDone = false
    self.fighters_recalled = false
end

function SingleUnitRetreat:jump_to_hyperspace()
    Object.Hyperspace_Away(false)
    self.isActive = false
    self.jumpInProgress = false
    self.retreatTimerDone = false
    self.fighters_recalled = false
end

function SingleUnitRetreat:hostile_interdictor_active()
    local interdictorTable = Find_All_Objects_Of_Type("Interdictor")
    for _, interdictor in pairs(interdictorTable) do
        if interdictor.Is_Ability_Active("INTERDICT") and interdictor.Get_Owner() ~= self.owner then
            return true
        end
    end

    return false
end

function SingleUnitRetreat:retreat_timer()
    self.retreatTimerDone = true
    Cancel_Timer(self.retreat_timer)
end

return SingleUnitRetreat
