require("PGBase")
require("deepcore/std/class")
require("eawx-util/StoryUtil")

---@class PersistentDamageTactical
PersistentDamageTactical = class()

function PersistentDamageTactical:new(damage_data_source_unit_name)
	self.enabled = false
	self.object_name = Object.Get_Type().Get_Name()
	self.p_owner = Object.Get_Owner()
	self.owner_name = self.p_owner.Get_Faction_Name()
	self.unit_globalval = self.object_name.."_"..self.owner_name
	local initial_health_percent = GlobalValue.Get(self.unit_globalval)
	if initial_health_percent == nil then
		return
	end
	self.enabled = true
	self.owner_is_human = self.p_owner.Is_Human()

	--should be impossible for an SSD to enter tactical with hull in range [90, 100), but just in case
	if initial_health_percent >= 90 and initial_health_percent < 100 then
		initial_health_percent = 100
		GlobalValue.Set(self.unit_globalval, 100)
	end

	self.actual_hull_at_last_update = initial_health_percent
	self.last_value_written_to_globalval = initial_health_percent

	local display_name_library = require("DisplayNameLibrary")
	self.short_name = display_name_library[self.object_name]

	if self.owner_is_human == true then
		crossplot:publish("SSD_PARTICIPATED_IN_TACTICAL_BATTLE", self.short_name, initial_health_percent, self.object_name, self.owner_name)
	end

	if initial_health_percent == 100 then
		return
	end

	local unit_data = require("hardpoint-lists/"..damage_data_source_unit_name)
	local unit_uses_unique_shield_heal_dummy = unit_data.UNIQUE_SHIELD_HEAL_DUMMY

	self:apply_damage(unit_data.MAX_HEALTH, unit_data.HARDPOINT_HEALTH, unit_data.HARDPOINT_LIST, initial_health_percent)

	local apply_shield_heal_67_percent = 0
	local apply_shield_heal_33_percent = 0

	if initial_health_percent >= 83  then
		apply_shield_heal_67_percent = 67
		apply_shield_heal_33_percent = 33
	elseif initial_health_percent >= 50 then
		apply_shield_heal_67_percent = 67
	elseif initial_health_percent >= 16 then
		apply_shield_heal_33_percent = 33
	end

	--display initial values if deployed with damage
	if self.owner_is_human == true then
		local intro_text = self.short_name.." — initial shields: "..tostring(apply_shield_heal_67_percent + apply_shield_heal_33_percent).."% — initial hull: "..tostring(initial_health_percent).."%"
		StoryUtil.ShowScreenText(intro_text, 10)
	end

	if apply_shield_heal_67_percent + apply_shield_heal_33_percent == 0 then
		return
	end

	--NB: without this length of Sleep, the shield healer dummies spawn before the damage is taken
	Sleep(5)

	local root_bone = Object.Get_Bone_Position("root")

	if apply_shield_heal_67_percent == 67 then
		local dummy_name = "PERSISTENT_DAMAGE_SHIELD_HEAL_67_PERCENT"
		if unit_uses_unique_shield_heal_dummy == true then
			dummy_name = dummy_name.."_"..self.object_name
		end
		Spawn_Unit(Find_Object_Type(dummy_name), root_bone, self.p_owner, true, false)
	end

	if apply_shield_heal_33_percent == 33 then
		local dummy_name = "PERSISTENT_DAMAGE_SHIELD_HEAL_33_PERCENT"
		if unit_uses_unique_shield_heal_dummy == true then
			dummy_name = dummy_name.." "..self.object_name
		end
		Spawn_Unit(Find_Object_Type(dummy_name), root_bone, self.p_owner, true, false)
	end
end

function PersistentDamageTactical:apply_damage(max_health, hardpoint_health, hardpoint_list, target_health_percent)
	local damage_amount = tonumber(Dirty_Floor(((100 - target_health_percent) * max_health) / 100))
	local hardpoints_to_destroy_count = Dirty_Ceiling(damage_amount / hardpoint_health)

	while hardpoints_to_destroy_count > 0 do
		local remaining_hardpoint_count = table.getn(hardpoint_list)
		if remaining_hardpoint_count == 0 then
			break
		end
		local randroll = GameRandom.Free_Random(1,remaining_hardpoint_count)
		Object.Take_Damage(99999, hardpoint_list[randroll])
		table.remove(hardpoint_list,randroll)
		hardpoints_to_destroy_count = hardpoints_to_destroy_count - 1
	end
end

function PersistentDamageTactical:update()
	if self.enabled == false then
		return
	end

	local current_actual_hull = tonumber(Dirty_Floor(Object.Get_Hull() * 100))

	--if the hull value has not changed since the last update, do nothing
	if current_actual_hull == self.actual_hull_at_last_update then
		return
	end

	if self.owner_is_human == true then
		--if the hull value has crossed the 90% threshold in either direction since the last update, print message
		if current_actual_hull < 90 and self.actual_hull_at_last_update >= 90 then
			StoryUtil.ShowScreenText(self.short_name.." hull integrity below 90%. If it survives, it will need galactic-level repairs.", 10)
		elseif current_actual_hull >= 90 and self.actual_hull_at_last_update < 90 then
			StoryUtil.ShowScreenText(self.short_name.." hull integrity up to 90% due to field repairs. If not damaged further, it will not need galactic-level repairs.", 10)
		end
	end

	--store the new hull value to compare with the hull value in the next update
	self.actual_hull_at_last_update = current_actual_hull

	--if the hull value has changed to a value >= 90% and the most recent value written to galactic isn't 100%, set galactic to 100%
	if current_actual_hull >= 90 and self.last_value_written_to_globalval < 100 then
		GlobalValue.Set(self.unit_globalval, 100)
		self.last_value_written_to_globalval = 100
	--if the hull value has changed to a value < 90% and the most recent value written to galactic doesn't match, write real hull to galactic
	elseif current_actual_hull < 90 and current_actual_hull ~= self.last_value_written_to_globalval then
		GlobalValue.Set(self.unit_globalval, current_actual_hull)
		self.last_value_written_to_globalval = current_actual_hull
	end
end

return PersistentDamageTactical
