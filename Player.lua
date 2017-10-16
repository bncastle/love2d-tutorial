local Class = require("lib.Class")
local StateMachine = require("lib.StateMachine")
local Anim = require("lib.Animation")
local Sprite = require("lib.Sprite")

local P = Class:derive("Player")

local hero_atlas
local snd

--Animation data
local idle = Anim(16, 16, 16, 16, 4, 4, 6 )
local walk = Anim(16, 32, 16, 16, 6, 6, 12)
local jump = Anim(16, 48, 16, 16, 1, 1, 10, false)
local swim = Anim(16, 64, 16, 16, 6, 6, 12)
local punch = Anim(16, 80, 16, 16, 3, 3, 10, false)

function P:new()
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

    self.anim_sm = StateMachine(self, "idle")
end

function P:idle_enter(dt)
    self.spr:animate("idle")
end

function P:idle(dt)
    if Key:key("left") or Key:key("right") then
        self.anim_sm:change("walk")
    elseif Key:key_down("space") then
        self.anim_sm:change("punch")
    elseif Key:key_down("z") then
        self.anim_sm:change("jump")
    end
end

function P:punch_enter(dt)
    self.spr:animate("punch")
    love.audio.stop(snd)
    love.audio.play(snd)
end

function P:punch(dt)
    if self.spr:animation_finished() then
        self.anim_sm:change("idle")
    end
end

local jumping = false
local y_before_jump = nil

function P:jump_enter(dt)
    jumping = true
    self.spr:animate("jump")
end

function P:jump(dt)
    if not jumping then
        self.anim_sm:change("idle")
        y_before_jump = nil
    elseif Key:key_down("space") then
            self.anim_sm:change("punch")
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
        self.anim_sm:change("idle")
    end
    if Key:key_down("space") then
        self.vx = 0
        self.anim_sm:change("punch")
    elseif Key:key_down("z") then
        self.anim_sm:change("jump")
    end
end

local y_vel = 0
local y_gravity = 1000
function P:update(dt)
    self.anim_sm:update(dt)
    self.spr:update(dt)
    self.spr.pos.x = self.spr.pos.x + self.vx * 115 * dt
    
    -- if Key:key("up") then
    --     self.spr.pos.y = self.spr.pos.y - 115 * dt
    -- elseif Key:key("down") then
    --     self.spr.pos.y = self.spr.pos.y + 115 * dt
    -- end

    if jumping and y_before_jump == nil then
        y_vel = -400
        y_before_jump = self.spr.pos.y
    elseif jumping then
        y_vel = y_vel + y_gravity * dt
        self.spr.pos.y = self.spr.pos.y + y_vel * dt

        if self.spr.pos.y >= y_before_jump then
            jumping = false
            self.spr.pos.y = y_before_jump
            y_before_jump = nil
            self.vx = 0
            self.anim_sm:change("idle")
        end
    end
end

--This function responds to a collision event on any of the
-- given sides of the player's collision rect
-- top, bottom, left, right are all boolean values
function P:collided(top, bottom, left, right)
    if bottom then
        jumping = false
        y_before_jump = nil
        self.vx = 0
        self.anim_sm:change("idle")
    end
end

function P:draw()
    self.spr:draw()
end

return P