return {
	Ship_Crew_Requirement = 110,
	Fighters = {
		["LIGHT_FIGHTER"] = {
			DEFAULT = {Initial = 1, Reserve = 1, HeroOverride = {{"PADME_AMIDALA"}, {"N1_SQUADRON"}}}
		},
		["Z95_BOMBER_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		}
	},
	Native = "SECTOR_FORCES",
	Scripts = {"multilayer", "fighter-spawn"}
}