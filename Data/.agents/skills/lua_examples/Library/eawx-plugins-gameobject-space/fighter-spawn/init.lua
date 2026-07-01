require("deepcore/std/plugintargets")

return {
	type = "plugin",
	target = PluginTargets.always(),
	init = function(self, ctx)
		FighterSpawn = require("eawx-plugins-gameobject-space/fighter-spawn/FighterSpawn")
		local unit_entry = ModContentLoader.get_object_script(Object.Get_Type().Get_Name())
		if unit_entry.Flags then
			if unit_entry.Flags.FIGHTERINHERIT ~= nil then
				return FighterSpawn(ModContentLoader.get_object_script(unit_entry.Flags.FIGHTERINHERIT))
			end
		end
		return FighterSpawn(unit_entry)
	end
}
