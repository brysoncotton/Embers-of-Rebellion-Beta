require("deepcore/std/plugintargets")

return {
	type = "plugin",
	target = PluginTargets.interval(1),
	init = function(self, ctx)
		PersistentDamageTactical = require("eawx-plugins-gameobject-space/persistent-damage-tactical/PersistentDamageTactical")
		local unit_entry = ModContentLoader.get_object_script(Object.Get_Type().Get_Name())
		if unit_entry.Flags then
			if unit_entry.Flags.DAMAGEINHERIT ~= nil then
				return PersistentDamageTactical(ModContentLoader.get_object_script(unit_entry.Flags.DAMAGEINHERIT).Source_Unit_Name)
			end
		end
		return PersistentDamageTactical(unit_entry.Source_Unit_Name)
	end
}
