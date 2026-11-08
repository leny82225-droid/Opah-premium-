local P, W, CG, RS = game:GetService("Players"), game:GetService("Workspace"), game:GetService("CoreGui"), game:GetService("RunService")
local LP = P.LocalPlayer

local function createESP(obj, col, nm)
    if not obj:FindFirstChild("ESPHighlight") then
        local hl = Instance.new("Highlight", obj)
        hl.Name, hl.FillColor, hl.FillTransparency, hl.OutlineColor = "ESPHighlight", col, 0.4, Color3.new(1,1,1)
        local bb = Instance.new("BillboardGui", obj)
        bb.Name, bb.Size, bb.AlwaysOnTop, bb.StudsOffset = "ESPText", UDim2.new(0,150,0,30), true, Vector3.new(0,3,0)
        local lbl = Instance.new("TextLabel", bb)
        lbl.Size, lbl.BackgroundTransparency, lbl.Text, lbl.TextColor3, lbl.TextSize, lbl.Font = UDim2.new(1,0,1,0), 1, nm, col, 14, Enum.Font.SourceSansBold
    end
end

local function removeESP(obj)
    if obj:FindFirstChild("ESPHighlight") then obj.ESPHighlight:Destroy() end
    if obj:FindFirstChild("ESPText") then obj.ESPText:Destroy() end
end

local function getTargets(fName)
    local t = {}
    local f = W:FindFirstChild(fName)
    if f then
        for _, v in pairs(f:GetChildren()) do
            if v:IsA("BasePart") or (v:IsA("Model") and (v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart"))) then table.insert(t, v) end
        end
    end
    return t
end

local function tpTo(obj)
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local cf
        if obj:IsA("Model") then cf = obj.PrimaryPart and obj.PrimaryPart.CFrame or obj:FindFirstChildWhichIsA("BasePart").CFrame
        elseif obj:IsA("BasePart") then cf = obj.CFrame end
        if cf then LP.Character.HumanoidRootPart.CFrame = cf + Vector3.new(0,2,0) end
    end
end

local SG = Instance.new("ScreenGui", CG)
SG.Name, SG.ResetOnSpawn = "OpahLite", false
local MF = Instance.new("Frame", SG)
MF.Name, MF.Size, MF.Position, MF.BackgroundColor3, MF.Active, MF.Draggable = "MF", UDim2.new(0,220,0,400), UDim2.new(0.1,0,0.2,0), Color3.fromRGB(30,30,35), true, true
Instance.new("UICorner", MF).CornerRadius = UDim.new(0,8)

local Tl = Instance.new("TextLabel", MF)
Tl.Size, Tl.BackgroundColor3, Tl.Text, Tl.TextColor3, Tl.TextSize, Tl.Font = UDim2.new(1,0,0,35), Color3.fromRGB(45,45,50), "  OPAH ULTRA PRO", Color3.fromRGB(255,215,0), 14, Enum.Font.SourceSansBold

local SF = Instance.new("ScrollingFrame", MF)
SF.Size, SF.Position, SF.BackgroundTransparency, SF.CanvasSize, SF.ScrollBarThickness = UDim2.new(1,0,1,-35), UDim2.new(0,0,0,35), 1, UDim2.new(0,0,0,560), 4
local LY = Instance.new("UIListLayout", SF)
LY.SortOrder, LY.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0,6)
local PD = Instance.new("UIPadding", SF)
PD.PaddingTop, PD.PaddingLeft, PD.PaddingRight = UDim.new(0,10), UDim.new(0,10), UDim.new(0,10)

local MB = Instance.new("TextButton", MF)
MB.Size, MB.Position, MB.BackgroundColor3, MB.Text, MB.TextColor3, MB.TextSize, MB.Font = UDim2.new(0,30,0,25), UDim2.new(1,-35,0,5), Color3.fromRGB(60,60,70), "-", Color3.new(1,1,1), 16, Enum.Font.SourceSansBold
Instance.new("UICorner", MB).CornerRadius = UDim.new(0,4)

local mz = false
MB.MouseButton1Click:Connect(function()
    mz = not mz
    SF.Visible, MF.Size, MB.Text = not mz, mz and UDim2.new(0,220,0,35) or UDim2.new(0,220,0,400), mz and "+" or "-"
end)

local function btn(txt, cb)
    local b = Instance.new("TextButton", SF)
    b.Size, b.BackgroundColor3, b.Text, b.TextColor3, b.TextSize, b.Font = UDim2.new(1,0,0,36), Color3.fromRGB(50,50,60), txt, Color3.new(1,1,1), 13, Enum.Font.SourceSansBold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    b.MouseButton1Click:Connect(cb)
    return b
end

local oE, kE, cE, nC = false, false, false, false

local Esc = btn("🔥 INSTANT AUTO ESCAPE LOOPS", function()
    for _, v in pairs(W:GetChildren()) do
        if v.Name:find("Chest") or v.Name:find("TripleChest") or v.Name:find("DoubleChest") then
            for _, d in pairs(v:GetDescendants()) do
                if d:IsA("ProximityPrompt") then fireproximityprompt(d) elseif d:IsA("ClickDetector") then fireclickdetector(d) end
            end
        end
    end
    task.wait(0.8)
    local keys = getTargets("PuzzleItems")
    if #keys > 0 then
        for _, k in pairs(keys) do
            local ck = k:FindFirstChildWhichIsA("ClickDetector", true)
            if ck then
                tpTo(k) task.wait(0.2) fireclickdetector(ck) task.wait(0.2)
                local locks = getTargets("PuzzleLocks")
                if #locks > 0 then
                    for _, l in pairs(locks) do
                        local cl = l:FindFirstChildWhichIsA("ClickDetector", true)
                        if cl then tpTo(l) task.wait(0.25) fireclickdetector(cl) task.wait(0.25) break end
                    end
                end
            end
        end
    end
end)
Esc.BackgroundColor3, Esc.TextColor3 = Color3.fromRGB(180,40,40), Color3.fromRGB(255,230,100)

local oB = btn("Toggle ESP Opah: OFF", function()
    oE = not oE oB.Text = "Toggle ESP Opah: " .. (oE and "ON" or "OFF")
    oB.BackgroundColor3 = oE and Color3.fromRGB(200,50,50) or Color3.fromRGB(50,50,60)
    if not oE and W:FindFirstChild("OpahRuntime") then for _, v in pairs(W.OpahRuntime:GetChildren()) do removeESP(v) end end
end)

local kB = btn("Toggle ESP Kunci: OFF", function()
    kE = not kE kB.Text = "Toggle ESP Kunci: " .. (kE and "ON" or "OFF")
    kB.BackgroundColor3 = kE and Color3.fromRGB(50,150,50) or Color3.fromRGB(50,50,60)
    if not kE then for _, v in pairs(getTargets("PuzzleItems")) do removeESP(v) end end
end)

local cB = btn("Toggle ESP Kertas Kode: OFF", function()
    cE = not cE cB.Text = "Toggle ESP Kertas Kode: " .. (cE and "ON" or "OFF")
    cB.BackgroundColor3 = cE and Color3.fromRGB(50,120,150) or Color3.fromRGB(50,50,60)
    if not cE and W:FindFirstChild("PasscodeNote") then removeESP(W.PasscodeNote) end
end)

btn("🎒 Bring All Keys (Auto Grab)", function()
    local keys = getTargets("PuzzleItems")
    if #keys > 0 then
        local p = LP.Character.HumanoidRootPart.CFrame
        for _, k in pairs(keys) do
            local c = k:FindFirstChildWhichIsA("ClickDetector", true)
            if c then tpTo(k) task.wait(0.15) fireclickdetector(c) task.wait(0.1) end
        end
        LP.Character.HumanoidRootPart.CFrame = p
    end
end)

btn("🔢 Auto Enter Keypad Code", function()
    local n, k = W:FindFirstChild("PasscodeNote"), W:FindFirstChild("Keypad")
    if n and k then
        local txt = n:FindFirstChild("Code", true) or n:FindFirstChild("Text", true)
        if txt and txt:IsA("TextLabel") and txt.Text ~= "" then
            local pin = txt.Text tpTo(k) task.wait(0.3)
            for i = 1, #pin do
                local d = k:FindFirstChild(pin:sub(i,i), true)
                if d and d:FindFirstChildWhichIsA("ClickDetector") then fireclickdetector(d:FindFirstChildWhichIsA("ClickDetector")) task.wait(0.15) end
            end
            local ok = k:FindFirstChild("Oke", true) or k:FindFirstChild("Enter", true)
            if ok and ok:FindFirstChildWhichIsA("ClickDetector") then fireclickdetector(ok:FindFirstChildWhichIsA("ClickDetector")) end
        end
    end
end)

local sC
local sB = btn("⚡ Infinite Stamina: OFF", function()
    if not sC then
        sC = RS.Heartbeat:Connect(function()
            pcall(function()
                if LP:FindFirstChild("Stamina") then LP.Stamina.Value = 100 end
                if LP.Character and LP.Character:FindFirstChild("Stamina") then LP.Character.Stamina.Value = 100 end
            end)
        end)
        sB.Text, sB.BackgroundColor3 = "⚡ Infinite Stamina: ON", Color3.fromRGB(230,150,30)
    else
        sC:Disconnect() sC = nil
        sB.Text, sB.BackgroundColor3 = "⚡ Infinite Stamina: OFF", Color3.fromRGB(50,50,60)
    end
end)

local nB = btn("🧱 No Clip: OFF", function()
    nC = not nC nB.Text = "🧱 No Clip: " .. (nC and "ON" or "OFF")
    nB.BackgroundColor3 = nC and Color3.fromRGB(130,50,180) or Color3.fromRGB(50,50,60)
end)

RS.Stepped:Connect(function()
    if nC and LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

btn("🔓 Auto Buka Semua Laci", function()
    for _, v in pairs(W:GetChildren()) do
        if v.Name:find("Chest") or v.Name:find("TripleChest") or v.Name:find("DoubleChest") then
            for _, d in pairs(v:GetDescendants()) do
                if d:IsA("ProximityPrompt") then fireproximityprompt(d) elseif d:IsA("ClickDetector") then fireclickdetector(d) end
            end
        end
    end
end)

btn("✨ TP ke Kunci固定", function() local k = getTargets("PuzzleItems") if #k > 0 then tpTo(k[#k]) end end)
btn("📄 TP ke Kertas Kode", function() if W:FindFirstChild("PasscodeNote") then tpTo(W.PasscodeNote) end end)
btn("🔢 TP ke Keypad Pintu Utama", function() if W:FindFirstChild("Keypad") then tpTo(W.Keypad) end end)

task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            if oE and W:FindFirstChild("OpahRuntime") then
                for _, v in pairs(W.OpahRuntime:GetChildren()) do if v:IsA("Model") or v:IsA("BasePart") then createESP(v, Color3.new(1,0,0), "⚠️ OPAH ⚠️") end end
            end
            if kE then for _, v in pairs(getTargets("PuzzleItems")) do createESP(v, Color3.new(1,1,0), "🔑 Kunci") end end
            if cE and W:FindFirstChild("PasscodeNote") then createESP(W.PasscodeNote, Color3.new(0,1,1), "📄 Catatan Kode") end
        end)
    end
end)
