local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local SeedData = require(ReplicatedStorage.SharedModules.SeedData)
local PetData = require(ReplicatedStorage.SharedData.PetData)
local PackData = require(ReplicatedStorage.SharedModules.SeedPackData)

local SeedModule = ReplicatedStorage.SharedModules.SeedData
local SeedImages = SeedModule:WaitForChild("SeedImages")
local PlantImages = SeedModule:WaitForChild("PlantImages")
local FruitImages = SeedModule:WaitForChild("FruitImages")

local function GetImage(folder, name)
	local obj = folder:FindFirstChild(name)

	if obj and obj:IsA("StringValue") then
		return obj.Value
	end

	return ""
end

local function GetSeedImages(seedName)
	return {
		GetImage(SeedImages, seedName),
		GetImage(PlantImages, seedName),
		GetImage(FruitImages, seedName)
	}
end

local function safe(v)
	return tostring(v ~= nil and v or "?")
end

local function FormatNumber(num)
	num = tonumber(num) or 0

	local str = tostring(math.floor(num))

	while true do
		local formatted, count = str:gsub("^(-?%d+)(%d%d%d)", "%1.%2")
		str = formatted

		if count == 0 then
			break
		end
	end

	return str
end

local function FormatTime(seconds)
	seconds = tonumber(seconds)

	if not seconds then
		return "?"
	end

	local minutes = math.floor(seconds / 60)
	local remain = seconds % 60

	if minutes > 0 then
		return string.format("%dm %ds", minutes, remain)
	end

	return string.format("%ds", remain)
end

local function GetPetDescription(species, pet)
    local success, result = pcall(function()
        if type(pet.Description) == "string" then
            return pet.Description
        end

        if type(pet.Description) == "function" then
            return pet.Description("Normal", "Normal")
        end

        if PetData.GetDescription then
            return PetData.GetDescription(species, "Normal", "Normal")
        end

        return ""
    end)

    return success and tostring(result) or ""
end

local gui = Instance.new("ScreenGui")
gui.Name = "ModernDataUI"
gui.ResetOnSpawn = false
gui.Parent = gethui and gethui() or game.CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(650, 420)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
main.BackgroundTransparency = 0.3
main.BorderSizePixel = 0
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1
stroke.Transparency = 0.6
stroke.Color = Color3.fromRGB(120,120,120)
stroke.Parent = main

local top = Instance.new("Frame")
top.Size = UDim2.new(1,0,0,40)
top.BackgroundTransparency = 1
top.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-10,1,0)
title.Position = UDim2.fromOffset(10,0)
title.BackgroundTransparency = 1
title.Text = "Data Viewer"
title.TextColor3 = Color3.fromRGB(240,240,240)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = top

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1,0,0,40)
tabBar.Position = UDim2.fromOffset(0,40)
tabBar.BackgroundTransparency = 1
tabBar.Parent = main

local content = Instance.new("Frame")
content.Size = UDim2.new(1,0,1,-80)
content.Position = UDim2.fromOffset(0,80)
content.BackgroundTransparency = 1
content.Parent = main

local function createPage()
	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.fromScale(1,1)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 4
	scroll.CanvasSize = UDim2.new()
	scroll.Visible = false
	scroll.Parent = content

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0,6)
	layout.Parent = scroll

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scroll.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 10)
	end)

	return scroll
end

local SeedsPage = createPage()
local PetsPage = createPage()
local PacksPage = createPage()

SeedsPage.Visible = true

local function switch(page)
	for _,v in ipairs(content:GetChildren()) do
		if v:IsA("ScrollingFrame") then
			v.Visible = false
		end
	end
	page.Visible = true
end

local function createTab(text, x, page)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.fromOffset(120,28)
	btn.Position = UDim2.fromOffset(x,6)
	btn.BackgroundColor3 = Color3.fromRGB(35,35,45)
	btn.BackgroundTransparency = 0.2
	btn.TextColor3 = Color3.fromRGB(220,220,220)
	btn.Text = text
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 13
	btn.Parent = tabBar

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

	btn.MouseButton1Click:Connect(function()
		switch(page)
	end)
end

createTab("Seeds",10,SeedsPage)
createTab("Pets",140,PetsPage)
createTab("Packs",270,PacksPage)

local dragging = false
local dragInput
local dragStart
local startPos

top.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPos = main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

top.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		local delta = input.Position - dragStart

		main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)


local function addItem(parent, titleText, descText, images)
    local textSize = 12

    local bounds = game:GetService("TextService"):GetTextSize(
        tostring(descText),
        textSize,
        Enum.Font.Gotham,
        Vector2.new(540, math.huge)
    )

    local itemHeight = math.max(85, bounds.Y + 50)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, itemHeight)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    frame.BackgroundTransparency = 0.25
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Transparency = 0.4
    stroke.Color = Color3.fromRGB(80, 80, 90)
    stroke.Parent = frame

    local imageFrame = Instance.new("Frame")
imageFrame.Size = UDim2.fromOffset(200, 60)
imageFrame.Position = UDim2.fromOffset(10, 12)
imageFrame.BackgroundTransparency = 1
imageFrame.Parent = frame

for i = 1, 3 do
	local img = Instance.new("ImageLabel")
	img.Size = UDim2.fromOffset(60, 60)
	img.Position = UDim2.fromOffset((i - 1) * 65, 0)
	img.BackgroundTransparency = 1

	if images and images[i] and images[i] ~= "" then
		img.Image = images[i]
	end

	img.Parent = imageFrame
end

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -230, 0, 25)
    title.Position = UDim2.fromOffset(220, 8)
    title.BackgroundTransparency = 1
    title.RichText = true
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextColor3 = Color3.fromRGB(240,240,240)
    title.Text = tostring(titleText)
    title.Parent = frame

    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -230, 0, bounds.Y + 10)
    desc.Position = UDim2.fromOffset(220, 30)
    desc.BackgroundTransparency = 1
    desc.RichText = true
    desc.TextWrapped = true
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextYAlignment = Enum.TextYAlignment.Top
    desc.Font = Enum.Font.Gotham
    desc.TextSize = textSize
    desc.TextColor3 = Color3.fromRGB(190,190,190)
    desc.Text = tostring(descText)
    desc.Parent = frame
end

for _,v in ipairs(SeedData) do
	if v.SeedName then
		addItem(
			SeedsPage,
			v.SeedName,
			("Rarity: %s\nPrice: %s Sheckles\nGrow: %s")
			:format(
				safe(v.Rarity),
				FormatNumber(v.PurchasePrice),
				FormatTime(v.PrimeTime)
			),
			GetSeedImages(v.SeedName)
		)
	end
end

for _,v in pairs(PetData) do
	if type(v) == "table" and v.DisplayName then
		local info =
    ("Rarity: %s\nSpawn: %s%%\nPrice: %s\n\n%s")
    :format(
        safe(v.Rarity),
        safe(v.SpawnChance),
        FormatNumber(v.BasePrice) .. " Sheckles",
        GetPetDescription(v.DisplayName, v)
    )

addItem(
	PetsPage,
	v.DisplayName,
	info,
	{type(v.Image) == "string" and v.Image or ""}
)
	end
end

if PackData and PackData.Data then
	for _,v in ipairs(PackData.Data) do
		addItem(
	PacksPage,
	safe(v.PackName),
	safe(v.Rarity or "Pack"),
	{type(v.IMG) == "string" and v.IMG or ""}
)
	end
end

print("Loaded Seeds:", #SeedData)
print("Loaded Packs:", PackData.Data and #PackData.Data or 0)
