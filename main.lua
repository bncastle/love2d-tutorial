Key = require("lib.Keyboard")
local GPM = require("lib.GamepadMgr")
local SM = require("lib.SceneMgr")

local snd
local sm

local gpm = GPM({"assets/gamecontrollerdb.txt"})

function love.load()
    Key:hook_love_events()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    gpm.event:hook('controller_added', on_controller_added)
    gpm.event:hook('controller_removed', on_controller_removed)
    
    sm = SM("scenes", {"MainMenu", "Test"})
    -- sm:switch("MainMenu")
    sm:switch("Test")
end

function on_controller_added(joyId)
    print("controller " .. joyId .. "added")
end

function on_controller_removed(joyId)
    print("controller " .. joyId .. "removed")
end

function on_space()
    print("Spaced!")
end

function love.update(dt)
    if dt > 0.035 then return end
    
    if Key:key_down(",") then
        sm:switch("MainMenu")
    elseif Key:key_down(".") then
        sm:switch("Test")
    end

    sm:update(dt)
    Key:update(dt)
    gpm:update(dt)
end

function love.draw()
    sm:draw()
end
