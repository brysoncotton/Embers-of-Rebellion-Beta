require("deepcore/std/plugintargets")

return {
	type = "plugin",
	target = PluginTargets.always(),
	init = function(self, ctx)
		local unit_entry = ModContentLoader.get_object_script(Object.Get_Type().Get_Name())
		local hull = 0
		local shields = 0
		if unit_entry.Flags then
			if unit_entry.Flags.HULL then
				hull = unit_entry.Flags.HULL
			end
			if unit_entry.Flags.SHIELDS then
				shields = unit_entry.Flags.SHIELDS
			end
		end
		ShoddyWorkmanship = require("eawx-plugins-gameobject-space/shoddy-workmanship/ShoddyWorkmanship")
		return ShoddyWorkmanship(hull,shields)
	end
}
