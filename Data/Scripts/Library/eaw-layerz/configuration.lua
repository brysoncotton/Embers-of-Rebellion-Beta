---@class Configuration
Configuration = {
    ---@type table<string,function>[]
    ---A map of anonymous objects that define the mapping between the category mask and (a subset of) bones of the `LAYER_DUMMY_TYPE`.
    CATEGORY_MAP = {
        {
            ---@type string
            ID = "Corvette",
            ---@return integer l_min minimum offset
            ---@return integer l_max maximum offset
            ---**TODO:** Update to desired range.
            get_range = function() return -75, 75 end
        },
        {
            -- @type string
            ID = "Frigate",
            ---@return integer l_min minimum offset
            ---@return integer l_max maximum offset
            ---**TODO:** Update to desired range.
            get_range = function() return -150, 300 end
        },
        {
            -- @type string
            ID = "Capital",
            ---@return integer l_min minimum offset
            ---@return integer l_max maximum offset
            ---**TODO:** Update to desired range.
            get_range = function() return -250, 350 end

        },
        ---@return integer l_min minimum offset
        ---@return integer l_max maximum offset
        ---**TODO:** Update to desired range.
        default = function() return -50, 50 end
    }
}

return Configuration
