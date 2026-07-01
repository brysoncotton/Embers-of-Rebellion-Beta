return {
	Fighters = {
		["PDF_Z95_HEADHUNTER_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, TechLevel = LessOrEqualTo(2), Reserve = 2}
		},
		["MISSILE_TIE_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, TechLevel = GreaterThan(2), Reserve = 2}
		},
		["2_WARPOD_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 1, Reserve = 2, ResearchType = "RepublicWarpods"},
			SECTOR_FORCES = {Initial = 1, Reserve = 2},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 2}
		},
		["CLONE_BTLB_Y_WING_SQUADRON_DOUBLE"] = {
			CIS = {Initial = 1, Reserve = 2},
			EMPIRE = {Initial = 1, Reserve = 2, ResearchType = "~RepublicWarpods"},
			HOSTILE = {Initial = 1, Reserve = 2}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}