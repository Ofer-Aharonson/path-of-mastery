-- Path of Mastery Addon - Main Entry Point
-- Bootstrap and module loading with Ace3
-- Author: GitHub Copilot
-- Version: 1.0.0

local AceAddon = LibStub("AceAddon-3.0")
local PathOfMastery = AceAddon:NewAddon("PathOfMastery", "AceConsole-3.0", "AceEvent-3.0")

-- Addon constants
PathOfMastery.name = "Path of Mastery"
PathOfMastery.version = "1.0.0"

-- Module loading function
function PathOfMastery:LoadModules()
    -- Load Core module
    if not PathOfMastery.Core then
        self:Print("Error: Core module not loaded!")
        return false
    end

    -- Load Data module
    if not PathOfMastery.Data then
        self:Print("Error: Data module not loaded!")
        return false
    end

    -- Load UI module
    if not PathOfMastery.UI then
        self:Print("Error: UI module not loaded!")
        return false
    end

    -- Load Config module
    if not PathOfMastery.Config then
        self:Print("Error: Config module not loaded!")
        return false
    end

    return true
end

-- Initialization
function PathOfMastery:OnInitialize()
    self:Print("Loading Path of Mastery " .. self.version .. "...")

    -- Load all modules
    if not self:LoadModules() then
        self:Print("Failed to load modules!")
        return
    end

    -- Initialize Core
    if PathOfMastery.Core.OnInitialize then
        PathOfMastery.Core:OnInitialize()
    end

    self:Print("Path of Mastery loaded successfully!")
end

-- Enable function
function PathOfMastery:OnEnable()
    self:Print("Path of Mastery enabled!")

    -- Register slash commands
    self:RegisterChatCommand("pom", "HandleSlashCommand")
    self:RegisterChatCommand("pathofmastery", "HandleSlashCommand")
    self:Print("Slash commands registered: /pom and /pathofmastery")
end

-- Slash command handler
function PathOfMastery:HandleSlashCommand(msg)
    self:Print("Slash command received: " .. tostring(msg))

    -- Ensure Core module is loaded
    if not PathOfMastery.Core then
        self:Print("Error: Core module not available")
        return
    end

    -- Delegate to Core module's slash command handler
    if PathOfMastery.Core.HandleSlashCommand then
        self:Print("Delegating to Core module...")
        PathOfMastery.Core:HandleSlashCommand(msg)
    else
        self:Print("Error: Core slash command handler not available")
        self:Print("Available functions in Core:")
        for k, v in pairs(PathOfMastery.Core) do
            if type(v) == "function" then
                self:Print("  " .. k)
            end
        end
    end
end

-- Make addon globally available
_G.PathOfMastery = PathOfMastery

-- Debug: Confirm main addon file loaded
print("[Path of Mastery] Main addon file loaded successfully")
