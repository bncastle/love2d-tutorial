local utf8 = require("utf8")
local U = require("lib.Utils")
local Label = require("lib.ui.Label")
local TextField = Label:derive("TextField")

local cursor = '|'

--On Android and iOS, textinput is disabled by default; 
--call love.keyboard.setTextInput to enable it. 

function TextField:new(x, y, w, h, text, color, align)
    TextField.super.new(self, x, y, w, h, text, color, align)
    self.focus = false
    self.focused_color = U.color(128)
    self.unfocused_color = U.color(32)
    self.back_color = self.unfocused_color
    
    --TODO: Add capability to limit # of characters allowed in the input field
    --TODO: Add "enter" key detection too
    self.key_pressed = function(key)
        if key == "backspace" then
            self:on_text_input(key)
        end
    end
    self.text_input = function(text)
        self:on_text_input(text)
    end
end

function TextField:get_rect()
    return {x = self.pos.x, y = self.pos.y - self.h / 2, w = self.w, h = self.h}
end

function TextField:on_enter()
    _G.events:hook("key_pressed", self.key_pressed)
    _G.events:hook("text_input", self.text_input)
end

function TextField:on_exit()
    _G.events:unhook("key_pressed", self.key_pressed)
    _G.events:unhook("text_input", self.text_input)
end

function TextField:set_focus(focus)
    assert(type(focus) == 'boolean', "focus should be of type boolean")
    if focus then
        self.back_color = self.focused_color

        if not self.focus then
            self.text = self.text .. cursor
        end
    else
        self.back_color = self.unfocused_color
        if not focus and self.focus then
            self:remove_end_chars(1)
        end
    end
    self.focus = focus
end

function TextField:on_text_input(text)
    if not self.focus or not self.enabled then
        return 
    end
    
    if text == "backspace" then
        self:remove_end_chars(2)
        self.text = self.text .. cursor
    else
        self:remove_end_chars(1)
        self.text = self.text .. text
        self.text = self.text .. cursor
    end
end

function TextField:remove_end_chars(num)
    -- get the byte offset to the last UTF-8 character in the string.
    local byteoffset = utf8.offset(self.text, -num)
    
    if byteoffset then
        -- remove the last UTF-8 character.
        -- string.sub operates on bytes rather than UTF-8 characters, 
        --so we couldn't do string.sub(text, 1, -2).
        self.text = string.sub(self.text, 1, byteoffset - 1)
    end
end

function TextField:draw()
    love.graphics.setColor(self.back_color)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y - self.h / 2, self.w, self.h)
    TextField.super.draw(self)
end

return TextField
