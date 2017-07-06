local U = require("lib.Utils")
local Class = require("lib.Class")
local Vector2 = require("lib.Vector2")

local Slider = Class:derive("Slider")

local slider_width = 20

function Slider:new(x, y, w, h, id)
    self.pos = Vector2(x or 0, y or 0)
    self.w = w
    self.h = h
    self.id = id or ''
    
    self.slider_pos = 0
    self.slider_prev_pos = 0
    self.slider_x_delta = 0
    self.moving_slider = false
    
    --Goes between 0 and 100 or maybe
    -- a percentage as a float number
    self.value = 0
    
    --Slider Colors
    self.normal = U.color(128, 32, 32, 192)
    self.highlight = U.color(192, 32, 32, 255)
    self.pressed = U.color(255, 32, 32, 255)
    self.disabled = U.gray(128, 128)
    
    self.groove_color = U.gray(128)
    self.color = self.normal
    self.interactible = true
end

--Returns a value between 0 and 100
function Slider:get_value()
    return math.floor( (self.slider_pos / (self.w - slider_width)) * 100)
end

function Slider:update(dt)
    if not self.interactible then
        return 
    end
    local mx, my = love.mouse.getPosition()
    local left_click = love.mouse.isDown(1)
    local in_bounds = U.mouse_in_rect(mx, my, self.pos.x + self.slider_pos, self.pos.y - self.h, slider_width, self.h)
    
    if in_bounds and not left_click then
        self.color = self.highlight
    elseif in_bounds and left_click then
        if not self.prev_left_click then
            self.slider_x_delta = (self.slider_pos) - mx
            self.moving_slider = true
        end
    end
    
    if self.moving_slider and left_click then
        self.color = self.pressed
        self.slider_prev_pos = self.slider_pos

        self.slider_pos = mx + self.slider_x_delta
        if self.slider_pos > self.w - slider_width then
            self.slider_pos = self.w - slider_width
        elseif self.slider_pos < 0 then
            self.slider_pos = 0
        end
        if self.slider_prev_pos ~= self.slider_pos then
             _G.events:invoke("onSliderChanged", self)
        end

    elseif self.moving_slider and not left_click then
        self.moving_slider = false
        self.color = self.normal
    end
    
    self.prev_left_click = left_click
end

function Slider:draw()
    -- love.graphics.line(self.pos.x, self.pos.y - self.h / 2, self.pos.x, self.pos.y + self.h / 2)
    -- love.graphics.line(self.pos.x - self.w / 2, self.pos.y, self.pos.x + self.w / 2, self.pos.y)
    
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(self.groove_color)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y - self.h / 2, self.w, 5, 4, 4)
    
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.pos.x + self.slider_pos, self.pos.y - self.h, slider_width, self.h, 4, 4)
    
    love.graphics.setColor(r, g, b, a)
end

return Slider
