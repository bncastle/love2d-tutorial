
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

return U