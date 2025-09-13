-- Path of Mastery Addon - UI Module
-- Handles user interface elements and frames
-- Author: GitHub Copilot
-- Version: 1.0.0

local PathOfMastery = _G.PathOfMastery

-- UI Module
PathOfMastery.UI = {}

-- Initialize UI components
function PathOfMastery.UI:Initialize()
    PathOfMastery:Print("Initializing UI components...")

    -- Create minimap button if enabled
    if PathOfMastery.db.profile.showMinimap then
        self:CreateMinimapButton()
    end

    -- Create main frame
    self:CreateMainFrame()

    PathOfMastery:Print("UI components initialized!")
end

-- Create the main UI frame
function PathOfMastery.UI:CreateMainFrame()
    local frame = CreateFrame("Frame", "PathOfMasteryMainFrame", UIParent, "BasicFrameTemplateWithInset")
    frame:SetSize(400, 300)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

    -- Title
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.title:SetPoint("TOP", 0, -5)
    frame.title:SetText("Path of Mastery - Advanced Guide")

    -- Close button
    frame.CloseButton:SetScript("OnClick", function()
        frame:Hide()
    end)

    -- Scroll frame for content
    local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 10, -30)
    scrollFrame:SetPoint("BOTTOMRIGHT", -30, 40)

    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetSize(360, 200)
    scrollFrame:SetScrollChild(content)

    -- Content text
    frame.contentText = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.contentText:SetPoint("TOPLEFT", 5, -5)
    frame.contentText:SetPoint("TOPRIGHT", -5, -5)
    frame.contentText:SetJustifyH("LEFT")
    frame.contentText:SetText("Welcome to Path of Mastery!\n\nThis addon provides advanced tips and guidance for new players.\n\nSelect a category below to get started.")

    -- Category buttons
    local categories = {"Getting Started", "Combat Tips", "Questing Guide", "Class Specific", "Settings"}
    frame.categoryButtons = {}

    for i, category in ipairs(categories) do
        local button = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
        button:SetSize(100, 25)
        button:SetPoint("BOTTOMLEFT", 10 + (i-1)*75, 10)
        button:SetText(category)
        button:SetScript("OnClick", function()
            self:ShowCategory(category)
        end)
        frame.categoryButtons[i] = button
    end

    self.mainFrame = frame
end

-- Show content for selected category
function PathOfMastery.UI:ShowCategory(category)
    local content = ""

    if category == "Getting Started" then
        content = "Welcome to Azeroth!\n\n• Always accept quests from NPCs\n• Use your minimap to navigate\n• Press 'M' to open your map\n• Join a guild for extra help\n• Don't forget to repair your gear!"
    elseif category == "Combat Tips" then
        content = "Combat Fundamentals:\n\n• Use abilities on cooldown\n• Position yourself behind enemies\n• Use health potions when low\n• Learn your class abilities\n• Always be aware of your surroundings"
    elseif category == "Questing Guide" then
        content = "Questing Strategies:\n\n• Group similar quests together\n• Use quest items immediately\n• Complete bonus objectives\n• Look for hidden quests\n• Turn in multiple quests at once"
    elseif category == "Class Specific" then
        content = "Class Tips:\n\n• Warriors: Use defensive cooldowns\n• Mages: Conserve mana carefully\n• Hunters: Keep pets buffed\n• Priests: Heal yourself in combat\n• Rogues: Position for backstabs"
    elseif category == "Settings" then
        content = "Addon Settings:\n\n• Enable/Disable tips\n• Toggle minimap button\n• Sound notifications\n• Reset all data\n\nUse /pom reset to reset settings"
    end

    if self.mainFrame and self.mainFrame.contentText then
        self.mainFrame.contentText:SetText(content)
    end
end

-- Show startup dialog for experience level selection
function PathOfMastery.UI:ShowStartupDialog()
    PathOfMastery:Print("ShowStartupDialog called")

    -- Don't show if dialog already exists
    if self.startupDialog then
        PathOfMastery:Print("Showing existing startup dialog")
        self.startupDialog:Show()
        return
    end

    PathOfMastery:Print("Creating new startup dialog")

    -- Create the startup dialog frame
    local dialog = CreateFrame("Frame", "PathOfMasteryStartupDialog", UIParent, "BasicFrameTemplateWithInset")
    dialog:SetSize(400, 250)
    dialog:SetPoint("CENTER")
    dialog:SetFrameStrata("DIALOG")
    dialog:SetFrameLevel(100)
    dialog:EnableMouse(true)

    -- Make it modal
    dialog:SetScript("OnShow", function()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)
    end)

    dialog:SetScript("OnHide", function()
        PlaySound(SOUNDKIT.IG_MAINMENU_CLOSE)
    end)

    -- Title
    dialog.title = dialog:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    dialog.title:SetPoint("TOP", 0, -10)
    dialog.title:SetText("Welcome to Path of Mastery!")

    -- Description text
    dialog.description = dialog:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dialog.description:SetPoint("TOPLEFT", 20, -40)
    dialog.description:SetPoint("TOPRIGHT", -20, -40)
    dialog.description:SetJustifyH("CENTER")
    dialog.description:SetText("To provide you with the best guidance, please tell us about your World of Warcraft experience:")

    -- Experience level buttons
    local buttonData = {
        {text = "Just Started", level = "beginner", description = "New to WoW - need basic guidance"},
        {text = "Played a Bit", level = "intermediate", description = "Some experience - can learn advanced tips"},
        {text = "Advanced Player", level = "advanced", description = "Experienced - minimal guidance needed"}
    }

    dialog.buttons = {}
    for i, data in ipairs(buttonData) do
        local button = CreateFrame("Button", nil, dialog, "GameMenuButtonTemplate")
        button:SetSize(350, 35)
        button:SetPoint("TOPLEFT", 25, -70 - (i-1)*45)
        button:SetText(data.text)

        -- Add description tooltip
        button:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(data.text, 1, 0.82, 0)
            GameTooltip:AddLine(data.description, nil, nil, nil, true)
            GameTooltip:Show()
        end)

        button:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)

        -- Set experience level on click
        button:SetScript("OnClick", function()
            PathOfMastery:SetExperienceLevel(data.level)
            dialog:Hide()
            -- Show a welcome message based on level
            if data.level == "beginner" then
                PathOfMastery:Print("Welcome! We'll provide comprehensive guidance to help you learn WoW.")
            elseif data.level == "intermediate" then
                PathOfMastery:Print("Great! We'll focus on advanced tips and strategies.")
            else
                PathOfMastery:Print("Welcome back! We'll keep guidance minimal but available if needed.")
            end
        end)

        dialog.buttons[i] = button
    end

    -- Skip button (bottom right)
    local skipButton = CreateFrame("Button", nil, dialog, "GameMenuButtonTemplate")
    skipButton:SetSize(80, 25)
    skipButton:SetPoint("BOTTOMRIGHT", -15, 15)
    skipButton:SetText("Skip")
    skipButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText("Skip for now", 1, 0.82, 0)
        GameTooltip:AddLine("You can set your experience level later in settings", nil, nil, nil, true)
        GameTooltip:Show()
    end)
    skipButton:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
    skipButton:SetScript("OnClick", function()
        -- Mark as shown but don't set experience level
        PathOfMastery.db.profile.startupDialogShown = true
        dialog:Hide()
        PathOfMastery:Print("Setup skipped. You can configure your experience level in settings.")
    end)

    -- Close button handler
    dialog.CloseButton:SetScript("OnClick", function()
        -- Mark as shown but don't set experience level
        PathOfMastery.db.profile.startupDialogShown = true
        dialog:Hide()
    end)

    self.startupDialog = dialog
    dialog:Show()
end

-- Hide main frame
function PathOfMastery.UI:HideMainFrame()
    if self.mainFrame then
        self.mainFrame:Hide()
    end
end

-- Create minimap button
function PathOfMastery.UI:CreateMinimapButton()
    local button = CreateFrame("Button", "PathOfMasteryMinimapButton", Minimap)
    button:SetSize(32, 32)
    button:SetFrameStrata("MEDIUM")
    button:SetFrameLevel(8)
    button:SetPoint("TOPLEFT", Minimap, "TOPLEFT")

    -- Button texture
    button.icon = button:CreateTexture(nil, "BACKGROUND")
    button.icon:SetTexture("Interface\\Icons\\INV_Misc_Book_09")
    button.icon:SetSize(20, 20)
    button.icon:SetPoint("CENTER")
    button.icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)

    -- Border
    button.border = button:CreateTexture(nil, "OVERLAY")
    button.border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    button.border:SetSize(54, 54)
    button.border:SetPoint("CENTER")

    -- Highlight
    button.highlight = button:CreateTexture(nil, "HIGHLIGHT")
    button.highlight:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    button.highlight:SetSize(32, 32)
    button.highlight:SetPoint("CENTER")
    button.highlight:SetBlendMode("ADD")

    -- Position (default position)
    if not PathOfMastery.db.minimapPos then
        PathOfMastery.db.minimapPos = 225
    end
    self:UpdateMinimapPosition()

    -- Scripts
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText("Path of Mastery")
        GameTooltip:AddLine("Left-click to open guide", 1, 1, 1)
        GameTooltip:AddLine("Right-click to show options", 1, 1, 1)
        GameTooltip:Show()
    end)

    button:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    button:SetScript("OnClick", function(self, button)
        if button == "LeftButton" then
            PathOfMastery.UI:ShowMainFrame()
        elseif button == "RightButton" then
            PathOfMastery.UI:ShowMinimapMenu()
        end
    end)

    button:SetScript("OnMouseDown", function(self)
        self.icon:SetTexCoord(0, 1, 0, 1)
    end)

    button:SetScript("OnMouseUp", function(self)
        self.icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
    end)

    -- Make draggable
    button:SetMovable(true)
    button:RegisterForDrag("LeftButton")
    button:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    button:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        PathOfMastery.UI:SaveMinimapPosition()
    end)

    self.minimapButton = button

    -- Register with Addon Compartment if available
    self:RegisterAddonCompartment()
end

-- Update minimap button position
function PathOfMastery.UI:UpdateMinimapPosition()
    if not self.minimapButton then return end

    local angle = PathOfMastery.db.minimapPos or 225
    local radius = 80
    local x = cos(angle) * radius
    local y = sin(angle) * radius
    self.minimapButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

-- Save minimap button position
function PathOfMastery.UI:SaveMinimapPosition()
    if not self.minimapButton then return end

    local x, y = self.minimapButton:GetCenter()
    local mx, my = Minimap:GetCenter()
    local dx, dy = x - mx, y - my
    local angle = atan2(dy, dx)
    if angle < 0 then
        angle = angle + 360
    end
    PathOfMastery.db.minimapPos = angle
end

-- Show minimap right-click menu
function PathOfMastery.UI:ShowMinimapMenu()
    PathOfMastery:Print("Right-click menu - use /pom show to open guide")
    -- For now, just show the main frame
    self:ShowMainFrame()
end

-- Refresh UI
function PathOfMastery.UI:Refresh()
    -- Refresh minimap button visibility
    if PathOfMastery.db.profile.showMinimap then
        if not self.minimapButton then
            self:CreateMinimapButton()
        end
        self.minimapButton:Show()
    else
        if self.minimapButton then
            self.minimapButton:Hide()
        end
    end
end

-- Register with Addon Compartment
function PathOfMastery.UI:RegisterAddonCompartment()
    -- Check if Addon Compartment is available (WoW 10.0+)
    if AddonCompartmentFrame then
        AddonCompartmentFrame:RegisterAddon({
            text = "Path of Mastery",
            icon = "Interface\\Icons\\INV_Misc_Book_09",
            notCheckable = true,
            func = function(button, menuInputData, menu)
                PathOfMastery.UI:ShowMainFrame()
            end,
            funcOnEnter = function(button)
                MenuUtil.ShowTooltip(button, function(tooltip)
                    tooltip:SetText("Path of Mastery")
                    tooltip:AddLine("Advanced new player guide", 1, 1, 1, true)
                    tooltip:AddLine("Click to open the guide", 0.5, 0.5, 0.5, true)
                end)
            end,
            funcOnLeave = function(button)
                MenuUtil.HideTooltip(button)
            end,
        })
    end
end
