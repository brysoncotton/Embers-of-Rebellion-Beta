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
--*   @Author:              Mord
--*   @Date:                2023-08-27T21:24:23-05:00
--*   @Project:             Imperial Civil War
--*   @Filename:            Sort.lua
--*   @Last modified by:    Mord
--*   @Last modified time:  2023-11-04T17:25:23-05:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************

function SortKeys(input_table,asc_desc)
	local inner_table = {}

	for input_key,input_value in pairs(input_table) do
		table.insert(inner_table,{input_key,input_value})	   
	end

	local return_table = {}

	local sort_fn =
	function(a,b) 
		return a[2] < b[2]
	end

	table.sort(inner_table,sort_fn)

	if asc_desc == "asc" then
		for inner_key,inner_value in ipairs(inner_table) do
			return_table[inner_key] = inner_value[1]
		end
	end

	if asc_desc == "desc" then
		local array_size = table.getn(inner_table)
		
		for inner_key,inner_value in ipairs(inner_table) do
			return_table[array_size-inner_key+1] = inner_value[1]
		end
	end

	return return_table
end

function SortKeysByElement(input_table,element_name,asc_desc)
	local inner_table = {}

	for input_key,input_value in pairs(input_table) do
		table.insert(inner_table,{input_key,input_value[element_name]})
	end
	
	local return_table = {}

	local sort_fn =
	function(a,b)
		if a[2] and not b[2] then
			return true
		elseif not a[2] and b[2] then
			return false
		elseif not a[2] and not b[2] then
			return false
		else
			return a[2] < b[2]
		end
	end

	table.sort(inner_table,sort_fn)

	if asc_desc == "asc" then
		for inner_key,inner_value in ipairs(inner_table) do
			return_table[inner_key] = inner_value[1]
		end
	end

	if asc_desc == "desc" then
		local array_size = table.getn(inner_table)
		
		for inner_key,inner_value in ipairs(inner_table) do
			return_table[array_size-inner_key+1] = inner_value[1]
		end
	end

	return return_table
end
