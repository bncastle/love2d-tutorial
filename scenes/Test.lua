local Scene = require("lib.Scene")
local U = require("lib.Utils")
local Vector2 = require("lib.Vector2")
local Vector3 = require("lib.Vector3")

local Entity = require("lib.Entity")
local Transform = require("lib.components.Transform")

local Player = require("../Player")
local Missile = require("../Missile")

local T = Scene:derive("Test")

function T:new(scene_mgr) 
    T.super.new(self, scene_mgr)
    self.p = Player()
    self.em:add(self.p)

    self.e = Missile(320, 100)
    self.em:add(self.e)
    
    self.e:target(self.p.Sprite)

    self.c1 = {x = 200, y = 200, r= 20, c = U.color(255)}
    self.c2 = {x = 320, y = 200, r= 40, c = U.color(255, 200, 200)}
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
        self.p:collided(md:collides_top(sep), md:collides_bottom(sep), md:collides_left(sep), md:collides_right(sep))

        self.p.Transform.x = self.p.Transform.x + sep.x 
        self.p.Transform.y = self.p.Transform.y + sep.y 
        
    else
        self.p.Sprite.tintColor = U.color(255)
    end

    --Check if the circles collide
    if U.CirclesCollide(self.c1, self.c2) then
        self.c1.c = U.color(0,128,128,200)
    else
        self.c1.c = U.color(255)
    end

    if Key:key("w") then
        self.c1.y = self.c1.y - 115 * dt
    elseif Key:key("s") then
        self.c1.y = self.c1.y + 115 * dt
    elseif Key:key("a") then
        self.c1.x = self.c1.x - 115 * dt
    elseif Key:key("d") then
        self.c1.x = self.c1.x + 115 * dt
    end

end

function T:draw()
    love.graphics.clear(64,64,255)
    self.super.draw(self)

    love.graphics.setColor(self.c1.c)
    love.graphics.circle("line", self.c1.x,self.c1.y, self.c1.r)

    love.graphics.setColor(self.c2.c)
    love.graphics.circle("line", self.c2.x,self.c2.y, self.c2.r)
end

return T
