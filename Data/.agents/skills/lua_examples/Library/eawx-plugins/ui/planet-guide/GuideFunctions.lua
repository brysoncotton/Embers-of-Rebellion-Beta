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
--*   @Author:              [TR]Jorritkarwehr
--*   @Date:                2024-04-11T01:27:01+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            GuideFunctions.lua
--*   @Last modified by:    [TR]Jorritkarwehr
--*   @Last modified time:  2024-04-11T01:27:01+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************

function Create_Planet_List(planetlist)
	local PlanetTable = require("eawx-util/PlanetTable")
	
	local returnvalue = ""
	local list = {}
	local notlist =  {}

	if table.getn(planetlist) == 0 then
		returnvalue = "All"
	end
	for i, planet in ipairs(planetlist) do
		local check = FindPlanet(planet)
        if not TestValid(check) then
			table.insert(notlist, PlanetTable[planet])
		else
			table.insert(list, PlanetTable[planet])
		end
	end
	
	table.sort(list)
	table.sort(notlist)
	
	for i, planet in ipairs(list) do
		if i > 1 then
			returnvalue = returnvalue .. ", "
		end
		returnvalue = returnvalue .. planet
	end
	
	if table.getn(notlist) > 0 then
		if table.getn(list) > 0 then
			returnvalue = returnvalue .. ", "
		end
		returnvalue = returnvalue .. "[Not in GC: "
		for i, planet in ipairs(notlist) do
			if i > 1 then
				returnvalue = returnvalue .. ", "
			end
			returnvalue = returnvalue .. planet
		end
		returnvalue = returnvalue .. "]"
	end
	
	return returnvalue
end

function Create_Corp_Entry(event, name, object, planetlist)
	local gameConstants = ModContentLoader.get("GameConstants")
	local factions = gameConstants.PLAYABLE_FACTIONS
	local abbrevs = gameConstants.ALL_FACTION_ABBREVIATIONS
	
	local returnvalue = name
	
	local planets = Create_Planet_List(planetlist)
	if string.sub(planets, 1, 1) == "[" then
		return
	end
	returnvalue = returnvalue .. " - " .. planets .. " | "
	local object = Find_Object_Type(object)
	
	local addcomma = false
	local list = {}
	local notlist = {}
	
	for i, faction in ipairs(factions) do
		local player = Find_Player(faction)
		if object.Is_Affiliated_With(player) then
			if object.Is_Build_Locked(player) or object.Is_Obsolete(player) then
				table.insert(notlist, abbrevs[faction])
			else
				table.insert(list, abbrevs[faction])
			end
		end
	end
	
	--table.sort(list)
	--table.sort(notlist)
	
	for i, faction in ipairs(list) do
		if i > 1 then
			returnvalue = returnvalue .. ", "
		end
		returnvalue = returnvalue .. faction
	end
	
	if table.getn(notlist) > 0 then
		if table.getn(list) > 0 then
			returnvalue = returnvalue .. ", "
		end
		returnvalue = returnvalue .. "[Locked: "
		for i, faction in ipairs(notlist) do
			if i > 1 then
				returnvalue = returnvalue .. ", "
			end
			returnvalue = returnvalue .. faction
		end
		returnvalue = returnvalue .. "]"
	end
	
	event.Add_Dialog_Text(returnvalue)
end

function Create_Influence_Entry(planet, units, influences)
	local returnvalue = Create_Planet_List({planet}) .. ": Can build "
	
	for i, unit in ipairs(units) do
		if i > 1 then
			returnvalue = returnvalue .. ", "
		end
		returnvalue = returnvalue .. unit .. " at " .. influences[i] .. " influence"
	end
	return returnvalue
end