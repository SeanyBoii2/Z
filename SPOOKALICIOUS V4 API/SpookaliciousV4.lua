--[[
    ================================================================
    =       S P O O K A L I C I O U S   V 4   L I B R A R Y       =
    =       Professional Mod Menu UI Library for Roblox             =
    ================================================================
    
    USAGE:
    
    local Library = loadstring(...)()
    local Window = Library:CreateWindow("My Menu", "v1.0")
    
    local Page = Window:CreatePage("Combat")
    local Section = Page:CreateSection("Aimbot")
    
    Section:CreateToggle("Enabled", {Toggled = false}, function(value)
        print("Aimbot:", value)
    end)
    
    Section:CreateSlider("FOV", {Min = 10, Max = 500, Default = 120}, function(value)
        print("FOV:", value)
    end)
    
    Section:CreateButton("Kill All", function()
        print("Executed!")
    end)
    
    Section:CreateTextbox("Target", "Enter name...", function(text)
        print("Target:", text)
    end)
    
    Section:CreateDropdown("Mode", {
        List = {"Head", "Torso", "Nearest"},
        Default = "Head"
    }, function(value)
        print("Mode:", value)
    end)
    
    Section:CreateKeybind("Toggle Key", {Default = Enum.KeyCode.E}, function(key)
        print("Keybind:", key)
    end)
    
    CONTROLS:
      [       Open / Close menu
      W / S   Scroll up / down (wraps)
      A / D   Slider adjust / Dropdown cycle
      F/SPACE Select / Toggle / Activate
      X       Back / Close
      Drag titlebar to move. Drag corner to resize.
--]]

-- Services
local Players       = game:GetService("Players")
local UIS           = game:GetService("UserInputService")
local CAS           = game:GetService("ContextActionService")
local TS            = game:GetService("TweenService")
local RS            = game:GetService("RunService")
local SoundService  = game:GetService("SoundService")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

------------------------------------------------------------------------
--  CLEAN UP PREVIOUS
------------------------------------------------------------------------
local old = playerGui:FindFirstChild("SpookaliciousV4")
if old then old:Destroy() end

------------------------------------------------------------------------
--  THEME SYSTEM
------------------------------------------------------------------------
local THEMES = {
    {
        name = "PHANTOM PURPLE",
        border = Color3.fromRGB(140, 60, 220),
        glow = Color3.fromRGB(160, 80, 255),
        accent = Color3.fromRGB(220, 170, 255),
        accentDim = Color3.fromRGB(154, 112, 200),
        bg = Color3.fromRGB(12, 5, 22),
        bgLight = Color3.fromRGB(22, 10, 40),
        subtitleBg = Color3.fromRGB(140, 60, 220),
        subtitleTxt = Color3.fromRGB(240, 220, 255),
        onColor = Color3.fromRGB(80, 255, 144),
        offColor = Color3.fromRGB(255, 64, 112),
        sliderFill = Color3.fromRGB(160, 80, 255),
        sliderTrack = Color3.fromRGB(40, 18, 70),
        particle = Color3.fromRGB(180, 120, 255),
        fog = Color3.fromRGB(120, 40, 200),
        sectionColor = Color3.fromRGB(100, 55, 160),
        inputBg = Color3.fromRGB(25, 12, 45),
        inputBorder = Color3.fromRGB(80, 40, 140),
    },
    {
        name = "BLOOD RED",
        border = Color3.fromRGB(200, 40, 40),
        glow = Color3.fromRGB(220, 50, 50),
        accent = Color3.fromRGB(255, 180, 180),
        accentDim = Color3.fromRGB(180, 100, 100),
        bg = Color3.fromRGB(22, 5, 5),
        bgLight = Color3.fromRGB(40, 10, 10),
        subtitleBg = Color3.fromRGB(180, 30, 30),
        subtitleTxt = Color3.fromRGB(255, 220, 220),
        onColor = Color3.fromRGB(80, 255, 144),
        offColor = Color3.fromRGB(255, 64, 112),
        sliderFill = Color3.fromRGB(200, 50, 50),
        sliderTrack = Color3.fromRGB(60, 15, 15),
        particle = Color3.fromRGB(255, 100, 100),
        fog = Color3.fromRGB(200, 30, 30),
        sectionColor = Color3.fromRGB(160, 55, 55),
        inputBg = Color3.fromRGB(40, 10, 10),
        inputBorder = Color3.fromRGB(140, 40, 40),
    },
    {
        name = "GHOUL GREEN",
        border = Color3.fromRGB(40, 180, 80),
        glow = Color3.fromRGB(60, 200, 100),
        accent = Color3.fromRGB(180, 255, 200),
        accentDim = Color3.fromRGB(100, 170, 120),
        bg = Color3.fromRGB(5, 18, 8),
        bgLight = Color3.fromRGB(10, 35, 16),
        subtitleBg = Color3.fromRGB(40, 160, 70),
        subtitleTxt = Color3.fromRGB(220, 255, 230),
        onColor = Color3.fromRGB(80, 255, 144),
        offColor = Color3.fromRGB(255, 64, 112),
        sliderFill = Color3.fromRGB(50, 200, 90),
        sliderTrack = Color3.fromRGB(15, 50, 25),
        particle = Color3.fromRGB(100, 255, 150),
        fog = Color3.fromRGB(30, 160, 60),
        sectionColor = Color3.fromRGB(50, 140, 70),
        inputBg = Color3.fromRGB(8, 30, 14),
        inputBorder = Color3.fromRGB(40, 120, 60),
    },
    {
        name = "SPIRIT BLUE",
        border = Color3.fromRGB(40, 80, 220),
        glow = Color3.fromRGB(60, 100, 240),
        accent = Color3.fromRGB(180, 200, 255),
        accentDim = Color3.fromRGB(100, 120, 180),
        bg = Color3.fromRGB(5, 8, 22),
        bgLight = Color3.fromRGB(10, 16, 40),
        subtitleBg = Color3.fromRGB(40, 70, 200),
        subtitleTxt = Color3.fromRGB(220, 230, 255),
        onColor = Color3.fromRGB(80, 255, 144),
        offColor = Color3.fromRGB(255, 64, 112),
        sliderFill = Color3.fromRGB(50, 90, 220),
        sliderTrack = Color3.fromRGB(15, 22, 60),
        particle = Color3.fromRGB(100, 150, 255),
        fog = Color3.fromRGB(30, 60, 200),
        sectionColor = Color3.fromRGB(55, 75, 160),
        inputBg = Color3.fromRGB(10, 14, 38),
        inputBorder = Color3.fromRGB(40, 60, 140),
    },
    {
        name = "CURSED GOLD",
        border = Color3.fromRGB(200, 160, 40),
        glow = Color3.fromRGB(220, 180, 50),
        accent = Color3.fromRGB(255, 235, 170),
        accentDim = Color3.fromRGB(180, 150, 90),
        bg = Color3.fromRGB(20, 15, 5),
        bgLight = Color3.fromRGB(38, 28, 10),
        subtitleBg = Color3.fromRGB(180, 140, 30),
        subtitleTxt = Color3.fromRGB(255, 245, 210),
        onColor = Color3.fromRGB(80, 255, 144),
        offColor = Color3.fromRGB(255, 64, 112),
        sliderFill = Color3.fromRGB(200, 160, 40),
        sliderTrack = Color3.fromRGB(55, 42, 12),
        particle = Color3.fromRGB(255, 220, 100),
        fog = Color3.fromRGB(180, 140, 30),
        sectionColor = Color3.fromRGB(160, 130, 40),
        inputBg = Color3.fromRGB(35, 26, 8),
        inputBorder = Color3.fromRGB(140, 110, 30),
    },
    {
        name = "RAINBOW",
        -- These are placeholder values; ct() generates dynamic colors when this theme is active
        border = Color3.fromRGB(255, 80, 80),
        glow = Color3.fromRGB(255, 100, 100),
        accent = Color3.fromRGB(255, 220, 220),
        accentDim = Color3.fromRGB(200, 150, 150),
        bg = Color3.fromRGB(12, 5, 22),
        bgLight = Color3.fromRGB(22, 10, 40),
        subtitleBg = Color3.fromRGB(255, 80, 80),
        subtitleTxt = Color3.fromRGB(255, 240, 240),
        onColor = Color3.fromRGB(80, 255, 144),
        offColor = Color3.fromRGB(255, 64, 112),
        sliderFill = Color3.fromRGB(255, 80, 80),
        sliderTrack = Color3.fromRGB(40, 18, 40),
        particle = Color3.fromRGB(255, 150, 150),
        fog = Color3.fromRGB(200, 60, 60),
        sectionColor = Color3.fromRGB(200, 100, 100),
        inputBg = Color3.fromRGB(25, 12, 30),
        inputBorder = Color3.fromRGB(140, 60, 60),
    },
}

------------------------------------------------------------------------
--  INTERNAL STATE
------------------------------------------------------------------------
local State = {
    visible = false,
    colorIdx = 1,
    sounds = true,
    particles = true,
    scanlines = true,
    glitchTitle = true,
    opacity = 80,

    -- Navigation
    currentView = "home",    -- "home" or page id
    sel = 1,
    stack = {},

    -- All registered pages
    pages = {},
    pageOrder = {},

    -- Current flat item list for keyboard nav
    flatItems = {},

    -- Window info
    title = "SPOOKALICIOUS",
    version = "V4",
}

-- ✨ Make State globally accessible for addons
_G.State = State

local rainbowHue = 0 -- Updated in Heartbeat

local function hsvToRgb(h, s, v)
    return Color3.fromHSV(h % 1, s, v)
end

local function ct()
    local base = THEMES[State.colorIdx]
    if base.name ~= "RAINBOW" then return base end

    -- Generate dynamic rainbow theme from current hue
    local h = rainbowHue
    local border   = hsvToRgb(h, 0.7, 0.85)
    local glow     = hsvToRgb(h, 0.6, 1.0)
    local accent   = hsvToRgb(h, 0.25, 1.0)
    local accentD  = hsvToRgb(h, 0.4, 0.7)
    local subBg    = hsvToRgb(h, 0.65, 0.8)
    local fill     = hsvToRgb(h, 0.6, 0.9)
    local particle = hsvToRgb(h + 0.1, 0.5, 1.0)
    local fog      = hsvToRgb(h + 0.05, 0.6, 0.7)

    return {
        name = "RAINBOW",
        border = border,
        glow = glow,
        accent = accent,
        accentDim = accentD,
        bg = Color3.fromRGB(12, 5, 22),
        bgLight = Color3.fromRGB(22, 10, 40),
        subtitleBg = subBg,
        subtitleTxt = Color3.fromRGB(255, 250, 255),
        onColor = Color3.fromRGB(80, 255, 144),
        offColor = Color3.fromRGB(255, 64, 112),
        sliderFill = fill,
        sliderTrack = Color3.fromRGB(35, 15, 45),
        particle = particle,
        fog = fog,
        sectionColor = hsvToRgb(h + 0.15, 0.5, 0.65),
        inputBg = Color3.fromRGB(25, 12, 30),
        inputBorder = hsvToRgb(h, 0.5, 0.55),
    }
end

local DEFAULT_STATE = {
    colorIdx = 1, sounds = true, particles = true,
    scanlines = true, glitchTitle = true, opacity = 80,
}

------------------------------------------------------------------------
--  ✨ RIPPLE CLICK EFFECT
------------------------------------------------------------------------
local function createRipple(parent, posX, posY)
    if not State.particles then return end
    local c = ct()
    
    local ripple = makeFrame(parent, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0, posX, 0, posY),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = c.glow,
        BackgroundTransparency = 0.3,
        ZIndex = 100,
    })
    addCorner(ripple, 200)
    
    quickTween(ripple, 0.6, {
        Size = UDim2.new(0, 120, 0, 120),
        BackgroundTransparency = 1,
    })
    
    task.delay(0.65, function() ripple:Destroy() end)
end

------------------------------------------------------------------------
--  SCREEN GUI
------------------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "SpookaliciousV4"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = false
gui.DisplayOrder = 999999
gui.Parent = playerGui

------------------------------------------------------------------------
--  UTILITY HELPERS
------------------------------------------------------------------------
local function tween(obj, info, props)
    TS:Create(obj, info, props):Play()
end

local function quickTween(obj, dur, props, style, dir)
    tween(obj, TweenInfo.new(dur, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
end

local function addStroke(parent, color, thick, transp, mode)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.new(1,1,1)
    s.Thickness = thick or 1
    s.Transparency = transp or 0
    s.ApplyStrokeMode = mode or Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function addCorner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = parent
    return c
end

local function addGradient(parent, transpSeq, rot)
    local g = Instance.new("UIGradient")
    if transpSeq then g.Transparency = transpSeq end
    if rot then g.Rotation = rot end
    g.Parent = parent
    return g
end

local function makeLabel(parent, props)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.Code
    l.RichText = true
    l.TextXAlignment = Enum.TextXAlignment.Center
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.BorderSizePixel = 0
    for k, v in pairs(props) do l[k] = v end
    l.Parent = parent
    return l
end

local function makeFrame(parent, props)
    local f = Instance.new("Frame")
    f.BorderSizePixel = 0
    f.BackgroundTransparency = 1
    for k, v in pairs(props) do f[k] = v end
    f.Parent = parent
    return f
end

------------------------------------------------------------------------
--  ✨ ENHANCED SOUND SYSTEM WITH VARIATIONS
------------------------------------------------------------------------
local sounds = {}
local function createSnd(vol, pitch, id)
    local s = Instance.new("Sound")
    s.Volume = vol or 0.2
    s.PlaybackSpeed = pitch or 1
    s.SoundId = id or "rbxassetid://6042053626"
    s.Parent = SoundService
    return s
end

-- Multiple variations for richer audio feedback
sounds.nav    = {createSnd(0.12, 1.4), createSnd(0.12, 1.5), createSnd(0.12, 1.3)}
sounds.select = {createSnd(0.22, 1.0), createSnd(0.22, 1.1)}
sounds.back   = createSnd(0.18, 0.7)
sounds.slider = createSnd(0.08, 1.8)
sounds.open   = createSnd(0.25, 0.5)
sounds.toggle = {createSnd(0.18, 1.2), createSnd(0.18, 1.3)}
sounds.hover  = createSnd(0.05, 2.2)
sounds.success = createSnd(0.14, 1.5)

local function playSound(name)
    if not State.sounds then return end
    local s = sounds[name]
    -- Pick random variation if table
    if type(s) == "table" then
        s = s[math.random(1, #s)]
    end
    if s then 
        s.PlaybackSpeed = s.PlaybackSpeed + (math.random() - 0.5) * 0.1 -- Slight pitch variation
        s:Stop(); s:Play() 
    end
end

------------------------------------------------------------------------
--  ✨ ENHANCED TOAST SYSTEM WITH ICONS & ANIMATIONS
------------------------------------------------------------------------
local toastContainer = makeFrame(gui, {
    Name = "Toasts",
    Size = UDim2.new(0, 280, 1, 0),
    Position = UDim2.new(1, -295, 0, 0),
    ZIndex = 80,
    ClipsDescendants = false,
})

local activeToasts = {}
local MAX_TOASTS = 5
local TOAST_H = 36
local TOAST_GAP = 5
local TOAST_DURATION = 3.0

local function repositionToasts()
    for i, t in ipairs(activeToasts) do
        local targetY = -(i * (TOAST_H + TOAST_GAP)) - 10
        quickTween(t.frame, 0.25, {
            Position = UDim2.new(0, 0, 1, targetY)
        }, Enum.EasingStyle.Back)
    end
end

local function showToast(msg)
    -- Remove oldest if at max
    if #activeToasts >= MAX_TOASTS then
        local oldest = table.remove(activeToasts, 1)
        if oldest and oldest.frame then
            quickTween(oldest.frame, 0.15, { 
                Position = UDim2.new(1, 50, oldest.frame.Position.Y.Scale, oldest.frame.Position.Y.Offset),
                BackgroundTransparency = 1 
            })
            task.delay(0.2, function()
                if oldest.frame then oldest.frame:Destroy() end
            end)
        end
    end

    local c = ct()

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, TOAST_H)
    frame.Position = UDim2.new(1, 40, 1, 0) -- start offscreen
    frame.BackgroundColor3 = c.bg
    frame.BackgroundTransparency = 0.04
    frame.BorderSizePixel = 0
    frame.ZIndex = 82
    frame.ClipsDescendants = true
    frame.Parent = toastContainer
    addCorner(frame, 5)
    local stroke = addStroke(frame, c.border, 1.5, 0.25)
    
    -- Pulsing glow effect on stroke
    task.spawn(function()
        for i = 1, 8 do
            if not frame.Parent then break end
            quickTween(stroke, 0.35, { Transparency = 0.55 })
            task.wait(0.35)
            quickTween(stroke, 0.35, { Transparency = 0.25 })
            task.wait(0.35)
        end
    end)

    -- Icon
    local icon = makeLabel(frame, {
        Size = UDim2.new(0, 22, 1, 0),
        Position = UDim2.new(0, 6, 0, 0),
        TextSize = 16,
        TextColor3 = c.accent,
        Text = "●",
        ZIndex = 84,
    })
    
    -- Animate icon with pulse
    quickTween(icon, 0.3, { TextSize = 18 }, Enum.EasingStyle.Back)
    task.delay(0.3, function()
        if icon.Parent then
            quickTween(icon, 0.2, { TextSize = 16 })
        end
    end)

    -- Left accent bar with expand animation
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 0, 0.7, 0)
    bar.Position = UDim2.new(0, 3, 0.15, 0)
    bar.BackgroundColor3 = c.glow
    bar.BackgroundTransparency = 0.05
    bar.BorderSizePixel = 0
    bar.ZIndex = 83
    bar.Parent = frame
    addCorner(bar, 2)
    
    -- Animate bar expanding
    quickTween(bar, 0.4, {
        Size = UDim2.new(0, 3, 0.7, 0)
    }, Enum.EasingStyle.Back)

    local lbl = makeLabel(frame, {
        Size = UDim2.new(1, -36, 1, 0),
        Position = UDim2.new(0, 30, 0, 0),
        TextSize = 13,
        TextColor3 = c.accent,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = msg,
        ZIndex = 84,
    })
    addStroke(lbl, c.bg, 0.9, 0.35, Enum.ApplyStrokeMode.Contextual)

    local entry = { frame = frame }
    table.insert(activeToasts, entry)
    repositionToasts()

    -- Slide in with spring effect
    quickTween(frame, 0.4, {
        Position = UDim2.new(0, 0, 1, -(#activeToasts * (TOAST_H + TOAST_GAP)) - 10)
    }, Enum.EasingStyle.Back)

    -- Auto remove with slide out
    task.delay(TOAST_DURATION, function()
        quickTween(frame, 0.25, { 
            Position = UDim2.new(1, 40, frame.Position.Y.Scale, frame.Position.Y.Offset),
            BackgroundTransparency = 1 
        })
        quickTween(lbl, 0.25, { TextTransparency = 1 })
        quickTween(bar, 0.25, { BackgroundTransparency = 1 })
        quickTween(icon, 0.25, { TextTransparency = 1 })

        task.delay(0.3, function()
            for i, t in ipairs(activeToasts) do
                if t == entry then
                    table.remove(activeToasts, i)
                    break
                end
            end
            frame:Destroy()
            repositionToasts()
        end)
    end)
end

------------------------------------------------------------------------
--  ✨ ENHANCED HINT LABEL WITH GLOW
------------------------------------------------------------------------
local hintFrame = Instance.new("Frame")
hintFrame.Size = UDim2.new(0, 350, 0, 42)
hintFrame.Position = UDim2.new(1, -365, 0, 14)
hintFrame.BackgroundColor3 = Color3.fromRGB(12, 5, 22)
hintFrame.BackgroundTransparency = 0.08
hintFrame.BorderSizePixel = 0
hintFrame.ZIndex = 70
hintFrame.Parent = gui
addCorner(hintFrame, 6)
local hintStroke = addStroke(hintFrame, ct().border, 1.8, 0.3)

-- ✨ Animated accent bar
local hintBar = Instance.new("Frame")
hintBar.Size = UDim2.new(0, 4, 0.68, 0)
hintBar.Position = UDim2.new(0, 6, 0.16, 0)
hintBar.BackgroundColor3 = ct().glow
hintBar.BackgroundTransparency = 0.03
hintBar.BorderSizePixel = 0
hintBar.ZIndex = 71
hintBar.Parent = hintFrame
addCorner(hintBar, 2)

local hintLabel = makeLabel(hintFrame, {
    Size = UDim2.new(1, -26, 1, 0),
    Position = UDim2.new(0, 18, 0, 0),
    TextSize = 14,
    TextColor3 = ct().accentDim,
    Text = utf8.char(0x1F480) .. ' Press <font color="#d8a0ff">LEFT ALT</font> to summon <font color="#d8a0ff">SPOOKALICIOUS</font> ' .. utf8.char(0x1F480),
    ZIndex = 72,
})
addStroke(hintLabel, Color3.fromRGB(50, 18, 90), 1.2, 0.25, Enum.ApplyStrokeMode.Contextual)

-- ✨ Enhanced multi-layer pulse animation
task.spawn(function()
    while true do
        if hintFrame.Visible then
            -- Text pulse
            tween(hintLabel, TweenInfo.new(2.0, Enum.EasingStyle.Sine), { TextTransparency = 0.35 })
            -- Bar pulse
            tween(hintBar, TweenInfo.new(2.0, Enum.EasingStyle.Sine), { BackgroundTransparency = 0.25 })
            -- Stroke glow
            tween(hintStroke, TweenInfo.new(2.0, Enum.EasingStyle.Sine), { Transparency = 0.5 })
            task.wait(2.0)
            tween(hintLabel, TweenInfo.new(2.0, Enum.EasingStyle.Sine), { TextTransparency = 0 })
            tween(hintBar, TweenInfo.new(2.0, Enum.EasingStyle.Sine), { BackgroundTransparency = 0.03 })
            tween(hintStroke, TweenInfo.new(2.0, Enum.EasingStyle.Sine), { Transparency = 0.3 })
            task.wait(2.0)
        else task.wait(0.5) end
    end
end)

------------------------------------------------------------------------
--  ✨ ENHANCED MAIN PANEL WITH PREMIUM STYLING
------------------------------------------------------------------------
local MENU_W = 360
local MENU_MIN_W, MENU_MAX_W = 280, 520

local mainFrame = Instance.new("Frame")
mainFrame.Name = "Panel"
mainFrame.Size = UDim2.new(0, MENU_W, 0, 450)
mainFrame.Position = UDim2.new(1, -MENU_W - 16, 0.5, -225)
mainFrame.BackgroundColor3 = ct().bg
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ZIndex = 10
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui
addCorner(mainFrame, 8)

local outerStroke = addStroke(mainFrame, ct().border, 2.5, 0.05)

-- ✨ Secondary outer glow
local outerGlow = addStroke(mainFrame, ct().glow, 4, 0.85)

-- Inner border
local innerBorder = makeFrame(mainFrame, {
    Size = UDim2.new(1, -14, 1, -14),
    Position = UDim2.new(0, 7, 0, 7),
    BackgroundTransparency = 1,
    ZIndex = 11,
})
local innerStroke = addStroke(innerBorder, ct().border, 1.2, 0.65)
addCorner(innerBorder, 6)

-- ✨ Enhanced top glare with gradient
local topGlare = makeFrame(mainFrame, {
    Size = UDim2.new(1, 0, 0, 130),
    BackgroundColor3 = ct().glow,
    BackgroundTransparency = 0.89,
    ZIndex = 13,
})
addGradient(topGlare, NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(0.6, 0.3),
    NumberSequenceKeypoint.new(1, 1),
}), 90)

-- ✨ Enhanced bottom vignette
local botVig = makeFrame(mainFrame, {
    Size = UDim2.new(1, 0, 0, 80),
    Position = UDim2.new(0, 0, 1, -80),
    BackgroundColor3 = Color3.new(0,0,0),
    BackgroundTransparency = 0.88,
    ZIndex = 13,
})
addGradient(botVig, NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0.4),
    NumberSequenceKeypoint.new(1, 0),
}), 90)

-- ✨ Larger fog blobs with better positioning
local fogA = makeFrame(mainFrame, {
    Size = UDim2.new(0.7, 0, 0.7, 0),
    Position = UDim2.new(0.06, 0, 0.06, 0),
    BackgroundColor3 = ct().fog,
    BackgroundTransparency = 0.92,
    ZIndex = 14,
})
addCorner(fogA, 100)

local fogB = makeFrame(mainFrame, {
    Size = UDim2.new(0.6, 0, 0.6, 0),
    Position = UDim2.new(0.35, 0, 0.45, 0),
    BackgroundColor3 = ct().fog,
    BackgroundTransparency = 0.93,
    ZIndex = 14,
})
addCorner(fogB, 100)

-- Scanlines
local scanlineOverlay = makeFrame(mainFrame, {
    Name = "Scanlines",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Color3.new(0,0,0),
    BackgroundTransparency = 0.955,
    ZIndex = 46,
})

------------------------------------------------------------------------
--  ✨ ENHANCED TITLE AREA WITH PREMIUM STYLING
------------------------------------------------------------------------
local titleRegion = makeFrame(mainFrame, {
    Name = "TitleRegion",
    Size = UDim2.new(1, 0, 0, 58),
    Position = UDim2.new(0, 0, 0, 5),
    ZIndex = 20,
})

local titleLabel = makeLabel(titleRegion, {
    Name = "Title",
    Size = UDim2.new(1, 0, 0, 35),
    Position = UDim2.new(0, 0, 0, 0),
    TextSize = 26,
    TextColor3 = ct().accent,
    Text = utf8.char(0x1F480) .. " SPOOKALICIOUS " .. utf8.char(0x1F480),
    ZIndex = 22,
})
local titleTextStroke = addStroke(titleLabel, ct().glow, 2.0, 0.2, Enum.ApplyStrokeMode.Contextual)

-- ✨ Enhanced glitch clones with better visibility
local glitchRed = makeLabel(titleRegion, {
    Name = "GR", Size = UDim2.new(1,0,0,35), Position = UDim2.new(0,0,0,0),
    TextSize = 26, TextColor3 = Color3.fromRGB(255,30,80),
    Text = utf8.char(0x1F480) .. " SPOOKALICIOUS " .. utf8.char(0x1F480), TextTransparency = 1, ZIndex = 21,
})
local glitchGreen = makeLabel(titleRegion, {
    Name = "GG", Size = UDim2.new(1,0,0,35), Position = UDim2.new(0,0,0,0),
    TextSize = 26, TextColor3 = Color3.fromRGB(60,255,140),
    Text = utf8.char(0x1F480) .. " SPOOKALICIOUS " .. utf8.char(0x1F480), TextTransparency = 1, ZIndex = 21,
})

local versionLabel = makeLabel(titleRegion, {
    Size = UDim2.new(1,0,0,18), Position = UDim2.new(0,0,0,35),
    TextSize = 14, TextColor3 = ct().accentDim, Text = "V4 ✨ ENHANCED", ZIndex = 22,
})
addStroke(versionLabel, ct().border, 1.0, 0.45, Enum.ApplyStrokeMode.Contextual)

-- ✨ Enhanced title underline with glow
local titleLine = makeFrame(titleRegion, {
    Size = UDim2.new(0.46, 0, 0, 1.8),
    Position = UDim2.new(0.27, 0, 0, 52),
    BackgroundColor3 = ct().border,
    BackgroundTransparency = 0.35,
    ZIndex = 22,
})
addCorner(titleLine, 1)

-- Drag button on title
local dragBtn = Instance.new("TextButton")
dragBtn.Size = UDim2.new(1, 0, 1, 0)
dragBtn.BackgroundTransparency = 1
dragBtn.Text = ""
dragBtn.ZIndex = 23
dragBtn.Parent = titleRegion

------------------------------------------------------------------------
--  ✨ ENHANCED SUBTITLE BANNER
------------------------------------------------------------------------
local subY = 68

local subtitleBanner = makeFrame(mainFrame, {
    Size = UDim2.new(1, -24, 0, 28),
    Position = UDim2.new(0, 12, 0, subY),
    BackgroundColor3 = ct().subtitleBg,
    BackgroundTransparency = 0.38,
    ZIndex = 20,
})
addCorner(subtitleBanner, 5)
local subtitleStroke = addStroke(subtitleBanner, ct().glow, 1, 0.7)

local subtitleLabel = makeLabel(subtitleBanner, {
    Size = UDim2.new(1, 0, 1, 0),
    TextSize = 14,
    TextColor3 = ct().subtitleTxt,
    Text = utf8.char(0x1F383) .. " MAIN MENU " .. utf8.char(0x1F383),
    ZIndex = 21,
    Font = Enum.Font.Code,
    TextStrokeTransparency = 0.5,
    TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
})
addStroke(subtitleLabel, ct().bg, 1.3, 0.2, Enum.ApplyStrokeMode.Contextual)

-- ✨ Enhanced top separator with gradient
local topSep = makeFrame(mainFrame, {
    Size = UDim2.new(1, -28, 0, 1.5),
    Position = UDim2.new(0, 14, 0, subY + 34),
    BackgroundColor3 = ct().border,
    BackgroundTransparency = 0.4,
    ZIndex = 20,
})
addGradient(topSep, NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.18, 0),
    NumberSequenceKeypoint.new(0.82, 0),
    NumberSequenceKeypoint.new(1, 1),
}))
addCorner(topSep, 1)

------------------------------------------------------------------------
--  ITEMS SCROLLING FRAME
------------------------------------------------------------------------
local itemsY = subY + 40

local itemsFrame = Instance.new("ScrollingFrame")
itemsFrame.Name = "Items"
itemsFrame.Size = UDim2.new(1, -8, 0, 300)
itemsFrame.Position = UDim2.new(0, 4, 0, itemsY)
itemsFrame.BackgroundTransparency = 1
itemsFrame.BorderSizePixel = 0
itemsFrame.ScrollBarThickness = 4
itemsFrame.ScrollBarImageColor3 = ct().border
itemsFrame.ScrollBarImageTransparency = 0.3
itemsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
itemsFrame.ZIndex = 20
itemsFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
itemsFrame.Parent = mainFrame

------------------------------------------------------------------------
--  BOTTOM SEP + FOOTER
------------------------------------------------------------------------
local botSep = makeFrame(mainFrame, {
    Size = UDim2.new(1, -28, 0, 1),
    BackgroundColor3 = ct().border,
    BackgroundTransparency = 0.5,
    ZIndex = 20,
})
addGradient(botSep, NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.2, 0),
    NumberSequenceKeypoint.new(0.8, 0),
    NumberSequenceKeypoint.new(1, 1),
}))

local footerLabel = makeLabel(mainFrame, {
    Name = "Footer",
    Size = UDim2.new(1, -12, 0, 28),
    TextSize = 11,
    TextColor3 = Color3.fromRGB(100, 70, 140),
    ZIndex = 22,
})
addStroke(footerLabel, Color3.fromRGB(35, 12, 60), 0.7, 0.5, Enum.ApplyStrokeMode.Contextual)

------------------------------------------------------------------------
--  RESIZE HANDLE
------------------------------------------------------------------------
local resizeHandle = Instance.new("TextButton")
resizeHandle.Name = "ResizeHandle"
resizeHandle.Size = UDim2.new(0, 22, 0, 22)
resizeHandle.Position = UDim2.new(1, -26, 1, -26)
resizeHandle.BackgroundColor3 = ct().bg
resizeHandle.BackgroundTransparency = 0.3
resizeHandle.Text = ""
resizeHandle.ZIndex = 50
resizeHandle.Parent = mainFrame
addCorner(resizeHandle, 4)
local resizeStroke = addStroke(resizeHandle, ct().border, 1, 0.45)

-- Diagonal grip lines
local resizeIcon = makeLabel(resizeHandle, {
    Size = UDim2.new(1, 0, 1, 0),
    Text = "///",
    TextSize = 10,
    TextColor3 = ct().glow,
    TextTransparency = 0.25,
    ZIndex = 51,
    Rotation = -45,
})
addStroke(resizeIcon, ct().bg, 0.6, 0.5, Enum.ApplyStrokeMode.Contextual)

-- Hover glow
resizeHandle.MouseEnter:Connect(function()
    quickTween(resizeHandle, 0.15, { BackgroundTransparency = 0.1 })
    quickTween(resizeStroke, 0.15, { Transparency = 0.15 })
    quickTween(resizeIcon, 0.15, { TextTransparency = 0 })
end)
resizeHandle.MouseLeave:Connect(function()
    quickTween(resizeHandle, 0.2, { BackgroundTransparency = 0.3 })
    quickTween(resizeStroke, 0.2, { Transparency = 0.45 })
    quickTween(resizeIcon, 0.2, { TextTransparency = 0.25 })
end)

------------------------------------------------------------------------
--  DRAGGING
------------------------------------------------------------------------
do
    local dragging, dragStart, startPos = false, nil, nil
    dragBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = mainFrame.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                State._userDragged = true
                State._lastPos = mainFrame.Position
            end
            dragging = false
        end
    end)
end

------------------------------------------------------------------------
--  RESIZING
------------------------------------------------------------------------
do
    local resizing, resizeStart, startSize = false, nil, nil
    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true; resizeStart = input.Position; startSize = mainFrame.AbsoluteSize
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - resizeStart
            local nw = math.clamp(startSize.X + d.X, MENU_MIN_W, MENU_MAX_W)
            mainFrame.Size = UDim2.new(0, nw, mainFrame.Size.Y.Scale, mainFrame.Size.Y.Offset)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end)
end

------------------------------------------------------------------------
--  ✨ ENHANCED ELEMENT HEIGHT CONSTANTS
------------------------------------------------------------------------
local H_ITEM    = 40
local H_SLIDER  = 60
local H_TEXTBOX = 48
local H_DROP    = 42
local H_KEYBIND = 42
local H_SECTION = 28
local H_PAGE    = 40

------------------------------------------------------------------------
--  ITEM RENDERING
------------------------------------------------------------------------
local itemInstances = {}

local function clearItems()
    for _, v in ipairs(itemInstances) do v:Destroy() end
    itemInstances = {}
end

local function getItemHeight(item)
    if item.type == "slider" then return H_SLIDER
    elseif item.type == "textbox" then return H_TEXTBOX
    elseif item.type == "dropdown" then
        local base = H_DROP
        if item._expanded then
            base = base + (#item.list * 24) + 4
        end
        return base
    elseif item.type == "keybind" then return H_KEYBIND
    elseif item.type == "section_header" then return H_SECTION
    elseif item.type == "page_link" then return H_PAGE
    else return H_ITEM end
end

-- Forward declare
local renderView

local function createItemUI(index, item, yPos)
    local sel = (index == State.sel)
    local c = ct()
    local h = getItemHeight(item)

    local frame = makeFrame(itemsFrame, {
        Size = UDim2.new(1, -6, 0, h),
        Position = UDim2.new(0, 3, 0, yPos),
        BackgroundColor3 = c.border,
        BackgroundTransparency = sel and 0.87 or 1,
        ZIndex = 24,
    })
    addCorner(frame, 3)

    -- Selection highlight + animated bars
    if sel then
        -- Animate background highlight in
        frame.BackgroundTransparency = 1
        quickTween(frame, 0.25, { BackgroundTransparency = 0.87 })

        for _, side in ipairs({"left","right"}) do
            local bar = makeFrame(frame, {
                Size = UDim2.new(0, 2, 0, 0),  -- start collapsed
                Position = side == "left"
                    and UDim2.new(0, 2, 0.5, 0)     -- start centered
                    or UDim2.new(1, -4, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = c.glow,
                BackgroundTransparency = 0.6,
                ZIndex = 26,
            })
            addCorner(bar, 1)

            -- Animate bar expanding + fading in
            quickTween(bar, 0.3, {
                Size = UDim2.new(0, 2, 0.6, 0),
                BackgroundTransparency = 0.05,
            }, Enum.EasingStyle.Back)
        end
    end

    -- ── SECTION HEADER ──
    if item.type == "section_header" then
        local sep1 = makeFrame(frame, {
            Size = UDim2.new(0.2, 0, 0, 1),
            Position = UDim2.new(0, 14, 0.5, 0),
            BackgroundColor3 = c.sectionColor,
            BackgroundTransparency = 0.5,
            ZIndex = 27,
        })
        local sep2 = makeFrame(frame, {
            Size = UDim2.new(0.2, 0, 0, 1),
            Position = UDim2.new(0.8, -14, 0.5, 0),
            BackgroundColor3 = c.sectionColor,
            BackgroundTransparency = 0.5,
            ZIndex = 27,
        })
        makeLabel(frame, {
            Size = UDim2.new(0.6, 0, 1, 0),
            Position = UDim2.new(0.2, 0, 0, 0),
            TextSize = 12,
            TextColor3 = c.sectionColor,
            Text = string.upper(item.label),
            ZIndex = 27,
        })

    -- ── PAGE LINK ──
    elseif item.type == "page_link" then
        local lbl = makeLabel(frame, {
            Size = UDim2.new(1, -14, 1, 0),
            Position = UDim2.new(0, 7, 0, 0),
            TextSize = 16,
            TextColor3 = sel and c.accent or c.accentDim,
            Text = "[ " .. string.upper(item.label) .. "  > ]",
            ZIndex = 27,
        })
        addStroke(lbl, c.bg, 1, sel and 0.2 or 0.5, Enum.ApplyStrokeMode.Contextual)

    -- ── TOGGLE ──
    elseif item.type == "toggle" then
        local on = item.value
        local clr = on and string.format("#%02x%02x%02x", c.onColor.R*255, c.onColor.G*255, c.onColor.B*255)
                        or string.format("#%02x%02x%02x", c.offColor.R*255, c.offColor.G*255, c.offColor.B*255)
        local word = on and "ON" or "OFF"
        local lbl = makeLabel(frame, {
            Size = UDim2.new(1, -14, 1, 0),
            Position = UDim2.new(0, 7, 0, 0),
            TextSize = 16,
            TextColor3 = sel and c.accent or c.accentDim,
            Text = string.format('[ <font color="%s">%s</font>  %s ]', clr, word, string.upper(item.label)),
            ZIndex = 27,
        })
        addStroke(lbl, c.bg, 1, sel and 0.2 or 0.5, Enum.ApplyStrokeMode.Contextual)

    -- ── SLIDER (mouse draggable + A/D) ──
    elseif item.type == "slider" then
        local val = item.value
        local pct = math.clamp((val - item.min) / (item.max - item.min), 0, 1)

        local lbl = makeLabel(frame, {
            Size = UDim2.new(1, 0, 0, 20),
            TextSize = 15,
            TextColor3 = sel and c.accent or c.accentDim,
            Text = string.format('[ %s : <font color="#d8a0ff">%d</font> ]', string.upper(item.label), val),
            ZIndex = 27,
        })
        addStroke(lbl, c.bg, 1, sel and 0.25 or 0.55, Enum.ApplyStrokeMode.Contextual)

        -- Track (taller hit area)
        local trackWrap = makeFrame(frame, {
            Size = UDim2.new(1, -34, 0, 18),
            Position = UDim2.new(0, 17, 0, 20),
            BackgroundTransparency = 1,
            ZIndex = 27,
        })

        local track = makeFrame(trackWrap, {
            Size = UDim2.new(1, 0, 0, 6),
            Position = UDim2.new(0, 0, 0.5, -3),
            BackgroundColor3 = c.sliderTrack,
            BackgroundTransparency = 0,
            ZIndex = 27,
        })
        addCorner(track, 3)
        addStroke(track, c.border, 1, 0.7)

        local fill = makeFrame(track, {
            Size = UDim2.new(pct, 0, 1, 0),
            BackgroundColor3 = c.sliderFill,
            BackgroundTransparency = 0,
            ZIndex = 28,
        })
        addCorner(fill, 3)

        -- Thumb dot
        local thumbSize = sel and 14 or 10
        local thumb = makeFrame(trackWrap, {
            Size = UDim2.new(0, thumbSize, 0, thumbSize),
            Position = UDim2.new(pct, -thumbSize/2, 0.5, -thumbSize/2),
            BackgroundColor3 = sel and c.glow or c.sliderFill,
            BackgroundTransparency = 0.05,
            ZIndex = 30,
        })
        addCorner(thumb, thumbSize)
        if sel then
            addStroke(thumb, c.accent, 1, 0.3)
        end

        -- Mouse drag handler
        local dragBtn = Instance.new("TextButton")
        dragBtn.Size = UDim2.new(1, 10, 1, 6)
        dragBtn.Position = UDim2.new(0, -5, 0, -3)
        dragBtn.BackgroundTransparency = 1
        dragBtn.Text = ""
        dragBtn.ZIndex = 33
        dragBtn.Parent = trackWrap

        local sliderDragging = false
        local dragMoveConn, dragEndConn

        local function updateSliderFromMouse(inputX)
            local trackAbsPos = track.AbsolutePosition.X
            local trackAbsSize = track.AbsoluteSize.X
            if trackAbsSize < 1 then return end

            local relX = math.clamp((inputX - trackAbsPos) / trackAbsSize, 0, 1)
            local rawVal = item.min + relX * (item.max - item.min)

            -- Snap to step
            local step = item.step or 1
            local snapped = math.floor((rawVal - item.min) / step + 0.5) * step + item.min
            snapped = math.clamp(snapped, item.min, item.max)

            if snapped ~= item.value then
                item.value = snapped
                playSound("slider")
                if item.callback then item.callback(snapped) end

                -- Update fill and thumb live without full re-render
                local newPct = math.clamp((snapped - item.min) / (item.max - item.min), 0, 1)
                fill.Size = UDim2.new(newPct, 0, 1, 0)
                thumb.Position = UDim2.new(newPct, -thumbSize/2, 0.5, -thumbSize/2)
                lbl.Text = string.format('[ %s : <font color="#d8a0ff">%d</font> ]', string.upper(item.label), snapped)
            end
        end

        dragBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sliderDragging = true
                State.sel = index
                updateSliderFromMouse(input.Position.X)

                dragMoveConn = UIS.InputChanged:Connect(function(moveInput)
                    if sliderDragging and (moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch) then
                        updateSliderFromMouse(moveInput.Position.X)
                    end
                end)

                dragEndConn = UIS.InputEnded:Connect(function(endInput)
                    if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
                        sliderDragging = false
                        if dragMoveConn then dragMoveConn:Disconnect(); dragMoveConn = nil end
                        if dragEndConn then dragEndConn:Disconnect(); dragEndConn = nil end
                        showToast(item.label .. ": " .. item.value)
                        renderView()
                    end
                end)
            end
        end)

        -- A/D hint
        if sel then
            makeLabel(frame, {
                Size = UDim2.new(1, 0, 0, 12),
                Position = UDim2.new(0, 0, 0, 39),
                TextSize = 10,
                TextColor3 = Color3.fromRGB(75, 50, 110),
                Text = 'DRAG or <font color="#ffaa40">A</font> / <font color="#ffaa40">D</font>',
                ZIndex = 27,
            })
        end

    -- ── BUTTON ──
    elseif item.type == "button" then
        local lbl = makeLabel(frame, {
            Size = UDim2.new(1, -14, 1, 0),
            Position = UDim2.new(0, 7, 0, 0),
            TextSize = 16,
            TextColor3 = sel and c.accent or c.accentDim,
            Text = "[ " .. string.upper(item.label) .. " ]",
            ZIndex = 27,
        })
        addStroke(lbl, c.bg, 1, sel and 0.2 or 0.5, Enum.ApplyStrokeMode.Contextual)

    -- ── TEXTBOX ──
    elseif item.type == "textbox" then
        makeLabel(frame, {
            Size = UDim2.new(1, 0, 0, 16),
            Position = UDim2.new(0, 0, 0, 1),
            TextSize = 14,
            TextColor3 = sel and c.accent or c.accentDim,
            Text = string.upper(item.label),
            ZIndex = 27,
        })

        local inputFrame = makeFrame(frame, {
            Size = UDim2.new(1, -30, 0, 18),
            Position = UDim2.new(0, 15, 0, 18),
            BackgroundColor3 = c.inputBg,
            BackgroundTransparency = 0.1,
            ZIndex = 28,
        })
        addCorner(inputFrame, 3)
        addStroke(inputFrame, sel and c.border or c.inputBorder, 1, sel and 0.3 or 0.6)

        local tb = Instance.new("TextBox")
        tb.Size = UDim2.new(1, -10, 1, 0)
        tb.Position = UDim2.new(0, 5, 0, 0)
        tb.BackgroundTransparency = 1
        tb.Font = Enum.Font.Code
        tb.TextSize = 14
        tb.TextColor3 = c.accent
        tb.PlaceholderText = item.placeholder or "Type here..."
        tb.PlaceholderColor3 = c.accentDim
        tb.Text = item.value or ""
        tb.ClearTextOnFocus = false
        tb.ZIndex = 29
        tb.Parent = inputFrame

        tb.FocusLost:Connect(function(enter)
            item.value = tb.Text
            if item.callback then item.callback(tb.Text) end
        end)

    -- ── DROPDOWN ──
    elseif item.type == "dropdown" then
        local current = item.value or item.default or "None"

        local lbl = makeLabel(frame, {
            Size = UDim2.new(1, -14, 0, H_DROP),
            Position = UDim2.new(0, 7, 0, 0),
            TextSize = 15,
            TextColor3 = sel and c.accent or c.accentDim,
            Text = string.format('[ %s : <font color="#d8a0ff">%s</font> ]', string.upper(item.label), current),
            ZIndex = 27,
        })
        addStroke(lbl, c.bg, 1, sel and 0.2 or 0.5, Enum.ApplyStrokeMode.Contextual)

        if item._expanded then
            for oi, opt in ipairs(item.list) do
                local optSel = (opt == current)
                local optFrame = makeFrame(frame, {
                    Size = UDim2.new(1, -20, 0, 22),
                    Position = UDim2.new(0, 10, 0, H_DROP + (oi - 1) * 24),
                    BackgroundColor3 = optSel and c.border or c.inputBg,
                    BackgroundTransparency = optSel and 0.7 or 0.2,
                    ZIndex = 28,
                })
                addCorner(optFrame, 2)

                local optLbl = makeLabel(optFrame, {
                    Size = UDim2.new(1, -10, 1, 0),
                    Position = UDim2.new(0, 5, 0, 0),
                    TextSize = 13,
                    TextColor3 = optSel and c.accent or c.accentDim,
                    Text = opt,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 29,
                })

                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 1, 0)
                optBtn.BackgroundTransparency = 1
                optBtn.Text = ""
                optBtn.ZIndex = 30
                optBtn.Parent = optFrame
                optBtn.MouseButton1Click:Connect(function()
                    item.value = opt
                    item._expanded = false
                    if item.callback then item.callback(opt) end
                    showToast(item.label .. ": " .. opt)
                    renderView()
                end)
            end
        end

    -- ── KEYBIND ──
    elseif item.type == "keybind" then
        local keyName = item.value and item.value.Name or "None"
        if item._listening then keyName = "..." end

        local lbl = makeLabel(frame, {
            Size = UDim2.new(1, -14, 1, 0),
            Position = UDim2.new(0, 7, 0, 0),
            TextSize = 15,
            TextColor3 = sel and c.accent or c.accentDim,
            Text = string.format('[ %s : <font color="#ffaa40">%s</font> ]', string.upper(item.label), keyName),
            ZIndex = 27,
        })
        addStroke(lbl, c.bg, 1, sel and 0.2 or 0.5, Enum.ApplyStrokeMode.Contextual)
    end

    -- Click zone
    if item.type ~= "textbox" then
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, math.min(h, H_DROP))
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.ZIndex = 32
        btn.Parent = frame
        btn.MouseButton1Click:Connect(function()
            State.sel = index
            -- ✨ Add ripple effect on click
            local mousePos = UIS:GetMouseLocation()
            local framePos = frame.AbsolutePosition
            createRipple(frame, mousePos.X - framePos.X, mousePos.Y - framePos.Y)
            doSelect()
        end)
        btn.MouseEnter:Connect(function()
            playSound("hover") -- ✨ Add hover sound
            if State.sel ~= index then
                State.sel = index
                renderView()
            end
        end)
    end

    table.insert(itemInstances, frame)
end

------------------------------------------------------------------------
--  BUILD FLAT ITEM LIST
------------------------------------------------------------------------
local function buildFlatItems()
    State.flatItems = {}

    if State.currentView == "home" then
        -- Show page links + settings
        for _, pageId in ipairs(State.pageOrder) do
            local pg = State.pages[pageId]
            table.insert(State.flatItems, {
                type = "page_link",
                label = pg.name,
                pageId = pageId,
            })
        end
        -- Built-in settings as a page link
        table.insert(State.flatItems, {
            type = "page_link",
            label = "Settings",
            pageId = "__settings__",
        })
    elseif State.currentView == "__settings__" then
        -- Show settings page
        table.insert(State.flatItems, { type = "section_header", label = "Menu Settings" })
        table.insert(State.flatItems, { type = "button", label = "Menu Color", callback = function()
            State.colorIdx = (State.colorIdx % #THEMES) + 1
            showToast("Theme: " .. ct().name)
        end })
        table.insert(State.flatItems, { type = "toggle", label = "Menu Sounds", value = State.sounds, callback = function(v) State.sounds = v end })
        table.insert(State.flatItems, { type = "slider", label = "Menu Opacity", value = State.opacity, min = 10, max = 98, step = 2, callback = function(v) State.opacity = v end })
        table.insert(State.flatItems, { type = "toggle", label = "Particles", value = State.particles, callback = function(v) State.particles = v end })
        table.insert(State.flatItems, { type = "toggle", label = "Scanlines", value = State.scanlines, callback = function(v) State.scanlines = v end })
        table.insert(State.flatItems, { type = "toggle", label = "Glitch Title", value = State.glitchTitle, callback = function(v) State.glitchTitle = v end })
    else
        -- Show page contents
        local pg = State.pages[State.currentView]
        if pg then
            for _, sec in ipairs(pg.sections) do
                table.insert(State.flatItems, { type = "section_header", label = sec.name })
                for _, el in ipairs(sec.elements) do
                    table.insert(State.flatItems, el)
                end
            end
        end
    end
end

------------------------------------------------------------------------
--  RENDER VIEW
------------------------------------------------------------------------
function renderView()
    clearItems()
    buildFlatItems()

    local items = State.flatItems
    if #items == 0 then return end

    State.sel = math.clamp(State.sel, 1, #items)

    -- Skip section headers
    while items[State.sel] and items[State.sel].type == "section_header" do
        State.sel = State.sel + 1
        if State.sel > #items then State.sel = 1 end
    end

    local c = ct()

    -- Subtitle
    if State.currentView == "home" then
        subtitleLabel.Text = utf8.char(0x1F383) .. " MAIN MENU " .. utf8.char(0x1F383)
    elseif State.currentView == "__settings__" then
        subtitleLabel.Text = utf8.char(0x1F383) .. " SETTINGS " .. utf8.char(0x1F383)
    else
        local pg = State.pages[State.currentView]
        subtitleLabel.Text = pg and (utf8.char(0x1F383) .. " " .. string.upper(pg.name) .. " " .. utf8.char(0x1F383)) or "---"
    end

    -- Footer
    local bk = #State.stack > 0 and "BACK" or "CLOSE"
    footerLabel.Text = string.format(
        '<font color="#50ff90">ALT</font> TOGGLE   '..
        '<font color="#ffaa40">W/S</font> SCROLL   '..
        '<font color="#ffaa40">A/D</font> ADJUST   '..
        '<font color="#d8a0ff">F/SPACE</font> SELECT   '..
        '<font color="#ff4070">X</font> %s', bk
    )

    -- Render items with ✨ staggered animation
    local totalH = 0
    for i, item in ipairs(items) do
        local h = getItemHeight(item)
        createItemUI(i, item, totalH)
        totalH = totalH + h
    end

    itemsFrame.CanvasSize = UDim2.new(0, 0, 0, totalH)

    -- Auto-scroll
    local selY = 0
    for i = 1, State.sel - 1 do selY = selY + getItemHeight(items[i]) end
    local viewH = itemsFrame.AbsoluteSize.Y
    if selY < itemsFrame.CanvasPosition.Y then
        itemsFrame.CanvasPosition = Vector2.new(0, selY)
    elseif selY + H_ITEM > itemsFrame.CanvasPosition.Y + viewH then
        itemsFrame.CanvasPosition = Vector2.new(0, selY + H_ITEM - viewH)
    end

    -- Resize frame
    local itemsH = math.min(totalH, 340)
    itemsFrame.Size = UDim2.new(1, -8, 0, itemsH)
    local totalFrameH = itemsY + itemsH + 8 + 32 + 12
    mainFrame.Size = UDim2.new(0, mainFrame.Size.X.Offset, 0, totalFrameH)

    botSep.Position = UDim2.new(0, 14, 0, itemsY + itemsH + 4)
    footerLabel.Position = UDim2.new(0, 6, 0, itemsY + itemsH + 8)

    -- Theme colors
    outerStroke.Color = c.border
    if outerGlow then outerGlow.Color = c.glow end
    innerStroke.Color = c.border
    topGlare.BackgroundColor3 = c.glow
    fogA.BackgroundColor3 = c.fog
    fogB.BackgroundColor3 = c.fog
    titleLabel.TextColor3 = c.accent
    titleTextStroke.Color = c.glow
    versionLabel.TextColor3 = c.accentDim
    titleLine.BackgroundColor3 = c.border
    subtitleBanner.BackgroundColor3 = c.subtitleBg
    if subtitleStroke then subtitleStroke.Color = c.glow end
    subtitleLabel.TextColor3 = c.subtitleTxt
    topSep.BackgroundColor3 = c.border
    botSep.BackgroundColor3 = c.border
    itemsFrame.ScrollBarImageColor3 = c.border
    hintStroke.Color = c.border
    hintBar.BackgroundColor3 = c.glow
    mainFrame.BackgroundColor3 = c.bg
    scanlineOverlay.Visible = State.scanlines
    resizeStroke.Color = c.border
    resizeIcon.TextColor3 = c.glow
    resizeHandle.BackgroundColor3 = c.bg

    mainFrame.BackgroundTransparency = 1 - (State.opacity / 100)
end

-- ✨ Make renderView globally accessible for addons
_G.SpookyRenderView = renderView

------------------------------------------------------------------------
--  NAVIGATION LOGIC
------------------------------------------------------------------------
function doSelect()
    local item = State.flatItems[State.sel]
    if not item then return end

    if item.type == "page_link" then
        playSound("select")
        table.insert(State.stack, State.currentView)
        State.currentView = item.pageId
        State.sel = 1
        renderView()

    elseif item.type == "toggle" then
        playSound("toggle")
        item.value = not item.value
        showToast(item.label .. ": " .. (item.value and "ON" or "OFF"))
        if item.callback then item.callback(item.value) end
        renderView()

    elseif item.type == "button" then
        playSound("select")
        if item.callback then item.callback() end
        showToast(item.label .. " executed")
        renderView()

    elseif item.type == "dropdown" then
        playSound("select")
        item._expanded = not item._expanded
        renderView()

    elseif item.type == "keybind" then
        playSound("select")
        item._listening = true
        showToast("Press any key...")
        renderView()

        -- Wait for next key press
        local conn
        conn = UIS.InputBegan:Connect(function(input, gp)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.Escape then
                    item.value = nil
                    showToast(item.label .. ": Unbound")
                else
                    item.value = input.KeyCode
                    showToast(item.label .. ": " .. input.KeyCode.Name)
                end
                item._listening = false
                if item.callback then item.callback(item.value) end
                conn:Disconnect()
                renderView()
            end
        end)

    elseif item.type == "slider" then
        -- F does nothing on sliders, use A/D
    end
end

function doGoBack()
    playSound("back")
    if #State.stack > 0 then
        State.currentView = table.remove(State.stack)
        State.sel = 1
        renderView()
    else
        toggleMenu(false)
    end
end

function doSliderAdjust(dir)
    local item = State.flatItems[State.sel]
    if not item then return end

    if item.type == "slider" then
        playSound("slider")
        local nv = math.clamp(item.value + dir * (item.step or 1), item.min, item.max)
        if nv ~= item.value then
            item.value = nv
            showToast(item.label .. ": " .. nv)
            if item.callback then item.callback(nv) end
            renderView()
        end
    elseif item.type == "dropdown" and not item._expanded then
        -- Cycle through dropdown with A/D
        playSound("nav")
        local idx = 1
        for i, v in ipairs(item.list) do
            if v == item.value then idx = i; break end
        end
        idx = idx + dir
        if idx < 1 then idx = #item.list
        elseif idx > #item.list then idx = 1 end
        item.value = item.list[idx]
        showToast(item.label .. ": " .. item.value)
        if item.callback then item.callback(item.value) end
        renderView()
    end
end

------------------------------------------------------------------------
--  OPEN / CLOSE
------------------------------------------------------------------------
function toggleMenu(show)
    State.visible = show
    if show then
        State.currentView = "home"
        State.sel = 1
        State.stack = {}
        renderView()

        mainFrame.Visible = true
        hintFrame.Visible = false

        -- Calculate proper right-side position
        local menuW = mainFrame.Size.X.Offset
        local menuH = mainFrame.Size.Y.Offset
        local screenW = gui.AbsoluteSize.X

        -- If menu was dragged somewhere, keep that position; otherwise default to right side
        local targetPos
        if State._userDragged then
            targetPos = State._lastPos
        else
            targetPos = UDim2.new(1, -menuW - 16, 0.5, -menuH / 2)
        end

        -- Start offscreen right, slide in
        mainFrame.Position = UDim2.new(1, 20, targetPos.Y.Scale, targetPos.Y.Offset)

        -- ✨ Enhanced opening animation with subtle shake
        tween(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = targetPos,
            BackgroundTransparency = 1 - (State.opacity / 100),
        })
        
        -- ✨ Subtle screen shake effect
        task.spawn(function()
            task.wait(0.35)
            for i = 1, 3 do
                mainFrame.Position = UDim2.new(
                    targetPos.X.Scale, 
                    targetPos.X.Offset + (math.random() - 0.5) * 4,
                    targetPos.Y.Scale,
                    targetPos.Y.Offset + (math.random() - 0.5) * 4
                )
                task.wait(0.02)
            end
            mainFrame.Position = targetPos
        end)

        playSound("open")
        bindKeys()
    else
        hintFrame.Visible = true
        State._lastPos = mainFrame.Position

        tween(mainFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 20, mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset),
            BackgroundTransparency = 1,
        })

        task.delay(0.24, function() mainFrame.Visible = false end)
        unbindKeys()
    end
end

------------------------------------------------------------------------
--  INPUT SINKING
------------------------------------------------------------------------
local SINK = "SpookaliciousV4Sink"
local BLOCKED = {
    Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D,
    Enum.KeyCode.F, Enum.KeyCode.E, Enum.KeyCode.R, Enum.KeyCode.Q,
    Enum.KeyCode.X, Enum.KeyCode.Z, Enum.KeyCode.C, Enum.KeyCode.V,
    Enum.KeyCode.G, Enum.KeyCode.T, Enum.KeyCode.B, Enum.KeyCode.Y,
    Enum.KeyCode.Space, Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift,
    Enum.KeyCode.LeftControl, Enum.KeyCode.Tab, Enum.KeyCode.Return,
    Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.KeyCode.Left, Enum.KeyCode.Right,
    Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three,
    Enum.KeyCode.Four, Enum.KeyCode.Five, Enum.KeyCode.Six,
    Enum.KeyCode.Seven, Enum.KeyCode.Eight, Enum.KeyCode.Nine, Enum.KeyCode.Zero,
    Enum.KeyCode.Escape,
}

local heldKeys = {}
local REPEAT_DELAY = 0.32
local REPEAT_RATE = 0.055

function bindKeys()
    CAS:BindAction(SINK, function(_, inputState, inputObj)
        local k = inputObj.KeyCode
        if inputState == Enum.UserInputState.Begin then
            heldKeys[k] = tick()

            local items = State.flatItems
            local count = #items

            if k == Enum.KeyCode.W or k == Enum.KeyCode.Up then
                playSound("nav")
                State.sel = State.sel - 1
                if State.sel < 1 then State.sel = count end
                -- Skip section headers
                while items[State.sel] and items[State.sel].type == "section_header" do
                    State.sel = State.sel - 1
                    if State.sel < 1 then State.sel = count end
                end
                renderView()
            elseif k == Enum.KeyCode.S or k == Enum.KeyCode.Down then
                playSound("nav")
                State.sel = State.sel + 1
                if State.sel > count then State.sel = 1 end
                while items[State.sel] and items[State.sel].type == "section_header" do
                    State.sel = State.sel + 1
                    if State.sel > count then State.sel = 1 end
                end
                renderView()
            elseif k == Enum.KeyCode.A or k == Enum.KeyCode.Left then
                doSliderAdjust(-1)
            elseif k == Enum.KeyCode.D or k == Enum.KeyCode.Right then
                doSliderAdjust(1)
            elseif k == Enum.KeyCode.F or k == Enum.KeyCode.Space then
                doSelect()
            elseif k == Enum.KeyCode.X or k == Enum.KeyCode.Escape then
                doGoBack()
            end
        elseif inputState == Enum.UserInputState.End then
            heldKeys[k] = nil
        end
        return Enum.ContextActionResult.Sink
    end, false, unpack(BLOCKED))
end

function unbindKeys()
    CAS:UnbindAction(SINK)
    heldKeys = {}
end

-- Held key repeat for sliders
task.spawn(function()
    while true do
        task.wait(REPEAT_RATE)
        if not State.visible then continue end
        local now = tick()
        for k, t in pairs(heldKeys) do
            if now - t > REPEAT_DELAY then
                if k == Enum.KeyCode.A or k == Enum.KeyCode.Left then doSliderAdjust(-1)
                elseif k == Enum.KeyCode.D or k == Enum.KeyCode.Right then doSliderAdjust(1) end
            end
        end
    end
end)

-- [ key always active
UIS.InputBegan:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.LeftAlt and gui.Parent then
        toggleMenu(not State.visible)
    end
end)

------------------------------------------------------------------------
--  ✨ ULTRA ENHANCED VISUAL EFFECTS LOOP
------------------------------------------------------------------------
local phase = 0

RS.Heartbeat:Connect(function(dt)
    phase = phase + dt
    rainbowHue = (rainbowHue + dt * 0.08) % 1

    if not State.visible then return end
    local c = ct()

    -- Rainbow: update colors every frame
    if THEMES[State.colorIdx].name == "RAINBOW" then
        outerStroke.Color = c.border
        if outerGlow then outerGlow.Color = c.glow end
        innerStroke.Color = c.border
        topGlare.BackgroundColor3 = c.glow
        fogA.BackgroundColor3 = c.fog
        fogB.BackgroundColor3 = c.fog
        titleLabel.TextColor3 = c.accent
        titleTextStroke.Color = c.glow
        versionLabel.TextColor3 = c.accentDim
        titleLine.BackgroundColor3 = c.border
        subtitleBanner.BackgroundColor3 = c.subtitleBg
        if subtitleStroke then subtitleStroke.Color = c.glow end
        topSep.BackgroundColor3 = c.border
        botSep.BackgroundColor3 = c.border
        itemsFrame.ScrollBarImageColor3 = c.border
        resizeStroke.Color = c.border
        resizeIcon.TextColor3 = c.glow
    end

    -- ✨ Enhanced border glow pulse
    outerStroke.Transparency = 0.05 + math.sin(phase * 2.8) * 0.12
    if outerGlow then
        outerGlow.Transparency = 0.82 + math.sin(phase * 3.2) * 0.1
    end

    -- ✨ Enhanced title stroke with faster pulse
    titleTextStroke.Transparency = 0.2 + math.sin(phase * 2.2) * 0.15

    -- ✨ Top glare shimmer with wave effect
    topGlare.BackgroundTransparency = 0.88 + math.sin(phase * 1.3) * 0.02

    -- ✨ Enhanced fog drift with circular motion
    local fogSpeed = 0.35
    fogA.Position = UDim2.new(
        0.06 + math.sin(phase * fogSpeed) * 0.06, 0, 
        0.06 + math.cos(phase * fogSpeed * 0.8) * 0.04, 0
    )
    fogB.Position = UDim2.new(
        0.35 - math.sin(phase * fogSpeed * 0.9) * 0.06, 0, 
        0.45 - math.cos(phase * fogSpeed * 0.7) * 0.04, 0
    )

    -- ✨ Inner border pulse
    innerStroke.Transparency = 0.62 + math.sin(phase * 3.5) * 0.08

    -- ✨ Subtitle banner subtle pulse
    subtitleBanner.BackgroundTransparency = 0.4 + math.sin(phase * 1.8) * 0.04

    -- ✨ Enhanced chromatic glitch with more drama
    if State.glitchTitle then
        if math.random() < 0.015 then
            local ox = (math.random() - 0.5) * 8
            local oy = (math.random() - 0.5) * 4
            glitchRed.Position = UDim2.new(0, ox, 0, 2 + oy)
            glitchRed.TextTransparency = 0.25
            glitchGreen.Position = UDim2.new(0, -ox, 0, 2 - oy)
            glitchGreen.TextTransparency = 0.3

            task.delay(0.04 + math.random() * 0.08, function()
                glitchRed.TextTransparency = 1
                glitchGreen.TextTransparency = 1
            end)
        end

        -- ✨ More frequent heavy glitch bursts
        if math.random() < 0.003 then
            for i = 1, 4 do
                local ox = (math.random() - 0.5) * 12
                glitchRed.Position = UDim2.new(0, ox, 0, 2)
                glitchRed.TextTransparency = 0.15
                glitchGreen.Position = UDim2.new(0, -ox, 0, 2)
                glitchGreen.TextTransparency = 0.2
                task.wait(0.025)
            end
            glitchRed.TextTransparency = 1
            glitchGreen.TextTransparency = 1
        end
    end
    
    -- ✨ Animated title underline
    titleLine.BackgroundTransparency = 0.35 + math.sin(phase * 2.5) * 0.08
end)

-- ✨ Rainbow: refresh items more frequently for smoother transitions
task.spawn(function()
    while true do
        task.wait(0.35)
        if State.visible and THEMES[State.colorIdx].name == "RAINBOW" then
            renderView()
        end
    end
end)

------------------------------------------------------------------------
--  ✨ ENHANCED PARTICLE SYSTEMS
------------------------------------------------------------------------
local particleFolder = Instance.new("Folder")
particleFolder.Name = "Particles"
particleFolder.Parent = gui

-- Bottom particles (floating up) - Enhanced with variety
task.spawn(function()
    while true do
        task.wait(0.12 + math.random() * 0.22)
        if not State.visible or not State.particles then continue end
        local c = ct()
        local ss = gui.AbsoluteSize
        if ss.X < 1 then continue end
        local mp = mainFrame.AbsolutePosition
        local ms = mainFrame.AbsoluteSize

        local size = math.random(2, 6)
        local sx = (mp.X + math.random(0, math.floor(ms.X))) / ss.X
        local sy = (mp.Y + ms.Y + 5) / ss.Y

        local p = makeFrame(particleFolder, {
            Size = UDim2.new(0, size, 0, size),
            Position = UDim2.new(sx, 0, sy, 0),
            BackgroundColor3 = c.particle,
            BackgroundTransparency = 0.12 + math.random() * 0.15,
            ZIndex = 4,
        })
        addCorner(p, math.ceil(size/2))

        local dur = 2.2 + math.random() * 3.2
        quickTween(p, dur, {
            Position = UDim2.new(sx + (math.random()-0.5)*0.09, 0, sy - 0.14 - math.random()*0.14, 0),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 1, 0, 1),
            Rotation = (math.random() - 0.5) * 180, -- ✨ Add rotation
        }, Enum.EasingStyle.Sine)
        task.delay(dur + 0.1, function() p:Destroy() end)
    end
end)

-- Side particles - Enhanced with glow
task.spawn(function()
    while true do
        task.wait(0.25 + math.random() * 0.45)
        if not State.visible or not State.particles then continue end
        local c = ct()
        local ss = gui.AbsoluteSize
        if ss.X < 1 then continue end
        local mp = mainFrame.AbsolutePosition
        local ms = mainFrame.AbsoluteSize

        local side = math.random() > 0.5 and 1 or 0
        local sx = (mp.X + side * ms.X) / ss.X
        local sy = (mp.Y + math.random() * ms.Y) / ss.Y
        local size = math.random(1, 4)

        local p = makeFrame(particleFolder, {
            Size = UDim2.new(0, size, 0, size),
            Position = UDim2.new(sx, 0, sy, 0),
            BackgroundColor3 = c.glow,
            BackgroundTransparency = 0.25,
            ZIndex = 4,
        })
        addCorner(p, size)
        
        -- ✨ Add glow stroke
        local stroke = addStroke(p, c.glow, 1, 0.7)

        local dur = 1.3 + math.random() * 2.2
        local drift = (side == 0 and -1 or 1) * (0.014 + math.random() * 0.028)
        quickTween(p, dur, {
            Position = UDim2.new(sx + drift, 0, sy - 0.018, 0),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 0, 0),
        })
        quickTween(stroke, dur, { Transparency = 1 })
        task.delay(dur + 0.1, function() p:Destroy() end)
    end
end)

-- Internal ambient particles - Enhanced with trails
task.spawn(function()
    while true do
        task.wait(0.35 + math.random() * 0.55)
        if not State.visible or not State.particles then continue end
        local c = ct()

        local size = math.random(1, 4)
        local p = makeFrame(mainFrame, {
            Size = UDim2.new(0, size, 0, size),
            Position = UDim2.new(math.random() * 0.88 + 0.06, 0, 0.96, 0),
            BackgroundColor3 = c.particle,
            BackgroundTransparency = 0.45,
            ZIndex = 47,
        })
        addCorner(p, size)

        local dur = 3.2 + math.random() * 4.2
        quickTween(p, dur, {
            Position = UDim2.new(p.Position.X.Scale + (math.random()-0.5)*0.16, 0, -0.06, 0),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 0, 0),
            Rotation = (math.random() - 0.5) * 360, -- ✨ Add rotation
        }, Enum.EasingStyle.Sine)
        task.delay(dur + 0.1, function() p:Destroy() end)
    end
end)

------------------------------------------------------------------------
--  PUBLIC API
------------------------------------------------------------------------
local Library = {}
Library.__index = Library

-- ✨ Make Library globally accessible for addons
_G.SpookyLibrary = Library

function Library:CreateWindow(title, version)
    local skull = utf8.char(0x1F480)
    local pumpkin = utf8.char(0x1F383)

    State.title = title or "SPOOKALICIOUS"
    State.version = version or "V4"

    titleLabel.Text = skull .. " " .. State.title .. " " .. skull
    glitchRed.Text = skull .. " " .. State.title .. " " .. skull
    glitchGreen.Text = skull .. " " .. State.title .. " " .. skull
    versionLabel.Text = State.version

    hintLabel.Text = string.format(
        '%s Press <font color="#d8a0ff">LEFT ALT</font> to summon <font color="#d8a0ff">%s</font> %s',
        skull, State.title, skull
    )

    local Window = {}
    Window.__index = Window

    function Window:CreatePage(name)
        local pageId = "page_" .. tostring(#State.pageOrder + 1) .. "_" .. name:gsub("%s","_")
        local page = {
            name = name,
            sections = {},
        }
        State.pages[pageId] = page
        table.insert(State.pageOrder, pageId)

        local Page = {}
        Page.__index = Page

        function Page:CreateSection(sectionName)
            local sec = {
                name = sectionName,
                elements = {},
            }
            table.insert(page.sections, sec)

            local Section = {}
            Section.__index = Section

            function Section:CreateToggle(label, options, callback)
                options = options or {}
                local el = {
                    type = "toggle",
                    label = label,
                    value = options.Toggled or options.Default or false,
                    callback = callback,
                }
                table.insert(sec.elements, el)

                -- Return controller
                return {
                    Set = function(_, val)
                        el.value = val
                        if State.visible then renderView() end
                    end,
                    Get = function(_) return el.value end,
                }
            end

            function Section:CreateSlider(label, options, callback)
                options = options or {}
                local el = {
                    type = "slider",
                    label = label,
                    value = options.DefaultValue or options.Default or options.Min or 0,
                    min = options.Min or 0,
                    max = options.Max or 100,
                    step = options.Step or 1,
                    callback = callback,
                }
                table.insert(sec.elements, el)

                return {
                    Set = function(_, val)
                        el.value = math.clamp(val, el.min, el.max)
                        if callback then callback(el.value) end
                        if State.visible then renderView() end
                    end,
                    Get = function(_) return el.value end,
                }
            end

            function Section:CreateButton(label, callback)
                local el = {
                    type = "button",
                    label = label,
                    callback = callback,
                }
                table.insert(sec.elements, el)
                return el
            end

            function Section:CreateTextbox(label, placeholder, callback)
                local el = {
                    type = "textbox",
                    label = label,
                    placeholder = placeholder or "Type here...",
                    value = "",
                    callback = callback,
                }
                table.insert(sec.elements, el)

                return {
                    Set = function(_, val)
                        el.value = val
                        if State.visible then renderView() end
                    end,
                    Get = function(_) return el.value end,
                }
            end

            function Section:CreateDropdown(label, options, callback)
                options = options or {}
                local el = {
                    type = "dropdown",
                    label = label,
                    list = options.List or {},
                    value = options.Default or (options.List and options.List[1]) or "None",
                    callback = callback,
                    _expanded = false,
                }
                table.insert(sec.elements, el)

                return {
                    Set = function(_, val)
                        el.value = val
                        if callback then callback(val) end
                        if State.visible then renderView() end
                    end,
                    Get = function(_) return el.value end,
                    Clear = function(_)
                        el.list = {}
                        el.value = "None"
                        if State.visible then renderView() end
                    end,
                    Add = function(_, newList)
                        if type(newList) == "table" then
                            for _, v in ipairs(newList) do
                                table.insert(el.list, v)
                            end
                            if el.value == "None" and #el.list > 0 then
                                el.value = el.list[1]
                            end
                        end
                        if State.visible then renderView() end
                    end,
                    Refresh = function(_, newList)
                        el.list = newList or {}
                        el.value = #el.list > 0 and el.list[1] or "None"
                        if State.visible then renderView() end
                    end,
                }
            end

            function Section:CreateKeybind(label, options, callback)
                options = options or {}
                local el = {
                    type = "keybind",
                    label = label,
                    value = options.Default or nil,
                    callback = callback,
                    _listening = false,
                }
                table.insert(sec.elements, el)

                -- Keybind listener
                UIS.InputBegan:Connect(function(input, gp)
                    if gp then return end
                    if not State.visible and el.value and input.KeyCode == el.value then
                        if callback then callback(el.value) end
                    end
                end)

                return {
                    Set = function(_, key)
                        el.value = key
                        if State.visible then renderView() end
                    end,
                    Get = function(_) return el.value end,
                }
            end

            return Section
        end

        return Page
    end

    function Window:Toggle()
        toggleMenu(not State.visible)
    end

    function Window:Show()
        toggleMenu(true)
    end

    function Window:Hide()
        toggleMenu(false)
    end

    function Window:Notify(msg)
        showToast(msg)
    end

    function Window:Destroy()
        State.visible = false
        unbindKeys()
        gui:Destroy()
    end

    return Window
end

------------------------------------------------------------------------
--  INIT
------------------------------------------------------------------------
mainFrame.Visible = false
hintFrame.Visible = true
print("[SPOOKALICIOUS V4 ✨ ENHANCED] Library loaded successfully!")
print("✨ NEW FEATURES: Enhanced animations, ripple effects, variety sounds, better particles!")
print("Press LEFT ALT to open.")

return Library
