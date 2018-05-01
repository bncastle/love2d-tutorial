local U = require("lib.Utils")
local Class = require("lib.Class")
local Vector2 = require("lib.Vector2")

local B = Class:derive("Bar")

local border_thickness = 2

function B:new(id, x, y, w, h, text)
    self.id = id
    self.pos = Vector2(x or 0, y or 0)
    self.w = w
    self.h = h
    self.text = text
    self.percentage = 0
    self.filled_value = self.w - border_thickness

    --Text colors
    self.text_color = U.color(1)
    self.fill_color = U.color(1,0,0, 1)
    self.outline_color = U.color(1)
end

--A value between 0 and 100
function B:set(percentage)
    local new_percentage = math.max(0, math.min(percentage, 100))

    if self.percentage ~= new_percentage then
        self.percentage = new_percentage
        _G.events:invoke("onBarChanged", self, new_percentage)
    else
        self.percentage = new_percentage
    end
    -- self.text = tostring(percentage .. "%")
end

function B:update(dt) end

function B:draw()
    -- love.graphics.line(self.pos.x, self.pos.y - self.h / 2, self.pos.x, self.pos.y + self.h / 2)
    -- love.graphics.line(self.pos.x - self.w / 2, self.pos.y, self.pos.x + self.w / 2, self.pos.y)
    local r, g, b, a = love.graphics.getColor()
    local lw = love.graphics.getLineWidth()

    --The bar inside color
    love.graphics.setColor(self.fill_color)

    local fillamount = self.filled_value * self.percentage / 100
    if fillamount > 0 then
        love.graphics.rectangle("fill", self.pos.x - self.w / 2 + border_thickness  / 2, self.pos.y - self.h / 2, fillamount, self.h, 2, 2)
    end

    --The bar outline
    love.graphics.setLineWidth(border_thickness)
    love.graphics.setColor(self.outline_color)
    love.graphics.rectangle("line", self.pos.x - self.w / 2, self.pos.y - self.h / 2, self.w, self.h, 2, 2)
    love.graphics.setLineWidth(lw)
    
    local f = love.graphics.getFont()
    local _, lines = f:getWrap(self.text, self.w)
    local fh = f:getHeight()

    love.graphics.setColor(self.text_color)
    love.graphics.printf(self.text, self.pos.x  - self.w / 2, self.pos.y - (fh /2 * #lines), self.w, "center")
    love.graphics.setColor(r, g, b, a)
end

return B