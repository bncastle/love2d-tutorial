local Scene = require("lib.Scene")
local Label = require("lib.ui.Label")
local Player = require("../Player")

local T = Scene:derive("TweenTest")

local lbl
local pos = {x = 0, y = 150}

function T:new(scene_mgr) 
    T.super.new(self, scene_mgr)
    lbl = Label(0,15, love.graphics.getWidth(), 50, "not a tween")
    self.em:add(lbl)
end

function T:update(dt)
    self.super.update(self,dt)

    if Key:key_down("escape") then
        love.event.quit()
    elseif Key:key_down("space") then
        Tween.create(pos, "x", 200, 1, Tween.quad_in)
    end
end

function T:draw()
    love.graphics.clear(64,64,64)
    self.super.draw(self)

    love.graphics.rectangle("fill", pos.x, pos.y, 30,30)
end

return T
