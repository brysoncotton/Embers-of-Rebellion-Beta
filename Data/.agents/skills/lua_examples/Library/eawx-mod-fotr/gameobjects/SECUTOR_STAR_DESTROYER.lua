return {
	Ship_Crew_Requirement = 770,
	Fighters = {
		["INTERCEPTOR"] = {
			DEFAULT = {Initial = 3, Reserve = 8}
		},
		["FIGHTER"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		},
		["BOMBER_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		},
		["HEAVY_BOMBER"] = {
			DEFAULT = {Initial = 1, Reserve = 4}
		}
	},
	Native = "SECTOR_FORCES",
	Scripts = {"multilayer", "fighter-spawn"}
}