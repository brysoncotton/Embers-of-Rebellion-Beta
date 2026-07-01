require("deepcore/std/plugintargets")

return {
    type = "plugin",
    target = PluginTargets.always(),
    init = function(self, ctx)
        CompanySpawn = require("eawx-plugins-gameobject-land/company-spawn/CompanySpawn")
        local unit_entry = ModContentLoader.get_ground_object_script(Object.Get_Type().Get_Name())
		if unit_entry.Flags then
			if unit_entry.Flags.COMPANYINHERIT ~= nil then
				return CompanySpawn(ModContentLoader.get_ground_object_script(unit_entry.Flags.COMPANYINHERIT))
			end
		end
        return CompanySpawn(unit_entry)
    end
}
