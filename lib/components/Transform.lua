local Class = require("lib.Class")
local Vector2 = require("lib.Vector2")

local T = Class:derive("Transform")

function T:new(x, y, sx, sy, angle)
    self.x = x or 0
    self.y = y or 0
    self.sx = sx or 1
    self.sy = sy or 1
    self.angle = angle or 0
    self.enabled = true
    self.started = true
end

function T:VectorPos() return Vector2(self.x, self.y) end

return T