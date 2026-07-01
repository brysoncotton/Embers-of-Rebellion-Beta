require("deepcore/std/class")
require("eawx-util/StoryUtil")
ModContentLoader.get("GameObjectLibrary")

---@class ShoddyWorkmanship
ShoddyWorkmanship = class()

---@param fighter_spawn FighterSpawn
function ShoddyWorkmanship:new(object_hull,object_shields)
	self.enabled = true
	if Find_Hint("ATTACKER ENTRY POSITION", "instant-action") then
		self.enabled = false
		return
	end

	self.object_hull = object_hull
	self.object_shields = object_shields
	self.object_total_health = object_hull + object_shields

	self.activation_count = 0
	self.backfire_count = 0
	self.superlaser_firing = false

	local ObjectName = Object.Get_Type().Get_Name()
	local display_name_library = require("DisplayNameLibrary")
	self.ObjectReadableName = display_name_library[ObjectName]

	self.result_texts = {
		safety = {
			self.ObjectReadableName.." superlaser fired successfully.",
			self.ObjectReadableName.." has fired another shot without any issues.",
			self.ObjectReadableName.." initiating recharge cycle after a third shot.",
			self.ObjectReadableName.." actually seems to work; I can't believe it!",
			self.ObjectReadableName.." is still operational; I guess I owe Durga five credits."
		},
		backfire = {
			self.ObjectReadableName.." is experiencing excess heat buildup.",
			self.ObjectReadableName.." is still gaining heat and sinks are failing.",
			self.ObjectReadableName.."'s capacitor banks have caught fire.",
			"Please stop firing, sir! "..self.ObjectReadableName.." won't survive another misfire!"
		},
		selfdestruct = {
			"Abandon ship! Aban–"
		}
	}
end

function ShoddyWorkmanship:update()
	if self.enabled == false then
		return
	end

	if self.superlaser_firing == true then
		return
	end

	if Object.Is_Ability_Active("SUPER_LASER") then
		self.superlaser_firing = true
		Register_Timer(self.reset_timer, 6, self)
		self:roll_the_dice()
	end
end

function ShoddyWorkmanship:roll_the_dice()
	self.activation_count = self.activation_count + 1
	local firing_text

	if self.backfire_count == 0 then
		if GameRandom.Free_Random(1,6) > self.activation_count then
			firing_text = self.result_texts.safety[self.activation_count]
			StoryUtil.ShowScreenText(firing_text, 20)
			return
		end
	end

	self.backfire_count = self.backfire_count + 1

	local damage_percent_min = 0.07 * self.backfire_count
	local damage_percent_max = damage_percent_min + 0.12 * self.backfire_count
	local damage_amount_min = damage_percent_min * self.object_total_health
	local damage_amount_max = damage_percent_max * self.object_total_health

	local current_health = Object.Get_Hull() * self.object_hull + Object.Get_Shield() * self.object_shields
	local incoming_damage = GameRandom.Free_Random(damage_amount_min,damage_amount_max)
	local incoming_damage = 50000

	Object.Take_Damage(incoming_damage)

	if current_health <= incoming_damage then
		StoryUtil.ShowScreenText(self.result_texts.selfdestruct[1], 20)
		ScriptExit()
	else
		StoryUtil.ShowScreenText(self.result_texts.backfire[self.backfire_count], 20)
	end
end

function ShoddyWorkmanship:reset_timer()
	self.superlaser_firing = false
	Cancel_Timer(self.reset_timer)
end

return ShoddyWorkmanship
