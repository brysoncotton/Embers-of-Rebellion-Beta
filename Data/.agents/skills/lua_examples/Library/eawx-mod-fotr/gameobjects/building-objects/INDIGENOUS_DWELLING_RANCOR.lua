return {
	dwelling_type = "ANIMAL",
	can_be_influenced = true,

	group_name = "RANCOR",
	random_allegiance = false,
	Allegiances = {"HOSTILE"},

	Spawn_Units = {
		["RANCOR"] = {
			DEFAULT = {Initial = 2, Reserve = 4},
		}
	},
	Scripts = {"partisan-allegiance"},
}