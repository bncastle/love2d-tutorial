local Anim = require("lib.Animation")
local Sprite = require("lib.Sprite")
local Key = require("lib.Keyboard")
local Evt = require("lib.Events")
local GPM = require("lib.GamepadMgr")

local hero_atlas

local spr
local idle = Anim(16, 16, 16, 16, 4, 4, 6 )
local walk = Anim(16, 32, 16, 16, 6, 6, 12)
local swim = Anim(16, 64, 16, 16, 6, 6, 12)
local punch = Anim(16, 80, 16, 16, 3, 3, 10, false)
local snd
local e

local gpm = GPM({"assets/gamecontrollerdb.txt"})

function love.load()
    Key:hook_love_events()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    hero_atlas = love.graphics.newImage("assets/gfx/hero.png")
    spr = Sprite(hero_atlas, 16,16, 100,100, 10, 10)
    spr:add_animations({idle = idle, walk = walk, swim = swim, punch = punch})
    spr:animate("swim")

    gpm.event:hook('controller_added', on_controller_added)
    gpm.event:hook('controller_removed', on_controller_removed)

    e = Evt()
    e:add('on_space')
    e:hook('on_space', on_space)

    snd = love.audio.newSource("assets/sfx/hit01.wav", "static")
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

    if (Key:key_down("space") or gpm:button_down(1,'a')) and spr.current_anim ~= "punch" then
        spr:animate("punch")
        love.audio.stop(snd)
        love.audio.play(snd)
        e:invoke('on_space')
    elseif Key:key_down("u") then
        e:unhook('on_space', on_space)
    elseif Key:key_down("escape") then
        love.event.quit()
    end   

    if spr.current_anim == "punch" and spr:animation_finished() then
        spr:animate("idle")
    end

    Key:update(dt)
    spr:update(dt)
    gpm:update(dt)
end

function love.draw()
    love.graphics.clear(64,64,255)
    spr:draw()
end
