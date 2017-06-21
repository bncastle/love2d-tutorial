local Class = require("lib.Class")

local Events = Class:derive("Events")

function Events:new(event_must_exist)
    self.handlers = {}
    self.event_must_exist = (event_must_exist == nil) or event_must_exist
end

local function index_of(evt_tbl, callback)
    if(evt_tbl == nil or callback == nil) then return -1 end
    for i = 1, #evt_tbl do
        if evt_tbl[i] == callback then return i end
    end
    return -1
end

--Returns true if the event exists, false otherwise
function Events:exists(evt_type)
    return self.handlers[evt_type] ~= nil
end

--Add a new event type to our table
function Events:add(evt_type)
    assert(self.handlers[evt_type] == nil, "Event " .. evt_type .. " already exists!")
    self.handlers[evt_type] = {}
end

--Remove an event type from our table
function Events:remove(evt_type)
    self.handlers[evt_type] = nil
end

--Subscribe to an event
function Events:hook(evt_type, callback)
    assert(type(callback) == "function", "callback parameter must be a function!")

    if self.event_must_exist then
        assert(self.handlers[evt_type] ~= nil, "Event of type " .. evt_type .. " does not exist!")
    elseif(self.handlers[evt_type] == nil) then
        self:add(evt_type)
    end

    -- if(index_of(self.handlers[evt_type], callback) > -1) then return end
    assert(index_of(self.handlers[evt_type], callback) == -1, "callback has already been registered!")

    local tbl = self.handlers[evt_type]
    tbl[#tbl + 1] = callback
end

function Events:unhook(evt_type, callback)
    assert(type(callback) == "function", "callback parameter must be a function!")
    if self.handlers[evt_type] == nil then return end
    local index = index_of(self.handlers[evt_type], callback)
    if index > -1 then
        table.remove(self.handlers[evt_type], index)
    end
end

--Clears out the event handlers for the givent envent type
function Events:clear(evt_type)
    if evt_type == nil then
        for k,v in pairs(self.handlers) do
            self.handlers[k] = {}
        end
        elseif self.handlers[evt_type] ~= nil then
            self.handlers[evt_type] = {}
    end
end

function Events:invoke(evt_type, ...)
    if self.handlers[evt_type] == nil then return end
    -- assert(self.handlers[evt_type] ~= nil, "Event of type " .. evt_type .. " does not exist!")
    local tbl = self.handlers[evt_type]
    for i = 1, #tbl do
        tbl[i](...)
    end
end

return Events