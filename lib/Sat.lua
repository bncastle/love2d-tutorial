local Vector2 = require("lib.Vector2")

local S = {}

local function contains_axis(edges, unit_normal)
    for i = 1, #edges do
        if math.abs(unit_normal:dot(edges[i])) == 1 then return true end
    end
    return false
end

--Retrieves all the edge normals from a polygon
-- given a list of Vector2 points that make up the polygon
--
local function get_edge_normals(vertices)
    if vertices == nil or #vertices == 0 then return nil end

    local edge_normals = {}

    for i = 1, #vertices do
        local p1 = vertices[i]
        local p2 = vertices[i + 1] or vertices[1]
        --subtract these 2 to get the edge vector
        local edge = Vector2.sub(p1,p2)
        --Get the edge normal
        local normal = edge:normal():unit()
        
        --Check if the edge is valid (i.e. magnitude is > 0)
        if edge:mag() > 0 and not contains_axis(edge_normals, normal) then
            edge_normals[#edge_normals + 1] = normal
        end
    end
    
    return edge_normals
end

--Projects the given vertices onto the given axis
--
local function project_onto_axis(vertices, axis)
    local min = axis:dot(vertices[1])
    local max = min

    for i = 2, #vertices do
        local proj = axis:dot(vertices[i])
        if proj < min then min = proj
        elseif proj > max then max = proj
        end 
    end
    return min, max
end

function S.to_Vector2_array(tbl)
    local vertices = {}

    assert(#tbl % 2 == 0, "Table must have an even number of elements!")

    for i = 1, #tbl, 2 do
        vertices[#vertices + 1] = Vector2(tbl[i], tbl[i + 1])
    end

    return vertices
end

--Performs the Separating Axis Theorem calculations on the 
--given polygons. returns the minimum penetration axis and overlap amount separation vector if colliding
--nil,nil otherwise
--
function S.Collide(poly1, poly2)
    local axes = get_edge_normals(poly1)
    local axes2 = get_edge_normals(poly2)
    local min_pentration_axis = nil
    local overlap = 0xEFFFFFFF
    --concatenate axes2 into axes
    for i =1, #axes2 do axes[#axes + 1] = axes2[i] end

    --loop over all the possible separating axes and
    --if we find even 1 that does not overlap, then we are DONE
    for i = 1, #axes do
        local axis = axes[i]
        --project both shapes onto the current axis
        local p1min, p1max = project_onto_axis(poly1, axis)
        local p2min, p2max = project_onto_axis(poly2, axis)

        --now check for no overlap. If no overlap, return nil and we're done
        if p1min > p2max or p2min > p1max then return nil end
        --otherwise, grab the amount of overlap
        local o = math.min(p1max, p2max) - math.max(p1min, p2min)
        if o < overlap then 
            overlap = o
            min_pentration_axis = axis
        end
    end

    --if we get here then we are colliding
    assert(min_pentration_axis ~=nil)
    return min_pentration_axis, overlap
end

return S