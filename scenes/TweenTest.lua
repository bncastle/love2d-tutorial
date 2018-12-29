local Scene = require("lib.Scene")
local Label = require("lib.ui.Label")
local Player = require("../Player")

local T = Scene:derive("TweenTest")

local lbl
local pos = {x = 0, y = 150}

local tween_index = 1
local available_tweens = {}

function get_tweens()
    for k,v in pairs(Tween) do
        if type(v) == "function" then
            if k ~= "update" and k ~= "create" then
                available_tweens[#available_tweens + 1] = v
            end
        end
    end
end

function T:new(scene_mgr)
    T.super.new(self, scene_mgr)
    self.lbl = Label(0,15, love.graphics.getWidth(), 50, "not a tween")
    self.lbl2 = Label(0,love.graphics.getHeight() - 45, love.graphics.getWidth(), 50, "left/right arrows: cycle tween type")
    self.lbl3 = Label(0,love.graphics.getHeight() - 20, love.graphics.getWidth(), 50, "spacebar: execute tween")
    self.em:add(self.lbl)
    self.em:add(self.lbl2)
    self.em:add(self.lbl3)
    ease_function = Tween.quad_out
    pos.x = love.graphics.getWidth() / 2 - 150
    get_tweens()
end

function T:update(dt)
    self.super.update(self,dt)

    if Key:key_down("escape") then
        love.event.quit()
    elseif Key:key_down("space") then
        if self.t ~= nil then 
            self.t:cancel()
        end

        local xstart = love.graphics.getWidth() / 2 - 150
        local xend = love.graphics.getWidth() / 2 + 150

        if self.t == nil or self.t.to == xstart then
            self.t = Tween.create(pos, "x", xend, 1, available_tweens[tween_index])
            self.t.on_complete = on_complete
        elseif self.t ~= nill and self.t.to == xend then
             self.t = Tween.create(pos, "x", xstart, 1, available_tweens[tween_index])
             self.t.on_complete = on_complete
            end

    elseif Key:key_down("right") then
        tween_index = tween_index + 1
        if tween_index > #available_tweens then 
            tween_index = 1 
        end
    elseif Key:key_down("left") then
        tween_index = tween_index - 1
        if tween_index < 1 then 
            tween_index = #available_tweens
        end
    end

    for k,v in pairs(Tween) do
        if v == available_tweens[tween_index] then
            self.lbl.text = k
            break
        end
    end
end

function T:draw()
    love.graphics.clear(0.25,0.25,0.25)
    self.super.draw(self)

    love.graphics.rectangle("fill", pos.x, pos.y, 30,30)
end

return T
