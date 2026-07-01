-- in a separate file you can declare your state machine
require("eawx-statemachine/EawXStateMachine")

local state_machine = EawXStateMachine.from_script("eawx-gc-states/FotRProgressiveStates")

-- update the state machine every frame
state_machine:update()

