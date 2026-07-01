return {
	Fighters = {
		["PDF_Z95_HEADHUNTER_SQUADRON_HALF"] = {
			EMPIRE = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(3)},
			HOSTILE = {Initial = 1, Reserve = 1},
			SECTOR_FORCES = {Initial = 1, Reserve = 1},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 1}
		},
		["TWIN_ION_ENGINE_STARFIGHTER_SQUADRON_HALF"] = {
			EMPIRE = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(3)}
		},
		["2_WARPOD_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 1, ResearchType = "RepublicWarpods"},
			SECTOR_FORCES = {Initial = 1, Reserve = 1, TechLevel = EqualTo(1)},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 1, TechLevel = EqualTo(1)},
			HOSTILE = {Initial = 1, Reserve = 1, TechLevel = EqualTo(1)}
		},
		["BTLS1_Y_WING_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 1, ResearchType = "~RepublicWarpods"},
			SECTOR_FORCES = {Initial = 1, Reserve = 1, TechLevel = GreaterOrEqualTo(2)},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 1, TechLevel = GreaterOrEqualTo(2)},
			HOSTILE = {Initial = 1, Reserve = 1, TechLevel = GreaterOrEqualTo(2)}
		},
		["SKIRMISH_LAC"] = {
			DEFAULT = {Initial = 1, Reserve = 1}
		}
	},
	Scripts = {"fighter-spawn"}
}