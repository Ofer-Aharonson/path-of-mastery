-- Path of Mastery Addon - Config Module
-- Handles configuration and settings with Ace3
-- Author: GitHub Copilot
-- Version: 1.0.0

local PathOfMastery = _G.PathOfMastery
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

-- Config Module
PathOfMastery.Config = {}

-- Options table
local options = {
    name = "Path of Mastery",
    handler = PathOfMastery,
    type = "group",
    args = {
        general = {
            type = "group",
            name = "General",
            order = 1,
            args = {
                enabled = {
                    type = "toggle",
                    name = "Enable Addon",
                    desc = "Enable or disable the Path of Mastery addon",
                    order = 1,
                    get = function() return PathOfMastery.db.profile.enabled end,
                    set = function(_, value)
                        PathOfMastery.db.profile.enabled = value
                        PathOfMastery:RefreshConfig()
                    end,
                },
                showTips = {
                    type = "toggle",
                    name = "Show Tips",
                    desc = "Show helpful tips to new players",
                    order = 2,
                    get = function() return PathOfMastery.db.profile.showTips end,
                    set = function(_, value)
                        PathOfMastery.db.profile.showTips = value
                        PathOfMastery:RefreshConfig()
                    end,
                },
                soundEnabled = {
                    type = "toggle",
                    name = "Sound Effects",
                    desc = "Play sound when showing tips",
                    order = 3,
                    get = function() return PathOfMastery.db.profile.soundEnabled end,
                    set = function(_, value)
                        PathOfMastery.db.profile.soundEnabled = value
                        PathOfMastery:RefreshConfig()
                    end,
                },
            },
        },
        minimap = {
            type = "group",
            name = "Minimap",
            order = 2,
            args = {
                showMinimap = {
                    type = "toggle",
                    name = "Show Minimap Button",
                    desc = "Show the minimap button for quick access",
                    order = 1,
                    get = function() return PathOfMastery.db.profile.showMinimap end,
                    set = function(_, value)
                        PathOfMastery.db.profile.showMinimap = value
                        PathOfMastery:RefreshConfig()
                    end,
                },
            },
        },
        tips = {
            type = "group",
            name = "Tips",
            order = 3,
            args = {
                tipDelay = {
                    type = "range",
                    name = "Tip Delay",
                    desc = "Delay between showing tips (seconds)",
                    order = 1,
                    min = 1,
                    max = 30,
                    step = 1,
                    get = function() return PathOfMastery.db.profile.tipDelay end,
                    set = function(_, value)
                        PathOfMastery.db.profile.tipDelay = value
                        PathOfMastery:RefreshConfig()
                    end,
                },
                maxTipsPerSession = {
                    type = "range",
                    name = "Max Tips Per Session",
                    desc = "Maximum number of tips to show per session",
                    order = 2,
                    min = 1,
                    max = 10,
                    step = 1,
                    get = function() return PathOfMastery.db.profile.maxTipsPerSession end,
                    set = function(_, value)
                        PathOfMastery.db.profile.maxTipsPerSession = value
                        PathOfMastery:RefreshConfig()
                    end,
                },
            },
        },
        experience = {
            type = "group",
            name = "Experience Level",
            order = 4,
            args = {
                currentLevel = {
                    type = "description",
                    name = function()
                        local level = PathOfMastery:GetExperienceLevel()
                        if level then
                            local levelNames = {
                                beginner = "Just Started (Beginner)",
                                intermediate = "Played a Bit (Intermediate)",
                                advanced = "Advanced Player"
                            }
                            return "Current Experience Level: |cff00ff00" .. (levelNames[level] or "Not Set") .. "|r"
                        else
                            return "Current Experience Level: |cffff0000Not Set|r"
                        end
                    end,
                    order = 1,
                },
                setBeginner = {
                    type = "execute",
                    name = "Set as Beginner",
                    desc = "Configure addon for new players - more frequent tips and basic guidance",
                    order = 2,
                    func = function()
                        PathOfMastery:SetExperienceLevel("beginner")
                        PathOfMastery:Print("Experience level set to Beginner!")
                    end,
                },
                setIntermediate = {
                    type = "execute",
                    name = "Set as Intermediate",
                    desc = "Configure addon for players with some experience - moderate tips and advanced guidance",
                    order = 3,
                    func = function()
                        PathOfMastery:SetExperienceLevel("intermediate")
                        PathOfMastery:Print("Experience level set to Intermediate!")
                    end,
                },
                setAdvanced = {
                    type = "execute",
                    name = "Set as Advanced",
                    desc = "Configure addon for experienced players - minimal guidance",
                    order = 4,
                    func = function()
                        PathOfMastery:SetExperienceLevel("advanced")
                        PathOfMastery:Print("Experience level set to Advanced!")
                    end,
                },
                resetStartupDialog = {
                    type = "execute",
                    name = "Reset Startup Dialog",
                    desc = "Show the experience level selection dialog again on next login",
                    order = 5,
                    func = function()
                        PathOfMastery:ResetStartupDialog()
                        PathOfMastery:Print("Startup dialog will show again on next login!")
                    end,
                },
            },
        },
        actions = {
            type = "group",
            name = "Actions",
            order = 5,
            args = {
                reset = {
                    type = "execute",
                    name = "Reset Settings",
                    desc = "Reset all settings to default values",
                    order = 1,
                    func = function()
                        PathOfMastery.db:ResetProfile()
                        PathOfMastery:Print("Settings reset to defaults!")
                        PathOfMastery:RefreshConfig()
                    end,
                },
                showMainFrame = {
                    type = "execute",
                    name = "Show Main Window",
                    desc = "Open the main Path of Mastery window",
                    order = 2,
                    func = function()
                        if PathOfMastery.UI then
                            PathOfMastery.UI:ShowMainFrame()
                        end
                    end,
                },
            },
        },
    },
}

-- Register options table
AceConfig:RegisterOptionsTable("PathOfMastery", options)

-- Add profile management options
local profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(PathOfMastery.db)
AceConfig:RegisterOptionsTable("PathOfMastery_Profiles", profiles)

-- Open options panel
function PathOfMastery.Config:OpenOptionsPanel()
    -- Create the options frame if it doesn't exist
    if not self.optionsFrame then
        self.optionsFrame = AceConfigDialog:AddToBlizOptions("PathOfMastery", "Path of Mastery")
        self.profilesFrame = AceConfigDialog:AddToBlizOptions("PathOfMastery_Profiles", "Profiles", "Path of Mastery")
    end

    -- Show the options frame
    if InterfaceOptionsFrame:IsShown() then
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    else
        InterfaceOptionsFrame:Show()
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    end
end

-- Initialize Blizzard Interface Options integration
function PathOfMastery.Config:InitializeBlizOptions()
    -- Try modern Settings API first (WoW 10.0+)
    if Settings and Settings.RegisterCanvasLayoutCategory then
        local category = Settings.RegisterCanvasLayoutCategory(self:CreateBlizOptionsFrame(), "Path of Mastery")
        category.ID = "PathOfMastery"
        Settings.RegisterAddOnCategory(category)
        self.blizCategory = category
    else
        -- Fallback to legacy Interface Options
        self:InitializeLegacyOptions()
    end
end

-- Create Blizzard options frame
function PathOfMastery.Config:CreateBlizOptionsFrame()
    local frame = AceConfigDialog:AddToBlizOptions("PathOfMastery", "Path of Mastery")
    return frame
end

-- Alternative method for older WoW versions
function PathOfMastery.Config:InitializeLegacyOptions()
    -- Create the options frame if it doesn't exist
    if not self.optionsFrame then
        self.optionsFrame = AceConfigDialog:AddToBlizOptions("PathOfMastery", "Path of Mastery")
    end

    -- Add to Blizzard's AddOns category
    if InterfaceOptions_AddCategory then
        InterfaceOptions_AddCategory(self.optionsFrame)
    end
end

-- Get setting value
function PathOfMastery.Config:GetSetting(key)
    return PathOfMastery.db.profile[key]
end

-- Set setting value
function PathOfMastery.Config:SetSetting(key, value)
    PathOfMastery.db.profile[key] = value
    PathOfMastery:RefreshConfig()
end

-- Toggle setting
function PathOfMastery.Config:ToggleSetting(key)
    local current = self:GetSetting(key)
    self:SetSetting(key, not current)
end

-- Reset settings to defaults
function PathOfMastery.Config:ResetSettings()
    PathOfMastery.db:ResetProfile()
    PathOfMastery:Print("Settings reset to defaults!")
end

-- Export for other modules
PathOfMastery.Config = PathOfMastery.Config
