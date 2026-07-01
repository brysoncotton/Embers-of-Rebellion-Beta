--**************************************************************************************************
--*    _______ __                                                                                  *
--*   |_     _|  |--.----.---.-.--.--.--.-----.-----.                                              *
--*     |   | |     |   _|  _  |  |  |  |     |__ --|                                              *
--*     |___| |__|__|__| |___._|________|__|__|_____|                                              *
--*    ______                                                                                      *
--*   |   __ \.-----.--.--.-----.-----.-----.-----.                                                *
--*   |      <|  -__|  |  |  -__|     |  _  |  -__|                                                *
--*   |___|__||_____|\___/|_____|__|__|___  |_____|                                                *
--*                                   |_____|                                                      *
--*                                                                                                *
--*                                                                                                *
--*       File:              AbstractResourceManager.lua                                           *
--*       File Created:      Sunday, 23rd February 2020 08:26                                      *
--*       Author:            [TR] Corey                                                            *
--*       Last Modified:     Sunday, 23rd February 2020 10:22                                      *
--*       Modified By:       [TR] Corey                                                            *
--*       Copyright:         Thrawns Revenge Development Team                                      *
--*       License:           This code may not be used without the author's explicit permission    *
--**************************************************************************************************
require("pgevents")

---@param tag string
function HintPrompt(tag)
    local plot = Get_Story_Plot("Conquests\\Player_Agnostic_Plot.xml")
    local player_guide_warning = plot.Get_Event("Helper_Display")

    player_guide_warning.Clear_Dialog_Text()
    player_guide_warning.Add_Dialog_Text("TEXT_DOCUMENTATION_HELPER_"..tag)

    Story_Event("NEW_PLAYER_HELPER")
end