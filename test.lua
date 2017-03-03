Class = require "Class"

local Animal = Class:derive("Animal")
local Human = Class:derive("Human")

function Animal:SoundOff()
    print("uh?")
end

local a = Animal()
a:SoundOff()
print(a:get_type())

local Cat = Animal:derive("Cat")

function Cat:SoundOff()
     print("Meow!")
 end

local c = Cat()
c:SoundOff()
print(c:get_type())

local Minx = Cat:derive("Minx")
local m = Minx()
-- print(m:is(Human))
print(m:is_type("Minx"))