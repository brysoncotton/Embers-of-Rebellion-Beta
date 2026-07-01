require("deepcore/std/class")
require("PGStoryMode")
require("PGSpawnUnits")
require("eawx-util/StoryUtil")
require("eawx-util/MissionUtil")
require("eawx-plugins/ui/galactic-display/ShipCrewDisplayComponent")

---@class CrewIncomeMission
CrewIncomeMission = class()

function CrewIncomeMission:new(gc, player)
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
	self.CurrentShipCrewIncome = nil
	self.TargetShipCrewIncome = nil

	self.MaxCrewIncomeForMission = 300

	self.p_human = Find_Player("local")	
	
end

function CrewIncomeMission:update()
	--Logger:trace("entering CrewIncomeMission:update")
	if self.Active == true then
		self.CurrentShipCrewIncome = GlobalValue.Get("CURRENT_CREW_INCOME")
		if self.CurrentShipCrewIncome == nil then
			self.CurrentShipCrewIncome = 0
		end

		if self.CurrentShipCrewIncome >= self.TargetShipCrewIncome then
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

function CrewIncomeMission:Begin(reward_group, week_start)
	--Logger:trace("entering CrewIncomeMission:Begin")
	if self.Active == true then
		return
	end

	local current_crew_income = GlobalValue.Get("CURRENT_CREW_INCOME")
	if current_crew_income == nil then
		current_crew_income = 0
	end

	if current_crew_income > self.MaxCrewIncomeForMission then
		return
	end

	self.TimeSinceAssigned = 0

	self.RewardGroupTable = reward_group
	self.Dialog = "DIALOG_INTERVENTION_MASTERFILE_"..self.RewardGroupTable.DialogName

	self.TargetShipCrewIncome = GameRandom.Free_Random(6, 14) * 5 + current_crew_income

	self.Active = true
	
	self.TimerStart = week_start
	self.TimeActive = GameRandom.Free_Random(3, 5)
	self.EndTime = self.TimerStart + self.TimeActive
	self.TimeActive = self.TimeActive + 1

	self.Reward, self.RewardCount, self.RewardError = MissionUtil.SelectReward(self.player, self.RewardGroupTable.RewardName, 1)

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository.xml")
	local event = plot.Get_Event("CrewIncome_01")
	event.Set_Dialog(self.Dialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_CREWINCOME_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_CREWINCOME_TARGET", self.TargetShipCrewIncome)
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
	
	local tag = "CREWINCOME"
	crossplot:publish("MISSION_STARTED", tag)
	
	Story_Event("CREWINCOME_ASSIGN")
end

function CrewIncomeMission:Fulfil()
	--Logger:trace("entering CrewIncomeMission:Fulfil")
	local RewardLocation = StoryUtil.FindFriendlyPlanet(self.player)

	if RewardLocation ~= nil then
		for i=1,self.RewardCount do
			SpawnList({self.Reward}, RewardLocation, self.player, true, false)
		end
	else 
		RewardLocation = "(No safe location available; reward not granted)"
	end

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository.xml")
	local event = plot.Get_Event("CrewIncome_02")
	event.Set_Dialog(self.Dialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_CREWINCOME_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_CREWINCOME_TARGET_COMPLETE", self.TargetShipCrewIncome)
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

	Story_Event("CREWINCOME_COMPLETE")
end

function CrewIncomeMission:Failed()
	--Logger:trace("entering CrewIncomeMission:Failed")

	local plot = Get_Story_Plot("Conquests\\Events\\MissionRepository.xml")
	local event = plot.Get_Event("CrewIncome_04")
	event.Set_Dialog(self.Dialog)
	event.Clear_Dialog_Text()

	event.Add_Dialog_Text("TEXT_INTERVENTION_CREWINCOME_OBJECTIVE")
	event.Add_Dialog_Text("TEXT_INTERVENTION_CREWINCOME_TARGET_FAILED", self.TargetShipCrewIncome)
	event.Add_Dialog_Text("TEXT_INTERVENTION_CREWINCOME_TARGET_CURRENT", self.CurrentShipCrewIncome)
	event.Add_Dialog_Text("TEXT_NONE")

	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_START", self.TimerStart)
	event.Add_Dialog_Text("TEXT_INTERVENTION_TIMER_END", self.EndTime)

	if self.RewardGroupTable.GroupSupport == "LEGITIMACY" then
		crossplot:publish("INCREASE_LEGITIMACY", self.RewardGroupTable.DialogName, (0 - self.RewardGroupTable.SupportArg))
	elseif self.RewardGroupTable.GroupSupport then
		crossplot:publish("INCREASE_FAVOUR" , self.RewardGroupTable.GroupSupport, (0 - self.RewardGroupTable.SupportArg))
	end

	self:Reset()

	Story_Event("CREWINCOME_FAILED")
end

function CrewIncomeMission:Reset()
	--Logger:trace("entering CrewIncomeMission:Reset")
	self.Active = false
	self.Dialog = nil
	self.TimerStart = nil
	self.TimeActive = nil
	self.EndTime = nil
	self.Reward = nil
	self.RewardCount = 0
	self.CurrentShipCrewIncome = nil
	self.TargetShipCrewIncome = nil

	local tag = "CREWINCOME"
	crossplot:publish("MISSION_COMPLETE", tag)
end

return CrewIncomeMission