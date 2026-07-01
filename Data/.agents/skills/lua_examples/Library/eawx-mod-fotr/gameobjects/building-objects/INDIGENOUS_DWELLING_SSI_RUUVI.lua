return {
	dwelling_type = "PARTISAN",
	can_be_influenced = true,

	group_name = "SSI_RUUVI",
	random_allegiance = false,
	Allegiances = {"INDEPENDENT_FORCES"},

	Spawn_Units = {
		["PARTISAN_SSI_RUUVI_SQUAD"] = {
			DEFAULT = {Initial = 1, Reserve = 2},
		}
	},
	Scripts = {"partisan-allegiance"},
}