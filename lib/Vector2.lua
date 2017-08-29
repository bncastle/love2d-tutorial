local Class = require("lib.Class")

local V = Class:derive("Vector2")

local pow = math.pow
local sqrt = math.sqrt

function V:new(x,y)
    self.x = x or 0
    self.y = y or 0
end

--Calculates the magintude of the vector
function V:mag()
  return sqrt(pow(self.x,2) + pow(self.y,2))
end

function V.add(v1, v2)
    return V(v1.x + v2.x, v1.y + v2.y)
end

function V.sub(v1, v2)
    return V(v1.x - v2.x, v1.y - v2.y)
end

function V:mul(val)
    return V(self.x * val, self.y * val)
end

function V:div(val)
    assert(val ~= 0, "Error val must not be 0!")
    return V(self.x / val, self.y / val)
end

--Calculates the unit vector of this vector
function V:unit()
    local mag = self:mag()
    return V(self.x / mag, self.y / mag)
end

return V