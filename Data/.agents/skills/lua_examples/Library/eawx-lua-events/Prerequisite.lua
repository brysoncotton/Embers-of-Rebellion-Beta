function Prereq(initial)
    return {
        last = BasicCondition(initial),
        And = function(self, next)
            local andCondition = AndCondition(self.last, BasicCondition(next))
            self:OrderAndSetCondition(andCondition)
            return self
        end,
        Or = function(self, next)
            local orCondition = OrCondition(self.last, BasicCondition(next))
            self:OrderAndSetCondition(orCondition)
            return self
        end,
        End = function(self)
            return self.last
        end,
        OrderAndSetCondition = function(self, condition)
            if self.last.priority and self.last.priority > condition.priority then
                local tmp = self.last.second
                self.last.second = condition
                condition.first = tmp
                return
            end
            self.last = condition
        end
    }
end

function AndCondition(first, second)
    return {
        priority = 1,
        first = first,
        second = second,
        evaluate = function(self, events)
            local result = self.first:evaluate(events) and self.second:evaluate(events)
            return result
        end,
        print = function(self)
            print(self.first:print())
            print(self.second:print())
        end
    }
end

function OrCondition(first, second)
    return {
        priority = 2,
        first = first,
        second = second,
        evaluate = function(self, events)
            local result = self.first:evaluate(events) or self.second:evaluate(events)
            return result
        end,
        print = function(self)
            print("Or")
            print(self.first:print())
            print(self.second:print())
        end
    }
end

function BasicCondition(eventName)
    return {
        eventName = eventName,
        evaluate = function(self, events)
            return events[self.eventName] and events[self.eventName].concluded
        end,
        print = function(self)
            print(self.eventName)
        end
    }
end