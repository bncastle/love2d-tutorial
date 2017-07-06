local U = require("lib.Utils")
local Class = require("lib.Class")
local Vector2 = require("lib.Vector2")

local Button = Class:derive("Button")

local function mouse_in_bounds(self, mx, my)
    return mx >= self.pos.x - self.w / 2 and mx <= self.pos.x + self.w / 2 and my >= self.pos.y - self.h / 2 and my <= self.pos.y + self.h / 2
end

function Button:new(x, y, w, h, text)
    self.pos = Vector2(x or 0, y or 0)
    self.w = w
    self.h = h
    self.text = text
    
    --Button Colors
    self.normal = U.color(128, 32, 32, 192)
    self.highlight = U.color(192, 32, 32, 255)
    self.pressed = U.color(255, 32, 32, 255)
    self.disabled = U.gray(128, 128)

    --Text colors
    self.text_normal = U.color(255)
    self.text_disabled = U.gray(128, 255)


    self.text_color = self.text_normal
    self.color = self.normal
    self.prev_left_click = false
    self.interactible = true
end

function Button:text_colors(normal, disabled)
    assert(type(normal) == "table", "normal parameter must be a table!")
    assert(type(disabled) == "table", "disabled parameter must be a table!")

    self.text_normal = normal
    self.text_disabled = disabled
end

function Button:colors(normal, highlight, pressed, disabled)
    assert(type(normal) == "table", "normal parameter must be a table!")
    assert(type(highlight) == "table", "highlight parameter must be a table!")
    assert(type(pressed) == "table", "pressed parameter must be a table!")
    --assert(type(disabled) == "table", "disabled parameter must be a table!")
    self.normal = normal
    self.highlight = highlight
    self.pressed = pressed
    self.disabled = disabled or self.disabled
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
        self.text_color = self.text_disabled
    else
        self.text_color = self.text_normal
    end
end

function Button:update(dt)
    if not self.interactible then return end
    
    local mx, my = love.mouse.getPosition()
    local left_click = love.mouse.isDown(1)
    local in_bounds = mouse_in_bounds(self, mx, my)

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

    -- love.graphics.line(self.pos.x, self.pos.y - self.h / 2, self.pos.x, self.pos.y + self.h / 2)
    -- love.graphics.line(self.pos.x - self.w / 2, self.pos.y, self.pos.x + self.w / 2, self.pos.y)

    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.pos.x - self.w / 2, self.pos.y - self.h / 2, self.w, self.h, 4, 4)
    
    local f = love.graphics.getFont()
    local _, lines = f:getWrap(self.text, self.w)
    local fh = f:getHeight()

    love.graphics.setColor(self.text_color)
    love.graphics.printf(self.text, self.pos.x  - self.w / 2, self.pos.y - (fh /2 * #lines), self.w, "center")
    love.graphics.setColor(r, g, b, a)
end

return Button
