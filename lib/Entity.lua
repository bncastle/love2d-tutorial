local Class = require("lib.Class")
local U = require("lib.Utils")

local E = Class:derive("Entity")

function E:new(...)
    self.components = {}
    local components_to_add = {...}
    
    if #components_to_add > 0 then
        for i = 1, #components_to_add do
            self:add(components_to_add[i])
        end
    end
end

--helps us sort our priorities because priorities are important
local function priority_compare(e1, e2)
    return e1.priority < e2.priority
end

--Add a component to this entity
--
--Note: name is optional and if it is not used, the component's class type
--will be used instead
function E:add(component, name)
    if U.contains(self.components, component) then return end
    --Add additional table entries that we want to exist for all components

    --higher priority components will be updated/drawn before lower priority ones
    component.priority = component.priority or 1
    --indicates if the on_started function has been called on a component
    component.started = component.started or false
    --if a component is enabled, then it is drawn/updated
    component.enabled = (component.enabled == nil) or component.enabled
    --Let the component know who its parent is
    component.entity = self

    --Add the component to the list
    self.components[#self.components + 1] = component

    if name ~=nil and type(name) == "string" and name.len() > 0 then
        assert(self[name] == nil, "This entity already contains a component of name: " .. name)
        self[name] = component
    elseif component.type and type(component.type) == "string" then
        assert(self[component.type] == nil, "This entity already contains a component of name: " .. component.type)
        self[component.type] = component
    end

    -- if component.on_added then component:on_added() end

    if self.started and not component.started and component.enabled then
        component.started = true
        if component.on_start then component:on_start() end
    end
    
    --Sort components
    table.sort(self.components, priority_compare)
end

function E:remove(component)
    local i = U.index_of(self.components, component)
    if i == -1 then return end

    --if the component has an on_remove event, call it
    if component.on_remove then component:on_remove() end
    --then remove it
    table.remove(self.components, i)

    --check if the component has a type property of type string
    --if so, remove it from this entity
    if component.type and type(component.type) == "string" then
        self[component.type] = nil
        component.entity = nil
    end
end

function E:on_start()
    for i = 1, #self.components do
        local component = self.components[i]
        --if the component is enabled, then call on_start() if it has one
        if component.enabled then
            if not component.started then
                component.started = true
                if component.on_start then component:on_start() end
            end
        end
    end
end

function E:update(dt)
    for i = 1, #self.components do
        --if the component is enabled, then update it
        if self.components[i].enabled and self.components[i].update then
            self.components[i]:update(dt)
        end
    end
end

function E:draw()
    for i = 1, #self.components do
        if self.components[i].enabled and self.components[i].draw then
            self.components[i]:draw()
        end
    end
end

return E