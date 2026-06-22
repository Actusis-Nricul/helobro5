-- class.lua
-- Minimal class system with single inheritance.
-- Usage:
--   local Animal = class("Animal")
--   function Animal:init(name) self.name = name end
--   function Animal:speak() print(self.name .. " makes a sound") end
--
--   local Dog = class("Dog", Animal)
--   function Dog:speak() print(self.name .. " barks") end
--
--   local d = Dog.new("Rex")
--   d:speak() --> "Rex barks"
--   print(d:is(Animal)) --> true

local function class(name, parent)
    local cls = {}
    cls.__name = name
    cls.__index = cls
    cls.__parent = parent

    if parent then
        setmetatable(cls, { __index = parent })
    end

    function cls.new(...)
        local instance = setmetatable({}, cls)
        if instance.init then
            instance:init(...)
        end
        return instance
    end

    -- Walks the inheritance chain to check type
    function cls:is(otherClass)
        local mt = getmetatable(self)
        while mt do
            if mt == otherClass then return true end
            mt = mt.__parent
        end
        return false
    end

    return cls
end

return class
