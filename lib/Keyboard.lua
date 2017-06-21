--
--This module keeps track of keys pressed and released
--

local Keyboard = {}
--A table containing keys that have been pressed
--for the current frame
local key_states = {}

function Keyboard:update(dt)
    for k,v in pairs(key_states) do
        key_states[k] = nil
    end
end

--Returns the current state of the given key
function Keyboard:key(key)
    return love.keyboard.isDown(key)
end

--Returns if the key has been pressed THIS frame
function Keyboard:key_down(key)
    return key_states[key]
end

--Returns if the key has been unpressed THIS frame
function Keyboard:key_up(key)
    return key_states[key] == false
end

function Keyboard:hook_love_events()
    function love.keypressed(key, scancode, isrepeat)
        key_states[key] = true
        _G.events:invoke("key_pressed", key)
    end
    function love.keyreleased(key, scancode)
        key_states[key] = false
        _G.events:invoke("key_released", key)
    end

    function love.textinput(text)
        _G.events:invoke("text_input", text)
    end
end

return Keyboard