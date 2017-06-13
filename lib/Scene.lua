local Class = require("lib.Class")
local EntityMgr = require("lib.EntityMgr")

local Scene = Class:derive("Scene")

--function gets called when the scene is loaded
function Scene:new(scene_mgr) 
    self.scene_mgr = scene_mgr
    self.em = EntityMgr()
end

--gets called each time the scene is switched as the main scene
function Scene:enter() end
function Scene:update(dt) self.em:update(dt) end
function Scene:draw() self.em:draw() end
--this is called when the scene is removed from the scene manager
function Scene:destroy() end
function Scene:exit() end

return Scene