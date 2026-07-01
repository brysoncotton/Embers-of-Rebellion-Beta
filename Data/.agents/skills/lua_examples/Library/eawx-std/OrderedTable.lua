require("deepcore/std/class")

---@class OrderedTableIterator
OrderedTableIterator = class()

---@param ordered_table OrderedTable
function OrderedTableIterator:new(ordered_table)
    ---@private
    self.__source = ordered_table

    ---@private
    self.__next = 0
end

function OrderedTableIterator:next(_)
    self.__next = self.__next + 1
    local key = self.__source.__keys[self.__next]
    local value = self.__source.__map[key]

    return key, value
end

---@class OrderedTable
OrderedTable = class()

function OrderedTable:new()
    ---@private
    self.__keys = {}

    ---@private
    self.__map = {}

    ---@public
    self.size = 0
end

---Inserts a key-value pair into the table. Throws an error if the key already exists.
---@param key any
---@param value any
function OrderedTable:put(key, value)
    local current_value = self.__map[key]

    if current_value then
        error("Key " .. tostring(key) .. " does already exist")
    end

    table.insert(self.__keys, key)
    self.__map[key] = value
    self.size = table.getn(self.__keys)
end

---Updates the value for the given key. Optionally pushes the key back to the end of the table. Throws an error if the key does not exist.
---@overload fun(key: any, value: any)
---@param key any
---@param value any
---@param push_back boolean
function OrderedTable:update(key, value, push_back)
    if not self.__map[key] then
        error("Key " .. tostring(key) .. " does not exist")
    end

    self.__map[key] = value

    if not push_back then
        return
    end

    local index
    for i, k in pairs(self.__keys) do
        if k == key then
            index = i
            break
        end
    end

    table.remove(self.__keys, index)
    table.insert(self.__keys, key)
end

---Removes the key-value pair with the given key from the table and returns the value.
---@param key any
---@return any
function OrderedTable:remove(key)
    local value = self.__map[key]

    if not value then
        return
    end

    self.__map[key] = nil

    for i, key_cmp in pairs(self.__keys) do
        if key_cmp == key then
            table.remove(self.__keys, i)
            break
        end
    end

    self.size = table.getn(self.__keys)

    return value
end

---Removes the key-value pairs at the given index and returns the key and value.
---@param index number
---@return any, any
function OrderedTable:remove_index(index)
    local key = self.__keys[index]

    if not key then
        return
    end

    local value = self.__map[key]

    table.remove(self.__keys, index)
    self.__map[key] = nil

    self.size = table.getn(self.__keys)

    return key, value
end

---Returns the value for the given key.
---@param key any
---@return any
function OrderedTable:get(key)
    return self.__map[key]
end

---Returns an iterator that can be used to iterate over the map with a for loop. NOT SAFE FOR CONCURRENT MODIFICATION!
---@return OrderedTableIterator
function OrderedTable:iter()
    local iterator = OrderedTableIterator(self)
    return iterator.next, iterator, nil
end