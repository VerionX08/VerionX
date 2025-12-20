local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "Verion Hub",
    Icon = "moon", -- lucide icon. optional
    Author = "by VerionX", -- optional
   Size = UDim2.fromOffset(580, 460),
   Resizable = true,
Transparent = true,
BackgroundImageTransparency = 0.8,
Background = "rbxassetid://97239349377509",
  
})

Window:EditOpenButton({
    Enabled = false,
})
local gui = Instance.new("ScreenGui")
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Nút chính
local btn = Instance.new("ImageButton")
btn.Parent = gui
btn.Size = UDim2.new(0, 50, 0, 50)
btn.Position = UDim2.new(0.5, -25, 0.5, -25)
btn.BackgroundTransparency = 1
btn.Draggable = true
btn.Image = "rbxassetid://97239349377509"
btn.ScaleType = Enum.ScaleType.Fit

-- Bo tròn nhẹ ImageButton
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 15)
btnCorner.Parent = btn

-- Cooldown setup
local canClick = true
local cooldown = 0.08

btn.MouseButton1Click:Connect(function()
    if canClick then
        canClick = false
        Window:Toggle()
        task.wait(cooldown)
        canClick = true
    end
end)

-- Viền gradient
local border = Instance.new("Frame")
border.Parent = btn
border.Size = UDim2.new(1, 4, 1, 4)
border.Position = UDim2.new(0, -2, 0, -2)
border.BackgroundTransparency = 0
border.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
border.ZIndex = btn.ZIndex - 1
border.ClipsDescendants = true

-- Bo tròn nhẹ viền
local borderCorner = Instance.new("UICorner")
borderCorner.CornerRadius = UDim.new(0, 15)
borderCorner.Parent = border

-- Gradient xoay
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromHex("0066CC")),
    ColorSequenceKeypoint.new(1, Color3.fromHex("FFFFFF")),
}
gradient.Parent = border

task.spawn(function()
    while true do
        for i = 0, 360 do
            gradient.Rotation = i
            task.wait(0.01)
        end
    end
end)

local GaG_Tab = Window:Tab({
Title = "GaG Tab",
Icon = "tree-palm",
})

_G.sword = false

GaG_Tab:Toggle({
    Title = "Auto Giant Sword",
    Icon = "sword",
Desc = "Auto Admin Weather",
    Default = false,
    Callback = function(state)
        _G.sword = state

        while _G.sword do
coroutine.wrap(function()
            game:GetService("ReplicatedStorage")
                :WaitForChild("GameEvents")
                :WaitForChild("GiantSwordPull")
                :InvokeServer()
end)()
task.wait(0.01)
        end
    end,
})
_G.seed = false
local Toggle = GaG_Tab:Toggle({
    Title = "Dupe Frostspike",
    Desc = "idk why I created this",
    Icon = "snowflake",
    Value = false, -- default value
    Callback = function(state) 
        _G.seed = state

while _G.seed do
local prompt1 = workspace.WeatherVisuals.Pillars.Pillar_1.Offering.ProximityPrompt
local prompt2 = workspace.WeatherVisuals.Pillars.Pillar_2.Offering.ProximityPrompt
local prompt3 = workspace.WeatherVisuals.Pillars.Pillar_3.Offering.ProximityPrompt
local prompt4 = workspace.WeatherVisuals.Pillars.Pillar_4.Offering.ProximityPrompt
local prompt5 = workspace.WeatherVisuals.Pillars.Pillar_5.Offering.ProximityPrompt

fireproximityprompt(prompt1)
task.wait(0.5)
fireproximityprompt(prompt2)
task.wait(0.5)
fireproximityprompt(prompt3)
task.wait(0.5)
fireproximityprompt(prompt4)
task.wait(0.5)
fireproximityprompt(prompt5)
    end
end,
})
local SaB_Tab = Window:Tab({
        Title = "SaB Tab",
        Icon = "rabbit",
    })
        
