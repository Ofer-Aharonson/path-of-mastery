--- AceConsole-3.0 provides console functionality for addons
-- Simplified version for Path of Mastery

local MAJOR, MINOR = "AceConsole-3.0", 7
local AceConsole, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not AceConsole then return end -- No upgrade needed

local type, pairs, ipairs, select, tconcat = type, pairs, ipairs, select, table.concat
local format, strfind, strsub, strmatch, strlower = string.format, string.find, string.sub, string.match, string.lower

-- Mixins
local mixins = {
    "Print", "Printf", "RegisterChatCommand", "UnregisterChatCommand"
}

-- Embed function
function AceConsole:Embed(target)
    for k, v in pairs(mixins) do
        target[v] = self[v]
    end
    self.embeds[target] = true
    return target
end

-- Print function
function AceConsole:Print(...)
    local text = ""
    for i = 1, select("#", ...) do
        if i > 1 then text = text .. " " end
        text = text .. tostring(select(i, ...))
    end

    local status, err = pcall(function()
        DEFAULT_CHAT_FRAME:AddMessage(text, 1.0, 0.85, 0.0)
    end)
    if not status then
        print("[AceConsole] Error:", err)
    end
end

-- Printf function
function AceConsole:Printf(format, ...)
    self:Print(format:format(...))
end

-- RegisterChatCommand function
function AceConsole:RegisterChatCommand(command, func, persist)
    if type(command) ~= "string" then error("Usage: RegisterChatCommand(command, func, [persist]): 'command' - string expected.", 2) end
    if type(func) ~= "function" and type(func) ~= "string" then error("Usage: RegisterChatCommand(command, func, [persist]): 'func' - function or string expected.", 2) end

    self.commands = self.commands or {}
    self.commands[command] = func

    -- Register with WoW
    _G["SLASH_" .. command:upper() .. "1"] = "/" .. command:lower()
    SlashCmdList[command:upper()] = function(msg)
        if type(func) == "function" then
            func(msg)
        elseif type(func) == "string" and self[func] then
            self[func](self, msg)
        end
    end
end

-- UnregisterChatCommand function
function AceConsole:UnregisterChatCommand(command)
    if type(command) ~= "string" then error("Usage: UnregisterChatCommand(command): 'command' - string expected.", 2) end

    if self.commands then
        self.commands[command] = nil
    end

    -- Unregister from WoW
    _G["SLASH_" .. command:upper() .. "1"] = nil
    SlashCmdList[command:upper()] = nil
end

-- Export
AceConsole.embeds = AceConsole.embeds or setmetatable({}, {__mode="k"})

-- Register with LibStub
LibStub.libs[MAJOR] = AceConsole
