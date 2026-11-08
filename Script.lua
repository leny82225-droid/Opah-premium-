local P, W, CG, RS = game:GetService("Players"), game:GetService("Workspace"), game:GetService("CoreGui"), game:GetService("RunService")
local LP = P.LocalPlayer

-- Fungsi Teleportasi Objek (Memindahkan Kunci/Kode ke Depan Pintu Utama)
local function bringToExit(object)
    local keypad = W:FindFirstChild("Keypad")
    if keypad and object then
        local targetPart = keypad:IsA("Model") and (keypad.PrimaryPart or keypad:FindFirstChildWhichIsA("BasePart")) or keypad
        if targetPart then
            if object:IsA("Model") then
                if object.PrimaryPart then object.PrimaryPart.CFrame = targetPart.CFrame + Vector3.new(0, 2, 0)
                else local p = object:FindFirstChildWhichIsA("BasePart") if p then p.CFrame = targetPart.CFrame + Vector3.new(0, 2, 0) end end
            elseif object:IsA("BasePart") then
                object.CFrame = targetPart.CFrame + Vector3.new(0, 2, 0)
            end
        end
    end
end

local SG = Instance.new("ScreenGui", CG)
SG.Name, SG.ResetOnSpawn = "OpahMaju", false
local MF = Instance.new("Frame", SG)
MF.Name, MF.Size, MF.Position, MF.BackgroundColor3, MF.Active, MF.Draggable = "MF", UDim2.new(0, 220, 0, 160), UDim2.new(0.1, 0, 0.2, 0), Color3.fromRGB(35, 35, 40), true, true
Instance.new("UICorner", MF).CornerRadius = UDim.new(0, 8)

local Tl = Instance.new("TextLabel", MF)
Tl.Size, Tl.BackgroundColor3, Tl.Text, Tl.TextColor3, Tl.TextSize, Tl.Font = UDim2.new(1, 0, 0, 35), Color3.fromRGB(50, 50, 55), "  OPAH AUTO ESCAPE", Color3.fromRGB(255, 215, 0), 14, Enum.Font.SourceSansBold

local MB = Instance.new("TextButton", MF)
MB.Size, MB.Position, MB.BackgroundColor3, MB.Text, MB.TextColor3, MB.TextSize, MB.Font = UDim2.new(0, 30, 0, 25), UDim2.new(1, -35, 0, 5), Color3.fromRGB(70, 70, 80), "-", Color3.new(1, 1, 1), 16, Enum.Font.SourceSansBold
Instance.new("UICorner", MB).CornerRadius = UDim.new(0, 4)

local SF = Instance.new("Frame", MF)
SF.Size, SF.Position, SF.BackgroundTransparency = UDim2.new(1, 0, 1, -35), UDim2.new(0, 0, 0, 35), 1
local LY = Instance.new("UIListLayout", SF)
LY.SortOrder, LY.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 6)
local PD = Instance.new("UIPadding", SF)
PD.PaddingTop, PD.PaddingLeft, PD.PaddingRight = UDim.new(0, 10), UDim.new(0, 10), UDim.new(0, 10)

local mz = false
MB.MouseButton1Click:Connect(function()
    mz = not mz
    SF.Visible, MF.Size, MB.Text = not mz, mz and UDim2.new(0, 220, 0, 35) or UDim2.new(0, 220, 0, 160), mz and "+" or "-"
end)

local function btn(txt, cb)
    local b = Instance.new("TextButton", SF)
    b.Size, b.BackgroundColor3, b.Text, b.TextColor3, b.TextSize, b.Font = UDim2.new(1, 0, 0, 40), Color3.fromRGB(60, 60, 70), txt, Color3.new(1, 1, 1), 13, Enum.Font.SourceSansBold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(cb)
    return b
end

-- 1. TOMBOL UTAMA: BUKA LACI & BAWA SEMUA KUNCI + KODE KE PINTU UTAMA
local act = false
local mainBtn = btn("⚡ Aktifkan Auto Bring: OFF", function()
    act = not act
    mainBtn.Text = "⚡ Aktifkan Auto Bring: " .. (act and "ON" or "OFF")
    mainBtn.BackgroundColor3 = act and Color3.fromRGB(40, 140, 40) or Color3.fromRGB(60, 60, 70)
    
    if act then
        -- Buka semua laci (Chest) dekat maupun jauh sekaligus
        for _, v in pairs(W:GetChildren()) do
            if v.Name:find("Chest") or v.Name:find("TripleChest") or v.Name:find("DoubleChest") then
                for _, d in pairs(v:GetDescendants()) do
                    if d:IsA("ProximityPrompt") then fireproximityprompt(d)
                    elseif d:IsA("ClickDetector") then fireclickdetector(d) end
                end
            end
        end
        
        -- Tunggu sebentar agar item keluar dari laci
        task.wait(0.5)
        
        -- Bawa semua kunci ke depan pintu utama
        local items = W:FindFirstChild("PuzzleItems")
        if items then
            for _, k in pairs(items:GetChildren()) do bringToExit(k) end
        end
        
        -- Bawa kertas kode ke depan pintu utama
        local note = W:FindFirstChild("PasscodeNote")
        if note then bringToExit(note) end
    end
end)

-- 2. TOMBOL INSTANT TELEPORT KE PINTU UTAMA (UNTUK AMBIL ITEM)
btn("🔢 Teleport ke Pintu Utama", function()
    local keypad = W:FindFirstChild("Keypad")
    if keypad and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local p = keypad:IsA("Model") and (keypad.PrimaryPart or keypad:FindFirstChildWhichIsA("BasePart")) or keypad
        if p then LP.Character.HumanoidRootPart.CFrame = p.CFrame + Vector3.new(0, 3, 0) end
    end
end)
