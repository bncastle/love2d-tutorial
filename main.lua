Key = require("lib.Keyboard")
local GPM = require("lib.GamepadMgr")
local SM = require("lib.SceneMgr")
local Event = require("lib.Events")

local sm

local gpm = GPM({"assets/gamecontrollerdb.txt"})

function love.load()
    --Love2D game settings
    love.graphics.setDefaultFilter('nearest', 'nearest')
    local font = love.graphics.newFont("assets/SuperMario256.ttf", 20)
    --set the font to the one above
    love.graphics.setFont(font)

    _G.events = Event(false)

    Key:hook_love_events()

    gpm.event:hook('controller_added', on_controller_added)
    gpm.event:hook('controller_removed', on_controller_removed)
    
    sm = SM("scenes", {"MainMenu", "Test"})
    sm:switch("MainMenu")
    -- sm:switch("Test")
end

function on_controller_added(joyId)
    print("controller " .. joyId .. "added")
end

function on_controller_removed(joyId)
    print("controller " .. joyId .. "removed")
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
