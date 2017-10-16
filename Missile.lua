local Class = require("lib.Class")
local StateMachine = require("lib.StateMachine")
local Anim = require("lib.Animation")
local Sprite = require("lib.Sprite")
local Vector2 = require("lib.Vector2")
local Vector3 = require("lib.Vector3")

local E = Class:derive("Missile")

local missile_atlas
local target_object

--Animation data
local idle = Anim(0,0, 124, 80, 2, 2, 6 )

function E:new(x, y)
    if missile_atlas == nil then
        missile_atlas = love.graphics.newImage("assets/gfx/missile.png")
    end

    self.spr = Sprite(missile_atlas,x, y, 124, 80, 1, 1)
    self.spr:add_animations({idle = idle})
    self.spr:animate("idle")
    self.vx = 0
end

--Sets the target object
---
function E:target(object)
    target_object = object
end

function E:update(dt)
    if target_object ~= nil then
        local missile_to_target = Vector2.sub(target_object.pos, self.spr.pos)
        local missile_dir = Vector2( math.cos(self.spr.angle ), math.sin(self.spr.angle))
        -- print(missile_dir.x .. " " .. missile_dir.y )
        local cp = Vector3.cross(Vector3(missile_dir.x, missile_dir.y, 0), Vector3(missile_to_target.y, missile_to_target.x, 0))
        print(cp.x .. " " .. cp.y  .. " " .. cp.z)

        -- self.spr.angle = self.spr.angle + 1 * dt
    end

    self.spr:update(dt)
end

function E:draw()
    self.spr:draw()
end

return E