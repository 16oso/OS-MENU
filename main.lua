-- ============================================
-- TL MENU v6 — AudioCrafter Style
-- Purple · Cards · Bottom Tabs · Dark Glass
-- ============================================
-- Einstiegspunkt: Lädt alle Module und startet
-- das Menü.
-- ============================================

-- ── Module laden ──────────────────────────
local Theme    = require(script.config.theme)
local Helpers  = require(script.utils.helpers)
local Services = require(script.core.services)
local GUI      = require(script.core.gui)
local Notify   = require(script.core.notifications)
local UI       = require(script.components.builders)

-- ── Pages laden ───────────────────────────
local pages = {
    Home     = require(script.pages.home),
    Player   = require(script.pages.player),
    World    = require(script.pages.world),
    Tools    = require(script.pages.tools),
    Players  = require(script.pages.players),
    Settings = require(script.pages.settings),
}

-- ── Notifications initialisieren ──────────
Notify.init(GUI.screenGui)

-- ── Tab-Definitionen ──────────────────────
local tabDefs = {
    {name = "Home",     emoji = "🏠"},
    {name = "Player",   emoji = "👤"},
    {name = "World",    emoji = "🌍"},
    {name = "Tools",    emoji = "⚡"},
    {name = "Players",  emoji = "👥"},
    {name = "Settings", emoji = "⚙️"},
}

-- ── Tab-Wechsel-Logik ─────────────────────
local tw = Helpers.tween
local cr = Helpers.corner
local st = Helpers.stroke

local activeTabBtn = nil

local function switchTab(name, btnRef)
    -- Alten Tab deaktivieren
    if activeTabBtn and activeTabBtn ~= btnRef then
        tw(activeTabBtn, {BackgroundColor3 = Theme.TabBG, BackgroundTransparency = 0.2})
        local oldTxt = activeTabBtn:FindFirstChildWhichIsA("TextLabel")
        if oldTxt then tw(oldTxt, {TextColor3 = Theme.TextSec}, 0.1) end
    end

    -- Neuen Tab aktivieren
    activeTabBtn = btnRef
    tw(btnRef, {BackgroundColor3 = Theme.White, BackgroundTransparency = 0}, 0.15)
    local newTxt = btnRef:FindFirstChildWhichIsA("TextLabel")
    if newTxt then tw(newTxt, {TextColor3 = Color3.fromRGB(0, 0, 0)}, 0.1) end

    -- Content laden
    GUI.clearContent()
    if pages[name] then
        pcall(pages[name])
    end
end

-- ── Tab-Buttons erstellen ─────────────────
for i, data in ipairs(tabDefs) do
    local isFirst = i == 1
    local btnW    = 100

    local btn = Instance.new("TextButton")
    btn.Size                   = UDim2.new(0, btnW, 0, 32)
    btn.BackgroundColor3       = isFirst and Theme.White or Theme.TabBG
    btn.BackgroundTransparency = isFirst and 0 or 0.2
    btn.Text                   = ""
    btn.AutoButtonColor        = false
    btn.ZIndex                 = GUI.tabInner.ZIndex + 1  -- tabBar ZIndex context
    btn.Parent                 = GUI.tabInner
    cr(btn, 16)
    if not isFirst then st(btn, Theme.Border, 1, 0.4) end

    local lbl = Instance.new("TextLabel")
    lbl.Size                   = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text                   = data.name
    lbl.TextColor3             = isFirst and Color3.fromRGB(0, 0, 0) or Theme.TextSec
    lbl.TextSize               = 11
    lbl.Font                   = Enum.Font.GothamBold
    lbl.ZIndex                 = btn.ZIndex + 1
    lbl.Parent                 = btn

    if isFirst then activeTabBtn = btn end

    local capturedName = data.name
    local capturedBtn  = btn

    btn.MouseButton1Click:Connect(function()
        switchTab(capturedName, capturedBtn)
    end)
    btn.MouseEnter:Connect(function()
        if capturedBtn ~= activeTabBtn then
            tw(capturedBtn, {BackgroundTransparency = 0.05}, 0.1)
        end
    end)
    btn.MouseLeave:Connect(function()
        if capturedBtn ~= activeTabBtn then
            tw(capturedBtn, {BackgroundTransparency = 0.2}, 0.1)
        end
    end)
end

-- ── Öffnungs-Animation ───────────────────
local WIN_W = GUI.WIN_W
local WIN_H = GUI.WIN_H

GUI.mainFrame.Size = UDim2.new(0, WIN_W, 0, 0)
tw(GUI.mainFrame, {Size = UDim2.new(0, WIN_W, 0, WIN_H)}, 0.32, Enum.EasingStyle.Back)

-- Home-Tab laden
task.delay(0.1, function()
    pcall(pages["Home"])
end)

-- Willkommens-Notification
task.delay(0.6, function()
    Notify.send("TL MENU v6", "Purple Edition geladen!", "success")
end)

print("[TL MENU v6 - Purple Edition] Geladen!")
