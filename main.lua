
local x = 120
local dir = 1

function love.load(arg)

end

function love.update(dt)
    if x > 400 or x < 120 then
        di r = dir * -1
    end

    x = x + dir * 200 * dt
end


function love.draw()
    love.graphics.setColor(255,255,255)
    love.graphics.print("Hi there peoplez", 10, 100)
    love.graphics.setColor(128,64,255)
    love.graphics.rectangle("fill", x, 100, 100, 50)
end
