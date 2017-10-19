local Class = require("lib.Class")
local Vector2 = require("lib.Vector2")

local PC = Class:derive("PolygonCollider")

--expects an array of Vector2D objects
--These vertices should be centered around the origin
function PC:new(vertices)
    self.vertices = vertices
    --Scaled and translated vertices (we use these for collision detection)
    self.world_vertices = {}
    self.draw_points = {}

    for i = 1, #self.vertices do
        self.world_vertices[#self.world_vertices + 1] = Vector2()
        --there are 2 draw points for every vertex (x,y)
        self.draw_points[#self.draw_points + 1] = 0
        self.draw_points[#self.draw_points + 1] = 0
    end
end

function PC:on_start()
    assert(self.entity.Transform ~=nil, "PolygonCollider component requires a Transform component to exist in the attached entity!")
    self.tr = self.entity.Transform
    self:scale_translate()
end

function PC:scale_translate()
    --update the polygon's rotation/scale
    for i = 1, #self.vertices do
        self.world_vertices[i].x = self.vertices[i].x * self.tr.sx
        self.world_vertices[i].y = self.vertices[i].y * self.tr.sy
        self.world_vertices[i]:rotate(self.tr.angle, self.tr.x, self.tr.y)
        
        self.draw_points[1 + 2*(i - 1)] = self.world_vertices[i].x
        self.draw_points[1 + 2*(i - 1) + 1] = self.world_vertices[i].y
    end
end

function PC:update(dt)
    self:scale_translate()
end

function PC:draw()
    love.graphics.polygon("line", self.draw_points)
end

return PC