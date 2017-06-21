local Class = require("lib.Class")
local Events = require("lib.Events")

local GPM = Class:derive("GamepadMgr")

local DEAD_ZONE = 0.1

local function hook_love_events(self)

    function love.joystickadded(joystick)
        local id = joystick:getID()
        assert(self.connected_sticks[id] == nil, "Joystick " .. id .. "already exists!")
        self.connected_sticks[id] = joystick
        self.is_connected[id] = true
        self.button_map[id] = {}
        self.event:invoke('controller_added', id)
    end

    function love.joystickremoved(joystick)
        local id = joystick:getID()
        self.is_connected[id] = false
        self.connected_sticks[id] = nil
        self.button_map[id] = {}
        self.event:invoke('controller_removed', id)
    end

    function love.gamepadpressed(joystick, button)
        local id = joystick:getID()
        self.button_map[id][button] = true
    end

    function love.gamepadreleased(joystick, button)
        local id = joystick:getID()
        self.button_map[id][button] = false
    end
end

function GPM:new(db_files, ad_enabled)
    if db_files ~= nil then
        for i = 1, #db_files do
            love.joystick.loadGamepadMappings(db_files[i])
        end
    end

    self.event = Events()
    self.event:add('controller_added')
    self.event:add('controller_removed')

    hook_love_events(self)

    --if true, then the left analog joystick will be converted to
    --its corresponding dpad button output
    self.ad_enabled = ad_enabled

    --The currently-connected joysticks
    self.connected_sticks = {}
    self.is_connected = {}
    
    --Maps a joystick id to a table of key values 
    --where the key is a button and the value is either true = just_pressed 
    --false = just_release, nil = none
    self.button_map = {}
end

--Returns true if a joystick with the given id exists
--
function GPM:exists(joyId)
     return self.is_connected[joyId] == nil and self.is_connected[joyId]   
end

--returns the joystick with the given id
--
function GPM:get_stick(joyId)
    return self.connected_sticks[joyId]
end

--Returns true if the given button was just pressed  THIS frame!
function GPM:button_down(joyId, button)
    if self.is_connected[joyId] == nil or self.is_connected[joyId] == false then 
        return false
    else 
        return self.button_map[joyId][button] == true
    end
end

--Returns true if the given button was just released THIS frame!
function GPM:button_up(joyId, button)
    if self.is_connected[joyId] == nil or self.is_connected[joyId] == false then 
        return false
    else 
        return self.button_map[joyId][button] == false
    end
end

--return the instantaneous state of the requested button for the given joystick
function GPM:button(joyId, button)
    local stick = self.connected_sticks[joyid]
    if self.is_connected[joyId] == nil or self.is_connected[joyId] == false then return false end

    local is_down = stick:isGamepadDown(button)
    
    --do we want to convert the left analog stick to dpad buttons?
    if self.ad_enabled and not is_down then
        local xAxis = stick:getGamepadAxis("leftx")
        local yAxis = stick:getGamepadAxis("lefty")
        if button == 'dpright' then
            is_down = xAxis > DEAD_ZONE
        elseif button == 'dpleft' then
            is_down = xAxis < -DEAD_ZONE
        elseif button == 'dpup' then
            is_down = yAxis < -DEAD_ZONE
        elseif button == 'dpdown' then
            is_down = yAxis > DEAD_ZONE
        end
    end
    return is_down
end

function GPM:update(dt)
    for i = 1, #self.is_connected do
        if self.button_map[i] then
            for k,_ in pairs(self.button_map[i]) do
                self.button_map[i][k] = nil
            end
        end
    end
end

return GPM