local Class = require("lib.Class")
local Scene = require("lib.Scene")

local SM = Class:derive("SceneMgr")

function SM:new(scene_dir, scenes)
    self.scenes = {}
    self.scene_dir = scene_dir
    
    if not scene_dir then scene_dir = "" end

    if scenes ~= nil then
        assert(type(scenes) == "table", "parameter scenes must be table!")
        for i =1, #scenes do
            local M = require(scene_dir .. "." .. scenes[i])
            assert(M:is(Scene), "File: " .. scene_dir .. "." .. scenes[i] .. ".lua is not of type Scene!")
            self.scenes[scenes[i]] = M(self)
        end
    end

    --these are strings that are keys into the self.scenes table
    self.prev_scene_name = nil
    self.current_scene_name = nil
    --this contains the actual scene object
    self.current = nil
end

--adds a scene to the list where scene is an instance of a sub-class of Scene
function SM:add(scene, scene_name)
    if scene then
        assert(scene_name ~= nil, "parameter scene_name must be specified!")
        assert(type(scene_name) == "string", "parameter scene_name must be string!")
        assert(type(scene) == "table", "parameter scene must be table!")
        assert(scene:is(Scene), "cannot add non-scene object to the scene manager!")
        --assuming the scene is already contructed 
        self.scenes[scene_name] = scene
        
    end
end

--removes a scene from our list
function SM:remove(scene_name)
    if scene_name then
        for k,v in pairs(self.scenes) do
            if k == scene_name then
                self.scenes[k]:destroy()
                self.scenes[k] = nil
                if scene_name == self.current_scene_name then
                    self.current = nil
                end
                break
            end
        end
    end
end

--switches from the current scene to the next_scene
function SM:switch(next_scene)
    if self.current then
        self.current:exit()
    end

    if next_scene then
        assert(self.scenes[next_scene] ~= nil, "Unable to find scene:" .. next_scene)
        self.prev_scene_name = self.current_scene_name
        self.current_scene_name = next_scene
        self.current = self.scenes[next_scene]
        self.current:enter()
    end
end

--Returns to the previous scene if there is one
function SM:pop()
    if self.prev_scene_name then
        self:switch(self.prev_scene_name)
        self.prev_scene_name = nil
    end
end

--Gives a list of all the scene names that the scene manager knows about
function SM:get_available_scenes()
    local scene_names = {}
    for k,v in pairs(self.scenes) do
        scene_names[#scene_names + 1] = k
    end
    return scene_names
end

function SM:update(dt) 
    if self.current then
        self.current:update(dt)
    end
end
function SM:draw()
    if self.current then 
        self.current:draw(dt)
    end
end

return SM