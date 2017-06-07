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

local function repeats(str, num) return num > 0 and str .. repeats(str, num -1) or "" end
local function dump(o, indent)
    indent = indent or 0
   if type(o) == 'table' then
      local s = '\n' .. repeats(" ", indent) .. '{\n'
      for k,v in pairs(o) do
        s = s .. repeats(" ", indent)
         if type(k) ~= 'number' then k = '"'..k..'"' end
         if  o ~= v then --Don't want circular loops
            s = s .. '['..k..'] = ' .. dump(v, indent + 1) .. '\n'
         end
      end
      return s ..repeats(" ", indent) .. '}\n'
   else
      return tostring(o)
   end
end