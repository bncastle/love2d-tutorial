local Class = require("lib.Class")

local EM = Class:derive("EntityMgr")

local function contains(list, item)
    for val in pairs(list) do
        if val == item then return true end
    end
    return false
end

local function layer_compare(e1, e2)
    return e1.layer < e2.layer
end

function EM:new()
    self.entities = {}
end

function EM:add(entity)
    if contains(self.entities, entity) then return end

    --Add additional table entries that we want to exist for all entities
    entity.layer = entity.layer or 1
    entity.started = entity.started or false
    self.entities[#self.entities + 1] = entity

    --TODO: Sort entities
    table.sort(self.entities, layer_compare)

end

function EM:update(dt)
    for i = 1, #self.entities do
        local e = self.entities[i]

        if e.remove == true then
            e.remove = false
            if e.on_remove then e:on_remove() end
            table.remove(self.entities, i)
            i = i -1
        elseif not e.started then
            e.started = true
            if e.on_start then e:on_start() end
        else
            e:update(dt)
        end

    end
end

function EM:draw()
    for i = 1, #self.entities do
        self.entities[i]:draw()
    end
end

return EM