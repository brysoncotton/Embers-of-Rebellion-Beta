return {
	Fighters = {
		["VULTURE_BROWN_SQUADRON_DOUBLE"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 8},
			COMMERCE_GUILD = {Initial = 1, Reserve = 8},
			EMPIRE = {Initial = 1, Reserve = 8},
			HOSTILE = {Initial = 1, Reserve = 8},
			REBEL = {Initial = 1, Reserve = 8, TechLevel = EqualTo(1)},
			SECTOR_FORCES = {Initial = 1, Reserve = 8},
			TECHNO_UNION = {Initial = 1, Reserve = 8},
			TRADE_FEDERATION = {Initial = 1, Reserve = 8},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 8}
		},
		["VULTURE_SQUADRON_DOUBLE"] = {
			REBEL = {Initial = 1, Reserve = 8, TechLevel = GreaterOrEqualTo(2)}
		},
		["NANTEX_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 4}
		},
		["HYENA_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 8}
		},
		["ADVANCED_ESTAP_BROWN_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(1)}
		},
		["BELBULLAB24_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 4, TechLevel = GreaterOrEqualTo(2)}
		},
		["SKIRMISH_DIAMOND_FRIGATE"] = {
			DEFAULT = {Initial = 2, Reserve = 2}
		}
	},
	Scripts = {"fighter-spawn"}
}