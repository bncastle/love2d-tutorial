local Class = require("lib.Class")

local CC = Class:derive("CircleCollider")

function CC:new(radius)
    self.r = radius
end

function CC:on_start()
    assert(self.entity.Transform ~=nil, "CircleCollider component requires a Transform component to exist in the attached entity!")
    self.tr = self.entity.Transform
end

-- function CC:update(dt)
-- end

function CC:draw()
    love.graphics.circle("line", self.tr.x, self.tr.y, self.r)
end

return CC