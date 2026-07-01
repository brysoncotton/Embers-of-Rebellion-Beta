require("deepcore/std/class")
require("PGStoryMode")
require("PGSpawnUnits")
require("eawx-util/StoryUtil")
require("eawx-util/MissionUtil")

---@class RaiseInfluenceMission
RaiseInfluenceMission = class()

function RaiseInfluenceMission:new(gc, player)
	self.player = player
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
	self.Target = nil
	self.TargetPlanet = nil
	self.InfluenceLevel = 0
end

function RaiseInfluenceMission:update()
	--Logger:trace("entering RaiseInfluenceMission:update")
	if self.Active == true then
		self.InfluenceLevel = EvaluatePerception("Planet_Influence_Value", self.player, self.TargetPlanet)
		if (self.InfluenceLevel >= self.Target) then
			self:Fulfil()
		end
		if self.TimeActive ~= nil then
			self.TimeActive = self.TimeActive - 1
			if self.TimeActive == 0 then
				self:Failed()
			end
		end
	end
end

function RaiseInfluenceMission:Begin(reward_group, week_start)
	--Logger:trace("entering RaiseInfluenceMission:Begin")
	if self.Active == true then
		return
	end

	self.TargetPlanet = MissionUtil.FindLowInfluencePlanet(self.player, 1)

	if self.TargetPlanet == nil then
		return
	end

	self.TimeSinceAssigned = 0

	self.RewardGroupTable = reward_group
	self.Dialog = "DIALOG_INTERVENTION_MASTERFILE_"..self.RewardGroupTable.DialogName

	self.Target = GameRandom.Free_Random(6, 8)

	self.Active = true
	
	self.TimerStart = week_start
	self.TimeActive = GameRandom.Free_Random(6, 10)
	self.EndTime = self.TimerStart + self.TimeActive
	self.TimeActive = self.TimeActive + 1

	self.Reward, self.RewardCount, self.RewardError = MissionUtil.SelectReward(self.player, self.RewardGroupTable.RewardName, 2)

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository.xml")
	local event = plot.Get_Event("Raise_Influence_01")
	event.Set_Dialog(self.Dialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_RAISE_INFLUENCE_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", self.TargetPlanet)
	event.Add_Dialog_Text("TEXT_INTERVENTION_RAISE_INFLUENCE_TARGET", self.Target)
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

	self.Active = true
	
	local tag = "RAISE_INFLUENCE"
	crossplot:publish("MISSION_STARTED", tag)
	
	Story_Event("RAISE_INFLUENCE_ASSIGN")
end

function RaiseInfluenceMission:Fulfil()
	--Logger:trace("entering RaiseInfluenceMission:Fulfil")
	local RewardLocation = StoryUtil.FindFriendlyPlanet(self.player)

	if RewardLocation ~= nil then
		for i=1,self.RewardCount do
			SpawnList({self.Reward}, RewardLocation, self.player, true, false)
		end
	else 
		RewardLocation = "(No safe location available; reward not granted)"
	end

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository.xml")
	local event = plot.Get_Event("Raise_Influence_02")
	event.Set_Dialog(self.Dialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_RAISE_INFLUENCE_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", self.TargetPlanet)
	event.Add_Dialog_Text("TEXT_INTERVENTION_RAISE_INFLUENCE_TARGET_COMPLETE", self.Target)
	event.Add_Dialog_Text("TEXT_NONE")

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

	Story_Event("RAISE_INFLUENCE_COMPLETE")
end

function RaiseInfluenceMission:Failed()
	--Logger:trace("entering RaiseInfluenceMission:Failed")

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository.xml")
	local event = plot.Get_Event("Raise_Influence_04")
	event.Set_Dialog(self.Dialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_RAISE_INFLUENCE_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", self.TargetPlanet)
	event.Add_Dialog_Text("TEXT_INTERVENTION_RAISE_INFLUENCE_TARGET_FAILED", self.Target)
	event.Add_Dialog_Text("TEXT_INTERVENTION_RAISE_INFLUENCE_TARGET_CURRENT", self.InfluenceLevel)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.TimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.EndTime)

	if self.RewardGroupTable.GroupSupport == "LEGITIMACY" then
		crossplot:publish("INCREASE_LEGITIMACY", self.RewardGroupTable.DialogName, (0 - self.RewardGroupTable.SupportArg))
	elseif self.RewardGroupTable.GroupSupport then
		crossplot:publish("INCREASE_FAVOUR" , self.RewardGroupTable.GroupSupport, (0 - self.RewardGroupTable.SupportArg))
	end

	self:Reset()

	Story_Event("RAISE_INFLUENCE_FAILED")
end

function RaiseInfluenceMission:Reset()
	--Logger:trace("entering RaiseInfluenceMission:Reset")
	self.Active = false
	self.Dialog = nil
	self.TimerStart = nil
	self.TimeActive = nil
	self.EndTime = nil
	self.Reward = nil
	self.RewardCount = 0
	self.Target = nil
	self.TargetPlanet = nil
	self.InfluenceLevel = 0

	local tag = "RAISE_INFLUENCE"
	crossplot:publish("MISSION_COMPLETE", tag)
end

return RaiseInfluenceMission