return {
	Fighters = {
		["PDF_Z95_HEADHUNTER_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(3)},
			HOSTILE = {Initial = 1, Reserve = 1},
			SECTOR_FORCES = {Initial = 1, Reserve = 1},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 1}
		},
		["TWIN_ION_ENGINE_STARFIGHTER_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(3)}
		},
		["SKIRMISH_LAC"] = {
			EMPIRE = {Initial = 1, Reserve = 0},
			HOSTILE = {Initial = 1, Reserve = 0},
			SECTOR_FORCES = {Initial = 1, Reserve = 0},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 0}
		},
		["CLOAKSHAPE_SQUADRON"] = {
			HUTT_CARTELS = {Initial = 1, Reserve = 1}
		},
		["SKIRMISH_LIGHT_MINSTREL_YACHT"] = {
			HUTT_CARTELS = {Initial = 2, Reserve = 0}
		}
	},
	Scripts = {"turn-station", "fighter-spawn"},
	Flags = {HANGAR = true}
}