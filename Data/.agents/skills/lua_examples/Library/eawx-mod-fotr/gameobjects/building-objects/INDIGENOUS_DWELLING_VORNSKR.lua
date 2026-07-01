return {
	dwelling_type = "ANIMAL",
	can_be_influenced = true,

	group_name = "VORNSKR",
	random_allegiance = false,
	Allegiances = {"HOSTILE"},

	Spawn_Units = {
		["VORNSKR"] = {
			DEFAULT = {Initial = 10, Reserve = 20},
		}
	},
	Scripts = {"partisan-allegiance"},
}