-- OS MENU v1 -- Hidden Hub Style
if not game:IsLoaded() then game.Loaded:Wait() end

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
    Character = c; Humanoid = c:WaitForChild("Humanoid"); HRP = c:WaitForChild("HumanoidRootPart")
end)

-- THEME (Hidden Hub style - dark mono)
local T = {
    BG        = Color3.fromRGB(15, 15, 17),
    TopBar    = Color3.fromRGB(18, 18, 21),
    Sidebar   = Color3.fromRGB(18, 18, 21),
    Card      = Color3.fromRGB(24, 24, 28),
    CardDeep  = Color3.fromRGB(20, 20, 23),
    Border    = Color3.fromRGB(42, 42, 50),
    Accent    = Color3.fromRGB(110, 86, 255),
    AccentDim = Color3.fromRGB(70, 55, 180),
    Green     = Color3.fromRGB(34, 197, 94),
    Red       = Color3.fromRGB(220, 50, 50),
    Yellow    = Color3.fromRGB(234, 179, 8),
    White     = Color3.fromRGB(240, 240, 242),
    TextSec   = Color3.fromRGB(155, 152, 165),
    TextMuted = Color3.fromRGB(88, 85, 96),
}

-- HELPERS
local function tw(obj, props, dur, style, dir)
    TweenService:Create(obj, TweenInfo.new(dur or 0.18, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props):Play()
end
local function cr(obj, r) local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 8); c.Parent = obj; return c end
local function st(obj, col, thick, trans)
    local s = Instance.new("UIStroke"); s.Color = col or T.Border; s.Thickness = thick or 1
    s.Transparency = trans or 0; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = obj; return s
end
local function pad(obj, l, r, t, b)
    local p = Instance.new("UIPadding"); p.PaddingLeft = UDim.new(0,l or 0); p.PaddingRight = UDim.new(0,r or l or 0)
    p.PaddingTop = UDim.new(0,t or l or 0); p.PaddingBottom = UDim.new(0,b or t or l or 0); p.Parent = obj
end
local function lbl(parent, text, size, color, font, xa, pos, sz)
    local l = Instance.new("TextLabel"); l.BackgroundTransparency = 1; l.Text = text; l.TextSize = size or 12
    l.TextColor3 = color or T.White; l.Font = font or Enum.Font.Gotham
    l.TextXAlignment = xa or Enum.TextXAlignment.Left
    if pos then l.Position = pos end; if sz then l.Size = sz else l.Size = UDim2.new(1,0,1,0) end
    l.Parent = parent; return l
end

-- DESTROY OLD
pcall(function()
    for _, n in ipairs({"OSMenu","TLMenuV6","TLMenuV5"}) do local f = CoreGui:FindFirstChild(n); if f then f:Destroy() end end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "OSMenu"; gui.ResetOnSpawn = false; gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() gui.IgnoreGuiInset = true end)
if not pcall(function() gui.Parent = CoreGui end) then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- NOTIFICATIONS
local notifHolder = Instance.new("Frame")
notifHolder.Size = UDim2.new(0,270,1,-20); notifHolder.Position = UDim2.new(0,10,0,10)
notifHolder.BackgroundTransparency = 1; notifHolder.Parent = gui
local nl = Instance.new("UIListLayout"); nl.Padding = UDim.new(0,6); nl.VerticalAlignment = Enum.VerticalAlignment.Bottom; nl.Parent = notifHolder

local function notify(title, text, ntype)
    local accent = ntype=="success" and T.Green or ntype=="error" and T.Red or ntype=="warning" and T.Yellow or T.Accent
    local n = Instance.new("Frame"); n.Size = UDim2.new(1,0,0,0); n.BackgroundColor3 = T.Card
    n.BackgroundTransparency = 0.05; n.BorderSizePixel = 0; n.ClipsDescendants = true; n.Parent = notifHolder
    cr(n,10); st(n,T.Border,1,0.3)
    local bar = Instance.new("Frame"); bar.Size = UDim2.new(0,3,1,0); bar.BackgroundColor3 = accent
    bar.BorderSizePixel = 0; bar.ZIndex = n.ZIndex+1; bar.Parent = n; cr(bar,2)
    lbl(n, title, 11, T.White, Enum.Font.GothamBold, Enum.TextXAlignment.Left, UDim2.new(0,12,0,8), UDim2.new(1,-16,0,16))
    lbl(n, text, 10, T.TextSec, Enum.Font.Gotham, Enum.TextXAlignment.Left, UDim2.new(0,12,0,26), UDim2.new(1,-16,0,16))
    tw(n, {Size = UDim2.new(1,0,0,54)}, 0.26, Enum.EasingStyle.Back)
    task.delay(3.5, function() tw(n,{Size=UDim2.new(1,0,0,0),BackgroundTransparency=1},0.18); task.wait(0.2); if n and n.Parent then n:Destroy() end end)
end

-- MAIN WINDOW
local WIN_W, WIN_H = 640, 460
local SB = 52  -- sidebar width
local TB = 50  -- topbar height

local main = Instance.new("Frame")
main.Name = "MainWindow"; main.Size = UDim2.new(0,WIN_W,0,WIN_H)
main.Position = UDim2.new(0.5,-WIN_W/2,0.5,-WIN_H/2)
main.BackgroundColor3 = T.BG; main.BackgroundTransparency = 0
main.BorderSizePixel = 0; main.ClipsDescendants = true; main.Parent = gui
cr(main,12)

-- TOP BAR
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1,0,0,TB)
-- Same color as BG so rounded corner blends in perfectly
topBar.BackgroundColor3 = T.TopBar
topBar.BackgroundTransparency = 0; topBar.BorderSizePixel = 0
topBar.ZIndex = main.ZIndex+3; topBar.Parent = main

local topSep = Instance.new("Frame")
topSep.Size = UDim2.new(1,0,0,1); topSep.Position = UDim2.new(0,0,1,-1)
topSep.BackgroundColor3 = T.Border; topSep.BackgroundTransparency = 0; topSep.BorderSizePixel = 0
topSep.ZIndex = topBar.ZIndex+1; topSep.Parent = topBar

-- Logo circle
local logoCircle = Instance.new("Frame")
logoCircle.Size = UDim2.new(0,30,0,30); logoCircle.Position = UDim2.new(0,12,0.5,-15)
logoCircle.BackgroundColor3 = T.Accent; logoCircle.BackgroundTransparency = 0.2
logoCircle.BorderSizePixel = 0; logoCircle.ZIndex = topBar.ZIndex+1; logoCircle.Parent = topBar; cr(logoCircle,8)
lbl(logoCircle,"OS",10,T.White,Enum.Font.GothamBlack,Enum.TextXAlignment.Center)

-- Title + sub
lbl(topBar,"OS MENU",13,T.White,Enum.Font.GothamBlack,Enum.TextXAlignment.Left,UDim2.new(0,50,0,9),UDim2.new(0,140,0,16)).ZIndex = topBar.ZIndex+1
lbl(topBar,"v1.0  |  by TL Scripts",9,T.TextMuted,Enum.Font.Gotham,Enum.TextXAlignment.Left,UDim2.new(0,50,0,27),UDim2.new(0,180,0,12)).ZIndex = topBar.ZIndex+1

-- FPS/Ping
local fpsPing = lbl(topBar,"FPS-- | --ms",9,T.TextMuted,Enum.Font.GothamBold,Enum.TextXAlignment.Left,UDim2.new(0,240,0,0),UDim2.new(0,140,1,0))
fpsPing.ZIndex = topBar.ZIndex+1
local fpsCount,lastT = 0,tick()
RunService.RenderStepped:Connect(function()
    fpsCount+=1; local now=tick()
    if now-lastT>=1 then
        local fps=math.round(fpsCount/(now-lastT)); local ping=0
        pcall(function() ping=math.round(LocalPlayer:GetNetworkPing()*1000) end)
        fpsPing.Text="FPS "..fps.." | "..ping.."ms"
        fpsPing.TextColor3 = ping<80 and T.Green or ping<150 and T.Yellow or T.Red
        fpsCount=0; lastT=now
    end
end)

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,26,0,26); closeBtn.Position = UDim2.new(1,-36,0.5,-13)
closeBtn.BackgroundColor3 = Color3.fromRGB(60,55,70); closeBtn.BackgroundTransparency = 0.3
closeBtn.Text = "x"; closeBtn.TextColor3 = T.TextSec; closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold; closeBtn.AutoButtonColor = false
closeBtn.ZIndex = topBar.ZIndex+1; closeBtn.Parent = topBar; cr(closeBtn,6)
closeBtn.MouseEnter:Connect(function() tw(closeBtn,{BackgroundColor3=T.Red,BackgroundTransparency=0,TextColor3=T.White},0.1) end)
closeBtn.MouseLeave:Connect(function() tw(closeBtn,{BackgroundColor3=Color3.fromRGB(60,55,70),BackgroundTransparency=0.3,TextColor3=T.TextSec},0.1) end)
closeBtn.MouseButton1Click:Connect(function()
    tw(main,{Size=UDim2.new(0,WIN_W,0,0),BackgroundTransparency=1},0.2,Enum.EasingStyle.Quart)
    task.wait(0.22); pcall(function() gui:Destroy() end)
end)

-- Dragging
do
    local drag,ds,sp=false,nil,nil
    topBar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true;ds=i.Position;sp=main.Position end end)
    topBar.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-ds; main.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
        end
    end)
end

-- SIDEBAR
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0,SB,1,-TB); sidebar.Position = UDim2.new(0,0,0,TB)
sidebar.BackgroundColor3 = T.Sidebar; sidebar.BackgroundTransparency = 0
sidebar.BorderSizePixel = 0; sidebar.ZIndex = main.ZIndex+2; sidebar.Parent = main

local sbSep = Instance.new("Frame")
sbSep.Size = UDim2.new(0,1,1,0); sbSep.Position = UDim2.new(1,-1,0,0)
sbSep.BackgroundColor3 = T.Border; sbSep.BackgroundTransparency = 0
sbSep.BorderSizePixel = 0; sbSep.ZIndex = sidebar.ZIndex+1; sbSep.Parent = sidebar

local sbLayout = Instance.new("UIListLayout")
sbLayout.Padding = UDim.new(0,2); sbLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sbLayout.VerticalAlignment = Enum.VerticalAlignment.Top; sbLayout.Parent = sidebar
pad(sidebar,0,0,8,8)

-- CONTENT AREA
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1,-SB,1,-TB); contentFrame.Position = UDim2.new(0,SB,0,TB)
contentFrame.BackgroundTransparency = 1; contentFrame.ClipsDescendants = true
contentFrame.ZIndex = main.ZIndex+1; contentFrame.Parent = main

local contentScroll = Instance.new("ScrollingFrame")
contentScroll.Size = UDim2.new(1,0,1,0); contentScroll.BackgroundTransparency = 1
contentScroll.BorderSizePixel = 0; contentScroll.ScrollBarThickness = 3
contentScroll.ScrollBarImageColor3 = T.Accent; contentScroll.CanvasSize = UDim2.new(0,0,0,0)
contentScroll.Parent = contentFrame; pad(contentScroll,14,14,14,14)

local contentList = Instance.new("UIListLayout")
contentList.Padding = UDim.new(0,8); contentList.Parent = contentScroll
contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    contentScroll.CanvasSize = UDim2.new(0,0,0,contentList.AbsoluteContentSize.Y+24)
end)

-- UI BUILDERS
local function makeSection(parent, text)
    local f = Instance.new("Frame"); f.Size = UDim2.new(1,0,0,20); f.BackgroundTransparency=1; f.Parent=parent
    lbl(f,text:upper(),9,T.TextMuted,Enum.Font.GothamBold,Enum.TextXAlignment.Left)
    return f
end

local function makeCard(parent, h, col, trans)
    local c = Instance.new("Frame"); c.Size = UDim2.new(1,0,0,h or 56)
    c.BackgroundColor3 = col or T.Card; c.BackgroundTransparency = trans or 0
    c.BorderSizePixel = 0; c.Parent = parent; cr(c,8); st(c,T.Border,1,0.4); return c
end

local function makeToggle(parent, labelTxt, default, callback)
    local row = makeCard(parent,46); pad(row,14,14,0,0)
    lbl(row,labelTxt,11,T.White,Enum.Font.Gotham,Enum.TextXAlignment.Left,nil,UDim2.new(1,-60,1,0))
    local track = Instance.new("TextButton")
    track.Size = UDim2.new(0,38,0,20); track.Position = UDim2.new(1,-52,0.5,-10)
    track.BackgroundColor3 = default and T.Accent or Color3.fromRGB(42,40,52)
    track.Text=""; track.AutoButtonColor=false; track.ZIndex=row.ZIndex+1; track.Parent=row; cr(track,10)
    st(track,default and T.Accent or T.Border,1,0.3)
    local knob = Instance.new("Frame"); knob.Size = UDim2.new(0,14,0,14)
    knob.Position = default and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
    knob.BackgroundColor3 = T.White; knob.BorderSizePixel=0; knob.ZIndex=track.ZIndex+1; knob.Parent=track; cr(knob,7)
    local state = default or false
    track.MouseButton1Click:Connect(function()
        state = not state
        if state then
            tw(track,{BackgroundColor3=T.Accent},0.14); tw(knob,{Position=UDim2.new(1,-17,0.5,-7)},0.14,Enum.EasingStyle.Back)
            local s2=track:FindFirstChildWhichIsA("UIStroke"); if s2 then tw(s2,{Color=T.Accent},0.14) end
        else
            tw(track,{BackgroundColor3=Color3.fromRGB(42,40,52)},0.14); tw(knob,{Position=UDim2.new(0,3,0.5,-7)},0.14)
            local s2=track:FindFirstChildWhichIsA("UIStroke"); if s2 then tw(s2,{Color=T.Border},0.14) end
        end
        pcall(callback,state)
    end)
    return row
end

local function makeSlider(parent, labelTxt, min, max, default, callback)
    local row = makeCard(parent,58); pad(row,14,14,8,8)
    local topR = Instance.new("Frame"); topR.Size=UDim2.new(1,0,0,16); topR.BackgroundTransparency=1; topR.Parent=row
    lbl(topR,labelTxt,11,T.White,Enum.Font.Gotham,Enum.TextXAlignment.Left,nil,UDim2.new(1,-50,1,0))
    local vbg = Instance.new("Frame"); vbg.Size=UDim2.new(0,42,0,16); vbg.Position=UDim2.new(1,-42,0,0)
    vbg.BackgroundColor3=Color3.fromRGB(36,34,46); vbg.BorderSizePixel=0; vbg.Parent=topR; cr(vbg,5); st(vbg,T.Border,1,0.3)
    local valLbl = lbl(vbg,tostring(default),10,T.Accent,Enum.Font.GothamBold)
    local sliderTrack = Instance.new("Frame"); sliderTrack.Size=UDim2.new(1,0,0,4); sliderTrack.Position=UDim2.new(0,0,0,36)
    sliderTrack.BackgroundColor3=Color3.fromRGB(36,34,46); sliderTrack.BorderSizePixel=0; sliderTrack.Parent=row; cr(sliderTrack,2)
    local fill = Instance.new("Frame"); fill.Size=UDim2.new((default-min)/(max-min),0,1,0)
    fill.BackgroundColor3=T.Accent; fill.BorderSizePixel=0; fill.Parent=sliderTrack; cr(fill,2)
    local thumb = Instance.new("TextButton"); thumb.Size=UDim2.new(0,12,0,12)
    thumb.Position=UDim2.new((default-min)/(max-min),-6,0.5,-6); thumb.BackgroundColor3=T.White
    thumb.Text=""; thumb.AutoButtonColor=false; thumb.ZIndex=sliderTrack.ZIndex+1; thumb.Parent=sliderTrack; cr(thumb,6)
    local dragging=false
    local function upd(i)
        local rel=math.clamp((i.Position.X-sliderTrack.AbsolutePosition.X)/sliderTrack.AbsoluteSize.X,0,1)
        local v=math.floor(min+(max-min)*rel)
        fill.Size=UDim2.new(rel,0,1,0); thumb.Position=UDim2.new(rel,-6,0.5,-6); valLbl.Text=tostring(v); pcall(callback,v)
    end
    thumb.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end end)
    sliderTrack.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then upd(i);dragging=true end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then upd(i) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
    return row
end

local function makeButton(parent, text, callback, accent)
    local btn = Instance.new("TextButton"); btn.Size=UDim2.new(1,0,0,36)
    btn.BackgroundColor3=accent and T.Accent or Color3.fromRGB(30,28,38)
    btn.BackgroundTransparency=accent and 0 or 0.3; btn.Text=text
    btn.TextColor3=T.White; btn.TextSize=11; btn.Font=Enum.Font.GothamBold
    btn.AutoButtonColor=false; btn.Parent=parent; cr(btn,8)
    if not accent then st(btn,T.Border,1,0.3) end
    btn.MouseEnter:Connect(function() tw(btn,{BackgroundTransparency=0,BackgroundColor3=accent and T.AccentDim or Color3.fromRGB(38,36,50)},0.1) end)
    btn.MouseLeave:Connect(function() tw(btn,{BackgroundColor3=accent and T.Accent or Color3.fromRGB(30,28,38),BackgroundTransparency=accent and 0 or 0.3},0.1) end)
    btn.MouseButton1Click:Connect(function()
        tw(btn,{Size=UDim2.new(0.97,0,0,34)},0.06); task.wait(0.07)
        tw(btn,{Size=UDim2.new(1,0,0,36)},0.12,Enum.EasingStyle.Back); pcall(callback)
    end)
    return btn
end
-- PAGES
local pages = {}
local function clearContent()
    for _,c in pairs(contentScroll:GetChildren()) do
        if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
    end
    contentScroll.CanvasPosition = Vector2.new(0,0)
end

-- HOME
pages["Home"] = function()
    -- User info card
    local userCard = makeCard(contentScroll, 66)
    pad(userCard, 12, 12, 0, 0)
    local avBg = Instance.new("Frame"); avBg.Size=UDim2.new(0,42,0,42); avBg.Position=UDim2.new(0,0,0.5,-21)
    avBg.BackgroundColor3=Color3.fromRGB(36,34,48); avBg.BorderSizePixel=0; avBg.ZIndex=userCard.ZIndex+1; avBg.Parent=userCard; cr(avBg,8)
    local av = Instance.new("ImageLabel"); av.Size=UDim2.new(1,0,1,0); av.BackgroundTransparency=1
    pcall(function() av.Image="https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=48&height=48&format=png" end)
    av.ZIndex=avBg.ZIndex+1; av.Parent=avBg; cr(av,8)
    local nameLbl = Instance.new("TextLabel"); nameLbl.Size=UDim2.new(1,-54,0,20); nameLbl.Position=UDim2.new(0,54,0,12)
    nameLbl.BackgroundTransparency=1; nameLbl.Text="Hello, "..LocalPlayer.Name.."!"; nameLbl.TextColor3=T.White
    nameLbl.TextSize=14; nameLbl.Font=Enum.Font.GothamBlack; nameLbl.TextXAlignment=Enum.TextXAlignment.Left
    nameLbl.ZIndex=userCard.ZIndex+1; nameLbl.Parent=userCard
    local subNameLbl = Instance.new("TextLabel"); subNameLbl.Size=UDim2.new(1,-54,0,14); subNameLbl.Position=UDim2.new(0,54,0,34)
    subNameLbl.BackgroundTransparency=1; subNameLbl.Text=LocalPlayer.Name.." | OS MENU v1.0"
    subNameLbl.TextColor3=T.TextSec; subNameLbl.TextSize=10; subNameLbl.Font=Enum.Font.Gotham
    subNameLbl.TextXAlignment=Enum.TextXAlignment.Left; subNameLbl.ZIndex=userCard.ZIndex+1; subNameLbl.Parent=userCard

    -- Server Info section
    makeSection(contentScroll, "Server")
    local serverGrid = Instance.new("Frame"); serverGrid.Size=UDim2.new(1,0,0,126); serverGrid.BackgroundTransparency=1; serverGrid.Parent=contentScroll
    local sg = Instance.new("UIGridLayout"); sg.CellSize=UDim2.new(0.5,-5,0,38); sg.CellPadding=UDim2.new(0,8,0,8); sg.Parent=serverGrid
    local function infoCell(label, value)
        local cell = Instance.new("Frame"); cell.BackgroundColor3=T.CardDeep; cell.BackgroundTransparency=0; cell.BorderSizePixel=0; cell.Parent=serverGrid; cr(cell,7); st(cell,T.Border,1,0.4)
        pad(cell,10,10,0,0)
        local l = Instance.new("TextLabel"); l.Size=UDim2.new(1,0,0,14); l.BackgroundTransparency=1; l.Text=label
        l.TextColor3=T.TextMuted; l.TextSize=9; l.Font=Enum.Font.GothamBold; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=cell
        local v = Instance.new("TextLabel"); v.Size=UDim2.new(1,0,0,14); v.Position=UDim2.new(0,0,0,16); v.BackgroundTransparency=1; v.Text=value
        v.TextColor3=T.White; v.TextSize=11; v.Font=Enum.Font.GothamBold; v.TextXAlignment=Enum.TextXAlignment.Left; v.Parent=cell
    end
    local ping=0; pcall(function() ping=math.round(LocalPlayer:GetNetworkPing()*1000) end)
    infoCell("Players", tostring(#Players:GetPlayers()).." playing")
    infoCell("Max Players", tostring(game.Players.MaxPlayers).." max")
    infoCell("Latency", ping.."ms")
    infoCell("Game ID", tostring(game.PlaceId))

    -- OS MENU card (like the "Wave" card)
    local featCard = makeCard(contentScroll, 58, Color3.fromRGB(55,35,100), 0)
    pad(featCard, 14, 14, 10, 10)
    st(featCard, T.Accent, 1, 0.5)
    local ft = Instance.new("TextLabel"); ft.Size=UDim2.new(1,0,0,18); ft.BackgroundTransparency=1
    ft.Text="OS MENU  v1.0"; ft.TextColor3=T.White; ft.TextSize=13; ft.Font=Enum.Font.GothamBlack
    ft.TextXAlignment=Enum.TextXAlignment.Left; ft.ZIndex=featCard.ZIndex+1; ft.Parent=featCard
    local fs = Instance.new("TextLabel"); fs.Size=UDim2.new(1,0,0,14); fs.Position=UDim2.new(0,0,0,22)
    fs.BackgroundTransparency=1; fs.Text="Script loaded successfully!"
    fs.TextColor3=Color3.fromRGB(190,175,255); fs.TextSize=10; fs.Font=Enum.Font.Gotham
    fs.TextXAlignment=Enum.TextXAlignment.Left; fs.ZIndex=featCard.ZIndex+1; fs.Parent=featCard
end

-- PLAYER
local invisRunning=false
pages["Player"] = function()
    makeSection(contentScroll,"Appearance")
    makeToggle(contentScroll,"Invisible FE",false,function(s)
        if s then
            invisRunning=true
            local char=Character; if not char then return end
            for _,p in pairs(char:GetDescendants()) do if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then p.Transparency=1 end end
            local conn; conn=RunService.Heartbeat:Connect(function()
                if not invisRunning then conn:Disconnect(); return end
                for _,v in pairs(char:GetChildren()) do
                    if v:IsA("BasePart") and v.Name~="HumanoidRootPart" then v.Velocity=Vector3.new(0,0,0); v.CFrame=CFrame.new(9e9,9e9,9e9) end
                end
            end)
            notify("Invisible","Others cant see you!","success")
        else invisRunning=false; notify("Invisible","Rejoin to become visible again!","warning") end
    end)
    makeSection(contentScroll,"Stats")
    makeSlider(contentScroll,"Walk Speed",16,500,16,function(v) pcall(function() if Humanoid then Humanoid.WalkSpeed=v end end) end)
    makeSlider(contentScroll,"Jump Power",50,500,50,function(v) pcall(function() if Humanoid then Humanoid.JumpPower=v end end) end)
    makeSection(contentScroll,"Survival")
    local godConn=nil
    makeToggle(contentScroll,"God Mode",false,function(s)
        pcall(function()
            if godConn then godConn:Disconnect(); godConn=nil end
            if not Humanoid then return end
            if s then
                Humanoid.MaxHealth=math.huge; Humanoid.Health=math.huge
                godConn=Humanoid:GetPropertyChangedSignal("Health"):Connect(function() if Humanoid then Humanoid.Health=math.huge end end)
            else Humanoid.MaxHealth=100; Humanoid.Health=100 end
        end)
        notify("God Mode",s and "Invincible!" or "Normal!","success")
    end)
end

-- WORLD
pages["World"] = function()
    local flyEnabled,flyConn,flyBody,flySpd=false,nil,nil,80
    makeSection(contentScroll,"Fly")
    makeToggle(contentScroll,"Fly Mode",false,function(s)
        flyEnabled=s; pcall(function()
            if s then
                if not HRP then notify("Fly","No character!","error"); return end
                flyBody=Instance.new("BodyVelocity"); flyBody.MaxForce=Vector3.new(9e9,9e9,9e9); flyBody.Velocity=Vector3.zero; flyBody.Parent=HRP
                flyConn=RunService.RenderStepped:Connect(function()
                    if not flyEnabled or not HRP then return end
                    local dir=Vector3.zero; local cam=Camera
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir+=cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir-=cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir-=cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir+=cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir+=Vector3.new(0,1,0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir-=Vector3.new(0,1,0) end
                    flyBody.Velocity=dir.Magnitude>0 and dir.Unit*flySpd or Vector3.zero
                end)
                notify("Fly","WASD + Space/Shift!","success")
            else
                if flyConn then flyConn:Disconnect(); flyConn=nil end
                if flyBody then flyBody:Destroy(); flyBody=nil end
                notify("Fly","Disabled!","warning")
            end
        end)
    end)
    makeSlider(contentScroll,"Fly Speed",10,300,80,function(v) flySpd=v end)
    makeSection(contentScroll,"Movement")
    local ncConn=nil
    makeToggle(contentScroll,"No Clip",false,function(s)
        pcall(function()
            if s then
                ncConn=RunService.Stepped:Connect(function()
                    if not Character then return end
                    for _,p in pairs(Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
                end); notify("No Clip","Through walls!","success")
            else
                if ncConn then ncConn:Disconnect(); ncConn=nil end
                if Character then for _,p in pairs(Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end
                notify("No Clip","Disabled!","warning")
            end
        end)
    end)
    makeToggle(contentScroll,"Infinite Jump",false,function(s)
        if s then UserInputService.JumpRequest:Connect(function() if Humanoid then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end) end
        notify("Infinite Jump",s and "Active!" or "Disabled!","success")
    end)
end

-- TOOLS
pages["Tools"] = function()
    makeSection(contentScroll,"Actions")
    makeButton(contentScroll,"Rejoin Server",function()
        notify("Rejoin","Reconnecting...","success"); task.wait(0.8)
        pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LocalPlayer) end)
    end,true)
    makeButton(contentScroll,"Respawn",function()
        pcall(function() if Character then Character:BreakJoints() end end)
        notify("Respawn","You will respawn!","success")
    end)
    makeSection(contentScroll,"Visual")
    local espConns={}
    makeToggle(contentScroll,"Player ESP",false,function(s)
        pcall(function()
            for _,c in pairs(espConns) do c:Disconnect() end; espConns={}
            for _,p in pairs(Players:GetPlayers()) do
                if p~=LocalPlayer and p.Character then
                    if s then
                        local hl=Instance.new("Highlight"); hl.Name="OSESP"; hl.FillColor=Color3.fromRGB(70,40,140)
                        hl.OutlineColor=T.Accent; hl.FillTransparency=0.7; hl.Parent=p.Character
                    else for _,v in pairs(p.Character:GetChildren()) do if v.Name=="OSESP" then v:Destroy() end end end
                end
            end
        end)
        notify("ESP",s and "Players highlighted!" or "Off!","success")
    end)
    makeToggle(contentScroll,"Full Bright",false,function(s)
        pcall(function()
            if s then Lighting.Brightness=10;Lighting.ClockTime=12;Lighting.FogEnd=100000;Lighting.GlobalShadows=false
            else Lighting.Brightness=2;Lighting.ClockTime=14;Lighting.FogEnd=1000;Lighting.GlobalShadows=true end
        end)
        notify("Full Bright",s and "Bright!" or "Normal!","success")
    end)
    makeToggle(contentScroll,"Anti-AFK",false,function(s)
        if s then pcall(function()
            local VU=game:GetService("VirtualUser")
            LocalPlayer.Idled:Connect(function() VU:CaptureController();VU:ClickButton2(Vector2.new()) end)
        end); notify("Anti-AFK","No kick!","success")
        else notify("Anti-AFK","Disabled!","warning") end
    end)
end

-- PLAYERS
pages["Players"] = function()
    makeSection(contentScroll,"Online ("..#Players:GetPlayers()..")")
    for _,p in pairs(Players:GetPlayers()) do
        local isMe=p==LocalPlayer
        local row=makeCard(contentScroll,50); pad(row,10,10,0,0)
        if isMe then
            local bar=Instance.new("Frame"); bar.Size=UDim2.new(0,3,0,28); bar.Position=UDim2.new(0,0,0.5,-14)
            bar.BackgroundColor3=T.Accent; bar.BackgroundTransparency=0; bar.BorderSizePixel=0
            bar.ZIndex=row.ZIndex+1; bar.Parent=row; cr(bar,2)
        end
        local av=Instance.new("ImageLabel"); av.Size=UDim2.new(0,28,0,28); av.Position=UDim2.new(0,8,0.5,-14)
        av.BackgroundColor3=Color3.fromRGB(36,34,48); av.BorderSizePixel=0; av.ZIndex=row.ZIndex+1; av.Parent=row; cr(av,6)
        pcall(function() av.Image="https://www.roblox.com/headshot-thumbnail/image?userId="..p.UserId.."&width=48&height=48&format=png" end)
        st(av,isMe and T.Accent or T.Border,1,0.4)
        local nl2=Instance.new("TextLabel"); nl2.Size=UDim2.new(1,-46,0,14); nl2.Position=UDim2.new(0,42,0.5,-14)
        nl2.BackgroundTransparency=1; nl2.Text=p.Name; nl2.TextColor3=isMe and T.Accent or T.White
        nl2.TextSize=11; nl2.Font=Enum.Font.GothamBold; nl2.TextXAlignment=Enum.TextXAlignment.Left
        nl2.ZIndex=row.ZIndex+1; nl2.Parent=row
        local idl=Instance.new("TextLabel"); idl.Size=UDim2.new(1,-46,0,11); idl.Position=UDim2.new(0,42,0.5,2)
        idl.BackgroundTransparency=1; idl.Text="ID "..p.UserId..(isMe and " | you" or "")
        idl.TextColor3=T.TextMuted; idl.TextSize=9; idl.Font=Enum.Font.Gotham
        idl.TextXAlignment=Enum.TextXAlignment.Left; idl.ZIndex=row.ZIndex+1; idl.Parent=row
    end
end

-- SETTINGS
pages["Settings"] = function()
    makeSection(contentScroll,"About")
    local about=makeCard(contentScroll,62); pad(about,14,14,10,10)
    local bar=Instance.new("Frame"); bar.Size=UDim2.new(0,3,0,38); bar.Position=UDim2.new(0,0,0.5,-19)
    bar.BackgroundColor3=T.Accent; bar.BackgroundTransparency=0; bar.BorderSizePixel=0
    bar.ZIndex=about.ZIndex+1; bar.Parent=about; cr(bar,2)
    local at=Instance.new("TextLabel"); at.Size=UDim2.new(1,0,0,18); at.BackgroundTransparency=1
    at.Text="OS MENU v1.0"; at.TextColor3=T.White; at.TextSize=13; at.Font=Enum.Font.GothamBlack
    at.TextXAlignment=Enum.TextXAlignment.Left; at.ZIndex=about.ZIndex+1; at.Parent=about
    local as2=Instance.new("TextLabel"); as2.Size=UDim2.new(1,0,0,12); as2.Position=UDim2.new(0,0,0,22)
    as2.BackgroundTransparency=1; as2.Text="Hidden Hub Style | by TL Scripts"
    as2.TextColor3=T.TextMuted; as2.TextSize=9; as2.Font=Enum.Font.Gotham
    as2.TextXAlignment=Enum.TextXAlignment.Left; as2.ZIndex=about.ZIndex+1; as2.Parent=about
    makeSection(contentScroll,"Actions")
    makeButton(contentScroll,"Close Menu",function()
        tw(main,{Size=UDim2.new(0,WIN_W,0,0),BackgroundTransparency=1},0.2,Enum.EasingStyle.Quart)
        task.wait(0.22); pcall(function() gui:Destroy() end)
    end)
    makeButton(contentScroll,"Test Notification",function() notify("OS MENU","Everything works!","success") end,true)
end

-- SIDEBAR TAB BUTTONS
local tabDefs = {
    {name="Home",     icon="Home"},
    {name="Player",   icon="Me"},
    {name="World",    icon="World"},
    {name="Tools",    icon="Tools"},
    {name="Players",  icon="List"},
    {name="Settings", icon="Set"},
}
local activeTabBtn=nil

local function switchTab(name, btnRef)
    if activeTabBtn and activeTabBtn~=btnRef then
        tw(activeTabBtn,{BackgroundColor3=T.Sidebar,BackgroundTransparency=0},0.15)
        local ob=activeTabBtn:FindFirstChild("_bar"); if ob then tw(ob,{BackgroundTransparency=1},0.15) end
        local oi=activeTabBtn:FindFirstChild("_icon"); if oi then tw(oi,{TextColor3=T.TextMuted},0.15) end
    end
    activeTabBtn=btnRef
    tw(btnRef,{BackgroundColor3=Color3.fromRGB(36,32,52),BackgroundTransparency=0},0.15)
    local nb=btnRef:FindFirstChild("_bar"); if nb then tw(nb,{BackgroundTransparency=0},0.15) end
    local ni=btnRef:FindFirstChild("_icon"); if ni then tw(ni,{TextColor3=T.White},0.15) end
    clearContent(); if pages[name] then pcall(pages[name]) end
end

for i,data in ipairs(tabDefs) do
    local isFirst=i==1
    local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,-4,0,44)
    btn.BackgroundColor3=isFirst and Color3.fromRGB(36,32,52) or T.Sidebar
    btn.BackgroundTransparency=0; btn.Text=""; btn.AutoButtonColor=false
    btn.ZIndex=sidebar.ZIndex+1; btn.Parent=sidebar; cr(btn,8)

    local bar=Instance.new("Frame"); bar.Name="_bar"
    bar.Size=UDim2.new(0,3,0,24); bar.Position=UDim2.new(0,-1,0.5,-12)
    bar.BackgroundColor3=T.Accent; bar.BackgroundTransparency=isFirst and 0 or 1
    bar.BorderSizePixel=0; bar.ZIndex=btn.ZIndex+1; bar.Parent=btn; cr(bar,2)

    local icon=Instance.new("TextLabel"); icon.Name="_icon"
    icon.Size=UDim2.new(1,0,1,0); icon.BackgroundTransparency=1
    icon.Text=data.icon; icon.TextColor3=isFirst and T.White or T.TextMuted
    icon.TextSize=16; icon.Font=Enum.Font.GothamBold
    icon.ZIndex=btn.ZIndex+1; icon.Parent=btn

    if isFirst then activeTabBtn=btn end
    local cName,cBtn=data.name,btn
    btn.MouseButton1Click:Connect(function() switchTab(cName,cBtn) end)
    btn.MouseEnter:Connect(function()
        if cBtn~=activeTabBtn then tw(cBtn,{BackgroundColor3=Color3.fromRGB(28,26,38)},0.1) end
    end)
    btn.MouseLeave:Connect(function()
        if cBtn~=activeTabBtn then tw(cBtn,{BackgroundColor3=T.Sidebar},0.1) end
    end)
end

-- START: open animation + load home
main.Size = UDim2.new(0,WIN_W,0,0)
tw(main,{Size=UDim2.new(0,WIN_W,0,WIN_H)},0.3,Enum.EasingStyle.Back)
task.delay(0.1,function() pcall(pages["Home"]) end)
task.delay(0.7,function() notify("OS MENU","Script loaded!","success") end)
print("[OS MENU v1.0] Loaded!")
