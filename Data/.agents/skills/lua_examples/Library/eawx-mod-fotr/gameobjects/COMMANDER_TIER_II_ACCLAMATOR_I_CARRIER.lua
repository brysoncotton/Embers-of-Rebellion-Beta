return {
	Ship_Crew_Requirement = 155,
	Fighters = {
		["INTERCEPTOR_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		},
		["BOMBER_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		}
	},
	Native = "SECTOR_FORCES",
	FighterFlags = {"TORRENTKEEP"},
	Scripts = {"multilayer", "fighter-spawn", "single-unit-retreat"}
}