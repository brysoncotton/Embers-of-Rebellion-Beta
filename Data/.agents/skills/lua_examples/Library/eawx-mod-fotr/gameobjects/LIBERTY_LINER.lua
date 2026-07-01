return {
	Ship_Crew_Requirement = 310,
	Fighters = {
		["LIGHT_FIGHTER"] = {
			DEFAULT = {Initial = 1, Reserve = 1}
		},
		["LIGHT_BOMBER"] = {
			DEFAULT = {Initial = 1, Reserve = 1}
		}
	},
	Native = "SECTOR_FORCES",
	Scripts = {"multilayer", "fighter-spawn", "single-unit-retreat"}
}