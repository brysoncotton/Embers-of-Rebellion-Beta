return {
	["RANDOM_MERCENARY"] = {
		BuildDummyName = "RANDOM_MERCENARY",
		RecruiterOptions = {"REBEL"},
		BuildableOptions = {
			["ARGYUS"] = {
				key = "ARGYUS",
				TeamName = "FARO_ARGYUS_TEAM",
				available = true,
				hired = false,
				HireSpeech = "Faro Argyus: At Count Dooku's request, I'll be at your service. I expect to be compensated greatly. \n[Faro Argyus has been hired.]",
				StartYear = -22,
				EndYear = -21
			},
			["VAZUS"] = {
				key = "VAZUS",
				TeamName = "VAZUS_TEAM",
				available = true,
				hired = false,
				HireSpeech = "Vazus Mandrake: Heard you're hiring mercenaries. My men and I are just the type you're looking for. \n[Vazus Mandrake has been hired.]",
			},
			["RONKO_BIST"] = {
				key = "RONKO_BIST",
				TeamName = "RONKO_BIST_TEAM",
				available = true,
				hired = false,
				HireSpeech = "Ronko Bist: Trandosha yearns for freedom from the yoke of the Republic, and I will fight to ensure it. \n[Ronko Bist has been hired.]",
			},
		},
	},
	["RANDOM_BOUNTY_HUNTER"] = {
		BuildDummyName = "RANDOM_BOUNTY_HUNTER",
		RecruiterOptions = {"REBEL","HUTT_CARTELS"},
		BuildableOptions = {
			["BOSSK"] = {
				key = "BOSSK",
				TeamName = "BOSSK_TEAM",
				available = true,
				hired = false,
				HireSpeech = "Bossk: You seek prey? Then I am the best hunter you could ask for. \n[Bossk has been hired.]",
			},
			["DENGAR"] = {
				key = "DENGAR",
				TeamName = "DENGAR_TEAM",
				available = true,
				hired = false,
				HireSpeech = "Dengar: I'm always up for a good score. Nothing better than cracking skulls for credits, heh. \n[Dengar has been hired.]",
			},
			["SHAHAN"] = {
				key = "SHAHAN",
				TeamName = "SHAHAN_ALAMA_TEAM",
				available = true,
				hired = false,
				HireSpeech = "Shahan Alama: I'll take the job, but this time I'll ask for my payment upfront. \n[Shahan Alama has been hired.]",
			},
			["GREEDO"] = {
				key = "GREEDO",
				TeamName = "GREEDO_TEAM",
				available = true,
				hired = false,
				HireSpeech = "Greedo: I may be new to the game, but bounty hunting is in my blood. I'll show you how much I'm worth. \n[Greedo has been hired.]",
			},
			["SALLOW_VIOLECT"] = {
				key = "SALLOW_VIOLECT",
				TeamName = "SALLOW_VIOLECT_TEAM",
				available = true,
				hired = false,
				HireSpeech = "Sallow Violect: I am of the Nova Guard no longer, but the song of battle calls to me still. \n[Sallow Violect has been hired.]",
			},
			["BOBA_FETT"] = {
				key = "BOBA_FETT",
				TeamName = "BOBA_FETT_TEAM",
				available = true,
				hired = false,
				HireSpeech = "Boba Fett: My father taught me all the skills a bounty hunter needs, and I intend to be the best there is. \n[Boba Fett has been hired.]",
				StartYear = -20,
			},
		},
	},
}
