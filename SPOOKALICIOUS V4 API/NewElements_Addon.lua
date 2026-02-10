--[[
    =================================================================
    SPOOKALICIOUS V4 - NEW ELEMENTS ADDON (FIXED)
    =================================================================
    
    Adds new element types:
    - CreateLabel()
    - CreateDivider()
    - CreateColorPicker()
    - CreateMultiSlider()
    - CreateProgressBar()
    
    USAGE:
    local NewElements = loadstring(game:HttpGet("URL"))()
    NewElements.Extend(Library)
    local Window = Library:CreateWindow("Title", "v1.0")
--]]

local function ExtendSpookalicious(Library)
    print("[NEW ELEMENTS] Extending Spookalicious...")
    
    -- Hook into CreateWindow to wrap CreatePage
    local originalCreateWindow = Library.CreateWindow
    Library.CreateWindow = function(self, title, version)
        local Window = originalCreateWindow(self, title, version)
        
        -- Wrap CreatePage
        local originalCreatePage = Window.CreatePage
        Window.CreatePage = function(self, name)
            local Page = originalCreatePage(self, name)
            
            -- Wrap CreateSection
            local originalCreateSection = Page.CreateSection
            Page.CreateSection = function(self, sectionName, options)
                local Section = originalCreateSection(self, sectionName, options)
                
                -- Get reference to the actual section data
                -- It was just added to the page.sections array
                local State = _G.State or {}
                local pageId = nil
                for pid, pg in pairs(State.pages or {}) do
                    if pg == self then
                        pageId = pid
                        break
                    end
                end
                
                local sectionData = nil
                if pageId and State.pages[pageId] then
                    local sections = State.pages[pageId].sections
                    sectionData = sections[#sections] -- The section we just created
                end
                
                --================================================
                -- LABEL
                --================================================
                function Section:CreateLabel(text, options)
                    options = options or {}
                    local el = {
                        type = "label",
                        text = text,
                        label = text, -- For consistency
                        color = options.Color or nil,
                        size = options.Size or 13,
                        centered = options.Centered or false,
                    }
                    
                    if sectionData then
                        table.insert(sectionData.elements, el)
                    end
                    
                    return {
                        SetText = function(_, newText)
                            el.text = newText
                            el.label = newText
                        end,
                        SetColor = function(_, color)
                            el.color = color
                        end,
                    }
                end
                
                --================================================
                -- DIVIDER
                --================================================
                function Section:CreateDivider()
                    local el = {
                        type = "divider",
                        label = "---",
                    }
                    
                    if sectionData then
                        table.insert(sectionData.elements, el)
                    end
                    
                    return el
                end
                
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
                    
                    if sectionData then
                        table.insert(sectionData.elements, el)
                    end
                    
                    return {
                        Set = function(_, color)
                            el.value = color
                            local h, s, v = Color3.toHSV(color)
                            el._hue = h
                            el._sat = s
                            el._val = v
                            if callback then callback(color) end
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
                        _selected = 1,
                    }
                    
                    -- Initialize values
                    for i, lbl in ipairs(labels) do
                        el.value[i] = defaults[i] or el.min
                    end
                    
                    if sectionData then
                        table.insert(sectionData.elements, el)
                    end
                    
                    return {
                        Set = function(_, index, value)
                            if type(index) == "table" then
                                el.value = index
                            else
                                el.value[index] = math.clamp(value, el.min, el.max)
                            end
                            if callback then callback(el.value) end
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
                    
                    if sectionData then
                        table.insert(sectionData.elements, el)
                    end
                    
                    return {
                        Set = function(_, value)
                            el.value = math.clamp(value, el.min, el.max)
                        end,
                        Get = function(_) return el.value end,
                        SetColor = function(_, color)
                            el.color = color
                        end,
                    }
                end
                
                return Section
            end
            
            return Page
        end
        
        return Window
    end
    
    print("[NEW ELEMENTS] Extension complete!")
end

return {
    Extend = ExtendSpookalicious
}
