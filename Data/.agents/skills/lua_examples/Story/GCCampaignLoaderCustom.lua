require("PGBase")
require("pgevents")
require("PGStateMachine")
require("PGStoryMode")
require("deepcore/crossplot/crossplot")
require("eawx-util/StoryUtil")

function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))
	
	crossplot:galactic()
	crossplot:subscribe("CUSTOM_START_OPTION", Load_GC)

	StoryModeEvents = {
		Universal_Story_Start = Set_Tech,
		Delayed_Initialize = Initialize
	}

end

function Set_Tech(message)
  if message == OnEnter then
		Find_Player("local").Give_Money(1000)
    
  end
end

function Initialize(message)
    if message == OnEnter then	
		crossplot:publish("POPUPEVENT", "CUSTOM_GC", {"FTGU_LAYOUT", "SMALL", "MEDIUM", "LARGE", "INFLUENCERS"}, { },
				{ }, { },
				{ }, { },
				{ }, { },
				"CUSTOM_START_OPTION")
		Story_Event("LOOP_CLEAR")
	else
		crossplot:update()
    end
end

function Load_GC(choice)
	--Match the order of the index in factions.xml
	liveFactionTable = {
            ["REBEL"] = 0,
            ["EMPIRE"] = 1,
            --["UNDERWORLD"] = 2,
            --["NEUTRAL"] = 3,
            --["HOSTILE"] = 4,
            --["INDEPENDENT_FORCES"] = 5,
            ["HUTT_CARTELS"] = 6,
            ["BANKING_CLAN"] = 7,
            ["COMMERCE_GUILD"] = 8,
            ["TECHNO_UNION"] = 9,
            ["TRADE_FEDERATION"] = 10,
            ["SECTOR_FORCES"] = 11,
            --["MANDALORIANS"] = 12,
        }
	
    local faction_index = 0
    local faction_name = "REBEL"
	for faction, id in pairs(liveFactionTable) do
		if Find_Player(faction).Is_Human() then
            faction_index = id
            faction_name = faction
			break
		end
	end
	
	local campaign_name = "Sandbox_Custom"
	if choice == "CUSTOM_GC_LARGE" then
		campaign_name = campaign_name .. "_Large"
	end
	if choice == "CUSTOM_GC_MEDIUM" then
		campaign_name = campaign_name .. "_Medium"
	end
	if choice == "CUSTOM_GC_SMALL" then
		campaign_name = campaign_name .. "_Small"
	end
	if choice == "CUSTOM_GC_INFLUENCERS" then
		campaign_name = campaign_name .. "_Influencers"
	end
	
	campaign_name = campaign_name .. "_" .. faction_name
    

    plot = Get_Story_Plot("Conquests\\Progressive\\GCLoader.xml")

    loadEvent = plot.Get_Event("Load_Another_GC")

    loadEvent.Set_Reward_Parameter(0, campaign_name)
    loadEvent.Set_Reward_Parameter(1, faction_index)
	local difficulty = Find_Player("Empire").Get_Difficulty()
    if faction_name == "EMPIRE" then
      difficulty = Find_Player("Rebel").Get_Difficulty()
    end
    local difficulty_index = 1
    if difficulty == "Easy" then
      difficulty_index = 0
    elseif difficulty == "Hard" then
      difficulty_index = 2
    end
    loadEvent.Set_Reward_Parameter(2, difficulty_index)

	
    Story_Event("LOAD_CAMPAIGN_EVENT")
end

function Perpetuator(message)
    if message == OnEnter then
    else
		crossplot:update()
    end
end