return {
	Ship_Crew_Requirement = 20,
	Fighters = {
		["LIGHT_FIGHTER_HALF"] = {
			DEFAULT = {Initial = 1, Reserve = 1},
			CIS = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(99)},
		},
		["SCARAB_SQUADRON_HALF"] = {
			CIS = {Initial = 1, Reserve = 1}
		}
	},
	Native = "SECTOR_FORCES",
	Scripts = {"multilayer", "fighter-spawn", "single-unit-retreat"},
	Flags = {HANGAR = true}
}