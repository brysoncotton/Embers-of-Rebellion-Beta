return {
	Ship_Crew_Requirement = 270,
	Fighters = {
		["LIGHT_FIGHTER"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		},
		["Z95_HEADHUNTER_SQUADRON"] = {
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 2}
		},
		["ELITE_FIGHTER"] = {
			DEFAULT = {Initial = 1, Reserve = 2},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 2, TechLevel = GreaterOrEqualTo(99)}
		},
		["BOMBER2_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		}
	},
	Native = "CIS",
	Scripts = {"multilayer", "fighter-spawn"}
}