--- AceEvent-3.0 provides event handling functionality
-- Simplified version for Path of Mastery

local MAJOR, MINOR = "AceEvent-3.0", 4
local AceEvent, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not AceEvent then return end -- No upgrade needed

local type, pairs, ipairs, select, tconcat = type, pairs, ipairs, select, table.concat
local format, strfind, strsub, strmatch, strlower = string.format, string.find, string.sub, string.match, string.lower

-- Mixins
local mixins = {
    "RegisterEvent", "UnregisterEvent", "UnregisterAllEvents",
    "RegisterMessage", "UnregisterMessage", "UnregisterAllMessages",
    "SendMessage", "IsEventRegistered"
}

-- Embed function
function AceEvent:Embed(target)
    for k, v in pairs(mixins) do
        target[v] = self[v]
    end
    self.embeds[target] = true
    return target
end

-- RegisterEvent function
function AceEvent:RegisterEvent(event, method, ...)
    if type(event) ~= "string" then error("Usage: RegisterEvent(event, method, ...): 'event' - string expected.", 2) end

    self.events = self.events or {}
    self.events[event] = method or event

    -- Create frame if it doesn't exist
    self.frame = self.frame or CreateFrame("Frame")
    self.frame:RegisterEvent(event)

    -- Set up script handler if not already done
    if not self.frame:GetScript("OnEvent") then
        self.frame:SetScript("OnEvent", function(frame, event, ...)
            self:OnEvent(event, ...)
        end)
    end
end

-- UnregisterEvent function
function AceEvent:UnregisterEvent(event)
    if type(event) ~= "string" then error("Usage: UnregisterEvent(event): 'event' - string expected.", 2) end

    if self.events then
        self.events[event] = nil
    end

    if self.frame then
        self.frame:UnregisterEvent(event)
    end
end

-- UnregisterAllEvents function
function AceEvent:UnregisterAllEvents()
    if self.events then
        for event in pairs(self.events) do
            if self.frame then
                self.frame:UnregisterEvent(event)
            end
        end
        self.events = nil
    end
end

-- IsEventRegistered function
function AceEvent:IsEventRegistered(event)
    return self.events and self.events[event] ~= nil
end

-- OnEvent function (internal)
function AceEvent:OnEvent(event, ...)
    local method = self.events and self.events[event]
    if method then
        if type(method) == "function" then
            method(self, event, ...)
        elseif type(method) == "string" and self[method] then
            self[method](self, event, ...)
        end
    end
end

-- Message system (simplified)
function AceEvent:RegisterMessage(message, method)
    self.messages = self.messages or {}
    self.messages[message] = method or message
end

function AceEvent:UnregisterMessage(message)
    if self.messages then
        self.messages[message] = nil
    end
end

function AceEvent:UnregisterAllMessages()
    self.messages = nil
end

function AceEvent:SendMessage(message, ...)
    -- Simplified - just call local handlers
    if self.messages and self.messages[message] then
        local method = self.messages[message]
        if type(method) == "function" then
            method(self, message, ...)
        elseif type(method) == "string" and self[method] then
            self[method](self, message, ...)
        end
    end
end

-- Export
AceEvent.embeds = AceEvent.embeds or setmetatable({}, {__mode="k"})

-- Register with LibStub
LibStub.libs[MAJOR] = AceEvent
