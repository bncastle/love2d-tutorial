
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
    local t = 0
    local from = target[prop_name]
    local diff = to - from

    local update = function(dt)
        if t >= duration then
            target[prop_name] = to
            return true
        end

        --tween the property here
        target[prop_name] = from + diff * ease_function(t / duration)

        t = t + dt
        return false
    end
    
    --add tween to active
    active_tweens[#active_tweens + 1] = update
    --TODO: maybe return something so we can stop or complete the tween early
end

function T.update(dt)
    for i=#active_tweens, 1, -1 do
        if active_tweens[i](dt) then
            --toto: if the tween has a completion function, then call it
            table.remove(active_tweens, i)
        end
    end
end

return T