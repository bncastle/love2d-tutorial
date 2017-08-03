local Scene = require("lib.Scene")
local Player = require("../Player")

local T = Scene:derive("Test")

local spr

function T:new(scene_mgr) 
    T.super.new(self, scene_mgr)
end

local entered = false
function T:enter()
    T.super.enter(self)
    if not entered then
        entered = true
        self.p = Player("idle")
        self.em:add(self.p)
    end
end

function T:update(dt)
    self.super.update(self,dt)

    if Key:key_down("escape") then
        love.event.quit()
    end
end

function T:draw()
    love.graphics.clear(64,64,255)
    self.super.draw(self)
end

return T
