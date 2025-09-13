-- Path of Mastery Addon - Data Module
-- Handles tip data, logic, and event processing
-- Author: GitHub Copilot
-- Version: 1.0.0

local PathOfMastery = _G.PathOfMastery

-- Tip data structure
PathOfMastery.tips = {
    -- Level-based tips
    level = {
        [5] = {
            id = "level_5",
            title = "Level 5 Milestone!",
            content = "Great progress! At level 5:\n• Consider your first talent point\n• Start focusing on your main stat\n• Repair your gear regularly\n• Think about joining a guild"
        },
        [10] = {
            id = "level_10",
            title = "Level 10 Achievement!",
            content = "You're doing great! At level 10:\n• You can create or join a guild\n• Consider your class specialization\n• Start saving for mounts\n• Learn about your profession options"
        },
        [20] = {
            id = "level_20",
            title = "Experienced Adventurer",
            content = "Level 20! You're getting experienced:\n• Focus on gear upgrades\n• Learn advanced class mechanics\n• Consider grouping for tougher content\n• Start thinking about dungeons"
        }
    },

    -- Zone-based tips
    zones = {
        ["Stormwind City"] = {
            id = "zone_stormwind",
            title = "Welcome to Stormwind!",
            content = "Capital city tips:\n• Visit the Auction House (bottom left)\n• Check the Class Trainer for new abilities\n• Use the Bank for storage\n• Explore the Trade District"
        },
        ["Orgrimmar"] = {
            id = "zone_orgrimmar",
            title = "Welcome to Orgrimmar!",
            content = "Capital city tips:\n• Visit the Auction House in the Valley of Strength\n• Check the Class Trainer for new abilities\n• Use the Bank for storage\n• Explore the different districts"
        },
        ["Elwynn Forest"] = {
            id = "zone_elwynn",
            title = "Exploring Elwynn Forest",
            content = "Starter zone tips:\n• Look for exclamation marks on minimap\n• Complete all quests for bonus XP\n• Explore side paths for hidden quests\n• Visit Goldshire for more quests"
        },
        ["Durotar"] = {
            id = "zone_durotar",
            title = "Exploring Durotar",
            content = "Starter zone tips:\n• Look for exclamation marks on minimap\n• Complete all quests for bonus XP\n• Explore side paths for hidden quests\n• Visit Razor Hill for more quests"
        }
    },

    -- General tips
    general = {
        welcome = {
            id = "general_welcome",
            title = "Welcome to Path of Mastery!",
            content = "Your advanced guide is ready:\n• Use /pom show to open the main window\n• Tips will appear automatically\n• Check the minimap for quick access\n• Customize settings as needed"
        },
        combat = {
            id = "general_combat",
            title = "Combat Fundamentals",
            content = "Essential combat tips:\n• Use abilities on cooldown\n• Position behind enemies when possible\n• Use health potions when low\n• Learn your class rotation\n• Stay aware of surroundings"
        },
        questing = {
            id = "general_questing",
            title = "Questing Strategies",
            content = "Advanced questing:\n• Group similar quests together\n• Use quest items immediately\n• Complete bonus objectives\n• Look for hidden quests\n• Turn in multiple quests at once"
        }
    }
}

-- Event handler implementations
function PathOfMastery:HandlePlayerEnteringWorld(...)
    self:Print("Welcome to your advanced guide!")
    -- Check if player is new and show initial tips
    local level = UnitLevel("player")
    if level <= 15 then
        self:ShowTip(self.tips.general.welcome.content, self.tips.general.welcome.id)
        -- Show additional new player tips
        self:ShowNewPlayerTips()
    end

    -- Check for zone and level tips
    self:CheckTips()
end

function PathOfMastery:HandlePlayerLevelUp(newLevel)
    self:Print("Congratulations on reaching level " .. newLevel .. "!")
    -- Show level-specific tips
    self:CheckTips()
end

function PathOfMastery:HandleZoneChanged(...)
    -- Show zone-specific tips
    self:CheckTips()
end

function PathOfMastery:HandleQuestAccepted(questID)
    -- Show quest-specific tips
    local questName = C_QuestLog.GetQuestInfo(questID)
    if questName then
        self:Print("New quest accepted: " .. questName)
        -- Could add specific quest tips here
    end
end

function PathOfMastery:HandleQuestTurnedIn(questID)
    -- Show completion tips
    local questName = C_QuestLog.GetQuestInfo(questID)
    if questName then
        self:Print("Quest completed: " .. questName)
        -- Could add completion tips here
    end
end

-- Check and show appropriate tips
function PathOfMastery:CheckTips()
    local level = UnitLevel("player")
    local zone = GetZoneText()
    local experienceLevel = PathOfMastery:GetExperienceLevel() or "beginner"

    -- Level-based tips (filtered by experience level)
    if self.tips.level[level] then
        local tip = self.tips.level[level]
        local shouldShow = false

        if experienceLevel == "beginner" then
            -- Show all level tips for beginners
            shouldShow = true
        elseif experienceLevel == "intermediate" then
            -- Show level 10+ tips for intermediate players
            shouldShow = level >= 10
        elseif experienceLevel == "advanced" then
            -- Show only level 20+ tips for advanced players
            shouldShow = level >= 20
        end

        if shouldShow then
            self:ShowTip(tip.content, tip.id)
        end
    end

    -- Zone-based tips (filtered by experience level)
    if self.tips.zones[zone] then
        local tip = self.tips.zones[zone]
        local shouldShow = false

        if experienceLevel == "beginner" then
            -- Show all zone tips for beginners
            shouldShow = true
        elseif experienceLevel == "intermediate" then
            -- Show zone tips for intermediate players
            shouldShow = true
        elseif experienceLevel == "advanced" then
            -- Don't show zone tips for advanced players (they know the basics)
            shouldShow = false
        end

        if shouldShow then
            self:ShowTip(tip.content, tip.id)
        end
    end
end

-- Show a tip to the player
function PathOfMastery:ShowTip(message, tipId)
    if not self.db.profile.enabled then return end

    -- Check if tip was already shown (if tipId provided)
    if tipId and self.db.global.shownTips[tipId] then
        return
    end

    -- Mark tip as shown
    if tipId then
        self.db.global.shownTips[tipId] = true
    end

    -- Create or update tip frame
    if not self.tipFrame then
        self:CreateTipFrame()
    end

    self.tipFrame.text:SetText(message)
    self.tipFrame:Show()

    -- Auto-hide after 10 seconds
    local hideFrame = CreateFrame("Frame")
    local startTime = GetTime()
    hideFrame:SetScript("OnUpdate", function(self, elapsed)
        if GetTime() - startTime >= 10 then
            if PathOfMastery.tipFrame then
                PathOfMastery.tipFrame:Hide()
            end
            self:SetScript("OnUpdate", nil)
        end
    end)

    -- Play sound if enabled
    if self.db.profile.soundEnabled then
        PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN)
    end
end

-- Create the tip notification frame
function PathOfMastery:CreateTipFrame()
    local frame = CreateFrame("Frame", "PathOfMasteryTipFrame", UIParent)
    frame:SetSize(300, 100)
    frame:SetPoint("TOP", 0, -50)
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 8, right = 8, top = 8, bottom = 8 }
    })
    frame:SetBackdropColor(0, 0, 0, 0.8)

    -- Title
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.title:SetPoint("TOP", 0, -10)
    frame.title:SetText("Path of Mastery Tip")

    -- Text
    frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.text:SetPoint("TOPLEFT", 15, -30)
    frame.text:SetPoint("BOTTOMRIGHT", -15, 15)
    frame.text:SetJustifyH("LEFT")
    frame.text:SetJustifyV("TOP")

    -- Close button
    local closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", -5, -5)
    closeButton:SetScript("OnClick", function()
        frame:Hide()
    end)

    -- Make draggable
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

    self.tipFrame = frame
end

-- Show additional tips for new players
function PathOfMastery:ShowNewPlayerTips()
    if not self:IsNewPlayer() then return end

    -- Show combat tips after a delay
    local combatFrame = CreateFrame("Frame")
    local combatStartTime = GetTime()
    combatFrame:SetScript("OnUpdate", function(self, elapsed)
        if GetTime() - combatStartTime >= 5 then
            if PathOfMastery:IsNewPlayer() then
                PathOfMastery:ShowTip(PathOfMastery.tips.general.combat.content, PathOfMastery.tips.general.combat.id)
            end
            self:SetScript("OnUpdate", nil)
        end
    end)

    -- Show questing tips after another delay
    local questFrame = CreateFrame("Frame")
    local questStartTime = GetTime()
    questFrame:SetScript("OnUpdate", function(self, elapsed)
        if GetTime() - questStartTime >= 10 then
            if PathOfMastery:IsNewPlayer() then
                PathOfMastery:ShowTip(PathOfMastery.tips.general.questing.content, PathOfMastery.tips.general.questing.id)
            end
            self:SetScript("OnUpdate", nil)
        end
    end)
end

-- Check if player is new/inexperienced
function PathOfMastery:IsNewPlayer()
    local experienceLevel = PathOfMastery:GetExperienceLevel()

    -- If experience level is set to beginner, consider them new
    if experienceLevel == "beginner" then
        return true
    end

    -- If experience level is advanced, don't consider them new
    if experienceLevel == "advanced" then
        return false
    end

    -- For intermediate or unset experience level, use level-based logic
    local level = UnitLevel("player")

    -- Consider player new if level 15 or below
    -- OR level 16-25 with additional zone check
    if level <= 15 then
        return true
    end

    -- Also check if they're in starter zones (for higher level players who might be new)
    local zone = GetZoneText()
    local starterZones = {
        "Northshire", "Elwynn Forest", "Deathknell", "Tirisfal Glades",
        "Durotar", "Mulgore", "Teldrassil", "Dun Morogh"
    }

    for _, starterZone in ipairs(starterZones) do
        if zone == starterZone then
            return true
        end
    end

    return false
end

-- Show welcome tip
function PathOfMastery:ShowWelcomeTip()
    self:ShowTip(self.tips.general.welcome.content, self.tips.general.welcome.id)
end

-- Export for other modules
PathOfMastery.Data = PathOfMastery
