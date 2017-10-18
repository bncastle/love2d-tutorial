local Class = require("lib.Class")

local V = Class:derive("Vector2")

local pow = math.pow
local sqrt = math.sqrt

function V:new(x,y)
    self.x = x or 0
    self.y = y or 0
end

--Calculates the magnitude of the vector
function V:mag()
  return sqrt(pow(self.x,2) + pow(self.y,2))
end

function V.add(v1, v2)
    return V(v1.x + v2.x, v1.y + v2.y)
end

function V.sub(v1, v2)
    return V(v1.x - v2.x, v1.y - v2.y)
end

function V.divide(v1, divisor)
    assert(divisor ~= 0, "Error divisor must not be 0!")
    return V(v1.x / divisor, v1.y / divisor)
end

function V.multiply(v1, mult)
    return V(v1.x * mult, v1.y * mult)
end

--Returns the dot product of the vector with the specified one
--note: this number is a scalar
--
function V:dot(other)
    return self.x * other.x + self.y * other.y
end

function V:mul(val)
    self.x = self.x * val
    self.y = self.y * val
end

function V:div(val)
    assert(val ~= 0, "Error val must not be 0!")
    self.x = self.x / val
    self.y = self.y / val
end

--Modifies the vector in-place to have a magnitude of 1
-- this is commonly referred to as a unit vector
function V:unit()
    local mag = self:mag()
    self.x = self.x / mag
    self.y = self.y / mag
end

--Returns a vector that is the normal of this one (perpendicular)
--
function V:normal()
    return V(self.y, -self.x)
end

--Creates a copy of this Vector2 object
--
function V:copy()
    return V(self.x, self.y)
end

return V