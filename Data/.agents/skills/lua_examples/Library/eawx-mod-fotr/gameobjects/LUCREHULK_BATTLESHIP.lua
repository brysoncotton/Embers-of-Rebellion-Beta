return {
	Ship_Crew_Requirement = 1350,
	Fighters = {
		["LIGHT_FIGHTER_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 3},
		},
		["EARLY_SKIPRAY_SQUADRON"] = {
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 4}
		},
		["ELITE_INTERCEPTOR"] = {
			DEFAULT = {Initial = 1, Reserve = 4},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 4, TechLevel = GreaterThan(99)},
		},
		["LIGHT_BOMBER2"] = {
			DEFAULT = {Initial = 1, Reserve = 4}
		}
	},
	Native = "CIS",
	Scripts = {"multilayer", "fighter-spawn"}
}