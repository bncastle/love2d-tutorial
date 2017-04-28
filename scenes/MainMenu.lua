local Scene = require("lib.Scene")
local Button = require("lib.ui.Button")

local MM = Scene:derive("MainMenu")

function MM:new(scene_mgr)
    self.super(scene_mgr)
    self.button = Button(100, 100, 125, 40)

end

function MM:draw()
    self.button:draw()
    love.graphics.print("Hello there from Main Menu!", 200, 25)
end
return MM
