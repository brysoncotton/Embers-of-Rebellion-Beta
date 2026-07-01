return {
    on_enter = function(self, state_context)
        --Logger:trace("entering fotr-ftgu-era-three:on_enter")

        GlobalValue.Set("CURRENT_ERA", 3)

        self.entry_time = GetCurrentTime()
        self.EventsFired = false
    end,
    on_update = function(self, state_context)
        local current = GetCurrentTime() - self.entry_time
        if current >=10 and self.EventsFired ~= true then
            crossplot:publish("VENATOR_RESEARCH_FINISHED", "empty")
            crossplot:publish("VICTORY1_RESEARCH", "empty")
            crossplot:publish("PROVIDENCE_RESEARCH_FINISHED", "empty")
            self.EventsFired = true
        end
    end,
    on_exit = function(self, state_context)
    end
}