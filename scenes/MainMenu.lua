local Scene = require("lib.Scene")
local Button = require("lib.ui.Button")

local MM = Scene:derive("MainMenu")

function MM:new(scene_mgr)
    self.super(scene_mgr)
    self.button = Button(100, 100, 140, 40, "Press Me!")
end

function MM:enter()
    _G.events:hook("onBtnClick", on_click)    
end

function MM:exit()
    _G.events:unhook("onBtnClick", on_click)
end

function on_click(button)
    print("Button Clicked: " .. button.label)
end


function MM:update(dt)
    if Key:key_down("escape") then 
        love.event.quit()
    elseif Key:key_down("space") then
        self.button:enable(not self.button.interactible)
    end

    self.button:update(dt)
end

function MM:draw()
    self.button:draw()
    love.graphics.print("Hello there from Main Menu!", 200, 25)
end

return MM
