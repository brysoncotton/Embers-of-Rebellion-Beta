require("deepcore/crossplot/crossplot")
require("eawx-util/StoryUtil")

return {
    on_enter = function(self, state_context)
        --Logger:trace("entering fotr-setup-state:on_enter")
    end,
    on_update = function(self, state_context)
    end,
    on_exit = function(self, state_context)
        local placeholder_table = Find_All_Objects_Of_Type("Placement_Dummy")
        for i, unit in pairs(placeholder_table) do
            unit.Despawn()
        end
    end
}