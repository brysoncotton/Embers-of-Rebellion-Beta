require("deepcore/std/class")
require("PGStateMachine")
require("PGSpawnUnits")
require("eawx-util/MissionUtil")
require("eawx-util/StoryUtil")

---@class PartisanAllegiance
PartisanAllegiance = class()

function PartisanAllegiance:new(structure_entry)
	local gameConstants = ModContentLoader.get("GameConstants")
	self.factionAliasTable = gameConstants.ALIASES
	local heroTraitsTable = require("HeroIndigenousEffectsLibrary")
	self.partisanAllegianceTable = heroTraitsTable.PARTISAN_ALLEGIANCE
	self.partisanSuppressionTable = heroTraitsTable.PARTISAN_SUPPRESSION
	self.animalAllegianceTable = heroTraitsTable.ANIMAL_ALLEGIANCE

	self.p_attacker = MissionUtil.Find_Attacking_Player()
	self.attacker_name = self.p_attacker.Get_Faction_Name()
	self.p_defender = MissionUtil.Find_Defending_Player()
	self.defender_name = self.p_defender.Get_Faction_Name()

	self.attacker_alias = self.factionAliasTable[self.attacker_name]
	self.defender_alias = self.factionAliasTable[self.defender_name]

	self.p_human = Find_Player("local")
	self.p_enemy = nil
	if self.p_human == self.p_attacker then
		self.p_enemy = self.p_defender
	else
		self.p_enemy = self.p_attacker
	end

	self.location = Object.Get_Position()

	self.dwelling_type = structure_entry.dwelling_type
	self.can_be_influenced = structure_entry.can_be_influenced
	self.random_allegiance = structure_entry.random_allegiance
	self.possible_allegiances = structure_entry.Allegiances
	self.master_spawn_data = structure_entry.Spawn_Units

	self.spawn_objects = {}
	self.interference_message = nil
	self.recheck_time = nil

	--1) wait for AI to wake up, then check for presence of a labour camp
	self.labour_camp_exists = nil
	if self.labour_camp_exists == nil then
		repeat
			Sleep(0.1)
			self.labour_camp_exists = EvaluatePerception("Enemy_Has_Labour_Camp",self.p_attacker)
		until self.labour_camp_exists ~= nil
	end
	self.labour_camp_exists = (self.labour_camp_exists == 1)

	--2) if there is no labour camp, check for presence of a "Partisan Suppressor" hero
	self.suppressor_hero_exists = false
	if self.labour_camp_exists == false then
		self:detect_suppressor_hero()
	end

	--2) identify partisan owner
	self.possible_allegiances = self:faction_alias_handler()
	self.p_partisan_owner = self:determine_allegiance()
	self.partisan_owner_name = self.p_partisan_owner.Get_Faction_Name()
	self.partisan_owner_alias = self.factionAliasTable[self.partisan_owner_name]

	--3) determine what objects will spawn for this owner when spawning begins
	self:initialize_spawn_objects()

	--4) change ownership of structure if there is no labour camp and no suppressor hero
	if self.labour_camp_exists == false and self.suppressor_hero_exists == false then
		Object.Change_Owner(self.p_partisan_owner)
	end

	--5) set the appropriate objective text based on human role, partisan stance towards human, and labour camp existence
	self:set_objective_text()
end

function PartisanAllegiance:detect_suppressor_hero()
	local HeroTraitTable = nil

	if self.dwelling_type == "PARTISAN" then
		HeroTraitTable = self.partisanSuppressionTable
	else
		return
	end

	--when suppressor is deployed to the field (can be defender or initial attacker unit)
	for i,hero_attributes in pairs(HeroTraitTable) do
		local hero_object = Find_First_Object(hero_attributes.HeroName)
		if TestValid(hero_object) then
			self.suppressor_hero_exists = true
			self.interference_message = hero_attributes.RecruitingMessage
			return
		end
	end

	--when defending suppressor is in orbit (stealth raid)
	for i,hero_attributes in pairs(HeroTraitTable) do
		if Evaluate_In_Galactic_Context(hero_attributes.GroundPerception, self.p_defender) == 1 then
			self.suppressor_hero_exists = true
			self.interference_message = hero_attributes.RecruitingMessage
			return
		end
	end

	--when attacking suppressor is in orbit
	for i,hero_attributes in pairs(HeroTraitTable) do
		if Evaluate_In_Galactic_Context(hero_attributes.GroundPerception, self.p_attacker) == 1 then
			self.suppressor_hero_exists = true
			self.interference_message = hero_attributes.RecruitingMessage
			return
		end
	end

	--the game thinks an orbiting suppressor hero stops existing during deployment from reinforcements
	if self.suppressor_hero_exists == true and self.recheck_time == nil then
		self.recheck_time = GetCurrentTime() + 10
		return
	elseif self.recheck_time == nil then
		return
	end

	if self.recheck_time <= GetCurrentTime() then
		self.suppressor_hero_exists = false
		self.recheck_time = nil
	end
end

function PartisanAllegiance:faction_alias_handler()
	local dealiased_faction_name_list = {}

	local order_66 = GlobalValue.Get("ORDER_66")

	for _,aliased_faction_name in pairs(self.possible_allegiances) do
		if aliased_faction_name == "REPUBLIC_UNLESS_ORDER_66" then
			if order_66 == true then
				aliased_faction_name = "INDEPENDENT_FORCES"
			else
				aliased_faction_name = "REPUBLIC"
			end
		end

		local dealiased_faction_name = aliased_faction_name

		if aliased_faction_name == self.defender_alias then
			dealiased_faction_name = self.defender_name
		elseif aliased_faction_name == self.attacker_alias then
			dealiased_faction_name = self.attacker_name
		end
		table.insert(dealiased_faction_name_list,dealiased_faction_name)
	end

	return dealiased_faction_name_list
end

function PartisanAllegiance:determine_allegiance()
	local owner_name = nil

	--1) If the defender is Independent Forces, then partisans ally with the defender.
	if self.p_defender == self.p_independent then
		self.possible_allegiances = {"INDEPENDENT_FORCES"}
	end

	--2) If partisan allegiance can be influenced:
	--A) If a labour camp exists on the planet, sapient partisans' possible allegiances are set to "ATTACKER".
	if self.labour_camp_exists == true then
		self:labour_camp_allegiance_handler()
	--B) If no labour camp exists, and a "Partisan Recruiter", "Beast Tamer", "Anti-Partisan", or "Poacher" hero is present, allegiance is set based on the hero owner.
	else
		self:hero_trait_allegiance_handler()
	end

	if self.interference_message ~= nil then
		StoryUtil.ShowScreenText(self.interference_message, 15, nil, {r = 244, g = 244, b = 0})
	end

	--3.A) If the allegiance is not randomized, check if partisans want to align with one of the belligerents. (Defender preferred.)
	if self.random_allegiance ~= true then
		owner_name = self:align_with_belligerent()
	end

	--3.B) If the allegiance is randomized *OR* partisans don't want to align with one of the belligerents, pick a random allegiance from their list.
	if (owner_name == nil) or (self.random_allegiance == true) then
		local random = GameRandom.Free_Random(1, table.getn(self.possible_allegiances))
		owner_name = self.possible_allegiances[random]
	end

	--If the allegiance uses the ATTACKER or DEFENDER aliases, translate that into an actual faction.
	if owner_name == "ATTACKER" then
		return self.p_attacker
	elseif owner_name == "DEFENDER" then
		return self.p_defender
	else
		return Find_Player(owner_name)
	end
end

function PartisanAllegiance:labour_camp_allegiance_handler()
	if self.dwelling_type ~= "PARTISAN" then
		return
	end

	if self.can_be_influenced == false then
		self.interference_message = "The local partisans will fight for the "..Find_Player(self.possible_allegiances[1]).Get_Name().." if the labour camp is destroyed."
		return
	end

	if self.p_human == self.p_attacker then
		self.interference_message = "The local freedom fighters will fight for us if we free their leaders from the "..self.p_defender.Get_Name().." labour camp."
	else
		self.interference_message = "The local insurgents will fight for the "..self.p_attacker.Get_Name().." if our labour camp is destroyed."
	end

	self.possible_allegiances = {"ATTACKER"}
end

function PartisanAllegiance:hero_trait_allegiance_handler()
	local HeroTraitTable = nil
	local partisan_owner_name = nil

	if self.dwelling_type == "PARTISAN" then
		HeroTraitTable = self.partisanAllegianceTable
	elseif self.dwelling_type == "ANIMAL" then
		HeroTraitTable = self.animalAllegianceTable
	else
		return
	end

	--when recruiter is deployed to the field (can be defender or initial attacker unit)
	for i,hero_attributes in pairs(HeroTraitTable) do
		local hero_object = Find_First_Object(hero_attributes.HeroName)
		if TestValid(hero_object) then
			if self:check_can_be_influenced() == false then
				return
			end

			local p_hero_owner = hero_object.Get_Owner()

			if p_hero_owner == self.p_attacker then
				if hero_attributes.RecruitingFaction == "FRIENDLY" then
					partisan_owner_name = "ATTACKER"
				else
					partisan_owner_name = "DEFENDER"
				end
			else
				if hero_attributes.RecruitingFaction == "FRIENDLY" then
					partisan_owner_name = "DEFENDER"
				else
					partisan_owner_name = "ATTACKER"
				end
			end

			self.interference_message = hero_attributes.RecruitingMessage
			self.possible_allegiances = {partisan_owner_name}

			return
		end
	end

	--when defending recruiter is in orbit (stealth raid)
	for i,hero_attributes in pairs(HeroTraitTable) do
		if Evaluate_In_Galactic_Context(hero_attributes.GroundPerception, self.p_defender) == 1 then
			if self:check_can_be_influenced() == false then
				return
			end

			if hero_attributes.RecruitingFaction == "FRIENDLY" then
				partisan_owner_name = "DEFENDER"
			else
				partisan_owner_name = "ATTACKER"
			end

			self.interference_message = hero_attributes.RecruitingMessage
			self.possible_allegiances = {partisan_owner_name}

			return
		end
	end

	--when attacking recruiter is in orbit
	for i,hero_attributes in pairs(HeroTraitTable) do
		if Evaluate_In_Galactic_Context(hero_attributes.GroundPerception, self.p_attacker) == 1 then
			if self:check_can_be_influenced() == false then
				return
			end

			if hero_attributes.RecruitingFaction == "FRIENDLY" then
				partisan_owner_name = "ATTACKER"
			else
				partisan_owner_name = "DEFENDER"
			end

			self.interference_message = hero_attributes.RecruitingMessage
			self.possible_allegiances = {partisan_owner_name}

			return
		end
	end
end

function PartisanAllegiance:check_can_be_influenced()
	if self.can_be_influenced == false then
		if self.dwelling_type == "PARTISAN" then
			self.interference_message = "The local partisans cannot be dissuaded from fighting for the "..Find_Player(self.possible_allegiances[1]).Get_Name().."."
		else
			self.interference_message = "The local wildlife cannot be dissuaded from fighting for the "..Find_Player(self.possible_allegiances[1]).Get_Name().."."
		end
	end

	return self.can_be_influenced
end

function PartisanAllegiance:align_with_belligerent()
	--1) If the planet owner is on this partisan's list of preferred allegiances *OR* if this partisan has DEFENDER in their list of allegiances, this partisan fights for the planet owner.
	for _, faction_name in pairs(self.possible_allegiances) do
		if (faction_name == "DEFENDER") or (faction_name == self.name_defender) then
			return faction_name
		end
	end
	--2) If the attacker is on this partisan's list of preferred allegiances *OR* if this partisan has ATTACKER in their list of allegiances, this partisan fights for the attacker.
	for _, faction_name in pairs(self.possible_allegiances) do
		if faction_name == "ATTACKER" or faction_name == self.p_attacker.Get_Faction_Name() then
			return faction_name
		end
	end
end

function PartisanAllegiance:initialize_spawn_objects()
	for object_type_name, spawn_details in pairs(self.master_spawn_data) do
		local pending_spawn = self:check_if_object_spawns_for_owner(spawn_details)
		if pending_spawn then
			local object_type = Find_Object_Type(object_type_name)
			pending_spawn.Reserve = pending_spawn.Initial + pending_spawn.Reserve
			for i = 1, pending_spawn.Initial do
				table.insert(self.spawn_objects, {UnitType = nil, ObjectType = object_type, TypeString = object_type_name, RefString = object_type_name})
			end
		end
	end
end

function PartisanAllegiance:check_if_object_spawns_for_owner(spawn_details)
	if spawn_details[self.partisan_owner_name] then
		return spawn_details[self.partisan_owner_name]
	elseif self.partisan_owner_alias and spawn_details[self.partisan_owner_alias] then
		return spawn_details[self.partisan_owner_alias]
	elseif spawn_details["DEFAULT"] then
		return spawn_details["DEFAULT"]
	else
		return nil
	end
end

function PartisanAllegiance:set_objective_text()
	local old_enemy_objective_text = GlobalValue.Get("PARTISANS_ENEMY_OBJECTIVE_TEXT")
	local old_friendly_objective_text = GlobalValue.Get("PARTISANS_FRIENDLY_OBJECTIVE_TEXT")
	local old_third_party_objective_text = GlobalValue.Get("PARTISANS_THIRD_PARTY_OBJECTIVE_TEXT")
	local new_enemy_objective_text = nil
	local new_friendly_objective_text = nil
	local new_third_party_objective_text = nil

	if self.labour_camp_exists == true then
		if self.p_partisan_owner == self.p_enemy then
			new_enemy_objective_text = "TEXT_TACTICAL_OBJECTIVE_PARTISANS_IMPRISONED_ENEMY"
		elseif self.p_partisan_owner == self.p_human then
			new_friendly_objective_text = "TEXT_TACTICAL_OBJECTIVE_PARTISANS_IMPRISONED_FRIENDLY"
		else
			new_third_party_objective_text = "TEXT_TACTICAL_OBJECTIVE_PARTISANS_IMPRISONED_THIRD_PARTY"
		end
	elseif self.suppressor_hero_exists == true then
		if self.p_partisan_owner == self.p_enemy then
			new_enemy_objective_text = "TEXT_TACTICAL_OBJECTIVE_PARTISANS_SUPPRESSED_ENEMY"
		elseif self.p_partisan_owner == self.p_human then
			new_friendly_objective_text = "TEXT_TACTICAL_OBJECTIVE_PARTISANS_SUPPRESSED_FRIENDLY"
		else
			new_third_party_objective_text = "TEXT_TACTICAL_OBJECTIVE_PARTISANS_SUPPRESSED_THIRD_PARTY"
		end
	else
		if self.p_partisan_owner == self.p_enemy then
			new_enemy_objective_text = "TEXT_TACTICAL_OBJECTIVE_PARTISANS_ACTIVE_ENEMY"
		elseif self.p_partisan_owner == self.p_human then
			new_friendly_objective_text = "TEXT_TACTICAL_OBJECTIVE_PARTISANS_ACTIVE_FRIENDLY"
		else
			new_third_party_objective_text = "TEXT_TACTICAL_OBJECTIVE_PARTISANS_ACTIVE_THIRD_PARTY"
		end
	end

	if new_enemy_objective_text ~= old_enemy_objective_text and new_enemy_objective_text ~= nil then
		if old_enemy_objective_text == nil then
			MissionUtil.SetObjectiveNew(new_enemy_objective_text)
		else
			MissionUtil.SetObjectiveUpdate(old_enemy_objective_text,new_enemy_objective_text)
		end
		GlobalValue.Set("PARTISANS_ENEMY_OBJECTIVE_TEXT",new_enemy_objective_text)
	elseif new_friendly_objective_text ~= old_friendly_objective_text and new_friendly_objective_text ~= nil then
		if old_friendly_objective_text == nil then
			MissionUtil.SetObjectiveNew(new_friendly_objective_text)
		else
			MissionUtil.SetObjectiveUpdate(old_friendly_objective_text,new_friendly_objective_text)
		end
		GlobalValue.Set("PARTISANS_FRIENDLY_OBJECTIVE_TEXT",new_friendly_objective_text)
	elseif new_third_party_objective_text ~= old_third_party_objective_text and new_third_party_objective_text ~= nil then
		if old_third_party_objective_text == nil then
			MissionUtil.SetObjectiveNew(new_third_party_objective_text)
		else
			MissionUtil.SetObjectiveUpdate(old_third_party_objective_text,new_third_party_objective_text)
		end
		GlobalValue.Set("PARTISANS_THIRD_PARTY_OBJECTIVE_TEXT",new_third_party_objective_text)
	end
end

function PartisanAllegiance:update()
	--nothing prevents animal spawns
	if self.dwelling_type == "ANIMAL" then
		self:check_spawn_objects()
		return
	end

	--if there was a labour camp and it was destroyed, reset the objective text
	if self.labour_camp_exists == true then
		self.labour_camp_exists = (EvaluatePerception("Enemy_Has_Labour_Camp",self.p_attacker) == 1)
		if self.labour_camp_exists == false and self.suppressor_hero_exists == false then
			Object.Change_Owner(self.p_partisan_owner)
			self:set_objective_text()
		elseif self.labour_camp_exists == false then
			self:set_objective_text()
		else
			return
		end
	end

	--if there was no labour camp, but there was a suppressor hero and the suppressor hero was destroyed, reset the objective text
	if self.suppressor_hero_exists == true then
		self:detect_suppressor_hero()

		if self.suppressor_hero_exists == false and self.labour_camp_exists == false then
			Object.Change_Owner(self.p_partisan_owner)
			self:set_objective_text()
		elseif self.suppressor_hero_exists == false then
			self:set_objective_text()
		else
			return
		end
	end

	self:check_spawn_objects()
end

function PartisanAllegiance:check_spawn_objects()
	for i, details in pairs(self.spawn_objects) do
		if not details.UnitType or not TestValid(details.UnitType) then
			local delay = i + 1
			Register_Timer(self.execute_spawn, delay, {self, details})
			table.remove(self.spawn_objects, i)
		end
	end
end

function PartisanAllegiance.execute_spawn(wrapper)
	local self = wrapper[1]
	local data = wrapper[2]
	local object_type = data.ObjectType
	local type_string = data.TypeString
	local ref_string = data.RefString

	local master_details = self.master_spawn_data[ref_string]
	local master_entry = self:check_if_object_spawns_for_owner(master_details)

	if not master_entry then
		-- DebugMessage(
			-- "Could not find Squad Entry for %s on Spawner %s",
			-- tostring(objectType.Get_Name()),
			-- tostring(Object.Get_Type().Get_Name())
		-- )
		return
	end

	if master_entry.Reserve > 0 then
		local unit_type = Find_Object_Type(type_string)
		data.UnitType = Spawn_Unit(unit_type, self.location, self.p_partisan_owner, true, false)[1]
		table.insert(self.spawn_objects, data)
		master_entry.Reserve = master_entry.Reserve - 1
		MissionUtil.AIActivation()
	end
end

return PartisanAllegiance
