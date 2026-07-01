return {
	dwelling_type = "PARTISAN",
	can_be_influenced = true,

	group_name = "MANDALLIAN",
	random_allegiance = false,
	Allegiances = {"MANDALORIANS"},

	Spawn_Units = {
		["PARTISAN_MANDALLIAN_SQUAD"] = {
			DEFAULT = {Initial = 1, Reserve = 2},
		}
	},
	Scripts = {"partisan-allegiance"},
}