require("deepcore/std/plugintargets")

return {
    type = "plugin",
    target = PluginTargets.always(),
    init = function(self, ctx)
        GroupSpawn = require("eawx-plugins-gameobject-space/group-spawn/GroupSpawn")
        local unit_entry = ModContentLoader.get_object_script(Object.Get_Type().Get_Name())
		if unit_entry.Flags then
			if unit_entry.Flags.COMPANYINHERIT ~= nil then
				return GroupSpawn(ModContentLoader.get_object_script(unit_entry.Flags.COMPANYINHERIT))
			end
		end
        return GroupSpawn(unit_entry)
    end
}
