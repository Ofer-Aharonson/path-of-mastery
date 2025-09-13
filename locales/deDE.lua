-- Path of Mastery - German Localization
-- Author: GitHub Copilot

local L = LibStub("AceLocale-3.0"):NewLocale("PathOfMastery", "deDE")

if L then
    -- General
    L["INITIALIZING"] = "Initialisiere Path of Mastery %s..."
    L["INITIALIZATION_COMPLETE"] = "Path of Mastery Initialisierung abgeschlossen!"
    L["ADDON_ENABLED"] = "Path of Mastery aktiviert!"
    L["ADDON_DISABLED"] = "Path of Mastery deaktiviert!"
    L["CONFIG_REFRESHED"] = "Konfiguration aktualisiert!"
    L["DATABASE_RESET"] = "Datenbank zurückgesetzt!"

    -- Slash Commands
    L["SLASH_COMMANDS"] = "Befehle: /pom show | hide | reset | config"

    -- UI Elements
    L["MAIN_WINDOW_TITLE"] = "Path of Mastery - Erweiterte Anleitung"
    L["TIP_TITLE"] = "Path of Mastery Tipp"
    L["MINIMAP_TOOLTIP"] = "Path of Mastery|nLinks-Klick um Anleitung zu öffnen|nRechts-Klick für Optionen"

    -- Categories
    L["CATEGORY_GETTING_STARTED"] = "Erste Schritte"
    L["CATEGORY_COMBAT_TIPS"] = "Kampf-Tipps"
    L["CATEGORY_QUESTING_GUIDE"] = "Quest-Anleitung"
    L["CATEGORY_CLASS_SPECIFIC"] = "Klassenspezifisch"
    L["CATEGORY_SETTINGS"] = "Einstellungen"

    -- Content
    L["WELCOME_MESSAGE"] = "Willkommen bei Path of Mastery! Ihre erweiterte Anleitung ist bereit."
    L["GETTING_STARTED_CONTENT"] = "Willkommen in Azeroth!\n\n• Akzeptiere immer Quests von NPCs\n• Verwende deine Minimap zur Navigation\n• Drücke 'M' um deine Karte zu öffnen\n• Tritt einer Gilde bei für extra Hilfe\n• Vergiss nicht deine Ausrüstung zu reparieren!"
end
