
local U = {}

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

return U