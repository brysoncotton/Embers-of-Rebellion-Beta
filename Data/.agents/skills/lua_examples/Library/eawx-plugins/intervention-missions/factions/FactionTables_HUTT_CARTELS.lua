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
		"CRIME_PATH",
		"CRIME_PATH",
		"EMPIRE_PATH",
		"ACADEMY",
		"PDF"
	},
	RewardGroupDetails = {
		["CRIME_PATH"] = {
			DialogName = "HUTTS_CRIME",
			RewardName = "CRIME_PATH",
			GroupSupport = "SCUM",
			SupportArg = 1
		},
		["EMPIRE_PATH"] = {
			DialogName = "HUTTS_EMPIRE",
			RewardName = "EMPIRE_PATH",
			GroupSupport = "HUTT_MOBILIZATION",
			SupportArg = 5
		},
		["ACADEMY"] = {
			DialogName = "HUTTS_ACADEMY",
			RewardName = "ACADEMY",
			GroupSupport = "HUTT_MOBILIZATION",
			SupportArg = 5
		},
		["PDF"] = {
			DialogName = "PDF",
			RewardName = "PDF"
		}
	}
}
