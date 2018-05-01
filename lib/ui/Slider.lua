local U = require("lib.Utils")
local Class = require("lib.Class")
local Vector2 = require("lib.Vector2")

local Slider = Class:derive("Slider")

local slider_size = 20
local groove_size = 6

function Slider:new(x, y, w, h, id, is_vertical)
    self.pos = Vector2(x or 0, y or 0)
    self.w = w
    self.h = h
    self.id = id or ''
    
    self.is_vertical = (is_vertical and true) or false
    self.slider_pos = 0
    self.slider_prev_pos = 0
    self.slider_delta = 0
    self.moving_slider = false
    
    --Goes between 0 and 100 or maybe
    -- a percentage as a float number
    self.value = 0
    
    --Slider Colors
    self.normal = U.color(0.5, 0.125, 0.125, 0.75)
    self.highlight = U.color(0.75, 0.125, 0.125, 1)
    self.pressed = U.color(1, 0.125, 0.125, 1)
    self.disabled = U.gray(0.5, 0.5)

    self.groove_color = U.gray(0.5)
    self.color = self.normal
    self.interactible = true
end

--Returns a value between 0 and 100
function Slider:get_value()
    if self.is_vertical then
        return math.floor((self.slider_pos / (self.h - slider_size)) * 100)
    else
        return math.floor((self.slider_pos / (self.w - slider_size)) * 100)
    end
end

function Slider:update(dt)
    if not self.interactible then
        return 
    end
    
    local mx, my = love.mouse.getPosition()
    local left_click = love.mouse.isDown(1)
    local in_bounds = false
    
    if self.is_vertical then
        in_bounds = U.mouse_in_rect(mx, my, self.pos.x, self.pos.y + self.h - self.slider_pos - slider_size, self.w, slider_size)
    else
        in_bounds = U.mouse_in_rect(mx, my, self.pos.x + self.slider_pos, self.pos.y - self.h, slider_size, self.h)
    end
    
    if in_bounds and not left_click then
        self.color = self.highlight
    elseif in_bounds and left_click then
        if not self.prev_left_click then
            if self.is_vertical then
                self.slider_delta = self.pos.y + self.h - self.slider_pos - my
            else
                self.slider_delta = self.slider_pos - mx
            end
            self.moving_slider = true
        end
    else
        self.color = self.normal
    end
    
    if self.moving_slider and left_click then
        self.color = self.pressed
        self.slider_prev_pos = self.slider_pos
        
        if self.is_vertical then
            self.slider_pos = self.pos.y + self.h - (my + self.slider_delta)
            if self.slider_pos > self.h - slider_size then
                self.slider_pos = self.h - slider_size
            elseif self.slider_pos < 0 then
                self.slider_pos = 0
            end
        else
            self.slider_pos = mx + self.slider_delta
            if self.slider_pos > self.w - slider_size then
                self.slider_pos = self.w - slider_size
            elseif self.slider_pos < 0 then
                self.slider_pos = 0
            end
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
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(self.groove_color)
    
    if self.is_vertical then
        love.graphics.rectangle("fill", self.pos.x + self.w / 2 - groove_size / 2, self.pos.y, groove_size, self.h, 2, 2)
        love.graphics.setColor(self.color)
        love.graphics.rectangle("fill", self.pos.x, self.pos.y + self.h - self.slider_pos - slider_size, self.w, slider_size, 2, 2)
    else
        love.graphics.rectangle("fill", self.pos.x, self.pos.y - self.h / 2 - groove_size / 2, self.w, groove_size, 2, 2)
        love.graphics.setColor(self.color)
        love.graphics.rectangle("fill", self.pos.x + self.slider_pos, self.pos.y - self.h, slider_size, self.h, 2, 2)
    end
    
    love.graphics.setColor(r, g, b, a)
end

return Slider
