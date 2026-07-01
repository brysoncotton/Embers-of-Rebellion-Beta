return {
	dwelling_type = "PARTISAN",
	can_be_influenced = false,

	group_name = "GEONOSIAN",
	random_allegiance = false,
	Allegiances = {"CIS"},

	Spawn_Units = {
		["PARTISAN_GEONOSIAN_SQUAD"] = {
			DEFAULT = {Initial = 1, Reserve = 2},
		}
	},
	Scripts = {"partisan-allegiance"},
}