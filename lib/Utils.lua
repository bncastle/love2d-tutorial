local Vector2 = require("lib.Vector2")

local U = {}
local pow = math.pow
local sqrt = math.sqrt

function U.color(r, g, b, a)
    return {r, g or r, b or r, a or 255}
end

function U.gray(level, alpha)
    return {level, level, level, alpha or 255}
end

function U.point_in_rect(point, rect)
    return not(
        point.x < rect.x or
        point.x > rect.x + rect.w or
        point.y < rect.y or
        point.y > rect.y + rect.h)
end

--rx,ry is the upper left corner of the rectangle
--rw,rh is the width and height of the rectangle
function U.mouse_in_rect(mx, my, rx, ry, rw, rh)
    return not (mx < rx or mx > rx + rw or my < ry or my > ry + rh) 
end

--Axis-Aligned Bounding Box collision detection
--
function U.AABBColl(rect1, rect2)
    local rect1r = rect1.x + rect1.w
    local rect1b = rect1.y + rect1.h
    
    local rect2r = rect2.x + rect2.w
    local rect2b = rect2.y + rect2.h

    return rect1r >= rect2.x and rect2r >= rect1.x and
           rect1b >= rect2.y and rect2b >= rect1.y
end

--Circle to circle collision. Refine this!
--returns boolean -> true if circles overlap, false otherwise, 
--if colliding then also returns a minimum separation unit vector
function U.CircleOverlaps(circle1, circle2)
    local c1toc2 = Vector2(circle1.x - circle2.x, circle1.y - circle2.y)
    local d = c1toc2:mag()

    local overlaps = d < circle1.r + circle2.r

    if overlaps then
        local unit = c1toc2:unit()
        unit:mul(circle1.r + circle2.r - d)
        return true, unit
    else
        return false
    end
end

--Collides circle1 with circle2 if they overlap
--it will apply a separation to one or both circles
--parameters: circle1, circle2 are the circles in question
--            ratio: a number from 0 to 1 that affects how much of the separation
--                   to apply to circle1 vs circle2
--
--returns: true if the two circles collided, false otherwise
function U.CirclesCollide(circle1, circle2, ratio)
    ratio = ratio or 1

    --ensure that the ratio is between 0 and 1
    if ratio < 0 then ratio = 0 
    elseif ratio > 1 then ratio = 1
    end
    
    local overlaps, sep = U.CircleOverlaps(circle1, circle2)
    if overlaps then
        --With this, only the first circle will be moved
        circle1.x = circle1.x + sep.x * ratio
        circle1.y = circle1.y + sep.y * ratio

        circle2.x = circle2.x - sep.x * (1 - ratio)
        circle2.y = circle2.y - sep.y * (1 - ratio)
    end
    return overlaps
end

return U