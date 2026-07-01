return {
	Ship_Crew_Requirement = 155,
	Fighters = {
		["FIGHTER"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		},
		["BOMBER"] = {
			DEFAULT = {Initial = 1, Reserve = 2},
			HUTT_CARTELS = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(99)}
		},
		["BOMBER2"] = {
			HUTT_CARTELS = {Initial = 1, Reserve = 2}
		}
	},
	Native = "SECTOR_FORCES",
	FighterFlags = {"NO_TIEFIGHTERS"},
	Scripts = {"multilayer", "fighter-spawn", "single-unit-retreat"}
}