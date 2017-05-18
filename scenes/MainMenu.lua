local Scene = require("lib.Scene")
local Button = require("lib.ui.Button")

local MM = Scene:derive("MainMenu")

function MM:new(scene_mgr)
    self.super(scene_mgr)
    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()

    self.start_button = Button(sw / 2, sh / 2 - 30 , 140, 40, "Start")
    self.exit_button = Button(sw / 2, sh / 2 + 30 , 140, 40, "Exit")
    self.exit_button:colors({0,128,0,255}, {64, 212, 64, 255 }, {200, 255, 200, 255})
    self.click = function(btn) self:on_click(btn) end
end

function MM:enter()
    _G.events:hook("onBtnClick", self.click)    
end

function MM:exit()
    _G.events:unhook("onBtnClick", self.click)
end

function MM:on_click(button)
    print("Button Clicked: " .. button.label)
    if button == self.start_button then
        self.scene_mgr:switch("Test")
    elseif button == self.exit_button then
        love.event.quit()
    end
end


function MM:update(dt)
    if Key:key_down("escape") then 
        love.event.quit()
    elseif Key:key_down("space") then
        self.button:enable(not self.button.interactible)
    end

    self.start_button:update(dt)
    self.exit_button :update(dt)
end

function MM:draw()
    self.start_button:draw()
    self.exit_button:draw()
    love.graphics.printf("Main Menu", 0, 25, love.graphics.getWidth(), "center")
end

return MM
