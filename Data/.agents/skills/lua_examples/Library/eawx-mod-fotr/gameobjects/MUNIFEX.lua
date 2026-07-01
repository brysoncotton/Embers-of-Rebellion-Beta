return {
	Ship_Crew_Requirement = 39,
	Fighters = {
		["CLOAKSHAPE_SQUADRON_HALF"] = {
			EMPIRE = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(2)},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(2)}
		},
		["MANKVIM_SQUADRON_HALF"] = {
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(2)}
		},
		["TWIN_ION_ENGINE_STARFIGHTER_SQUADRON_HALF"] = {
			EMPIRE = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(2)}
		},
		["ELITE_FIGHTER_HALF"] = {
			DEFAULT = {Initial = 1, Reserve = 1},
			EMPIRE = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(99)},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(99)},
		}
	},
	Native = "CIS",
	Scripts = {"multilayer", "fighter-spawn"},
	Flags = {HANGAR = true}
}