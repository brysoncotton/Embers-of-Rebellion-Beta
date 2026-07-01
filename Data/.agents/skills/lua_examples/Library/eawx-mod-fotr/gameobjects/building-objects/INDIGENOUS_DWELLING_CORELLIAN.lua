return {
	dwelling_type = "PARTISAN",
	can_be_influenced = true,

	group_name = "CORELLIAN",
	random_allegiance = false,
	Allegiances = {"DEFENDER"},

	Spawn_Units = {
		["PARTISAN_CORELLIAN_SQUAD"] = {
			DEFAULT = {Initial = 1, Reserve = 2},
		}
	},
	Scripts = {"partisan-allegiance"},
}