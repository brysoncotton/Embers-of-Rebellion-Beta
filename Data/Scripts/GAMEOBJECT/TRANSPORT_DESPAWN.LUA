--[[ 
000000000000000000000 0000000       000000000000000000000000000   00000000000000000 00000000000000000     00000000000000
000000000000000000000 00000000     00000000000000000000000000000  00000000000000000 0000000000000000000  000000000000000
000000000000000000000 0000000000  0000000000000000000000000000000 00000000000000000 0000000000000000000  000000000000000
    0000000           0000000000 000000000000000000     00000000  0000000           00000000     000000  000000000      
    00000000000000    00000000000000000000000000000000000000000   0000000000000     0000000000000000000   0000000000    
    00000000000000    000000000000000000000000000000000000000000  0000000000000     00000000000000000      00000000000  
    0000000           00000000000000000000000000000     000000000 0000000           000000000000000           00000000  
    00000000000000000000000000000000000000000000000      00000000000000000000000000000000000000000000000000000000000000 
    0000000000000000000000000  0000 00000000000000000000000000000 00000000000000000000000000  0000000000000000000000000 
    0000000000000000000000000  000  000000000000000000000000000   00000000000000000000000000    0000000000000000000000     

     000000000000     0000000000000000
  000000000000000000  0000000000000000
 00000000000000000000 0000000000000000
00000000     00000000 0000000         
0000000       000000000000000000000   
0000000       000000000000000000000   
00000000      0000000 0000000         
000000000000000000000 0000000         
  000000000000000000  0000000         
    0000000000000     0000000         

0000000000000000    00000000000000000 000000000000000000   00000000000000000 0000000          0000000          0000000     000000000000     00000000    0000000
000000000000000000  00000000000000000 00000000000000000000 00000000000000000 0000000          0000000          0000000  000000000000000000  0000000000  0000000
0000000000000000000 00000000000000000 00000000000000000000 00000000000000000 0000000          0000000          0000000 00000000000000000000 00000000000 0000000
00000000     000000 0000000           0000000     00000000 0000000           0000000          0000000          000000000000000      000000000000000000000000000
0000000000000000000 00000000000000    000000000000000000   00000000000000    0000000          0000000          000000000000000       00000000000000000000000000
00000000000000000   00000000000000    0000000000000000000  00000000000000    0000000          0000000          00000000000000        00000000000000000000000000
000000000000000     0000000           0000000      000000000000000           0000000          0000000          000000000000000      000000000000000000000000000
000000000000000000000000000000000000000000000     00000000000000000000000000000000000000000000000000000000000000000000 00000000000000000000 0000000000000000000
00000000  000000000000000000000000000000000000000000000000 00000000000000000000000000000000000000000000000000000000000  000000000000000000  00000000  000000000
00000000    000000000000000000000000000000000000000000000  00000000000000000000000000000000000000000000000000000000000    00000000000000    00000000   00000000

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 P R I V A T E   C O D E   D O   N O T   D I S T R I B U T E   O R   C O P Y   W I T H O U T   P E R M I S S I O N
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        File: 

    	Original Author: Embers of Rebellion Development Team

        Editing Author: Embers of Rebellion Development Team

		Based off of code from Strategic Improvement Mod

        DateTime: 2026-03-21 10:16

        Revision: #1
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--]]

require("PGStateMachine")
require("PGStoryMode")

function Definitions()
    ServiceRate = 1
    ability_name = "REPLENISH_WINGMEN"
    
    -- State Definitions
    Define_State("State_Init", State_Init)
    Define_State("State_AI_Autofire", State_AI_Autofire)
    Define_State("State_Human_No_Autofire", State_Human_No_Autofire)
    Define_State("State_Human_Autofire", State_Human_Autofire)
end

function State_Init(message)
    if message == OnEnter then
        -- Safety check for Land mode
        if Get_Game_Mode() == "Land" then
            Object.Despawn()
            return
        end

        -- Diverge logic based on player type
        if Object.Get_Owner().Is_Human() then
            Set_Next_State("State_Human_No_Autofire")
        else
            Set_Next_State("State_AI_Autofire")
        end
    end
end

-- Shared logic to handle the actual ability activation
function Manage_Ability_Activation()
    if Object.Get_Contained_Object_Count() > 12.0 then
        if Object.Is_Ability_Ready(ability_name) then
            Object.Activate_Ability(ability_name, false)
        end
    end
end

function State_AI_Autofire(message)
    if message == OnUpdate then
        Manage_Ability_Activation()
    end     
end

function State_Human_No_Autofire(message)
    if message == OnUpdate then
        -- Transition to autofire state if the player toggles it on
        if Object.Is_Ability_Autofire(ability_name) then
            Set_Next_State("State_Human_Autofire")
        end     
    end
end

function State_Human_Autofire(message)
    if message == OnUpdate then
        -- If player turns off autofire, switch states
        if not Object.Is_Ability_Autofire(ability_name) then
            Set_Next_State("State_Human_No_Autofire")
            return
        end

        Manage_Ability_Activation()
    end
end