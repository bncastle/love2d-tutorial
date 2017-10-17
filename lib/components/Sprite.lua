local Class = require("lib.Class")
local Vector2 = require("lib.Vector2")
local Anim = require("lib.Animation")
local Rect = require("lib.Rect")
local U = require("lib.Utils")

local Sprite = Class:derive("Sprite")

--where x,y is the center of the sprite
--
--Note: This component assumes the presence of a Transform component!
--
function Sprite:new(atlas, w, h, sx, sy, color)
    self.w = w
    self.h = h
    self.flip = Vector2(1,1)
    self.scale = Vector2(sx or 1, sy or 1)
    self.atlas = atlas
    self.animations = {}
    self.current_anim = ""
    self.quad = love.graphics.newQuad(0,0, w, h, atlas:getDimensions())
    self.tintColor = color or {255,255,255,255}
end

function Sprite:on_start()
    assert(self.entity.Transform ~=nil, "Sprite component requires a Transform component to exists in the attached entity!")
end

function Sprite:animate(anim_name)
    if self.current_anim ~= anim_name and self.animations[anim_name] ~= nil then
        self.current_anim = anim_name
        self.animations[anim_name]:reset()
        self.animations[anim_name]:set(self.quad)
    elseif self.animations[anim_name] == nil then
        assert(false, anim_name .. " animation not found!")
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

function Sprite:center()
    local e = self.entity
    return Vector2(e.Transform.x + self.w /2, e.Transform.y + self.h / 2)
end

function Sprite:rect()
    local e = self.entity
    return Rect.create_centered(e.Transform.x - (self.w / 2 * self.scale.x), e.Transform.y - (self.h / 2 * self.scale.y), self.w * self.scale.x, self.h * self.scale.y)
end

function Sprite:poly()
    local e = self.entity
    local a = e.Transform.angle
    local x = (self.w / 2 * self.scale.x)
    local y = (self.h / 2 * self.scale.y)

    local rx1,ry1 = U.rotate_point(-x, -y, a, e.Transform.x - (self.w / 2 * self.scale.x), e.Transform.y - (self.h / 2 * self.scale.y))
    local rx2,ry2 = U.rotate_point( x, -y, a, e.Transform.x - (self.w / 2 * self.scale.x), e.Transform.y - (self.h / 2 * self.scale.y))
    local rx3,ry3 = U.rotate_point( x,  y, a, e.Transform.x - (self.w / 2 * self.scale.x), e.Transform.y - (self.h / 2 * self.scale.y))
    local rx4,ry4 = U.rotate_point(-x,  y, a, e.Transform.x - (self.w / 2 * self.scale.x), e.Transform.y - (self.h / 2 * self.scale.y))
    local p ={ rx1, ry1, rx2, ry2, rx3, ry3, rx4, ry4 }
    return p
end

function Sprite:draw()
    local e = self.entity
    love.graphics.setColor(self.tintColor)
    love.graphics.draw(self.atlas, self.quad, e.Transform.x - (self.w / 2 * self.scale.x), e.Transform.y - (self.h / 2 * self.scale.y), e.Transform.angle, self.scale.x * self.flip.x, self.scale.y * self.flip.y, self.w / 2, self.h / 2)

    local r = self:rect()

    love.graphics.setColor({255,64, 128})
    love.graphics.rectangle("line", r.x,r.y, r.w,r.h)

    love.graphics.setColor({255,255, 255})
    love.graphics.polygon("line", self:poly())
end

return Sprite