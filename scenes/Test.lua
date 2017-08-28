local Scene = require("lib.Scene")
local U = require("lib.Utils")
local Player = require("../Player")
local Enemy = require("../Enemy")

local T = Scene:derive("Test")

function T:new(scene_mgr) 
    T.super.new(self, scene_mgr)
    self.p = Player()
    self.em:add(self.p)

    self.e = Enemy()
    self.e.spr.tintColor = U.color(255,0,0,255)
    self.e.spr.pos.x = 320
    self.em:add(self.e)
end

function T:update(dt)
    self.super.update(self,dt)

    if Key:key_down("escape") then
        love.event.quit()
    end

    if U.AABBColl(self.p.spr:rect(), self.e.spr:rect()) then
        self.p.spr.tintColor = U.color(0,128,128,200)
    else
        self.p.spr.tintColor = U.color(255)
    end

end

function T:draw()
    love.graphics.clear(64,64,255)
    self.super.draw(self)
end

return T
