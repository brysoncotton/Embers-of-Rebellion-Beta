return {
	Fighters = {
		["PDF_Z95_HEADHUNTER_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(3)},
			HOSTILE = {Initial = 1, Reserve = 1},
			SECTOR_FORCES = {Initial = 1, Reserve = 1},
			INDEPENDENT_FORCES = {Initial = 1, Reserve = 1}
		},
		["TWIN_ION_ENGINE_STARFIGHTER_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(3)}
		},
		["NANTEX_SQUADRON"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 1},
			COMMERCE_GUILD = {Initial = 1, Reserve = 1},
			REBEL = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(3)}
		},
		["MANKVIM_SQUADRON"] = {
			REBEL = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(3)}
		},
		["SCARAB_SQUADRON"] = {
			TECHNO_UNION = {Initial = 1, Reserve = 1},
			TRADE_FEDERATION = {Initial = 1, Reserve = 1}
		},
		["SKIRMISH_LAC"] = {
			EMPIRE = {Initial = 1, Reserve = 1}
		},
		["SKIRMISH_DIAMOND_FRIGATE"] = {
			BANKING_CLAN = {Initial = 1, Reserve = 1},
			COMMERCE_GUILD = {Initial = 1, Reserve = 1},
			REBEL = {Initial = 1, Reserve = 1},
			TECHNO_UNION = {Initial = 1, Reserve = 1},
			TRADE_FEDERATION = {Initial = 1, Reserve = 1}
		},
		["CLOAKSHAPE_SQUADRON"] = {
			HUTT_CARTELS = {Initial = 1, Reserve = 1},
		},
		["SKIRMISH_LIGHT_MINSTREL_YACHT"] = {
			HUTT_CARTELS = {Initial = 2, Reserve = 2}
		}
	},
	Scripts = {"turn-station", "fighter-spawn"}
}