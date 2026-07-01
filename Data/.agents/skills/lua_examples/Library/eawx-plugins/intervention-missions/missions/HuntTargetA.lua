require("deepcore/std/class")
require("PGStoryMode")
require("PGSpawnUnits")
require("eawx-util/StoryUtil")
require("eawx-util/MissionUtil")
CONSTANTS = ModContentLoader.get("GameConstants")

---@class HuntTargetAMission
HuntTargetAMission = class()

function HuntTargetAMission:new(gc, player, is_ftgu)
	self.player = player
	self.is_ftgu = is_ftgu
	self.Dialog = nil
	self.RewardGroupTable = nil

	self.TimeSinceAssigned = 0

	self.Active = false
	self.TimerStart = nil
	self.TimeActive = nil
	self.EndTime = nil
	self.Reward = nil
	self.RewardError = nil
	self.RewardCount = 0
	self.HuntTargetAUnit = nil
	self.HuntTargetAUnitName = nil
	self.HuntTargetACountCurrent = nil
	self.HuntTargetALocationCurrent = nil
	self.HuntTargetAFleet = nil
	self.ConvoyOptionsTable = nil

	self.galactic_hero_killed_event = gc.Events.GalacticHeroKilled
	self.galactic_hero_killed_event:attach_listener(self.on_galactic_hero_killed, self)
end

function HuntTargetAMission:update()
	--Logger:trace("entering HuntTargetAMission:update")
	if self.Active == true then
		self:UpdateDisplay()

		if self.TimeActive ~= nil then
			self.TimeActive = self.TimeActive - 1
			if self.TimeActive == 0 then
				self:Failed()
				self.Active = false
			end
		end
		if self.HuntTargetALocationCurrent ~= nil and self.Active == true then
			if self.HuntTargetACountCurrent ~= nil and self.HuntTargetACountCurrent > 0 then
				self.HuntTargetALocationCurrent.Attach_Particle_Effect("Breaking_Supply_Lines_Particle")
			end
		end
	end
end

function HuntTargetAMission:Begin(reward_group, week_start)
	--Logger:trace("entering HuntTargetAMission:Begin")
	if self.Active == true then
		return
	end
	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository.xml")
	self.TimeSinceAssigned = 0

	self.RewardGroupTable = reward_group
	self.Dialog = "DIALOG_INTERVENTION_MASTERFILE_"..self.RewardGroupTable.DialogName

	local active_enemy_only = true
	if self.is_ftgu == true then
		active_enemy_only = false
	end

	self.HuntTargetALocationCurrent = StoryUtil.FindTargetPlanet(self.player, true, false, 1, active_enemy_only)

	if self.HuntTargetALocationCurrent == nil then
		return
	end

	local HuntTargetAOwner = self.HuntTargetALocationCurrent.Get_Owner()
	local HuntTargetAOwnerName = HuntTargetAOwner.Get_Faction_Name()
	local HuntTargetAOwnerAlias = CONSTANTS.ALIASES[HuntTargetAOwner.Get_Faction_Name()]

	local BaseConvoyOptionsTable = require("eawx-plugins/intervention-missions/ConvoyHuntTarget_Table")
	BaseConvoyOptionsTable = BaseConvoyOptionsTable.HUNTTARGETA
	local TargetConvoyOptionsTable = {}

	for _,entry in pairs(BaseConvoyOptionsTable) do
		if entry[3] == nil then
			table.insert(TargetConvoyOptionsTable,entry)
		else
			for _,faction_name_or_alias in pairs(entry[3]) do
				if faction_name_or_alias == HuntTargetAOwnerName or faction_name_or_alias == HuntTargetAOwnerAlias then
					table.insert(TargetConvoyOptionsTable,entry)
				end
			end
		end
	end

	local convoyUnitIndex = GameRandom.Free_Random(1, table.getn(TargetConvoyOptionsTable))

	self.HuntTargetAUnitName = TargetConvoyOptionsTable[convoyUnitIndex][1]
	self.HuntTargetAUnit = Find_Object_Type(self.HuntTargetAUnitName)
	self.HuntTargetACountCurrent = TargetConvoyOptionsTable[convoyUnitIndex][2]

	local convoy_list = {}
	for i=1,self.HuntTargetACountCurrent do
		table.insert(convoy_list, self.HuntTargetAUnitName)
	end

	local convoy_unit_list = SpawnList(convoy_list, self.HuntTargetALocationCurrent, HuntTargetAOwner, false, false)
	self.HuntTargetAFleet = Assemble_Fleet(convoy_unit_list)

	if self.HuntTargetAFleet == nil then
		return
	end

	self.TimerStart = week_start
	self.TimeActive = GameRandom.Free_Random(5, 10)
	self.EndTime = self.TimerStart + self.TimeActive
	self.TimeActive = self.TimeActive + 1

	self.Reward, self.RewardCount, self.RewardError = MissionUtil.SelectReward(self.player, self.RewardGroupTable.RewardName, 2)

	self:UpdateDisplay()

	self.Active = true

	local tag = "HUNTTARGETA"
	crossplot:publish("MISSION_STARTED", tag)

	Story_Event("HUNTTARGETA_ASSIGN")
end

function HuntTargetAMission:UpdateDisplay()
	--Logger:trace("entering HuntTargetAMission:UpdateDisplay")
	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository.xml")
	local event = plot.Get_Event("HuntTargetA_01")
	event.Set_Dialog(self.Dialog)
	event.Clear_Dialog_Text()

	self.HuntTargetALocationCurrent = self.HuntTargetAFleet.Get_Parent_Object()
	event.Add_Dialog_Text("TEXT_INTERVENTION_HUNTTARGET_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_HUNT", self.HuntTargetAUnit)
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.HuntTargetACountCurrent)
	if TestValid(self.HuntTargetALocationCurrent) then
		event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", self.HuntTargetALocationCurrent)
	else
		event.Add_Dialog_Text("TEXT_INTERVENTION_HUNTTARGET_TRANSIT")
	end
	event.Add_Dialog_Text("TEXT_NONE")

	--Try to turn these into a mission library function after basic testing.
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD")
	if self.RewardError then
		event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", self.RewardError)
	else
		event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", Find_Object_Type(self.Reward))
	end
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.RewardCount)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.TimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.EndTime)
end

function HuntTargetAMission:Fulfil()
	--Logger:trace("entering HuntTargetAMission:Fulfil")
	local RewardLocation = StoryUtil.FindFriendlyPlanet(self.player)

	if RewardLocation ~= nil then
		for i=1,self.RewardCount do
			SpawnList({self.Reward}, RewardLocation, self.player, true, false)
		end
	else 
		RewardLocation = "(No safe location available; reward not granted)"
	end

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository.xml")
	local event = plot.Get_Event("HuntTargetA_02")
	event.Set_Dialog(self.Dialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_HUNTTARGET_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_HUNT_COMPLETE", self.HuntTargetAUnit)
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.HuntTargetACountCurrent)
	event.Add_Dialog_Text("TEXT_NONE")

	--Try to turn these into a mission library function after basic testing.
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD")
	if self.RewardError then
		event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", self.RewardError)
	else
		event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", Find_Object_Type(self.Reward))
	end
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.RewardCount)
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", RewardLocation)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.TimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.EndTime)

	if self.RewardGroupTable.GroupSupport == "LEGITIMACY" then
		crossplot:publish("INCREASE_LEGITIMACY", self.RewardGroupTable.DialogName, self.RewardGroupTable.SupportArg)
	elseif self.RewardGroupTable.GroupSupport then
		crossplot:publish("INCREASE_FAVOUR", self.RewardGroupTable.GroupSupport, self.RewardGroupTable.SupportArg)
	end

	self:Reset()

	Story_Event("HUNTTARGETA_COMPLETE")
end

function HuntTargetAMission:Failed()
	--Logger:trace("entering HuntTargetAMission:Failed")

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository.xml")
	local event = plot.Get_Event("HuntTargetA_04")
	event.Set_Dialog(self.Dialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_HUNTTARGET_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_HUNT_FAILED", self.HuntTargetAUnit)
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", self.HuntTargetACountCurrent)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.TimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.EndTime)

	if self.RewardGroupTable.GroupSupport == "LEGITIMACY" then
		crossplot:publish("INCREASE_LEGITIMACY", self.RewardGroupTable.DialogName, (0 - self.RewardGroupTable.SupportArg))
	elseif self.RewardGroupTable.GroupSupport then
		crossplot:publish("INCREASE_FAVOUR" , self.RewardGroupTable.GroupSupport, (0 - self.RewardGroupTable.SupportArg))
	end

	convoy_despawn_list = Find_All_Objects_Of_Type(self.HuntTargetAUnitName)
	for _,unit in pairs(convoy_despawn_list) do
		if TestValid(unit) then
			unit.Despawn()
		end
	end

	self:Reset()

	Story_Event("HUNTTARGETA_FAILED")
end


function HuntTargetAMission:on_galactic_hero_killed(hero_type_name)
	--Logger:trace("entering HuntTargetAMission:on_galactic_hero_killed")

	if self.Active == true then
		if hero_type_name == self.HuntTargetAUnitName then
			self.HuntTargetACountCurrent = self.HuntTargetACountCurrent - 1

			if self.HuntTargetACountCurrent == 0 then
				self:Fulfil()
			else
				self:UpdateDisplay()
			end
		end
	end
end

function HuntTargetAMission:Reset()
	--Logger:trace("entering HuntTargetAMission:Reset")
	self.Active = false
	self.Dialog = nil
	self.TimerStart = nil
	self.TimeActive = nil
	self.EndTime = nil
	self.Reward = nil
	self.RewardCount = 0
	self.HuntTargetAUnit = nil
	self.HuntTargetACountCurrent = nil
	self.HuntTargetALocationCurrent = nil
	self.HuntTargetAFleet = nil

	local tag = "HUNTTARGETA"
	crossplot:publish("MISSION_COMPLETE", tag)
end

return HuntTargetAMission