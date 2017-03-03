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
local walk = Anim(16, 32, 16, 16, 6, 6, 12)
local swim = Anim(16, 64, 16, 16, 6, 6, 12)

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    hero_atlas = love.graphics.newImage("assets/gfx/hero.png")
    spr = Sprite(hero_atlas, 16,16,100,100, 10, 10)
    spr:add_animation("walk", walk)
    spr:add_animation("swim", swim)
    spr:animate("walk")
    spr:animate("swim")
end

function love.update(dt)
    if dt > 0.035 then return end

    spr:update(dt)
    -- a:update(dt, hero_sprite)
    -- anim_timer = anim_timer - dt
    -- if anim_timer <= 0 then
    --     anim_timer = 1 / fps
    --     frame = frame + 1
    --     if frame > num_frames then frame = 1 end
    --     xoffset = 16 * frame
    --     hero_sprite:setViewport(xoffset, 32, 16, 16)
    -- end
end

function love.draw()
    love.graphics.clear(64,64,255)
    -- love.graphics.draw(hero_atlas, 25, 25, 0, 1, 1)
    spr:draw()
end
