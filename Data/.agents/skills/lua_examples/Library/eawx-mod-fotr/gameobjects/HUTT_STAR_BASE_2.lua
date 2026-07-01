return {
	Fighters = {
		["CLOAKSHAPE_SQUADRON_HALF"] = {
			DEFAULT = {Initial = 1, Reserve = 1},
		},
		["2_WARPOD_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 1, TechLevel = EqualTo(1)},
		},
		["BTLS1_Y_WING_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 1, TechLevel = GreaterOrEqualTo(2)},
		},
		["SKIRMISH_LIGHT_MINSTREL_YACHT"] = {
			DEFAULT = {Initial = 1, Reserve = 1}
		}
	},
	Scripts = {"fighter-spawn"}
}