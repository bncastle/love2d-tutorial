local class = require("class")
local Sprite = class:derive("Sprite")
local Anim = require("Animation")
local Vector2 = require("Vector2")

function Sprite:new(atlas, w, h, x, y, sx, sy, angle)
    self.w = w
    self.h = h
    self.pos = Vector2(x or 0, y or 0)
    self.scale = Vector2(sx or 1, sy or 1)
    self.atlas = atlas
    self.animations = {}
    self.current_anim = ""
    self.angle = angle or 0
    self.quad = love.graphics.newQuad(0,0, w, h, atlas:getDimensions())
end

function Sprite:animate(anim_name)
    if self.current_anim ~= anim_name and self.animations[anim_name] ~= nil then
        self.current_anim = anim_name
        self.animations[anim_name]:reset()
        self.animations[anim_name]:set(self.quad)
    end
end

function Sprite:add_animation(name, anim)
    self.animations[name] = anim
end

function Sprite:update(dt)
    if self.animations[self.current_anim] ~= nil then
        self.animations[self.current_anim]:update(dt, self.quad)
    end
end

function Sprite:draw()
    love.graphics.draw(self.atlas, self.quad, self.pos.x , self.pos.y, self.angle, self.scale.x, self.scale.y, self.w / 2, self.h / 2)   
end

return Sprite