return {
    __important = true,
    __id = "screen-text",
    __has_character_limit = true,
    __event = nil,
    __debug_stack = {},
    with_event = function(self, event)
        self.__event = event
        local debug_stack = {
            "Debug_Placeholder",
            "Debug_Placeholder",
            "Debug_Placeholder",
            "Debug_Placeholder",
            "Debug_Placeholder",
            "Debug_Placeholder",
            "Debug_Placeholder",
            "Debug_Placeholder",
            "Debug_Placeholder",
            "Debug_Placeholder"
        }
        self.__debug_stack = debug_stack
        return self
    end,
    __log = function(self, message)
        if not self.__event then
            return
        end
        local msg = tostring(message)
        if self.__debug_stack[10] ~= msg then
            table.remove(self.__debug_stack, 1)
            table.insert(self.__debug_stack, msg)
            
            self.__event.Clear_Dialog_Text()
            for _, entry in pairs(self.__debug_stack) do
                self.__event.Add_Dialog_Text(entry)
            end
        end
    end
}