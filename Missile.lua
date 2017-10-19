local Class = require("lib.Class")
local Anim = require("lib.Animation")
local Vector2 = require("lib.Vector2")
local Vector3 = require("lib.Vector3")

local Sprite = require("lib.components.Sprite")
local Transform = require("lib.components.Transform")

local M = Class:derive("Missile")

local missile_atlas
local target_object
local rotate_speed = 100
local missile_speed = 40

--Animation data
local idle = Anim(0,0, 124, 80, 2, 2, 6 )

function M:new()
    self.vx = 0
end

function M.create_sprite()
    if missile_atlas == nil then
        missile_atlas = love.graphics.newImage("assets/gfx/missile.png")
    end
    local spr = Sprite(missile_atlas, 124, 80)
    spr:add_animations({idle = idle})
    spr:animate("idle")
    return spr
end

function M:on_start()
    self.transform = self.entity.Transform
end

--Sets the target object
---
function M:target(object)
    target_transform = object
end

function M:update(dt)

    if target_transform ~= nil then
        local missile_to_target = Vector2.sub(target_transform:VectorPos(), self.transform:VectorPos())
        missile_to_target:unit()
        --print(missile_to_target.x .. " " .. missile_to_target.y )

        local missile_dir = Vector2( math.cos(self.transform.angle ), math.sin(self.transform.angle))
        missile_dir:unit()

        -- print("to target: " .. missile_to_target.x .. "," .. missile_to_target.y .. " missile dir: " .. missile_dir.x .. "," .. missile_dir.y )
        local cp = Vector3.cross(missile_dir, missile_to_target)
        if cp.z < 0.005 and ( missile_to_target.x == -missile_dir.x or missile_to_target.y == -missile_dir.y)  then cp.z = 10 end

        -- print(cp.x .. " " .. cp.y  .. " " .. cp.z)
        self.transform.angle = self.transform.angle + cp.z * rotate_speed * (math.pi / 180) * dt
        self.transform.x = self.transform.x + (missile_dir.x * missile_speed * dt)
        self.transform.y = self.transform.y + (missile_dir.y * missile_speed * dt)
    end
end

return M