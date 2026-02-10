--[[
    =================================================================
    SPOOKALICIOUS V4 - CONFIG SYSTEM ADDON
    =================================================================
    
    Add this to your existing SpookaliciousV4 to enable:
    - Save/Load configurations
    - Multiple profiles  
    - Auto-save
    - Export/Import
    
    USAGE:
    Add to your Window creation:
    
    local Window = Library:CreateWindow("My Menu", "v1.0")
    
    -- Load the config system
    loadstring(game:HttpGet("CONFIG_SYSTEM_URL"))()
    ConfigSystem:Attach(Window)
    
    -- Now you can:
    Window:SaveConfig("ProfileName")
    Window:LoadConfig("ProfileName")
    Window:GetProfiles()
    Window:DeleteProfile("ProfileName")
    Window:SetAutoSave(true)
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
    self.state = nil
    
    return self
end

function ConfigSystem:Attach(window)
    self.window = window
    self.state = window._state -- Assuming window stores its state here
    
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
    
    print("[CONFIG SYSTEM] Attached to window. Profiles:", #self:GetProfiles())
end

function ConfigSystem:SaveConfig(profileName)
    profileName = profileName or self.currentProfile
    
    local configData = {
        version = "4.0",
        saved = os.date("%Y-%m-%d %H:%M:%S"),
        elements = {},
        menuSettings = {}
    }
    
    -- Save all element values from all pages
    for pageId, page in pairs(self.state.pages) do
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
    
    -- Save menu settings
    configData.menuSettings = {
        colorIdx = self.state.colorIdx,
        sounds = self.state.sounds,
        particles = self.state.particles,
        scanlines = self.state.scanlines,
        glitchTitle = self.state.glitchTitle,
        opacity = self.state.opacity,
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
    
    -- Restore element values
    for pageId, pageData in pairs(configData.elements) do
        if self.state.pages[pageId] then
            local page = self.state.pages[pageId]
            
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
    
    -- Restore menu settings
    if configData.menuSettings then
        self.state.colorIdx = configData.menuSettings.colorIdx or self.state.colorIdx
        self.state.sounds = configData.menuSettings.sounds
        self.state.particles = configData.menuSettings.particles
        self.state.scanlines = configData.menuSettings.scanlines
        self.state.glitchTitle = configData.menuSettings.glitchTitle
        self.state.opacity = configData.menuSettings.opacity or self.state.opacity
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

-- Global instance
_G.SpookyConfigSystem = ConfigSystem.new()

return ConfigSystem
