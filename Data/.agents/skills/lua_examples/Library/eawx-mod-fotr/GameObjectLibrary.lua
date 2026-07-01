
require("eawx-util/Comparators")

GameObjectLibrary = {
    Interdictors = {
        "Interdiction_Minefield_Container",
        "Galleon",
        "DH_Omni",
        "Jarl_Pelta"
    },
    Numbers = {
        "Display_One",
        "Display_Two",
        "Display_Three",
        "Display_Four",
        "Display_Five",
        "Display_Six",
        "Display_Seven",
        "Display_Eight",
        "Display_Nine",
        "Display_Ten"
    },
    OrbitalStructures = {
    --Construction Stations
        ["TEMPLATE_SHIPYARD_LEVEL_ONE"] = {
            Text = "TEXT_DISPLAY_SHIPYARD1",
            Equation = "Planet_Has_Shipyard_One"
        },
        ["TEMPLATE_SHIPYARD_LEVEL_TWO"] = {
            Text = "TEXT_DISPLAY_SHIPYARD2",
            Equation = "Planet_Has_Shipyard_Two"
        },
        ["TEMPLATE_SHIPYARD_LEVEL_THREE"] = {
            Text = "TEXT_DISPLAY_SHIPYARD3",
            Equation = "Planet_Has_Shipyard_Three"
        },
        ["TEMPLATE_SHIPYARD_LEVEL_FOUR"] = {
            Text = "TEXT_DISPLAY_SHIPYARD4",
            Equation = "Planet_Has_Shipyard_Four"
        },
        ["PIRATE_BASE"] = {
            Text = "TEXT_DISPLAY_PIRATE_BASE",
            Equation = "Planet_Has_Pirate_Base"
        },
        ["REPUBLIC_NAVAL_COMMAND_CENTRE"] = {
            Text = "TEXT_DISPLAY_REPUBLIC_NAVAL_COMMAND_CENTRE",
            Equation = "Planet_Has_Republic_Naval_Command_Centre"
        },
        ["SABAOTH_HQ"] = {
            Text = "TEXT_DISPLAY_SABAOTH_HQ",
            Equation = "Planet_Has_Sabaoth_HQ"
        },

    --Defense Stations
        ["SECONDARY_GOLAN_ONE"] = {
            Text = "TEXT_DISPLAY_SECONDARY_GOLAN_ONE",
            Equation = "Planet_Has_Secondary_Golan_One"
        },
        ["SECONDARY_GOLAN_TWO"] = {
            Text = "TEXT_DISPLAY_SECONDARY_GOLAN_TWO",
            Equation = "Planet_Has_Secondary_Golan_Two"
        },
        ["SECONDARY_HAVEN"] = {
            Text = "TEXT_DISPLAY_SECONDARY_HAVEN",
            Equation = "Planet_Has_Secondary_Haven"
        },
        ["SECONDARY_TF_OUTPOST"] = {
            Text = "TEXT_DISPLAY_SECONDARY_TF_OUTPOST",
            Equation = "Planet_Has_Secondary_TF_Outpost"
        },

    --Econ Stations
        ["TRADESTATION"] = {
            Text = "TEXT_DISPLAY_TRADE",
            Equation = "Planet_Has_Trade_Station"
        },
        ["GOLAN_COLONY_ONE"] = {
            Text = "TEXT_DISPLAY_COLONY_ONE",
            Equation = "Planet_Has_Colony_One"
        },
        ["GOLAN_COLONY_TWO"] = {
            Text = "TEXT_DISPLAY_COLONY_TWO",
            Equation = "Planet_Has_Colony_Two"
        },
        ["MINING_FACILITY_MINERALS_SPACE"] = {
            Text = "TEXT_DISPLAY_MINING_FACILITY_MINERALS",
            Equation = "Planet_Has_Mining_Facility_Minerals_Space"
        },
        ["MINING_FACILITY_SPICE_SPACE"] = {
            Text = "TEXT_DISPLAY_MINING_FACILITY_SPICE",
            Equation = "Planet_Has_Mining_Facility_Spice_Space"
        },
        ["MINING_FACILITY_TIBANNA_SPACE"] = {
            Text = "TEXT_DISPLAY_MINING_FACILITY_TIBANNA",
            Equation = "Planet_Has_Mining_Facility_Tibanna_Space"
        },

        --  ["CREW_RESOURCE_DUMMY"]={
        --      Text="TEXT_DISPLAY_SLAYN_KORPIL"
        --  },
        --    ["PLACEHOLDER_CATEGORY_DUMMY"]={
        --        Text="TEXT_DISPLAY_PLACEHOLDER_CATEGORY_DUMMY"
        --    },
        --    ["NON_CAPITAL_CATEGORY_DUMMY"]={
        --        Text="TEXT_DISPLAY_NON_CAPITAL_CATEGORY_DUMMY"
        --    },
        --    ["CAPITAL_CATEGORY_DUMMY"]={
        --        Text="TEXT_DISPLAY_CAPITAL_CATEGORY_DUMMY"
        --    },
        --    ["STRUCTURE_CATEGORY_DUMMY"]={
        --        Text="TEXT_DISPLAY_STRUCTURE_CATEGORY_DUMMY"
        --    }
    },
    InfluenceLevels = {
        ["INFLUENCE_ONE"] = {},
        ["INFLUENCE_TWO"] = {},
        ["INFLUENCE_THREE"] = {},
        ["INFLUENCE_FOUR"] = {},
        ["INFLUENCE_FIVE"] = {},
        ["INFLUENCE_SIX"] = {},
        ["INFLUENCE_SEVEN"] = {},
        ["INFLUENCE_EIGHT"] = {},
        ["INFLUENCE_NINE"] = {},
        ["INFLUENCE_TEN"] = {},
        ["BONUS_PLACEHOLDER"] = {}
    },
    Units = require("GameObjectList"),
    GroundUnits = require("GroundCompanyList"),
	GroundStructures = require("GroundStructureList")
}
return GameObjectLibrary
