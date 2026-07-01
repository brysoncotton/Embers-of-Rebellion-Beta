return {
	Fighters = {
		["MORNINGSTAR_A_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		},
		["MORNINGSTAR_B_SQUADRON"] = {
			DEFAULT = {Initial = 3, Reserve = 99}
		},
		["MORNINGSTAR_C_SQUADRON"] = {
			DEFAULT = {Initial = 3, Reserve = 6}
		},
		["SKIRMISH_LIGHT_MINSTREL_YACHT"] = {
			DEFAULT = {Initial = 2, Reserve = 4}
		},
		["SKIRMISH_JUVARD_FRIGATE"] = {
			DEFAULT = {Initial = 4, Reserve = 0}
		},
		["SKIRMISH_BARABBULA_FRIGATE"] = {
			DEFAULT = {Initial = 3, Reserve = 0}
		},
		["SKIRMISH_SZAJIN_CRUISER"] = {
			DEFAULT = {Initial = 2, Reserve = 0}
		}
	},
	Scripts = {"fighter-spawn"},
	Flags = {SHIPYARD = true, HANGAR = true}
}