--- AceGUI-3.0 provides GUI widget functionality
-- Simplified version for Path of Mastery

local MAJOR, MINOR = "AceGUI-3.0", 41
local AceGUI, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not AceGUI then return end -- No upgrade needed

local type, pairs, ipairs, select, tconcat = type, pairs, ipairs, select, table.concat
local format, strfind, strsub, strmatch, strlower = string.format, string.find, string.sub, string.match, string.lower

-- Widget registry
AceGUI.WidgetRegistry = AceGUI.WidgetRegistry or {}
AceGUI.WidgetBase = AceGUI.WidgetBase or {}

-- Create widget function
function AceGUI:Create(type)
    if type == "Frame" then
        return self:CreateFrame()
    elseif type == "Button" then
        return self:CreateButton()
    elseif type == "CheckBox" then
        return self:CreateCheckBox()
    elseif type == "Slider" then
        return self:CreateSlider()
    elseif type == "EditBox" then
        return self:CreateEditBox()
    elseif type == "Label" then
        return self:CreateLabel()
    else
        error("Unknown widget type: " .. tostring(type))
    end
end

-- CreateFrame function
function AceGUI:CreateFrame()
    local frame = CreateFrame("Frame", nil, UIParent)
    frame:SetSize(400, 300)
    frame:SetPoint("CENTER")

    -- Add AceGUI methods
    frame.SetTitle = function(self, title)
        if not self.title then
            self.title = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            self.title:SetPoint("TOP", 0, -5)
        end
        self.title:SetText(title)
    end

    frame.SetStatusText = function(self, text)
        if not self.status then
            self.status = self:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            self.status:SetPoint("BOTTOMLEFT", 10, 10)
        end
        self.status:SetText(text)
    end

    frame.AddChild = function(self, child)
        child:SetParent(self)
        if not self.children then self.children = {} end
        table.insert(self.children, child)
    end

    return frame
end

-- CreateButton function
function AceGUI:CreateButton()
    local button = CreateFrame("Button", nil, UIParent, "GameMenuButtonTemplate")
    button:SetSize(100, 25)
    button:SetText("Button")

    button.SetText = function(self, text)
        self:SetText(text)
    end

    return button
end

-- CreateCheckBox function
function AceGUI:CreateCheckBox()
    local check = CreateFrame("CheckButton", nil, UIParent, "InterfaceOptionsCheckButtonTemplate")

    check.SetLabel = function(self, label)
        self.Text:SetText(label)
    end

    check.GetValue = function(self)
        return self:GetChecked()
    end

    check.SetValue = function(self, value)
        self:SetChecked(value)
    end

    return check
end

-- CreateSlider function
function AceGUI:CreateSlider()
    local slider = CreateFrame("Slider", nil, UIParent, "OptionsSliderTemplate")
    slider:SetWidth(200)
    slider:SetMinMaxValues(0, 100)
    slider:SetValueStep(1)

    slider.SetLabel = function(self, label)
        if not self.label then
            self.label = self:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            self.label:SetPoint("BOTTOM", self, "TOP", 0, 5)
        end
        self.label:SetText(label)
    end

    slider.GetValue = function(self)
        return self:GetValue()
    end

    slider.SetValue = function(self, value)
        self:SetValue(value)
    end

    return slider
end

-- CreateEditBox function
function AceGUI:CreateEditBox()
    local edit = CreateFrame("EditBox", nil, UIParent, "InputBoxTemplate")
    edit:SetSize(200, 20)
    edit:SetAutoFocus(false)

    edit.SetLabel = function(self, label)
        if not self.label then
            self.label = self:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            self.label:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 5)
        end
        self.label:SetText(label)
    end

    edit.GetText = function(self)
        return self:GetText()
    end

    edit.SetText = function(self, text)
        self:SetText(text)
    end

    return edit
end

-- CreateLabel function
function AceGUI:CreateLabel()
    local label = UIParent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetText("Label")

    label.SetText = function(self, text)
        self:SetText(text)
    end

    return label
end

-- RegisterAsWidget function
function AceGUI:RegisterAsWidget(widget)
    -- Simplified - just return the widget
    return widget
end

-- RegisterAsContainer function
function AceGUI:RegisterAsContainer(container)
    -- Simplified - just return the container
    return container
end

-- Register with LibStub
LibStub.libs[MAJOR] = AceGUI
