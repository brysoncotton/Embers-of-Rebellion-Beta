require("PGCommands")
require("TRCommands")
require("eawx-util/StoryUtil")
require("eawx-util/MissionUtil")
require("deepcore/std/class")

---@class TacticalSuperlaser
TacticalSuperlaser = class()

function TacticalSuperlaser:new()
	self.enabled = true
	if Find_Hint("ATTACKER ENTRY POSITION", "instant-action") then
		self.enabled = false
		return
	end

	self.owner = Object.Get_Owner()
	if self.owner ~= Find_Player("local") then
		ScriptExit()
	end

	self.ObjectName = Object.Get_Type().Get_Name()
	self.Ability = "Super_Laser_Attack_Ability"

	local display_name_library = require("DisplayNameLibrary")
	self.ObjectReadableName = display_name_library[self.ObjectName]

	MissionUtil.ToggleAbility(self.owner,self.ObjectName,self.Ability,false)

	self.FullChargeSeconds = 60
	self.NotificationCount = 6

	self.NotificationInterval = self.FullChargeSeconds / self.NotificationCount

	self.EntryTime = GetCurrentTime()
	self.FullChargeTime = self.EntryTime + self.FullChargeSeconds

	self.DisplayStringEmpty = " \n "
	StoryUtil.ShowScreenText(self.DisplayStringEmpty, -1)

	self.DisplayStringText = self.ObjectReadableName.." tactical superlaser charging. Ready in "..tostring(self.FullChargeSeconds).." seconds."
	StoryUtil.ShowScreenText(self.DisplayStringText, self.NotificationInterval)
	Object.Attach_Particle_Effect("Tactical_Superlaser_Charging_Particle_1")

	self.NextNotificationIndex = 1
	self.NextNotificationTime = self.EntryTime + self.NotificationInterval
end

function TacticalSuperlaser:update()
	if self.enabled == false then
		return
	end
	
	MissionUtil.ToggleAbility(self.owner,self.ObjectName,self.Ability,false)

	if GetCurrentTime() < self.NextNotificationTime then
		return
	end

	local DisplayStringText = ""
	local particle_name = "Tactical_Superlaser_Charging_Particle_"..tostring(self.NextNotificationIndex)

	if self.NextNotificationIndex == self.NotificationCount then
		MissionUtil.ToggleAbility(self.owner,self.ObjectName,self.Ability,true)
		StoryUtil.RemoveScreenText(self.DisplayStringText)
		self.DisplayStringText = self.ObjectReadableName.." tactical superlaser ready. You may fire at will."
		StoryUtil.ShowScreenText(self.DisplayStringText, self.NotificationInterval)
		Object.Attach_Particle_Effect(particle_name)
		self.enabled = false
		return
	end

	StoryUtil.RemoveScreenText(self.DisplayStringText)
	self.DisplayStringText = self.ObjectReadableName.." charge "..Dirty_Floor(self.NextNotificationIndex / self.NotificationCount * 100).."%. Ready in "..tostring(self.FullChargeTime - self.NextNotificationTime).." seconds."
	StoryUtil.ShowScreenText(self.DisplayStringText, self.NotificationInterval)
	Object.Attach_Particle_Effect(particle_name)

	self.NextNotificationIndex = self.NextNotificationIndex + 1
	self.NextNotificationTime = self.NextNotificationTime + self.NotificationInterval
end

return TacticalSuperlaser
