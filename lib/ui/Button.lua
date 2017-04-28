local Class = require("lib.Class")
local Vector2 = require("lib.Vector2")

local Button = Class:derive("Button")

local function color(r, g, b, a)
    return {r, g or r, b or r, a or 255}
end

local function gray(level, alpha)
    return {level, level, level, alpha or 255}
end

function Button:new(x, y, w, h)
    self.pos = Vector2(x or 0, y or 0)
    self.w = w
    self.h = h

    --Button Colors
    self.normal = color(128, 32, 32, 192)
    self.highlight = color(128, 32, 32, 255)
    self.pressed = color(255,32,32,255)
    self.disabled = gray(128,128)
end

function Button:left(x)
    self.pos.x = x + self.w / 2
end

function Button:top(y)
    self.pos.y = y + self.h / 2
end

function Button:draw()
    local r,g,b,a = love.graphics.getColor()
    love.graphics.setColor(self.normal)
    love.graphics.rectangle("fill", self.pos.x - self.w / 2, self.pos.y - self.h / 2, self.w, self.h, 4, 4)
    love.graphics.setColor(r,g,b,a)
    love.graphics.print("New", self.pos.x - 20, self.pos.y - 25)
end

return Button