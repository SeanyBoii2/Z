--[[
    =================================================================
    SPOOKALICIOUS V4 - CONFIG SYSTEM ADDON (FIXED)
    =================================================================
    
    USAGE:
    local ConfigSystem = loadstring(game:HttpGet("URL"))()
    ConfigSystem:Attach(Window)
--]]

local HttpService = game:GetService("HttpService")

local ConfigSystem = {}
ConfigSystem.__index = ConfigSystem

function ConfigSystem.new()
    local self = setmetatable({}, ConfigSystem)
    
    self.profiles = {}
    self.currentProfile = "Default"
    self.autoSave = false
    self.fileName = "SpookaliciousV4_Configs.json"
    self.window = nil
    
    return self
end

function ConfigSystem:Attach(window)
    self.window = window
    
    -- Load existing configs from file
    self:LoadFromFile()
    
    -- Add methods to window
    window.SaveConfig = function(_, profileName)
        return self:SaveConfig(profileName)
    end
    
    window.LoadConfig = function(_, profileName)
        return self:LoadConfig(profileName)
    end
    
    window.GetProfiles = function(_)
        return self:GetProfiles()
    end
    
    window.DeleteProfile = function(_, profileName)
        return self:DeleteProfile(profileName)
    end
    
    window.SetAutoSave = function(_, enabled)
        self.autoSave = enabled
        if enabled then
            self:SaveConfig(self.currentProfile)
        end
    end
    
    window.ExportConfig = function(_, profileName)
        return self:ExportConfig(profileName)
    end
    
    window.ImportConfig = function(_, data, profileName)
        return self:ImportConfig(data, profileName)
    end
    
    print("[CONFIG SYSTEM] Attached successfully. Profiles:", #self:GetProfiles())
end

function ConfigSystem:SaveConfig(profileName)
    profileName = profileName or self.currentProfile
    
    -- Access the global State variable that the library uses
    local State = _G.State or {}
    
    local configData = {
        version = "4.0",
        saved = os.date("%Y-%m-%d %H:%M:%S"),
        elements = {},
        menuSettings = {}
    }
    
    -- Save all element values from all pages
    if State.pages then
        for pageId, page in pairs(State.pages) do
            configData.elements[pageId] = {}
            
            for sectionIdx, section in ipairs(page.sections) do
                configData.elements[pageId][sectionIdx] = {}
                
                for elementIdx, element in ipairs(section.elements) do
                    if element.value ~= nil then
                        configData.elements[pageId][sectionIdx][elementIdx] = {
                            type = element.type,
                            value = element.value,
                            label = element.label
                        }
                    end
                end
            end
        end
    end
    
    -- Save menu settings
    configData.menuSettings = {
        colorIdx = State.colorIdx or 1,
        sounds = State.sounds,
        particles = State.particles,
        scanlines = State.scanlines,
        glitchTitle = State.glitchTitle,
        opacity = State.opacity or 80,
    }
    
    self.profiles[profileName] = configData
    self.currentProfile = profileName
    
    -- Write to file
    self:SaveToFile()
    
    if self.window and self.window.Notify then
        self.window:Notify("Config saved: " .. profileName)
    end
    
    return true
end

function ConfigSystem:LoadConfig(profileName)
    profileName = profileName or self.currentProfile
    
    local configData = self.profiles[profileName]
    if not configData then
        if self.window and self.window.Notify then
            self.window:Notify("Profile not found: " .. profileName)
        end
        return false
    end
    
    local State = _G.State or {}
    
    -- Restore element values
    if State.pages then
        for pageId, pageData in pairs(configData.elements) do
            if State.pages[pageId] then
                local page = State.pages[pageId]
                
                for sectionIdx, sectionData in pairs(pageData) do
                    if page.sections[sectionIdx] then
                        local section = page.sections[sectionIdx]
                        
                        for elementIdx, elementData in pairs(sectionData) do
                            if section.elements[elementIdx] then
                                local element = section.elements[elementIdx]
                                element.value = elementData.value
                                
                                -- Trigger callback
                                if element.callback then
                                    pcall(element.callback, elementData.value)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- Restore menu settings
    if configData.menuSettings then
        State.colorIdx = configData.menuSettings.colorIdx or State.colorIdx
        State.sounds = configData.menuSettings.sounds
        State.particles = configData.menuSettings.particles
        State.scanlines = configData.menuSettings.scanlines
        State.glitchTitle = configData.menuSettings.glitchTitle
        State.opacity = configData.menuSettings.opacity or State.opacity
    end
    
    self.currentProfile = profileName
    
    if self.window and self.window.Notify then
        self.window:Notify("Config loaded: " .. profileName)
    end
    
    return true
end

function ConfigSystem:GetProfiles()
    local list = {}
    for name, _ in pairs(self.profiles) do
        table.insert(list, name)
    end
    table.sort(list)
    return list
end

function ConfigSystem:DeleteProfile(profileName)
    if not profileName or profileName == "" then return false end
    
    self.profiles[profileName] = nil
    self:SaveToFile()
    
    if self.window and self.window.Notify then
        self.window:Notify("Profile deleted: " .. profileName)
    end
    
    return true
end

function ConfigSystem:ExportConfig(profileName)
    profileName = profileName or self.currentProfile
    local data = self.profiles[profileName]
    
    if not data then return nil end
    
    local encoded = HttpService:JSONEncode(data)
    
    if setclipboard then
        setclipboard(encoded)
        if self.window and self.window.Notify then
            self.window:Notify("Config copied to clipboard!")
        end
    end
    
    return encoded
end

function ConfigSystem:ImportConfig(jsonData, profileName)
    if not jsonData or jsonData == "" then return false end
    
    local success, data = pcall(function()
        return HttpService:JSONDecode(jsonData)
    end)
    
    if not success then
        if self.window and self.window.Notify then
            self.window:Notify("Invalid config data")
        end
        return false
    end
    
    profileName = profileName or "Imported_" .. os.time()
    self.profiles[profileName] = data
    self:SaveToFile()
    
    if self.window and self.window.Notify then
        self.window:Notify("Config imported: " .. profileName)
    end
    
    return true
end

function ConfigSystem:SaveToFile()
    if not writefile then return false end
    
    local allData = {
        version = "4.0",
        currentProfile = self.currentProfile,
        profiles = self.profiles
    }
    
    local success, encoded = pcall(function()
        return HttpService:JSONEncode(allData)
    end)
    
    if success then
        writefile(self.fileName, encoded)
        return true
    end
    
    return false
end

function ConfigSystem:LoadFromFile()
    if not readfile or not isfile then return false end
    if not isfile(self.fileName) then return false end
    
    local success, data = pcall(function()
        local content = readfile(self.fileName)
        return HttpService:JSONDecode(content)
    end)
    
    if success and data then
        self.profiles = data.profiles or {}
        self.currentProfile = data.currentProfile or "Default"
        return true
    end
    
    return false
end

-- Create and return instance
local instance = ConfigSystem.new()
return instance
