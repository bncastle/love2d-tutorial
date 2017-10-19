local Class = require("lib.Class")

local PC = Class:derive("PolygonCollider")

function PC:new()

end

function PC:on_start()
    assert(self.entity.Transform ~=nil, "PolygonCollider component requires a Transform component to exist in the attached entity!")
    self.tr = self.entity.Transform
end

function CC:update(dt)
end

function PC:draw()

end

return PC