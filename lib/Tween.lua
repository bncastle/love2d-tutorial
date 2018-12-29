
local pow = math.pow
local sin = math.sin
local cos = math.cos
local PI = math.pi

local T = {}
local active_tweens = {}

--Easing functions
function T.linear(ratio) return ratio end

function T.quad_in(ratio) return pow(ratio, 2) end
function T.quad_out(ratio) return ratio * (2 - ratio) end
function T.quad_inout(ratio) 
    if ratio < 0.5 then
        return 2 * pow(ratio,2)
    else
        return 1 - 2 * pow(ratio - 1, 2)
    end
end

function T.cubic_in(ratio) return pow(ratio, 3) end
function T.cubic_out(ratio) return pow(ratio -1, 3) + 1 end
function T.cubic_inout(ratio) 
    if ratio < 0.5 then
        return 4 * pow(ratio,3)
    else
        return 1 + 4 * pow((ratio -1), 3)
    end
end


function T.quart_in(ratio) return pow(ratio, 4) end
function T.quart_out(ratio) return 1 - pow(ratio - 1, 4) end
function T.quart_inout(ratio) 
    if ratio < 0.5 then
        return 8 * pow(ratio,4)
    else
        return 1 - 8 * pow(ratio - 1, 4)
    end
end

function T.quint_in(ratio) return pow(ratio, 5) end
function T.quint_out(ratio) return pow(ratio -1, 5) + 1 end
function T.quint_inout(ratio) 
    if ratio < 0.5 then
        return 16 * pow(ratio,5)
    else
        return 1 + 16 * pow(ratio -1, 5)
    end
end

function T.sine_in(ratio) return 1 - cos(ratio * PI / 2) end
function T.sine_out(ratio) return sin(ratio * PI / 2) end
function T.sine_inout(ratio) return (1 + sin(ratio * PI - PI /2)) / 2  end

function T.back_out(ratio) return ratio * (2 - ratio * ratio) end
--TODO Create elastic and bounce easings

-- function T:create(target, prop_name, from, to, duration)
function T.create(target, prop_name, to, duration, ease_function)
    assert(type(target) == "table", "target parameter must be a table!")
    assert(type(prop_name) == "string", "prop_name parameter must be a string!")

    -- 
    local tween = {
        t = 0,
        from = target[prop_name],
        diff = to - target[prop_name],
        to = to,
        duration = duration,
        target = target,
        update = function(self, dt)
            if self.stop_tween then return false end
            if self.t >= self.duration then
                    self.target[prop_name] = to
                return false
            end
    
            --tween the property here
            self.target[prop_name] = self.from + self.diff * ease_function(self.t / self.duration)
    
            self.t = self.t + dt
            return true            
        end,
        cancel = function(self, should_complete)
            self.stop_tween = true
            if should_complete then
                self.target[prop_name] = self.to
            end
        end
    }
    
    --add tween to active
    active_tweens[#active_tweens + 1] = tween
    --return the new tween table
    return tween
end

function T.update(dt)
    for i=#active_tweens, 1, -1 do
        if not active_tweens[i]:update(dt) then
            local t = active_tweens[i]
            table.remove(active_tweens, i)
            if(t.on_complete) then t:on_complete() end
        end
    end
end

return T