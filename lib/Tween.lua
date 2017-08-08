
local pow = math.pow

local T = {}
local active_tweens = {}

--Easing functions
function T.linear(ratio) return ratio end
function T.quad_in(ratio) return pow(ratio, 2) end


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