
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
function U.CircleColl(circle1, circle2)
    local d = sqrt( pow (circle1.x - circle2.x, 2) + pow(circle1.y - circle2.y, 2))
    return d < circle1.r + circle2.r
end

return U