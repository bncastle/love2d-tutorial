local class = require("lib.Class")
local Vector2 = require("lib.Vector2")

local Entity = class:derive("Entity")

function Entity:new(x,y)
    self.pos = Vector2(x or 0, y or 0)
    self.id = 'none'
end

function Entity:update(dt) end
function Entity:draw() end

return Entity