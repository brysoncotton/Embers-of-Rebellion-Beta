--******************************************************************************
--     _______ __
--    |_     _|  |--.----.---.-.--.--.--.-----.-----.
--      |   | |     |   _|  _  |  |  |  |     |__ --|
--      |___| |__|__|__| |___._|________|__|__|_____|
--     ______
--    |   __ \.-----.--.--.-----.-----.-----.-----.
--    |      <|  -__|  |  |  -__|     |  _  |  -__|
--    |___|__||_____|\___/|_____|__|__|___  |_____|
--                                    |_____|
--*   @Author:              [TR]Pox
--*   @Date:                2017-12-22T10:45:35+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            DisplayStructuresUtilities.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2018-03-10T04:14:44+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************

function GameObjectNumber(num)
    if not GameObjectLibrary then
        GameObjectLibrary = ModContentLoader.get("GameObjectLibrary")
    end

    if not GameObjectLibrary.Numbers[num] then
        return nil
    end
    return Find_Object_Type(GameObjectLibrary.Numbers[num])
end
