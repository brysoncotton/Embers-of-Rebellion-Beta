return {
	Ship_Crew_Requirement = 2500,
	Fighters = {
		["LIGHT_FIGHTER"] = {
			DEFAULT = {Initial = 2, Reserve = 6}
		},
		["HEAVY_FIGHTER"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		},
		["LIGHT_BOMBER"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		},
		["LIGHT_BOMBER2"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		}
	},
	Native = "CIS",
	Scripts = {"multilayer", "fighter-spawn", "tactical-superlaser"}
}