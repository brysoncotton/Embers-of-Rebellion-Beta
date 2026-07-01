--**************************************************************************************************
--*    _______ __                                                                                  *
--*   |_     _|  |--.----.---.-.--.--.--.-----.-----.                                              *
--*     |   | |     |   _|  _  |  |  |  |     |__ --|                                              *
--*     |___| |__|__|__| |___._|________|__|__|_____|                                              *
--*    ______                                                                                      *
--*   |   __ \.-----.--.--.-----.-----.-----.-----.                                                *
--*   |      <|  -__|  |  |  -__|     |  _  |  -__|                                                *
--*   |___|__||_____|\___/|_____|__|__|___  |_____|                                                *
--*                                   |_____|                                                      *
--*                                                                                                *
--*                                                                                                *
--*       File:              Boarding.lua                                                          *
--*       File Created:      Saturday, 7th March 2020 21:42                                        *
--*       Author:            [TR] Pox                                                              *
--*       Last Modified:     Monday, 8th June 2020 08:28                                           *
--*       Modified By:       [TR] Pox                                                              *
--*       Copyright:         Thrawns Revenge Development Team                                      *
--*       License:           This code may not be used without the author's explicit permission    *
--**************************************************************************************************

require("PGCommands")
require("TRCommands")
require("eawx-util/StoryUtil")
require("deepcore/std/class")

---@class Boarding
Boarding = class()

function Boarding:new()
    self.isActive = true
    self.attemptsLeft = 5
    self.registeredProx = false
    self.boardingTarget = nil

    self.crew_cost_per_attempt = 25
end

function Boarding:update()
    if Object.Is_Ability_Active("SPOILER_LOCK") then
        if self.attemptsLeft <= 0 then
            Object.Activate_Ability("SPOILER_LOCK", false)
            StoryUtil.ShowScreenText("BOARDING_UNAVAILABLE", 5)
            return
        end

        self:register_prox_function()
    else
        self:cancel_prox_function()
        self:cancel_timer_function()
    end
end

function Boarding:register_prox_function()
    if self.registeredProx then
        return
    end

    TR_Register_Prox(Object, self.boarding_prox_trigger, 600, nil, self)
    self.registeredProx = true
end

function Boarding:cancel_prox_function()
    if not self.registeredProx then
        return
    end

    TR_Cancel_Prox(Object, self.boarding_prox_trigger)
    self.registeredProx = false
end

function Boarding:cancel_timer_function()
    if self.registeredTimer then
        self:toggle_boarding_effects(self.boardingTarget)
        Cancel_Timer(self.boarding_timer)
        self.registeredTimer = false
    end
end

function Boarding:toggle_boarding_effects()
    if not TestValid(self.boardingTarget) then
        return
    end

    if self.boardingEffectsActive == nil then
        self.boardingEffectsActive = false
    end

    self.boardingEffectsActive = not self.boardingEffectsActive
    self.boardingTarget.Stop()
    if self.boardingEffectsActive then
        self.boardingTarget.Attach_Particle_Effect("Boarding_Particle")
    end
end

function Boarding.boarding_prox_trigger(prox_obj, trigger_obj, self)
    if trigger_obj.Get_Owner() == Object.Get_Owner() then
        return
    end

    if trigger_obj.Has_Property("Boardable") then
        TR_Cancel_Prox(Object, self.boarding_prox_trigger)
        self.boardingTarget = trigger_obj
        self:toggle_boarding_effects()
        Register_Timer(self.boarding_timer, 4, self)
        self.registeredTimer = true
    end
end

function Boarding:boarding_timer()
    Cancel_Timer(self.boarding_timer)
    local target = self.boardingTarget
    self:toggle_boarding_effects()
    self.attemptsLeft = self.attemptsLeft - 1
    crossplot:publish("CREW_COST", self.crew_cost_per_attempt)

    self.registeredTimer = false
    self.boardingTarget = nil
    Object.Activate_Ability("SPOILER_LOCK", false)
    Object.Make_Invulnerable(true)
    target.Make_Invulnerable(true)

    if not TestValid(target) then
        return
    end

    if target.Get_Owner() == Object.Get_Owner() then
        return
    end

    local success = (GameRandom(1, 100) - target.Get_Hull() * 40) > 50

    if success then
        target.Change_Owner(Object.Get_Owner())
        target.Stop()
        local boardedTypeName = target.Get_Type().Get_Name()
        local newOwnerName = Object.Get_Owner().Get_Faction_Name()
        DebugMessage("Boarding -- Boarding successful. Object Type: %s, New Owner: %s", boardedTypeName, newOwnerName)
        crossplot:publish("BOARDED_UNIT", boardedTypeName, newOwnerName)
        StoryUtil.ShowScreenText("BOARDING_SUCCESSFUL_REGULAR", 10)
        target.Hyperspace_Away(true)
    else
        target.Make_Invulnerable(false)
    end

    Object.Make_Invulnerable(false)
end

return Boarding
