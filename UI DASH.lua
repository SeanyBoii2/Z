local p = game:GetService("Players")
local r = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local lp = p.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()

local t = false -- is teleport active on a player
local fConn = nil -- following connection
local tE = false -- toggle state
local tK = Enum.KeyCode.X
local loopConn = nil -- main loop connection
local diedConn = nil -- track current target's died connection

local function f(trgHRP)
    if fConn then fConn:Disconnect() end
    fConn = r.RenderStepped:Connect(function()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = trgHRP.CFrame * CFrame.new(0, 0, 3)
        end
    end)
end

local function u()
    if fConn then 
        fConn:Disconnect() 
        fConn = nil 
    end
    if diedConn then
        diedConn:Disconnect()
        diedConn = nil
    end
end

local function tpF(trg)
    if t then return end
    t = true
    local trgChar = trg.Character
    if not trgChar then return end

    local trgHRP = trgChar:FindFirstChild("HumanoidRootPart")
    local trgHum = trgChar:FindFirstChild("Humanoid")

    if trgHRP and trgHum then
        char:MoveTo(trgHRP.Position + trgHRP.CFrame.LookVector * -5)
        f(trgHRP)
        diedConn = trgHum.Died:Connect(function()
            task.wait()
            u()
            t = false
            if tE then -- only keep going if toggle is on
                cP()
            end
        end)
    else
        u()
        t = false
    end
end

function cP()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local closestPlayer = nil
    local closestDist = math.huge

    for _,plr in pairs(p:GetPlayers()) do
        if plr ~= lp then
            local trgChar = plr.Character
            if trgChar then
                local trgHRP = trgChar:FindFirstChild("HumanoidRootPart")
                local trgHum = trgChar:FindFirstChild("Humanoid")
                if trgHRP and trgHum and trgHum.Health > 0 then
                    local dist = (hrp.Position - trgHRP.Position).Magnitude
                    if dist < closestDist and dist <= 35 then
                        closestDist = dist
                        closestPlayer = plr
                    end
                end
            end
        end
    end

    if closestPlayer then
        tpF(closestPlayer)
    else
        u()
        t = false
    end
end

local function tT()
    tE = not tE
    if tE then
        if loopConn then loopConn:Disconnect() end
        loopConn = r.RenderStepped:Connect(function()
            if tE and not t then
                cP()
            end
        end)
    else
        if loopConn then 
            loopConn:Disconnect() 
            loopConn = nil 
        end
        u()
        t = false
    end
end

uis.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == tK then
        tT()
    end
end)

lp.CharacterAdded:Connect(function(newChar)
    char = newChar
end)
