---@param user_string string
function CapitalizeFirstCharacterOfEachSentence(user_string)
	if user_string == nil then
		return ""
	end
	user_string_len = string.len(user_string)
        
    first_char = string.upper(string.sub(user_string,1,1))

    user_string = first_char..string.sub(user_string,2,-1)
    
    local _, count_periods = string.gsub(user_string,"%.","")
    
    if count_periods == 0 then
        return user_string
    end
    
    local period_indices = {}
    local period_index = 0
    
    for i=1,count_periods do
        period_index = string.find(user_string,"%.",period_index + 1)
        table.insert(period_indices,period_index)
    end
    
    for _,value in pairs(period_indices) do
        value = value + 2
        if value <= user_string_len then
            user_string = string.sub(user_string,1,value-1)..string.upper(string.sub(user_string,value,value))..string.sub(user_string,value + 1,-1)
        else
            break
        end
    end
    
    return user_string
end
