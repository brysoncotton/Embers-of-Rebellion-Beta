require("deepcore/statemachine/DeepCoreState")

---@param dsl dsl
return function(dsl)
    local policy = dsl.policy
    local effect = dsl.effect

    local initialize = DeepCoreState.with_empty_policy()
    local setup = DeepCoreState.with_empty_policy()
    local era_one = DeepCoreState(require("eawx-states/tech/tech-era-one"))
    local era_two = DeepCoreState(require("eawx-states/tech/tech-era-two"))
    local era_three = DeepCoreState(require("eawx-states/tech/tech-era-three"))
    local era_four = DeepCoreState(require("eawx-states/tech/tech-era-four"))
    local era_five = DeepCoreState(require("eawx-states/tech/tech-era-five"))

    -- Initial setup

    dsl.transition(initialize)
        :to(setup)
        :when(policy:timed(2))
        :end_()
    dsl.transition(setup)
        :to(era_one)
        :when(policy:global_era(1))
        :end_()
    dsl.transition(setup)
        :to(era_two)
        :when(policy:global_era(2))
        :end_()
    dsl.transition(setup)
        :to(era_three)
        :when(policy:global_era(3))
        :end_()
    dsl.transition(setup)
        :to(era_four)
        :when(policy:global_era(4))
        :end_()
    dsl.transition(setup)
        :to(era_five)
        :when(policy:global_era(5))
        :end_()


    -- In-Game Progression

    dsl.transition(era_one)
        :to(era_two)
        :when(policy:global_era(2))
        :end_()
    dsl.transition(era_two)
        :to(era_three)
        :when(policy:global_era(3))
        :end_()
    dsl.transition(era_three)
        :to(era_four)
        :when(policy:global_era(4))
        :end_()
    dsl.transition(era_four)
        :to(era_five)
        :when(policy:global_era(5))
        :end_()

    return initialize
end
