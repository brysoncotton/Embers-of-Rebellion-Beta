return {
	dwelling_type = "PARTISAN",
	can_be_influenced = true,

	group_name = "AILON_NOVA_GUARD",
	random_allegiance = false,
	Allegiances = {"ATTACKER", "DEFENDER"},

	Spawn_Units = {
		["PARTISAN_AILON_NOVA_GUARD_SQUAD"] = {
			DEFAULT = {Initial = 1, Reserve = 2},
		}
	},
	Scripts = {"partisan-allegiance"},
}