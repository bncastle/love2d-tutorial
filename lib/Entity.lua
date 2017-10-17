local Class = require("lib.Class")
local U = require("lib.Utils")

local E = Class:derive("Entity")

function E:new()
    self.components = {}
end

--helps us sort our priorities because priorities are important
local function priority_compare(e1, e2)
    return e1.priority < e2.priority
end

function E:add(component)
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

    if component.type and type(component.type) == "string" then
        self[component.type] = component
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

function E:update(dt)
    for i = 1, #self.components do
        local component = self.components[i]
        --if the component is enabled, then update it
        if component.enabled then
            if not component.started then
                component.started = true
                if component.on_start then component:on_start() end
            elseif component.update then
                component:update(dt)
            end
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