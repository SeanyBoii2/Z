-- Place this LocalScript in StarterPlayerScripts

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local lastHealth

-- Function to find the closest player
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (character.HumanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = otherPlayer
            end
        end
    end
    return closestPlayer
end

-- Teleport function with facing and offset adjustment
local function teleportBehindAndFace(target)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = target.Character.HumanoidRootPart.Position
        local offset = target.Character.HumanoidRootPart.CFrame.LookVector * -18 -- Adjusted to 15 studs back
        local newPosition = targetPosition + offset
        
        -- Set character position and rotation to face target
        character:SetPrimaryPartCFrame(CFrame.new(newPosition, targetPosition)) -- Teleport behind and face target
    end
end

-- Setup function to initialize everything for the character
local function setupCharacter(newCharacter)
    character = newCharacter
    local humanoid = character:WaitForChild("Humanoid")
    lastHealth = humanoid.Health

    humanoid.HealthChanged:Connect(function(newHealth)
        if newHealth < lastHealth then
            local closestPlayer = getClosestPlayer()
            teleportBehindAndFace(closestPlayer)
        end
        lastHealth = newHealth -- Update lastHealth to current health after checking
    end)
end

-- Initialize for the current character
if character then
    setupCharacter(character)
end

-- Reinitialize for new characters on respawn
player.CharacterAdded:Connect(function(newCharacter)
    setupCharacter(newCharacter)
end)
