-- Path of Mastery - French Localization
-- Author: GitHub Copilot

local L = LibStub("AceLocale-3.0"):NewLocale("PathOfMastery", "frFR")

if L then
    -- General
    L["INITIALIZING"] = "Initialisation de Path of Mastery %s..."
    L["INITIALIZATION_COMPLETE"] = "Initialisation de Path of Mastery terminée!"
    L["ADDON_ENABLED"] = "Path of Mastery activé!"
    L["ADDON_DISABLED"] = "Path of Mastery désactivé!"
    L["CONFIG_REFRESHED"] = "Configuration actualisée!"
    L["DATABASE_RESET"] = "Base de données réinitialisée!"

    -- Slash Commands
    L["SLASH_COMMANDS"] = "Commandes: /pom show | hide | reset | config"

    -- UI Elements
    L["MAIN_WINDOW_TITLE"] = "Path of Mastery - Guide Avancé"
    L["TIP_TITLE"] = "Conseil Path of Mastery"
    L["MINIMAP_TOOLTIP"] = "Path of Mastery|nClic gauche pour ouvrir le guide|nClic droit pour les options"

    -- Categories
    L["CATEGORY_GETTING_STARTED"] = "Premiers Pas"
    L["CATEGORY_COMBAT_TIPS"] = "Conseils de Combat"
    L["CATEGORY_QUESTING_GUIDE"] = "Guide de Quêtes"
    L["CATEGORY_CLASS_SPECIFIC"] = "Spécifique à la Classe"
    L["CATEGORY_SETTINGS"] = "Paramètres"

    -- Content
    L["WELCOME_MESSAGE"] = "Bienvenue sur Path of Mastery! Votre guide avancé est prêt."
    L["GETTING_STARTED_CONTENT"] = "Bienvenue en Azeroth!\n\n• Acceptez toujours les quêtes des PNJ\n• Utilisez votre minicarte pour naviguer\n• Appuyez sur 'M' pour ouvrir votre carte\n• Rejoignez une guilde pour plus d'aide\n• N'oubliez pas de réparer votre équipement!"
end
