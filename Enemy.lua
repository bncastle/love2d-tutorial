local Class = require("lib.Class")
local StateMachine = require("lib.StateMachine")
local Anim = require("lib.Animation")
local Sprite = require("lib.Sprite")

local E = Class:derive("Enemy")

local missile_atlas

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

function E:update(dt)
    self.spr:update(dt)
end

function E:draw()
    self.spr:draw()
end

return E