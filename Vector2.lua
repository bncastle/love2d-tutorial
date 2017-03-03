local class = require("class")
local Vec2 = class:derive("Vector2")

function Vec2:new(x,y)
    self.x = x or 0
    self.y = y or 0
end

--TODO: Other vector functions

return Vec2