require("PGBase")
require("PGSpawnUnits")
require("deepcore/std/class")
require("deepcore/crossplot/crossplot")
require("eawx-util/StoryUtil")

---@class Bloodlust
Bloodlust = class()

function Bloodlust:new()
    self.bloodlust_player_name = "UNDERWORLD"
    self.player_bloodlust = Find_Player("Underworld")
    self.human_is_mando = false
    if Find_Player("local") == self.player_bloodlust then
        self.human_is_mando = true
    end

    self.bloodlust_enabled = false
    self.player_enemy = nil

    self.position = nil

    self.active_target = nil
    self.targeting_duration = 90
    self.targeting_end_time = 0

    self.active_buff = nil
    self.buff_duration = 60
    self.buff_end_time = 0

    self.cooldown_duration = 30
    self.cooldown_end_time = 0

    crossplot:subscribe("GAME_MODE_STARTING", self.mode_start, self)
    crossplot:subscribe("GAME_MODE_ENDING", self.mode_end, self)
    crossplot:subscribe("TACTICAL_UNIT_DESTROYED", self.object_destroyed, self)
end

function Bloodlust:mode_start(mode)
    if mode ~= "Space" or TestValid(Find_First_Object("SCRIPTED_BATTLE_MARKER")) == true then
        self.bloodlust_enabled = false
        return
    end

    local player_attacker = Find_First_Object("Attacker Entry Position").Get_Owner()
    local player_defender = Find_First_Object("Defending Forces Position").Get_Owner()
    if player_attacker == self.player_bloodlust then
        self.bloodlust_enabled = true
        self.player_enemy = player_defender
    else
        if player_defender == self.player_bloodlust then
            self.bloodlust_enabled = true
            self.player_enemy = player_attacker
        end
    end

    self.position = nil

    self.active_target = nil
    self.targeting_end_time = 0

    self.active_buff = nil
    self.buff_end_time = 0

    self.cooldown_end_time = 60 --first target selection in each relevant battle at T+60s; all subsequent cooldowns between buff end and new target selection in intervals of 30s
end

function Bloodlust:update()
    if self.bloodlust_enabled == false then
        return
    end

    if self.position == nil then
        self.position = Create_Position(0,0,0)
    end

    local now = GetCurrentTime()

    --if no target, no buff, and cooldown time has elapsed, select new target and begin targeting timer
    if self.active_target == nil and self.active_buff == nil and now > self.cooldown_end_time then
        self:targeting_begin()
    --if target and targeting time has elapsed, spawn debuff and begin buff timer
    elseif self.active_target ~= nil and now > self.targeting_end_time then
        self:buff_begin(false)
    --if buff and buff time has elapsed, despawn it and begin cooldown timer
    elseif self.active_buff ~= nil and now > self.buff_end_time then
        self:cooldown_begin()
    end
end

function Bloodlust:targeting_begin()
    if TestValid(self.player_enemy) ~= true then
        return
    end

    local target_list = Find_All_Objects_Of_Type(self.player_enemy, "Capital | Frigate | Corvette")

    for i, target in pairs(target_list) do
        if target.Has_Property("IsStarbase") then
            table.remove(target_list, i)
        end
    end

    if table.getn(target_list) == 0 then
        return
    end

    local target_index = GameRandom.Free_Random(1,table.getn(target_list))
    self.active_target = target_list[target_index]
    self.active_target.Attach_Particle_Effect("Bloodlust_Particle")

    local message = nil
    if self.human_is_mando == true then
        message = "TEXT_GOVERNMENT_BLOODLUST_TARGET_MANDO"
    else
        message = "TEXT_GOVERNMENT_BLOODLUST_TARGET_NON_MANDO"
    end
    StoryUtil.ShowScreenText(message, 15, self.active_target)

    self.targeting_end_time = GetCurrentTime() + self.targeting_duration
end

function Bloodlust:object_destroyed(object_name, object_power, object_is_hero, object)
    if object == self.active_target then
        self:buff_begin(true)
    end
end

function Bloodlust:buff_begin(success)
    if not self.position then
        return
    end

    local buff_type = nil
    local message = nil
    if success == true then
        buff_type = "Bloodlust_Success_Buff"
        if self.human_is_mando == true then
            message = "TEXT_GOVERNMENT_BLOODLUST_SUCCESS_MANDO"
        else
            message = "TEXT_GOVERNMENT_BLOODLUST_SUCCESS_NON_MANDO"
        end
        StoryUtil.ShowScreenText(message, 15, self.active_target)
    else
        buff_type = "Bloodlust_Failure_Debuff"
        if self.human_is_mando == true then
            if TestValid(self.active_target) == false then
                message = "TEXT_GOVERNMENT_BLOODLUST_FAILURE_MANDO_BACKUP"
                StoryUtil.ShowScreenText(message, 15)
            else
                message = "TEXT_GOVERNMENT_BLOODLUST_FAILURE_MANDO"
                StoryUtil.ShowScreenText(message, 15, self.active_target)
            end
        else
            if TestValid(self.active_target) == false then
                message = "TEXT_GOVERNMENT_BLOODLUST_FAILURE_NON_MANDO_BACKUP"
                StoryUtil.ShowScreenText(message, 15)
            else
                message = "TEXT_GOVERNMENT_BLOODLUST_FAILURE_NON_MANDO"
                StoryUtil.ShowScreenText(message, 15, self.active_target)
            end
            --this is a stopgap while the Mando AI doesn't actively go after the Bloodlust target. ~Mord
            self.active_target = nil
            self.cooldown_end_time = GetCurrentTime() + self.buff_duration + self.cooldown_duration
            return
        end
    end

    self.active_target = nil
    self.active_buff = Create_Generic_Object(buff_type, self.position, self.player_bloodlust)
    self.active_buff.Set_Selectable(false)

    self.buff_end_time = GetCurrentTime() + self.buff_duration
end

function Bloodlust:cooldown_begin()
    if TestValid(self.active_buff) then
        self.active_buff.Despawn()
    end

    self.active_buff = nil

    self.cooldown_end_time = GetCurrentTime() + self.cooldown_duration
end

function Bloodlust:mode_end(mode)
    self.bloodlust_enabled = false
end

return Bloodlust
