return {
    on_enter = function(self, state_context)
        --Logger:trace("entering fotr-ftgu-era-two:on_enter")

        GlobalValue.Set("CURRENT_ERA", 2)

        self.entry_time = GetCurrentTime()
        self.EventsFired = false
    end,
    on_update = function(self, state_context)
        local current = GetCurrentTime() - self.entry_time
        if current >=10 and self.EventsFired ~= true then
            crossplot:publish("VENATOR_RESEARCH", "empty")
            crossplot:publish("PROVIDENCE_RESEARCH", "empty")
            self.EventsFired = true
        end
    end,
    on_exit = function(self, state_context)
    end
}