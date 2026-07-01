require("deepcore/std/class")
require("deepcore/crossplot/crossplot")
require("PGStoryMode")

---@class OrbitalStructureHandler
OrbitalStructureHandler = class()

function OrbitalStructureHandler:new(gc)
    self.Structure_Table = require("StructureCategoryLists")

    gc.Events.GalacticProductionFinished:attach_listener(self.on_production_finished, self)
    gc.Events.GalacticProductionStarted:attach_listener(self.on_production_queued, self)

    self.structure_swap_warning = Observable()
    self.no_taxes_warning = Observable()
    self.structure_swapped = Observable()
end

function OrbitalStructureHandler:on_production_queued(planet, game_object_type_name)
    --Logger:trace("entering OrbitalStructureHandler:on_production_queued")
    local planet_owner = planet:get_owner()
    local human_player = Find_Player("local")

    if planet_owner == human_player then
        if game_object_type_name == "TAX_AGENCY" then
            local base_income = EvaluatePerception("PlanetTrueBaseIncome", human_player, planet:get_game_object())
            if base_income == 0 then
                self.no_taxes_warning:notify(planet)
            end
        end

        for structure_type, structure_list in pairs(self.Structure_Table) do
            for _, structure in pairs(structure_list) do
                if game_object_type_name == structure then
                    for _, structure in pairs(self.Structure_Table[structure_type]) do
                        if game_object_type_name ~= structure then
                            self:check_existing_structures(planet, game_object_type_name, structure, human_player, structure_type)
                        end
                    end
                end
             end
        end
    else
        return
    end
end

function OrbitalStructureHandler:check_existing_structures(planet,game_object_type_name, structure_object_type, owner, structure_type)
    --Logger:trace("entering OrbitalStructureHandler:check_existing_structures")
    for i, structure in pairs(Find_All_Objects_Of_Type(structure_object_type, owner)) do
        if structure.Get_Planet_Location() == planet:get_game_object() then
            if owner.Is_Human() then
                self.structure_swap_warning:notify(planet, structure_object_type,structure_type)
            end
        end
    end
end

function OrbitalStructureHandler:on_production_finished(planet, game_object_type_name)
    --Logger:trace("entering OrbitalStructureHandler:on_production_finished")
    --Has to be structured differently than other ones since otherwise gunships will crash it.
	local first = Find_First_Object(game_object_type_name)
	if first then
        if first.Is_Category("SpaceStructure") == true or first.Is_Category("Structure") == true then       
            local player = planet:get_owner()
            
            for structure_type, structure_list in pairs(self.Structure_Table) do
                
                for _, structure in pairs(structure_list) do
                    if game_object_type_name == structure then
                        for _, structure in pairs(self.Structure_Table[structure_type]) do
                            if game_object_type_name ~= structure then
                                self:remove_existing_structure(planet, game_object_type_name, structure, player, structure_type)
                            end
                        end
                    end
                end
            end
        else
            return
        end
    end
end

function OrbitalStructureHandler:remove_existing_structure(planet,game_object_type_name, structure_object_type, owner, structure_type)
    --Logger:trace("entering OrbitalStructureHandler:remove_existing_structure")
    for i, structure in pairs(Find_All_Objects_Of_Type(structure_object_type, owner)) do
        if structure.Get_Planet_Location() == planet:get_game_object() then
            local deconstructionSellValue = structure.Get_Game_Scoring_Type().Get_Build_Cost() / 2.0 + 1.0
			owner.Give_Money(deconstructionSellValue)
            structure.Despawn()
            if owner.Is_Human() then
                self.structure_swapped:notify(planet, game_object_type_name,structure_type)
            end
        end
    end
end


return OrbitalStructureHandler
