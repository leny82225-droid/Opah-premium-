-- ========================================================
-- OPAH ULTRA LITE - ULTIMATE AUTO-ESCAPE EDITION
-- ========================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Fungsi Global Pembuat ESP Highlight
local function createESP(object, color, name)
    if not object:FindFirstChild("ESPHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.FillColor = color
        highlight.FillTransparency = 0.4
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0
        highlight.Adornee = object
        highlight.Parent = object

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESPText"
        billboard.Size = UDim2.new(0, 150, 0, 30)
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.Adornee = object
        billboard.Parent = object

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = color
        label.TextSize = 14
        label.Font = Enum.Font.SourceSansBold
        label.TextStrokeTransparency = 0
        label.Parent = billboard
    end
end

local function removeESP(object)
    if object:FindFirstChild("ESPHighlight") then object.ESPHighlight:Destroy() end
    if object:FindFirstChild("ESPText") then object.ESPText:Destroy() end
end

-- Ambil Target Kunci Valid di Map
local function getValidTargets(folderName)
    local targets = {}
    local folder = Workspace:FindFirstChild(folderName)
    if folder then
        for _, item in pairs(folder:GetChildren()) do
            if item:IsA("BasePart") or (item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart"))) then
                table.insert(targets, item)
            end
        end
    end
    return targets
end

-- Fungsi Teleportasi Aman
local function teleportTo(object)
    if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetCFrame
        if object:IsA("Model") then
            if object.PrimaryPart then targetCFrame = object.PrimaryPart.CFrame
            else local part = object:FindFirstChildWhichIsA("BasePart") if part then targetCFrame = part.CFrame end end
        elseif object:IsA("BasePart") then targetCFrame = object.CFrame end
        if targetCFrame then LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame + Vector3.new(0, 2, 0) end
    end
end

-- ========================================================
-- MEMBUAT LITE FLOATING GUI
-- ========================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OpahUltraLitePremium"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 400)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
Title.Text = "  OPAH ULTRA PRO"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Name = "ScrollingFrame"
ScrollingFrame.Size = UDim2.new(1, 0, 1, -35)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 35)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 560)
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 10)
Padding.PaddingLeft = UDim.new(0, 10)
Padding.PaddingRight = UDim.new(0, 10)
Padding.Parent = ScrollingFrame

local MiniBtn = Instance.new("TextButton")
MiniBtn.Size = UDim2.new(0, 30, 0, 25)
MiniBtn.Position = UDim2.new(1, -35, 0, 5)
MiniBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
MiniBtn.Text = "-"
MiniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniBtn.TextSize = 16
MiniBtn.Font = Enum.Font.SourceSansBold
MiniBtn.Parent = MainFrame

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 4)
MiniCorner.Parent = MiniBtn

local isMinimized = false
MiniBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        ScrollingFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 220, 0, 35)
        MiniBtn.Text = "+"
    else
        ScrollingFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 220, 0, 400)
        MiniBtn.Text = "-"
    end
end)

local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.SourceSansBold
    btn.BorderSizePixel = 0
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
    btn.Parent = ScrollingFrame
    return btn
end

local opahESPActive, keyESPActive, codeESPActive, noclipActive = false, false, false, false

-- ========================================================
-- FITUR DEWA BARU: INSTANT OPEN -> GRAB -> ESCAPE UNLOCK
-- ========================================================
local EscapeBtn = createButton("🔥 INSTANT AUTO ESCAPE LOOPS", function()
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj.Name:find("Chest") or obj.Name:find("TripleChest") or obj.Name:find("DoubleChest") then
            for _, descendant in pairs(obj:GetDescendants()) do
                if descendant:IsA("ProximityPrompt") then fireproximityprompt(descendant)
                elseif descendant:IsA("ClickDetector") then fireclickdetector(descendant) end
            end
        end
    end
    
    task.wait(0.8)
    
    local keys = getValidTargets("PuzzleItems")
    if #keys > 0 then
        for _, key in pairs(keys) do
            local clickKey = key:FindFirstChildWhichIsA("ClickDetector", true)
            if clickKey then
                teleportTo(key)
                task.wait(0.2)
                fireclickdetector(clickKey)
                task.wait(0.2)
                
                local locks = getValidTargets("PuzzleLocks")
                if #locks > 0 then
                    for _, lock in pairs(locks) do
                        local clickLock = lock:FindFirstChildWhichIsA("ClickDetector", true)
                        if clickLock then
                            teleportTo(lock)
                            task.wait(0.25)
                            fireclickdetector(clickLock)
                            task.wait(0.25)
                            break 
                        end
                    end
                end
            end
        end
    end
end)
EscapeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
EscapeBtn.TextColor3 = Color3.fromRGB(255, 230, 100)

-- ========================================================
-- PANEL TOMBOL PREMIUM LAINNYA
-- ========================================================
local OpahBtn = createButton("Toggle ESP Opah: OFF", function()
    opahESPActive = not opahESPActive
    OpahBtn.Text = "Toggle ESP Opah: " .. (opahESPActive and "ON" or "OFF")
    OpahBtn.BackgroundColor3 = opahESPActive and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(50, 50, 60)
    if not opahESPActive and Workspace:FindFirstChild("OpahRuntime") then
        for _, v in pairs(Workspace.OpahRuntime:GetChildren()) do removeESP(v) end
    end
end)

local KeyBtn = createButton("Toggle ESP Kunci: OFF", function()
    keyESPActive = not keyESPActive
    KeyBtn.Text = "Toggle ESP Kunci: " .. (keyESPActive and "ON" or "OFF")
    KeyBtn.BackgroundColor3 = keyESPActive and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(50, 50, 60)
    if not keyESPActive then for _, v in pairs(getValidTargets("PuzzleItems")) do removeESP(v) end end
end)

local CodeBtn = createButton("Toggle ESP Kertas Kode: OFF", function()
    codeESPActive = not codeESPActive
    CodeBtn.Text = "Toggle ESP Kertas Kode: " .. (codeESPActive and "ON" or "OFF")
    CodeBtn.BackgroundColor3 = codeESPActive and Color3.fromRGB(50, 120, 150) or Color3.fromRGB(50, 50, 60)
    if not codeESPActive and Workspace:FindFirstChild("PasscodeNote") then removeESP(Workspace.PasscodeNote) end
end)

createButton("🎒 Bring All Keys (Auto Grab)", function()
    local keys = getValidTargets("PuzzleItems")
    if #keys > 0 then
        local savedPos = LocalPlayer.Character.HumanoidRootPart.CFrame
        for _, key in pairs(keys) do
            local click = key:FindFirstChildWhichIsA("ClickDetector", true)
            if click then
                teleportTo(key)
                task.wait(0.15)
                fireclickdetector(click)
                task.wait(0.1)
            end
      end
      
