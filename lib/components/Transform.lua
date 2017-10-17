local Class = require("lib.Class")
local Vector2 = require("lib.Vector2")

local T = Class:derive("Transform")

function T:new(x, y, angle)
    self.x = x or 0
    self.y = y or 0
    self.angle = angle or 0
    self.enabled = true
    self.started = true
end

-- function T:get_pos_vector() return Vector2(self.x, self.y) end

return T