-- Path of Mastery Addon - Core Module
-- Main addon logic and initialization with Ace3
-- Author: GitHub Copilot
-- Version: 1.0.0

local PathOfMastery = _G.PathOfMastery
local AceDB = LibStub("AceDB-3.0")
local AceEvent = LibStub("AceEvent-3.0")

-- Create database with experience level tracking
PathOfMastery.db = AceDB:New("PathOfMasteryDB", {
    profile = {
        enabled = true,
        showMinimap = true,
        soundEnabled = true,
        showTips = true,
        tipDelay = 5,
        maxTipsPerSession = 3,
        experienceLevel = nil, -- "beginner", "intermediate", "advanced"
        startupDialogShown = false,
    },
    global = {
        shownTips = {},
        tipHistory = {},
    }
}, true)

-- Embed AceEvent
AceEvent:Embed(PathOfMastery)

-- Initialization function
function PathOfMastery:OnInitialize()
    self:Print("Initializing Path of Mastery " .. self.version .. "...")

    -- Register events
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "OnPlayerEnteringWorld")
    self:RegisterEvent("PLAYER_LEVEL_UP", "OnPlayerLevelUp")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "OnZoneChanged")
    self:RegisterEvent("QUEST_ACCEPTED", "OnQuestAccepted")
    self:RegisterEvent("QUEST_TURNED_IN", "OnQuestTurnedIn")
    self:RegisterEvent("ADDON_LOADED", "OnAddonLoaded")

    -- Initialize UI components
    if PathOfMastery.UI then
        PathOfMastery.UI:Initialize()
    end

    -- Initialize Blizzard Interface Options (delay until UI is ready)
    if PathOfMastery.Config then
        -- Delay initialization to ensure UI is fully loaded
        C_Timer.After(1, function()
            PathOfMastery.Config:InitializeBlizOptions()
        end)
    end

    self:Print("Path of Mastery initialization complete!")
end

-- Enable function
function PathOfMastery:OnEnable()
    self:Print("Path of Mastery enabled!")

    -- Check if we need to show the startup dialog
    self:CheckStartupDialog()
end

-- Disable function
function PathOfMastery:OnDisable()
    self:Print("Path of Mastery disabled!")
end

-- Event handlers
function PathOfMastery:OnPlayerEnteringWorld(event, ...)
    if PathOfMastery.Data then
        PathOfMastery.Data:HandlePlayerEnteringWorld(...)
    end
end

function PathOfMastery:OnPlayerLevelUp(event, newLevel)
    if PathOfMastery.Data then
        PathOfMastery.Data:HandlePlayerLevelUp(newLevel)
    end
end

function PathOfMastery:OnZoneChanged(event, ...)
    if PathOfMastery.Data then
        PathOfMastery.Data:HandleZoneChanged(...)
    end
end

function PathOfMastery:OnQuestAccepted(event, questID)
    if PathOfMastery.Data then
        PathOfMastery.Data:HandleQuestAccepted(questID)
    end
end

function PathOfMastery:OnQuestTurnedIn(event, questID)
    if PathOfMastery.Data then
        PathOfMastery.Data:HandleQuestTurnedIn(questID)
    end
end

function PathOfMastery:OnAddonLoaded(event, addonName)
    if addonName == "PathOfMastery" then
        self:OnInitialize()
    end
end

-- Check if we need to show the startup dialog
function PathOfMastery:CheckStartupDialog()
    -- Only show dialog if it hasn't been shown before and we don't have an experience level set
    if not self.db.profile.startupDialogShown and not self.db.profile.experienceLevel then
        -- Delay the dialog slightly to ensure UI is ready
        C_Timer.After(2, function()
            if PathOfMastery.UI then
                PathOfMastery.UI:ShowStartupDialog()
            end
        end)
    end
end

-- Set the player's experience level
function PathOfMastery:SetExperienceLevel(level)
    if level ~= "beginner" and level ~= "intermediate" and level ~= "advanced" then
        self:Print("Invalid experience level: " .. tostring(level))
        return
    end

    self.db.profile.experienceLevel = level
    self.db.profile.startupDialogShown = true
    self:Print("Experience level set to: " .. level)

    -- Adjust addon behavior based on experience level
    self:AdjustBehaviorForExperienceLevel(level)
end

-- Get the player's experience level
function PathOfMastery:GetExperienceLevel()
    return self.db.profile.experienceLevel
end

-- Adjust addon behavior based on experience level
function PathOfMastery:AdjustBehaviorForExperienceLevel(level)
    if level == "beginner" then
        -- Beginner: More frequent tips, simpler content
        self.db.profile.tipDelay = 3
        self.db.profile.maxTipsPerSession = 5
        self.db.profile.showTips = true
    elseif level == "intermediate" then
        -- Intermediate: Moderate tips, some advanced content
        self.db.profile.tipDelay = 5
        self.db.profile.maxTipsPerSession = 3
        self.db.profile.showTips = true
    elseif level == "advanced" then
        -- Advanced: Minimal tips, focus on advanced content only
        self.db.profile.tipDelay = 10
        self.db.profile.maxTipsPerSession = 1
        self.db.profile.showTips = false
    end

    -- Refresh configuration
    self:RefreshConfig()
end

-- Reset startup dialog (for testing or user preference)
function PathOfMastery:ResetStartupDialog()
    self.db.profile.startupDialogShown = false
    self.db.profile.experienceLevel = nil
    self:Print("Startup dialog reset. It will show again on next login.")
end

-- Refresh configuration
function PathOfMastery:RefreshConfig()
    self:Print("Configuration refreshed!")
    -- Refresh UI if it exists
    if PathOfMastery.UI then
        PathOfMastery.UI:Refresh()
    end
end

-- Slash command handler
function PathOfMastery:HandleSlashCommand(msg)
    if not msg then msg = "" end
    msg = msg:lower():trim()

    if msg == "show" then
        if PathOfMastery.UI then
            PathOfMastery.UI:ShowMainFrame()
        end
    elseif msg == "hide" then
        if PathOfMastery.UI then
            PathOfMastery.UI:HideMainFrame()
        end
    elseif msg == "reset" then
        self:ResetDatabase()
    elseif msg == "config" then
        if PathOfMastery.Config then
            PathOfMastery.Config:OpenOptionsPanel()
        end
    elseif msg == "startup" then
        if PathOfMastery.UI then
            PathOfMastery.UI:ShowStartupDialog()
        end
    elseif msg == "resetdialog" then
        self:ResetStartupDialog()
    elseif msg == "debug" then
        self:Print("=== Path of Mastery Debug Info ===")
        self:Print("Version: " .. (self.version or "Unknown"))
        self:Print("Enabled: " .. (self.db and self.db.profile.enabled and "Yes" or "No"))
        self:Print("Experience Level: " .. (self:GetExperienceLevel() or "Not set"))
        if PathOfMastery.Config then
            self:Print("Config Module: Loaded")
            self:Print("Bliz Options Category: " .. (PathOfMastery.Config.blizCategory and "Registered" or "Not registered"))
        else
            self:Print("Config Module: Not loaded")
        end
        if PathOfMastery.UI then
            self:Print("UI Module: Loaded")
        else
            self:Print("UI Module: Not loaded")
        end
    else
        self:Print("Path of Mastery Commands:")
        self:Print("  /pom show - Open main guide window")
        self:Print("  /pom hide - Hide main guide window")
        self:Print("  /pom config - Open settings (or use ESC -> Interface -> AddOns)")
        self:Print("  /pom startup - Show experience level dialog")
        self:Print("  /pom resetdialog - Reset startup dialog")
        self:Print("  /pom debug - Show debug information")
        self:Print("  /pom reset - Reset all settings to defaults")
    end
end

-- Reset database
function PathOfMastery:ResetDatabase()
    PathOfMasteryDB = nil
    self:Print("Database reset! Reloading UI...")
    ReloadUI()
end

-- Print function
function PathOfMastery:Print(message)
    if not message then return end
    local status, err = pcall(function()
        DEFAULT_CHAT_FRAME:AddMessage(string.format("|cff00ff00[Path of Mastery]|r %s", message), 1.0, 0.85, 0.0)
    end)
    if not status then
        print("[Path of Mastery] Error in Print:", err)
    end
end

-- Export for other modules
PathOfMastery.Core = PathOfMastery
