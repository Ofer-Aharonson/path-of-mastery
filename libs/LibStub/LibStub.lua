-- LibStub - A simple versioning stub meant for use in Libraries
-- Simplified version for Path of Mastery

local LIBSTUB_MAJOR, LIBSTUB_MINOR = "LibStub", 2
local LibStub = _G.LibStub or {}

-- LibStub.libs = LibStub.libs or {}
-- LibStub.minors = LibStub.minors or {}

-- NewLibrary function
function LibStub:NewLibrary(major, minor)
    if type(major) ~= "string" then
        error("Usage: LibStub:NewLibrary(major, minor): 'major' - string expected.", 2)
    end
    if type(minor) ~= "number" then
        error("Usage: LibStub:NewLibrary(major, minor): 'minor' - number expected.", 2)
    end

    local oldminor = self.minors and self.minors[major]
    if oldminor and oldminor >= minor then
        return nil -- No upgrade needed
    end

    self.minors = self.minors or {}
    self.minors[major] = minor
    self.libs = self.libs or {}
    self.libs[major] = self.libs[major] or {}

    return self.libs[major], oldminor
end

-- GetLibrary function
function LibStub:GetLibrary(major, silent)
    if type(major) ~= "string" then
        error("Usage: LibStub:GetLibrary(major, silent): 'major' - string expected.", 2)
    end

    if not self.libs or not self.libs[major] then
        if not silent then
            error(("Usage: LibStub:GetLibrary(major, silent): Library '%s' not found."):format(major), 2)
        end
        return nil
    end

    return self.libs[major], self.minors[major]
end

-- IterateLibraries function
function LibStub:IterateLibraries()
    return pairs(self.libs or {})
end

-- Make global
_G.LibStub = LibStub

return LibStub
