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
--*   @Date:                2017-11-24T12:43:51+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            Boarding.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2018-04-09T14:26:51+02:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************

require("PGCommands")
require("TRCommands")
require("eawx-util/StoryUtil")
require("deepcore/crossplot/crossplot")

Boarding = {}

Boarding.isActive = true

function Boarding:Init(globals)
    if Get_Game_Mode() ~= "Space" then
        self.isActive = false
        return
    end
    self.attemptsLeft = 5
    self.registeredProx = false
    self.boardingTarget = nil
    crossplot:game_object()
end

function Boarding:Update(globals)
    crossplot:update()
    if Object.Is_Ability_Active("SPOILER_LOCK") then
        if self.attemptsLeft <= 0 then
            Object.Activate_Ability("SPOILER_LOCK", false)
            StoryUtil.ShowScreenText("BOARDING_UNAVAILABLE", 5)
            return
        end

        self:RegisterProxFunction()
    else
        self:CancelProxFunction()
        self:CancelTimerFunction()
    end
end

function Boarding:RegisterProxFunction()
    if self.registeredProx then
        return
    end

    TR_Register_Prox(Object, BoardingProximityTrigger, 600, nil, self)
    self.registeredProx = true
end

function Boarding:CancelProxFunction()
    if not self.registeredProx then
        return
    end

    TR_Cancel_Prox(Object, BoardingProximityTrigger)
    self.registeredProx = false
end

function Boarding:CancelTimerFunction()
    if self.registeredTimer then
        self:ToggleBoardingEffects(self.boardingTarget)
        Cancel_Timer(BoardingTimer)
        self.registeredTimer = false
    end
end

function Boarding:ToggleBoardingEffects()
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

function BoardingProximityTrigger(prox_obj, trigger_obj, self)
    if trigger_obj.Get_Owner() == Object.Get_Owner() then
        return
    end

    if trigger_obj.Has_Property("Boardable") then
        TR_Cancel_Prox(Object, BoardingProximityTrigger)
        self.boardingTarget = trigger_obj
        self:ToggleBoardingEffects()
        Register_Timer(BoardingTimer, 4, self)
        self.registeredTimer = true
    end
end

function BoardingTimer(self)
    Cancel_Timer(BoardingTimer)
    local target = self.boardingTarget
    self:ToggleBoardingEffects()
    self.attemptsLeft = self.attemptsLeft - 1
    self.registeredTimer = false
    self.boardingTarget = nil
    Object.Activate_Ability("SPOILER_LOCK", false)

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
        crossplot:publish("BOARDED_UNIT", boardedTypeName, newOwnerName)
        StoryUtil.ShowScreenText("BOARDING_SUCCESSFUL_REGULAR", 10)
    end
end

return Boarding
