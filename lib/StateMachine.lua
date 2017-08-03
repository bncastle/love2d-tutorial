local Class = require("lib.Class")
-- local Vector2 = require("lib.Vector2")

local SM = Class:derive("StateMachine")

local transition = {
    enter = "_enter",
    none = "",
    exit = "_exit"
}

function SM:new(state)
    self:reset()
    self:change(state)
end

function SM:reset()
    self.state = nil
    self.prev = nil
    self.transition = transition.none
end

--Changes to a state without calling the previous state's state_exit function
--
function SM:change_immediate(state)
    assert(type(state) == "string" or type(state) == "nil", "parameter state must be of type string or nil!")
    assert(state == nil or self[state] ~= nil, "Can't find state: " .. state .. "as a state function!")

    self.prev = self.state
    self.state = state
    if self.state ~= nil and self[self.state .. transition.enter] ~= nil then
        self.transition = transition.enter
    else
        self.transition = transition.none
    end
end

function SM:change(state)
    --TODO allow forcing a state to change to itself
    if state == prev then return end
    self:change_immediate(state)
    if prev ~= nil and self[prev .. transition.exit] ~= nil then
        self.transition = transition.exit
    end    
end

function SM:update(dt)
    if self.transition == transition.exit then
        self[self.prev .. self.transition](self, dt) --previous_state_exit(dt)
        
        if self.state ~= nil and self[self.state .. transition.enter] ~= nil then
            self.transition = transition.enter
        else
            self.transition = transition.none
        end

    elseif self.transition == transition.enter then
        self[self.state .. self.transition](self,dt)  --state_enter(dt)
        self.transition = transition.none
    elseif self.state ~= nil then 
        self[self.state](self, dt)  --state(dt)
    end
end

function SM:draw() end

return SM



-- function idle_enter(dt)
-- end

-- function idle(dt)
-- end

-- function idle_exit(dt)
-- end


-- function idle()
--     if self.transition == transition.enter then
--         --do enter stuff
--     elseif self.transition == transition.none then 
--         -- do something
--     else --transition.exit
--         --do exit stuff
--     end
-- end
