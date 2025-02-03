local p=game:GetService("Players")
local r=game:GetService("RunService")
local uis=game:GetService("UserInputService")
local lp=p.LocalPlayer
local char=lp.Character or lp.CharacterAdded:Wait()
local t=false
local fConn=nil
local tE=false
local tK=Enum.KeyCode.X

local function f(trgHRP)
    if fConn then fConn:Disconnect() end
    fConn=r.RenderStepped:Connect(function()
        local hrp=char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame=trgHRP.CFrame*CFrame.new(0,0,3)
        end
    end)
end

local function u()
    if fConn then fConn:Disconnect() fConn=nil end
end

local function tpF(trg)
    if t then return end
    t=true
    local trgChar=trg.Character
    if not trgChar then return end
    local trgHRP=trgChar:FindFirstChild("HumanoidRootPart")
    local trgHum=trgChar:FindFirstChild("Humanoid")
    if trgHRP and trgHum then
        char:MoveTo(trgHRP.Position+trgHRP.CFrame.LookVector*-5)
        f(trgHRP)
        trgHum.Died:Connect(function()
            wait()
            u()
            t=false
            cP()
        end)
    else
        u()
        t=false
    end
end

local function cP()
    local hrp=char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _,plr in pairs(p:GetPlayers()) do
        if plr~=lp then
            local trgChar=plr.Character
            if trgChar then
                local trgHRP=trgChar:FindFirstChild("HumanoidRootPart")
                local trgHum=trgChar:FindFirstChild("Humanoid")
                if trgHRP and trgHum and trgHum.Health>0 then
                    local dist=(hrp.Position-trgHRP.Position).Magnitude
                    if dist<=12 then
                        tpF(plr)
                        return
                    end
                end
            end
        end
    end
    u()
end

local function tT()
    tE=not tE
    if tE then
        r.RenderStepped:Connect(function()
            if tE and not t then
                cP()
            end
        end)
    else
        u()
        t=false
    end
end

uis.InputBegan:Connect(function(input)
    if input.KeyCode==tK then
        tT()
    end
end)

lp.CharacterAdded:Connect(function(newChar)
    char=newChar
end)
