local Class = require("lib.Class")
local StateMachine = require("lib.StateMachine")
local Anim = require("lib.Animation")
local Sprite = require("lib.Sprite")
local Vector2 = require("lib.Vector2")
local Vector3 = require("lib.Vector3")

local E = Class:derive("Missile")

local missile_atlas
local target_object
local rotate_speed = 100
local missile_speed = 40

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
        local missile_to_target = Vector2.sub(target_object:center(), self.spr:center())
        missile_to_target:normalize()

        local missile_dir = Vector2( math.cos(self.spr.angle ), math.sin(self.spr.angle))
        missile_dir:normalize()

        -- print(missile_dir.x .. " " .. missile_dir.y )
        local cp = Vector3.cross(missile_dir, missile_to_target)

        -- print(cp.x .. " " .. cp.y  .. " " .. cp.z)
        self.spr.angle = self.spr.angle + cp.z * rotate_speed * (math.pi / 180) * dt
        self.spr.pos.x = self.spr.pos.x + (missile_dir.x * missile_speed * dt)
        self.spr.pos.y = self.spr.pos.y + (missile_dir.y * missile_speed * dt)
    end

    self.spr:update(dt)
end

function E:draw()
    self.spr:draw()
end

return E