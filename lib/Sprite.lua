local Class = require("lib.Class")
local Vector2 = require("lib.Vector2")
local Anim = require("lib.Animation")

local Sprite = Class:derive("Sprite")

function Sprite:new(atlas, x, y, w, h, sx, sy, angle, color)
    self.pos = Vector2(x or 0, y or 0)
    self.w = w
    self.h = h
    self.flip = Vector2(1,1)
    self.scale = Vector2(sx or 1, sy or 1)
    self.atlas = atlas
    self.animations = {}
    self.current_anim = ""
    self.angle = angle or 0
    self.quad = love.graphics.newQuad(0,0, w, h, atlas:getDimensions())
    self.tintColor = color or {255,255,255,255}
end

function Sprite:animate(anim_name)
    if self.current_anim ~= anim_name and self.animations[anim_name] ~= nil then
        self.current_anim = anim_name
        self.animations[anim_name]:reset()
        self.animations[anim_name]:set(self.quad)
    end
end

function Sprite:flip_h(flip)
    if flip then
        self.flip.x = -1
    else
        self.flip.x = 1
    end
end

function Sprite:flip_v(flip)
    if flip then
        self.flip.y = -1
    else
        self.flip.y = 1
    end
end

function Sprite:animation_finished()
    if self.animations[self.current_anim] ~= nil then
        return self.animations[self.current_anim].done
    end
    return true
end

function Sprite:add_animations(animations)
    assert(type(animations) == "table", "animations parameter must be a table!")
    for k,v in pairs(animations) do
        self.animations[k] = v
    end
end

function Sprite:update(dt)
    if self.animations[self.current_anim] ~= nil then
        self.animations[self.current_anim]:update(dt, self.quad)
    end
end

function Sprite:draw()
    love.graphics.setColor(self.tintColor)
    love.graphics.draw(self.atlas, self.quad, self.pos.x , self.pos.y, self.angle, self.scale.x * self.flip.x, self.scale.y * self.flip.y, self.w / 2, self.h / 2)   
end

return Sprite