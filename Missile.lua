local Entity = require("lib.Entity")
local StateMachine = require("lib.StateMachine")
local Anim = require("lib.Animation")
local Vector2 = require("lib.Vector2")
local Vector3 = require("lib.Vector3")

local Sprite = require("lib.components.Sprite")
local Transform = require("lib.components.Transform")

local M = Entity:derive("Missile")

local missile_atlas
local target_object
local rotate_speed = 100
local missile_speed = 40

--Animation data
local idle = Anim(0,0, 124, 80, 2, 2, 6 )

function M:new(x, y)
    M.super.new(self)

    if missile_atlas == nil then
        missile_atlas = love.graphics.newImage("assets/gfx/missile.png")
    end

    local spr = Sprite(missile_atlas, 124, 80, 1, 1)
    spr:add_animations({idle = idle})
    spr:animate("idle")
    self.vx = 0

    self:add(Transform(x, y, 0))
    self:add(spr)    
end

--Sets the target object
---
function M:target(object)
    target_object = object
end

function M:update(dt)
    if target_object ~= nil then
        local missile_to_target = Vector2.sub(target_object:center(), self.Sprite:center())
        missile_to_target:normalize()

        local missile_dir = Vector2( math.cos(self.Transform.angle ), math.sin(self.Transform.angle))
        missile_dir:normalize()

        -- print(missile_dir.x .. " " .. missile_dir.y )
        local cp = Vector3.cross(missile_dir, missile_to_target)

        -- print(cp.x .. " " .. cp.y  .. " " .. cp.z)
        self.Transform.angle = self.Transform.angle + cp.z * rotate_speed * (math.pi / 180) * dt
        self.Transform.x = self.Transform.x + (missile_dir.x * missile_speed * dt)
        self.Transform.y = self.Transform.y + (missile_dir.y * missile_speed * dt)
    end

end


return M