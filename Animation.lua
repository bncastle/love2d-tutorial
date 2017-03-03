local class = require("class")
local Anim = class:derive("Animation")
local Vector2 = require("Vector2")

function Anim:new()
    self.fps = 
    self.timer = 1 / self.fps
    self.frame = 
    self.num_frames = 
    self.offset = Vector2()
    self.size = Vector2()
end

function Anim:update(dt, quad)
    if(self.num_frames <= 1) then return end

    self.timer = self.timer - dt
    if(self.timer <= 0) then
        self.timer = 1 / self.fps
        self.frame = self.frame + 1
        if self.frame > self.num_frames then 
            self.frame = 1 
        end
        self.offset.x = self.size.x * frame
    end
end

return Anim