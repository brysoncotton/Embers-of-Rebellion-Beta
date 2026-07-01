return {
	Ship_Crew_Requirement = 5400,
	Fighters = {
		["FIGHTER_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		},
		["INTERCEPTOR_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		},
		["ELITE_FIGHTER"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		},
		["BOMBER_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		}
	},
	Native = "SECTOR_FORCES",
	Scripts = {"multilayer", "fighter-spawn", "persistent-damage-tactical"}
}