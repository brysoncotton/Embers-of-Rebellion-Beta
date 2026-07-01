return {
	Ship_Crew_Requirement = 45,
	Fighters = {
		["CLOAKSHAPE_STOCK_SQUADRON_HALF"] = {
			DEFAULT = {Initial = 1, Reserve = 2, HeroOverride = {{"PADME_AMIDALA"}, {"N1_SQUADRON_HALF"}}}
		},
		["LIGHT_BOMBER_HALF"] = {
			DEFAULT = {Initial = 1, Reserve = 0}
		}
	},
	Native = "SECTOR_FORCES",
	Scripts = {"multilayer", "fighter-spawn"},
	Flags = {HANGAR = true}
}