return {
	dwelling_type = "PARTISAN",
	can_be_influenced = true,

	group_name = "DUROS",
	random_allegiance = false,
	Allegiances = {"DEFENDER"},

	Spawn_Units = {
		["PARTISAN_DUROS_SQUAD"] = {
			DEFAULT = {Initial = 1, Reserve = 2},
		}
	},
	Scripts = {"partisan-allegiance"},
}