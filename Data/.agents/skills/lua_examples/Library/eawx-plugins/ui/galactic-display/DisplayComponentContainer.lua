require("deepcore/std/class")
require("eawx-plugins/ui/galactic-display/ContentBox")

---@class DisplayComponentContainer
DisplayComponentContainer = class()

function DisplayComponentContainer:new()
    ---@private
    self.__display_components = {}
    self.__components_by_name = {}
    self.__last_cycle_update = 1
end

function DisplayComponentContainer:add_display_component(name, component, space_after)
    space_after = space_after or 0
    local box = ContentBox(component, space_after)
    table.insert(self.__display_components, box)
    self.__components_by_name[name] = component
end

function DisplayComponentContainer:get_component(name)
    return self.__components_by_name[name]
end

function DisplayComponentContainer:update()
    local begin_updating = false

    --always update all display components on cycle end
    local current_cycle = Dirty_Floor(GetCurrentTime() / 40) + 1
    if current_cycle > self.__last_cycle_update then
        begin_updating = true
        self.__last_cycle_update = current_cycle
    end

    for i, component in ipairs(self.__display_components) do
        if begin_updating or component:needs_update() then
            begin_updating = true
            component:render()
        end
    end
end
