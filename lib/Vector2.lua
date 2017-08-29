local Class = require("lib.Class")

local Vec2 = Class:derive("Vector2")

local pow = math.pow
local sqrt = math.sqrt

function Vec2:new(x,y)
    self.x = x or 0
    self.y = y or 0
end

--Calculates the magintude of the vector
function Vec2:mag()
  return sqrt(pow(self.x,2) + pow(self.y,2))
end

function Vec2:mul(val)
    self.x = self.x * val
    self.y = self.y * val
end

--Calculates the unit vector of this vector
function Vec2:unit()
    local mag = self:mag()
    return Vec2(self.x / mag, self.y / mag)
end

return Vec2