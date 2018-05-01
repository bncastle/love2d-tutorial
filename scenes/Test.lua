local Scene = require("lib.Scene")
local U = require("lib.Utils")
local Vector2 = require("lib.Vector2")
local Vector3 = require("lib.Vector3")

local Entity = require("lib.Entity")
local Transform = require("lib.components.Transform")

local CC = require("lib.components.physics.CircleCollider")
local PC = require("lib.components.physics.PolygonCollider")

local Player = require("../Player")
local Missile = require("../Missile")
local Sat = require("lib.Sat")

local T = Scene:derive("Test")

function T:new(scene_mgr) 
    T.super.new(self, scene_mgr)

    --Player Entitiy
    self.p = Entity(Transform(100, 100, 4, 4), Player(), Player.create_sprite(),CC(32,32),
    PC({Vector2(-8,-8), Vector2(8,-8), Vector2(8,8), Vector2(-8, 8)}))

    self.em:add(self.p)

    --Missile Entity
    self.e = Entity(Transform(350, 100, 1, 1, 0), Missile(), Missile.create_sprite(),CC(62,40),
    PC({Vector2(-62,-40), Vector2(62,-40), Vector2(62,40), Vector2(-62, 40)}))
    self.em:add(self.e)
    
    --Set the missile's target to the player
    self.e.Missile:target(self.p.Transform)
end

function T:update(dt)
    self.super.update(self,dt)

    if Key:key_down("escape") then
        love.event.quit()
    end

    local msuv, amount = Sat.Collide(self.p.PolygonCollider.world_vertices, self.e.PolygonCollider.world_vertices)
    if msuv ~= nil then
        --print(string.format("min sep unit vector: %.2f, %.2f amount: %.2f",msuv.x,msuv.y, amount))
        local sepDir = Vector2(self.p.Transform.x - self.e.Transform.x, self.p.Transform.y - self.e.Transform.y)

        --Swap signs on the Minimum separation unit vector as required to push self.p in the correct direction
        if not U.same_sign(sepDir.x, msuv.x) then msuv.x = msuv.x * -1 end
        if not U.same_sign(sepDir.y, msuv.y) then msuv.y = msuv.y * -1 end

         self.p.Transform.x = self.p.Transform.x + msuv.x * amount
         self.p.Transform.y = self.p.Transform.y + msuv.y * amount
    end

end

function T:draw()
    love.graphics.clear(0.25,0.25,1)
    self.super.draw(self)

    -- local triangle = {100, 100, 200, 100, 150, 305}
    -- local rect = {100, 300, 200, 300, 200, 350, 100, 350}

    -- local msuv, amount = Sat.Collide(Sat.to_Vector2_array(triangle), Sat.to_Vector2_array(rect))
    -- if msuv ~= nil then
    --     print("min sep unit vector: " .. msuv.x .. "," .. msuv.y .. " sep amount:" .. amount)
    -- end

    -- love.graphics.polygon("line", triangle)
    -- love.graphics.polygon("line", rect)
end

return T
