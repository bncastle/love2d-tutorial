local Scene = require("lib.Scene")

local MM = Scene:derive("MainMenu")

function MM:draw()
    love.graphics.print("Hello there from Main Menu!", 200, 25)
end
return MM
