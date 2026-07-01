return {
	dwelling_type = "PARTISAN",
	can_be_influenced = true,

	group_name = "SELKATH",
	random_allegiance = false,
	Allegiances = {"DEFENDER"},

	Spawn_Units = {
		["PARTISAN_SELKATH_SQUAD"] = {
			DEFAULT = {Initial = 1, Reserve = 2},
		}
	},
	Scripts = {"partisan-allegiance"},
}