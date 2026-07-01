return {
	dwelling_type = "PARTISAN",
	can_be_influenced = true,

	group_name = "ZABRAK",
	random_allegiance = false,
	Allegiances = {"REPUBLIC"},

	Spawn_Units = {
		["PARTISAN_ZABRAK_SQUAD"] = {
			DEFAULT = {Initial = 1, Reserve = 2},
		}
	},
	Scripts = {"partisan-allegiance"},
}