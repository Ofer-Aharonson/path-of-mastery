--- AceAddon-3.0 provides a template for creating addon objects
-- Simplified version for Path of Mastery

local MAJOR, MINOR = "AceAddon-3.0", 13
local AceAddon, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not AceAddon then return end -- No upgrade needed

local type, pairs, ipairs, select, tconcat = type, pairs, ipairs, select, table.concat
local format, strfind, strsub, strmatch, strlower = string.format, string.find, string.sub, string.match, string.lower

-- Internal registries
AceAddon.addons = AceAddon.addons or {}
AceAddon.addonsToBeDisabled = AceAddon.addonsToBeDisabled or {}
AceAddon.registry = AceAddon.registry or {}

-- Mixins
local mixins = {
    "OnInitialize", "OnEnable", "OnDisable",
    "GetName", "GetDB", "SetDB", "GetDefaultState", "SetDefaultState",
    "Enable", "Disable", "IsEnabled", "SetEnabledState",
    "RegisterMessage", "UnregisterMessage", "UnregisterAllMessages",
    "SendMessage", "NewModule", "GetModule", "HasModule", "IterateModules"
}

-- Embed function
function AceAddon:Embed(target)
    for k, v in pairs(mixins) do
        target[v] = self[v]
    end
    self.embeds[target] = true
    return target
end

-- NewAddon function
function AceAddon:NewAddon(name, ...)
    if type(name) ~= "string" then error("Usage: NewAddon(name, [lib, lib, lib, ...]): 'name' - string expected.", 2) end
    if self.registry[name] then error("Usage: NewAddon(name, [lib, lib, lib, ...]): 'name' already registered.", 2) end

    local addon = {}
    self.registry[name] = addon
    addon.name = name
    addon.baseName = name

    -- Embed AceAddon
    self:Embed(addon)

    -- Embed additional libraries
    for i = 1, select("#", ...) do
        local lib = select(i, ...)
        lib:Embed(addon)
    end

    -- Initialize addon
    addon.modules = {}
    addon.defaultModuleState = true
    addon.enabledState = true
    addon.dependants = {}

    self.addons[name] = addon

    return addon
end

-- GetAddon function
function AceAddon:GetAddon(name)
    if type(name) ~= "string" then error("Usage: GetAddon(name): 'name' - string expected.", 2) end
    return self.registry[name]
end

-- OnInitialize (stub)
function AceAddon:OnInitialize()
    -- Override in your addon
end

-- OnEnable (stub)
function AceAddon:OnEnable()
    -- Override in your addon
end

-- OnDisable (stub)
function AceAddon:OnDisable()
    -- Override in your addon
end

-- Enable function
function AceAddon:Enable()
    if self.enabledState then return end
    self.enabledState = true
    if self.OnEnable then
        self:OnEnable()
    end
end

-- Disable function
function AceAddon:Disable()
    if not self.enabledState then return end
    self.enabledState = false
    if self.OnDisable then
        self:OnDisable()
    end
end

-- IsEnabled function
function AceAddon:IsEnabled()
    return self.enabledState
end

-- SetEnabledState function
function AceAddon:SetEnabledState(state)
    if state then
        self:Enable()
    else
        self:Disable()
    end
end

-- GetName function
function AceAddon:GetName()
    return self.name
end

-- NewModule function
function AceAddon:NewModule(name, ...)
    if type(name) ~= "string" then error("Usage: NewModule(name, [prototype, [lib, lib, lib, ...]]): 'name' - string expected.", 2) end
    if self.modules[name] then error(format("Usage: NewModule(name, [prototype, [lib, lib, lib, ...]]): 'name' - module '%s' already exists.", name), 2) end

    local module = {}
    self.modules[name] = module
    module.name = name
    module.baseName = self.name

    -- Embed additional libraries
    for i = 1, select("#", ...) do
        local lib = select(i, ...)
        lib:Embed(module)
    end

    module.defaultModuleState = true
    module.enabledState = true

    return module
end

-- GetModule function
function AceAddon:GetModule(name)
    if type(name) ~= "string" then error("Usage: GetModule(name): 'name' - string expected.", 2) end
    return self.modules[name]
end

-- HasModule function
function AceAddon:HasModule(name)
    return self.modules[name] ~= nil
end

-- IterateModules function
function AceAddon:IterateModules()
    return pairs(self.modules)
end

-- Message system (simplified)
function AceAddon:RegisterMessage(message, method)
    self.messages = self.messages or {}
    self.messages[message] = method or message
end

function AceAddon:UnregisterMessage(message)
    if self.messages then
        self.messages[message] = nil
    end
end

function AceAddon:UnregisterAllMessages()
    self.messages = nil
end

function AceAddon:SendMessage(message, ...)
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
AceAddon.embeds = AceAddon.embeds or setmetatable({}, {__mode="k"})

-- Register with LibStub
LibStub.libs[MAJOR] = AceAddon
