
local hero_atlas
local hero_sprite

local angle = 0

--animation parameters
local fps = 15
local anim_timer = 1 / fps
local frame = 1
local num_frames = 6
local xoffset

function love.load(arg)
    love.graphics.setDefaultFilter('nearest', 'nearest')
    hero_atlas = love.graphics.newImage("assets/gfx/hero.png")
    hero_sprite = love.graphics.newQuad(16, 32, 16, 16, hero_atlas:getDimensions())
end

function love.update(dt)
    if dt > 0.035 then return end
    -- angle = angle + 27.5 * dt
    anim_timer = anim_timer - dt
    if anim_timer <= 0 then
        anim_timer = 1 / fps
        frame = frame + 1
        if frame > num_frames then frame = 1 end
        xoffset = 16 * frame
        hero_sprite:setViewport(xoffset,32, 16, 16)
    end
end


function love.draw()
    love.graphics.draw(hero_atlas, hero_sprite,320, 180, math.rad(angle), 10, 10, 8, 8)
end
