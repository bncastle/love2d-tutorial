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
    lbl = Label(0,15, love.graphics.getWidth(), 50, "not a tween")
    self.em:add(lbl)
    ease_function = Tween.quad_out
    get_tweens()
end

function T:update(dt)
    self.super.update(self,dt)

    if Key:key_down("escape") then
        love.event.quit()
    elseif Key:key_down("space") then
        if pos.x == 0 then
            Tween.create(pos, "x", 200, 1, available_tweens[tween_index])
        else
            Tween.create(pos, "x", 0, 1, available_tweens[tween_index])
        end

    elseif Key:key_down(".") then
        tween_index = tween_index + 1
        if tween_index > #available_tweens then 
            tween_index = 1 
        end
    elseif Key:key_down(",") then
        tween_index = tween_index - 1
        if tween_index < 1 then 
            tween_index = #available_tweens
        end
    end

    for k,v in pairs(Tween) do
        if v == available_tweens[tween_index] then
            lbl.text = k
            break
        end
    end
end

function T:draw()
    love.graphics.clear(64,64,64)
    self.super.draw(self)

    love.graphics.rectangle("fill", pos.x, pos.y, 30,30)
end

return T
