require("deepcore/std/class")
require("PGStoryMode")
require("PGSpawnUnits")
require("eawx-util/StoryUtil")
require("eawx-util/MissionUtil")

require("eawx-plugins/intervention-missions/missions/BuildStructuresGround")
require("eawx-plugins/intervention-missions/missions/BuildStructuresSpace")
require("eawx-plugins/intervention-missions/missions/CreditIncome")
require("eawx-plugins/intervention-missions/missions/CrewIncome")
require("eawx-plugins/intervention-missions/missions/HuntTargetA")
require("eawx-plugins/intervention-missions/missions/HuntTargetB")
require("eawx-plugins/intervention-missions/missions/RaiseInfluence")
require("eawx-plugins/intervention-missions/missions/RaiseInfrastructure")
require("eawx-plugins/intervention-missions/missions/Recon")
require("eawx-plugins/intervention-missions/missions/TakePlanetAny")
require("eawx-plugins/intervention-missions/missions/TakePlanetEnemy")

---@class MissionHandlerHuman
MissionHandlerHuman = class()

function MissionHandlerHuman:new(gc, player, is_ftgu)
	self.player = player
	self.is_ftgu = is_ftgu

	self.potential_targets = {}

	self.CurrentTime = 0
	self.ActiveMissions = 0
	self.TimeSinceAssigned = 0
	self.DefaultHumanMissionFrequency = 4
	self.HumanMissionFrequency = 4
	self.HumanMaxMissions = 3

	self.era = GlobalValue.Get("CURRENT_ERA")

	FactionTable = require("eawx-plugins/intervention-missions/factions/FactionTables_"..player.Get_Faction_Name())

	self.BaseRewardGroups = FactionTable.RewardGroups
	self.EligibleRewardGroups = {}
	self.RewardGroupDetails = FactionTable.RewardGroupDetails
	self.Missions = FactionTable.Missions

	self.BuildStructuresGroundMission = BuildStructuresGroundMission(gc, self.player)
	self.BuildStructuresSpaceMission = BuildStructuresSpaceMission(gc, self.player)
	self.CreditIncomeMission = CreditIncomeMission(gc, self.player)
	self.CrewIncomeMission = CrewIncomeMission(gc, self.player)
	self.HuntTargetAMission = HuntTargetAMission(gc, self.player, self.is_ftgu)
	self.HuntTargetBMission = HuntTargetBMission(gc, self.player, self.is_ftgu)
	--self.RaiseInfluenceMission = RaiseInfluenceMission(gc, self.player)
	self.RaiseInfrastructureMission = RaiseInfrastructureMission(gc, self.player)
	self.ReconMission = ReconMission(gc, self.player)
	self.TakePlanetAnyMission = TakePlanetAnyMission(gc, self.player)
	self.TakePlanetEnemyMission = TakePlanetEnemyMission(gc, self.player, self.is_ftgu)

	crossplot:subscribe("MISSION_STARTED", self.mission_increment, self)
	crossplot:subscribe("MISSION_COMPLETE", self.mission_decrement, self)

	--TR New Republic Chief of State handling
	self.human_is_new_republic = false
	if Find_Object_Type("icw") ~= nil then
		if self.player == Find_Player("Rebel") then
			self.human_is_new_republic = true
		end
	end
end

function MissionHandlerHuman:update()
	--Logger:trace("entering MissionHandlerHuman:Update")
	self.CurrentTime = self.CurrentTime + 1

	if EvaluatePerception("Planet_Ownership", self.player) == 0 then
		return
	end

	--TR New Republic Chief of State handling
	if self.human_is_new_republic == true then
		if GlobalValue.Get("ChiefOfState") == "DUMMY_CHIEFOFSTATE_MOTHMA" then
			self.HumanMissionFrequency = self.DefaultHumanMissionFrequency - 1
		else
			self.HumanMissionFrequency = self.DefaultHumanMissionFrequency
		end
	end

	self.TimeSinceAssigned = self.TimeSinceAssigned + 1

	if self.TimeSinceAssigned >= self.HumanMissionFrequency then
		self.TimeSinceAssigned = 0
		if self.ActiveMissions <= self.HumanMaxMissions then
			self:AssignNewMission()
		end
	end

	self.BuildStructuresGroundMission:update()
	self.BuildStructuresSpaceMission:update()
	self.CreditIncomeMission:update()
	self.CrewIncomeMission:update()
	self.HuntTargetAMission:update()
	self.HuntTargetBMission:update()
	--self.RaiseInfluenceMission:update()
	self.RaiseInfrastructureMission:update()
	self.ReconMission:update()
	self.TakePlanetAnyMission:update()
	self.TakePlanetEnemyMission:update()
--these don't exist
	--self.RiotMission:update()
	--self.SabotageMission:update()
	--self.AssassinationMission:update()
	--self.PrisonerRescueMission:update()
	--self.ExfiltrationMission:update()
end

function MissionHandlerHuman:AssignNewMission()
	local RewardGamble
	local RunningTotal = 0
	local NewMissionName = nil
	local loop_escaper = 0

	repeat
		RewardGamble = GameRandom.Free_Random(1, 100)
		for mission_name,mission_attributes in pairs(self.Missions) do
			RunningTotal = RunningTotal + mission_attributes.chance

			if RewardGamble <= RunningTotal then
				if mission_attributes.active == false then
					NewMissionName = mission_name
				end
				break
			end
		end
		loop_escaper = loop_escaper + 1
	until NewMissionName ~= nil or loop_escaper == 25

	if NewMissionName == nil then
		return
	end

	local reward_group = self:determine_group()

	self.Missions[NewMissionName].active = true

	if NewMissionName == "BUILDSTRUCTURESGROUND" then
		self.BuildStructuresGroundMission:Begin(reward_group, self.CurrentTime)
	elseif NewMissionName == "BUILDSTRUCTURESSPACE" then
		self.BuildStructuresSpaceMission:Begin(reward_group, self.CurrentTime)
	elseif NewMissionName == "CREDITINCOME" then
		self.CreditIncomeMission:Begin(reward_group, self.CurrentTime)
	elseif NewMissionName == "CREWINCOME" then
		self.CrewIncomeMission:Begin(reward_group, self.CurrentTime)
	elseif NewMissionName == "HUNTTARGETA" then
		self.HuntTargetAMission:Begin(reward_group, self.CurrentTime)
	elseif NewMissionName == "HUNTTARGETB" then
		self.HuntTargetBMission:Begin(reward_group, self.CurrentTime)
	--elseif NewMissionName == "RAISE_INFLUENCE" then
		-- self.RaiseInfluenceMission:Begin(reward_group, self.CurrentTime)
	elseif NewMissionName == "RAISEINFRASTRUCTURE" then
		self.RaiseInfrastructureMission:Begin(reward_group, self.CurrentTime)
	elseif NewMissionName == "RECON" then
		self.ReconMission:Begin(reward_group, self.CurrentTime)
	elseif NewMissionName == "TAKEPLANETANY" then
		self.TakePlanetAnyMission:Begin(reward_group, self.CurrentTime)
	elseif NewMissionName == "TAKEPLANETENEMY" then
		self.TakePlanetEnemyMission:Begin(reward_group, self.CurrentTime)
	end
end

function MissionHandlerHuman:determine_group()
	self:GetEligibleRewardGroups()

	local FactionIndex = GameRandom.Free_Random(1, table.getn(self.EligibleRewardGroups))
	local faction_info = self.EligibleRewardGroups[FactionIndex]

	local reward_group = self.RewardGroupDetails[faction_info]

	return reward_group
end

function MissionHandlerHuman:GetEligibleRewardGroups()
	self.EligibleRewardGroups = {}

	for RewardGroupName,DetailTable in pairs(self.RewardGroupDetails) do
		if DetailTable.SupportArg ~= nil then
			for _,v in pairs(CONSTANTS.ALL_FACTIONS_NOT_NEUTRAL) do
				if RewardGroupName == v then
					if EvaluatePerception("Planet_Ownership", Find_Player(RewardGroupName)) > 0 then
						table.insert(self.EligibleRewardGroups,RewardGroupName)
					end
					break
				end
			end
		end
	end

	if table.getn(self.EligibleRewardGroups) == 0 then
		self.EligibleRewardGroups = self.BaseRewardGroups
	end
end

function MissionHandlerHuman:mission_increment(tag)
	--Logger:trace("entering MissionHandlerHuman:mission_increment")
	self.ActiveMissions = self.ActiveMissions + 1
	self.Missions[tag].active = true
end

function MissionHandlerHuman:mission_decrement(tag)
	--Logger:trace("entering MissionHandlerHuman:mission_decrement")
	self.ActiveMissions = self.ActiveMissions - 1
	self.Missions[tag].active = false
end

return MissionHandlerHuman
