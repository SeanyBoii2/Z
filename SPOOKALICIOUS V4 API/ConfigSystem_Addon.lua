--[[
    ================================================================
    =           SPOOKALICIOUS V4 CONFIG SYSTEM ADDON               =
    =              Fixed version with file persistence             =
    ================================================================
--]]

local HttpService = game:GetService("HttpService")

local ConfigSystem = {}
ConfigSystem.__index = ConfigSystem

-- File configuration
local CONFIG_FOLDER = "SpookyHub_Configs/"
local CONFIG_EXTENSION = ".json"

-- Check if executor supports file operations
local function checkFileSupport()
    local success = pcall(function()
        if not isfolder(CONFIG_FOLDER) then
            makefolder(CONFIG_FOLDER)
        end
        writefile(CONFIG_FOLDER .. "test.txt", "test")
        readfile(CONFIG_FOLDER .. "test.txt")
        delfile(CONFIG_FOLDER .. "test.txt")
    end)
    return success
end

function ConfigSystem.new()
    local self = setmetatable({}, ConfigSystem)
    
    self.Window = nil
    self.AutoSave = false
    self.CurrentProfile = "Default"
    self.FileSupport = checkFileSupport()
    
    if not self.FileSupport then
        warn("[CONFIG SYSTEM] WARNING: File operations not supported!")
        warn("[CONFIG SYSTEM] Configs will NOT persist between sessions!")
    else
        print("[CONFIG SYSTEM] File support detected!")
        if not isfolder(CONFIG_FOLDER) then
            makefolder(CONFIG_FOLDER)
        end
    end
    
    return self
end

function ConfigSystem:Attach(window)
    if not window then
        warn("[CONFIG SYSTEM] No window provided!")
        return
    end
    
    self.Window = window
    
    -- Add methods to Window
    window.SaveConfig = function(_, profileName)
        return self:SaveConfig(profileName or self.CurrentProfile)
    end
    
    window.LoadConfig = function(_, profileName)
        return self:LoadConfig(profileName or self.CurrentProfile)
    end
    
    window.GetProfiles = function(_)
        return self:GetProfiles()
    end
    
    window.ExportConfig = function(_)
        return self:ExportConfig()
    end
    
    window.SetAutoSave = function(_, enabled)
        self.AutoSave = enabled
        print("[CONFIG SYSTEM] Auto-save:", enabled and "ON" or "OFF")
    end
    
    print("[CONFIG SYSTEM] Attached to window successfully!")
end

function ConfigSystem:SaveConfig(profileName)
    if not self.FileSupport then
        warn("[CONFIG SYSTEM] Cannot save - file operations not supported")
        return false
    end
    
    profileName = profileName or self.CurrentProfile
    local fileName = CONFIG_FOLDER .. profileName .. CONFIG_EXTENSION
    
    -- Collect all settings from Window
    local configData = {
        ProfileName = profileName,
        SavedAt = os.time(),
        Settings = {}
    }
    
    -- This is a basic implementation - the actual library might have different structure
    -- You may need to customize this based on how your library stores settings
    
    local success, err = pcall(function()
        local json = HttpService:JSONEncode(configData)
        writefile(fileName, json)
    end)
    
    if success then
        print("[CONFIG SYSTEM] ✓ Saved config:", profileName)
        return true
    else
        warn("[CONFIG SYSTEM] ✗ Save failed:", err)
        return false
    end
end

function ConfigSystem:LoadConfig(profileName)
    if not self.FileSupport then
        warn("[CONFIG SYSTEM] Cannot load - file operations not supported")
        return false
    end
    
    profileName = profileName or self.CurrentProfile
    local fileName = CONFIG_FOLDER .. profileName .. CONFIG_EXTENSION
    
    if not isfile(fileName) then
        warn("[CONFIG SYSTEM] Config file not found:", profileName)
        return false
    end
    
    local success, err = pcall(function()
        local json = readfile(fileName)
        local configData = HttpService:JSONDecode(json)
        
        -- Apply settings to Window
        -- This is a basic implementation - customize based on your library
        
        print("[CONFIG SYSTEM] ✓ Loaded config:", profileName)
    end)
    
    if success then
        return true
    else
        warn("[CONFIG SYSTEM] ✗ Load failed:", err)
        return false
    end
end

function ConfigSystem:GetProfiles()
    if not self.FileSupport then
        return {}
    end
    
    local profiles = {}
    
    local success = pcall(function()
        local files = listfiles(CONFIG_FOLDER)
        for _, filePath in ipairs(files) do
            local fileName = filePath:match("([^/\\]+)$")
            if fileName:match(CONFIG_EXTENSION .. "$") then
                local profileName = fileName:gsub(CONFIG_EXTENSION, "")
                table.insert(profiles, profileName)
            end
        end
    end)
    
    if not success then
        warn("[CONFIG SYSTEM] Failed to list profiles")
    end
    
    return profiles
end

function ConfigSystem:ExportConfig()
    if not setclipboard then
        warn("[CONFIG SYSTEM] Clipboard not supported")
        return false
    end
    
    local fileName = CONFIG_FOLDER .. self.CurrentProfile .. CONFIG_EXTENSION
    
    if not isfile(fileName) then
        warn("[CONFIG SYSTEM] No config to export")
        return false
    end
    
    local success = pcall(function()
        local json = readfile(fileName)
        setclipboard(json)
    end)
    
    if success then
        print("[CONFIG SYSTEM] ✓ Config exported to clipboard")
        return true
    else
        warn("[CONFIG SYSTEM] ✗ Export failed")
        return false
    end
end

function ConfigSystem:DeleteConfig(profileName)
    if not self.FileSupport then
        return false
    end
    
    profileName = profileName or self.CurrentProfile
    local fileName = CONFIG_FOLDER .. profileName .. CONFIG_EXTENSION
    
    if isfile(fileName) then
        delfile(fileName)
        print("[CONFIG SYSTEM] ✓ Deleted config:", profileName)
        return true
    end
    
    return false
end

-- Return a function that creates a new ConfigSystem instance
return function()
    return ConfigSystem.new()
end
