return {
	dwelling_type = "PARTISAN",
	can_be_influenced = false,

	group_name = "MANDALORIAN",
	random_allegiance = false,
	Allegiances = {"DEFENDER"},

	Spawn_Units = {
		["PARTISAN_MANDALORIAN_SQUAD"] = {
			DEFAULT = {Initial = 3, Reserve = 6},
		}
	},
	Scripts = {"partisan-allegiance"},
}