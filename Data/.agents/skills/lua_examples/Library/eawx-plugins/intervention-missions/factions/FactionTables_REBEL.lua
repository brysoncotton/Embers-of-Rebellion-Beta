return {
	Missions = {
		["BUILDSTRUCTURESGROUND"] = {active = false, chance = 12},
		["BUILDSTRUCTURESSPACE"] = {active = false, chance = 12},
		["CREDITINCOME"] = {active = false, chance = 4},
		["CREWINCOME"] = {active = false, chance = 4},
		["HUNTTARGETA"] = {active = false, chance = 12},
		["HUNTTARGETB"] = {active = false, chance = 12},
		--["RAISE_INFLUENCE"] = {active = false, chance = 8},
		["RAISEINFRASTRUCTURE"] = {active = false, chance = 8},
		["RECON"] = {active = false, chance = 12},
		["TAKEPLANETANY"] = {active = false, chance = 12},
		["TAKEPLANETENEMY"] = {active = false, chance = 12},
	},
	RewardGroups = {
		"COMMERCE_GUILD",
		"BANKING_CLAN",
		"TRADE_FEDERATION",
		"TECHNO_UNION",
		"CIS",
		"PDF"
	},
	RewardGroupDetails = {
		["COMMERCE_GUILD"] = {
			DialogName = "CIS_CG",
			RewardName = "COMMERCE_GUILD",
			GroupSupport = "COMMERCE_GUILD",
			SupportArg = 5
		},
		["BANKING_CLAN"] = {
			DialogName = "CIS_IGBC",
			RewardName = "IGBC",
			GroupSupport = "BANKING_CLAN",
			SupportArg = 5
		},
		["TRADE_FEDERATION"] = {
			DialogName = "CIS_TF",
			RewardName = "TRADE_FEDERATION",
			GroupSupport = "TRADE_FEDERATION",
			SupportArg = 5
		},
		["TECHNO_UNION"] = {
			DialogName = "CIS_TU",
			RewardName = "TECHNO_UNION",
			GroupSupport = "TECHNO_UNION",
			SupportArg = 5
		},
		["CIS"] = {
			DialogName = "CIS",
			RewardName = "CIS"
		},
		["PDF"] = {
			DialogName = "PDF",
			RewardName = "PDF"
		}
	}
}
