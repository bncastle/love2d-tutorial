--[[
This module gives us some class-like functionality
]]

local Class = {}
Class.__index = Class

--default implementation
function Class:new() end

--create a new Class type from our base class
function Class:derive(class_type)
    assert(class_type ~= nil, "parameter class_type must not be nil!")
    assert(type(class_type) == "string", "parameter class_type class must be string!")
    local cls = {}
    cls["__call"] = Class.__call
    cls.type = class_type
    cls.__index = cls
    cls.super = self
    setmetatable(cls, self)
    return cls
end

--Check if the instance is a sub-class of the given type
function Class:is(class)
    assert(class ~= nil, "parameter class must not be nil!")
    assert(type(class) == "table", "parameter class must be of Type Class!")
    local mt = getmetatable(self)
    while mt do
        if mt == class then return true end
        mt = getmetatable(mt)
    end
    return false
end

function Class:is_type(class_type)
    assert(class_type ~= nil, "parameter class_type must not be nil!")
    assert(type(class_type) == "string", "parameter class_type class must be string!")
    local base = self
    while base do
        if base.type == class_type then return true end
        base = base.super
    end
    return false
end

function Class:__call(...)
    local inst = setmetatable({}, self)
    inst:new(...)
    return inst
end

function Class:get_type()
    return self.type
end

return Class