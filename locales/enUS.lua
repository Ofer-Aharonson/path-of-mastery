-- Path of Mastery - English Localization
-- Author: GitHub Copilot

local L = LibStub("AceLocale-3.0"):NewLocale("PathOfMastery", "enUS", true)

if L then
    -- General
    L["INITIALIZING"] = "Initializing Path of Mastery %s..."
    L["INITIALIZATION_COMPLETE"] = "Path of Mastery initialization complete!"
    L["ADDON_ENABLED"] = "Path of Mastery enabled!"
    L["ADDON_DISABLED"] = "Path of Mastery disabled!"
    L["CONFIG_REFRESHED"] = "Configuration refreshed!"
    L["DATABASE_RESET"] = "Database reset!"

    -- Slash Commands
    L["SLASH_COMMANDS"] = "Commands: /pom show | hide | reset | config"

    -- UI Elements
    L["MAIN_WINDOW_TITLE"] = "Path of Mastery - Advanced Guide"
    L["TIP_TITLE"] = "Path of Mastery Tip"
    L["MINIMAP_TOOLTIP"] = "Path of Mastery|nLeft-click to open guide|nRight-click for options"

    -- Categories
    L["CATEGORY_GETTING_STARTED"] = "Getting Started"
    L["CATEGORY_COMBAT_TIPS"] = "Combat Tips"
    L["CATEGORY_QUESTING_GUIDE"] = "Questing Guide"
    L["CATEGORY_CLASS_SPECIFIC"] = "Class Specific"
    L["CATEGORY_SETTINGS"] = "Settings"

    -- Content
    L["WELCOME_MESSAGE"] = "Welcome to Path of Mastery! Your advanced guide is ready."
    L["GETTING_STARTED_CONTENT"] = "Welcome to Azeroth!\n\n• Always accept quests from NPCs\n• Use your minimap to navigate\n• Press 'M' to open your map\n• Join a guild for extra help\n• Don't forget to repair your gear!"
    L["COMBAT_TIPS_CONTENT"] = "Combat Fundamentals:\n\n• Use abilities on cooldown\n• Position yourself behind enemies\n• Use health potions when low\n• Learn your class abilities\n• Always be aware of your surroundings"
    L["QUESTING_GUIDE_CONTENT"] = "Questing Strategies:\n\n• Group similar quests together\n• Use quest items immediately\n• Complete bonus objectives\n• Look for hidden quests\n• Turn in multiple quests at once"
    L["CLASS_SPECIFIC_CONTENT"] = "Class Tips:\n\n• Warriors: Use defensive cooldowns\n• Mages: Conserve mana carefully\n• Hunters: Keep pets buffed\n• Priests: Heal yourself in combat\n• Rogues: Position for backstabs"
    L["SETTINGS_CONTENT"] = "Addon Settings:\n\n• Enable/Disable tips\n• Toggle minimap button\n• Sound notifications\n• Reset all data\n\nUse /pom reset to reset settings"

    -- Tips
    L["LEVEL_5_TIP"] = "Great progress! At level 5:\n• Consider your first talent point\n• Start focusing on your main stat\n• Repair your gear regularly\n• Think about joining a guild"
    L["LEVEL_10_TIP"] = "You're doing great! At level 10:\n• You can create or join a guild\n• Consider your class specialization\n• Start saving for mounts\n• Learn about your profession options"
    L["LEVEL_20_TIP"] = "Level 20! You're getting experienced:\n• Focus on gear upgrades\n• Learn advanced class mechanics\n• Consider grouping for tougher content\n• Start thinking about dungeons"

    -- Zone Tips
    L["STORMWIND_TIP"] = "Capital city tips:\n• Visit the Auction House (bottom left)\n• Check the Class Trainer for new abilities\n• Use the Bank for storage\n• Explore the Trade District"
    L["ORGRIMMAR_TIP"] = "Capital city tips:\n• Visit the Auction House in the Valley of Strength\n• Check the Class Trainer for new abilities\n• Use the Bank for storage\n• Explore the different districts"
    L["ELWYNN_TIP"] = "Starter zone tips:\n• Look for exclamation marks on minimap\n• Complete all quests for bonus XP\n• Explore side paths for hidden quests\n• Visit Goldshire for more quests"
    L["DUROTAR_TIP"] = "Starter zone tips:\n• Look for exclamation marks on minimap\n• Complete all quests for bonus XP\n• Explore side paths for hidden quests\n• Visit Razor Hill for more quests"

    -- General Tips
    L["WELCOME_TIP"] = "Your advanced guide is ready:\n• Use /pom show to open the main window\n• Tips will appear automatically\n• Check the minimap for quick access\n• Customize settings as needed"
    L["COMBAT_TIP"] = "Essential combat tips:\n• Use abilities on cooldown\n• Position behind enemies when possible\n• Use health potions when low\n• Learn your class rotation\n• Stay aware of surroundings"
    L["QUESTING_TIP"] = "Advanced questing:\n• Group similar quests together\n• Use quest items immediately\n• Complete bonus objectives\n• Look for hidden quests\n• Turn in multiple quests at once"
end
