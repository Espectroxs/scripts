local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

local function getParent()
    local ok, hui = pcall(function()
        return gethui()
    end)

    if ok and hui then
        return hui
    end

    return player:WaitForChild("PlayerGui")
end

local GUI_NAME = "SimpleFPSBoostUI"

if getParent():FindFirstChild(GUI_NAME) then
    getParent():FindFirstChild(GUI_NAME):Destroy()
end

local function ApplyLowGraphics()
    for _, v in ipairs(game:GetDescendants()) do
        pcall(function()
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                v.Enabled = false
            end

            if v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            end

            if v:IsA("Sound") then
                v.Volume = 0
            end

            if v:IsA("BasePart") then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
                v.CastShadow = false
            end
        end)
    end

    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.Brightness = 1
        Lighting.FogEnd = 9e9
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
    end)

    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)
end

ApplyLowGraphics()

game.DescendantAdded:Connect(function(v)
    task.wait()

    pcall(function()
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
            v.Enabled = false
        end

        if v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        end

        if v:IsA("Sound") then
            v.Volume = 0
        end

        if v:IsA("BasePart") then
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
            v.CastShadow = false
        end
    end)
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = GUI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = getParent()

local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.new(0, 210, 0, 105)
Main.Position = UDim2.new(0.5, -105, 0.25, 0)
Main.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local Corner = Instance.new("UICorner")
Corner.Parent = Main
Corner.CornerRadius = UDim.new(0, 8)

local Stroke = Instance.new("UIStroke")
Stroke.Parent = Main
Stroke.Color = Color3.fromRGB(90, 210, 120)
Stroke.Thickness = 1

local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.Size = UDim2.new(1, -40, 0, 32)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "FPS BOOST ATIVO"
Title.Font = Enum.Font.Code
Title.TextSize = 15
Title.TextColor3 = Color3.fromRGB(90, 210, 120)
Title.TextXAlignment = Enum.TextXAlignment.Left

local Close = Instance.new("TextButton")
Close.Parent = Main
Close.Size = UDim2.new(0, 28, 0, 28)
Close.Position = UDim2.new(1, -34, 0, 4)
Close.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Close.Text = "X"
Close.Font = Enum.Font.Code
Close.TextSize = 14
Close.TextColor3 = Color3.fromRGB(255, 90, 90)
Close.BorderSizePixel = 0
Close.AutoButtonColor = false

local CloseCorner = Instance.new("UICorner")
CloseCorner.Parent = Close
CloseCorner.CornerRadius = UDim.new(0, 6)

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local Status = Instance.new("TextLabel")
Status.Parent = Main
Status.Size = UDim2.new(1, -20, 0, 24)
Status.Position = UDim2.new(0, 10, 0, 35)
Status.BackgroundTransparency = 1
Status.Text = "[system] gráficos reduzidos"
Status.Font = Enum.Font.Code
Status.TextSize = 12
Status.TextColor3 = Color3.fromRGB(180, 180, 180)
Status.TextXAlignment = Enum.TextXAlignment.Left

local Reapply = Instance.new("TextButton")
Reapply.Parent = Main
Reapply.Size = UDim2.new(1, -20, 0, 34)
Reapply.Position = UDim2.new(0, 10, 0, 62)
Reapply.BackgroundColor3 = Color3.fromRGB(18, 38, 24)
Reapply.Text = "REAPLICAR BOOST"
Reapply.Font = Enum.Font.Code
Reapply.TextSize = 13
Reapply.TextColor3 = Color3.fromRGB(90, 210, 120)
Reapply.BorderSizePixel = 0
Reapply.AutoButtonColor = false

local ReapplyCorner = Instance.new("UICorner")
ReapplyCorner.Parent = Reapply
ReapplyCorner.CornerRadius = UDim.new(0, 6)

Reapply.MouseButton1Click:Connect(function()
    ApplyLowGraphics()

    Status.Text = "[system] boost reaplicado"

    TweenService:Create(Reapply, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(30, 70, 40)
    }):Play()

    task.wait(0.15)

    TweenService:Create(Reapply, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(18, 38, 24)
    }):Play()
end)
