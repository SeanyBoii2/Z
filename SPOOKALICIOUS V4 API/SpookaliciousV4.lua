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
      ALT     Open / Close menu
      W / S   Scroll up / down (wraps)
      A / D   Slider adjust / Dropdown cycle
      F/SPACE Select / Toggle / Activate
      X       Back / Close
      Drag titlebar to move. Drag corner to resize.
--]]

-- Prevent duplicate execution
if _G.SpookaliciousV4Running then
    warn("Spookalicious V4 already running! Destroying old instance...")
    if _G.SpookaliciousV4Instance then
        pcall(function()
            _G.SpookaliciousV4Instance:Destroy()
        end)
    end
end
_G.SpookaliciousV4Running = true

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
--  CONNECTION TRACKING
------------------------------------------------------------------------
local connections = {}  -- Track all connections for cleanup

local function addConnection(conn)
    table.insert(connections, conn)
    return conn
end

local function disconnectAll()
    for _, conn in ipairs(connections) do
        pcall(function() conn:Disconnect() end)
    end
    connections = {}
end

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
}

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
}

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

-- Particle folder (created early so effect helpers can use it)
local particleFolder = Instance.new("Folder")
particleFolder.Name = "Particles"
particleFolder.Parent = gui

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
--  SOUND SYSTEM (MULTI-LAYERED + PITCH VARIATION)
------------------------------------------------------------------------
local sounds = {}
local SOUND_IDS = {
    click = "rbxassetid://6042053626",  -- sharp UI click
    blip  = "rbxassetid://6042053626",  -- same base, pitched differently
}

local function createSnd(id, vol, pitch)
    local s = Instance.new("Sound")
    s.Volume = vol or 0.2
    s.PlaybackSpeed = pitch or 1
    s.SoundId = id or SOUND_IDS.click
    s.Parent = SoundService
    return s
end

-- Pre-create multiple sound instances per category for layering
-- Navigation: quick light tick
sounds.nav = createSnd(SOUND_IDS.click, 0.08, 1.8)

-- Select: satisfying confirmation (two layered)
sounds.select1 = createSnd(SOUND_IDS.click, 0.18, 1.05)
sounds.select2 = createSnd(SOUND_IDS.click, 0.1, 1.6)

-- Back: low thud
sounds.back = createSnd(SOUND_IDS.click, 0.16, 0.5)

-- Slider: tiny precise tick
sounds.slider = createSnd(SOUND_IDS.click, 0.05, 2.4)

-- Open: dramatic low boom + shimmer layer
sounds.open1 = createSnd(SOUND_IDS.click, 0.25, 0.3)
sounds.open2 = createSnd(SOUND_IDS.click, 0.12, 1.7)

-- Close: medium reverse
sounds.close1 = createSnd(SOUND_IDS.click, 0.18, 0.42)
sounds.close2 = createSnd(SOUND_IDS.click, 0.08, 0.9)

-- Toggle ON: rising confirmation
sounds.toggleOn = createSnd(SOUND_IDS.click, 0.15, 1.5)

-- Toggle OFF: falling deactivation
sounds.toggleOff = createSnd(SOUND_IDS.click, 0.12, 0.65)

-- Deny/error
sounds.deny = createSnd(SOUND_IDS.click, 0.12, 0.35)

local function playSnd(s, pitchVar)
    if not s then return end
    s:Stop()
    -- Add slight random pitch variation for organic feel
    if pitchVar then
        local base = s.PlaybackSpeed
        s.PlaybackSpeed = base + (math.random() - 0.5) * pitchVar
        s:Play()
        s.PlaybackSpeed = base -- reset for next play
    else
        s:Play()
    end
end

local function playSound(name, extra)
    if not State.sounds then return end

    if name == "nav" then
        playSnd(sounds.nav, 0.15)
    elseif name == "select" then
        playSnd(sounds.select1, 0.08)
        task.delay(0.035, function() playSnd(sounds.select2, 0.1) end)
    elseif name == "back" then
        playSnd(sounds.back, 0.06)
    elseif name == "slider" then
        playSnd(sounds.slider, 0.3)
    elseif name == "open" then
        playSnd(sounds.open1, 0.04)
        task.delay(0.06, function() playSnd(sounds.open2, 0.1) end)
    elseif name == "close" then
        playSnd(sounds.close1, 0.05)
        task.delay(0.04, function() playSnd(sounds.close2, 0.08) end)
    elseif name == "toggle" then
        if extra then
            playSnd(sounds.toggleOn, 0.12)
        else
            playSnd(sounds.toggleOff, 0.08)
        end
    elseif name == "deny" then
        playSnd(sounds.deny, 0.04)
    end
end

------------------------------------------------------------------------
--  TOAST SYSTEM (STACKING)
------------------------------------------------------------------------
local toastContainer = makeFrame(gui, {
    Name = "Toasts",
    Size = UDim2.new(0, 260, 1, 0),
    Position = UDim2.new(1, -275, 0, 0),
    ZIndex = 80,
    ClipsDescendants = false,
})

local activeToasts = {}
local MAX_TOASTS = 5
local TOAST_H = 30
local TOAST_GAP = 4
local TOAST_DURATION = 2.5

local function repositionToasts()
    for i, t in ipairs(activeToasts) do
        local targetY = -(i * (TOAST_H + TOAST_GAP)) - 10
        quickTween(t.frame, 0.2, {
            Position = UDim2.new(0, 0, 1, targetY)
        })
    end
end

local function showToast(msg)
    if #activeToasts >= MAX_TOASTS then
        local oldest = table.remove(activeToasts, 1)
        if oldest and oldest.frame then
            quickTween(oldest.frame, 0.15, { BackgroundTransparency = 1 })
            task.delay(0.2, function()
                if oldest.frame then oldest.frame:Destroy() end
            end)
        end
    end

    local c = ct()

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, TOAST_H)
    frame.Position = UDim2.new(1, 30, 1, 0)
    frame.BackgroundColor3 = c.bg
    frame.BackgroundTransparency = 0.06
    frame.BorderSizePixel = 0
    frame.ZIndex = 82
    frame.ClipsDescendants = true
    frame.Parent = toastContainer
    addCorner(frame, 4)
    addStroke(frame, c.border, 1, 0.35)

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 3, 0.65, 0)
    bar.Position = UDim2.new(0, 3, 0.175, 0)
    bar.BackgroundColor3 = c.glow
    bar.BackgroundTransparency = 0.1
    bar.BorderSizePixel = 0
    bar.ZIndex = 83
    bar.Parent = frame
    addCorner(bar, 1)

    local lbl = makeLabel(frame, {
        Size = UDim2.new(1, -18, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        TextSize = 12,
        TextColor3 = c.accent,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = msg,
        ZIndex = 84,
    })
    addStroke(lbl, c.bg, 0.8, 0.4, Enum.ApplyStrokeMode.Contextual)

    local entry = { frame = frame }
    table.insert(activeToasts, entry)
    repositionToasts()

    quickTween(frame, 0.25, {
        Position = UDim2.new(0, 0, 1, -(#activeToasts * (TOAST_H + TOAST_GAP)) - 10)
    }, Enum.EasingStyle.Back)

    task.delay(TOAST_DURATION, function()
        quickTween(frame, 0.2, { BackgroundTransparency = 1 })
        quickTween(lbl, 0.2, { TextTransparency = 1 })
        quickTween(bar, 0.2, { BackgroundTransparency = 1 })

        task.delay(0.25, function()
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
hintFrame.Size = UDim2.new(0, 320, 0, 36)
hintFrame.Position = UDim2.new(1, -335, 0, 14)
hintFrame.BackgroundColor3 = Color3.fromRGB(12, 5, 22)
hintFrame.BackgroundTransparency = 0.12
hintFrame.BorderSizePixel = 0
hintFrame.ZIndex = 70
hintFrame.Parent = gui
addCorner(hintFrame, 5)
local hintStroke = addStroke(hintFrame, ct().border, 1, 0.4)

local hintBar = Instance.new("Frame")
hintBar.Size = UDim2.new(0, 3, 0.6, 0)
hintBar.Position = UDim2.new(0, 5, 0.2, 0)
hintBar.BackgroundColor3 = ct().glow
hintBar.BackgroundTransparency = 0.1
hintBar.BorderSizePixel = 0
hintBar.ZIndex = 71
hintBar.Parent = hintFrame
addCorner(hintBar, 2)

local hintLabel = makeLabel(hintFrame, {
    Size = UDim2.new(1, -20, 1, 0),
    Position = UDim2.new(0, 14, 0, 0),
    TextSize = 14,
    TextColor3 = ct().accentDim,
    Text = utf8.char(0x1F480) .. ' Press <font color="#d8a0ff">LEFT ALT</font> to summon <font color="#d8a0ff">SPOOKALICIOUS</font> ' .. utf8.char(0x1F480),
    ZIndex = 72,
})
addStroke(hintLabel, Color3.fromRGB(50, 18, 90), 1, 0.35, Enum.ApplyStrokeMode.Contextual)

task.spawn(function()
    while true do
        if hintFrame.Visible then
            quickTween(hintLabel, 1.5, { TextTransparency = 0.35 })
            task.wait(1.5)
            quickTween(hintLabel, 1.5, { TextTransparency = 0 })
            task.wait(1.5)
        else task.wait(0.5) end
    end
end)

------------------------------------------------------------------------
--  MAIN PANEL
------------------------------------------------------------------------
local MENU_W = 360
local MENU_MIN_W, MENU_MAX_W = 280, 520
local MENU_MAX_H = 520  -- Maximum panel height to prevent going off screen

local mainFrame = Instance.new("Frame")
mainFrame.Name = "Panel"
mainFrame.Size = UDim2.new(0, MENU_W, 0, 450)
mainFrame.Position = UDim2.new(1, -MENU_W - 16, 0.5, -225)
mainFrame.BackgroundColor3 = ct().bg
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ZIndex = 10
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui
addCorner(mainFrame, 6)

local outerStroke = addStroke(mainFrame, ct().border, 2, 0.1)

local innerBorder = makeFrame(mainFrame, {
    Size = UDim2.new(1, -12, 1, -12),
    Position = UDim2.new(0, 6, 0, 6),
    BackgroundTransparency = 1,
    ZIndex = 11,
    Active = false,
})
local innerStroke = addStroke(innerBorder, ct().border, 1, 0.72)
addCorner(innerBorder, 4)

local topGlare = makeFrame(mainFrame, {
    Size = UDim2.new(1, 0, 0, 100),
    BackgroundColor3 = ct().glow,
    BackgroundTransparency = 0.93,
    ZIndex = 13,
    Active = false,
})
addGradient(topGlare, NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(1, 1),
}), 90)

local botVig = makeFrame(mainFrame, {
    Size = UDim2.new(1, 0, 0, 60),
    Position = UDim2.new(0, 0, 1, -60),
    BackgroundColor3 = Color3.new(0,0,0),
    BackgroundTransparency = 0.92,
    ZIndex = 13,
    Active = false,
})
addGradient(botVig, NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(1, 0),
}), 90)

local fogA = makeFrame(mainFrame, {
    Size = UDim2.new(0.6, 0, 0.6, 0),
    Position = UDim2.new(0.1, 0, 0.1, 0),
    BackgroundColor3 = ct().fog,
    BackgroundTransparency = 0.94,
    ZIndex = 14,
    Active = false,
})
addCorner(fogA, 80)

local fogB = makeFrame(mainFrame, {
    Size = UDim2.new(0.5, 0, 0.5, 0),
    Position = UDim2.new(0.4, 0, 0.5, 0),
    BackgroundColor3 = ct().fog,
    BackgroundTransparency = 0.95,
    ZIndex = 14,
    Active = false,
})
addCorner(fogB, 80)

local scanlineOverlay = makeFrame(mainFrame, {
    Name = "Scanlines",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Color3.new(0,0,0),
    BackgroundTransparency = 0.965,
    ZIndex = 46,
    ClipsDescendants = true,
    Active = false,
})

-- Animated scanline bars (scroll downward)
local scanlineBars = {}
for i = 0, 14 do
    local bar = makeFrame(scanlineOverlay, {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0, i * 32),
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 0.92,
        ZIndex = 47,
    })
    table.insert(scanlineBars, bar)
end

-- Holographic sweep bar (diagonal light that sweeps across periodically)
local holoSweep = makeFrame(mainFrame, {
    Name = "HoloSweep",
    Size = UDim2.new(0.08, 0, 1.4, 0),
    Position = UDim2.new(-0.15, 0, -0.2, 0),
    BackgroundColor3 = Color3.new(1,1,1),
    BackgroundTransparency = 0.92,
    Rotation = 15,
    ZIndex = 48,
    Active = false,
})
addGradient(holoSweep, NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.35, 0),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(0.65, 0),
    NumberSequenceKeypoint.new(1, 1),
}))

-- Vignette pulse overlay (dark edges that breathe)
local vigPulse = makeFrame(mainFrame, {
    Name = "VigPulse",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BackgroundTransparency = 0.97,
    ZIndex = 45,
    Active = false,
})
addCorner(vigPulse, 6)

-- Screen flash overlay (for open/close and actions)
local screenFlash = makeFrame(mainFrame, {
    Name = "ScreenFlash",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Color3.new(1,1,1),
    BackgroundTransparency = 1,
    ZIndex = 55,
    Active = false,
})
addCorner(screenFlash, 6)

-- CRT edge aberration frames (left = red, right = cyan)
local crtLeft = makeFrame(mainFrame, {
    Name = "CRTLeft",
    Size = UDim2.new(0.03, 0, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = Color3.fromRGB(255, 40, 80),
    BackgroundTransparency = 1,
    ZIndex = 49,
    Active = false,
})
local crtRight = makeFrame(mainFrame, {
    Name = "CRTRight",
    Size = UDim2.new(0.03, 0, 1, 0),
    Position = UDim2.new(0.97, 0, 0, 0),
    BackgroundColor3 = Color3.fromRGB(60, 200, 255),
    BackgroundTransparency = 1,
    ZIndex = 49,
    Active = false,
})

-- Matrix rain container (inside the panel)
local matrixContainer = makeFrame(mainFrame, {
    Name = "MatrixRain",
    Size = UDim2.new(1, 0, 1, 0),
    ClipsDescendants = true,
    ZIndex = 12,
    Active = false,
})

-- Lightning container
local lightningContainer = makeFrame(mainFrame, {
    Name = "Lightning",
    Size = UDim2.new(1, 0, 1, 0),
    ClipsDescendants = true,
    ZIndex = 44,
    Active = false,
})

------------------------------------------------------------------------
--  EFFECT HELPER FUNCTIONS
------------------------------------------------------------------------

-- Screen flash (white flash that fades out)
local function doScreenFlash(intensity, duration, color)
    screenFlash.BackgroundColor3 = color or Color3.new(1,1,1)
    screenFlash.BackgroundTransparency = intensity or 0.7
    quickTween(screenFlash, duration or 0.3, { BackgroundTransparency = 1 }, Enum.EasingStyle.Expo)
end

-- Ripple effect at a screen position (expanding ring)
local function doRipple(parent, posX, posY)
    local c = ct()
    local ripple = makeFrame(parent, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(posX, 0, posY, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        ZIndex = 50,
    })
    local ring = Instance.new("UIStroke")
    ring.Color = c.glow
    ring.Thickness = 2
    ring.Transparency = 0.3
    ring.Parent = ripple
    addCorner(ripple, 999)

    quickTween(ripple, 0.5, {
        Size = UDim2.new(0.8, 0, 0.8, 0),
    }, Enum.EasingStyle.Quad)
    quickTween(ring, 0.5, {
        Transparency = 1,
        Thickness = 0,
    }, Enum.EasingStyle.Quad)

    task.delay(0.55, function() ripple:Destroy() end)
end

-- Lightning crack (brief zigzag line)
local function doLightningCrack()
    local c = ct()
    local startX = math.random(10, 90) / 100
    local segments = math.random(3, 6)
    local segH = 1 / segments

    for i = 0, segments - 1 do
        local seg = makeFrame(lightningContainer, {
            Size = UDim2.new(0, math.random(1, 3), 0, math.floor(mainFrame.AbsoluteSize.Y * segH)),
            Position = UDim2.new(startX + (math.random() - 0.5) * 0.06, 0, segH * i, 0),
            BackgroundColor3 = c.glow,
            BackgroundTransparency = 0.15,
            ZIndex = 44,
            Rotation = (math.random() - 0.5) * 30,
        })
        -- Glow around it
        local glowSeg = makeFrame(lightningContainer, {
            Size = UDim2.new(0, math.random(8, 16), 0, math.floor(mainFrame.AbsoluteSize.Y * segH)),
            Position = seg.Position,
            BackgroundColor3 = c.glow,
            BackgroundTransparency = 0.85,
            ZIndex = 43,
            Rotation = seg.Rotation,
        })

        startX = startX + (math.random() - 0.5) * 0.08

        task.delay(0.06 + math.random() * 0.04, function()
            quickTween(seg, 0.12, { BackgroundTransparency = 1 })
            quickTween(glowSeg, 0.15, { BackgroundTransparency = 1 })
            task.delay(0.2, function()
                seg:Destroy()
                glowSeg:Destroy()
            end)
        end)
    end
end

-- Border spark (bright dot that travels along one edge)
local function doBorderSpark()
    local c = ct()
    local ss = gui.AbsoluteSize
    if ss.X < 1 then return end
    local mp = mainFrame.AbsolutePosition
    local ms = mainFrame.AbsoluteSize

    local edge = math.random(1, 4) -- 1=top, 2=right, 3=bottom, 4=left
    local startPos, endPos
    local sparkSize = math.random(3, 6)

    if edge == 1 then -- top
        startPos = UDim2.new((mp.X) / ss.X, 0, (mp.Y) / ss.Y, 0)
        endPos = UDim2.new((mp.X + ms.X) / ss.X, 0, (mp.Y) / ss.Y, 0)
    elseif edge == 2 then -- right
        startPos = UDim2.new((mp.X + ms.X) / ss.X, 0, (mp.Y) / ss.Y, 0)
        endPos = UDim2.new((mp.X + ms.X) / ss.X, 0, (mp.Y + ms.Y) / ss.Y, 0)
    elseif edge == 3 then -- bottom
        startPos = UDim2.new((mp.X + ms.X) / ss.X, 0, (mp.Y + ms.Y) / ss.Y, 0)
        endPos = UDim2.new((mp.X) / ss.X, 0, (mp.Y + ms.Y) / ss.Y, 0)
    else -- left
        startPos = UDim2.new((mp.X) / ss.X, 0, (mp.Y + ms.Y) / ss.Y, 0)
        endPos = UDim2.new((mp.X) / ss.X, 0, (mp.Y) / ss.Y, 0)
    end

    -- Bright spark dot
    local spark = makeFrame(particleFolder, {
        Size = UDim2.new(0, sparkSize, 0, sparkSize),
        Position = startPos,
        BackgroundColor3 = c.glow,
        BackgroundTransparency = 0,
        ZIndex = 60,
    })
    addCorner(spark, sparkSize)

    -- Spark glow halo
    local halo = makeFrame(particleFolder, {
        Size = UDim2.new(0, sparkSize * 4, 0, sparkSize * 4),
        Position = startPos,
        AnchorPoint = Vector2.new(0.3, 0.3),
        BackgroundColor3 = c.glow,
        BackgroundTransparency = 0.7,
        ZIndex = 59,
    })
    addCorner(halo, sparkSize * 4)

    local dur = 0.4 + math.random() * 0.4
    quickTween(spark, dur, { Position = endPos, BackgroundTransparency = 0.5 }, Enum.EasingStyle.Sine)
    quickTween(halo, dur, { Position = endPos, BackgroundTransparency = 1 }, Enum.EasingStyle.Sine)

    task.delay(dur, function()
        quickTween(spark, 0.15, { BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0) })
        task.delay(0.2, function() spark:Destroy(); halo:Destroy() end)
    end)
end

------------------------------------------------------------------------
--  TITLE AREA
------------------------------------------------------------------------
local titleRegion = makeFrame(mainFrame, {
    Name = "TitleRegion",
    Size = UDim2.new(1, 0, 0, 52),
    Position = UDim2.new(0, 0, 0, 8),
    ZIndex = 20,
})

local titleLabel = makeLabel(titleRegion, {
    Name = "Title",
    Size = UDim2.new(1, 0, 0, 32),
    Position = UDim2.new(0, 0, 0, 0),
    TextSize = 24,
    TextColor3 = ct().accent,
    Text = utf8.char(0x1F480) .. " SPOOKALICIOUS " .. utf8.char(0x1F480),
    ZIndex = 22,
})
local titleTextStroke = addStroke(titleLabel, ct().glow, 1.5, 0.3, Enum.ApplyStrokeMode.Contextual)

-- Title shimmer gradient (sweeping highlight)
local titleShimmer = Instance.new("UIGradient")
titleShimmer.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.new(1,1,1)),
    ColorSequenceKeypoint.new(0.4, Color3.new(1,1,1)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 240, 200)),
    ColorSequenceKeypoint.new(0.6, Color3.new(1,1,1)),
    ColorSequenceKeypoint.new(1, Color3.new(1,1,1)),
})
titleShimmer.Offset = Vector2.new(-1, 0)
titleShimmer.Parent = titleLabel

local glitchRed = makeLabel(titleRegion, {
    Name = "GR", Size = UDim2.new(1,0,0,32), Position = UDim2.new(0,0,0,0),
    TextSize = 24, TextColor3 = Color3.fromRGB(255,30,80),
    Text = utf8.char(0x1F480) .. " SPOOKALICIOUS " .. utf8.char(0x1F480), TextTransparency = 1, ZIndex = 21,
})
local glitchGreen = makeLabel(titleRegion, {
    Name = "GG", Size = UDim2.new(1,0,0,32), Position = UDim2.new(0,0,0,0),
    TextSize = 24, TextColor3 = Color3.fromRGB(60,255,140),
    Text = utf8.char(0x1F480) .. " SPOOKALICIOUS " .. utf8.char(0x1F480), TextTransparency = 1, ZIndex = 21,
})

local versionLabel = makeLabel(titleRegion, {
    Size = UDim2.new(1,0,0,16), Position = UDim2.new(0,0,0,32),
    TextSize = 14, TextColor3 = ct().accentDim, Text = "V4", ZIndex = 22,
})
addStroke(versionLabel, ct().border, 0.8, 0.55, Enum.ApplyStrokeMode.Contextual)

local titleLine = makeFrame(titleRegion, {
    Size = UDim2.new(0.4, 0, 0, 1),
    Position = UDim2.new(0.3, 0, 0, 46),
    BackgroundColor3 = ct().border,
    BackgroundTransparency = 0.45,
    ZIndex = 22,
})

local dragBtn = Instance.new("TextButton")
dragBtn.Size = UDim2.new(1, 0, 1, 0)
dragBtn.BackgroundTransparency = 1
dragBtn.Text = ""
dragBtn.ZIndex = 23
dragBtn.Parent = titleRegion

------------------------------------------------------------------------
--  SUBTITLE BANNER
------------------------------------------------------------------------
local subY = 66

local subtitleBanner = makeFrame(mainFrame, {
    Size = UDim2.new(1, -24, 0, 24),
    Position = UDim2.new(0, 12, 0, subY),
    BackgroundColor3 = ct().subtitleBg,
    BackgroundTransparency = 0.45,
    ZIndex = 20,
})
addCorner(subtitleBanner, 3)

local subtitleLabel = makeLabel(subtitleBanner, {
    Size = UDim2.new(1, 0, 1, 0),
    TextSize = 13,
    TextColor3 = ct().subtitleTxt,
    Text = utf8.char(0x1F383) .. " MAIN MENU " .. utf8.char(0x1F383),
    ZIndex = 21,
    Font = Enum.Font.Code,
    TextStrokeTransparency = 0.6,
    TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
})
addStroke(subtitleLabel, ct().bg, 1, 0.3, Enum.ApplyStrokeMode.Contextual)

-- Subtitle shimmer
local subShimmer = Instance.new("UIGradient")
subShimmer.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.new(1,1,1)),
    ColorSequenceKeypoint.new(0.45, Color3.new(1,1,1)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 220)),
    ColorSequenceKeypoint.new(0.55, Color3.new(1,1,1)),
    ColorSequenceKeypoint.new(1, Color3.new(1,1,1)),
})
subShimmer.Offset = Vector2.new(-1, 0)
subShimmer.Parent = subtitleLabel

local topSep = makeFrame(mainFrame, {
    Size = UDim2.new(1, -28, 0, 1),
    Position = UDim2.new(0, 14, 0, subY + 30),
    BackgroundColor3 = ct().border,
    BackgroundTransparency = 0.5,
    ZIndex = 20,
})
addGradient(topSep, NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.2, 0),
    NumberSequenceKeypoint.new(0.8, 0),
    NumberSequenceKeypoint.new(1, 1),
}))

------------------------------------------------------------------------
--  ITEMS SCROLLING FRAME
------------------------------------------------------------------------
local itemsY = subY + 36

local itemsFrame = Instance.new("ScrollingFrame")
itemsFrame.Name = "Items"
itemsFrame.Size = UDim2.new(1, -8, 0, 300)
itemsFrame.Position = UDim2.new(0, 4, 0, itemsY)
itemsFrame.BackgroundTransparency = 1
itemsFrame.BorderSizePixel = 0
itemsFrame.ScrollBarThickness = 3
itemsFrame.ScrollBarImageColor3 = ct().border
itemsFrame.ScrollBarImageTransparency = 0.4
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
    TextScaled = false,
    TextWrapped = false,
    ClipsDescendants = false,
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
    addConnection(UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end))
    addConnection(UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                State._userDragged = true
                State._lastPos = mainFrame.Position
            end
            dragging = false
        end
    end))
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
    addConnection(UIS.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - resizeStart
            local nw = math.clamp(startSize.X + d.X, MENU_MIN_W, MENU_MAX_W)
            mainFrame.Size = UDim2.new(0, nw, mainFrame.Size.Y.Scale, mainFrame.Size.Y.Offset)
        end
    end))
    addConnection(UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end))
end

------------------------------------------------------------------------
--  ELEMENT HEIGHT CONSTANTS
------------------------------------------------------------------------
local H_ITEM    = 36
local H_SLIDER  = 56
local H_TEXTBOX = 44
local H_DROP    = 38
local H_KEYBIND = 38
local H_SECTION = 24
local H_PAGE    = 36

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
        Active = true,  -- receive mouse input
    })
    addCorner(frame, 3)

    -- Mouse click to select + activate this item
    if item.type ~= "section_header" then
        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                State.sel = index
                doSelect()
            end
        end)
    end

    if sel then
        frame.BackgroundTransparency = 1
        quickTween(frame, 0.25, { BackgroundTransparency = 0.87 })

        -- Glow aura behind selected item
        local aura = makeFrame(frame, {
            Size = UDim2.new(1, 8, 1, 6),
            Position = UDim2.new(0, -4, 0, -3),
            BackgroundColor3 = c.glow,
            BackgroundTransparency = 0.92,
            ZIndex = 23,
        })
        addCorner(aura, 5)
        -- Pulse the aura
        task.spawn(function()
            while aura and aura.Parent do
                quickTween(aura, 0.8, { BackgroundTransparency = 0.85 })
                task.wait(0.8)
                if not aura or not aura.Parent then break end
                quickTween(aura, 0.8, { BackgroundTransparency = 0.94 })
                task.wait(0.8)
            end
        end)

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

        -- Selection arrow indicator (left side)
        local arrow = makeLabel(frame, {
            Size = UDim2.new(0, 16, 0, h),
            Position = UDim2.new(0, -2, 0, 0),
            Text = ">",
            TextSize = 14,
            TextColor3 = c.glow,
            TextTransparency = 0,
            ZIndex = 27,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        -- Bounce the arrow
        task.spawn(function()
            while arrow and arrow.Parent do
                quickTween(arrow, 0.4, { Position = UDim2.new(0, 2, 0, 0) }, Enum.EasingStyle.Sine)
                task.wait(0.4)
                if not arrow or not arrow.Parent then break end
                quickTween(arrow, 0.4, { Position = UDim2.new(0, -2, 0, 0) }, Enum.EasingStyle.Sine)
                task.wait(0.4)
            end
        end)
    end

    -- SECTION HEADER
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

    -- PAGE LINK
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

    -- TOGGLE
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

    -- SLIDER
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
        if sel then
            addStroke(thumb, c.accent, 1, 0.3)
        end

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

    -- BUTTON
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

    -- TEXTBOX
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

    -- DROPDOWN
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

    -- KEYBIND
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
            doSelect()
        end)
        btn.MouseEnter:Connect(function()
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
--  RENDER VIEW (FIXED: height capping + re-centering + footer)
------------------------------------------------------------------------
function renderView()
    clearItems()
    buildFlatItems()

    local items = State.flatItems
    if #items == 0 then return end

    State.sel = math.clamp(State.sel, 1, #items)

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

    -- Footer — compact version that fits in the panel width
    local bk = #State.stack > 0 and "BACK" or "CLOSE"
    footerLabel.Text = string.format(
        '<font color="#50ff90">ALT</font>Menu '..
        '<font color="#ffaa40">W/S</font>Nav '..
        '<font color="#ffaa40">A/D</font>Adj '..
        '<font color="#d8a0ff">F</font>Select '..
        '<font color="#ff4070">X</font>%s', bk
    )

    -- Render items
    local totalH = 0
    for i, item in ipairs(items) do
        local h = getItemHeight(item)
        createItemUI(i, item, totalH)
        totalH = totalH + h
    end

    itemsFrame.CanvasSize = UDim2.new(0, 0, 0, totalH)

    -- Auto-scroll to selected
    local selY = 0
    for i = 1, State.sel - 1 do selY = selY + getItemHeight(items[i]) end
    local viewH = itemsFrame.AbsoluteSize.Y
    if selY < itemsFrame.CanvasPosition.Y then
        itemsFrame.CanvasPosition = Vector2.new(0, selY)
    elseif selY + H_ITEM > itemsFrame.CanvasPosition.Y + viewH then
        itemsFrame.CanvasPosition = Vector2.new(0, selY + H_ITEM - viewH)
    end

    -- Calculate panel height: cap items area so panel doesn't exceed MENU_MAX_H
    local headerH = itemsY  -- space above items (title + subtitle + sep)
    local footerH = 8 + 32 + 12  -- bottom sep + footer + padding
    local maxItemsH = MENU_MAX_H - headerH - footerH
    local itemsH = math.min(totalH, maxItemsH)

    itemsFrame.Size = UDim2.new(1, -8, 0, itemsH)

    local totalFrameH = headerH + itemsH + footerH
    local newSize = UDim2.new(0, mainFrame.Size.X.Offset, 0, totalFrameH)

    -- Re-center panel vertically when height changes (unless user dragged it)
    local oldH = mainFrame.Size.Y.Offset
    mainFrame.Size = newSize

    if not State._userDragged and math.abs(totalFrameH - oldH) > 2 then
        -- Keep panel anchored from center of screen
        local screenH = gui.AbsoluteSize.Y
        local targetY = math.clamp((screenH - totalFrameH) / 2, 10, screenH - totalFrameH - 10)
        mainFrame.Position = UDim2.new(mainFrame.Position.X.Scale, mainFrame.Position.X.Offset, 0, targetY)
    else
        -- Clamp to screen bounds even if user dragged
        local screenH = gui.AbsoluteSize.Y
        local currentY = mainFrame.Position.Y.Offset
        if mainFrame.Position.Y.Scale > 0 then
            currentY = currentY + mainFrame.Position.Y.Scale * screenH
        end
        local clampedY = math.clamp(currentY, 10, math.max(10, screenH - totalFrameH - 10))
        if math.abs(clampedY - currentY) > 2 then
            mainFrame.Position = UDim2.new(mainFrame.Position.X.Scale, mainFrame.Position.X.Offset, 0, clampedY)
        end
    end

    botSep.Position = UDim2.new(0, 14, 0, itemsY + itemsH + 4)
    footerLabel.Position = UDim2.new(0, 6, 0, itemsY + itemsH + 8)

    -- Theme colors
    outerStroke.Color = c.border
    innerStroke.Color = c.border
    topGlare.BackgroundColor3 = c.glow
    fogA.BackgroundColor3 = c.fog
    fogB.BackgroundColor3 = c.fog
    titleLabel.TextColor3 = c.accent
    titleTextStroke.Color = c.glow
    versionLabel.TextColor3 = c.accentDim
    titleLine.BackgroundColor3 = c.border
    subtitleBanner.BackgroundColor3 = c.subtitleBg
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

------------------------------------------------------------------------
--  NAVIGATION LOGIC
------------------------------------------------------------------------
function doSelect()
    local item = State.flatItems[State.sel]
    if not item then return end

    if item.type == "page_link" then
        playSound("select")
        doScreenFlash(0.88, 0.25, ct().glow)
        doRipple(mainFrame, 0.5, (State.sel / math.max(#State.flatItems, 1)))
        table.insert(State.stack, State.currentView)
        State.currentView = item.pageId
        State.sel = 1
        renderView()

    elseif item.type == "toggle" then
        playSound("toggle", not item.value)  -- pass NEW state (before flip)
        item.value = not item.value
        doScreenFlash(0.92, 0.15, item.value and ct().onColor or ct().offColor)
        showToast(item.label .. ": " .. (item.value and "ON" or "OFF"))
        if item.callback then item.callback(item.value) end
        renderView()

    elseif item.type == "button" then
        playSound("select")
        doScreenFlash(0.9, 0.2, ct().glow)
        doRipple(mainFrame, 0.5, (State.sel / math.max(#State.flatItems, 1)))
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
        doScreenFlash(0.92, 0.2, ct().border)
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
local _closeVersion = 0

function toggleMenu(show)
    State.visible = show
    if show then
        _closeVersion = _closeVersion + 1  -- cancel any pending delayed hide
        State.currentView = "home"
        State.sel = 1
        State.stack = {}
        renderView()

        mainFrame.Visible = true
        hintFrame.Visible = false

        local menuW = mainFrame.Size.X.Offset
        local menuH = mainFrame.Size.Y.Offset
        local screenW = gui.AbsoluteSize.X
        local screenH = gui.AbsoluteSize.Y

        local targetPos
        if State._userDragged then
            targetPos = State._lastPos
            -- Clamp dragged position to screen
            local tY = targetPos.Y.Offset
            if targetPos.Y.Scale > 0 then
                tY = tY + targetPos.Y.Scale * screenH
            end
            tY = math.clamp(tY, 10, math.max(10, screenH - menuH - 10))
            targetPos = UDim2.new(targetPos.X.Scale, targetPos.X.Offset, 0, tY)
        else
            -- Center vertically, anchor to right side
            local centerY = math.clamp((screenH - menuH) / 2, 10, math.max(10, screenH - menuH - 10))
            targetPos = UDim2.new(1, -menuW - 16, 0, centerY)
        end

        mainFrame.Position = UDim2.new(1, 20, targetPos.Y.Scale, targetPos.Y.Offset)

        -- Slide in with bounce
        tween(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = targetPos,
            BackgroundTransparency = 1 - (State.opacity / 100),
        })

        -- Flash on open
        task.delay(0.1, function()
            doScreenFlash(0.75, 0.35, ct().glow)
        end)

        playSound("open")
        bindKeys()
    else
        _closeVersion = _closeVersion + 1
        local myVersion = _closeVersion
        hintFrame.Visible = true
        State._lastPos = mainFrame.Position

        -- Flash before close
        doScreenFlash(0.85, 0.15, ct().border)
        playSound("close")

        tween(mainFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 20, mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset),
            BackgroundTransparency = 1,
        })

        task.delay(0.25, function()
            if _closeVersion == myVersion then
                mainFrame.Visible = false
            end
        end)
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

------------------------------------------------------------------------
--  GLOBAL INPUT HANDLERS (WITH PROPER GP CHECKING)
------------------------------------------------------------------------

-- LeftAlt toggle (fixed with gp check)
addConnection(UIS.InputBegan:Connect(function(input, gp)
    if gp then return end  -- CRITICAL: Ignore if game processed (prevents chat conflicts)
    if input.KeyCode == Enum.KeyCode.LeftAlt and gui.Parent then
        toggleMenu(not State.visible)
    end
end))

-- Mouse scroll wheel to navigate items (fixed with gp check)
addConnection(UIS.InputChanged:Connect(function(input, gp)
    if not State.visible or gp then return end  -- CRITICAL: Check gp here too
    if input.UserInputType == Enum.UserInputType.MouseWheel then
        local items = State.flatItems
        local count = #items
        if count < 1 then return end
        
        local dir = input.Position.Z > 0 and -1 or 1  -- scroll up = prev, down = next
        playSound("nav")
        State.sel = State.sel + dir
        if State.sel < 1 then State.sel = count end
        if State.sel > count then State.sel = 1 end
        -- Skip section headers
        local tries = 0
        while items[State.sel] and items[State.sel].type == "section_header" and tries < count do
            State.sel = State.sel + dir
            if State.sel < 1 then State.sel = count end
            if State.sel > count then State.sel = 1 end
            tries = tries + 1
        end
        renderView()
    end
end))

------------------------------------------------------------------------
--  VISUAL EFFECTS LOOP
------------------------------------------------------------------------
local phase = 0
local holoTimer = 0
local shimmerOffset = -1
local heartbeatPhase = 0
local scanlineScroll = 0
local crtGlitchTimer = 0
local lightningTimer = 0

addConnection(RS.Heartbeat:Connect(function(dt)
    phase = phase + dt
    rainbowHue = (rainbowHue + dt * 0.08) % 1
    holoTimer = holoTimer + dt
    heartbeatPhase = heartbeatPhase + dt
    scanlineScroll = scanlineScroll + dt
    crtGlitchTimer = crtGlitchTimer + dt
    lightningTimer = lightningTimer + dt

    if not State.visible then return end
    local c = ct()

    if THEMES[State.colorIdx].name == "RAINBOW" then
        outerStroke.Color = c.border
        innerStroke.Color = c.border
        topGlare.BackgroundColor3 = c.glow
        fogA.BackgroundColor3 = c.fog
        fogB.BackgroundColor3 = c.fog
        titleLabel.TextColor3 = c.accent
        titleTextStroke.Color = c.glow
        versionLabel.TextColor3 = c.accentDim
        titleLine.BackgroundColor3 = c.border
        subtitleBanner.BackgroundColor3 = c.subtitleBg
        topSep.BackgroundColor3 = c.border
        botSep.BackgroundColor3 = c.border
        itemsFrame.ScrollBarImageColor3 = c.border
        resizeStroke.Color = c.border
        resizeIcon.TextColor3 = c.glow
    end

    -- ═══ HEARTBEAT BORDER PULSE (double-beat pattern) ═══
    local hbCycle = heartbeatPhase % 1.6  -- full cycle duration
    local hbPulse = 0
    if hbCycle < 0.1 then      -- first beat up
        hbPulse = hbCycle / 0.1
    elseif hbCycle < 0.2 then  -- first beat down
        hbPulse = 1 - (hbCycle - 0.1) / 0.1
    elseif hbCycle < 0.35 then -- second beat up
        hbPulse = (hbCycle - 0.2) / 0.15 * 0.7
    elseif hbCycle < 0.55 then -- second beat down
        hbPulse = 0.7 * (1 - (hbCycle - 0.35) / 0.2)
    end
    outerStroke.Transparency = 0.1 - hbPulse * 0.1
    outerStroke.Thickness = 2 + hbPulse * 1.5

    titleTextStroke.Transparency = 0.25 + math.sin(phase * 1.8) * 0.12
    topGlare.BackgroundTransparency = 0.92 + math.sin(phase * 1.1) * 0.015
    fogA.Position = UDim2.new(0.1 + math.sin(phase * 0.4) * 0.05, 0, 0.1 + math.cos(phase * 0.3) * 0.03, 0)
    fogB.Position = UDim2.new(0.4 - math.sin(phase * 0.4) * 0.05, 0, 0.5 - math.cos(phase * 0.3) * 0.03, 0)
    innerStroke.Transparency = 0.68 + math.sin(phase * 3) * 0.05

    -- ═══ ANIMATED SCANLINES (scroll downward) ═══
    if State.scanlines then
        scanlineOverlay.Visible = true
        local scrollY = (scanlineScroll * 40) % 32
        for i, bar in ipairs(scanlineBars) do
            bar.Position = UDim2.new(0, 0, 0, ((i - 1) * 32 + scrollY) % (15 * 32))
            bar.BackgroundTransparency = 0.88 + math.sin(phase * 3 + i * 0.8) * 0.04
        end
    else
        scanlineOverlay.Visible = false
    end

    -- ═══ HOLOGRAPHIC SWEEP (diagonal light bar every ~4s) ═══
    if holoTimer > 4 then
        holoTimer = 0
        holoSweep.BackgroundColor3 = c.glow
        holoSweep.Position = UDim2.new(-0.15, 0, -0.2, 0)
        holoSweep.BackgroundTransparency = 0.88
        quickTween(holoSweep, 0.7, {
            Position = UDim2.new(1.1, 0, -0.2, 0),
        }, Enum.EasingStyle.Quad)
        task.delay(0.7, function()
            holoSweep.BackgroundTransparency = 1
        end)
    end

    -- ═══ TITLE SHIMMER (gradient sweep every ~3s) ═══
    shimmerOffset = shimmerOffset + dt * 0.6
    if shimmerOffset > 2 then shimmerOffset = -1 end
    titleShimmer.Offset = Vector2.new(shimmerOffset, 0)
    -- Subtitle shimmer offset slightly behind title
    local subOffset = shimmerOffset - 0.3
    if subOffset > 2 then subOffset = -1 end
    subShimmer.Offset = Vector2.new(subOffset, 0)

    -- ═══ CRT CHROMATIC ABERRATION (random flicker) ═══
    if crtGlitchTimer > 3 + math.random() * 4 then
        crtGlitchTimer = 0
        crtLeft.BackgroundColor3 = Color3.fromRGB(255, 40, 80)
        crtRight.BackgroundColor3 = Color3.fromRGB(60, 200, 255)
        crtLeft.BackgroundTransparency = 0.88
        crtRight.BackgroundTransparency = 0.88

        task.delay(0.04 + math.random() * 0.06, function()
            crtLeft.BackgroundTransparency = 1
            crtRight.BackgroundTransparency = 1
        end)

        -- Occasional double-flicker
        if math.random() < 0.4 then
            task.delay(0.08, function()
                crtLeft.BackgroundTransparency = 0.9
                crtRight.BackgroundTransparency = 0.9
                task.delay(0.03, function()
                    crtLeft.BackgroundTransparency = 1
                    crtRight.BackgroundTransparency = 1
                end)
            end)
        end
    end

    -- ═══ VIGNETTE BREATHING ═══
    vigPulse.BackgroundTransparency = 0.95 + math.sin(phase * 0.8) * 0.03

    -- ═══ LIGHTNING CRACKS (rare, dramatic) ═══
    if lightningTimer > 6 + math.random() * 8 then
        lightningTimer = 0
        if State.particles then
            doLightningCrack()
            -- Brief white flash with lightning
            doScreenFlash(0.94, 0.08, c.glow)
        end
    end

    -- ═══ CHROMATIC GLITCH TITLE ═══
    if State.glitchTitle then
        if math.random() < 0.012 then
            local ox = (math.random() - 0.5) * 6
            local oy = (math.random() - 0.5) * 3
            glitchRed.Position = UDim2.new(0, ox, 0, 2 + oy)
            glitchRed.TextTransparency = 0.3
            glitchGreen.Position = UDim2.new(0, -ox, 0, 2 - oy)
            glitchGreen.TextTransparency = 0.35

            task.delay(0.05 + math.random() * 0.07, function()
                glitchRed.TextTransparency = 1
                glitchGreen.TextTransparency = 1
            end)
        end

        if math.random() < 0.002 then
            for _ = 1, 3 do
                local ox = (math.random() - 0.5) * 10
                glitchRed.Position = UDim2.new(0, ox, 0, 2)
                glitchRed.TextTransparency = 0.2
                glitchGreen.Position = UDim2.new(0, -ox, 0, 2)
                glitchGreen.TextTransparency = 0.25
                task.wait(0.03)
            end
            glitchRed.TextTransparency = 1
            glitchGreen.TextTransparency = 1
        end

        -- ═══ HORIZONTAL CRT JITTER (whole panel micro-shake) ═══
        if math.random() < 0.005 and State.visible then
            local origX = mainFrame.Position.X.Offset
            local origScale = mainFrame.Position.X.Scale
            local jitter = (math.random() - 0.5) * 4
            mainFrame.Position = UDim2.new(origScale, origX + jitter, mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset)
            task.delay(0.03, function()
                if State.visible then
                    mainFrame.Position = UDim2.new(origScale, origX, mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset)
                end
            end)
        end
    end
end))

task.spawn(function()
    while true do
        task.wait(0.4)
        if State.visible and THEMES[State.colorIdx].name == "RAINBOW" then
            renderView()
        end
    end
end)

------------------------------------------------------------------------
--  PARTICLE SYSTEMS
------------------------------------------------------------------------

-- Spooky symbols for floating text particles
local SPOOKY_SYMBOLS = {
    utf8.char(0x2620),  -- ☠
    utf8.char(0x1F480), -- 💀
    utf8.char(0x1F47B), -- 👻
    utf8.char(0x1F577), -- 🕷
    utf8.char(0x2606),  -- ☆
    utf8.char(0x263D),  -- ☽
    utf8.char(0x2605),  -- ★
    utf8.char(0x25C6),  -- ◆
    utf8.char(0x2666),  -- ♦
    utf8.char(0x00D7),  -- ×
}

-- ═══ BOTTOM RISING PARTICLES ═══
task.spawn(function()
    while true do
        task.wait(0.15 + math.random() * 0.25)
        if not State.visible or not State.particles then continue end
        local c = ct()
        local ss = gui.AbsoluteSize
        if ss.X < 1 then continue end
        local mp = mainFrame.AbsolutePosition
        local ms = mainFrame.AbsoluteSize

        local size = math.random(2, 5)
        local sx = (mp.X + math.random(0, math.floor(ms.X))) / ss.X
        local sy = (mp.Y + ms.Y + 5) / ss.Y

        local p = makeFrame(particleFolder, {
            Size = UDim2.new(0, size, 0, size),
            Position = UDim2.new(sx, 0, sy, 0),
            BackgroundColor3 = c.particle,
            BackgroundTransparency = 0.15 + math.random() * 0.2,
            ZIndex = 4,
        })
        addCorner(p, math.ceil(size/2))

        local dur = 2 + math.random() * 3.5
        quickTween(p, dur, {
            Position = UDim2.new(sx + (math.random()-0.5)*0.08, 0, sy - 0.12 - math.random()*0.12, 0),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 1, 0, 1),
        }, Enum.EasingStyle.Sine)
        task.delay(dur + 0.1, function() p:Destroy() end)
    end
end)

-- ═══ SIDE EDGE PARTICLES ═══
task.spawn(function()
    while true do
        task.wait(0.3 + math.random() * 0.5)
        if not State.visible or not State.particles then continue end
        local c = ct()
        local ss = gui.AbsoluteSize
        if ss.X < 1 then continue end
        local mp = mainFrame.AbsolutePosition
        local ms = mainFrame.AbsoluteSize

        local side = math.random() > 0.5 and 1 or 0
        local sx = (mp.X + side * ms.X) / ss.X
        local sy = (mp.Y + math.random() * ms.Y) / ss.Y
        local size = math.random(1, 3)

        local p = makeFrame(particleFolder, {
            Size = UDim2.new(0, size, 0, size),
            Position = UDim2.new(sx, 0, sy, 0),
            BackgroundColor3 = c.glow,
            BackgroundTransparency = 0.3,
            ZIndex = 4,
        })
        addCorner(p, size)

        local dur = 1.2 + math.random() * 2
        local drift = (side == 0 and -1 or 1) * (0.012 + math.random() * 0.025)
        quickTween(p, dur, {
            Position = UDim2.new(sx + drift, 0, sy - 0.015, 0),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 0, 0),
        })
        task.delay(dur + 0.1, function() p:Destroy() end)
    end
end)

-- ═══ INTERNAL AMBIENT PARTICLES ═══
task.spawn(function()
    while true do
        task.wait(0.4 + math.random() * 0.6)
        if not State.visible or not State.particles then continue end
        local c = ct()

        local size = math.random(1, 3)
        local p = makeFrame(mainFrame, {
            Size = UDim2.new(0, size, 0, size),
            Position = UDim2.new(math.random() * 0.9 + 0.05, 0, 0.95, 0),
            BackgroundColor3 = c.particle,
            BackgroundTransparency = 0.5,
            ZIndex = 47,
        })
        addCorner(p, size)

        local dur = 3 + math.random() * 4
        quickTween(p, dur, {
            Position = UDim2.new(p.Position.X.Scale + (math.random()-0.5)*0.15, 0, -0.05, 0),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 0, 0),
        }, Enum.EasingStyle.Sine)
        task.delay(dur + 0.1, function() p:Destroy() end)
    end
end)

-- ═══ FLOATING SPOOKY SYMBOLS (unique!) ═══
task.spawn(function()
    while true do
        task.wait(1.2 + math.random() * 2)
        if not State.visible or not State.particles then continue end
        local c = ct()
        local ss = gui.AbsoluteSize
        if ss.X < 1 then continue end
        local mp = mainFrame.AbsolutePosition
        local ms = mainFrame.AbsoluteSize

        local symbol = SPOOKY_SYMBOLS[math.random(1, #SPOOKY_SYMBOLS)]
        local sx = (mp.X + math.random(10, math.floor(ms.X) - 10)) / ss.X
        local sy = (mp.Y + ms.Y + 10) / ss.Y

        local lbl = makeLabel(particleFolder, {
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(sx, 0, sy, 0),
            Text = symbol,
            TextSize = math.random(10, 16),
            TextColor3 = c.particle,
            TextTransparency = 0.3 + math.random() * 0.2,
            ZIndex = 5,
            Rotation = math.random(-20, 20),
        })

        local dur = 3 + math.random() * 4
        local drift = (math.random() - 0.5) * 0.06
        local spin = math.random(-180, 180)
        quickTween(lbl, dur, {
            Position = UDim2.new(sx + drift, 0, sy - 0.15 - math.random() * 0.1, 0),
            TextTransparency = 1,
            Rotation = spin,
            Size = UDim2.new(0, 10, 0, 10),
        }, Enum.EasingStyle.Sine)
        task.delay(dur + 0.1, function() lbl:Destroy() end)
    end
end)

-- ═══ BORDER SPARK PARTICLES (traveling dots along edges) ═══
task.spawn(function()
    while true do
        task.wait(0.8 + math.random() * 1.5)
        if not State.visible or not State.particles then continue end
        doBorderSpark()
    end
end)

-- ═══ MATRIX CODE RAIN (falling characters inside panel) ═══
task.spawn(function()
    local matrixChars = "01アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン"
    local charList = {}
    for _, c in utf8.codes(matrixChars) do
        table.insert(charList, utf8.char(c))
    end

    while true do
        task.wait(0.08 + math.random() * 0.15)
        if not State.visible or not State.particles then continue end
        local c = ct()

        local col = math.random(1, 20)
        local colX = col / 20
        local fontSize = math.random(8, 11)

        local ch = charList[math.random(1, #charList)]
        local drop = makeLabel(matrixContainer, {
            Size = UDim2.new(0, 14, 0, 14),
            Position = UDim2.new(colX, 0, -0.03, 0),
            Text = ch,
            TextSize = fontSize,
            TextColor3 = c.particle,
            TextTransparency = 0.6 + math.random() * 0.2,
            ZIndex = 12,
            Font = Enum.Font.Code,
        })

        local dur = 1.5 + math.random() * 3
        quickTween(drop, dur, {
            Position = UDim2.new(colX, 0, 1.05, 0),
            TextTransparency = 1,
        }, Enum.EasingStyle.Linear)
        task.delay(dur + 0.1, function() drop:Destroy() end)
    end
end)

-- ═══ OCCASIONAL SCREEN TEAR EFFECT ═══
task.spawn(function()
    while true do
        task.wait(8 + math.random() * 12)
        if not State.visible or not State.particles then continue end
        local c = ct()

        -- Create a horizontal slice that shifts
        local tearY = math.random(10, 90) / 100
        local tearH = math.random(3, 8)
        local tear = makeFrame(mainFrame, {
            Size = UDim2.new(1, 10, 0, tearH),
            Position = UDim2.new(-0.02, 0, tearY, 0),
            BackgroundColor3 = c.bg,
            BackgroundTransparency = 0.3,
            ZIndex = 52,
            ClipsDescendants = true,
        })

        -- Shift it sideways
        local shiftDir = math.random() > 0.5 and 1 or -1
        quickTween(tear, 0.04, {
            Position = UDim2.new(shiftDir * 0.03, 0, tearY, 0),
        })

        task.delay(0.06 + math.random() * 0.04, function()
            tear:Destroy()
        end)

        -- Sometimes double-tear
        if math.random() < 0.4 then
            task.delay(0.03, function()
                local tearY2 = tearY + (math.random() - 0.5) * 0.1
                local tear2 = makeFrame(mainFrame, {
                    Size = UDim2.new(1, 10, 0, math.random(2, 5)),
                    Position = UDim2.new(shiftDir * -0.02, 0, tearY2, 0),
                    BackgroundColor3 = c.bg,
                    BackgroundTransparency = 0.4,
                    ZIndex = 52,
                })
                task.delay(0.05, function() tear2:Destroy() end)
            end)
        end
    end
end)

-- ═══ PULSE RING AROUND PANEL (expanding ring effect periodically) ═══
task.spawn(function()
    while true do
        task.wait(5 + math.random() * 5)
        if not State.visible or not State.particles then continue end
        local c = ct()
        local ss = gui.AbsoluteSize
        if ss.X < 1 then continue end
        local mp = mainFrame.AbsolutePosition
        local ms = mainFrame.AbsoluteSize

        -- Create expanding ring around the panel center
        local cx = (mp.X + ms.X / 2) / ss.X
        local cy = (mp.Y + ms.Y / 2) / ss.Y

        local ring = makeFrame(particleFolder, {
            Size = UDim2.new(0, ms.X * 0.5, 0, ms.Y * 0.5),
            Position = UDim2.new(cx, 0, cy, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            ZIndex = 3,
        })
        addCorner(ring, 8)
        local ringStroke = addStroke(ring, c.glow, 2, 0.4)

        quickTween(ring, 1.2, {
            Size = UDim2.new(0, ms.X * 1.3, 0, ms.Y * 1.3),
        }, Enum.EasingStyle.Quad)
        quickTween(ringStroke, 1.2, {
            Transparency = 1,
            Thickness = 0,
        }, Enum.EasingStyle.Quad)

        task.delay(1.3, function() ring:Destroy() end)
    end
end)

------------------------------------------------------------------------
--  PUBLIC API
------------------------------------------------------------------------
local Library = {}
Library.__index = Library

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

                addConnection(UIS.InputBegan:Connect(function(input, gp)
                    if gp then return end
                    if not State.visible and el.value and input.KeyCode == el.value then
                        if callback then callback(el.value) end
                    end
                end))

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
        _G.SpookaliciousV4Running = false
        _G.SpookaliciousV4Instance = nil
        State.visible = false
        unbindKeys()
        disconnectAll()
        gui:Destroy()
    end

    _G.SpookaliciousV4Instance = Window
    return Window
end

------------------------------------------------------------------------
--  INIT
------------------------------------------------------------------------
mainFrame.Visible = false
hintFrame.Visible = true
print("[SPOOKALICIOUS V4] Library loaded. Press LEFT ALT to open.")

return Library
