local Scene = require("lib.Scene")
local U = require("lib.Utils")
local Vector2 = require("lib.Vector2")
local Vector3 = require("lib.Vector3")

local Entity = require("lib.Entity")
local Transform = require("lib.components.Transform")

local CC = require("lib.components.physics.CircleCollider")
local PC = require("lib.components.physics.PolygonCollider")

local Player = require("../Player")
local Missile = require("../Missile")
local Sat = require("lib.Sat")

local T = Scene:derive("Test")

function T:new(scene_mgr) 
    T.super.new(self, scene_mgr)

    self.p = Entity(Transform(100, 100, 4, 4), Player(), Player.create_sprite(), CC(32),
    PC({Vector2(-8,-8), Vector2(8,-8), Vector2(8,8), Vector2(-8, 8)}))

    self.em:add(self.p)

    self.e = Entity(Transform(350, 100, 1, 1, 0), Missile(), Missile.create_sprite(),
    PC({Vector2(-62,-40), Vector2(62,-40), Vector2(62,40), Vector2(-62, 40)}))
    self.em:add(self.e)
    
    self.e.Missile:target(self.p.Transform)
end

function T:update(dt)
    self.super.update(self,dt)

    if Key:key_down("escape") then
        love.event.quit()
    end

    local r1 = self.p.Sprite:rect()
    local r2 = self.e.Sprite:rect()
    if U.AABBColl(r1, r2) then
        self.p.Sprite.tintColor = U.color(0,128,128,200)

        local md = r2:minkowski_diff(r1)

        --This will give us our separation vector
        -- x > 0 = Left side collision, x < 0 = right side collision
        -- y > 0 = Top side collision, y < 0 = bottom collision
        local sep = md:closest_point_on_bounds(Vector2())

        --tell the player on which side it has a collision
        self.p.Player:collided(md:collides_top(sep), md:collides_bottom(sep), md:collides_left(sep), md:collides_right(sep))

        self.p.Transform.x = self.p.Transform.x + sep.x 
        self.p.Transform.y = self.p.Transform.y + sep.y 
        
    else
        self.p.Sprite.tintColor = U.color(255)
    end

end

function T:draw()
    love.graphics.clear(64,64,255)
    self.super.draw(self)

    -- local triangle = {100, 100, 200, 100, 150, 305}
    -- local rect = {100, 300, 200, 300, 200, 350, 100, 350}

    -- local msuv, amount = Sat.Collide(Sat.to_Vector2_array(triangle), Sat.to_Vector2_array(rect))
    -- if msuv ~= nil then
    --     print("min sep unit vector: " .. msuv.x .. "," .. msuv.y .. " sep amount:" .. amount)
    -- end

    -- love.graphics.polygon("line", triangle)
    -- love.graphics.polygon("line", rect)
end

return T
