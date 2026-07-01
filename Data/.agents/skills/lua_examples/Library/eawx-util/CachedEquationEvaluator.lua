CachedEquationEvaluator = {
    __important = true
}
setmetatable(
    CachedEquationEvaluator,
    {
        __call = function(_, ...)
            return CachedEquationEvaluator.new(unpack(arg))
        end
    }
)

function CachedEquationEvaluator.new()
    local self = setmetatable({}, {__index = CachedEquationEvaluator})
    self.__equation_results = {}

    return self
end

function CachedEquationEvaluator:reset()
    self.__equation_results = {}
end

function CachedEquationEvaluator:evaluate(equation_name, faction, object)
    if not equation_name then
        return
    end

    if not faction then
        return
    end

    local equation_entry = self:__get_or_create_entry(equation_name, faction, object)

    if not equation_entry.has_result then
        if object then
            equation_entry.result = EvaluatePerception(equation_name, faction, object)
        else
            equation_entry.result = EvaluatePerception(equation_name, faction)
        end
        equation_entry.has_result = true
    end

    return equation_entry.result
end

function CachedEquationEvaluator:__get_or_create_entry(equation_name, faction, object)
    local equation_data = self.__equation_results[equation_name]
    if not equation_data then
        self.__equation_results[equation_name] = {}
        equation_data = self.__equation_results[equation_name]
    end

    local equation_faction_data = equation_data[faction]
    if not equation_faction_data then
        equation_data[faction] = {
            has_result = false,
            result = -1
        }

        equation_faction_data = equation_data[faction]
    end

    if object then
        local equation_object_data = equation_faction_data[object]
        if not equation_object_data then
            equation_faction_data[object] = {
                has_result = false,
                result = -1
            }

            equation_object_data = equation_faction_data[object]
        end

        return equation_object_data
    end

    return equation_faction_data
end

return CachedEquationEvaluator
