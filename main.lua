
local hero_atlas
local hero_sprite

local angle = 0

function love.load(arg)
    love.graphics.setDefaultFilter('nearest', 'nearest')
    hero_atlas = love.graphics.newImage("assets/gfx/hero.png")
    hero_sprite = love.graphics.newQuad(32, 16, 16, 16, hero_atlas:getDimensions())
end

function love.update(dt)
    if dt > 0.035 then return end
    angle = angle + 27.5 * dt
end


function love.draw()
    love.graphics.draw(hero_atlas, hero_sprite,320, 180, math.rad(angle), 4, 4, 8, 8)
end
