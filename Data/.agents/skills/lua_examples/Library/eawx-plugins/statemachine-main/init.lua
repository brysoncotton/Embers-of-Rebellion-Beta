require("deepcore/std/plugintargets")
require("deepcore/statemachine/DeepCoreStateMachine")

return {
    target = PluginTargets.always(),
    init = function(self, ctx)
        local dsl_init = require("deepcore/statemachine/dsl/init")
        return DeepCoreStateMachine.from_script("eawx-plugins/statemachine-main/"..tostring(ctx.id), dsl_init(ctx), {})
    end
}