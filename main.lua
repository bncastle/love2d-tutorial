local Anim = require("Animation")
local Sprite = require("Sprite")

local hero_atlas

local angle = 0

--animation parameters-
local fps = 12
local anim_timer = 1 / fps
local frame = 1
local num_frames = 6
local xoffset
-----------------------

local spr
local idle = Anim(16, 16, 16, 16, 4, 4, 6 )
local walk = Anim(16, 32, 16, 16, 6, 6, 12)
local swim = Anim(16, 64, 16, 16, 6, 6, 12)
local punch = Anim(16, 80, 16, 16, 3, 3, 10, false)
local snd

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    hero_atlas = love.graphics.newImage("assets/gfx/hero.png")
    spr = Sprite(hero_atlas, 16,16, 100,100, 10, 10)
    spr:add_animation("walk", walk)
    spr:add_animation("swim", swim)
    spr:add_animation("punch", punch)
    spr:add_animation("idle", idle)
    spr:animate("idle")

    snd = love.audio.newSource("assets/sfx/hit01.wav", "static")
end

function love.update(dt)
    if dt > 0.035 then return end

    if spr.current_anim == "punch" and spr:animation_finished() then
        spr:animate("idle")
    end

    spr:update(dt)

end

function love.draw()
    love.graphics.clear(64,64,255)
    spr:draw()
end

function love.keypressed(key, scancode, isrepeat)
    if key == "space" and spr.current_anim ~= "punch" then
        spr:animate("punch")
        love.audio.stop(snd)
        love.audio.play(snd)
    end
end

