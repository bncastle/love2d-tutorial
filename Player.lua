local StateMachine = require("lib.StateMachine")
local Anim = require("lib.Animation")
local Sprite = require("lib.Sprite")

local P = StateMachine:derive("Player")

local hero_atlas
local snd

--Animation data
local idle = Anim(16, 16, 16, 16, 4, 4, 6 )
local walk = Anim(16, 32, 16, 16, 6, 6, 12)
local jump = Anim(16, 48, 16, 16, 1, 1, 10)
local swim = Anim(16, 64, 16, 16, 6, 6, 12)
local punch = Anim(16, 80, 16, 16, 3, 3, 10, false)

function P:new(state)
    if hero_atlas == nil then
        hero_atlas = love.graphics.newImage("assets/gfx/hero.png")
    end
    if snd == nil then
        snd = love.audio.newSource("assets/sfx/hit01.wav", "static")
    end

    self.spr = Sprite(hero_atlas,100,100, 16, 16, 4, 4)
    self.spr:add_animations({idle = idle, walk = walk, swim = swim, punch = punch, jump = jump})
    self.spr:animate("idle")
    self.vx = 0

    self.super.new(self, state)
end

function P:idle_enter(dt)
    self.spr:animate("idle")
end

function P:idle(dt)
    if Key:key("left") or Key:key("right") then
        self:change("walk")
    elseif Key:key_down("space") then
        self:change("punch")
    end
end

function P:punch_enter(dt)
    self.spr:animate("punch")
    love.audio.stop(snd)
    love.audio.play(snd)
end

function P:punch(dt)
    if self.spr:animation_finished() then
        self:change("idle")
    end
end

function P:walk_enter(dt)
    self.spr:animate("walk")
end

function P:walk(dt)

    if Key:key("right") and not Key:key("left") and vx ~= 1 then
        self.spr:flip_h(false)
        self.vx = 1    
    elseif Key:key("left") and not Key:key("right") and vx ~= -1 then
        self.spr:flip_h(true)
        self.vx = -1
    elseif not Key:key("left") and not Key:key("right") then
        self.vx = 0
        self:change("idle")
    end
    if Key:key_down("space") then
        self.vx = 0
        self:change("punch")
    -- elseif Key:key_down("up") then
    --     self.change("jump")
    end
end

function P:update(dt)
    self.super.update(self, dt)
    self.spr:update(dt)

    self.spr.pos.x = self.spr.pos.x + self.vx * 115 * dt
end

function P:draw()
    self.spr:draw()
end

return P