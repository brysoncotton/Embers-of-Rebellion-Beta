require("deepcore/std/plugintargets")

return {
    type = "plugin",
    target = PluginTargets.interval(3),
    init = function(self, ctx)
        PartisanAllegiance = require("eawx-plugins-gameobject-land/partisan-allegiance/PartisanAllegiance")
        local structure_entry = ModContentLoader.get_ground_structure_object_script(Object.Get_Type().Get_Name())
		if structure_entry.Flags ~= nil then
			if structure_entry.Flags.COMPANYINHERIT ~= nil then
				structure_entry = ModContentLoader.get_ground_structure_object_script(structure_entry.Flags.COMPANYINHERIT)
			end
		end
        return PartisanAllegiance(structure_entry)
    end
}
