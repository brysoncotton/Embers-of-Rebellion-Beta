require("deepcore/std/plugintargets")

return {
    type = "plugin",
    target = PluginTargets.always(),
    dependencies = {"fighter-spawn"},
    init = function(self, ctx, fighter_spawn)
		local unit_entry = ModContentLoader.get_object_script(Object.Get_Type().Get_Name())
		local HIMS = false
		if unit_entry.Flags and unit_entry.Flags.HIMS then
			HIMS = true
		end
        SingleUnitRetreat = require("eawx-plugins-gameobject-space/single-unit-retreat/SingleUnitRetreat")
        return SingleUnitRetreat(fighter_spawn, HIMS)
    end
}
