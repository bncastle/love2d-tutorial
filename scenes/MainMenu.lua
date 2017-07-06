local Scene = require("lib.Scene")
local Button = require("lib.ui.Button")
local Label = require("lib.ui.Label")
local U = require("lib.Utils")
local TextField = require("lib.ui.TextField")
local Slider = require("lib.ui.Slider")

local MM = Scene:derive("MainMenu")

function MM:new(scene_mgr)
    MM.super.new(self, scene_mgr)

    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()
    
    local start_button = Button(sw / 2, sh / 2 - 30, 140, 40, "Start")
    local exit_button = Button(sw / 2, sh / 2 + 30, 140, 40, "Exit")
    exit_button:colors({0, 128, 0, 255}, {64, 212, 64, 255}, {200, 255, 200, 255})

    local mmtext = Label(0, 20, love.graphics.getWidth(), 40, "Main Menu")

    self.tf = TextField(love.graphics.getWidth() / 2- 50, 60, 100, 40, "hello", U.gray(196), "left")

    self.slider = Slider(love.graphics.getWidth() / 2 - 100 , 125, 200, 40, "volume")

    self.em:add(start_button)
    self.em:add(exit_button)
    self.em:add(mmtext)
    self.em:add(self.tf)
    self.em:add(self.slider)

    self.click = function(btn)  self:on_click(btn) end
    self.slider_changed = function(slider) self:on_slider_changed(slider) end
end

local entered = false
function MM:enter()
    MM.super.enter(self)   
    _G.events:hook("onBtnClick", self.click)
    _G.events:hook("onSliderChanged", self.slider_changed)
end

function MM:exit()
    MM.super.exit(self)
    _G.events:unhook("onBtnClick", self.click)
    _G.events:unhook("onSliderChanged", self.slider_changed)
end

function MM:on_slider_changed(slider)
    -- print(slider.id)
    -- print(slider:get_value())
end

function MM:on_click(button)
    print("Button Clicked: " .. button.text)
    if button.text == "Start" then
        self.scene_mgr:switch("Test")
    elseif button.text == "Exit" then
        love.event.quit()
    end
end

local prev_down = false
function MM:update(dt)
    self.super.update(self,dt)

    if Key:key_down("escape") then
        love.event.quit()
    -- elseif Key:key_down("space") then
    --     self.button:enable(not self.button.interactible)
    end

    --mouse stuff
    local mx,my = love.mouse.getPosition()
    local down = love.mouse.isDown(1)

    --if the mouse left btn was just clicked...
    if down and not prev_down then
        if U.point_in_rect({x=mx, y=my}, self.tf:get_rect()) then
            self.tf:set_focus(true)
        else
            self.tf:set_focus(false)
        end
    end

    prev_down = down
    
end

return MM
