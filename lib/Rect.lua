--For a good article on Minowski sums/differences to determin separation vector, see:
--http://hamaluik.com/posts/simple-aabb-collision-using-minkowski-difference/

local Class = require("lib.Class")
local Vector2 = require("lib.Vector2")

local R = Class:derive("Rect")

local abs = math.abs

--where (x,y) indicate the upper left corner of the rect
function R:new(x, y, w, h)
    self.x = x or 0
    self.y = y or 0
    self.w = w or 0
    self.h = h or 0
end

--where (x,y) indicates the center of the rect
function R.create_centered(cx, cy, w, h)
    local r = R(0,0,w,h)
    r:set_center(cx,cy)
    return r
end

function R:center()
    return Vector2(self.x + self.w / 2, self.y + self.h / 2)
end

function R:set_center(x,y)
    self.x = x - self.w / 2
    self.y = y - self.h / 2
end

function R:min()
    return Vector2(self.x, self.y)
end

function R:max()
    return Vector2(self.x + self.w, self.y + self.h)
end

function R:size()
    return Vector2(self.w, self.h)
end

--other is also a Rect
function R:minkowski_diff(other) 
    local top_left = Vector2.sub(self:min(), other:max())
    local newSize = Vector2.add(self:size(), other:size())
    local newLeft = Vector2.add(top_left, Vector2.divide(newSize,2))
    return R.create_centered(newLeft.x, newLeft.y, newSize.x, newSize.y)
end

--Returns a Vector2 that indicates the point on the
--rectangle's boundary that is closest to the given point
--
function R:closest_point_on_bounds(point)
    local min_dist = abs(point.x - self.x)
    local max = self:max()
    local bounds_point = Vector2(self.x, point.y)

    --finish checking x axis
    if abs(max.x - point.x) < min_dist then
        min_dist = abs(max.x - point.x)
        bounds_point = Vector2(max.x, point.y)
    end

    --move to y axis
    if abs(max.y - point.y) < min_dist then
        min_dist = abs(max.y - point.y)
        bounds_point = Vector2(point.x, max.y)
    end

    if abs(self.y - point.y) < min_dist then
        min_dist = abs(self.y - point.y)
        bounds_point = Vector2(point.x, self.y)
    end

    return bounds_point
end

--Given a bounds point obtained from Rect.closest_point_on_bounds()
--this returns true if a collision occurred on the right side of the rectangle
function R:collides_right(bounds_point)
    return bounds_point.x < 0 
end

--Given a bounds point obtained from Rect.closest_point_on_bounds()
--this returns true if a collision occurred on the left side of the rectangle
function R:collides_left(bounds_point)
    return bounds_point.x > 0 
end

--Given a bounds point obtained from Rect.closest_point_on_bounds()
--this returns true if a collision occurred on the top of the rectangle
function R:collides_bottom(bounds_point)
    return bounds_point.y < 0 
end

--Given a bounds point obtained from Rect.closest_point_on_bounds()
--this returns true if a collision occurred on the bottom of the rectangle
function R:collides_top(bounds_point)
    return bounds_point.y > 0 
end
return R