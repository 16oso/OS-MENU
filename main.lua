-- ============================================
-- TL MENU v6 â€” AudioCrafter Style
-- Purple Â· Cards Â· Bottom Tabs Â· Dark Glass
-- Einzeldatei fÃ¼r Executor (Xeno)
-- ============================================
if not game:IsLoaded() then game.Loaded:Wait() end

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- [1] SERVICES
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace        = game:GetService("Workspace")
local Lighting         = game:GetService("Lighting")
local CoreGui          = game:GetService("CoreGui")
local TeleportService  = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Camera      = Workspace.CurrentCamera
local Character, Humanoid, HRP

local function updateChar()
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    Humanoid  = Character:WaitForChild("Humanoid")
    HRP       = Character:WaitForChild("HumanoidRootPart")
end
updateChar()
LocalPlayer.CharacterAdded:Connect(function(c)
    Character = c
    Humanoid  = c:WaitForChild("Humanoid")
    HRP       = c:WaitForChild("HumanoidRootPart")
end)

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- [2] THEME / PALETTE
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local T = {
    -- Backgrounds (warm dark)
    BG          = Color3.fromRGB(10, 8, 14),
    Panel       = Color3.fromRGB(14, 11, 20),
    Card        = Color3.fromRGB(20, 15, 28),
    CardHover   = Color3.fromRGB(28, 20, 38),

    -- Primary Accents (Purple -> Orange)
    Purple      = Color3.fromRGB(148, 43, 255),
    PurpleLight = Color3.fromRGB(178, 90, 255),
    PurpleDim   = Color3.fromRGB(90, 25, 160),
    Orange      = Color3.fromRGB(255, 110, 35),
    OrangeLight = Color3.fromRGB(255, 150, 70),
    Pink        = Color3.fromRGB(255, 65, 130),

    -- Neutral
    White       = Color3.fromRGB(255, 255, 255),

    -- Typography
    TextPure    = Color3.fromRGB(255, 255, 255),
    TextMain    = Color3.fromRGB(225, 215, 240),
    TextSec     = Color3.fromRGB(155, 140, 175),
    TextMuted   = Color3.fromRGB(85, 72, 108),

    -- Semantic
    Success     = Color3.fromRGB(45, 215, 125),
    Danger      = Color3.fromRGB(255, 65, 75),
    Warning     = Color3.fromRGB(255, 175, 35),

    -- Borders
    Border      = Color3.fromRGB(55, 35, 80),
    BorderMid   = Color3.fromRGB(95, 55, 145),

    -- Tab Bar
    TabActive   = Color3.fromRGB(255, 255, 255),
    TabBG       = Color3.fromRGB(22, 16, 34),

    -- Decorative Dots (summer vibes)
    Dot1        = Color3.fromRGB(255, 110, 35),
    Dot2        = Color3.fromRGB(148, 43, 255),
    Dot3        = Color3.fromRGB(255, 175, 70),
}

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- [3] HELPER FUNKTIONEN
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local function tw(obj, props, dur, style, dir)
    TweenService:Create(obj, TweenInfo.new(dur or 0.2, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props):Play()
end
local function cr(obj, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 8); c.Parent = obj; return c
end
local function st(obj, col, thick, trans)
    local s = Instance.new("UIStroke"); s.Color = col or T.Border; s.Thickness = thick or 1; s.Transparency = trans or 0; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = obj; return s
end
local function pad(obj, l, r, top, bot)
    local p = Instance.new("UIPadding"); p.PaddingLeft = UDim.new(0, l or 0); p.PaddingRight = UDim.new(0, r or l or 0); p.PaddingTop = UDim.new(0, top or l or 0); p.PaddingBottom = UDim.new(0, bot or top or l or 0); p.Parent = obj; return p
end

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- [4] GUI ERSTELLEN
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
pcall(function()
    for _, name in ipairs({"TLMenuV6","TLMenuV5","TLMenuV4"}) do
        local f = CoreGui:FindFirstChild(name); if f then f:Destroy() end
    end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "TLMenuV6"; gui.ResetOnSpawn = false; gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() gui.IgnoreGuiInset = true end)
local ok = pcall(function() gui.Parent = CoreGui end)
if not ok then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- [5] NOTIFICATIONS
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local notifHolder = Instance.new("Frame")
notifHolder.Size = UDim2.new(0,260,1,-20); notifHolder.Position = UDim2.new(0,10,0,10)
notifHolder.BackgroundTransparency = 1; notifHolder.Parent = gui

local notifLayout = Instance.new("UIListLayout")
notifLayout.Padding = UDim.new(0,6); notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left; notifLayout.Parent = notifHolder

local function notify(title, text, ntype)
    local accent = ntype == "success" and T.Success or ntype == "error" and T.Danger or ntype == "warning" and T.Warning or T.Purple
    local n = Instance.new("Frame")
    n.Size = UDim2.new(1,0,0,0); n.BackgroundColor3 = Color3.fromRGB(18,14,28)
    n.BackgroundTransparency = 0.1; n.BorderSizePixel = 0; n.ClipsDescendants = true; n.Parent = notifHolder
    cr(n,10); st(n, T.Border, 1, 0.2)
    local strip = Instance.new("Frame")
    strip.Size = UDim2.new(0,3,1,0); strip.BackgroundColor3 = accent; strip.BorderSizePixel = 0
    strip.ZIndex = n.ZIndex + 1; strip.Parent = n; cr(strip,2)
    local tl2 = Instance.new("TextLabel")
    tl2.Size = UDim2.new(1,-16,0,16); tl2.Position = UDim2.new(0,12,0,8)
    tl2.BackgroundTransparency = 1; tl2.Text = title; tl2.TextColor3 = T.TextPure
    tl2.TextSize = 11; tl2.Font = Enum.Font.GothamBold; tl2.TextXAlignment = Enum.TextXAlignment.Left; tl2.Parent = n
    local tx = Instance.new("TextLabel")
    tx.Size = UDim2.new(1,-16,0,14); tx.Position = UDim2.new(0,12,0,26)
    tx.BackgroundTransparency = 1; tx.Text = text; tx.TextColor3 = T.TextSec
    tx.TextSize = 10; tx.Font = Enum.Font.Gotham; tx.TextXAlignment = Enum.TextXAlignment.Left
    tx.TextWrapped = true; tx.Parent = n
    tw(n, {Size = UDim2.new(1,0,0,52)}, 0.28, Enum.EasingStyle.Back)
    task.delay(3.5, function()
        tw(n, {Size = UDim2.new(1,0,0,0), BackgroundTransparency = 1}, 0.18)
        task.wait(0.22); if n and n.Parent then n:Destroy() end
    end)
end

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- [6] HAUPTFENSTER
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local WIN_W, WIN_H = 780, 480
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainWindow"; mainFrame.Size = UDim2.new(0,WIN_W,0,WIN_H)
mainFrame.Position = UDim2.new(0.5,-WIN_W/2,0.5,-WIN_H/2)
mainFrame.BackgroundColor3 = T.BG; mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0; mainFrame.ClipsDescendants = true; mainFrame.Parent = gui
cr(mainFrame,14); st(mainFrame, T.Border, 1.5, 0.1)

local glowEdge = Instance.new("Frame")
glowEdge.Size = UDim2.new(1,0,0,3); glowEdge.BackgroundColor3 = T.Purple
glowEdge.BackgroundTransparency = 0; glowEdge.BorderSizePixel = 0
glowEdge.ZIndex = mainFrame.ZIndex + 5; glowEdge.Parent = mainFrame
local glowGrad = Instance.new("UIGradient")
glowGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(148, 43, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(210, 70, 170)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 110, 35)),
})
glowGrad.Parent = glowEdge

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- [7] TOP BAR
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"; topBar.Size = UDim2.new(1,0,0,48)
topBar.BackgroundColor3 = Color3.fromRGB(10,8,16); topBar.BackgroundTransparency = 0.1
topBar.BorderSizePixel = 0; topBar.ZIndex = mainFrame.ZIndex + 2; topBar.Parent = mainFrame

local topLine = Instance.new("Frame")
topLine.Size = UDim2.new(1,0,0,1); topLine.Position = UDim2.new(0,0,1,-1)
topLine.BackgroundColor3 = T.Border; topLine.BackgroundTransparency = 0.3
topLine.BorderSizePixel = 0; topLine.ZIndex = topBar.ZIndex + 1; topLine.Parent = topBar

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(0,160,1,0); titleLbl.Position = UDim2.new(0,16,0,0)
titleLbl.BackgroundTransparency = 1; titleLbl.Text = "TL Menu"
titleLbl.TextColor3 = T.TextPure; titleLbl.TextSize = 15; titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextXAlignment = Enum.TextXAlignment.Left; titleLbl.ZIndex = topBar.ZIndex + 1; titleLbl.Parent = topBar

local subLbl = Instance.new("TextLabel")
subLbl.Size = UDim2.new(0,160,0,12); subLbl.Position = UDim2.new(0,16,0,28)
subLbl.BackgroundTransparency = 1; subLbl.Text = "by TL Scripts"
subLbl.TextColor3 = T.TextMuted; subLbl.TextSize = 9; subLbl.Font = Enum.Font.Gotham
subLbl.TextXAlignment = Enum.TextXAlignment.Left; subLbl.ZIndex = topBar.ZIndex + 1; subLbl.Parent = topBar

for i, col in ipairs({T.Dot1, T.Dot2, T.Dot3}) do
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0,10,0,10); dot.Position = UDim2.new(0,160+(i-1)*16,0.5,-5)
    dot.BackgroundColor3 = col; dot.BorderSizePixel = 0
    dot.ZIndex = topBar.ZIndex + 1; dot.Parent = topBar; cr(dot,5)
end

local rightBtns = {"Unload","Tags: ON","Key: G","âœ•"}
local rightX = WIN_W - 14
for i = #rightBtns, 1, -1 do
    local label = rightBtns[i]; local isX = label == "âœ•"
    local btnW = isX and 28 or (string.len(label)*7+20); rightX = rightX - btnW
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,btnW,0,24); btn.Position = UDim2.new(0,rightX,0.5,-12)
    btn.BackgroundColor3 = isX and T.Danger or T.TabBG
    btn.BackgroundTransparency = isX and 0 or 0.2; btn.Text = label
    btn.TextColor3 = isX and T.White or T.TextSec; btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold; btn.AutoButtonColor = false
    btn.ZIndex = topBar.ZIndex + 1; btn.Parent = topBar; cr(btn,6)
    if not isX then st(btn, T.Border, 1, 0.3) end
    btn.MouseEnter:Connect(function() tw(btn, {BackgroundTransparency = isX and 0.2 or 0}, 0.1); tw(btn, {TextColor3 = T.TextPure}, 0.1) end)
    btn.MouseLeave:Connect(function() tw(btn, {BackgroundTransparency = isX and 0 or 0.2}, 0.1); tw(btn, {TextColor3 = isX and T.White or T.TextSec}, 0.1) end)
    if isX then btn.MouseButton1Click:Connect(function()
        tw(mainFrame, {Size = UDim2.new(0,WIN_W,0,0), BackgroundTransparency = 1}, 0.22, Enum.EasingStyle.Quart)
        task.wait(0.25); pcall(function() gui:Destroy() end)
    end) end
    rightX = rightX - 6
end

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- [8] CONTENT BEREICH
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"; contentFrame.Size = UDim2.new(1,0,1,-96)
contentFrame.Position = UDim2.new(0,0,0,48); contentFrame.BackgroundTransparency = 1
contentFrame.ClipsDescendants = true; contentFrame.ZIndex = mainFrame.ZIndex + 1; contentFrame.Parent = mainFrame

local contentScroll = Instance.new("ScrollingFrame")
contentScroll.Size = UDim2.new(1,0,1,0); contentScroll.BackgroundTransparency = 1
contentScroll.BorderSizePixel = 0; contentScroll.ScrollBarThickness = 3
contentScroll.ScrollBarImageColor3 = T.Purple; contentScroll.CanvasSize = UDim2.new(0,0,0,0)
contentScroll.Parent = contentFrame; pad(contentScroll, 16, 16, 16, 16)

local contentList = Instance.new("UIListLayout")
contentList.Padding = UDim.new(0,10); contentList.Parent = contentScroll
contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    contentScroll.CanvasSize = UDim2.new(0,0,0,contentList.AbsoluteContentSize.Y + 32)
end)

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- [9] TAB BAR
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local tabBar = Instance.new("Frame")
tabBar.Name = "TabBar"; tabBar.Size = UDim2.new(1,0,0,48); tabBar.Position = UDim2.new(0,0,1,-48)
tabBar.BackgroundColor3 = Color3.fromRGB(10,8,16); tabBar.BackgroundTransparency = 0.1
tabBar.BorderSizePixel = 0; tabBar.ZIndex = mainFrame.ZIndex + 3; tabBar.Parent = mainFrame

local tabTopLine = Instance.new("Frame")
tabTopLine.Size = UDim2.new(1,0,0,1); tabTopLine.BackgroundColor3 = T.Border
tabTopLine.BackgroundTransparency = 0.3; tabTopLine.BorderSizePixel = 0
tabTopLine.ZIndex = tabBar.ZIndex + 1; tabTopLine.Parent = tabBar

local tabInner = Instance.new("Frame")
tabInner.Size = UDim2.new(1,-24,1,-10); tabInner.Position = UDim2.new(0,12,0,5)
tabInner.BackgroundTransparency = 1; tabInner.ZIndex = tabBar.ZIndex + 1; tabInner.Parent = tabBar

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabLayout.Padding = UDim.new(0,6); tabLayout.Parent = tabInner

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- [10] UI KOMPONENTEN (Builders)
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local function makeSection(parent, text)
    local f = Instance.new("Frame"); f.Size = UDim2.new(1,0,0,24); f.BackgroundTransparency = 1; f.Parent = parent
    local tick_ = Instance.new("Frame"); tick_.Size = UDim2.new(0,3,0,10); tick_.Position = UDim2.new(0,0,0.5,-5)
    tick_.BackgroundColor3 = T.Purple; tick_.BorderSizePixel = 0; tick_.Parent = f; cr(tick_,2)
    local l = Instance.new("TextLabel"); l.Size = UDim2.new(1,-12,1,0); l.Position = UDim2.new(0,10,0,0)
    l.BackgroundTransparency = 1; l.Text = text; l.TextColor3 = T.TextMuted; l.TextSize = 9
    l.Font = Enum.Font.GothamBold; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = f
    return f
end

local function makeCard(parent, height)
    local c = Instance.new("Frame"); c.Size = UDim2.new(1,0,0,height or 60)
    c.BackgroundColor3 = T.Card; c.BackgroundTransparency = 0.2; c.BorderSizePixel = 0
    c.Parent = parent; cr(c,10); st(c, T.Border, 1, 0.3); return c
end

local function makeToggle(parent, label, default, callback)
    local row = makeCard(parent, 46); pad(row, 14, 14, 0, 0)
    local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1,-60,1,0); lbl.BackgroundTransparency = 1
    lbl.Text = label; lbl.TextColor3 = T.TextMain; lbl.TextSize = 11; lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = row
    local track = Instance.new("TextButton"); track.Size = UDim2.new(0,38,0,20); track.Position = UDim2.new(1,-52,0.5,-10)
    track.BackgroundColor3 = default and T.Purple or Color3.fromRGB(40,32,60); track.Text = ""
    track.AutoButtonColor = false; track.ZIndex = row.ZIndex + 1; track.Parent = row
    cr(track,10); st(track, default and T.PurpleLight or T.Border, 1, 0.2)
    local knob = Instance.new("Frame"); knob.Size = UDim2.new(0,14,0,14)
    knob.Position = default and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
    knob.BackgroundColor3 = T.White; knob.BorderSizePixel = 0; knob.ZIndex = track.ZIndex + 1
    knob.Parent = track; cr(knob,7)
    local state = default or false
    track.MouseButton1Click:Connect(function()
        state = not state
        if state then
            tw(track, {BackgroundColor3 = T.Purple}, 0.14)
            tw(knob, {Position = UDim2.new(1,-17,0.5,-7)}, 0.14, Enum.EasingStyle.Back)
            local s2 = track:FindFirstChildWhichIsA("UIStroke"); if s2 then tw(s2, {Color = T.PurpleLight}, 0.14) end
        else
            tw(track, {BackgroundColor3 = Color3.fromRGB(40,32,60)}, 0.14)
            tw(knob, {Position = UDim2.new(0,3,0.5,-7)}, 0.14)
            local s2 = track:FindFirstChildWhichIsA("UIStroke"); if s2 then tw(s2, {Color = T.Border}, 0.14) end
        end
        pcall(callback, state)
    end)
    return row
end

local function makeSlider(parent, label, min, max, default, callback)
    local row = makeCard(parent, 60); pad(row, 14, 14, 10, 10)
    local topRow = Instance.new("Frame"); topRow.Size = UDim2.new(1,0,0,16); topRow.BackgroundTransparency = 1; topRow.Parent = row
    local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1,-50,1,0); lbl.BackgroundTransparency = 1
    lbl.Text = label; lbl.TextColor3 = T.TextMain; lbl.TextSize = 11; lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = topRow
    local valBg = Instance.new("Frame"); valBg.Size = UDim2.new(0,44,0,16); valBg.Position = UDim2.new(1,-44,0,0)
    valBg.BackgroundColor3 = Color3.fromRGB(40,30,60); valBg.BorderSizePixel = 0; valBg.Parent = topRow
    cr(valBg,5); st(valBg, T.Border, 1, 0.3)
    local val = Instance.new("TextLabel"); val.Size = UDim2.new(1,0,1,0); val.BackgroundTransparency = 1
    val.Text = tostring(default); val.TextColor3 = T.PurpleLight; val.TextSize = 10; val.Font = Enum.Font.GothamBold; val.Parent = valBg
    local sTrack = Instance.new("Frame"); sTrack.Size = UDim2.new(1,0,0,4); sTrack.Position = UDim2.new(0,0,0,38)
    sTrack.BackgroundColor3 = Color3.fromRGB(40,30,60); sTrack.BorderSizePixel = 0; sTrack.Parent = row; cr(sTrack,2)
    local fill = Instance.new("Frame"); fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = T.Purple; fill.BorderSizePixel = 0; fill.Parent = sTrack; cr(fill,2)
    local thumb = Instance.new("TextButton"); thumb.Size = UDim2.new(0,12,0,12)
    thumb.Position = UDim2.new((default-min)/(max-min),-6,0.5,-6); thumb.BackgroundColor3 = T.PurpleLight
    thumb.Text = ""; thumb.AutoButtonColor = false; thumb.ZIndex = sTrack.ZIndex + 1; thumb.Parent = sTrack; cr(thumb,6)
    local dragging = false
    local function upd(input)
        local rel = math.clamp((input.Position.X - sTrack.AbsolutePosition.X) / sTrack.AbsoluteSize.X, 0, 1)
        local v = math.floor(min + (max-min) * rel)
        fill.Size = UDim2.new(rel,0,1,0); thumb.Position = UDim2.new(rel,-6,0.5,-6)
        val.Text = tostring(v); pcall(callback, v)
    end
    thumb.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
    sTrack.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then upd(i); dragging = true end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then upd(i) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    return row
end

local function makeButton(parent, text, callback, isPrimary)
    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1,0,0,38)
    btn.BackgroundColor3 = isPrimary and T.Purple or Color3.fromRGB(30,22,50)
    btn.BackgroundTransparency = isPrimary and 0 or 0.2; btn.Text = text
    btn.TextColor3 = T.TextPure; btn.TextSize = 11; btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false; btn.Parent = parent; cr(btn,10)
    if not isPrimary then st(btn, T.Border, 1, 0.2) end
    btn.MouseEnter:Connect(function() tw(btn, {BackgroundColor3 = isPrimary and T.PurpleLight or Color3.fromRGB(45,32,70), BackgroundTransparency = 0}, 0.1) end)
    btn.MouseLeave:Connect(function() tw(btn, {BackgroundColor3 = isPrimary and T.Purple or Color3.fromRGB(30,22,50), BackgroundTransparency = isPrimary and 0 or 0.2}, 0.1) end)
    btn.MouseButton1Click:Connect(function()
        tw(btn, {Size = UDim2.new(0.97,0,0,36)}, 0.07); task.wait(0.07)
        tw(btn, {Size = UDim2.new(1,0,0,38)}, 0.14, Enum.EasingStyle.Back); pcall(callback)
    end)
    return btn
end
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- [11] TAB PAGES
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local pages = {}
local activeTab = nil

local function clearContent()
    for _, c in pairs(contentScroll:GetChildren()) do
        if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
    end
    contentScroll.CanvasPosition = Vector2.new(0, 0)
end

-- â”€â”€ HOME â”€â”€
pages["Home"] = function()
    local row1 = Instance.new("Frame"); row1.Size = UDim2.new(1,0,0,130); row1.BackgroundTransparency = 1; row1.Parent = contentScroll
    local rowLayout = Instance.new("UIListLayout"); rowLayout.FillDirection = Enum.FillDirection.Horizontal; rowLayout.Padding = UDim.new(0,10); rowLayout.Parent = row1

    local welcome = Instance.new("Frame"); welcome.Size = UDim2.new(0,420,1,0)
    welcome.BackgroundColor3 = T.Card; welcome.BackgroundTransparency = 0.15; welcome.BorderSizePixel = 0
    welcome.Parent = row1; cr(welcome,10); st(welcome, T.Border, 1.5, 0.15); pad(welcome, 18, 18, 16, 16)

    local topStrip = Instance.new("Frame"); topStrip.Size = UDim2.new(1,0,0,2)
    topStrip.BackgroundColor3 = T.Purple; topStrip.BackgroundTransparency = 0.2
    topStrip.BorderSizePixel = 0; topStrip.ZIndex = welcome.ZIndex + 1; topStrip.Parent = welcome

    local wTitle = Instance.new("TextLabel"); wTitle.Size = UDim2.new(1,0,0,24); wTitle.Position = UDim2.new(0,0,0,10)
    wTitle.BackgroundTransparency = 1; wTitle.Text = "Welcome, "..LocalPlayer.Name.."!"
    wTitle.TextColor3 = T.TextPure; wTitle.TextSize = 18; wTitle.Font = Enum.Font.GothamBlack
    wTitle.TextXAlignment = Enum.TextXAlignment.Left; wTitle.Parent = welcome

    local wSub = Instance.new("TextLabel"); wSub.Size = UDim2.new(1,0,0,14); wSub.Position = UDim2.new(0,0,0,40)
    wSub.BackgroundTransparency = 1; wSub.Text = "TL Menu v6 is loaded and ready."
    wSub.TextColor3 = T.TextSec; wSub.TextSize = 11; wSub.Font = Enum.Font.Gotham
    wSub.TextXAlignment = Enum.TextXAlignment.Left; wSub.Parent = welcome

    local badge = Instance.new("Frame"); badge.Size = UDim2.new(0,160,0,22); badge.Position = UDim2.new(0,0,0,64)
    badge.BackgroundColor3 = Color3.fromRGB(30,22,50); badge.BackgroundTransparency = 0.1
    badge.BorderSizePixel = 0; badge.Parent = welcome; cr(badge,6); st(badge, T.Purple, 1, 0.4)
    local bdot = Instance.new("Frame"); bdot.Size = UDim2.new(0,6,0,6); bdot.Position = UDim2.new(0,8,0.5,-3)
    bdot.BackgroundColor3 = T.Purple; bdot.BorderSizePixel = 0; bdot.ZIndex = badge.ZIndex+1; bdot.Parent = badge; cr(bdot,3)
    local badgeTxt = Instance.new("TextLabel"); badgeTxt.Size = UDim2.new(1,-20,1,0); badgeTxt.Position = UDim2.new(0,18,0,0)
    badgeTxt.BackgroundTransparency = 1; badgeTxt.Text = "Access Granted"; badgeTxt.TextColor3 = T.PurpleLight
    badgeTxt.TextSize = 10; badgeTxt.Font = Enum.Font.GothamBold; badgeTxt.TextXAlignment = Enum.TextXAlignment.Left; badgeTxt.Parent = badge

    local statsCol = Instance.new("Frame"); statsCol.Size = UDim2.new(1,-430,1,0); statsCol.BackgroundTransparency = 1; statsCol.Parent = row1
    local statsLayout = Instance.new("UIListLayout"); statsLayout.Padding = UDim.new(0,6); statsLayout.Parent = statsCol
    local function miniCard(label, value, vColor)
        local mc = Instance.new("Frame"); mc.Size = UDim2.new(1,0,0,34); mc.BackgroundColor3 = T.Card
        mc.BackgroundTransparency = 0.2; mc.BorderSizePixel = 0; mc.Parent = statsCol; cr(mc,8); st(mc, T.Border, 1, 0.35); pad(mc, 12, 12, 0, 0)
        local l = Instance.new("TextLabel"); l.Size = UDim2.new(0.45,0,1,0); l.BackgroundTransparency = 1
        l.Text = label; l.TextColor3 = T.TextMuted; l.TextSize = 9; l.Font = Enum.Font.GothamBold; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = mc
        local v = Instance.new("TextLabel"); v.Size = UDim2.new(0.55,0,1,0); v.Position = UDim2.new(0.45,0,0,0)
        v.BackgroundTransparency = 1; v.Text = value; v.TextColor3 = vColor or T.TextPure; v.TextSize = 11
        v.Font = Enum.Font.GothamBold; v.TextXAlignment = Enum.TextXAlignment.Left; v.Parent = mc
    end
    miniCard("Version", "v6.0", T.TextPure); miniCard("Status", "Loaded", T.Success); miniCard("Game", tostring(game.PlaceId), T.PurpleLight)

    makeSection(contentScroll, "CHANGELOG")
    local changes = {
        {ver="v6.0", title="AudioCrafter Style Redesign", desc="Full UI restyle. Purple theme, bottom tabs, card layout."},
        {ver="v5.0", title="Black & White Edition", desc="Monochrome redesign with sidebar navigation and glass cards."},
        {ver="v4.0", title="Original Release", desc="Initial TL Menu with core features and toggles."},
    }
    for _, ch in ipairs(changes) do
        local card = makeCard(contentScroll, 72); pad(card, 14, 14, 12, 12)
        local verBadge = Instance.new("Frame"); verBadge.Size = UDim2.new(0,36,0,18)
        verBadge.BackgroundColor3 = Color3.fromRGB(40,28,65); verBadge.BorderSizePixel = 0; verBadge.Parent = card
        cr(verBadge,5); st(verBadge, T.Purple, 1, 0.4)
        local verTxt = Instance.new("TextLabel"); verTxt.Size = UDim2.new(1,0,1,0); verTxt.BackgroundTransparency = 1
        verTxt.Text = ch.ver; verTxt.TextColor3 = T.PurpleLight; verTxt.TextSize = 9; verTxt.Font = Enum.Font.GothamBold; verTxt.Parent = verBadge
        local title = Instance.new("TextLabel"); title.Size = UDim2.new(1,-50,0,16); title.Position = UDim2.new(0,44,0,0)
        title.BackgroundTransparency = 1; title.Text = ch.title; title.TextColor3 = T.TextPure; title.TextSize = 12
        title.Font = Enum.Font.GothamBold; title.TextXAlignment = Enum.TextXAlignment.Left; title.Parent = card
        local desc = Instance.new("TextLabel"); desc.Size = UDim2.new(1,0,0,26); desc.Position = UDim2.new(0,0,0,28)
        desc.BackgroundTransparency = 1; desc.Text = ch.desc; desc.TextColor3 = T.TextSec; desc.TextSize = 10
        desc.Font = Enum.Font.Gotham; desc.TextXAlignment = Enum.TextXAlignment.Left; desc.TextWrapped = true; desc.Parent = card
    end
end

-- â”€â”€ PLAYER (BUG GEFIXT: alles in einer Funktion) â”€â”€
local invisRunning = false
local function makeInvisible()
    local char = Character; if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.Transparency = 1 end
    end
    local connection; connection = RunService.Heartbeat:Connect(function()
        if not invisRunning then connection:Disconnect(); return end
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                v.Velocity = Vector3.new(0,0,0); v.CFrame = CFrame.new(9e9,9e9,9e9)
            end
        end
    end)
end

pages["Player"] = function()
    makeSection(contentScroll, "AUSSEHEN")
    makeToggle(contentScroll, "Invisible FE", false, function(s)
        if s then invisRunning = true; makeInvisible(); notify("Invisible", "Andere Spieler sehen dich jetzt nicht mehr!", "success")
        else invisRunning = false; notify("Invisible", "Reset nÃ¶tig, um wieder sichtbar zu sein!", "warning") end
    end)

    makeSection(contentScroll, "STATS")
    makeSlider(contentScroll, "Walk Speed", 16, 500, 16, function(v) pcall(function() if Humanoid then Humanoid.WalkSpeed = v end end) end)
    makeSlider(contentScroll, "Jump Power", 50, 500, 50, function(v) pcall(function() if Humanoid then Humanoid.JumpPower = v end end) end)

    makeSection(contentScroll, "ÃœBERLEBEN")
    local godConn = nil
    makeToggle(contentScroll, "God Mode", false, function(s)
        pcall(function()
            if godConn then godConn:Disconnect(); godConn = nil end
            if not Humanoid then return end
            if s then
                Humanoid.MaxHealth = math.huge; Humanoid.Health = math.huge
                godConn = Humanoid:GetPropertyChangedSignal("Health"):Connect(function() if Humanoid then Humanoid.Health = math.huge end end)
            else Humanoid.MaxHealth = 100; Humanoid.Health = 100 end
        end)
        notify("God Mode", s and "Unverwundbar!" or "Normal!", "success")
    end)
end

-- â”€â”€ WORLD â”€â”€
pages["World"] = function()
    makeSection(contentScroll, "FLIEGEN")
    local flyEnabled, flyConn, flyBody, flySpd = false, nil, nil, 80
    makeToggle(contentScroll, "Fly Mode", false, function(s)
        flyEnabled = s
        pcall(function()
            if s then
                if not HRP then notify("Fly", "Kein Charakter!", "error"); return end
                flyBody = Instance.new("BodyVelocity"); flyBody.MaxForce = Vector3.new(9e9,9e9,9e9)
                flyBody.Velocity = Vector3.zero; flyBody.Parent = HRP
                flyConn = RunService.RenderStepped:Connect(function()
                    if not flyEnabled or not HRP then return end
                    local dir = Vector3.zero; local cam = Camera
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0,1,0) end
                    flyBody.Velocity = dir.Magnitude > 0 and dir.Unit * flySpd or Vector3.zero
                end)
                notify("Fly", "WASD + Space/Shift!", "success")
            else
                if flyConn then flyConn:Disconnect(); flyConn = nil end
                if flyBody then flyBody:Destroy(); flyBody = nil end
                notify("Fly", "Deaktiviert!", "warning")
            end
        end)
    end)
    makeSlider(contentScroll, "Fly Speed", 10, 300, 80, function(v) flySpd = v end)

    makeSection(contentScroll, "BEWEGUNG")
    local ncConn = nil
    makeToggle(contentScroll, "No Clip", false, function(s)
        pcall(function()
            if s then
                ncConn = RunService.Stepped:Connect(function()
                    if not Character then return end
                    for _, p in pairs(Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
                end)
                notify("No Clip", "Durch WÃ¤nde!", "success")
            else
                if ncConn then ncConn:Disconnect(); ncConn = nil end
                pcall(function() if Character then for _, p in pairs(Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end end)
                notify("No Clip", "Deaktiviert!", "warning")
            end
        end)
    end)
    makeToggle(contentScroll, "Infinite Jump", false, function(s)
        if s then UserInputService.JumpRequest:Connect(function() if Humanoid then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end) end
        notify("Infinite Jump", s and "Aktiviert!" or "Deaktiviert!", "success")
    end)
end

-- â”€â”€ TOOLS â”€â”€
pages["Tools"] = function()
    makeSection(contentScroll, "AKTIONEN")
    makeButton(contentScroll, "â†º  Rejoin Server", function()
        notify("Rejoin", "Verbinde neu...", "success"); task.wait(0.8)
        pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
    end, true)
    makeButton(contentScroll, "âœ¦  Respawn", function()
        pcall(function() if Character then Character:BreakJoints() end end)
        notify("Respawn", "Du wirst respawnt!", "success")
    end)

    makeSection(contentScroll, "VISUAL")
    local espConns = {}
    makeToggle(contentScroll, "Player ESP", false, function(s)
        pcall(function()
            for _, c in pairs(espConns) do c:Disconnect() end; espConns = {}
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    if s then
                        local hl = Instance.new("Highlight"); hl.Name = "TLESP"; hl.FillColor = Color3.fromRGB(80,0,140)
                        hl.OutlineColor = T.PurpleLight; hl.FillTransparency = 0.7; hl.Parent = p.Character
                    else for _, v in pairs(p.Character:GetChildren()) do if v.Name == "TLESP" then v:Destroy() end end end
                end
            end
            if s then table.insert(espConns, Players.PlayerAdded:Connect(function(p)
                p.CharacterAdded:Connect(function(c)
                    local hl = Instance.new("Highlight"); hl.Name = "TLESP"; hl.FillColor = Color3.fromRGB(80,0,140)
                    hl.OutlineColor = T.PurpleLight; hl.FillTransparency = 0.7; hl.Parent = c
                end)
            end)) end
        end)
        notify("ESP", s and "Spieler markiert!" or "Aus!", "success")
    end)
    makeToggle(contentScroll, "Full Bright", false, function(s)
        pcall(function()
            if s then Lighting.Brightness=10; Lighting.ClockTime=12; Lighting.FogEnd=100000; Lighting.GlobalShadows=false
            else Lighting.Brightness=2; Lighting.ClockTime=14; Lighting.FogEnd=1000; Lighting.GlobalShadows=true end
        end)
        notify("Full Bright", s and "Alles beleuchtet!" or "Normal!", "success")
    end)
    makeToggle(contentScroll, "Anti-AFK", false, function(s)
        if s then pcall(function() local VU = game:GetService("VirtualUser")
            LocalPlayer.Idled:Connect(function() VU:CaptureController(); VU:ClickButton2(Vector2.new()) end) end)
            notify("Anti-AFK", "Kein Kick mehr!", "success")
        else notify("Anti-AFK", "Deaktiviert!", "warning") end
    end)
end

-- â”€â”€ PLAYERS â”€â”€
pages["Players"] = function()
    makeSection(contentScroll, "ONLINE  ("..#Players:GetPlayers()..")")
    for _, p in pairs(Players:GetPlayers()) do
        local isMe = p == LocalPlayer; local row = makeCard(contentScroll, 52); pad(row, 12, 12, 0, 0)
        if isMe then
            local youBar = Instance.new("Frame"); youBar.Size = UDim2.new(0,3,0,28); youBar.Position = UDim2.new(0,0,0.5,-14)
            youBar.BackgroundColor3 = T.Purple; youBar.BackgroundTransparency = 0.2; youBar.BorderSizePixel = 0
            youBar.ZIndex = row.ZIndex+1; youBar.Parent = row; cr(youBar,2)
        end
        local av = Instance.new("ImageLabel"); av.Size = UDim2.new(0,30,0,30); av.Position = UDim2.new(0,6,0.5,-15)
        av.BackgroundColor3 = Color3.fromRGB(30,22,50); av.BorderSizePixel = 0
        pcall(function() av.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..p.UserId.."&width=48&height=48&format=png" end)
        av.ZIndex = row.ZIndex+1; av.Parent = row; cr(av,6); st(av, isMe and T.Purple or T.Border, 1, 0.3)
        local nl = Instance.new("TextLabel"); nl.Size = UDim2.new(1,-52,0,16); nl.Position = UDim2.new(0,44,0.5,-16)
        nl.BackgroundTransparency = 1; nl.Text = p.Name; nl.TextColor3 = isMe and T.PurpleLight or T.TextMain
        nl.TextSize = 11; nl.Font = Enum.Font.GothamBold; nl.TextXAlignment = Enum.TextXAlignment.Left
        nl.ZIndex = row.ZIndex+1; nl.Parent = row
        local idl = Instance.new("TextLabel"); idl.Size = UDim2.new(1,-52,0,12); idl.Position = UDim2.new(0,44,0.5,2)
        idl.BackgroundTransparency = 1; idl.Text = "ID "..p.UserId..(isMe and "  Â· you" or "")
        idl.TextColor3 = T.TextMuted; idl.TextSize = 9; idl.Font = Enum.Font.Gotham
        idl.TextXAlignment = Enum.TextXAlignment.Left; idl.ZIndex = row.ZIndex+1; idl.Parent = row
    end
end

-- â”€â”€ SETTINGS â”€â”€
pages["Settings"] = function()
    makeSection(contentScroll, "ÃœBER")
    local about = makeCard(contentScroll, 70); pad(about, 16, 16, 14, 14)
    local aStrip = Instance.new("Frame"); aStrip.Size = UDim2.new(0,3,0,40); aStrip.Position = UDim2.new(0,0,0.5,-20)
    aStrip.BackgroundColor3 = T.Purple; aStrip.BackgroundTransparency = 0.2; aStrip.BorderSizePixel = 0
    aStrip.ZIndex = about.ZIndex+1; aStrip.Parent = about; cr(aStrip,2)
    local at = Instance.new("TextLabel"); at.Size = UDim2.new(1,0,0,22); at.BackgroundTransparency = 1
    at.Text = "TL MENU  v6.0"; at.TextColor3 = T.TextPure; at.TextSize = 14; at.Font = Enum.Font.GothamBlack
    at.TextXAlignment = Enum.TextXAlignment.Left; at.Parent = about
    local as2 = Instance.new("TextLabel"); as2.Size = UDim2.new(1,0,0,12); as2.Position = UDim2.new(0,0,0,26)
    as2.BackgroundTransparency = 1; as2.Text = "AudioCrafter Style  Â·  Purple Edition"
    as2.TextColor3 = T.TextMuted; as2.TextSize = 9; as2.Font = Enum.Font.Gotham; as2.TextXAlignment = Enum.TextXAlignment.Left; as2.Parent = about

    makeSection(contentScroll, "DANGER")
    makeButton(contentScroll, "âœ•  Menu schlieÃŸen", function()
        tw(mainFrame, {Size = UDim2.new(0,WIN_W,0,0), BackgroundTransparency = 1}, 0.22, Enum.EasingStyle.Quart)
        task.wait(0.25); pcall(function() gui:Destroy() end)
    end)
    makeButton(contentScroll, "â†º  Test Notification", function() notify("Test!", "Alles funktioniert perfekt!", "success") end, true)
end

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- [12] TAB BUTTONS ERSTELLEN
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local tabDefs = {
    {name="Home"}, {name="Player"}, {name="World"},
    {name="Tools"}, {name="Players"}, {name="Settings"},
}
local activeTabBtn = nil

local function switchTab(name, btnRef)
    if activeTabBtn and activeTabBtn ~= btnRef then
        tw(activeTabBtn, {BackgroundColor3 = T.TabBG, BackgroundTransparency = 0.2})
        local oldGrad = activeTabBtn:FindFirstChildWhichIsA("UIGradient")
        if oldGrad then oldGrad:Destroy() end
        local oldTxt = activeTabBtn:FindFirstChildWhichIsA("TextLabel")
        if oldTxt then tw(oldTxt, {TextColor3 = T.TextSec}, 0.1) end
    end
    activeTabBtn = btnRef
    tw(btnRef, {BackgroundColor3 = T.Purple, BackgroundTransparency = 0}, 0.15)
    -- Add gradient to active tab
    local existingGrad = btnRef:FindFirstChildWhichIsA("UIGradient")
    if not existingGrad then
        local grad = Instance.new("UIGradient")
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(148, 43, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 110, 35)),
        })
        grad.Rotation = 90
        grad.Parent = btnRef
    end
    local newTxt = btnRef:FindFirstChildWhichIsA("TextLabel")
    if newTxt then tw(newTxt, {TextColor3 = T.White}, 0.1) end
    clearContent()
    if pages[name] then pcall(pages[name]) end
end

for i, data in ipairs(tabDefs) do
    local isFirst = i == 1
    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(0,100,0,32)
    btn.BackgroundColor3 = isFirst and T.Purple or T.TabBG
    btn.BackgroundTransparency = isFirst and 0 or 0.2; btn.Text = ""
    btn.AutoButtonColor = false; btn.ZIndex = tabBar.ZIndex + 2; btn.Parent = tabInner; cr(btn,16)
    if not isFirst then st(btn, T.Border, 1, 0.4) end
    -- Gradient on first (active) tab
    if isFirst then
        local grad = Instance.new("UIGradient")
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(148, 43, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 110, 35)),
        })
        grad.Rotation = 90
        grad.Parent = btn
    end
    local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1
    lbl.Text = data.name; lbl.TextColor3 = isFirst and T.White or T.TextSec
    lbl.TextSize = 11; lbl.Font = Enum.Font.GothamBold; lbl.ZIndex = btn.ZIndex+1; lbl.Parent = btn
    if isFirst then activeTabBtn = btn end
    local cName, cBtn = data.name, btn
    btn.MouseButton1Click:Connect(function() switchTab(cName, cBtn) end)
    btn.MouseEnter:Connect(function() if cBtn ~= activeTabBtn then tw(cBtn, {BackgroundTransparency = 0.05}, 0.1) end end)
    btn.MouseLeave:Connect(function() if cBtn ~= activeTabBtn then tw(cBtn, {BackgroundTransparency = 0.2}, 0.1) end end)
end

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- [13] FPS / PING ANZEIGE
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local fpsPing = Instance.new("TextLabel"); fpsPing.Size = UDim2.new(0,120,1,0); fpsPing.Position = UDim2.new(0,210,0,0)
fpsPing.BackgroundTransparency = 1; fpsPing.Text = "FPS -- Â· PING --ms"; fpsPing.TextColor3 = T.TextMuted
fpsPing.TextSize = 9; fpsPing.Font = Enum.Font.GothamBold; fpsPing.TextXAlignment = Enum.TextXAlignment.Left
fpsPing.ZIndex = topBar.ZIndex+1; fpsPing.Parent = topBar

local fpsCount, lastTick = 0, tick()
RunService.RenderStepped:Connect(function()
    fpsCount += 1; local now = tick()
    if now - lastTick >= 1 then
        local fps = math.round(fpsCount / (now - lastTick)); local ping = 0
        pcall(function() ping = math.round(LocalPlayer:GetNetworkPing() * 1000) end)
        fpsPing.Text = "FPS "..fps.."  |  "..ping.."ms"
        fpsPing.TextColor3 = ping < 80 and T.Success or ping < 150 and T.Warning or T.Danger
        fpsCount = 0; lastTick = now
    end
end)

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- [14] DRAGGING
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
do
    local dragging, dragStart, startPos = false, nil, nil
    topBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = i.Position; startPos = mainFrame.Position end
    end)
    topBar.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- [15] START
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
mainFrame.Size = UDim2.new(0, WIN_W, 0, 0)
tw(mainFrame, {Size = UDim2.new(0, WIN_W, 0, WIN_H)}, 0.32, Enum.EasingStyle.Back)
task.delay(0.1, function() pcall(pages["Home"]) end)
task.delay(0.6, function() notify("TL MENU v6", "Purple Edition geladen!", "success") end)
print("[TL MENU v6 - Purple Edition] Geladen!")
