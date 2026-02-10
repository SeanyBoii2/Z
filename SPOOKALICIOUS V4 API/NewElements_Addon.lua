--[[
    =================================================================
    SPOOKALICIOUS V4 - NEW ELEMENTS ADDON
    =================================================================
    
    Adds new element types to your existing library:
    - CreateColorPicker()
    - CreateMultiSlider()
    - CreateProgressBar()
    - CreateLabel()
    - CreateDivider()
    
    INSTALLATION:
    1. Load your existing SpookaliciousV4 library
    2. Load this addon
    3. Call: ExtendSpookalicious(Library)
    
    USAGE:
    local Section = Page:CreateSection("My Section")
    
    -- Color picker
    local color = Section:CreateColorPicker("Color", {
        Default = Color3.fromRGB(255, 100, 100)
    }, function(c)
        print("Color:", c)
    end)
    
    -- Multi-slider
    local pos = Section:CreateMultiSlider("Position", {
        Labels = {"X", "Y", "Z"},
        Defaults = {0, 50, 0},
        Min = -100,
        Max = 100
    }, function(values)
        print("X:", values[1], "Y:", values[2], "Z:", values[3])
    end)
    
    -- Progress bar
    local progress = Section:CreateProgressBar("Loading", {
        Max = 100
    })
    progress:Set(50)
    
    -- Label
    Section:CreateLabel("This is informational text")
    
    -- Divider
    Section:CreateDivider()
--]]

local function ExtendSpookalicious(Library)
    print("[NEW ELEMENTS] Extending Spookalicious with new element types...")
    
    -- We need to hook into the Section class creation
    -- This assumes the Section metatable is accessible
    
    -- Store original CreateSection
    local originalCreateSection = nil
    
    -- Find and wrap Page:CreateSection
    local function WrapPage(Page)
        originalCreateSection = Page.CreateSection
        
        Page.CreateSection = function(self, sectionName, options)
            options = options or {}
            local Section = originalCreateSection(self, sectionName)
            
            -- Add new methods to this Section instance
            
            --================================================
            -- COLOR PICKER
            --================================================
            function Section:CreateColorPicker(label, options, callback)
                options = options or {}
                local el = {
                    type = "colorpicker",
                    label = label,
                    value = options.Default or Color3.fromRGB(255, 255, 255),
                    callback = callback,
                    _expanded = false,
                    _hue = 0,
                    _sat = 1,
                    _val = 1,
                }
                
                -- Convert default color to HSV
                local h, s, v = Color3.toHSV(el.value)
                el._hue = h
                el._sat = s
                el._val = v
                
                table.insert(self._section.elements, el)
                
                return {
                    Set = function(_, color)
                        el.value = color
                        local h, s, v = Color3.toHSV(color)
                        el._hue = h
                        el._sat = s
                        el._val = v
                        if callback then callback(color) end
                        if _G.SpookyState and _G.SpookyState.visible then
                            _G.SpookyRenderView()
                        end
                    end,
                    Get = function(_) return el.value end,
                }
            end
            
            --================================================
            -- MULTI-SLIDER
            --================================================
            function Section:CreateMultiSlider(label, options, callback)
                options = options or {}
                local labels = options.Labels or {"X", "Y", "Z"}
                local defaults = options.Defaults or {}
                
                local el = {
                    type = "multislider",
                    label = label,
                    value = {},
                    labels = labels,
                    min = options.Min or 0,
                    max = options.Max or 100,
                    step = options.Step or 1,
                    callback = callback,
                    _selected = 1, -- Which slider is currently selected
                }
                
                -- Initialize values
                for i, lbl in ipairs(labels) do
                    el.value[i] = defaults[i] or el.min
                end
                
                table.insert(self._section.elements, el)
                
                return {
                    Set = function(_, index, value)
                        if type(index) == "table" then
                            -- Set all values
                            el.value = index
                        else
                            -- Set single value
                            el.value[index] = math.clamp(value, el.min, el.max)
                        end
                        if callback then callback(el.value) end
                        if _G.SpookyState and _G.SpookyState.visible then
                            _G.SpookyRenderView()
                        end
                    end,
                    Get = function(_, index)
                        if index then
                            return el.value[index]
                        end
                        return el.value
                    end,
                }
            end
            
            --================================================
            -- PROGRESS BAR
            --================================================
            function Section:CreateProgressBar(label, options)
                options = options or {}
                local el = {
                    type = "progressbar",
                    label = label,
                    value = options.Value or 0,
                    min = options.Min or 0,
                    max = options.Max or 100,
                    color = options.Color or Color3.fromRGB(80, 255, 144),
                }
                
                table.insert(self._section.elements, el)
                
                return {
                    Set = function(_, value)
                        el.value = math.clamp(value, el.min, el.max)
                        if _G.SpookyState and _G.SpookyState.visible then
                            _G.SpookyRenderView()
                        end
                    end,
                    Get = function(_) return el.value end,
                    SetColor = function(_, color)
                        el.color = color
                        if _G.SpookyState and _G.SpookyState.visible then
                            _G.SpookyRenderView()
                        end
                    end,
                }
            end
            
            --================================================
            -- INFO LABEL
            --================================================
            function Section:CreateLabel(text, options)
                options = options or {}
                local el = {
                    type = "label",
                    text = text,
                    color = options.Color or nil,
                    size = options.Size or 13,
                    centered = options.Centered or false,
                }
                
                table.insert(self._section.elements, el)
                
                return {
                    SetText = function(_, newText)
                        el.text = newText
                        if _G.SpookyState and _G.SpookyState.visible then
                            _G.SpookyRenderView()
                        end
                    end,
                    SetColor = function(_, color)
                        el.color = color
                        if _G.SpookyState and _G.SpookyState.visible then
                            _G.SpookyRenderView()
                        end
                    end,
                }
            end
            
            --================================================
            -- DIVIDER
            --================================================
            function Section:CreateDivider()
                local el = {
                    type = "divider",
                }
                
                table.insert(self._section.elements, el)
                
                return el
            end
            
            -- Store section reference for elements to access
            Section._section = self
            
            return Section
        end
    end
    
    -- Hook into window creation to wrap pages
    local originalCreateWindow = Library.CreateWindow
    Library.CreateWindow = function(self, title, version)
        local Window = originalCreateWindow(self, title, version)
        
        -- Wrap CreatePage
        local originalCreatePage = Window.CreatePage
        Window.CreatePage = function(self, name)
            local Page = originalCreatePage(self, name)
            WrapPage(Page)
            return Page
        end
        
        return Window
    end
    
    print("[NEW ELEMENTS] Extension complete!")
end

-- Auto-extend if Library exists
if _G.SpookyLibrary then
    ExtendSpookalicious(_G.SpookyLibrary)
end

return {
    Extend = ExtendSpookalicious
}
