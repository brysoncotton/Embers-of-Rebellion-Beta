return {
	dwelling_type = "PARTISAN",
	can_be_influenced = false,

	group_name = "WOOKIEE",
	random_allegiance = false,
	Allegiances = {"REPUBLIC_UNLESS_ORDER_66"},

	Spawn_Units = {
		["PARTISAN_WOOKIEE_SQUAD"] = {
			DEFAULT = {Initial = 1, Reserve = 2},
		}
	},
	Scripts = {"partisan-allegiance"},
}