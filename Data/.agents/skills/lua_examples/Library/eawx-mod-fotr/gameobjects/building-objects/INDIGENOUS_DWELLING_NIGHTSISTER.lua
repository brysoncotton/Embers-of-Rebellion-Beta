return {
	dwelling_type = "PARTISAN",
	can_be_influenced = true,

	group_name = "NIGHSISTER",
	random_allegiance = false,
	Allegiances = {"INDEPENDENT_FORCES"},

	Spawn_Units = {
		["PARTISAN_NIGHSISTER_SQUAD"] = {
			DEFAULT = {Initial = 1, Reserve = 2},
		}
	},
	Scripts = {"partisan-allegiance"},
}