-- ============================================================
-- OS MENU
-- Enthält: GUI-Kern, Sound-System, Notify-System
-- ============================================================

-- ========================
-- [1] SERVICES
-- ========================
local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local TweenService  = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService  = game:GetService("SoundService")
local StarterGui    = game:GetService("StarterGui")
local Debris        = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- ========================
-- [2] ENVIRONMENT COMPAT
-- ========================
local genv = (getgenv and getgenv()) or _G

if not genv.writefile  then genv.writefile  = function() end end
if not genv.readfile   then genv.readfile   = function() return nil end end
if not genv.isfile     then genv.isfile     = function() return false end end

local _task = (type(task) == "table" and task) or {
    wait  = function(t) return wait(t or 0) end,
    spawn = function(f, ...) return spawn(f, ...) end,
    delay = function(t, f, ...) return delay(t, f, ...) end,
    defer = function(f, ...) return spawn(f, ...) end,
}

-- ========================
-- [3] COLOR THEME
-- ========================
local C = {
    bg       = Color3.fromRGB(10,  10,  10),
    bg2      = Color3.fromRGB(20,  20,  20),
    bg3      = Color3.fromRGB(28,  28,  28),
    accent   = Color3.fromRGB(0,  200, 255),
    accent2  = Color3.fromRGB(0,  160, 220),
    sub      = Color3.fromRGB(0,  135, 195),
    text     = Color3.fromRGB(210, 235, 255),
    border   = Color3.fromRGB(0,  200, 255),
    panelBg  = Color3.fromRGB(10,  10,  10),
    panelHdr = Color3.fromRGB(20,  20,  20),
    red      = Color3.fromRGB(255,  60,  90),
    green    = Color3.fromRGB(0,   200, 255),
}

-- ========================
-- [4] HELPERS
-- ========================
local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function stroke(parent, thickness, color, transparency)
    local s = Instance.new("UIStroke")
    s.Thickness         = thickness or 1
    s.Color             = color or C.border
    s.Transparency      = transparency or 0.1
    s.ApplyStrokeMode   = Enum.ApplyStrokeMode.Border
    s.Parent            = parent
    return s
end

local function gradient(parent, rotation, c1, c2)
    local g = Instance.new("UIGradient")
    g.Rotation = rotation or 0
    g.Color    = ColorSequence.new(c1 or Color3.new(1,1,1), c2 or c1 or Color3.new(1,1,1))
    g.Parent   = parent
    return g
end

local TI_CACHE = {}
local function getTI(t, style, dir)
    local s = style or Enum.EasingStyle.Quart
    local d = dir   or Enum.EasingDirection.Out
    TI_CACHE[t] = TI_CACHE[t] or {}
    TI_CACHE[t][s] = TI_CACHE[t][s] or {}
    TI_CACHE[t][s][d] = TI_CACHE[t][s][d] or TweenInfo.new(t, s, d)
    return TI_CACHE[t][s][d]
end

local function tw(obj, t, props, style, dir)
    return TweenService:Create(obj, getTI(t, style, dir), props)
end

local function twP(obj, t, props, style, dir)
    local tween = tw(obj, t, props, style, dir)
    tween:Play()
    return tween
end

-- ========================
-- [5] SOUND SYSTEM
-- ========================
local Sound = {}

local hoverSoundObj = nil
local hoverLastT    = 0
local HOVER_GAP     = 0.04

pcall(function()
    hoverSoundObj = Instance.new("Sound")
    hoverSoundObj.SoundId = "rbxassetid://139800881181209"
    hoverSoundObj.Volume  = 0.5
    hoverSoundObj.RollOffMaxDistance = 10000
    hoverSoundObj.Name = "HoverSound"
end)

function Sound.playHover()
    local now = tick()
    if (now - hoverLastT) < HOVER_GAP then return end
    hoverLastT = now
    pcall(function()
        if not hoverSoundObj then return end
        local s = hoverSoundObj:Clone()
        s.Parent = SoundService
        s.Volume = 0.5
        s:Play()
        Debris:AddItem(s, 3)
    end)
end

function Sound.playToggleOn()
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://127366656618533"
        s.Volume  = 0.5
        s.Parent  = SoundService
        s:Play()
        Debris:AddItem(s, 2)
    end)
end

function Sound.playToggleOff()
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://79062163283657"
        s.Volume  = 0.6
        s.Parent  = SoundService
        s:Play()
        Debris:AddItem(s, 2)
    end)
end

-- ========================
-- [6] NOTIFY SYSTEM
-- ========================
local Notify = {}

local notifGui    = nil
local notifList   = {}
local NOTIF_W     = 300
local NOTIF_H     = 54
local NOTIF_PAD   = 8
local NOTIF_X_OFF = 16
local NOTIF_Y_OFF = 16

local function initNotifGui()
    if notifGui and notifGui.Parent then return end
    notifGui = Instance.new("ScreenGui")
    notifGui.Name           = "OSMenu_Notifs"
    notifGui.ResetOnSpawn   = false
    notifGui.IgnoreGuiInset = true
    notifGui.DisplayOrder   = 9999
    notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() notifGui.Parent = PlayerGui end)
    if not notifGui.Parent then
        pcall(function() notifGui.Parent = game:GetService("CoreGui") end)
    end
end

local function rePositionNotifs()
    local vp    = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
    local baseY = vp.Y - NOTIF_Y_OFF
    for i, entry in ipairs(notifList) do
        if entry.frame and entry.frame.Parent then
            local targetY = baseY - (i * (NOTIF_H + NOTIF_PAD))
            twP(entry.frame, 0.25, {
                Position = UDim2.new(1, -(NOTIF_W + NOTIF_X_OFF), 0, targetY)
            }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        end
    end
end

function Notify.send(title, text, duration)
    initNotifGui()
    duration = duration or 4

    local vp  = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
    local startY = vp.Y - NOTIF_Y_OFF - NOTIF_H

    -- Frame
    local frame = Instance.new("Frame", notifGui)
    frame.Size                 = UDim2.new(0, NOTIF_W, 0, NOTIF_H)
    frame.Position             = UDim2.new(1, NOTIF_X_OFF, 0, startY)
    frame.BackgroundColor3     = C.panelBg
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel      = 0
    frame.ZIndex               = 100
    corner(frame, 10)
    stroke(frame, 1, C.accent, 0.25)

    -- Accent bar
    local bar = Instance.new("Frame", frame)
    bar.Size              = UDim2.new(0, 3, 1, -16)
    bar.Position          = UDim2.new(0, 0, 0, 8)
    bar.BackgroundColor3  = C.accent
    bar.BorderSizePixel   = 0
    corner(bar, 99)

    -- Title
    local titleLbl = Instance.new("TextLabel", frame)
    titleLbl.Size                = UDim2.new(1, -52, 0, 18)
    titleLbl.Position            = UDim2.new(0, 14, 0, 8)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text                = tostring(title or "")
    titleLbl.Font                = Enum.Font.GothamBold
    titleLbl.TextSize            = 12
    titleLbl.TextColor3          = C.accent
    titleLbl.TextXAlignment      = Enum.TextXAlignment.Left
    titleLbl.ZIndex              = 101

    -- Body text
    local bodyLbl = Instance.new("TextLabel", frame)
    bodyLbl.Size                = UDim2.new(1, -20, 0, 22)
    bodyLbl.Position            = UDim2.new(0, 14, 0, 26)
    bodyLbl.BackgroundTransparency = 1
    bodyLbl.Text                = tostring(text or "")
    bodyLbl.Font                = Enum.Font.Gotham
    bodyLbl.TextSize            = 11
    bodyLbl.TextColor3          = C.text
    bodyLbl.TextXAlignment      = Enum.TextXAlignment.Left
    bodyLbl.TextTruncate        = Enum.TextTruncate.AtEnd
    bodyLbl.ZIndex              = 101

    -- Progress bar
    local prog = Instance.new("Frame", frame)
    prog.Size             = UDim2.new(1, -8, 0, 2)
    prog.Position         = UDim2.new(0, 4, 1, -4)
    prog.BackgroundColor3 = C.accent
    prog.BackgroundTransparency = 0.4
    prog.BorderSizePixel  = 0
    corner(prog, 99)

    -- Slide in
    local entry = { frame = frame }
    table.insert(notifList, 1, entry)
    rePositionNotifs()
    twP(frame, 0.35, {
        Position = UDim2.new(1, -(NOTIF_W + NOTIF_X_OFF), 0, startY)
    }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    -- Progress shrink
    twP(prog, duration, { Size = UDim2.new(0, 0, 0, 2) }, Enum.EasingStyle.Linear)

    -- Auto dismiss
    _task.delay(duration, function()
        twP(frame, 0.3, {
            Position = UDim2.new(1, NOTIF_X_OFF, 0, frame.Position.Y.Offset)
        }, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

        _task.delay(0.35, function()
            for i, e in ipairs(notifList) do
                if e == entry then
                    table.remove(notifList, i)
                    break
                end
            end
            pcall(function() frame:Destroy() end)
            rePositionNotifs()
        end)
    end)
end

-- Expose globally so other systems can call it
genv.TLSendNotif = function(title, text, dur)
    Notify.send(title, text, dur)
end

-- ========================
-- [7] MAIN SCREEN GUI
-- ========================
local GUI = {}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "OSMenuGui"
ScreenGui.ResetOnSpawn   = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder   = 999

pcall(function() ScreenGui.Parent = PlayerGui end)
if not ScreenGui.Parent then
    pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
end

-- Panel builder
local PANEL_W = 420
local panels  = {}

local function makePanel(name)
    local p = Instance.new("Frame", ScreenGui)
    p.Name                  = name
    p.Size                  = UDim2.new(0, PANEL_W, 0, 10)
    p.AnchorPoint           = Vector2.new(1, 0)
    p.Position              = UDim2.new(1, -61, 0, -600)
    p.Visible               = false
    p.ClipsDescendants      = true
    p.BackgroundColor3      = C.panelBg
    p.BackgroundTransparency = 0
    p.BorderSizePixel       = 0
    corner(p, 12)
    stroke(p, 1, C.bg3, 0)

    -- Header
    local hdr = Instance.new("Frame", p)
    hdr.Size             = UDim2.new(1, 0, 0, 48)
    hdr.BackgroundColor3 = C.panelHdr
    hdr.BorderSizePixel  = 0
    hdr.ZIndex           = 2
    corner(hdr, 12)
    gradient(hdr, 90, C.bg3, C.bg2)

    -- Header separator
    local sep = Instance.new("Frame", p)
    sep.Size             = UDim2.new(1, 0, 0, 1)
    sep.Position         = UDim2.new(0, 0, 0, 48)
    sep.BackgroundColor3 = C.accent
    sep.BackgroundTransparency = 0.4
    sep.BorderSizePixel  = 0
    sep.ZIndex           = 3

    -- Title
    local htitle = Instance.new("TextLabel", hdr)
    htitle.Size                = UDim2.new(1, -100, 1, 0)
    htitle.Position            = UDim2.new(0, 16, 0, 0)
    htitle.BackgroundTransparency = 1
    htitle.Text                = name:upper()
    htitle.Font                = Enum.Font.GothamBold
    htitle.TextSize            = 15
    htitle.TextColor3          = C.text
    htitle.TextXAlignment      = Enum.TextXAlignment.Left
    htitle.ZIndex              = 5

    -- Drag
    local dragging, dragStart, startPos = false, nil, nil
    hdr.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = UserInputService:GetMouseLocation()
            startPos  = p.Position
        end
    end)
    hdr.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    RunService.RenderStepped:Connect(function()
        if not dragging then return end
        local cur   = UserInputService:GetMouseLocation()
        local delta = cur - dragStart
        p.Position  = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end)

    -- Content scroll
    local scroll = Instance.new("ScrollingFrame", p)
    scroll.Name               = "Content"
    scroll.Size               = UDim2.new(1, -12, 1, -58)
    scroll.Position           = UDim2.new(0, 6, 0, 54)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel    = 0
    scroll.ClipsDescendants   = true
    scroll.ScrollBarThickness = 3
    scroll.CanvasSize         = UDim2.new(0, 0, 0, 0)
    scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    scroll.ElasticBehavior    = Enum.ElasticBehavior.Never
    scroll.ScrollBarImageColor3 = C.accent
    scroll.AutomaticCanvasSize  = Enum.AutomaticSize.Y

    panels[name] = p
    return p, scroll
end

local function openPanel(name)
    local p = panels[name]
    if not p then return end
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
    p.Visible = true
    twP(p, 0.35, {
        Position = UDim2.new(1, -61, 0, math.floor((vp.Y - 500) / 2))
    }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

local function closePanel(name)
    local p = panels[name]
    if not p then return end
    twP(p, 0.25, {
        Position = UDim2.new(1, -61, 0, -600)
    }, Enum.EasingStyle.Quart, Enum.EasingDirection.In).Completed:Connect(function()
        p.Visible = false
    end)
end

GUI.makePanel  = makePanel
GUI.openPanel  = openPanel
GUI.closePanel = closePanel

-- ========================
-- [8] SIDEBAR / NAVBAR
-- ========================
local NAV_W  = 52
local NAV_H  = 300
local NAV_PAD = 6

local navFrame = Instance.new("Frame", ScreenGui)
navFrame.Name                  = "Sidebar"
navFrame.Size                  = UDim2.new(0, NAV_W, 0, NAV_H)
navFrame.AnchorPoint           = Vector2.new(1, 0.5)
navFrame.Position              = UDim2.new(1, -4, 0.5, 0)
navFrame.BackgroundColor3      = C.panelBg
navFrame.BackgroundTransparency = 0
navFrame.BorderSizePixel       = 0
navFrame.ZIndex                = 10
corner(navFrame, 14)
stroke(navFrame, 1, C.accent, 0.35)
gradient(navFrame, 180, C.bg2, C.bg)

local navLayout = Instance.new("UIListLayout", navFrame)
navLayout.FillDirection        = Enum.FillDirection.Vertical
navLayout.HorizontalAlignment  = Enum.HorizontalAlignment.Center
navLayout.VerticalAlignment    = Enum.VerticalAlignment.Top
navLayout.Padding              = UDim.new(0, NAV_PAD)
navLayout.SortOrder            = Enum.SortOrder.LayoutOrder

local navPad = Instance.new("UIPadding", navFrame)
navPad.PaddingTop    = UDim.new(0, NAV_PAD)
navPad.PaddingBottom = UDim.new(0, NAV_PAD)

local navButtons   = {}
local activePanel  = nil

local function addNavButton(icon, tooltip, panelName, order)
    local btn = Instance.new("ImageButton", navFrame)
    btn.Name                  = panelName .. "_NavBtn"
    btn.Size                  = UDim2.new(0, 38, 0, 38)
    btn.BackgroundColor3      = C.bg3
    btn.BackgroundTransparency = 0.6
    btn.BorderSizePixel       = 0
    btn.LayoutOrder           = order
    btn.ZIndex                = 11
    btn.Image                 = icon
    btn.ImageColor3           = C.sub
    btn.ScaleType             = Enum.ScaleType.Fit
    corner(btn, 10)

    -- Tooltip
    local tip = Instance.new("TextLabel", btn)
    tip.Size                 = UDim2.new(0, 80, 0, 24)
    tip.Position             = UDim2.new(0, -88, 0.5, -12)
    tip.BackgroundColor3     = C.bg2
    tip.BackgroundTransparency = 0.1
    tip.BorderSizePixel      = 0
    tip.Text                 = tooltip
    tip.Font                 = Enum.Font.GothamBold
    tip.TextSize             = 11
    tip.TextColor3           = C.text
    tip.TextXAlignment       = Enum.TextXAlignment.Right
    tip.ZIndex               = 20
    tip.Visible              = false
    corner(tip, 6)

    btn.MouseEnter:Connect(function()
        Sound.playHover()
        twP(btn, 0.1, { BackgroundTransparency = 0.2, ImageColor3 = C.accent })
        tip.Visible = true
    end)
    btn.MouseLeave:Connect(function()
        if activePanel ~= panelName then
            twP(btn, 0.12, { BackgroundTransparency = 0.6, ImageColor3 = C.sub })
        end
        tip.Visible = false
    end)
    btn.MouseButton1Click:Connect(function()
        if activePanel == panelName then
            closePanel(panelName)
            twP(btn, 0.12, { BackgroundTransparency = 0.6, ImageColor3 = C.sub })
            activePanel = nil
        else
            if activePanel then
                closePanel(activePanel)
                local old = navButtons[activePanel]
                if old then
                    twP(old, 0.12, { BackgroundTransparency = 0.6, ImageColor3 = C.sub })
                end
            end
            openPanel(panelName)
            twP(btn, 0.1, { BackgroundTransparency = 0, ImageColor3 = C.accent })
            activePanel = panelName
        end
    end)

    navButtons[panelName] = btn
    return btn
end

-- ========================
-- [9] EXAMPLE PANELS
-- ========================

-- Home Panel
local homePanel, homeScroll = makePanel("Home")
homePanel.Size = UDim2.new(0, PANEL_W, 0, 300)

local greetLbl = Instance.new("TextLabel", homeScroll)
greetLbl.Size                = UDim2.new(1, -20, 0, 30)
greetLbl.Position            = UDim2.new(0, 10, 0, 10)
greetLbl.BackgroundTransparency = 1
greetLbl.Text                = "Willkommen, " .. LocalPlayer.DisplayName .. "!"
greetLbl.Font                = Enum.Font.GothamBold
greetLbl.TextSize            = 14
greetLbl.TextColor3          = C.text
greetLbl.TextXAlignment      = Enum.TextXAlignment.Left

-- Settings Panel
local settingsPanel, settingsScroll = makePanel("Settings")
settingsPanel.Size = UDim2.new(0, PANEL_W, 0, 360)

local settingsLbl = Instance.new("TextLabel", settingsScroll)
settingsLbl.Size                = UDim2.new(1, -20, 0, 30)
settingsLbl.Position            = UDim2.new(0, 10, 0, 10)
settingsLbl.BackgroundTransparency = 1
settingsLbl.Text                = "Settings"
settingsLbl.Font                = Enum.Font.GothamBold
settingsLbl.TextSize            = 14
settingsLbl.TextColor3          = C.text
settingsLbl.TextXAlignment      = Enum.TextXAlignment.Left

-- ========================
-- [10] NAV BUTTONS
-- ========================
addNavButton("rbxassetid://11341987215", "Home",     "Home",     1)
addNavButton("rbxassetid://11341987215", "Settings", "Settings", 2)

-- Adjust nav height to content
navLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    navFrame.Size = UDim2.new(0, NAV_W, 0, navLayout.AbsoluteContentSize.Y + (NAV_PAD * 2))
end)

-- ========================
-- [11] STARTUP
-- ========================
_task.spawn(function()
    _task.wait(1.5)
    Notify.send("OS Menu", "Bereit! GUI geladen ✅", 4)
end)

-- Global shortcut
genv.OSMenu = {
    GUI    = GUI,
    Sound  = Sound,
    Notify = Notify,
}

print("[OS MENU] Geladen — GUI, Sound & Notify aktiv")
