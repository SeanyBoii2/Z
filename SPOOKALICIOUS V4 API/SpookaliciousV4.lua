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
      LEFT ALT  Open / Close menu
      W / S     Scroll up / down (wraps)
      A / D     Slider adjust / Dropdown cycle
      F/SPACE   Select / Toggle / Activate
      X         Back / Close
      V         Toggle Mouse Mode (free movement + click to select)
      Drag titlebar to move. Drag corner to resize.
--]]

-- Services
local Players       = game:GetService("Players")
local UIS           = game:GetService("UserInputService")
local CAS           = game:GetService("ContextActionService")
local TS            = game:GetService("TweenService")
local RS            = game:GetService("RunService")
local SoundService  = game:GetService("SoundService")
local GuiService    = game:GetService("GuiService")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

------------------------------------------------------------------------
--  PLATFORM DETECTION
------------------------------------------------------------------------
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local isTouch = UIS.TouchEnabled

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
    currentView = "home",
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

    -- Mouse mode: V key toggles this. When true, keys pass to game, mouse clicks on GUI only
    mouseMode = false,
}

_G.State = State

local rainbowHue = 0

local function hsvToRgb(h, s, v)
    return Color3.fromHSV(h % 1, s, v)
end

local function ct()
    local base = THEMES[State.colorIdx]
    if base.name ~= "RAINBOW" then return base end

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
    _animateItems = false,
}

------------------------------------------------------------------------
--  RIPPLE CLICK EFFECT (dual-layer: fill + ring)
------------------------------------------------------------------------
local function createRipple(parent, posX, posY)
    if not State.particles then return end
    local c = ct()
    
    -- Inner fill ripple
    local ripple = Instance.new("Frame")
    ripple.BorderSizePixel = 0
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0, posX, 0, posY)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = c.glow
    ripple.BackgroundTransparency = 0.4
    ripple.ZIndex = 100
    ripple.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 200)
    corner.Parent = ripple
    
    TS:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 100, 0, 100),
        BackgroundTransparency = 1,
    }):Play()
    
    -- Outer ring ripple (stroke only)
    local ring = Instance.new("Frame")
    ring.BorderSizePixel = 0
    ring.Size = UDim2.new(0, 6, 0, 6)
    ring.Position = UDim2.new(0, posX, 0, posY)
    ring.AnchorPoint = Vector2.new(0.5, 0.5)
    ring.BackgroundTransparency = 1
    ring.ZIndex = 101
    ring.Parent = parent
    
    local ringCorner = Instance.new("UICorner")
    ringCorner.CornerRadius = UDim.new(0, 200)
    ringCorner.Parent = ring
    
    local ringStroke = addStroke(ring, c.accent, 2, 0.1)
    
    TS:Create(ring, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 140, 0, 140),
    }):Play()
    TS:Create(ringStroke, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 1,
        Thickness = 0.5,
    }):Play()
    
    task.delay(0.7, function()
        ripple:Destroy()
        ring:Destroy()
    end)
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
--  ENHANCED SOUND SYSTEM (unique IDs per action)
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

-- Navigation: soft tick/click sounds
sounds.nav = {
    createSnd(0.10, 1.6, "rbxassetid://6042053626"),
    createSnd(0.10, 1.5, "rbxassetid://6042053626"),
    createSnd(0.10, 1.7, "rbxassetid://6042053626"),
}
-- Select: satisfying confirm pop
sounds.select = {
    createSnd(0.18, 1.1, "rbxassetid://6895079853"),
    createSnd(0.18, 1.0, "rbxassetid://6895079853"),
}
-- Back: low thud
sounds.back = createSnd(0.16, 0.6, "rbxassetid://6042053626")
-- Slider: subtle notch tick
sounds.slider = createSnd(0.06, 2.2, "rbxassetid://6042053626")
-- Open: dramatic whoosh
sounds.open = createSnd(0.22, 0.45, "rbxassetid://6895079853")
-- Close: reverse whoosh
sounds.close = createSnd(0.15, 0.7, "rbxassetid://6042053626")
-- Toggle: snappy switch
sounds.toggle = {
    createSnd(0.15, 1.3, "rbxassetid://6895079853"),
    createSnd(0.15, 1.4, "rbxassetid://6895079853"),
}
-- Hover: barely audible whisper
sounds.hover = createSnd(0.03, 2.5, "rbxassetid://6042053626")
-- Success: bright chime
sounds.success = createSnd(0.12, 1.6, "rbxassetid://6895079853")
-- Page transition: whoosh sweep
sounds.page = createSnd(0.14, 0.9, "rbxassetid://6895079853")
-- Theme change: magical shimmer
sounds.theme = createSnd(0.16, 1.8, "rbxassetid://6895079853")
-- Error: low buzz
sounds.error = createSnd(0.10, 0.4, "rbxassetid://6042053626")
-- Intro: deep boot-up
sounds.intro = createSnd(0.25, 0.3, "rbxassetid://6895079853")
-- Intro chime: bright arrival
sounds.introChime = createSnd(0.20, 1.2, "rbxassetid://6895079853")
-- Whoosh: fast sweep for transitions
sounds.whoosh = createSnd(0.12, 0.55, "rbxassetid://6042053626")
-- Lock: satisfying click for closing/saving state
sounds.lock = createSnd(0.14, 1.8, "rbxassetid://6042053626")
-- Glitch: digital distortion
sounds.glitch = createSnd(0.08, 3.2, "rbxassetid://6042053626")

local basePitches = {}
for name, snd in pairs(sounds) do
    if type(snd) == "table" then
        basePitches[name] = {}
        for i, s in ipairs(snd) do
            basePitches[name][i] = s.PlaybackSpeed
        end
    else
        basePitches[name] = snd.PlaybackSpeed
    end
end

local function playSound(name)
    if not State.sounds then return end
    local s = sounds[name]
    local bp = basePitches[name]
    if type(s) == "table" then
        local idx = math.random(1, #s)
        s = s[idx]
        bp = bp[idx]
    end
    if s and bp then
        -- Micro pitch variation for organic feel (stays near original)
        s.PlaybackSpeed = bp + (math.random() - 0.5) * 0.08
        s:Stop(); s:Play()
    end
end

------------------------------------------------------------------------
--  TOAST SYSTEM
------------------------------------------------------------------------
local toastContainer = makeFrame(gui, {
    Name = "Toasts",
    Size = UDim2.new(0, 360, 1, 0),
    Position = UDim2.new(1, -375, 0, 0),
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
    frame.Position = UDim2.new(1, 40, 1, 0)
    frame.BackgroundColor3 = c.bg
    frame.BackgroundTransparency = 0.04
    frame.BorderSizePixel = 0
    frame.ZIndex = 82
    frame.ClipsDescendants = true
    frame.Parent = toastContainer
    addCorner(frame, 5)
    local stroke = addStroke(frame, c.border, 1.5, 0.25)
    
    task.spawn(function()
        for i = 1, 8 do
            if not frame.Parent then break end
            quickTween(stroke, 0.35, { Transparency = 0.55 })
            task.wait(0.35)
            quickTween(stroke, 0.35, { Transparency = 0.25 })
            task.wait(0.35)
        end
    end)

    local icon = makeLabel(frame, {
        Size = UDim2.new(0, 22, 1, 0),
        Position = UDim2.new(0, 6, 0, 0),
        TextSize = 16,
        TextColor3 = c.accent,
        Text = "●",
        ZIndex = 84,
    })
    
    quickTween(icon, 0.3, { TextSize = 18 }, Enum.EasingStyle.Back)
    task.delay(0.3, function()
        if icon.Parent then quickTween(icon, 0.2, { TextSize = 16 }) end
    end)

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 0, 0.7, 0)
    bar.Position = UDim2.new(0, 3, 0.15, 0)
    bar.BackgroundColor3 = c.glow
    bar.BackgroundTransparency = 0.05
    bar.BorderSizePixel = 0
    bar.ZIndex = 83
    bar.Parent = frame
    addCorner(bar, 2)
    
    quickTween(bar, 0.4, {
        Size = UDim2.new(0, 3, 0.7, 0)
    }, Enum.EasingStyle.Back)

    local lbl = makeLabel(frame, {
        Size = UDim2.new(1, -36, 1, 0),
        Position = UDim2.new(0, 30, 0, 0),
        TextSize = 12,
        TextColor3 = c.accent,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = msg,
        ZIndex = 84,
        TextTruncate = Enum.TextTruncate.AtEnd,
    })
    addStroke(lbl, c.bg, 0.9, 0.35, Enum.ApplyStrokeMode.Contextual)
    
    -- Timer drain bar at bottom
    local drain = Instance.new("Frame")
    drain.Size = UDim2.new(1, 0, 0, 2)
    drain.Position = UDim2.new(0, 0, 1, -2)
    drain.BackgroundColor3 = c.glow
    drain.BackgroundTransparency = 0.15
    drain.BorderSizePixel = 0
    drain.ZIndex = 85
    drain.Parent = frame
    addCorner(drain, 1)
    
    -- Drain shrinks to 0 over toast duration
    quickTween(drain, TOAST_DURATION, {
        Size = UDim2.new(0, 0, 0, 2),
        BackgroundTransparency = 0.6,
    }, Enum.EasingStyle.Linear)

    local entry = { frame = frame }
    table.insert(activeToasts, entry)
    repositionToasts()

    quickTween(frame, 0.4, {
        Position = UDim2.new(0, 0, 1, -(#activeToasts * (TOAST_H + TOAST_GAP)) - 10)
    }, Enum.EasingStyle.Back)

    task.delay(TOAST_DURATION, function()
        quickTween(frame, 0.25, { 
            Position = UDim2.new(1, 40, frame.Position.Y.Scale, frame.Position.Y.Offset),
            BackgroundTransparency = 1 
        })
        quickTween(lbl, 0.25, { TextTransparency = 1 })
        quickTween(bar, 0.25, { BackgroundTransparency = 1 })
        quickTween(icon, 0.25, { TextTransparency = 1 })
        quickTween(drain, 0.15, { BackgroundTransparency = 1 })

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
--  HINT LABEL
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
    Text = isMobile 
        and (utf8.char(0x1F480) .. ' Tap the <font color="#d8a0ff">skull button</font> to summon <font color="#d8a0ff">SPOOKALICIOUS</font> ' .. utf8.char(0x1F480))
        or (utf8.char(0x1F480) .. ' Press <font color="#d8a0ff">LEFT ALT</font> to summon <font color="#d8a0ff">SPOOKALICIOUS</font> ' .. utf8.char(0x1F480)),
    ZIndex = 72,
})
addStroke(hintLabel, Color3.fromRGB(50, 18, 90), 1.2, 0.25, Enum.ApplyStrokeMode.Contextual)

task.spawn(function()
    while true do
        if hintFrame.Visible then
            tween(hintLabel, TweenInfo.new(2.0, Enum.EasingStyle.Sine), { TextTransparency = 0.35 })
            tween(hintBar, TweenInfo.new(2.0, Enum.EasingStyle.Sine), { BackgroundTransparency = 0.25 })
            tween(hintStroke, TweenInfo.new(2.0, Enum.EasingStyle.Sine), { Transparency = 0.5 })
            task.wait(2.0)
            tween(hintLabel, TweenInfo.new(2.0, Enum.EasingStyle.Sine), { TextTransparency = 0 })
            tween(hintBar, TweenInfo.new(2.0, Enum.EasingStyle.Sine), { BackgroundTransparency = 0.03 })
            tween(hintStroke, TweenInfo.new(2.0, Enum.EasingStyle.Sine), { Transparency = 0.3 })
            task.wait(2.0)
        else task.wait(0.5) end
    end
end)

-- On mobile, hide the hint frame (we use floating button instead)
if isMobile then
    hintFrame.Visible = false
end

------------------------------------------------------------------------
--  MOBILE: FLOATING TOGGLE BUTTON (replaces ALT key on touch devices)
------------------------------------------------------------------------
local mobileToggleBtn, mobileBtnStroke, mobileBtnGlow, mobileBtnLabel

if isTouch then
    mobileToggleBtn = Instance.new("TextButton")
    mobileToggleBtn.Name = "MobileToggle"
    mobileToggleBtn.Size = UDim2.new(0, 50, 0, 50)
    mobileToggleBtn.Position = UDim2.new(0, 14, 0.5, -25)
    mobileToggleBtn.BackgroundColor3 = ct().bg
    mobileToggleBtn.BackgroundTransparency = 0.12
    mobileToggleBtn.Text = ""
    mobileToggleBtn.ZIndex = 200
    mobileToggleBtn.AutoButtonColor = false
    mobileToggleBtn.Parent = gui
    addCorner(mobileToggleBtn, 25)
    mobileBtnStroke = addStroke(mobileToggleBtn, ct().border, 2, 0.15)
    
    -- Outer glow ring
    mobileBtnGlow = addStroke(mobileToggleBtn, ct().glow, 4, 0.8)
    
    -- Skull icon
    mobileBtnLabel = makeLabel(mobileToggleBtn, {
        Size = UDim2.new(1, 0, 1, 0),
        TextSize = 24,
        TextColor3 = ct().accent,
        Text = utf8.char(0x1F480),
        ZIndex = 201,
    })
    
    -- Inner accent ring
    local innerRing = makeFrame(mobileToggleBtn, {
        Size = UDim2.new(1, -6, 1, -6),
        Position = UDim2.new(0, 3, 0, 3),
        BackgroundTransparency = 1,
        ZIndex = 200,
    })
    addCorner(innerRing, 22)
    local innerRingStroke = addStroke(innerRing, ct().border, 1, 0.55)
    
    -- Draggable mobile button
    local mbDragging, mbDragStart, mbStartPos = false, nil, nil
    local mbDragDist = 0
    
    mobileToggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            mbDragging = true
            mbDragStart = input.Position
            mbStartPos = mobileToggleBtn.Position
            mbDragDist = 0
            
            -- Press scale animation
            quickTween(mobileToggleBtn, 0.1, { Size = UDim2.new(0, 44, 0, 44) })
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if mbDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local d = input.Position - mbDragStart
            mbDragDist = d.Magnitude
            mobileToggleBtn.Position = UDim2.new(
                mbStartPos.X.Scale, mbStartPos.X.Offset + d.X,
                mbStartPos.Y.Scale, mbStartPos.Y.Offset + d.Y
            )
        end
    end)
    
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            if mbDragging then
                -- Release scale animation
                quickTween(mobileToggleBtn, 0.2, { Size = UDim2.new(0, 50, 0, 50) }, Enum.EasingStyle.Back)
                
                -- Only toggle if it was a tap (not a drag)
                if mbDragDist < 10 then
                    toggleMenu(not State.visible)
                end
            end
            mbDragging = false
        end
    end)
    
    -- Breathing glow animation for mobile button
    task.spawn(function()
        while true do
            if mobileToggleBtn.Visible then
                quickTween(mobileBtnStroke, 1.5, { Transparency = 0.5 })
                quickTween(mobileBtnGlow, 1.5, { Transparency = 0.5 })
                task.wait(1.5)
                quickTween(mobileBtnStroke, 1.5, { Transparency = 0.15 })
                quickTween(mobileBtnGlow, 1.5, { Transparency = 0.8 })
                task.wait(1.5)
            else
                task.wait(0.5)
            end
        end
    end)
end
------------------------------------------------------------------------
local MENU_W = isMobile and 300 or 360
local MENU_MIN_W, MENU_MAX_W = isMobile and 240 or 280, isMobile and 420 or 520

local mainFrame = Instance.new("Frame")
mainFrame.Name = "Panel"
mainFrame.Size = UDim2.new(0, MENU_W, 0, 450)
mainFrame.Position = UDim2.new(1, -MENU_W - 16, 0, 60)
mainFrame.BackgroundColor3 = ct().bg
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ZIndex = 10
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui
addCorner(mainFrame, 8)

local outerStroke = addStroke(mainFrame, ct().border, 2.5, 0.05)
local outerGlow = addStroke(mainFrame, ct().glow, 4, 0.85)

local innerBorder = makeFrame(mainFrame, {
    Size = UDim2.new(1, -14, 1, -14),
    Position = UDim2.new(0, 7, 0, 7),
    BackgroundTransparency = 1,
    ZIndex = 11,
})
local innerStroke = addStroke(innerBorder, ct().border, 1.2, 0.65)
addCorner(innerBorder, 6)

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

-- ═══════════════════════════════════════════════════════════
--  NEW: CORNER ACCENT BRACKETS (L-shaped marks in corners)
-- ═══════════════════════════════════════════════════════════
local cornerSize = 18
local cornerThick = 2
local corners = {}

for _, corner in ipairs({
    {ax = 0, ay = 0, px = 8, py = 8},       -- top-left
    {ax = 1, ay = 0, px = -8, py = 8},      -- top-right
    {ax = 0, ay = 1, px = 8, py = -8},      -- bottom-left
    {ax = 1, ay = 1, px = -8, py = -8},     -- bottom-right
}) do
    -- Horizontal bar
    local h = makeFrame(mainFrame, {
        Size = UDim2.new(0, cornerSize, 0, cornerThick),
        Position = UDim2.new(corner.ax, corner.px, corner.ay, corner.py),
        AnchorPoint = Vector2.new(corner.ax, corner.ay),
        BackgroundColor3 = ct().glow,
        BackgroundTransparency = 0.3,
        ZIndex = 18,
    })
    addCorner(h, 1)
    table.insert(corners, h)
    
    -- Vertical bar
    local v = makeFrame(mainFrame, {
        Size = UDim2.new(0, cornerThick, 0, cornerSize),
        Position = UDim2.new(corner.ax, corner.px, corner.ay, corner.py),
        AnchorPoint = Vector2.new(corner.ax, corner.ay),
        BackgroundColor3 = ct().glow,
        BackgroundTransparency = 0.3,
        ZIndex = 18,
    })
    addCorner(v, 1)
    table.insert(corners, v)
end

-- ═══════════════════════════════════════════════════════════
--  NEW: TITLE GLOW HALO (soft radial glow behind title)
-- ═══════════════════════════════════════════════════════════
local titleHalo = makeFrame(mainFrame, {
    Size = UDim2.new(0.6, 0, 0, 50),
    Position = UDim2.new(0.2, 0, 0, 12),
    BackgroundColor3 = ct().glow,
    BackgroundTransparency = 0.92,
    ZIndex = 12,
})
addCorner(titleHalo, 25)

-- ═══════════════════════════════════════════════════════════
--  NEW: LIGHT SWEEP (horizontal shimmer that passes across)
-- ═══════════════════════════════════════════════════════════
local lightSweep = makeFrame(mainFrame, {
    Size = UDim2.new(0.15, 0, 1, 0),
    Position = UDim2.new(-0.2, 0, 0, 0),
    BackgroundColor3 = Color3.new(1, 1, 1),
    BackgroundTransparency = 0.96,
    ZIndex = 16,  -- Below content (20+) so it doesn't block clicks
    ClipsDescendants = false,
    Active = false,  -- Don't block mouse input
})
addGradient(lightSweep, NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.4, 0),
    NumberSequenceKeypoint.new(0.6, 0),
    NumberSequenceKeypoint.new(1, 1),
}))

-- ═══════════════════════════════════════════════════════════
--  NEW: THIRD FOG BLOB (adds depth)
-- ═══════════════════════════════════════════════════════════
local fogC = makeFrame(mainFrame, {
    Size = UDim2.new(0.45, 0, 0.45, 0),
    Position = UDim2.new(0.5, 0, 0.25, 0),
    BackgroundColor3 = ct().fog,
    BackgroundTransparency = 0.95,
    ZIndex = 14,
})
addCorner(fogC, 80)

local scanlineOverlay = makeFrame(mainFrame, {
    Name = "Scanlines",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Color3.new(0,0,0),
    BackgroundTransparency = 0.955,
    ZIndex = 17,  -- Below content so it doesn't block clicks
})
scanlineOverlay.Active = false  -- Don't block mouse input

------------------------------------------------------------------------
--  TITLE AREA
------------------------------------------------------------------------
local titleRegion = makeFrame(mainFrame, {
    Name = "TitleRegion",
    Size = UDim2.new(1, 0, 0, 58),
    Position = UDim2.new(0, 0, 0, 5),
    ZIndex = 56,  -- Above overlays for drag to work
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
    TextSize = 14, TextColor3 = ct().accentDim, Text = "V4", ZIndex = 22,
})
addStroke(versionLabel, ct().border, 1.0, 0.45, Enum.ApplyStrokeMode.Contextual)

local titleLine = makeFrame(titleRegion, {
    Size = UDim2.new(0.46, 0, 0, 1.8),
    Position = UDim2.new(0.27, 0, 0, 52),
    BackgroundColor3 = ct().border,
    BackgroundTransparency = 0.35,
    ZIndex = 22,
})
addCorner(titleLine, 1)

local dragBtn = Instance.new("TextButton")
dragBtn.Size = UDim2.new(1, 0, 1, 0)
dragBtn.BackgroundTransparency = 1
dragBtn.Text = ""
dragBtn.ZIndex = 23
dragBtn.Parent = titleRegion

------------------------------------------------------------------------
--  SUBTITLE BANNER
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

-- Pulsing status dot (left of subtitle)
local statusDot = makeFrame(subtitleBanner, {
    Size = UDim2.new(0, 6, 0, 6),
    Position = UDim2.new(0, 8, 0.5, -3),
    BackgroundColor3 = ct().onColor,
    BackgroundTransparency = 0.1,
    ZIndex = 22,
})
addCorner(statusDot, 3)

-- Status dot glow ring
local dotGlow = makeFrame(subtitleBanner, {
    Size = UDim2.new(0, 12, 0, 12),
    Position = UDim2.new(0, 5, 0.5, -6),
    BackgroundColor3 = ct().onColor,
    BackgroundTransparency = 0.75,
    ZIndex = 21,
})
addCorner(dotGlow, 6)

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
itemsFrame.ZIndex = 55  -- MUST be above scanlines(46), lightSweep(45), corners(48) for clicks to work
itemsFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
itemsFrame.Parent = mainFrame

------------------------------------------------------------------------
--  BOTTOM SEP + FOOTER (FIX 1: wider footer, smaller text, shorter labels)
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
    Size = UDim2.new(1, -4, 0, 28),  -- FIX: wider (less padding)
    Position = UDim2.new(0, 2, 0, 0),
    TextSize = 10,                     -- FIX: smaller text to fit
    TextColor3 = Color3.fromRGB(100, 70, 140),
    TextXAlignment = Enum.TextXAlignment.Center,
    ZIndex = 22,
    TextTruncate = Enum.TextTruncate.None,
})
addStroke(footerLabel, Color3.fromRGB(35, 12, 60), 0.7, 0.5, Enum.ApplyStrokeMode.Contextual)

------------------------------------------------------------------------
--  MOUSE MODE INDICATOR (shows when V mouse mode is active)
------------------------------------------------------------------------
local mouseModeIndicator = makeLabel(mainFrame, {
    Name = "MouseModeIndicator",
    Size = UDim2.new(0, 120, 0, 18),
    Position = UDim2.new(0.5, -60, 0, 0),
    TextSize = 11,
    TextColor3 = Color3.fromRGB(80, 255, 144),
    Text = "MOUSE MODE",
    ZIndex = 50,
    Visible = false,
})
addStroke(mouseModeIndicator, Color3.fromRGB(0, 0, 0), 1, 0.3, Enum.ApplyStrokeMode.Contextual)

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
--  ELEMENT HEIGHT CONSTANTS
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
    elseif item.type == "label" then return H_ITEM
    elseif item.type == "divider" then return 12
    else return H_ITEM end
end

-- Non-interactive types that should be skipped during keyboard nav
local function isNonInteractive(itemType)
    return itemType == "section_header" or itemType == "label" or itemType == "divider"
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
    
    -- Staggered slide-in animation (items cascade in from right)
    -- Only plays ONCE per page transition, not on every renderView
    if State._animateItems then
        local delay = math.min(index * 0.025, 0.3)
        frame.Position = UDim2.new(0.15, 3, 0, yPos)
        local origTransp = sel and 0.87 or 1
        frame.BackgroundTransparency = 1
        task.delay(delay, function()
            if not frame.Parent then return end
            quickTween(frame, 0.3, {
                Position = UDim2.new(0, 3, 0, yPos),
                BackgroundTransparency = origTransp,
            }, Enum.EasingStyle.Back)
        end)
    end

    if sel then
        frame.BackgroundTransparency = 1
        quickTween(frame, 0.25, { BackgroundTransparency = 0.87 })

        -- Side accent bars with glow
        for _, side in ipairs({"left","right"}) do
            local bar = makeFrame(frame, {
                Size = UDim2.new(0, 2, 0, 0),
                Position = side == "left"
                    and UDim2.new(0, 2, 0.5, 0)
                    or UDim2.new(1, -4, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = c.glow,
                BackgroundTransparency = 0.6,
                ZIndex = 26,
            })
            addCorner(bar, 1)

            quickTween(bar, 0.3, {
                Size = UDim2.new(0, 2, 0.6, 0),
                BackgroundTransparency = 0.05,
            }, Enum.EasingStyle.Back)
        end
        
        -- Selection glow dot (left indicator)
        local dot = makeFrame(frame, {
            Size = UDim2.new(0, 6, 0, 6),
            Position = UDim2.new(0, -4, 0.5, -3),
            BackgroundColor3 = c.glow,
            BackgroundTransparency = 0.1,
            ZIndex = 27,
        })
        addCorner(dot, 3)
        addStroke(dot, c.glow, 2, 0.6)
        
        -- Dot pop-in animation
        dot.Size = UDim2.new(0, 0, 0, 0)
        dot.Position = UDim2.new(0, -1, 0.5, 0)
        quickTween(dot, 0.3, {
            Size = UDim2.new(0, 6, 0, 6),
            Position = UDim2.new(0, -4, 0.5, -3),
        }, Enum.EasingStyle.Back)
        
        -- Subtle top shimmer highlight
        local shimmer = makeFrame(frame, {
            Size = UDim2.new(1, -8, 0, 1),
            Position = UDim2.new(0, 4, 0, 1),
            BackgroundColor3 = c.accent,
            BackgroundTransparency = 0.75,
            ZIndex = 26,
        })
        addCorner(shimmer, 1)
        addGradient(shimmer, NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.3, 0),
            NumberSequenceKeypoint.new(0.7, 0),
            NumberSequenceKeypoint.new(1, 1),
        }))
    end

    -- SECTION HEADER
    if item.type == "section_header" then
        -- Left gradient line
        local sep1 = makeFrame(frame, {
            Size = UDim2.new(0.25, 0, 0, 1),
            Position = UDim2.new(0, 10, 0.5, 0),
            BackgroundColor3 = c.sectionColor,
            BackgroundTransparency = 0.3,
            ZIndex = 27,
        })
        addGradient(sep1, NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 0),
        }))
        addCorner(sep1, 1)
        
        -- Right gradient line
        local sep2 = makeFrame(frame, {
            Size = UDim2.new(0.25, 0, 0, 1),
            Position = UDim2.new(0.75, -10, 0.5, 0),
            BackgroundColor3 = c.sectionColor,
            BackgroundTransparency = 0.3,
            ZIndex = 27,
        })
        addGradient(sep2, NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 1),
        }))
        addCorner(sep2, 1)
        
        -- Center label with diamond ornaments
        makeLabel(frame, {
            Size = UDim2.new(0.5, 0, 1, 0),
            Position = UDim2.new(0.25, 0, 0, 0),
            TextSize = 11,
            TextColor3 = c.sectionColor,
            Text = "◆ " .. string.upper(item.label) .. " ◆",
            ZIndex = 27,
        })

    elseif item.type == "page_link" then
        local lbl = makeLabel(frame, {
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 12, 0, 0),
            TextSize = 16,
            TextColor3 = sel and c.accent or c.accentDim,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = string.upper(item.label),
            ZIndex = 27,
        })
        addStroke(lbl, c.bg, 1, sel and 0.2 or 0.5, Enum.ApplyStrokeMode.Contextual)
        
        -- Right arrow indicator
        local arrow = makeLabel(frame, {
            Size = UDim2.new(0, 24, 1, 0),
            Position = sel and UDim2.new(1, -30, 0, 0) or UDim2.new(1, -34, 0, 0),
            TextSize = 16,
            TextColor3 = sel and c.glow or c.accentDim,
            Text = "›",
            ZIndex = 27,
        })
        
        -- Arrow slide animation when selected
        if sel then
            arrow.Position = UDim2.new(1, -38, 0, 0)
            quickTween(arrow, 0.25, {
                Position = UDim2.new(1, -28, 0, 0),
            }, Enum.EasingStyle.Back)
        end

    elseif item.type == "toggle" then
        local on = item.value
        local stateColor = on and c.onColor or c.offColor
        
        -- Toggle switch track
        local switchTrack = makeFrame(frame, {
            Size = UDim2.new(0, 28, 0, 14),
            Position = UDim2.new(0, 12, 0.5, -7),
            BackgroundColor3 = on and c.onColor or c.offColor,
            BackgroundTransparency = on and 0.55 or 0.7,
            ZIndex = 28,
        })
        addCorner(switchTrack, 7)
        
        -- Toggle knob
        local knob = makeFrame(switchTrack, {
            Size = UDim2.new(0, 10, 0, 10),
            Position = on and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5),
            BackgroundColor3 = on and c.onColor or Color3.fromRGB(120, 120, 120),
            BackgroundTransparency = 0,
            ZIndex = 29,
        })
        addCorner(knob, 5)
        
        -- Label
        local lbl = makeLabel(frame, {
            Size = UDim2.new(1, -52, 1, 0),
            Position = UDim2.new(0, 46, 0, 0),
            TextSize = 15,
            TextColor3 = sel and c.accent or c.accentDim,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = string.upper(item.label),
            ZIndex = 27,
        })
        addStroke(lbl, c.bg, 1, sel and 0.2 or 0.5, Enum.ApplyStrokeMode.Contextual)

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

        local thumbSize = sel and 14 or 10
        local thumb = makeFrame(trackWrap, {
            Size = UDim2.new(0, thumbSize, 0, thumbSize),
            Position = UDim2.new(pct, -thumbSize/2, 0.5, -thumbSize/2),
            BackgroundColor3 = sel and c.glow or c.sliderFill,
            BackgroundTransparency = 0.05,
            ZIndex = 30,
        })
        addCorner(thumb, thumbSize)
        if sel then addStroke(thumb, c.accent, 1, 0.3) end

        local sliderBtn = Instance.new("TextButton")
        sliderBtn.Size = UDim2.new(1, 10, 1, 6)
        sliderBtn.Position = UDim2.new(0, -5, 0, -3)
        sliderBtn.BackgroundTransparency = 1
        sliderBtn.Text = ""
        sliderBtn.ZIndex = 61
        sliderBtn.Active = true
        sliderBtn.Parent = trackWrap

        local sliderDragging = false
        local dragMoveConn, dragEndConn

        local function updateSliderFromMouse(inputX)
            local trackAbsPos = track.AbsolutePosition.X
            local trackAbsSize = track.AbsoluteSize.X
            if trackAbsSize < 1 then return end

            local relX = math.clamp((inputX - trackAbsPos) / trackAbsSize, 0, 1)
            local rawVal = item.min + relX * (item.max - item.min)

            local step = item.step or 1
            local snapped = math.floor((rawVal - item.min) / step + 0.5) * step + item.min
            snapped = math.clamp(snapped, item.min, item.max)

            if snapped ~= item.value then
                item.value = snapped
                playSound("slider")
                if item.callback then item.callback(snapped) end

                local newPct = math.clamp((snapped - item.min) / (item.max - item.min), 0, 1)
                fill.Size = UDim2.new(newPct, 0, 1, 0)
                thumb.Position = UDim2.new(newPct, -thumbSize/2, 0.5, -thumbSize/2)
                lbl.Text = string.format('[ %s : <font color="#d8a0ff">%d</font> ]', string.upper(item.label), snapped)
            end
        end

        sliderBtn.InputBegan:Connect(function(input)
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

        if sel then
            makeLabel(frame, {
                Size = UDim2.new(1, 0, 0, 12),
                Position = UDim2.new(0, 0, 0, 39),
                TextSize = 10,
                TextColor3 = Color3.fromRGB(75, 50, 110),
                Text = isMobile 
                    and 'DRAG or <font color="#ffaa40">◄</font> / <font color="#ffaa40">►</font>'
                    or 'DRAG or <font color="#ffaa40">A</font> / <font color="#ffaa40">D</font>',
                ZIndex = 27,
            })
        end

    elseif item.type == "button" then
        -- Execute icon
        makeLabel(frame, {
            Size = UDim2.new(0, 20, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            TextSize = 12,
            TextColor3 = sel and c.glow or c.accentDim,
            Text = "▶",
            ZIndex = 27,
        })
        
        local lbl = makeLabel(frame, {
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 30, 0, 0),
            TextSize = 15,
            TextColor3 = sel and c.accent or c.accentDim,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = string.upper(item.label),
            ZIndex = 27,
        })
        addStroke(lbl, c.bg, 1, sel and 0.2 or 0.5, Enum.ApplyStrokeMode.Contextual)

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
        tb.ZIndex = 61
        tb.Parent = inputFrame

        tb.FocusLost:Connect(function(enter)
            item.value = tb.Text
            if item.callback then item.callback(tb.Text) end
        end)

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

                makeLabel(optFrame, {
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
                optBtn.ZIndex = 62
                optBtn.Active = true
                optBtn.Parent = optFrame
                optBtn.Activated:Connect(function()
                    item.value = opt
                    item._expanded = false
                    if item.callback then item.callback(opt) end
                    showToast(item.label .. ": " .. opt)
                    renderView()
                end)
            end
        end

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

    elseif item.type == "label" then
        local lbl = makeLabel(frame, {
            Size = UDim2.new(1, -14, 1, 0),
            Position = UDim2.new(0, 7, 0, 0),
            TextSize = 13,
            TextColor3 = c.accentDim,
            Text = item.label or "",
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 27,
        })
        addStroke(lbl, c.bg, 0.8, 0.5, Enum.ApplyStrokeMode.Contextual)

    elseif item.type == "divider" then
        local line = makeFrame(frame, {
            Size = UDim2.new(1, -24, 0, 1),
            Position = UDim2.new(0, 12, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = c.border,
            BackgroundTransparency = 0.55,
            ZIndex = 27,
        })
        addCorner(line, 1)
    end

    -- Click zone (always works, keyboard mode AND mouse mode)
    if not isNonInteractive(item.type) and item.type ~= "textbox" then
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, math.min(h, H_DROP))
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.ZIndex = 60
        btn.Active = true
        btn.Parent = frame
        
        -- Activated is the ONLY reliable click signal inside ScrollingFrame.
        -- MouseButton1Click and InputBegan both get swallowed by ScrollingFrame
        -- scroll detection. Activated fires after a proper click/tap completes.
        btn.Activated:Connect(function()
            State.sel = index
            doSelect()
        end)
        
        -- MouseButton1Down fires on press (before release) - backup for fast clicks
        btn.MouseButton1Down:Connect(function()
            State.sel = index
        end)
        
        btn.MouseEnter:Connect(function()
            if State.sel ~= index then
                playSound("hover")
                local oldFrame = itemInstances[State.sel]
                if oldFrame and oldFrame.Parent then
                    quickTween(oldFrame, 0.12, { BackgroundTransparency = 1 })
                end
                State.sel = index
                quickTween(frame, 0.12, { BackgroundTransparency = 0.87 })
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
        for _, pageId in ipairs(State.pageOrder) do
            local pg = State.pages[pageId]
            table.insert(State.flatItems, {
                type = "page_link",
                label = pg.name,
                pageId = pageId,
            })
        end
        table.insert(State.flatItems, {
            type = "page_link",
            label = "Settings",
            pageId = "__settings__",
        })
    elseif State.currentView == "__settings__" then
        table.insert(State.flatItems, { type = "section_header", label = "Menu Settings" })
        table.insert(State.flatItems, { type = "button", label = "Menu Color", callback = function()
            State.colorIdx = (State.colorIdx % #THEMES) + 1
            playSound("theme")
            showToast("Theme: " .. ct().name)
        end })
        table.insert(State.flatItems, { type = "toggle", label = "Menu Sounds", value = State.sounds, callback = function(v) State.sounds = v end })
        table.insert(State.flatItems, { type = "slider", label = "Menu Opacity", value = State.opacity, min = 10, max = 98, step = 2, callback = function(v) State.opacity = v end })
        table.insert(State.flatItems, { type = "toggle", label = "Particles", value = State.particles, callback = function(v) State.particles = v end })
        table.insert(State.flatItems, { type = "toggle", label = "Scanlines", value = State.scanlines, callback = function(v) State.scanlines = v end })
        table.insert(State.flatItems, { type = "toggle", label = "Glitch Title", value = State.glitchTitle, callback = function(v) State.glitchTitle = v end })
    else
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

    while items[State.sel] and isNonInteractive(items[State.sel].type) do
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

    -- FIX 1: Footer text (mobile vs desktop)
    local bk = #State.stack > 0 and "BACK" or "CLOSE"
    if isMobile then
        footerLabel.Text = '<font color="#50ff90">TAP</font> items  <font color="#ffaa40">▲▼</font> Nav  <font color="#d8a0ff">✓</font> Select  <font color="#ff4070">✕</font> ' .. bk
    else
        local modeTag = State.mouseMode and ' <font color="#50ff90">V:MOUSE</font>' or ' <font color="#ffaa40">V</font>:Mouse'
        footerLabel.Text = string.format(
            '<font color="#50ff90">ALT</font>Open '..
            '<font color="#ffaa40">W/S</font>Nav '..
            '<font color="#ffaa40">A/D</font>Adj '..
            '<font color="#d8a0ff">F</font>Sel '..
            '<font color="#ff4070">X</font>%s'..
            '%s', bk, modeTag
        )
    end

    -- Mouse mode indicator
    mouseModeIndicator.Visible = State.mouseMode

    -- Render items
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

    -- Resize frame - keep top edge anchored
    local itemsH = math.min(totalH, 340)
    itemsFrame.Size = UDim2.new(1, -8, 0, itemsH)
    local totalFrameH = itemsY + itemsH + 8 + 32 + 12
    
    -- Save current top Y position before resizing
    local currentTopY = mainFrame.AbsolutePosition.Y
    local screenH = gui.AbsoluteSize.Y
    
    mainFrame.Size = UDim2.new(0, mainFrame.Size.X.Offset, 0, totalFrameH)
    
    -- Re-anchor: keep the top edge where it was (convert absolute back to UDim2)
    if screenH > 0 and State.visible then
        local topScale = currentTopY / screenH
        -- Clamp so menu doesn't go off screen at bottom
        local maxTopY = screenH - totalFrameH - 10
        if currentTopY > maxTopY and maxTopY > 0 then
            topScale = maxTopY / screenH
        end
        mainFrame.Position = UDim2.new(
            mainFrame.Position.X.Scale, 
            mainFrame.Position.X.Offset, 
            0, 
            math.max(10, topScale * screenH)
        )
    end

    botSep.Position = UDim2.new(0, 14, 0, itemsY + itemsH + 4)
    footerLabel.Position = UDim2.new(0, 2, 0, itemsY + itemsH + 8)

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
    
    -- New visual elements
    titleHalo.BackgroundColor3 = c.glow
    fogC.BackgroundColor3 = c.fog
    for _, cb in ipairs(corners) do
        cb.BackgroundColor3 = c.glow
    end
    statusDot.BackgroundColor3 = c.onColor
    dotGlow.BackgroundColor3 = c.onColor
    
    -- Mobile action bar theme update
    if isTouch and mobileActionBar then
        mobileActionBar.BackgroundColor3 = c.bg
        for action, info in pairs(mobileNavBtns) do
            if action == "select" then
                info.btn.BackgroundColor3 = c.onColor
                info.stroke.Color = c.onColor
                info.label.TextColor3 = c.onColor
            elseif action == "back" then
                info.btn.BackgroundColor3 = c.offColor
                info.stroke.Color = c.offColor
                info.label.TextColor3 = c.offColor
            else
                info.btn.BackgroundColor3 = c.bgLight
                info.stroke.Color = c.border
                info.label.TextColor3 = c.accent
            end
        end
    end
    if isTouch and mobileToggleBtn then
        mobileBtnStroke.Color = c.border
        mobileBtnGlow.Color = c.glow
        mobileBtnLabel.TextColor3 = c.accent
    end

    mainFrame.BackgroundTransparency = 1 - (State.opacity / 100)
end

_G.SpookyRenderView = renderView

------------------------------------------------------------------------
--  NAVIGATION LOGIC
------------------------------------------------------------------------
function doSelect()
    -- Debounce using tick() (task.delay can be unreliable in some exploit environments)
    local now = tick()
    if State._lastSelectTime and (now - State._lastSelectTime) < 0.15 then return end
    State._lastSelectTime = now
    
    local item = State.flatItems[State.sel]
    if not item then return end

    -- Selection bounce: pulse the selected item frame
    if itemInstances[State.sel] then
        local fr = itemInstances[State.sel]
        local origPos = fr.Position
        quickTween(fr, 0.08, {
            Position = UDim2.new(origPos.X.Scale, origPos.X.Offset + 4, origPos.Y.Scale, origPos.Y.Offset),
        })
        task.delay(0.08, function()
            if fr.Parent then
                quickTween(fr, 0.15, { Position = origPos }, Enum.EasingStyle.Back)
            end
        end)
    end

    if item.type == "page_link" then
        playSound("page")
        playSound("whoosh")
        
        -- Page transition wipe effect
        local wipe = makeFrame(itemsFrame, {
            Size = UDim2.new(0, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = ct().glow,
            BackgroundTransparency = 0.7,
            ZIndex = 58,
        })
        quickTween(wipe, 0.2, {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 0.85,
        }, Enum.EasingStyle.Quad)
        task.delay(0.2, function()
            quickTween(wipe, 0.2, { BackgroundTransparency = 1 })
            task.delay(0.25, function() if wipe.Parent then wipe:Destroy() end end)
        end)
        
        table.insert(State.stack, State.currentView)
        State.currentView = item.pageId
        State.sel = 1
        State._animateItems = true
        renderView()
        State._animateItems = false

    elseif item.type == "toggle" then
        playSound("toggle")
        item.value = not item.value
        showToast(item.label .. ": " .. (item.value and "ON" or "OFF"))
        if item.callback then item.callback(item.value) end
        renderView()
        
        -- Toggle flash on the NEW frame (after renderView)
        if itemInstances[State.sel] then
            local fr = itemInstances[State.sel]
            local flashColor = item.value and ct().onColor or ct().offColor
            local flash = makeFrame(fr, {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = flashColor,
                BackgroundTransparency = 0.5,
                ZIndex = 30,
            })
            addCorner(flash, 3)
            quickTween(flash, 0.35, { BackgroundTransparency = 1 })
            task.delay(0.4, function() if flash.Parent then flash:Destroy() end end)
        end

    elseif item.type == "button" then
        playSound("select")
        if item.callback then item.callback() end
        showToast(item.label .. " executed")
        renderView()
        
        -- Execute pulse on the NEW frame (after renderView)
        if itemInstances[State.sel] then
            local fr = itemInstances[State.sel]
            local pulse = makeFrame(fr, {
                Size = UDim2.new(0, 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundColor3 = ct().glow,
                BackgroundTransparency = 0.5,
                ZIndex = 30,
            })
            addCorner(pulse, 3)
            quickTween(pulse, 0.3, {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
            }, Enum.EasingStyle.Quad)
            task.delay(0.35, function() if pulse.Parent then pulse:Destroy() end end)
        end

    elseif item.type == "dropdown" then
        playSound("select")
        item._expanded = not item._expanded
        renderView()

    elseif item.type == "keybind" then
        playSound("select")
        item._listening = true
        showToast("Press any key...")
        renderView()

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
    end
end

function doGoBack()
    playSound("back")
    if #State.stack > 0 then
        playSound("whoosh")
        -- Reverse wipe effect (from right to left)
        local wipe = makeFrame(itemsFrame, {
            Size = UDim2.new(0, 0, 1, 0),
            Position = UDim2.new(1, 0, 0, 0),
            AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = ct().border,
            BackgroundTransparency = 0.75,
            ZIndex = 58,
        })
        quickTween(wipe, 0.15, {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 0.88,
        })
        task.delay(0.15, function()
            quickTween(wipe, 0.2, { BackgroundTransparency = 1 })
            task.delay(0.25, function() if wipe.Parent then wipe:Destroy() end end)
        end)
        
        State.currentView = table.remove(State.stack)
        State.sel = 1
        State._animateItems = true
        renderView()
        State._animateItems = false
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
--  FIX 3: MOUSE MODE TOGGLE (V KEY)
--  When active: unbinds keyboard sink so you can move freely in game.
--  Menu stays visible and clickable with mouse only.
--  Press V again or ALT to go back to keyboard mode / close.
------------------------------------------------------------------------

-- Cursor management: free the cursor whenever menu is open
-- BUT allow right-click camera rotation by not fighting MouseBehavior when RMB is held
local _savedMouseBehavior = nil
local _savedMouseIcon = nil
local _cursorConn = nil
local _rmbConn1 = nil
local _rmbConn2 = nil
local _rmbHeld = false

local function unlockCursor()
    if not _savedMouseBehavior then
        _savedMouseBehavior = UIS.MouseBehavior
        _savedMouseIcon = UIS.MouseIconEnabled
    end
    UIS.MouseBehavior = Enum.MouseBehavior.Default
    UIS.MouseIconEnabled = true
    
    -- Track right mouse button: let camera rotate when RMB is held
    if _rmbConn1 then _rmbConn1:Disconnect() end
    if _rmbConn2 then _rmbConn2:Disconnect() end
    
    _rmbConn1 = UIS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            _rmbHeld = true
            -- Let the game's camera script take control
        end
    end)
    _rmbConn2 = UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            _rmbHeld = false
            -- Re-assert free cursor after camera rotation ends
            if State.visible then
                UIS.MouseBehavior = Enum.MouseBehavior.Default
                UIS.MouseIconEnabled = true
            end
        end
    end)
    
    -- Only override cursor when RMB is NOT held (allows camera rotation)
    if _cursorConn then _cursorConn:Disconnect() end
    _cursorConn = RS.Heartbeat:Connect(function()
        if State.visible and not _rmbHeld then
            UIS.MouseBehavior = Enum.MouseBehavior.Default
            UIS.MouseIconEnabled = true
        end
    end)
end

local function restoreCursor()
    if _cursorConn then _cursorConn:Disconnect(); _cursorConn = nil end
    if _rmbConn1 then _rmbConn1:Disconnect(); _rmbConn1 = nil end
    if _rmbConn2 then _rmbConn2:Disconnect(); _rmbConn2 = nil end
    _rmbHeld = false
    if _savedMouseBehavior then
        UIS.MouseBehavior = _savedMouseBehavior
        UIS.MouseIconEnabled = _savedMouseIcon
        _savedMouseBehavior = nil
        _savedMouseIcon = nil
    end
end

local function enableMouseMode()
    if State.mouseMode then return end  -- already on
    State.mouseMode = true
    unbindKeys()
    -- Cursor stays unlocked (set by toggleMenu open)
    showToast("Mouse Mode ON - V to exit")
    renderView()
end

local function disableMouseMode()
    if not State.mouseMode then return end  -- already off
    State.mouseMode = false
    if State.visible then
        bindKeys()
    end
    -- Cursor stays unlocked (menu still open)
    showToast("Mouse Mode OFF")
    renderView()
end

------------------------------------------------------------------------
--  OPEN / CLOSE
------------------------------------------------------------------------
local showMobileUI, hideMobileUI  -- forward declarations (defined after bindKeys)

function toggleMenu(show)
    if State._toggling then return end  -- debounce
    State._toggling = true
    task.delay(0.3, function() State._toggling = false end)

    State.visible = show
    
    -- Cancel any pending close
    if State._closeThread then
        task.cancel(State._closeThread)
        State._closeThread = nil
    end
    
    if show then
        -- Restore previous position or start at home (first open)
        if State._savedView and (State._savedView == "home" or State._savedView == "__settings__" or State.pages[State._savedView]) then
            State.currentView = State._savedView
            State.sel = State._savedSel or 1
            State.stack = State._savedStack or {}
        else
            State.currentView = "home"
            State.sel = 1
            State.stack = {}
        end
        State.mouseMode = false
        State._animateItems = true
        renderView()
        State._animateItems = false
        
        -- Clamp selection to valid range
        if State.sel > #State.flatItems then State.sel = math.max(1, #State.flatItems) end
        if State.sel < 1 then State.sel = 1 end
        -- Skip section headers
        while State.flatItems[State.sel] and isNonInteractive(State.flatItems[State.sel].type) do
            State.sel = State.sel + 1
            if State.sel > #State.flatItems then State.sel = 1; break end
        end
        renderView()  -- Re-render with clamped selection

        mainFrame.Visible = true
        if not isMobile then hintFrame.Visible = false end

        -- Always use the canonical width (MENU_W) - never read from mainFrame mid-animation
        local menuW = MENU_W
        local menuH = mainFrame.Size.Y.Offset  -- renderView just set this correctly

        -- Reset size to correct dimensions (in case close animation left it shrunk)
        mainFrame.Size = UDim2.new(0, menuW, 0, menuH)

        local targetPos
        if State._userDragged then
            targetPos = State._lastPos
        else
            if isMobile then
                targetPos = UDim2.new(0.5, -menuW / 2, 0, 30)
            else
                targetPos = UDim2.new(1, -menuW - 16, 0, 60)
            end
        end

        -- Slide in from right (no size animation - avoids compounding shrink)
        mainFrame.Position = UDim2.new(1, 20, targetPos.Y.Scale, targetPos.Y.Offset)
        mainFrame.BackgroundTransparency = 1

        tween(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = targetPos,
            BackgroundTransparency = 1 - (State.opacity / 100),
        })
        
        task.spawn(function()
            task.wait(0.4)
            if not State.visible then return end
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
        unlockCursor()  -- Free the mouse so clicking always works
        
        if isMobile then
            showMobileUI()
        else
            bindKeys()
        end
        
        -- Flash overlay on open (quick white flash then glow fade)
        local flash = makeFrame(mainFrame, {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 0.85,
            ZIndex = 19,
        })
        quickTween(flash, 0.12, { BackgroundTransparency = 0.92 })
        task.delay(0.12, function()
            flash.BackgroundColor3 = ct().glow
            quickTween(flash, 0.4, { BackgroundTransparency = 1 })
            task.delay(0.45, function() if flash.Parent then flash:Destroy() end end)
        end)
        
        -- Border glow pulse on open (bright -> normal)
        if outerGlow then
            outerGlow.Transparency = 0.2
            quickTween(outerGlow, 0.6, { Transparency = 0.55 }, Enum.EasingStyle.Quad)
        end
        outerStroke.Transparency = 0
        quickTween(outerStroke, 0.5, { Transparency = 0.05 })
        
        -- Corner brackets expand on open
        for i, cb in ipairs(corners) do
            local origSize = cb.Size
            cb.Size = UDim2.new(0, 0, 0, 0)
            cb.BackgroundTransparency = 1
            task.delay(0.15 + (i * 0.02), function()
                if not cb.Parent then return end
                quickTween(cb, 0.35, {
                    Size = origSize,
                    BackgroundTransparency = 0.3,
                }, Enum.EasingStyle.Back)
            end)
        end
        
        -- Burst particles from center on open
        task.spawn(function()
            if not State.particles then return end
            local c = ct()
            -- Staggered ring burst
            for i = 1, 16 do
                local angle = (i / 16) * math.pi * 2 + math.random() * 0.3
                local size = math.random(2, 5)
                local p = makeFrame(mainFrame, {
                    Size = UDim2.new(0, size, 0, size),
                    Position = UDim2.new(0.5, 0, 0.35, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = i % 3 == 0 and c.glow or c.particle,
                    BackgroundTransparency = 0.1,
                    ZIndex = 19,
                })
                addCorner(p, size)
                
                local dist = 0.12 + math.random() * 0.22
                quickTween(p, 0.6 + math.random() * 0.5, {
                    Position = UDim2.new(0.5 + math.cos(angle) * dist, 0, 0.35 + math.sin(angle) * dist, 0),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 0),
                }, Enum.EasingStyle.Quad)
                task.delay(1.2, function() if p.Parent then p:Destroy() end end)
            end
            
            -- Small glowing lines radiating outward
            for i = 1, 6 do
                local angle = (i / 6) * math.pi * 2
                local line = makeFrame(mainFrame, {
                    Size = UDim2.new(0, 20, 0, 1),
                    Position = UDim2.new(0.5, 0, 0.35, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Rotation = math.deg(angle),
                    BackgroundColor3 = c.glow,
                    BackgroundTransparency = 0.3,
                    ZIndex = 19,
                })
                quickTween(line, 0.4, {
                    Size = UDim2.new(0, 45, 0, 1),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5 + math.cos(angle) * 0.08, 0, 0.35 + math.sin(angle) * 0.06, 0),
                })
                task.delay(0.45, function() if line.Parent then line:Destroy() end end)
            end
        end)
    else
        if not isMobile then hintFrame.Visible = true end
        State._lastPos = mainFrame.Position
        -- Save current view state for next open
        State._savedView = State.currentView
        State._savedSel = State.sel
        State._savedStack = {unpack(State.stack)}
        State.mouseMode = false
        
        playSound("close")
        restoreCursor()  -- Give mouse back to the game
        
        -- Implosion particles on close
        task.spawn(function()
            if not State.particles then return end
            local c = ct()
            -- Converging particles
            for i = 1, 12 do
                local angle = (i / 12) * math.pi * 2
                local size = math.random(2, 4)
                local startDist = 0.2 + math.random() * 0.15
                local p = makeFrame(mainFrame, {
                    Size = UDim2.new(0, size, 0, size),
                    Position = UDim2.new(0.5 + math.cos(angle) * startDist, 0, 0.5 + math.sin(angle) * startDist, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = i % 2 == 0 and c.glow or c.particle,
                    BackgroundTransparency = 0.15,
                    ZIndex = 19,
                })
                addCorner(p, size)
                quickTween(p, 0.18, {
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 0),
                })
                task.delay(0.2, function() if p.Parent then p:Destroy() end end)
            end
        end)
        
        -- Border drain effect (glow dims from edges)
        if outerGlow then
            quickTween(outerGlow, 0.15, { Transparency = 1 })
        end
        
        -- Corner brackets shrink
        for _, cb in ipairs(corners) do
            quickTween(cb, 0.12, { Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1 })
        end

        -- Slide out to right + fade (NO size change - prevents shrink bug)
        tween(mainFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 20, mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset),
            BackgroundTransparency = 1,
        })

        State._closeThread = task.delay(0.24, function()
            State._closeThread = nil
            mainFrame.Visible = false
        end)
        
        if isMobile then
            hideMobileUI()
        else
            unbindKeys()
        end
    end
end

------------------------------------------------------------------------
--  FIX 2: PROPER INPUT SINKING (keys do NOT pass to game)
--  Uses BindActionAtPriority with max priority so the game never sees
--  our keys. Also handles V key for mouse mode toggle.
------------------------------------------------------------------------
local SINK = "SpookaliciousV4Sink"
local BLOCKED = {
    Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D,
    Enum.KeyCode.F, Enum.KeyCode.E, Enum.KeyCode.R, Enum.KeyCode.Q,
    Enum.KeyCode.X, Enum.KeyCode.Z, Enum.KeyCode.C,
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
    -- FIX 2: Use BindActionAtPriority with very high priority (10000)
    -- This ensures the game NEVER receives these keys while menu is open
    CAS:BindActionAtPriority(SINK, function(_, inputState, inputObj)
        local k = inputObj.KeyCode
        if inputState == Enum.UserInputState.Begin then
            heldKeys[k] = tick()

            local items = State.flatItems
            local count = #items

            if k == Enum.KeyCode.W or k == Enum.KeyCode.Up then
                playSound("nav")
                State.sel = State.sel - 1
                if State.sel < 1 then State.sel = count end
                while items[State.sel] and isNonInteractive(items[State.sel].type) do
                    State.sel = State.sel - 1
                    if State.sel < 1 then State.sel = count end
                end
                renderView()
            elseif k == Enum.KeyCode.S or k == Enum.KeyCode.Down then
                playSound("nav")
                State.sel = State.sel + 1
                if State.sel > count then State.sel = 1 end
                while items[State.sel] and isNonInteractive(items[State.sel].type) do
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
        return Enum.ContextActionResult.Sink  -- ALWAYS sink, never pass to game
    end, false, 10000, unpack(BLOCKED))  -- priority 10000 = max
end

function unbindKeys()
    CAS:UnbindAction(SINK)
    heldKeys = {}
end

-- Held key repeat for sliders
task.spawn(function()
    while true do
        task.wait(REPEAT_RATE)
        if not State.visible or State.mouseMode then continue end
        local now = tick()
        for k, t in pairs(heldKeys) do
            if now - t > REPEAT_DELAY then
                if k == Enum.KeyCode.A or k == Enum.KeyCode.Left then doSliderAdjust(-1)
                elseif k == Enum.KeyCode.D or k == Enum.KeyCode.Right then doSliderAdjust(1) end
            end
        end
    end
end)

------------------------------------------------------------------------
--  MOBILE: TOUCH ACTION BAR (replaces keyboard controls)
------------------------------------------------------------------------
local mobileActionBar, mobileNavBtns

if isTouch then
    mobileActionBar = makeFrame(gui, {
        Name = "MobileActionBar",
        Size = UDim2.new(0, 310, 0, 52),
        Position = UDim2.new(0.5, -155, 1, -66),
        BackgroundColor3 = ct().bg,
        BackgroundTransparency = 0.06,
        ZIndex = 190,
        Visible = false,
    })
    addCorner(mobileActionBar, 12)
    local mabStroke = addStroke(mobileActionBar, ct().border, 1.8, 0.2)
    
    -- Inner glow line at top
    local mabGlow = makeFrame(mobileActionBar, {
        Size = UDim2.new(0.85, 0, 0, 2),
        Position = UDim2.new(0.075, 0, 0, 2),
        BackgroundColor3 = ct().glow,
        BackgroundTransparency = 0.5,
        ZIndex = 191,
    })
    addCorner(mabGlow, 1)
    addGradient(mabGlow, NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.3, 0),
        NumberSequenceKeypoint.new(0.7, 0),
        NumberSequenceKeypoint.new(1, 1),
    }))
    
    mobileNavBtns = {}
    
    local btnDefs = {
        { icon = "▲", action = "up", order = 1 },
        { icon = "▼", action = "down", order = 2 },
        { icon = "◄", action = "left", order = 3 },
        { icon = "►", action = "right", order = 4 },
        { icon = "✓", action = "select", order = 5, accent = true },
        { icon = "✕", action = "back", order = 6, warn = true },
    }
    
    local btnW = 44
    local totalW = #btnDefs * btnW + (#btnDefs - 1) * 6
    local startX = (310 - totalW) / 2
    
    for i, def in ipairs(btnDefs) do
        local btn = Instance.new("TextButton")
        btn.Name = "Nav_" .. def.action
        btn.Size = UDim2.new(0, btnW, 0, 36)
        btn.Position = UDim2.new(0, startX + (i - 1) * (btnW + 6), 0, 8)
        btn.BackgroundColor3 = def.accent and ct().onColor or def.warn and ct().offColor or ct().bgLight
        btn.BackgroundTransparency = def.accent and 0.5 or def.warn and 0.55 or 0.3
        btn.Text = ""
        btn.ZIndex = 192
        btn.AutoButtonColor = false
        btn.Parent = mobileActionBar
        addCorner(btn, 8)
        local btnS = addStroke(btn, def.accent and ct().onColor or def.warn and ct().offColor or ct().border, 1, 0.45)
        
        local btnLbl = makeLabel(btn, {
            Size = UDim2.new(1, 0, 1, 0),
            TextSize = def.accent and 18 or def.warn and 16 or 16,
            TextColor3 = def.accent and ct().onColor or def.warn and ct().offColor or ct().accent,
            Text = def.icon,
            ZIndex = 193,
        })
        
        mobileNavBtns[def.action] = { btn = btn, stroke = btnS, label = btnLbl }
        
        -- Touch feedback with press animation
        btn.MouseButton1Down:Connect(function()
            quickTween(btn, 0.08, {
                Size = UDim2.new(0, btnW - 4, 0, 32),
                Position = UDim2.new(0, startX + (i - 1) * (btnW + 6) + 2, 0, 10),
                BackgroundTransparency = 0.15,
            })
        end)
        
        local function release()
            quickTween(btn, 0.15, {
                Size = UDim2.new(0, btnW, 0, 36),
                Position = UDim2.new(0, startX + (i - 1) * (btnW + 6), 0, 8),
                BackgroundTransparency = def.accent and 0.5 or def.warn and 0.55 or 0.3,
            }, Enum.EasingStyle.Back)
        end
        
        btn.MouseButton1Up:Connect(release)
        btn.MouseLeave:Connect(release)
        
        btn.MouseButton1Click:Connect(function()
            if def.action == "up" then
                playSound("nav")
                local items = State.flatItems
                local count = #items
                State.sel = State.sel - 1
                if State.sel < 1 then State.sel = count end
                while items[State.sel] and isNonInteractive(items[State.sel].type) do
                    State.sel = State.sel - 1
                    if State.sel < 1 then State.sel = count end
                end
                renderView()
            elseif def.action == "down" then
                playSound("nav")
                local items = State.flatItems
                local count = #items
                State.sel = State.sel + 1
                if State.sel > count then State.sel = 1 end
                while items[State.sel] and isNonInteractive(items[State.sel].type) do
                    State.sel = State.sel + 1
                    if State.sel > count then State.sel = 1 end
                end
                renderView()
            elseif def.action == "left" then
                doSliderAdjust(-1)
            elseif def.action == "right" then
                doSliderAdjust(1)
            elseif def.action == "select" then
                doSelect()
            elseif def.action == "back" then
                doGoBack()
            end
        end)
    end
    
    -- Swipe gesture on items frame for scrolling
    local swipeStart, swipeStartY = nil, nil
    itemsFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            swipeStart = tick()
            swipeStartY = input.Position.Y
        end
    end)
    itemsFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and swipeStart then
            local dt = tick() - swipeStart
            local dy = input.Position.Y - (swipeStartY or 0)
            -- Quick flick = nav, not scroll
            if dt < 0.25 and math.abs(dy) > 40 then
                if dy < 0 then
                    -- Swipe up = next item
                    playSound("nav")
                    local items = State.flatItems
                    State.sel = State.sel + 1
                    if State.sel > #items then State.sel = 1 end
                    while items[State.sel] and isNonInteractive(items[State.sel].type) do
                        State.sel = State.sel + 1
                        if State.sel > #items then State.sel = 1 end
                    end
                    renderView()
                else
                    -- Swipe down = prev item
                    playSound("nav")
                    local items = State.flatItems
                    State.sel = State.sel - 1
                    if State.sel < 1 then State.sel = #items end
                    while items[State.sel] and isNonInteractive(items[State.sel].type) do
                        State.sel = State.sel - 1
                        if State.sel < 1 then State.sel = #items end
                    end
                    renderView()
                end
            end
            swipeStart = nil
        end
    end)
end

------------------------------------------------------------------------
--  MOBILE: SHOW/HIDE HELPERS
------------------------------------------------------------------------
showMobileUI = function()
    if not isTouch then return end
    if mobileActionBar then
        mobileActionBar.Visible = true
        mobileActionBar.Position = UDim2.new(0.5, -155, 1, 10)
        quickTween(mobileActionBar, 0.35, {
            Position = UDim2.new(0.5, -155, 1, -66),
        }, Enum.EasingStyle.Back)
    end
    if mobileToggleBtn then
        quickTween(mobileToggleBtn, 0.2, {
            Size = UDim2.new(0, 36, 0, 36),
            BackgroundTransparency = 0.5,
        })
    end
end

hideMobileUI = function()
    if not isTouch then return end
    if mobileActionBar then
        quickTween(mobileActionBar, 0.2, {
            Position = UDim2.new(0.5, -155, 1, 10),
        })
        task.delay(0.22, function()
            if not State.visible and mobileActionBar then
                mobileActionBar.Visible = false
            end
        end)
    end
    if mobileToggleBtn then
        quickTween(mobileToggleBtn, 0.3, {
            Size = UDim2.new(0, 50, 0, 50),
            BackgroundTransparency = 0.12,
        }, Enum.EasingStyle.Back)
    end
end

-- ALT key: opens menu when closed. Also handles V key exit from mouse mode.
-- This listener is for when the CAS sink is NOT active (menu closed or mouse mode)
UIS.InputBegan:Connect(function(input, gameProcessed)
    -- ALT: toggle menu open/close (debounce handled inside toggleMenu)
    if input.KeyCode == Enum.KeyCode.LeftAlt then
        if not gui.Parent then return end
        if State.mouseMode then
            disableMouseMode()
        end
        toggleMenu(not State.visible)
        return
    end

    -- V key: toggle mouse mode (only when menu is open)
    if input.KeyCode == Enum.KeyCode.V and State.visible then
        if State._vToggling then return end
        State._vToggling = true
        task.delay(0.25, function() State._vToggling = false end)
        
        if State.mouseMode then
            disableMouseMode()
        else
            enableMouseMode()
        end
        return
    end
    
    -- X key: back/close while in mouse mode (CAS sink is unbound so we handle it here)
    if input.KeyCode == Enum.KeyCode.X and State.visible and State.mouseMode then
        doGoBack()
        return
    end
end)

------------------------------------------------------------------------
--  GLOBAL CLICK HANDLER (BULLETPROOF)
--  UIS.InputBegan fires for ALL clicks, even if ScrollingFrame or 
--  overlays try to intercept. We manually check if the click is
--  within any item frame and activate it.
------------------------------------------------------------------------
UIS.InputBegan:Connect(function(input, gameProcessed)
    if not State.visible then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 
    and input.UserInputType ~= Enum.UserInputType.Touch then return end
    
    local cx, cy = input.Position.X, input.Position.Y
    
    -- Check if click is within itemsFrame bounds first
    local ifPos = itemsFrame.AbsolutePosition
    local ifSize = itemsFrame.AbsoluteSize
    if cx < ifPos.X or cx > ifPos.X + ifSize.X 
    or cy < ifPos.Y or cy > ifPos.Y + ifSize.Y then return end
    
    -- Find which item frame contains the click
    for i, frame in ipairs(itemInstances) do
        if frame.Parent then
            local fp = frame.AbsolutePosition
            local fs = frame.AbsoluteSize
            if cx >= fp.X and cx <= fp.X + fs.X 
            and cy >= fp.Y and cy <= fp.Y + fs.Y then
                local item = State.flatItems[i]
                if item and not isNonInteractive(item.type) and item.type ~= "textbox" and item.type ~= "slider" then
                    State.sel = i
                    createRipple(frame, cx - fp.X, cy - fp.Y)
                    doSelect()
                end
                break
            end
        end
    end
end)

------------------------------------------------------------------------
--  VISUAL EFFECTS LOOP (ENHANCED)
------------------------------------------------------------------------
local phase = 0
local sweepTimer = 0

RS.Heartbeat:Connect(function(dt)
    phase = phase + dt
    sweepTimer = sweepTimer + dt
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
        fogC.BackgroundColor3 = c.fog
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
        titleHalo.BackgroundColor3 = c.glow
        for _, cb in ipairs(corners) do
            cb.BackgroundColor3 = c.glow
        end
    end

    -- Border glow pulse (breathing)
    local breathe = math.sin(phase * 2.0) * 0.5 + 0.5  -- 0..1 smooth
    outerStroke.Transparency = 0.02 + breathe * 0.18
    -- outerGlow breathing handled in enhanced effects section below

    -- Title stroke shimmer
    titleTextStroke.Transparency = 0.15 + math.sin(phase * 2.8) * 0.18
    
    -- Top glare pulse
    topGlare.BackgroundTransparency = 0.87 + math.sin(phase * 1.5) * 0.025

    -- Fog drift (three blobs with different orbits)
    local fogSpeed = 0.35
    fogA.Position = UDim2.new(
        0.06 + math.sin(phase * fogSpeed) * 0.07, 0, 
        0.06 + math.cos(phase * fogSpeed * 0.8) * 0.05, 0
    )
    fogB.Position = UDim2.new(
        0.35 - math.sin(phase * fogSpeed * 0.9) * 0.07, 0, 
        0.45 - math.cos(phase * fogSpeed * 0.7) * 0.05, 0
    )
    fogC.Position = UDim2.new(
        0.5 + math.cos(phase * fogSpeed * 0.6) * 0.08, 0, 
        0.25 + math.sin(phase * fogSpeed * 1.1) * 0.06, 0
    )
    -- Fog size breathing
    local fogBreath = 0.02 * math.sin(phase * 0.8)
    fogA.Size = UDim2.new(0.7 + fogBreath, 0, 0.7 + fogBreath, 0)
    fogC.BackgroundTransparency = 0.94 + math.sin(phase * 1.2) * 0.02

    -- Inner border pulse
    -- Inner border pulse (handled below in enhanced effects)
    
    -- Subtitle banner breathing
    subtitleBanner.BackgroundTransparency = 0.38 + math.sin(phase * 2.0) * 0.05

    -- ═══ Corner bracket pulse ═══
    local cornerAlpha = 0.25 + math.sin(phase * 2.2) * 0.15
    for _, cb in ipairs(corners) do
        cb.BackgroundTransparency = cornerAlpha
    end

    -- ═══ Title halo breathing ═══
    titleHalo.BackgroundTransparency = 0.90 + math.sin(phase * 1.6) * 0.04
    titleHalo.BackgroundColor3 = c.glow

    -- ═══ Light sweep across panel (every ~6 seconds) ═══
    if sweepTimer > 6.0 then
        sweepTimer = 0
        lightSweep.Position = UDim2.new(-0.2, 0, 0, 0)
        lightSweep.BackgroundTransparency = 0.95
        quickTween(lightSweep, 1.8, {
            Position = UDim2.new(1.1, 0, 0, 0),
            BackgroundTransparency = 0.98,
        }, Enum.EasingStyle.Sine)
    end

    -- ═══ Title underline animated width pulse ═══
    titleLine.BackgroundTransparency = 0.3 + math.sin(phase * 2.5) * 0.1
    local lineW = 0.46 + math.sin(phase * 1.2) * 0.03
    titleLine.Size = UDim2.new(lineW, 0, 0, 1.8)
    titleLine.Position = UDim2.new((1 - lineW) / 2, 0, 0, 52)

    -- ═══ Chromatic glitch (original behavior preserved) ═══
    if State.glitchTitle then
        -- Subtle micro-glitch
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

        -- Heavy glitch burst
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
        
        -- Scanline flicker (brief horizontal offset)
        if math.random() < 0.008 then
            local shift = math.random(-3, 3)
            titleLabel.Position = UDim2.new(0, shift, 0, 0)
            task.delay(0.03, function()
                titleLabel.Position = UDim2.new(0, 0, 0, 0)
            end)
        end
    end
    
    -- Mouse mode indicator pulse
    if State.mouseMode and mouseModeIndicator.Visible then
        mouseModeIndicator.TextTransparency = 0.1 + math.sin(phase * 3) * 0.15
    end
    
    -- Status dot pulse (heartbeat-like)
    local dotPulse = math.abs(math.sin(phase * 2.5))
    statusDot.BackgroundTransparency = 0.05 + (1 - dotPulse) * 0.2
    dotGlow.BackgroundTransparency = 0.6 + (1 - dotPulse) * 0.3
    dotGlow.Size = UDim2.new(0, 12 + dotPulse * 4, 0, 12 + dotPulse * 4)
    dotGlow.Position = UDim2.new(0, 5 - dotPulse * 2, 0.5, -6 - dotPulse * 2)
    
    -- Mobile action bar glow animation
    if isTouch and mobileActionBar and mobileActionBar.Visible then
        local selectBtn = mobileNavBtns and mobileNavBtns["select"]
        if selectBtn then
            selectBtn.btn.BackgroundTransparency = 0.4 + math.sin(phase * 3.0) * 0.1
        end
    end
    
    -- Outer glow breathing (panel border glow pulses)
    if outerGlow then
        outerGlow.Transparency = 0.55 + math.sin(phase * 1.4) * 0.15
    end
    
    -- Subtitle text shimmer (color shifts slightly)
    local subShimmer = math.sin(phase * 2.0) * 0.5 + 0.5
    subtitleLabel.TextTransparency = 0.15 + (1 - subShimmer) * 0.08
    
    -- Inner border breathe
    innerStroke.Transparency = 0.25 + math.sin(phase * 1.8) * 0.1
    
    -- Footer text subtle pulse
    footerLabel.TextTransparency = 0.1 + math.abs(math.sin(phase * 0.8)) * 0.12
    
    -- Ambient energy sparks (rare, from edges)
    if State.particles and math.random() < 0.015 then
        local side = math.random(1, 4)
        local startX, startY, endX, endY
        if side == 1 then
            startX = math.random() * 0.8 + 0.1; startY = 0
            endX = startX + (math.random() - 0.5) * 0.1; endY = -0.04
        elseif side == 2 then
            startX = 1; startY = math.random() * 0.8 + 0.1
            endX = 1.04; endY = startY + (math.random() - 0.5) * 0.1
        elseif side == 3 then
            startX = math.random() * 0.8 + 0.1; startY = 1
            endX = startX + (math.random() - 0.5) * 0.1; endY = 1.04
        else
            startX = 0; startY = math.random() * 0.8 + 0.1
            endX = -0.04; endY = startY + (math.random() - 0.5) * 0.1
        end
        local spark = makeFrame(mainFrame, {
            Size = UDim2.new(0, 3, 0, 3),
            Position = UDim2.new(startX, 0, startY, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = c.glow,
            BackgroundTransparency = 0.15,
            ZIndex = 19,
        })
        addCorner(spark, 2)
        quickTween(spark, 0.5, {
            Position = UDim2.new(endX, 0, endY, 0),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 1, 0, 1),
        })
        task.delay(0.55, function() if spark.Parent then spark:Destroy() end end)
    end
    
    -- ═══ Selected item glow halo ═══
    local selFrame = itemInstances[State.sel]
    if selFrame and selFrame.Parent then
        local pulse = 0.82 + math.sin(phase * 4.0) * 0.06
        selFrame.BackgroundTransparency = pulse
    end
    
    -- ═══ Title text color shimmer ═══
    local shimH = (rainbowHue + math.sin(phase * 0.5) * 0.02) % 1
    local shimS = THEMES[State.colorIdx].name == "RAINBOW" and 0.6 or 0
    titleTextStroke.Color = shimS > 0 and c.glow or Color3.fromHSV(
        math.clamp(shimH, 0, 1), 
        math.clamp(0.4 + math.sin(phase * 1.3) * 0.15, 0, 1), 
        math.clamp(0.75 + math.sin(phase * 2.1) * 0.1, 0, 1)
    )
    
    -- ═══ Rare digital noise line ═══
    if math.random() < 0.005 then
        local noiseY = math.random() * 0.9 + 0.05
        local noiseLine = makeFrame(mainFrame, {
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0, 0, noiseY, 0),
            BackgroundColor3 = c.accent,
            BackgroundTransparency = 0.6,
            ZIndex = 19,
        })
        quickTween(noiseLine, 0.08, { BackgroundTransparency = 1, Position = UDim2.new(0, math.random(-6, 6), noiseY, 0) })
        task.delay(0.1, function() if noiseLine.Parent then noiseLine:Destroy() end end)
    end
    
    -- ═══ Panel edge shimmer (traveling light dot along border) ═══
    if State.particles and math.random() < 0.008 then
        local t = math.random()
        local px, py
        if t < 0.25 then px = t * 4; py = 0
        elseif t < 0.5 then px = 1; py = (t - 0.25) * 4
        elseif t < 0.75 then px = 1 - (t - 0.5) * 4; py = 1
        else px = 0; py = 1 - (t - 0.75) * 4 end
        
        local edgeDot = makeFrame(mainFrame, {
            Size = UDim2.new(0, 6, 0, 6),
            Position = UDim2.new(px, 0, py, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = c.glow,
            BackgroundTransparency = 0.25,
            ZIndex = 19,
        })
        addCorner(edgeDot, 3)
        
        -- Travel along border
        local nt = (t + 0.08) % 1
        local nx, ny
        if nt < 0.25 then nx = nt * 4; ny = 0
        elseif nt < 0.5 then nx = 1; ny = (nt - 0.25) * 4
        elseif nt < 0.75 then nx = 1 - (nt - 0.5) * 4; ny = 1
        else nx = 0; ny = 1 - (nt - 0.75) * 4 end
        
        quickTween(edgeDot, 0.8, {
            Position = UDim2.new(nx, 0, ny, 0),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 2, 0, 2),
        })
        task.delay(0.85, function() if edgeDot.Parent then edgeDot:Destroy() end end)
    end
    
    -- ═══ Version label slow fade pulse ═══
    versionLabel.TextTransparency = 0.2 + math.sin(phase * 0.7) * 0.12
end)

task.spawn(function()
    while true do
        task.wait(0.35)
        if State.visible and THEMES[State.colorIdx].name == "RAINBOW" then
            renderView()
        end
    end
end)

------------------------------------------------------------------------
--  PARTICLE SYSTEMS
------------------------------------------------------------------------
local particleFolder = Instance.new("Folder")
particleFolder.Name = "Particles"
particleFolder.Parent = gui

-- Bottom particles
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
            Rotation = (math.random() - 0.5) * 180,
        }, Enum.EasingStyle.Sine)
        task.delay(dur + 0.1, function() p:Destroy() end)
    end
end)

-- Side particles
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
        
        local pStroke = addStroke(p, c.glow, 1, 0.7)

        local dur = 1.3 + math.random() * 2.2
        local drift = (side == 0 and -1 or 1) * (0.014 + math.random() * 0.028)
        quickTween(p, dur, {
            Position = UDim2.new(sx + drift, 0, sy - 0.018, 0),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 0, 0),
        })
        quickTween(pStroke, dur, { Transparency = 1 })
        task.delay(dur + 0.1, function() p:Destroy() end)
    end
end)

-- Internal ambient particles
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
            Rotation = (math.random() - 0.5) * 360,
        }, Enum.EasingStyle.Sine)
        task.delay(dur + 0.1, function() p:Destroy() end)
    end
end)

-- Border sparkle particles (twinkle along edges)
task.spawn(function()
    while true do
        task.wait(0.4 + math.random() * 0.8)
        if not State.visible or not State.particles then continue end
        local c = ct()
        local ss = gui.AbsoluteSize
        if ss.X < 1 then continue end
        local mp = mainFrame.AbsolutePosition
        local ms = mainFrame.AbsoluteSize
        
        -- Pick a random point along the border perimeter
        local perim = (ms.X + ms.Y) * 2
        local pos = math.random() * perim
        local px, py
        if pos < ms.X then
            px, py = mp.X + pos, mp.Y -- top edge
        elseif pos < ms.X + ms.Y then
            px, py = mp.X + ms.X, mp.Y + (pos - ms.X) -- right edge
        elseif pos < ms.X * 2 + ms.Y then
            px, py = mp.X + ms.X - (pos - ms.X - ms.Y), mp.Y + ms.Y -- bottom edge
        else
            px, py = mp.X, mp.Y + ms.Y - (pos - ms.X * 2 - ms.Y) -- left edge
        end
        
        local sx = px / ss.X
        local sy = py / ss.Y
        
        -- Star-shaped sparkle (using a label with ✦)
        local sparkle = makeLabel(particleFolder, {
            Size = UDim2.new(0, 14, 0, 14),
            Position = UDim2.new(sx, -7, sy, -7),
            TextSize = math.random(8, 14),
            TextColor3 = c.accent,
            TextTransparency = 0.2,
            Text = "✦",
            ZIndex = 6,
        })
        
        -- Quick flash: pop in, hold, fade out
        quickTween(sparkle, 0.15, { TextSize = math.random(10, 16) }, Enum.EasingStyle.Back)
        task.delay(0.15, function()
            if sparkle.Parent then
                quickTween(sparkle, 0.4 + math.random() * 0.3, {
                    TextTransparency = 1,
                    TextSize = 4,
                    Rotation = math.random(-90, 90),
                })
            end
        end)
        task.delay(0.9, function() sparkle:Destroy() end)
    end
end)

-- Floating diamond particles (inside panel, slow drift)
task.spawn(function()
    while true do
        task.wait(1.2 + math.random() * 2.0)
        if not State.visible or not State.particles then continue end
        local c = ct()
        
        local sparkle = makeLabel(mainFrame, {
            Size = UDim2.new(0, 12, 0, 12),
            Position = UDim2.new(math.random() * 0.9 + 0.05, 0, math.random() * 0.8 + 0.1, 0),
            TextSize = math.random(6, 10),
            TextColor3 = c.glow,
            TextTransparency = 0.5,
            Text = "◆",
            ZIndex = 15,
            Rotation = 0,
        })
        
        local dur = 2.0 + math.random() * 3.0
        quickTween(sparkle, dur, {
            TextTransparency = 1,
            TextSize = 3,
            Position = UDim2.new(
                sparkle.Position.X.Scale + (math.random() - 0.5) * 0.1,
                0,
                sparkle.Position.Y.Scale - 0.08,
                0
            ),
            Rotation = (math.random() - 0.5) * 120,
        }, Enum.EasingStyle.Sine)
        task.delay(dur + 0.1, function() sparkle:Destroy() end)
    end
end)

-- Constellation lines (brief connecting lines between random points)
task.spawn(function()
    while true do
        task.wait(2.0 + math.random() * 3.0)
        if not State.visible or not State.particles then continue end
        local c = ct()
        
        -- Two random points inside the panel
        local x1, y1 = math.random() * 0.8 + 0.1, math.random() * 0.7 + 0.15
        local x2, y2 = x1 + (math.random() - 0.5) * 0.3, y1 + (math.random() - 0.5) * 0.25
        
        local dx, dy = x2 - x1, y2 - y1
        local len = math.sqrt(dx * dx + dy * dy)
        local angle = math.deg(math.atan2(dy, dx))
        
        local line = makeFrame(mainFrame, {
            Size = UDim2.new(0, 0, 0, 1),
            Position = UDim2.new(x1, 0, y1, 0),
            Rotation = angle,
            BackgroundColor3 = c.glow,
            BackgroundTransparency = 0.7,
            ZIndex = 15,
        })
        
        -- Line draws itself
        quickTween(line, 0.3, {
            Size = UDim2.new(len, 0, 0, 1),
            BackgroundTransparency = 0.6,
        })
        
        -- Small dots at endpoints
        for _, pos in ipairs({{x1, y1}, {x2, y2}}) do
            local dot = makeFrame(mainFrame, {
                Size = UDim2.new(0, 4, 0, 4),
                Position = UDim2.new(pos[1], 0, pos[2], 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = c.accent,
                BackgroundTransparency = 0.4,
                ZIndex = 15,
            })
            addCorner(dot, 2)
            quickTween(dot, 1.0, { BackgroundTransparency = 1, Size = UDim2.new(0, 1, 0, 1) })
            task.delay(1.1, function() if dot.Parent then dot:Destroy() end end)
        end
        
        -- Line fades
        task.delay(0.3, function()
            if line.Parent then
                quickTween(line, 0.5, { BackgroundTransparency = 1 })
                task.delay(0.55, function() if line.Parent then line:Destroy() end end)
            end
        end)
    end
end)

-- Energy pulse rings (expanding ring from center, rare)
task.spawn(function()
    while true do
        task.wait(4.0 + math.random() * 5.0)
        if not State.visible or not State.particles then continue end
        local c = ct()
        
        local ring = makeFrame(mainFrame, {
            Size = UDim2.new(0, 4, 0, 4),
            Position = UDim2.new(0.5, 0, 0.4, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            ZIndex = 15,
        })
        addCorner(ring, 999)
        local ringStroke = addStroke(ring, c.glow, 1.5, 0.5)
        
        quickTween(ring, 1.2, {
            Size = UDim2.new(0, 180, 0, 180),
        }, Enum.EasingStyle.Quad)
        quickTween(ringStroke, 1.2, {
            Transparency = 1,
        })
        task.delay(1.3, function() if ring.Parent then ring:Destroy() end end)
    end
end)

------------------------------------------------------------------------
local Library = {}
Library.__index = Library

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

    hintLabel.Text = isMobile
        and string.format('%s Tap the <font color="#d8a0ff">skull button</font> to summon <font color="#d8a0ff">%s</font> %s', skull, State.title, skull)
        or string.format('%s Press <font color="#d8a0ff">LEFT ALT</font> to summon <font color="#d8a0ff">%s</font> %s', skull, State.title, skull)

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

                return {
                    Set = function(_, val)
                        el.value = val
                        if callback then pcall(callback, val) end
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

            -- Built-in label element (non-interactive text)
            function Section:CreateLabel(text)
                local el = {
                    type = "label",
                    label = text or "",
                }
                table.insert(sec.elements, el)
                return el
            end

            -- Built-in divider element (visual separator)
            function Section:CreateDivider()
                local el = {
                    type = "divider",
                    label = "---",
                }
                table.insert(sec.elements, el)
                return el
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

    function Window:SetAutoSave(val)
        -- Stub for compatibility
    end

    function Window:Destroy()
        State.visible = false
        unbindKeys()
        restoreCursor()
        gui:Destroy()
    end

    -- ═══════════════════════════════════════════════════════════
    --  NATIVE CONFIG SYSTEM (no addon needed)
    --  Uses writefile/readfile to persist settings across sessions
    -- ═══════════════════════════════════════════════════════════
    local CONFIG_FOLDER = "SpookyHub_Configs"
    local HttpService = game:GetService("HttpService")
    
    -- Check if file system is available
    local _hasFS = (typeof(writefile) == "function" and typeof(readfile) == "function")
    
    function Window:SaveConfig(profileName)
        profileName = profileName or "Default"
        local data = {}
        
        -- Save all element values
        for _, pageId in ipairs(State.pageOrder) do
            local pg = State.pages[pageId]
            if pg then
                for _, sec in ipairs(pg.sections) do
                    for _, el in ipairs(sec.elements) do
                        local key = pg.name .. "|" .. sec.name .. "|" .. el.label
                        if el.type == "toggle" then
                            data[key] = { t = "toggle", v = el.value }
                        elseif el.type == "slider" then
                            data[key] = { t = "slider", v = el.value }
                        elseif el.type == "dropdown" then
                            data[key] = { t = "dropdown", v = el.value }
                        elseif el.type == "textbox" then
                            data[key] = { t = "textbox", v = el.value }
                        elseif el.type == "keybind" then
                            data[key] = { t = "keybind", v = el.value and el.value.Name or nil }
                        end
                    end
                end
            end
        end
        
        -- Save UI settings (theme, sounds, particles, etc.)
        data["__ui__"] = {
            colorIdx = State.colorIdx,
            sounds = State.sounds,
            particles = State.particles,
            scanlines = State.scanlines,
            glitchTitle = State.glitchTitle,
            opacity = State.opacity,
        }
        
        local ok, err = pcall(function()
            local json = HttpService:JSONEncode(data)
            if _hasFS then
                if not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end
                writefile(CONFIG_FOLDER .. "/" .. profileName .. ".json", json)
            else
                -- Fallback: store in _G so it persists within the same session
                _G.__SpookyConfig = _G.__SpookyConfig or {}
                _G.__SpookyConfig[profileName] = json
            end
        end)
        
        if not ok then
            warn("[SpookyConfig] Save error:", err)
        end
        return ok
    end
    
    function Window:LoadConfig(profileName)
        profileName = profileName or "Default"
        
        local json
        local ok = pcall(function()
            if _hasFS then
                local path = CONFIG_FOLDER .. "/" .. profileName .. ".json"
                if isfile(path) then
                    json = readfile(path)
                end
            else
                -- Fallback: read from _G
                if _G.__SpookyConfig and _G.__SpookyConfig[profileName] then
                    json = _G.__SpookyConfig[profileName]
                end
            end
        end)
        
        if not ok or not json then return false end
        
        local data
        ok = pcall(function()
            data = HttpService:JSONDecode(json)
        end)
        if not ok or type(data) ~= "table" then return false end
        
        -- Restore UI settings
        local ui = data["__ui__"]
        if ui then
            if ui.colorIdx then State.colorIdx = ui.colorIdx end
            if ui.sounds ~= nil then State.sounds = ui.sounds end
            if ui.particles ~= nil then State.particles = ui.particles end
            if ui.scanlines ~= nil then State.scanlines = ui.scanlines end
            if ui.glitchTitle ~= nil then State.glitchTitle = ui.glitchTitle end
            if ui.opacity then State.opacity = ui.opacity end
        end
        
        -- Restore element values
        for _, pageId in ipairs(State.pageOrder) do
            local pg = State.pages[pageId]
            if pg then
                for _, sec in ipairs(pg.sections) do
                    for _, el in ipairs(sec.elements) do
                        local key = pg.name .. "|" .. sec.name .. "|" .. el.label
                        local saved = data[key]
                        if saved then
                            if el.type == "toggle" and saved.t == "toggle" then
                                el.value = saved.v
                                if el.callback then pcall(el.callback, el.value) end
                            elseif el.type == "slider" and saved.t == "slider" then
                                el.value = math.clamp(saved.v, el.min, el.max)
                                if el.callback then pcall(el.callback, el.value) end
                            elseif el.type == "dropdown" and saved.t == "dropdown" then
                                -- Verify the value still exists in the list
                                local valid = false
                                for _, v in ipairs(el.list or {}) do
                                    if v == saved.v then valid = true; break end
                                end
                                if valid then
                                    el.value = saved.v
                                    if el.callback then pcall(el.callback, el.value) end
                                end
                            elseif el.type == "textbox" and saved.t == "textbox" then
                                el.value = saved.v or ""
                            elseif el.type == "keybind" and saved.t == "keybind" then
                                if saved.v and typeof(Enum.KeyCode[saved.v]) == "EnumItem" then
                                    el.value = Enum.KeyCode[saved.v]
                                end
                            end
                        end
                    end
                end
            end
        end
        
        if State.visible then renderView() end
        return true
    end
    
    function Window:GetProfiles()
        local profiles = {}
        pcall(function()
            if _hasFS and isfolder(CONFIG_FOLDER) then
                local files = listfiles(CONFIG_FOLDER)
                for _, path in ipairs(files) do
                    local name = path:match("([^/\\]+)%.json$")
                    if name then
                        table.insert(profiles, name)
                    end
                end
            end
            -- Check _G fallback too
            if _G.__SpookyConfig then
                for name in pairs(_G.__SpookyConfig) do
                    local found = false
                    for _, p in ipairs(profiles) do if p == name then found = true; break end end
                    if not found then table.insert(profiles, name) end
                end
            end
        end)
        return profiles
    end
    
    function Window:ExportConfig(profileName)
        profileName = profileName or "Default"
        local json
        pcall(function()
            if _hasFS then
                local path = CONFIG_FOLDER .. "/" .. profileName .. ".json"
                if isfile(path) then json = readfile(path) end
            elseif _G.__SpookyConfig then
                json = _G.__SpookyConfig[profileName]
            end
        end)
        if json and setclipboard then
            setclipboard(json)
            return true
        end
        return false
    end
    
    function Window:DeleteConfig(profileName)
        profileName = profileName or "Default"
        pcall(function()
            if _hasFS then
                local path = CONFIG_FOLDER .. "/" .. profileName .. ".json"
                if isfile(path) then delfile(path) end
            end
            if _G.__SpookyConfig then
                _G.__SpookyConfig[profileName] = nil
            end
        end)
        return true
    end

    return Window
end

------------------------------------------------------------------------
--  INIT + INTRO BOOT SEQUENCE
------------------------------------------------------------------------
mainFrame.Visible = false
if not isMobile then hintFrame.Visible = false end

-- ═══════════════════════════════════════════════════════════
--  CINEMATIC INTRO
-- ═══════════════════════════════════════════════════════════
task.spawn(function()
    local c = ct()
    
    local introOverlay = makeFrame(gui, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(4, 2, 12),
        BackgroundTransparency = 0,
        ZIndex = 300,
        ClipsDescendants = true,
    })
    
    -- Radial vignette (dark edges, lighter center)
    local vignette = makeFrame(introOverlay, {
        Size = UDim2.new(1.2, 0, 1.2, 0),
        Position = UDim2.new(-0.1, 0, -0.1, 0),
        BackgroundColor3 = c.glow,
        BackgroundTransparency = 0.96,
        ZIndex = 301,
    })
    addCorner(vignette, 999)
    
    -- Slow-moving ambient fog
    local introFog1 = makeFrame(introOverlay, {
        Size = UDim2.new(0.8, 0, 0.8, 0),
        Position = UDim2.new(0.1, 0, 0.15, 0),
        BackgroundColor3 = c.glow,
        BackgroundTransparency = 0.97,
        ZIndex = 302,
    })
    addCorner(introFog1, 200)
    local introFog2 = makeFrame(introOverlay, {
        Size = UDim2.new(0.6, 0, 0.6, 0),
        Position = UDim2.new(0.35, 0, 0.3, 0),
        BackgroundColor3 = c.accent,
        BackgroundTransparency = 0.97,
        ZIndex = 302,
    })
    addCorner(introFog2, 200)
    
    -- Animate fog drift
    quickTween(introFog1, 4, {
        Position = UDim2.new(0.05, 0, 0.1, 0),
    })
    quickTween(introFog2, 4, {
        Position = UDim2.new(0.4, 0, 0.25, 0),
    })
    
    -- ══ CENTRAL CONTENT (all anchored to center) ══
    -- Skull
    local skull = makeLabel(introOverlay, {
        Size = UDim2.new(0, 60, 0, 60),
        Position = UDim2.new(0.5, 0, 0.5, -42),
        AnchorPoint = Vector2.new(0.5, 0.5),
        TextSize = 1,
        TextColor3 = Color3.new(1, 1, 1),
        TextTransparency = 1,
        Text = utf8.char(0x1F480),
        ZIndex = 320,
    })
    
    -- Title
    local title = makeLabel(introOverlay, {
        Size = UDim2.new(0, 300, 0, 36),
        Position = UDim2.new(0.5, 0, 0.5, 2),
        AnchorPoint = Vector2.new(0.5, 0.5),
        TextSize = 1,
        TextColor3 = c.accent,
        TextTransparency = 1,
        Text = "SPOOKALICIOUS",
        ZIndex = 320,
    })
    local titleStroke = addStroke(title, c.glow, 3, 1, Enum.ApplyStrokeMode.Contextual)
    
    -- Thin divider line under title
    local divider = makeFrame(introOverlay, {
        Size = UDim2.new(0, 0, 0, 1),
        Position = UDim2.new(0.5, 0, 0.5, 22),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = c.border,
        BackgroundTransparency = 0.4,
        ZIndex = 318,
    })
    
    -- Glow pulse behind divider
    local divGlow = makeFrame(introOverlay, {
        Size = UDim2.new(0, 0, 0, 6),
        Position = UDim2.new(0.5, 0, 0.5, 22),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = c.glow,
        BackgroundTransparency = 0.8,
        ZIndex = 317,
    })
    addCorner(divGlow, 3)
    
    -- Version
    local ver = makeLabel(introOverlay, {
        Size = UDim2.new(0, 200, 0, 16),
        Position = UDim2.new(0.5, 0, 0.5, 34),
        AnchorPoint = Vector2.new(0.5, 0.5),
        TextSize = 11,
        TextColor3 = c.accentDim,
        TextTransparency = 1,
        Text = "VERSION 4.0",
        ZIndex = 320,
    })
    
    -- Loading bar container
    local barBg = makeFrame(introOverlay, {
        Size = UDim2.new(0, 180, 0, 3),
        Position = UDim2.new(0.5, 0, 0.5, 58),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(30, 15, 45),
        BackgroundTransparency = 1,
        ZIndex = 318,
    })
    addCorner(barBg, 2)
    
    -- Loading bar fill
    local barFill = makeFrame(barBg, {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = c.accent,
        BackgroundTransparency = 0.15,
        ZIndex = 319,
    })
    addCorner(barFill, 2)
    
    -- Bar glow
    local barGlow = makeFrame(barBg, {
        Size = UDim2.new(0, 0, 0, 8),
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = c.glow,
        BackgroundTransparency = 0.7,
        ZIndex = 317,
    })
    addCorner(barGlow, 4)
    
    -- Status text
    local status = makeLabel(introOverlay, {
        Size = UDim2.new(0, 200, 0, 14),
        Position = UDim2.new(0.5, 0, 0.5, 72),
        AnchorPoint = Vector2.new(0.5, 0.5),
        TextSize = 9,
        TextColor3 = c.accentDim,
        TextTransparency = 1,
        Text = "",
        ZIndex = 320,
    })
    
    -- Floating particles in background
    local introParticles = {}
    for i = 1, 20 do
        local sz = math.random(1, 3)
        local p = makeFrame(introOverlay, {
            Size = UDim2.new(0, sz, 0, sz),
            Position = UDim2.new(math.random() * 0.9 + 0.05, 0, math.random() * 0.9 + 0.05, 0),
            BackgroundColor3 = c.particle,
            BackgroundTransparency = 0.6 + math.random() * 0.3,
            ZIndex = 303,
        })
        addCorner(p, sz)
        table.insert(introParticles, p)
        -- Slow float upward
        quickTween(p, 3 + math.random() * 3, {
            Position = UDim2.new(p.Position.X.Scale + (math.random() - 0.5) * 0.1, 0, p.Position.Y.Scale - 0.15 - math.random() * 0.2, 0),
            BackgroundTransparency = 1,
        })
    end

    -- ═══════════════════════════════════════
    --  PHASE 1: Skull materializes (0.0s)
    -- ═══════════════════════════════════════
    playSound("intro")
    task.wait(0.1)
    
    -- Skull scales in with bounce
    quickTween(skull, 0.6, {
        TextSize = 42,
        TextTransparency = 0,
    }, Enum.EasingStyle.Back)
    
    task.wait(0.55)
    
    -- Subtle skull float
    task.spawn(function()
        while skull.Parent do
            quickTween(skull, 1.5, { Position = UDim2.new(0.5, 0, 0.5, -45) })
            task.wait(1.5)
            if not skull.Parent then break end
            quickTween(skull, 1.5, { Position = UDim2.new(0.5, 0, 0.5, -39) })
            task.wait(1.5)
        end
    end)
    
    -- ═══════════════════════════════════════
    --  PHASE 2: Title + divider (0.6s)
    -- ═══════════════════════════════════════
    playSound("whoosh")
    
    -- Divider line expands from center
    quickTween(divider, 0.35, { Size = UDim2.new(0, 200, 0, 1) }, Enum.EasingStyle.Quint)
    quickTween(divGlow, 0.35, { Size = UDim2.new(0, 200, 0, 6) }, Enum.EasingStyle.Quint)
    
    task.wait(0.1)
    
    -- Title scales in
    quickTween(title, 0.4, {
        TextSize = 26,
        TextTransparency = 0,
    }, Enum.EasingStyle.Back)
    quickTween(titleStroke, 0.4, { Transparency = 0.15 })
    
    task.wait(0.35)
    
    -- Version fades in
    quickTween(ver, 0.3, { TextTransparency = 0.2 })
    
    task.wait(0.25)
    
    -- ═══════════════════════════════════════
    --  PHASE 3: Loading bar (1.3s)
    -- ═══════════════════════════════════════
    quickTween(barBg, 0.2, { BackgroundTransparency = 0.3 })
    quickTween(status, 0.15, { TextTransparency = 0.3 })
    
    local loadSteps = {
        { pct = 0.2, text = "LOADING MODULES" },
        { pct = 0.45, text = "BINDING CONTROLS" },
        { pct = 0.7, text = "BUILDING INTERFACE" },
        { pct = 0.9, text = "FINALIZING" },
        { pct = 1.0, text = "READY" },
    }
    
    for _, step in ipairs(loadSteps) do
        status.Text = step.text
        quickTween(barFill, 0.18, { Size = UDim2.new(step.pct, 0, 1, 0) }, Enum.EasingStyle.Quad)
        quickTween(barGlow, 0.18, { Size = UDim2.new(step.pct, 0, 0, 8) }, Enum.EasingStyle.Quad)
        task.wait(0.16)
    end
    
    -- Bar flashes on complete
    playSound("introChime")
    quickTween(barFill, 0.15, { BackgroundColor3 = c.onColor, BackgroundTransparency = 0 })
    quickTween(barGlow, 0.15, { BackgroundColor3 = c.onColor, BackgroundTransparency = 0.4 })
    quickTween(status, 0.15, { TextColor3 = c.onColor })
    
    task.wait(0.4)
    
    -- ═══════════════════════════════════════
    --  PHASE 4: Particle burst + exit (2.5s)
    -- ═══════════════════════════════════════
    
    -- Circular burst from center
    if State.particles then
        for i = 1, 24 do
            local angle = (i / 24) * math.pi * 2
            local sz = math.random(2, 4)
            local p = makeFrame(introOverlay, {
                Size = UDim2.new(0, sz, 0, sz),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = i % 2 == 0 and c.accent or c.glow,
                BackgroundTransparency = 0.05,
                ZIndex = 325,
            })
            addCorner(p, sz)
            local dist = 100 + math.random() * 120
            quickTween(p, 0.5 + math.random() * 0.4, {
                Position = UDim2.new(0.5 + math.cos(angle) * (dist / 500), 0, 0.5 + math.sin(angle) * (dist / 400), 0),
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 1, 0, 1),
            }, Enum.EasingStyle.Quad)
        end
    end
    
    -- Bright flash
    local flash = makeFrame(introOverlay, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = c.glow,
        BackgroundTransparency = 0.7,
        ZIndex = 330,
    })
    quickTween(flash, 0.4, { BackgroundTransparency = 1 })
    
    task.wait(0.15)
    
    -- Everything fades + scales
    quickTween(skull, 0.35, { TextTransparency = 1, TextSize = 55 }, Enum.EasingStyle.Quad)
    quickTween(title, 0.3, { TextTransparency = 1, TextSize = 30 }, Enum.EasingStyle.Quad)
    quickTween(titleStroke, 0.3, { Transparency = 1 })
    quickTween(ver, 0.25, { TextTransparency = 1 })
    quickTween(status, 0.2, { TextTransparency = 1 })
    quickTween(barBg, 0.25, { BackgroundTransparency = 1 })
    quickTween(barFill, 0.25, { BackgroundTransparency = 1 })
    quickTween(barGlow, 0.25, { BackgroundTransparency = 1 })
    quickTween(divider, 0.3, { Size = UDim2.new(0, 0, 0, 1), BackgroundTransparency = 1 })
    quickTween(divGlow, 0.3, { Size = UDim2.new(0, 0, 0, 6), BackgroundTransparency = 1 })
    
    task.wait(0.2)
    
    -- Overlay dissolves
    quickTween(introOverlay, 0.45, { BackgroundTransparency = 1 })
    quickTween(vignette, 0.45, { BackgroundTransparency = 1 })
    
    task.wait(0.5)
    introOverlay:Destroy()
    
    -- Hint bar slides in cleanly
    if not isMobile then
        hintFrame.Visible = true
        hintFrame.Position = UDim2.new(1, -365, 0, -30)
        quickTween(hintFrame, 0.5, {
            Position = UDim2.new(1, -365, 0, 14),
        }, Enum.EasingStyle.Back)
    end
end)

print("[SPOOKALICIOUS V4] Loaded.")
if isMobile then
    print("Tap the skull button to open.")
else
    print("Press LEFT ALT to open. V for mouse mode.")
end

return Library
