--- AceLocale-3.0 provides localization functionality
-- Simplified version for Path of Mastery

local MAJOR, MINOR = "AceLocale-3.0", 14
local AceLocale, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not AceLocale then return end -- No upgrade needed

local type, pairs, ipairs, select, tconcat = type, pairs, ipairs, select, table.concat
local format, strfind, strsub, strmatch, strlower = string.format, string.find, string.sub, string.match, string.lower

-- Registry for locales
AceLocale.apps = AceLocale.apps or {}

-- NewLocale function
function AceLocale:NewLocale(application, locale, isDefault)
    if type(application) ~= "string" then error("Usage: NewLocale(application, locale, isDefault): 'application' - string expected.", 2) end
    if type(locale) ~= "string" then error("Usage: NewLocale(application, locale, isDefault): 'locale' - string expected.", 2) end

    if not self.apps[application] then
        self.apps[application] = {}
    end

    if self.apps[application][locale] then
        return nil -- Locale already exists
    end

    local L = setmetatable({}, {
        __index = function(t, k)
            t[k] = k -- Return key if translation not found
            return k
        end,
        __newindex = function(t, k, v)
            rawset(t, k, v)
        end
    })

    self.apps[application][locale] = L

    if isDefault then
        self.apps[application].default = L
    end

    return L
end

-- GetLocale function
function AceLocale:GetLocale(application, silent)
    if type(application) ~= "string" then error("Usage: GetLocale(application, silent): 'application' - string expected.", 2) end

    if not self.apps[application] then
        if not silent then
            error(format("Usage: GetLocale(application, silent): application '%s' not found.", application), 2)
        end
        return nil
    end

    -- Try current locale first
    local locale = GetLocale and GetLocale() or "enUS"
    local L = self.apps[application][locale]

    -- Fall back to default if available
    if not L and self.apps[application].default then
        L = self.apps[application].default
    end

    -- Fall back to any available locale
    if not L then
        for _, loc in pairs(self.apps[application]) do
            if type(loc) == "table" then
                L = loc
                break
            end
        end
    end

    return L
end

-- RegisterCallback function (stub)
function AceLocale:RegisterCallback(event, method)
    -- Simplified - no callback system implemented
end

-- Register with LibStub
LibStub.libs[MAJOR] = AceLocale
