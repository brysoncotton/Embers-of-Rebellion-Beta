return {
	dwelling_type = "PARTISAN",
	can_be_influenced = true,

	group_name = "NIMBUS",
	random_allegiance = false,
	Allegiances = {"CIS"},

	Spawn_Units = {
		["NIMBUS_COMMANDO_SQUAD"] = {
			DEFAULT = {Initial = 3, Reserve = 6},
		}
	},
	Scripts = {"partisan-allegiance"},
}