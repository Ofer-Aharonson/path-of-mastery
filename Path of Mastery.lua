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
end

-- Slash command handler
function PathOfMastery:HandleSlashCommand(msg)
    if PathOfMastery.Core and PathOfMastery.Core.HandleSlashCommand then
        PathOfMastery.Core:HandleSlashCommand(msg)
    else
        self:Print("Core module not available for slash commands")
    end
end

-- Make addon globally available
_G.PathOfMastery = PathOfMastery
