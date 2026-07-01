--*************************************** Microjump Ability **************************************** 
--==================================================================================================
--[[ 
 _______ _                              _       _____                                 
 |__   __| |                            ( )     |  __ \                                
    | |  | |__  _ __ __ ___      ___ __ |/ ___  | |__) |_____   _____ _ __   __ _  ___ 
    | |  | '_ \| '__/ _` \ \ /\ / / '_ \  / __| |  _  // _ \ \ / / _ \ '_ \ / _` |/ _ \
    | |  | | | | | | (_| |\ V  V /| | | | \__ \ | | \ \  __/\ V /  __/ | | | (_| |  __/
    |_|  |_| |_|_|  \__,_| \_/\_/ |_| |_| |___/ |_|  \_\___| \_/ \___|_| |_|\__, |\___|
                                                                             __/ |     
                                                                            |___/      
]] 

require("PGStateMachine") 
require("PGCommands")
require("PGStoryMode") 
TM = require("TRGameModeTransactions")

function Definitions()

  DebugMessage("%s -- In Definitions", tostring(Script))

  jumpInProgress = false
  Define_State("State_Init", State_Init);
  
end

function State_Init(message)
  if message == OnEnter then
    if Get_Game_Mode() ~= "Space" then
      ScriptExit()
    end


  elseif message == OnUpdate then
    if Object.Are_Engines_Online() then
      if Object.Is_Ability_Active("TURBO") and not jumpInProgress then
		Object.Suspend_Locomotor(true)
        Register_Timer(JumpToHyperSpace, 9)
        jumpInProgress = true
      end
    end
  end
end

function JumpToHyperSpace()
  local transaction = TM.CreateSpawnTransaction(Object.Get_Type().Get_Name(), Object.Get_Owner().Get_Faction_Name())
  TM.RegisterTransaction(transaction)
  Object.Hyperspace_Away()   
  Cancel_Timer(JumpToHyperSpace)
  ScriptExit()
end





