local Class = require("lib.Class")
local Vector2 = require("lib.Vector2")

local Button = Class:derive("Button")

local function color(r, g, b, a)
    return {r, g or r, b or r, a or 255}
end

local function gray(level, alpha)
    return {level, level, level, alpha or 255}
end

local function mouse_in_bounds(self, mx, my)
    return mx >= self.pos.x - self.w / 2 and mx <= self.pos.x + self.w / 2 and my >= self.pos.y - self.h / 2 and my <= self.pos.y + self.h / 2
end

function Button:new(x, y, w, h, label)
    self.pos = Vector2(x or 0, y or 0)
    self.w = w
    self.h = h
    self.label = label
    
    --Button Colors
    self.normal = color(128, 32, 32, 192)
    self.highlight = color(192, 32, 32, 255)
    self.pressed = color(255, 32, 32, 255)
    self.disabled = gray(128, 128)

    self.color = self.normal
    self.prev_left_click = false
    self.interactible = true
end

function Button:left(x)
    self.pos.x = x + self.w / 2
end

function Button:top(y)
    self.pos.y = y + self.h / 2
end

function Button:enable(enabled)
    self.interactible = enabled
    if not enabled then 
        self.color = self.disabled
    end
end

function Button:update(dt)
    if not self.interactible then return end
    
    x, y = love.mouse.getPosition()
    local left_click = love.mouse.isDown(1)
    local in_bounds = mouse_in_bounds(self, x, y)

    if in_bounds and not left_click then
        self.color = self.highlight
        if self.prev_left_click then
            _G.events:invoke("onBtnClick", self)
        end
    elseif in_bounds and left_click then
        self.color = self.pressed
    else
        self.color = self.normal
    end

    self.prev_left_click = left_click
end

function Button:draw()
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.pos.x - self.w / 2, self.pos.y - self.h / 2, self.w, self.h, 4, 4)
    love.graphics.setColor(r, g, b, a)
    
    local f = love.graphics.getFont()
    local fw = f:getWidth(self.label)
    local fh = f:getHeight()
    
    love.graphics.print(self.label, self.pos.x - fw / 2, self.pos.y - fh / 2)
end

return Button
