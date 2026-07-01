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
--*   @Date:                2017-10-05T20:50:45+02:00
--*   @Project:             Imperial Civil War
--*   @Filename:            StoryEventManager.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2017-12-21T12:31:42+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************
StoryEventManager = {}
StoryEventManager.activeEvents = {}
StoryEventManager.allEvents = {}
StoryEventManager.prereqMap = {}
StoryEventManager.queuedEvents = {}
StoryEventManager.triggeredEvent = false

function StoryEventManager:RegisterEvent(event)
    self.allEvents[event.id] = event
    if self:PrereqsDone(event) then
        self.activeEvents[event.id] = event
    else
        self:InsertIntoPrereqMap(event)
    end
end

function StoryEventManager:ProcessEvents()
    for _, event in pairs(self.activeEvents) do
        if event.enabled then
            self:TriggerEvent(event)
        end
    end

    if self.triggeredEvent then
        self:InsertFollowUpEvents()
        self.triggeredEvent = false
    end
    
    for id, event in pairs(self.queuedEvents) do
        self.activeEvents[id] = event
    end
    
    self.queuedEvents = {}
end

function StoryEventManager:SetBranchActive(branch, active)
    for _, event in pairs(self.allEvents) do
        if event.branch == branch then
            event.enabled = active
        end
    end
end

function StoryEventManager:SetEventActive(eventName, active)
    if not self.allEvents[eventName] then return end
    
    self.allEvents[eventName].enabled = active
end

function StoryEventManager:InsertIntoPrereqMap(event)
    if not event.prereqs then return end
    
    table.insert(self.prereqMap, event)
end


function StoryEventManager:PrereqsDone(event)
    if not event.prereqs then return true end
    
    return event.prereqs:evaluate(self.allEvents)
end

function StoryEventManager:TriggerEvent(event, force)
    if event.event:evaluate() or force then
        if event.reward then
            event.reward:execute()
        end
        
        event.concluded = true
        if not event.repeatable then
            self.activeEvents[event.id] = nil
        end
        
        DebugMessage("Event %s concluded", tostring(event.id))
        
        self.triggeredEvent = true
    end
end

function StoryEventManager:InsertFollowUpEvents()
    for i, event in pairs(self.prereqMap) do
        if self:PrereqsDone(event) then
            self.queuedEvents[event.id] = event
            table.remove(self.prereqMap, i)
        end
    end
end

return StoryEventManager
