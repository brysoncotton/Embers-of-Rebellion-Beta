require("deepcore/std/class")
require("eawx-std/OrderedTable")
require("eawx-util/StoryUtil")
require("eawx-plugins/ui/galactic-display/TextResource")

---@class NewsFeedDisplayComponent
NewsFeedDisplayComponent = class()

function NewsFeedDisplayComponent:new()
    ---@private
    self.__display_duration = 15

    ---@private
    self.__max_headlines = 10

    ---@private
    self.__news_sources = {}

    ---@private
    self.__header = "TEXT_NEWS_FEED_HEADER"

    ---@private
    self.__headlines_on_screen = OrderedTable()

    ---@private
    self.__headlines_to_remove = {}

    ---@private
    self.__pending_stories = {}

    ---@private
    self.__new_stories_begin_at = 0
end

---@param source Observable
function NewsFeedDisplayComponent:add_news_source(source)
    self.__news_sources[source] = true
    source:attach_listener(self.post, self)
end

function NewsFeedDisplayComponent:needs_update()
    local now = GetCurrentTime()
    local duration
    for headline, news_story in self.__headlines_on_screen:iter() do
        duration = news_story.duration or self.__display_duration
        if now >= news_story.start_time + duration then
            table.insert(self.__headlines_to_remove, headline)
        end
    end

    return table.getn(self.__headlines_to_remove) > 0 or table.getn(self.__pending_stories) > 0
end

function NewsFeedDisplayComponent:render()
    self:clear_screen_text()
    self:add_pending_stories()
    self:remove_old_stories()
    self:remove_overflow_stories()
    self:show_screen_text()
end

---@private
function NewsFeedDisplayComponent:remove_old_stories()
    local news_story
    for _, headline in pairs(self.__headlines_to_remove) do
        news_story = self.__headlines_on_screen:remove(headline)
        news_story.text_resource:release()
    end

    self.__headlines_to_remove = {}
end

function NewsFeedDisplayComponent:remove_overflow_stories()
    local headline, news_story
    while self.__headlines_on_screen.size > self.__max_headlines do
        headline, news_story = self.__headlines_on_screen:remove_index(1)
        news_story.text_resource:release()
    end
end

---@private
function NewsFeedDisplayComponent:add_pending_stories()
    for _, news_story in ipairs(self.__pending_stories) do
        news_story.start_time = GetCurrentTime()
        news_story.text_resource = TextResource(news_story.headline)
        news_story.headline = news_story.text_resource.real_text

        if self.__headlines_on_screen:get(news_story.headline) then
            self.__headlines_on_screen:update(news_story.headline, news_story, true)
        else
            self.__headlines_on_screen:put(news_story.headline, news_story)
        end
    end

    self.__new_stories_begin_at = self.__headlines_on_screen.size - table.getn(self.__pending_stories) + 1
    self.__pending_stories = {}
end

---@private
function NewsFeedDisplayComponent:show_screen_text()
    if self.__headlines_on_screen.size == 0 then
        return
    end

    StoryUtil.ShowScreenText(self.__header, -1, nil, {r = 160, g = 160, b = 164}, false)
    local i = 0
    local teletype = false
    for headline, news_story in self.__headlines_on_screen:iter() do
        i = i + 1
        if self:is_new_story(i) then
            teletype = true
        end
        -- TRUtil.ShowScreenText(news_story.headline, -1, news_story.var, news_story.color, teletype)
        news_story.text_resource:show(-1, news_story.var, news_story.color, teletype)
    end

    self.__new_stories_begin_at = 0
end

---@private
---@param index number
function NewsFeedDisplayComponent:is_new_story(index)
    return self.__new_stories_begin_at > 0 and index >= self.__new_stories_begin_at
end

---@private
function NewsFeedDisplayComponent:clear_screen_text()
    StoryUtil.RemoveScreenText(self.__header)

    for headline, news_story in self.__headlines_on_screen:iter() do
        news_story.text_resource:remove()
        -- TRUtil.RemoveScreenText(headline)
    end
end

function NewsFeedDisplayComponent:post(news_story)
    table.insert(self.__pending_stories, news_story)
end
