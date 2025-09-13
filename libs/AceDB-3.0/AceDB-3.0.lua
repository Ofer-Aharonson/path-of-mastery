--- AceDB-3.0 provides database functionality for addons
-- Simplified version for Path of Mastery

local MAJOR, MINOR = "AceDB-3.0", 27
local AceDB, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not AceDB then return end -- No upgrade needed

local type, pairs, ipairs, select, tconcat = type, pairs, ipairs, select, table.concat
local format, strfind, strsub, strmatch, strlower = string.format, string.find, string.sub, string.match, string.lower
local setmetatable, getmetatable, rawset, rawget = setmetatable, getmetatable, rawset, rawget

-- Mixins
local mixins = {
    "GetProfile", "SetProfile", "CopyProfile", "DeleteProfile", "ResetProfile",
    "GetProfiles", "GetCurrentProfile", "SetDefaultProfile", "GetDefaultProfile",
    "RegisterDefaults", "RegisterCallback", "UnregisterCallback", "UnregisterAllCallbacks"
}

-- Embed function
function AceDB:Embed(target)
    for k, v in pairs(mixins) do
        target[v] = self[v]
    end
    self.embeds[target] = true
    return target
end

-- New function
function AceDB:New(tbl, defaults, defaultProfile)
    if type(tbl) ~= "table" then error("Usage: New(tbl, defaults, defaultProfile): 'tbl' - table expected.", 2) end

    local db = setmetatable({}, {__index = self})
    db.db = tbl
    db.defaults = defaults
    db.defaultProfile = defaultProfile or "Default"

    -- Initialize profile if it doesn't exist
    if not db.db.profiles then
        db.db.profiles = {}
    end
    if not db.db.profiles[db.defaultProfile] then
        db.db.profiles[db.defaultProfile] = {}
    end

    -- Set current profile
    db.currentProfile = db.defaultProfile
    db.profile = db.db.profiles[db.currentProfile]

    -- Apply defaults
    if defaults then
        db:RegisterDefaults(defaults)
    end

    return db
end

-- GetProfile function
function AceDB:GetProfile(name)
    if type(name) ~= "string" then error("Usage: GetProfile(name): 'name' - string expected.", 2) end
    return self.db.profiles[name]
end

-- SetProfile function
function AceDB:SetProfile(name)
    if type(name) ~= "string" then error("Usage: SetProfile(name): 'name' - string expected.", 2) end

    -- Create profile if it doesn't exist
    if not self.db.profiles[name] then
        self.db.profiles[name] = {}
    end

    self.currentProfile = name
    self.profile = self.db.profiles[name]

    -- Apply defaults
    if self.defaults then
        self:CopyDefaults(self.profile, self.defaults)
    end

    -- Fire callback
    if self.callbacks then
        self.callbacks:Fire("OnProfileChanged", self, name)
    end
end

-- CopyProfile function
function AceDB:CopyProfile(name, copyFrom)
    if type(name) ~= "string" then error("Usage: CopyProfile(name, copyFrom): 'name' - string expected.", 2) end
    if type(copyFrom) ~= "string" then error("Usage: CopyProfile(name, copyFrom): 'copyFrom' - string expected.", 2) end

    local source = self.db.profiles[copyFrom]
    if not source then error(format("Usage: CopyProfile(name, copyFrom): profile '%s' does not exist.", copyFrom), 2) end

    self.db.profiles[name] = self:CopyTable(source)
    if self.currentProfile == name then
        self.profile = self.db.profiles[name]
    end
end

-- DeleteProfile function
function AceDB:DeleteProfile(name)
    if type(name) ~= "string" then error("Usage: DeleteProfile(name): 'name' - string expected.", 2) end
    if name == self.defaultProfile then error("Usage: DeleteProfile(name): cannot delete default profile.", 2) end

    self.db.profiles[name] = nil

    -- Switch to default if current profile was deleted
    if self.currentProfile == name then
        self:SetProfile(self.defaultProfile)
    end
end

-- ResetProfile function
function AceDB:ResetProfile()
    local profile = self.db.profiles[self.currentProfile]
    if profile then
        for k in pairs(profile) do
            profile[k] = nil
        end
    end

    -- Apply defaults
    if self.defaults then
        self:CopyDefaults(self.profile, self.defaults)
    end

    -- Fire callback
    if self.callbacks then
        self.callbacks:Fire("OnProfileReset", self)
    end
end

-- GetProfiles function
function AceDB:GetProfiles()
    local profiles = {}
    for name in pairs(self.db.profiles) do
        profiles[#profiles + 1] = name
    end
    return profiles
end

-- GetCurrentProfile function
function AceDB:GetCurrentProfile()
    return self.currentProfile
end

-- SetDefaultProfile function
function AceDB:SetDefaultProfile(name)
    if type(name) ~= "string" then error("Usage: SetDefaultProfile(name): 'name' - string expected.", 2) end
    self.defaultProfile = name
end

-- GetDefaultProfile function
function AceDB:GetDefaultProfile()
    return self.defaultProfile
end

-- RegisterDefaults function
function AceDB:RegisterDefaults(defaults)
    if type(defaults) ~= "table" then error("Usage: RegisterDefaults(defaults): 'defaults' - table expected.", 2) end
    self.defaults = defaults
    self:CopyDefaults(self.profile, defaults)
end

-- CopyDefaults function (internal)
function AceDB:CopyDefaults(target, defaults)
    for k, v in pairs(defaults) do
        if type(v) == "table" then
            if not target[k] then
                target[k] = {}
            end
            self:CopyDefaults(target[k], v)
        elseif target[k] == nil then
            target[k] = v
        end
    end
end

-- CopyTable function (internal)
function AceDB:CopyTable(tbl)
    if type(tbl) ~= "table" then return tbl end
    local copy = {}
    for k, v in pairs(tbl) do
        copy[k] = self:CopyTable(v)
    end
    return copy
end

-- Callback system (simplified)
function AceDB:RegisterCallback(event, method)
    self.callbacks = self.callbacks or {}
    self.callbacks[event] = self.callbacks[event] or {}
    self.callbacks[event][method] = true
end

function AceDB:UnregisterCallback(event, method)
    if self.callbacks and self.callbacks[event] then
        self.callbacks[event][method] = nil
    end
end

function AceDB:UnregisterAllCallbacks()
    self.callbacks = nil
end

-- Export
AceDB.embeds = AceDB.embeds or setmetatable({}, {__mode="k"})

-- Register with LibStub
LibStub.libs[MAJOR] = AceDB
