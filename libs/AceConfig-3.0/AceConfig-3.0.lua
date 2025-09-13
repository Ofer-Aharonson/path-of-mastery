--- AceConfig-3.0 provides configuration panel functionality
-- Simplified version for Path of Mastery

local MAJOR, MINOR = "AceConfig-3.0", 14
local AceConfig, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not AceConfig then return end -- No upgrade needed

local type, pairs, ipairs, select, tconcat = type, pairs, ipairs, select, table.concat
local format, strfind, strsub, strmatch, strlower = string.format, string.find, string.sub, string.match, string.lower

-- Mixins
local mixins = {
    "RegisterOptionsTable", "Open", "Close", "GetOptionsTable"
}

-- Embed function
function AceConfig:Embed(target)
    for k, v in pairs(mixins) do
        target[v] = self[v]
    end
    self.embeds[target] = true
    return target
end

-- RegisterOptionsTable function
function AceConfig:RegisterOptionsTable(appName, options, slashcmd)
    if type(appName) ~= "string" then error("Usage: RegisterOptionsTable(appName, options, [slashcmd]): 'appName' - string expected.", 2) end
    if type(options) ~= "table" then error("Usage: RegisterOptionsTable(appName, options, [slashcmd]): 'options' - table expected.", 2) end

    self.optionsTables = self.optionsTables or {}
    self.optionsTables[appName] = options

    -- Register slash command if provided
    if slashcmd then
        self.slashCommands = self.slashCommands or {}
        self.slashCommands[slashcmd] = appName
    end
end

-- GetOptionsTable function
function AceConfig:GetOptionsTable(appName)
    if type(appName) ~= "string" then error("Usage: GetOptionsTable(appName): 'appName' - string expected.", 2) end
    return self.optionsTables and self.optionsTables[appName]
end

-- Open function
function AceConfig:Open(appName)
    if type(appName) ~= "string" then error("Usage: Open(appName): 'appName' - string expected.", 2) end

    local options = self:GetOptionsTable(appName)
    if not options then error(format("Usage: Open(appName): options table '%s' not found.", appName), 2) end

    -- Create or show options frame
    self:CreateOptionsFrame(appName, options)
end

-- Close function
function AceConfig:Close(appName)
    if type(appName) ~= "string" then error("Usage: Close(appName): 'appName' - string expected.", 2) end

    if self.frames and self.frames[appName] then
        self.frames[appName]:Hide()
    end
end

-- CreateOptionsFrame function (internal)
function AceConfig:CreateOptionsFrame(appName, options)
    self.frames = self.frames or {}

    local frame = self.frames[appName]
    if not frame then
        frame = CreateFrame("Frame", "AceConfigFrame_" .. appName, UIParent, "BasicFrameTemplateWithInset")
        frame:SetSize(500, 400)
        frame:SetPoint("CENTER")
        frame:SetMovable(true)
        frame:EnableMouse(true)
        frame:RegisterForDrag("LeftButton")
        frame:SetScript("OnDragStart", frame.StartMoving)
        frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

        -- Title
        frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        frame.title:SetPoint("TOP", 0, -5)
        frame.title:SetText(options.name or appName)

        -- Close button
        frame.CloseButton:SetScript("OnClick", function() frame:Hide() end)

        -- Scroll frame for options
        local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
        scrollFrame:SetPoint("TOPLEFT", 10, -30)
        scrollFrame:SetPoint("BOTTOMRIGHT", -30, 40)

        local content = CreateFrame("Frame", nil, scrollFrame)
        content:SetSize(460, 300)
        scrollFrame:SetScrollChild(content)

        frame.content = content
        self.frames[appName] = frame
    end

    -- Clear previous content
    local content = frame.content
    local children = {content:GetChildren()}
    for _, child in ipairs(children) do
        child:Hide()
        child:SetParent(nil)
    end

    -- Build options
    self:BuildOptions(content, options, 0, 0)

    frame:Show()
end

-- BuildOptions function (internal)
function AceConfig:BuildOptions(parent, options, x, y)
    local currentY = y

    for _, option in ipairs(options) do
        if option.type == "header" then
            local header = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            header:SetPoint("TOPLEFT", x, currentY)
            header:SetText(option.name)
            currentY = currentY - 20
        elseif option.type == "description" then
            local desc = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            desc:SetPoint("TOPLEFT", x, currentY)
            desc:SetText(option.name)
            desc:SetWidth(400)
            desc:SetJustifyH("LEFT")
            currentY = currentY - 30
        elseif option.type == "toggle" then
            -- Checkbox
            local check = CreateFrame("CheckButton", nil, parent, "InterfaceOptionsCheckButtonTemplate")
            check:SetPoint("TOPLEFT", x, currentY)
            check.Text:SetText(option.name)
            check.tooltipText = option.desc

            if option.get then
                check:SetChecked(option.get())
            end

            if option.set then
                check:SetScript("OnClick", function(self)
                    option.set(self:GetChecked())
                end)
            end

            currentY = currentY - 25
        elseif option.type == "range" then
            -- Slider
            local slider = CreateFrame("Slider", nil, parent, "OptionsSliderTemplate")
            slider:SetPoint("TOPLEFT", x + 20, currentY)
            slider:SetWidth(200)
            slider:SetMinMaxValues(option.min or 0, option.max or 100)
            slider:SetValueStep(option.step or 1)

            local label = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            label:SetPoint("TOPLEFT", x, currentY)
            label:SetText(option.name)

            if option.get then
                slider:SetValue(option.get())
            end

            if option.set then
                slider:SetScript("OnValueChanged", function(self, value)
                    option.set(value)
                end)
            end

            currentY = currentY - 40
        elseif option.type == "select" then
            -- Dropdown (simplified)
            local label = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            label:SetPoint("TOPLEFT", x, currentY)
            label:SetText(option.name)
            currentY = currentY - 20

            -- For now, just show current value
            if option.get then
                local valueLabel = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                valueLabel:SetPoint("TOPLEFT", x + 20, currentY)
                valueLabel:SetText(option.get())
            end
            currentY = currentY - 20
        end
    end
end

-- Export
AceConfig.embeds = AceConfig.embeds or setmetatable({}, {__mode="k"})

-- Register with LibStub
LibStub.libs[MAJOR] = AceConfig
