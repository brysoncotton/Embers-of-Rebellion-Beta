return {
	dwelling_type = "PARTISAN",
	can_be_influenced = true,

	group_name = "VODRAN",
	random_allegiance = false,
	Allegiances = {"HUTT_CARTELS"},

	Spawn_Units = {
		["PARTISAN_VODRAN_SQUAD"] = {
			DEFAULT = {Initial = 1, Reserve = 2},
		}
	},
	Scripts = {"partisan-allegiance"},
}