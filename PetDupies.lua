local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Allowed pet names for duplication
local allowedPets = {
    Raccoon = true,
    RedFox = true,
    DragonFly = true,
    QueenBee = true,
    DiscoBee = true,
    BearBee = true,
    GoldenLab = true,
    Dog = true,
    Bunny = true,
    Caterpillar = true,
    GiantAnt = true,
    Mole = true,
    Hedgehog = true
}

-- Create GUI container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DupePetUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Helper: make frames draggable on PC and Mobile
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                math.clamp(startPos.X.Offset + delta.X, 0, workspace.CurrentCamera.ViewportSize.X - frame.AbsoluteSize.X),
                startPos.Y.Scale,
                math.clamp(startPos.Y.Offset + delta.Y, 0, workspace.CurrentCamera.ViewportSize.Y - frame.AbsoluteSize.Y)
            )
        end
    end)
end

-- Helper: rainbow gradient
local function createRainbowGradient(instance)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.20, Color3.fromRGB(255, 165, 0)),
        ColorSequenceKeypoint.new(0.40, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.80, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 255))
    })
    gradient.Parent = instance
end

-- Function to get current pet name from player
local function getCurrentPetName()
    local petNameValue = player:FindFirstChild("CurrentPetName")
    if petNameValue and petNameValue:IsA("StringValue") then
        return petNameValue.Value
    end
    return nil
end

-- Function to find the pet model instance by name in Pets folder
local function findPetModel(petName)
    local petsFolder = player:FindFirstChild("Pets")
    if not petsFolder then return nil end

    for _, pet in pairs(petsFolder:GetChildren()) do
        if pet.Name == petName then
            return pet
        end
    end

    return nil
end

-- ===== KEY PAGE UI =====
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 300, 0, 150)
KeyFrame.Position = UDim2.new(0, 300, 0, 200)
KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyFrame.Active = true
KeyFrame.Parent = ScreenGui
makeDraggable(KeyFrame)
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 10)

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "Enter Key"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.Font = Enum.Font.SourceSansBold
KeyTitle.TextSize = 24
KeyTitle.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.8, 0, 0.3, 0)
KeyBox.Position = UDim2.new(0.1, 0, 0.4, 0)
KeyBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.Text = ""
KeyBox.PlaceholderText = "Enter the key here..."
KeyBox.Font = Enum.Font.SourceSans
KeyBox.TextSize = 22
KeyBox.ClearTextOnFocus = false
KeyBox.Parent = KeyFrame

local KeySubmit = Instance.new("TextButton")
KeySubmit.Size = UDim2.new(0.5, 0, 0.25, 0)
KeySubmit.Position = UDim2.new(0.25, 0, 0.75, 0)
KeySubmit.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
KeySubmit.Text = "Submit"
KeySubmit.Font = Enum.Font.SourceSansBold
KeySubmit.TextSize = 24
KeySubmit.Parent = KeyFrame

local KeyError = Instance.new("TextLabel")
KeyError.Size = UDim2.new(1, 0, 0, 25)
KeyError.Position = UDim2.new(0, 0, 1, -25)
KeyError.Text = ""
KeyError.TextColor3 = Color3.fromRGB(255, 0, 0)
KeyError.Font = Enum.Font.SourceSansBold
KeyError.TextSize = 18
KeyError.BackgroundTransparency = 1
KeyError.Visible = false
KeyError.Parent = KeyFrame

-- ===== MAIN UI =====
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 150)
MainFrame.Position = UDim2.new(0, 300, 0, 200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
makeDraggable(MainFrame)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "KheasHub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 24
Title.Parent = MainFrame

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0.8, 0, 0.3, 0)
Button.Position = UDim2.new(0.1, 0, 0.4, 0)
Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Button.Text = "DUPE PET"
Button.Font = Enum.Font.SourceSansBold
Button.TextSize = 28
Button.Parent = MainFrame
createRainbowGradient(Button)

local Prompt = Instance.new("TextLabel")
Prompt.Size = UDim2.new(1, 0, 0, 25)
Prompt.Position = UDim2.new(0, 0, 1, -25)
Prompt.Text = "SUCCESFULLY DUPED PET"
Prompt.TextColor3 = Color3.fromRGB(0, 255, 0)
Prompt.Font = Enum.Font.SourceSansBold
Prompt.TextSize = 20
Prompt.BackgroundTransparency = 1
Prompt.Visible = false
Prompt.Parent = MainFrame

local HideButton = Instance.new("TextButton")
HideButton.Size = UDim2.new(0, 30, 0, 30)
HideButton.Position = UDim2.new(1, -35, 0, 5)
HideButton.BackgroundTransparency = 1
HideButton.Text = "x"
HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HideButton.Font = Enum.Font.SourceSans
HideButton.TextSize = 16
HideButton.Parent = MainFrame

-- Mini Window (circle with K)
local MiniFrame = Instance.new("Frame")
MiniFrame.Size = UDim2.new(0, 40, 0, 40)
MiniFrame.Position = UDim2.new(0, 100, 0, 100)
MiniFrame.BackgroundColor3 = Color3.new(0, 0, 0) -- black background
MiniFrame.Visible = false
MiniFrame.Active = true
MiniFrame.Parent = ScreenGui
makeDraggable(MiniFrame)
Instance.new("UICorner", MiniFrame).CornerRadius = UDim.new(0, 20) -- circle

local MiniLabel = Instance.new("TextLabel")
MiniLabel.Size = UDim2.new(1, 0, 1, 0)
MiniLabel.Text = "K"
MiniLabel.Font = Enum.Font.GothamBlack
MiniLabel.TextColor3 = Color3.new(1, 1, 1) -- white
MiniLabel.BackgroundTransparency = 1
MiniLabel.TextScaled = true
MiniLabel.Parent = MiniFrame

local MiniClickZone = Instance.new("TextButton")
MiniClickZone.Size = UDim2.new(1, 0, 1, 0)
MiniClickZone.BackgroundTransparency = 1
MiniClickZone.Text = ""
MiniClickZone.Parent = MiniFrame

-- ===== LOGIC =====

-- Key submission
KeySubmit.MouseButton1Click:Connect(function()
    local enteredKey = KeyBox.Text
    if enteredKey == "ILOVEISLY" then
        KeyFrame.Visible = false
        MainFrame.Visible = true
    else
        KeyError.Text = "Incorrect Key! Try again."
        KeyError.Visible = true
        task.delay(2, function()
            KeyError.Visible = false
        end)
    end
end)

-- Hide / Show main UI
HideButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniFrame.Visible = true
end)

MiniClickZone.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MiniFrame.Visible = false
end)

-- Duplication logic
Button.MouseButton1Click:Connect(function()
    local currentPet = getCurrentPetName()
    if currentPet and allowedPets[currentPet] then
        local petModel = findPetModel(currentPet)
        if petModel then
            local clonedPet = petModel:Clone()
            -- If pet has 'Equipped' BoolValue, set clone to false (unequipped)
            local equippedVal = clonedPet:FindFirstChild("Equipped")
            if equippedVal and equippedVal:IsA("BoolValue") then
                equippedVal.Value = false
            end
            clonedPet.Parent = player:FindFirstChild("Pets") or player
            Prompt.Visible = true
            task.delay(2, function()
                Prompt.Visible = false
            end)

            -- Button click tween animation
            Button:TweenSize(UDim2.new(0.8, 0, 0.25, 0), "Out", "Quad", 0.1, true, function()
                Button:TweenSize(UDim2.new(0.8, 0, 0.3, 0), "Out", "Quad", 0.1, true)
            end)
        else
            warn("Pet model not found for duplication.")
        end
    else
        warn("Player is not holding a valid pet to duplicate.")
    end
end)
