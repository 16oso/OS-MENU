-- OS MENU -- Hidden Hub Style v2
if not game:IsLoaded() then game.Loaded:Wait() end

local Players=game:GetService("Players"); local RunService=game:GetService("RunService")
local TweenService=game:GetService("TweenService"); local UserInputService=game:GetService("UserInputService")
local Workspace=game:GetService("Workspace"); local Lighting=game:GetService("Lighting")
local CoreGui=game:GetService("CoreGui"); local TeleportService=game:GetService("TeleportService")
local LocalPlayer=Players.LocalPlayer; local Camera=Workspace.CurrentCamera
local Character,Humanoid,HRP
local function updateChar() Character=LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait(); Humanoid=Character:WaitForChild("Humanoid"); HRP=Character:WaitForChild("HumanoidRootPart") end
updateChar()
LocalPlayer.CharacterAdded:Connect(function(c) Character=c; Humanoid=c:WaitForChild("Humanoid"); HRP=c:WaitForChild("HumanoidRootPart") end)

local T={
    Card=Color3.fromRGB(16,16,20), CardServer=Color3.fromRGB(18,48,32), CardFriends=Color3.fromRGB(16,16,38),
    CardRed=Color3.fromRGB(45,16,16), CardBlue=Color3.fromRGB(18,18,52), CardDark=Color3.fromRGB(14,14,18),
    NavBG=Color3.fromRGB(18,18,22), NavActive=Color3.fromRGB(55,80,220),
    Border=Color3.fromRGB(50,50,62), Accent=Color3.fromRGB(90,110,240),
    Green=Color3.fromRGB(34,200,100), Red=Color3.fromRGB(220,50,50), Yellow=Color3.fromRGB(234,180,8),
    White=Color3.fromRGB(240,240,242), TextSec=Color3.fromRGB(148,146,158), TextMuted=Color3.fromRGB(88,86,98),
}

local function tw(o,p,d,s,dr) TweenService:Create(o,TweenInfo.new(d or .18,s or Enum.EasingStyle.Quart,dr or Enum.EasingDirection.Out),p):Play() end
local function cr(o,r) local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 8);c.Parent=o;return c end
local function st(o,c,t,tr) local s=Instance.new("UIStroke");s.Color=c or T.Border;s.Thickness=t or 1;s.Transparency=tr or 0;s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;s.Parent=o;return s end
local function pad(o,l,r,t,b) local p=Instance.new("UIPadding");p.PaddingLeft=UDim.new(0,l or 0);p.PaddingRight=UDim.new(0,r or l or 0);p.PaddingTop=UDim.new(0,t or l or 0);p.PaddingBottom=UDim.new(0,b or t or l or 0);p.Parent=o end

pcall(function()
    for _,n in ipairs({"OSMenu","TLMenuV6","TLMenuV5"}) do
        local f=CoreGui:FindFirstChild(n); if f then f:Destroy() end
        pcall(function() local f2=LocalPlayer.PlayerGui:FindFirstChild(n); if f2 then f2:Destroy() end end)
    end
end)

local gui=Instance.new("ScreenGui"); gui.Name="OSMenu"; gui.ResetOnSpawn=false; gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
pcall(function() gui.IgnoreGuiInset=true end)
if not pcall(function() gui.Parent=CoreGui end) then gui.Parent=LocalPlayer:WaitForChild("PlayerGui") end

-- STATUS TOP CENTER
local statusLbl=Instance.new("TextLabel"); statusLbl.Size=UDim2.new(0,200,0,18); statusLbl.Position=UDim2.new(0.5,-100,0,6)
statusLbl.BackgroundTransparency=1; statusLbl.Text="Unknown Status"; statusLbl.TextColor3=T.TextMuted
statusLbl.TextSize=10; statusLbl.Font=Enum.Font.Gotham; statusLbl.ZIndex=10; statusLbl.Parent=gui

-- NOTIFICATIONS
local notifHolder=Instance.new("Frame"); notifHolder.Size=UDim2.new(0,240,0,260); notifHolder.Position=UDim2.new(0,8,1,-270)
notifHolder.BackgroundTransparency=1; notifHolder.BorderSizePixel=0; notifHolder.ZIndex=20; notifHolder.Parent=gui
local notifLayout=Instance.new("UIListLayout"); notifLayout.Padding=UDim.new(0,6); notifLayout.VerticalAlignment=Enum.VerticalAlignment.Bottom; notifLayout.Parent=notifHolder

local function notify(title,text,ntype)
    local accent=ntype=="success" and T.Green or ntype=="error" and T.Red or ntype=="warning" and T.Yellow or T.Accent
    local n=Instance.new("Frame"); n.Size=UDim2.new(1,0,0,0); n.BackgroundColor3=T.CardDark; n.BackgroundTransparency=0.08; n.BorderSizePixel=0; n.ClipsDescendants=true; n.ZIndex=20; n.Parent=notifHolder
    cr(n,10); st(n,T.Border,1,0.4)
    local bar=Instance.new("Frame"); bar.Size=UDim2.new(0,3,1,0); bar.BackgroundColor3=accent; bar.BorderSizePixel=0; bar.ZIndex=n.ZIndex+1; bar.Parent=n; cr(bar,2)
    local t1=Instance.new("TextLabel"); t1.Size=UDim2.new(1,-14,0,15); t1.Position=UDim2.new(0,12,0,8); t1.BackgroundTransparency=1; t1.Text=title; t1.TextColor3=T.White; t1.TextSize=11; t1.Font=Enum.Font.GothamBold; t1.TextXAlignment=Enum.TextXAlignment.Left; t1.ZIndex=n.ZIndex+1; t1.Parent=n
    local t2=Instance.new("TextLabel"); t2.Size=UDim2.new(1,-14,0,13); t2.Position=UDim2.new(0,12,0,25); t2.BackgroundTransparency=1; t2.Text=text; t2.TextColor3=T.TextSec; t2.TextSize=10; t2.Font=Enum.Font.Gotham; t2.TextXAlignment=Enum.TextXAlignment.Left; t2.ZIndex=n.ZIndex+1; t2.Parent=n
    tw(n,{Size=UDim2.new(1,0,0,50)},0.26,Enum.EasingStyle.Back)
    task.delay(3.5,function() tw(n,{Size=UDim2.new(1,0,0,0),BackgroundTransparency=1},0.18); task.wait(0.22); if n and n.Parent then n:Destroy() end end)
end

-- CONTENT FRAME (top-left, no window frame)
local CONT_W,CONT_H=374,310
local contentFrame=Instance.new("Frame"); contentFrame.Size=UDim2.new(0,CONT_W,0,CONT_H)
contentFrame.Position=UDim2.new(0,14,0,28); contentFrame.BackgroundTransparency=1; contentFrame.ClipsDescendants=false; contentFrame.ZIndex=2; contentFrame.Parent=gui
local contentLayout=Instance.new("UIListLayout"); contentLayout.Padding=UDim.new(0,7); contentLayout.Parent=contentFrame

-- PAGE TITLE
local titleFrame=Instance.new("Frame"); titleFrame.Size=UDim2.new(1,0,0,32); titleFrame.BackgroundTransparency=1; titleFrame.Parent=contentFrame
local pageTitleLbl=Instance.new("TextLabel"); pageTitleLbl.Name="PageTitle"; pageTitleLbl.Size=UDim2.new(1,0,0,18); pageTitleLbl.BackgroundTransparency=1; pageTitleLbl.Text="Home"; pageTitleLbl.TextColor3=T.White; pageTitleLbl.TextSize=16; pageTitleLbl.Font=Enum.Font.GothamBlack; pageTitleLbl.TextXAlignment=Enum.TextXAlignment.Left; pageTitleLbl.Parent=titleFrame
local pageSubLbl=Instance.new("TextLabel"); pageSubLbl.Name="PageSub"; pageSubLbl.Size=UDim2.new(1,0,0,11); pageSubLbl.Position=UDim2.new(0,0,0,20); pageSubLbl.BackgroundTransparency=1; pageSubLbl.Text="What's up?"; pageSubLbl.TextColor3=T.TextMuted; pageSubLbl.TextSize=9; pageSubLbl.Font=Enum.Font.Gotham; pageSubLbl.TextXAlignment=Enum.TextXAlignment.Left; pageSubLbl.Parent=titleFrame

-- PAGE CONTENT CONTAINER (cleared on tab switch)
local pageContainer=Instance.new("Frame"); pageContainer.Size=UDim2.new(1,0,0,270); pageContainer.BackgroundTransparency=1; pageContainer.ClipsDescendants=false; pageContainer.Parent=contentFrame
local pageLayout=Instance.new("UIListLayout"); pageLayout.Padding=UDim.new(0,7); pageLayout.Parent=pageContainer

-- CARD BUILDER
local function card(parent,w,h,col,trans)
    local f=Instance.new("Frame"); f.Size=UDim2.new(0,w or 200,0,h or 60)
    f.BackgroundColor3=col or T.Card; f.BackgroundTransparency=trans or 0.08; f.BorderSizePixel=0; f.Parent=parent; cr(f,8); st(f,T.Border,1,0.65); return f
end

local function cardLabel(parent,title,sub,col)
    local f=card(parent,CONT_W,nil,col,0.08); f.Size=UDim2.new(1,0,0,0); f.AutomaticSize=Enum.AutomaticSize.Y; pad(f,10,10,8,8)
    local layout=Instance.new("UIListLayout"); layout.Padding=UDim.new(0,3); layout.Parent=f
    local t=Instance.new("TextLabel"); t.Size=UDim2.new(1,0,0,14); t.BackgroundTransparency=1; t.Text=title; t.TextColor3=T.White; t.TextSize=11; t.Font=Enum.Font.GothamBlack; t.TextXAlignment=Enum.TextXAlignment.Left; t.Parent=f
    if sub then local s=Instance.new("TextLabel"); s.Size=UDim2.new(1,0,0,11); s.BackgroundTransparency=1; s.Text=sub; s.TextColor3=T.TextMuted; s.TextSize=9; s.Font=Enum.Font.Gotham; s.TextXAlignment=Enum.TextXAlignment.Left; s.Parent=f end
    return f
end

local function infoGrid(parent,items,cols)
    local cols=cols or 2; local cellH=34
    local rows=math.ceil(#items/cols); local gridH=rows*cellH+(rows-1)*4
    local g=Instance.new("Frame"); g.Size=UDim2.new(1,0,0,gridH); g.BackgroundTransparency=1; g.Parent=parent
    local gl=Instance.new("UIGridLayout"); gl.CellSize=UDim2.new(1/cols,-3,0,cellH); gl.CellPadding=UDim2.new(0,4,0,4); gl.Parent=g
    for _,item in ipairs(items) do
        local cell=Instance.new("Frame"); cell.BackgroundColor3=Color3.fromRGB(10,10,14); cell.BackgroundTransparency=0.35; cell.BorderSizePixel=0; cell.Parent=g; cr(cell,5); pad(cell,6,6,3,3)
        local l1=Instance.new("TextLabel"); l1.Size=UDim2.new(1,0,0,12); l1.BackgroundTransparency=1; l1.Text=item[1]; l1.TextColor3=T.TextSec; l1.TextSize=8; l1.Font=Enum.Font.GothamBold; l1.TextXAlignment=Enum.TextXAlignment.Left; l1.Parent=cell
        local l2=Instance.new("TextLabel"); l2.Size=UDim2.new(1,0,0,14); l2.Position=UDim2.new(0,0,0,13); l2.BackgroundTransparency=1; l2.Text=item[2]; l2.TextColor3=T.White; l2.TextSize=10; l2.Font=Enum.Font.GothamBold; l2.TextXAlignment=Enum.TextXAlignment.Left; l2.Parent=cell
    end; return g
end

local function makeToggle(parent,labelTxt,default,callback)
    local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,40); row.BackgroundColor3=T.Card; row.BackgroundTransparency=0.15; row.BorderSizePixel=0; row.Parent=parent; cr(row,8); st(row,T.Border,1,0.5); pad(row,12,12,0,0)
    local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,-52,1,0); l.BackgroundTransparency=1; l.Text=labelTxt; l.TextColor3=T.White; l.TextSize=11; l.Font=Enum.Font.Gotham; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=row
    local track=Instance.new("TextButton"); track.Size=UDim2.new(0,36,0,18); track.Position=UDim2.new(1,-48,0.5,-9); track.BackgroundColor3=default and T.Accent or Color3.fromRGB(40,38,52); track.Text=""; track.AutoButtonColor=false; track.ZIndex=row.ZIndex+1; track.Parent=row; cr(track,9)
    local knob=Instance.new("Frame"); knob.Size=UDim2.new(0,12,0,12); knob.Position=default and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6); knob.BackgroundColor3=T.White; knob.BorderSizePixel=0; knob.ZIndex=track.ZIndex+1; knob.Parent=track; cr(knob,6)
    local state=default or false
    track.MouseButton1Click:Connect(function() state=not state; tw(track,{BackgroundColor3=state and T.Accent or Color3.fromRGB(40,38,52)},0.14); tw(knob,{Position=state and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6)},0.14,Enum.EasingStyle.Back); pcall(callback,state) end)
    return row
end

local function makeSlider(parent,labelTxt,min,max,default,callback)
    local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,52); row.BackgroundColor3=T.Card; row.BackgroundTransparency=0.15; row.BorderSizePixel=0; row.Parent=parent; cr(row,8); st(row,T.Border,1,0.5); pad(row,12,12,8,8)
    local topR=Instance.new("Frame"); topR.Size=UDim2.new(1,0,0,15); topR.BackgroundTransparency=1; topR.Parent=row
    local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,-40,1,0); l.BackgroundTransparency=1; l.Text=labelTxt; l.TextColor3=T.White; l.TextSize=11; l.Font=Enum.Font.Gotham; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=topR
    local vl=Instance.new("TextLabel"); vl.Size=UDim2.new(0,36,1,0); vl.Position=UDim2.new(1,-36,0,0); vl.BackgroundTransparency=1; vl.Text=tostring(default); vl.TextColor3=T.Accent; vl.TextSize=10; vl.Font=Enum.Font.GothamBold; vl.TextXAlignment=Enum.TextXAlignment.Right; vl.Parent=topR
    local sliderTrack=Instance.new("Frame"); sliderTrack.Size=UDim2.new(1,0,0,4); sliderTrack.Position=UDim2.new(0,0,0,32); sliderTrack.BackgroundColor3=Color3.fromRGB(40,38,52); sliderTrack.BorderSizePixel=0; sliderTrack.Parent=row; cr(sliderTrack,2)
    local fill=Instance.new("Frame"); fill.Size=UDim2.new((default-min)/(max-min),0,1,0); fill.BackgroundColor3=T.Accent; fill.BorderSizePixel=0; fill.Parent=sliderTrack; cr(fill,2)
    local thumb=Instance.new("TextButton"); thumb.Size=UDim2.new(0,12,0,12); thumb.Position=UDim2.new((default-min)/(max-min),-6,0.5,-6); thumb.BackgroundColor3=T.White; thumb.Text=""; thumb.AutoButtonColor=false; thumb.ZIndex=sliderTrack.ZIndex+1; thumb.Parent=sliderTrack; cr(thumb,6)
    local dragging=false
    local function upd(i) local rel=math.clamp((i.Position.X-sliderTrack.AbsolutePosition.X)/sliderTrack.AbsoluteSize.X,0,1); local v=math.floor(min+(max-min)*rel); fill.Size=UDim2.new(rel,0,1,0); thumb.Position=UDim2.new(rel,-6,0.5,-6); vl.Text=tostring(v); pcall(callback,v) end
    thumb.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end end)
    sliderTrack.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then upd(i);dragging=true end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then upd(i) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
    return row
end

local function makeBtn(parent,text,callback,col)
    local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,0,0,36); btn.BackgroundColor3=col or Color3.fromRGB(28,26,36); btn.BackgroundTransparency=0.15; btn.Text=text; btn.TextColor3=T.White; btn.TextSize=11; btn.Font=Enum.Font.GothamBold; btn.AutoButtonColor=false; btn.Parent=parent; cr(btn,8)
    btn.MouseEnter:Connect(function() tw(btn,{BackgroundTransparency=0},0.1) end); btn.MouseLeave:Connect(function() tw(btn,{BackgroundTransparency=0.15},0.1) end)
    btn.MouseButton1Click:Connect(function() tw(btn,{Size=UDim2.new(0.97,0,0,34)},0.06); task.wait(0.07); tw(btn,{Size=UDim2.new(1,0,0,36)},0.12,Enum.EasingStyle.Back); pcall(callback) end)
    return btn
end
-- PAGES
local pages={}
local function clearPage()
    for _,c in pairs(pageContainer:GetChildren()) do if not c:IsA("UIListLayout") then c:Destroy() end end
end

-- HOME
pages["Home"]={title="Home",sub="What's up?",fn=function()
    -- Top row: Server + Friends cards
    local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,118); row.BackgroundTransparency=1; row.Parent=pageContainer
    local rowL=Instance.new("UIListLayout"); rowL.FillDirection=Enum.FillDirection.Horizontal; rowL.Padding=UDim.new(0,6); rowL.Parent=row

    local serverCard=Instance.new("Frame"); serverCard.Size=UDim2.new(0,210,1,0); serverCard.BackgroundColor3=T.CardServer; serverCard.BackgroundTransparency=0.08; serverCard.BorderSizePixel=0; serverCard.Parent=row; cr(serverCard,8); st(serverCard,T.Border,1,0.65); pad(serverCard,8,8,8,8)
    local sLayout=Instance.new("UIListLayout"); sLayout.Padding=UDim.new(0,5); sLayout.Parent=serverCard
    local sTitleF=Instance.new("Frame"); sTitleF.Size=UDim2.new(1,0,0,26); sTitleF.BackgroundTransparency=1; sTitleF.Parent=serverCard
    local sTitleLayout=Instance.new("UIListLayout"); sTitleLayout.Padding=UDim.new(0,2); sTitleLayout.Parent=sTitleF
    local sT=Instance.new("TextLabel"); sT.Size=UDim2.new(1,0,0,13); sT.BackgroundTransparency=1; sT.Text="Server"; sT.TextColor3=T.White; sT.TextSize=11; sT.Font=Enum.Font.GothamBlack; sT.TextXAlignment=Enum.TextXAlignment.Left; sT.Parent=sTitleF
    local sS=Instance.new("TextLabel"); sS.Size=UDim2.new(1,0,0,11); sS.BackgroundTransparency=1; sS.Text="Information on the session you're currently in"; sS.TextColor3=T.TextMuted; sS.TextSize=8; sS.Font=Enum.Font.Gotham; sS.TextXAlignment=Enum.TextXAlignment.Left; sS.TextWrapped=true; sS.Parent=sTitleF
    local ping=0; pcall(function() ping=math.round(LocalPlayer:GetNetworkPing()*1000) end)
    infoGrid(serverCard,{{"Players",tostring(#Players:GetPlayers()).." playing"},{"Maximum Players",tostring(game.Players.MaxPlayers).." max"},{"Latency",ping.."ms"},{"Server Region","US"},{"In server for","Active"},{"Join Script","Tap to copy"}},2)

    local friendsCard=Instance.new("Frame"); friendsCard.Size=UDim2.new(1,-216,1,0); friendsCard.BackgroundColor3=T.CardFriends; friendsCard.BackgroundTransparency=0.08; friendsCard.BorderSizePixel=0; friendsCard.Parent=row; cr(friendsCard,8); st(friendsCard,T.Border,1,0.65); pad(friendsCard,8,8,8,8)
    local fLayout=Instance.new("UIListLayout"); fLayout.Padding=UDim.new(0,5); fLayout.Parent=friendsCard
    local fTitleF=Instance.new("Frame"); fTitleF.Size=UDim2.new(1,0,0,26); fTitleF.BackgroundTransparency=1; fTitleF.Parent=friendsCard
    local fTitleLayout=Instance.new("UIListLayout"); fTitleLayout.Padding=UDim.new(0,2); fTitleLayout.Parent=fTitleF
    local fT=Instance.new("TextLabel"); fT.Size=UDim2.new(1,0,0,13); fT.BackgroundTransparency=1; fT.Text="Friends"; fT.TextColor3=T.White; fT.TextSize=11; fT.Font=Enum.Font.GothamBlack; fT.TextXAlignment=Enum.TextXAlignment.Left; fT.Parent=fTitleF
    local fS=Instance.new("TextLabel"); fS.Size=UDim2.new(1,0,0,11); fS.BackgroundTransparency=1; fS.Text="Find out what your friends are doing"; fS.TextColor3=T.TextMuted; fS.TextSize=8; fS.Font=Enum.Font.Gotham; fS.TextXAlignment=Enum.TextXAlignment.Left; fS.TextWrapped=true; fS.Parent=fTitleF
    infoGrid(friendsCard,{{"In Server","no friends"},{"Offline","0 friends"},{"Online","0 friends"},{"All","0 Friends"}},2)

    -- Profile card
    local profCard=Instance.new("Frame"); profCard.Size=UDim2.new(1,0,0,50); profCard.BackgroundColor3=T.CardDark; profCard.BackgroundTransparency=0.08; profCard.BorderSizePixel=0; profCard.Parent=pageContainer; cr(profCard,8); st(profCard,T.Border,1,0.65); pad(profCard,10,10,0,0)
    local av=Instance.new("ImageLabel"); av.Size=UDim2.new(0,32,0,32); av.Position=UDim2.new(0,0,0.5,-16); av.BackgroundColor3=Color3.fromRGB(30,28,40); av.BorderSizePixel=0; av.ZIndex=profCard.ZIndex+1; av.Parent=profCard; cr(av,6)
    pcall(function() av.Image="https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=48&height=48&format=png" end)
    local dn=Instance.new("TextLabel"); dn.Size=UDim2.new(1,-46,0,16); dn.Position=UDim2.new(0,42,0.5,-16); dn.BackgroundTransparency=1; dn.Text=LocalPlayer.DisplayName; dn.TextColor3=T.White; dn.TextSize=12; dn.Font=Enum.Font.GothamBlack; dn.TextXAlignment=Enum.TextXAlignment.Left; dn.ZIndex=profCard.ZIndex+1; dn.Parent=profCard
    local un=Instance.new("TextLabel"); un.Size=UDim2.new(1,-46,0,12); un.Position=UDim2.new(0,42,0.5,2); un.BackgroundTransparency=1; un.Text="@"..LocalPlayer.Name; un.TextColor3=T.TextMuted; un.TextSize=9; un.Font=Enum.Font.Gotham; un.TextXAlignment=Enum.TextXAlignment.Left; un.ZIndex=profCard.ZIndex+1; un.Parent=profCard

    -- Executor card
    local exCard=Instance.new("Frame"); exCard.Size=UDim2.new(1,0,0,46); exCard.BackgroundColor3=T.CardRed; exCard.BackgroundTransparency=0.08; exCard.BorderSizePixel=0; exCard.Parent=pageContainer; cr(exCard,8); st(exCard,T.Border,1,0.65); pad(exCard,10,10,8,8)
    local exL=Instance.new("UIListLayout"); exL.Padding=UDim.new(0,3); exL.Parent=exCard
    local exT=Instance.new("TextLabel"); exT.Size=UDim2.new(1,0,0,13); exT.BackgroundTransparency=1; exT.Text="OS MENU"; exT.TextColor3=T.White; exT.TextSize=11; exT.Font=Enum.Font.GothamBlack; exT.TextXAlignment=Enum.TextXAlignment.Left; exT.Parent=exCard
    local exS=Instance.new("TextLabel"); exS.Size=UDim2.new(1,0,0,11); exS.BackgroundTransparency=1; exS.Text="Your executor seems to support this script"; exS.TextColor3=Color3.fromRGB(200,170,170); exS.TextSize=9; exS.Font=Enum.Font.Gotham; exS.TextXAlignment=Enum.TextXAlignment.Left; exS.TextWrapped=true; exS.Parent=exCard

    -- Discord card
    local dcCard=Instance.new("Frame"); dcCard.Size=UDim2.new(1,0,0,46); dcCard.BackgroundColor3=T.CardBlue; dcCard.BackgroundTransparency=0.08; dcCard.BorderSizePixel=0; dcCard.Parent=pageContainer; cr(dcCard,8); st(dcCard,T.Border,1,0.65); pad(dcCard,10,10,8,8)
    local dcL=Instance.new("UIListLayout"); dcL.Padding=UDim.new(0,3); dcL.Parent=dcCard
    local dcT=Instance.new("TextLabel"); dcT.Size=UDim2.new(1,0,0,13); dcT.BackgroundTransparency=1; dcT.Text="Discord"; dcT.TextColor3=T.White; dcT.TextSize=11; dcT.Font=Enum.Font.GothamBlack; dcT.TextXAlignment=Enum.TextXAlignment.Left; dcT.Parent=dcCard
    local dcS=Instance.new("TextLabel"); dcS.Size=UDim2.new(1,0,0,11); dcS.BackgroundTransparency=1; dcS.Text="Tap to join our Discord server for updates and news"; dcS.TextColor3=Color3.fromRGB(170,170,220); dcS.TextSize=9; dcS.Font=Enum.Font.Gotham; dcS.TextXAlignment=Enum.TextXAlignment.Left; dcS.TextWrapped=true; dcS.Parent=dcCard
end}

-- PLAYER
local invisRunning=false
pages["Player"]={title="Player",sub="Manage your character",fn=function()
    makeToggle(pageContainer,"Invisible FE",false,function(s)
        if s then invisRunning=true; local char=Character; if not char then return end
            for _,p in pairs(char:GetDescendants()) do if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then p.Transparency=1 end end
            local conn; conn=RunService.Heartbeat:Connect(function() if not invisRunning then conn:Disconnect();return end
                for _,v in pairs(char:GetChildren()) do if v:IsA("BasePart") and v.Name~="HumanoidRootPart" then v.Velocity=Vector3.new(0,0,0);v.CFrame=CFrame.new(9e9,9e9,9e9) end end end)
            notify("Invisible","Others can't see you!","success")
        else invisRunning=false; notify("Invisible","Rejoin to become visible!","warning") end
    end)
    makeSlider(pageContainer,"Walk Speed",16,500,16,function(v) pcall(function() if Humanoid then Humanoid.WalkSpeed=v end end) end)
    makeSlider(pageContainer,"Jump Power",50,500,50,function(v) pcall(function() if Humanoid then Humanoid.JumpPower=v end end) end)
    local godConn=nil
    makeToggle(pageContainer,"God Mode",false,function(s)
        pcall(function() if godConn then godConn:Disconnect();godConn=nil end; if not Humanoid then return end
            if s then Humanoid.MaxHealth=math.huge;Humanoid.Health=math.huge; godConn=Humanoid:GetPropertyChangedSignal("Health"):Connect(function() if Humanoid then Humanoid.Health=math.huge end end)
            else Humanoid.MaxHealth=100;Humanoid.Health=100 end end)
        notify("God Mode",s and "Invincible!" or "Normal!","success")
    end)
end}

-- WORLD
local flyEnabled,flyConn,flyBody,flySpd=false,nil,nil,80
local ncConn=nil
pages["World"]={title="World",sub="Control the environment",fn=function()
    makeToggle(pageContainer,"Fly Mode",false,function(s)
        flyEnabled=s; pcall(function()
            if s then if not HRP then return end
                flyBody=Instance.new("BodyVelocity");flyBody.MaxForce=Vector3.new(9e9,9e9,9e9);flyBody.Velocity=Vector3.zero;flyBody.Parent=HRP
                flyConn=RunService.RenderStepped:Connect(function()
                    if not flyEnabled or not HRP then return end
                    local dir=Vector3.zero; local cam=Camera
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir+=cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir-=cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir-=cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir+=cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir+=Vector3.new(0,1,0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir-=Vector3.new(0,1,0) end
                    flyBody.Velocity=dir.Magnitude>0 and dir.Unit*flySpd or Vector3.zero end)
                notify("Fly","WASD + Space/Shift!","success")
            else if flyConn then flyConn:Disconnect();flyConn=nil end; if flyBody then flyBody:Destroy();flyBody=nil end; notify("Fly","Disabled!","warning") end end)
    end)
    makeSlider(pageContainer,"Fly Speed",10,300,80,function(v) flySpd=v end)
    makeToggle(pageContainer,"No Clip",false,function(s)
        pcall(function()
            if s then ncConn=RunService.Stepped:Connect(function() if Character then for _,p in pairs(Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end end); notify("No Clip","Through walls!","success")
            else if ncConn then ncConn:Disconnect();ncConn=nil end; if Character then for _,p in pairs(Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end; notify("No Clip","Disabled!","warning") end end)
    end)
    makeToggle(pageContainer,"Infinite Jump",false,function(s)
        if s then UserInputService.JumpRequest:Connect(function() if Humanoid then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end) end
        notify("Infinite Jump",s and "Active!" or "Off!","success")
    end)
end}

-- TOOLS
local espConns={}
pages["Tools"]={title="Tools",sub="Utilities and visual aids",fn=function()
    makeBtn(pageContainer,"Rejoin Server",function() notify("Rejoin","Reconnecting...","success"); task.wait(0.8); pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LocalPlayer) end) end,T.CardServer)
    makeBtn(pageContainer,"Respawn",function() pcall(function() if Character then Character:BreakJoints() end end); notify("Respawn","Respawning!","success") end)
    makeToggle(pageContainer,"Player ESP",false,function(s)
        pcall(function() for _,c in pairs(espConns) do c:Disconnect() end; espConns={}
            for _,p in pairs(Players:GetPlayers()) do if p~=LocalPlayer and p.Character then
                if s then local hl=Instance.new("Highlight");hl.Name="OSESP";hl.FillColor=Color3.fromRGB(60,40,120);hl.OutlineColor=T.Accent;hl.FillTransparency=0.7;hl.Parent=p.Character
                else for _,v in pairs(p.Character:GetChildren()) do if v.Name=="OSESP" then v:Destroy() end end end end end end)
        notify("ESP",s and "Players marked!" or "Off!","success")
    end)
    makeToggle(pageContainer,"Full Bright",false,function(s)
        pcall(function() if s then Lighting.Brightness=10;Lighting.ClockTime=12;Lighting.FogEnd=1e5;Lighting.GlobalShadows=false else Lighting.Brightness=2;Lighting.ClockTime=14;Lighting.FogEnd=1000;Lighting.GlobalShadows=true end end)
        notify("Full Bright",s and "Bright!" or "Normal!","success")
    end)
    makeToggle(pageContainer,"Anti-AFK",false,function(s)
        if s then pcall(function() local VU=game:GetService("VirtualUser"); LocalPlayer.Idled:Connect(function() VU:CaptureController();VU:ClickButton2(Vector2.new()) end) end); notify("Anti-AFK","No kick!","success")
        else notify("Anti-AFK","Disabled!","warning") end
    end)
end}

-- PLAYERS
pages["Players"]={title="Players",sub="Who's in this server?",fn=function()
    for _,p in pairs(Players:GetPlayers()) do
        local isMe=p==LocalPlayer
        local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,46); row.BackgroundColor3=isMe and T.CardFriends or T.CardDark; row.BackgroundTransparency=0.1; row.BorderSizePixel=0; row.Parent=pageContainer; cr(row,8); st(row,T.Border,1,0.6); pad(row,10,10,0,0)
        local av=Instance.new("ImageLabel"); av.Size=UDim2.new(0,28,0,28); av.Position=UDim2.new(0,0,0.5,-14); av.BackgroundColor3=Color3.fromRGB(28,26,40); av.BorderSizePixel=0; av.ZIndex=row.ZIndex+1; av.Parent=row; cr(av,6)
        pcall(function() av.Image="https://www.roblox.com/headshot-thumbnail/image?userId="..p.UserId.."&width=48&height=48&format=png" end)
        local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(1,-40,0,14); nl.Position=UDim2.new(0,36,0.5,-14); nl.BackgroundTransparency=1; nl.Text=p.DisplayName; nl.TextColor3=isMe and T.Accent or T.White; nl.TextSize=11; nl.Font=Enum.Font.GothamBold; nl.TextXAlignment=Enum.TextXAlignment.Left; nl.ZIndex=row.ZIndex+1; nl.Parent=row
        local ul=Instance.new("TextLabel"); ul.Size=UDim2.new(1,-40,0,11); ul.Position=UDim2.new(0,36,0.5,2); ul.BackgroundTransparency=1; ul.Text="@"..p.Name..(isMe and " (you)" or ""); ul.TextColor3=T.TextMuted; ul.TextSize=9; ul.Font=Enum.Font.Gotham; ul.TextXAlignment=Enum.TextXAlignment.Left; ul.ZIndex=row.ZIndex+1; ul.Parent=row
    end
end}

-- SETTINGS
pages["Settings"]={title="Settings",sub="Configure OS MENU",fn=function()
    local ab=Instance.new("Frame"); ab.Size=UDim2.new(1,0,0,56); ab.BackgroundColor3=T.CardBlue; ab.BackgroundTransparency=0.08; ab.BorderSizePixel=0; ab.Parent=pageContainer; cr(ab,8); st(ab,T.Border,1,0.65); pad(ab,12,12,10,10)
    local abL=Instance.new("UIListLayout"); abL.Padding=UDim.new(0,3); abL.Parent=ab
    local at=Instance.new("TextLabel"); at.Size=UDim2.new(1,0,0,14); at.BackgroundTransparency=1; at.Text="OS MENU v1.0"; at.TextColor3=T.White; at.TextSize=13; at.Font=Enum.Font.GothamBlack; at.TextXAlignment=Enum.TextXAlignment.Left; at.Parent=ab
    local as=Instance.new("TextLabel"); as.Size=UDim2.new(1,0,0,11); as.BackgroundTransparency=1; as.Text="Hidden Hub Style | by TL Scripts"; as.TextColor3=T.TextMuted; as.TextSize=9; as.Font=Enum.Font.Gotham; as.TextXAlignment=Enum.TextXAlignment.Left; as.Parent=ab
    makeBtn(pageContainer,"Test Notification",function() notify("OS MENU","Everything works!","success") end,T.CardBlue)
end}

-- BOTTOM NAVIGATION BAR
local NAV_W,NAV_H=300,50
local navWrap=Instance.new("Frame"); navWrap.Size=UDim2.new(0,NAV_W,0,NAV_H+20); navWrap.Position=UDim2.new(0.5,-NAV_W/2,1,-(NAV_H+18)); navWrap.BackgroundTransparency=1; navWrap.ZIndex=5; navWrap.Parent=gui

-- Expand arrow above nav
local expandArrow=Instance.new("TextLabel"); expandArrow.Size=UDim2.new(1,0,0,16); expandArrow.BackgroundTransparency=1; expandArrow.Text="v"; expandArrow.TextColor3=T.TextMuted; expandArrow.TextSize=10; expandArrow.Font=Enum.Font.GothamBold; expandArrow.ZIndex=5; expandArrow.Parent=navWrap

local navPill=Instance.new("Frame"); navPill.Size=UDim2.new(1,0,0,NAV_H); navPill.Position=UDim2.new(0,0,0,16); navPill.BackgroundColor3=T.NavBG; navPill.BackgroundTransparency=0.06; navPill.BorderSizePixel=0; navPill.ZIndex=5; navPill.Parent=navWrap; cr(navPill,NAV_H/2); st(navPill,T.Border,1,0.5)

-- Clock
local clockLbl=Instance.new("TextLabel"); clockLbl.Size=UDim2.new(0,44,1,0); clockLbl.Position=UDim2.new(0,14,0,0); clockLbl.BackgroundTransparency=1; clockLbl.Text="00:00"; clockLbl.TextColor3=T.White; clockLbl.TextSize=11; clockLbl.Font=Enum.Font.GothamBlack; clockLbl.ZIndex=navPill.ZIndex+1; clockLbl.Parent=navPill
task.spawn(function() while true do local t=os.date("*t"); clockLbl.Text=string.format("%02d:%02d",t.hour,t.min); task.wait(10) end end)

-- Nav icons frame
local navIcons=Instance.new("Frame"); navIcons.Size=UDim2.new(0,160,1,0); navIcons.Position=UDim2.new(0,60,0,0); navIcons.BackgroundTransparency=1; navIcons.ZIndex=navPill.ZIndex+1; navIcons.Parent=navPill
local navIconLayout=Instance.new("UIListLayout"); navIconLayout.FillDirection=Enum.FillDirection.Horizontal; navIconLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center; navIconLayout.VerticalAlignment=Enum.VerticalAlignment.Center; navIconLayout.Padding=UDim.new(0,4); navIconLayout.Parent=navIcons

-- Gear on right
local gearBtn=Instance.new("TextButton"); gearBtn.Size=UDim2.new(0,32,0,32); gearBtn.Position=UDim2.new(1,-42,0.5,-16); gearBtn.BackgroundTransparency=1; gearBtn.Text="S"; gearBtn.TextColor3=T.TextMuted; gearBtn.TextSize=11; gearBtn.Font=Enum.Font.GothamBold; gearBtn.ZIndex=navPill.ZIndex+1; gearBtn.Parent=navPill

local tabDefs={
    {name="Home",   icon="H",  page=pages["Home"]},
    {name="Player", icon="Me", page=pages["Player"]},
    {name="World",  icon="W",  page=pages["World"]},
    {name="Tools",  icon="T",  page=pages["Tools"]},
    {name="Players",icon="PL", page=pages["Players"]},
}
local activeNavBtn=nil

local function switchPage(pageData, btnRef)
    if activeNavBtn and activeNavBtn~=btnRef then
        tw(activeNavBtn,{BackgroundColor3=T.NavBG,BackgroundTransparency=1},0.15)
        local ol=activeNavBtn:FindFirstChildWhichIsA("TextLabel"); if ol then tw(ol,{TextColor3=T.TextMuted},0.15) end
    end
    activeNavBtn=btnRef
    tw(btnRef,{BackgroundColor3=T.NavActive,BackgroundTransparency=0},0.15)
    local nl2=btnRef:FindFirstChildWhichIsA("TextLabel"); if nl2 then tw(nl2,{TextColor3=T.White},0.15) end
    pageTitleLbl.Text=pageData.title; pageSubLbl.Text=pageData.sub
    clearPage(); pcall(pageData.fn)
end

-- Settings via gear
gearBtn.MouseButton1Click:Connect(function() switchPage(pages["Settings"],gearBtn) end)
gearBtn.MouseEnter:Connect(function() tw(gearBtn,{TextColor3=T.White},0.1) end)
gearBtn.MouseLeave:Connect(function() if gearBtn~=activeNavBtn then tw(gearBtn,{TextColor3=T.TextMuted},0.1) end end)

for i,data in ipairs(tabDefs) do
    local isFirst=i==1
    local btn=Instance.new("TextButton"); btn.Size=UDim2.new(0,30,0,30); btn.BackgroundColor3=T.NavActive
    btn.BackgroundTransparency=isFirst and 0 or 1; btn.Text=data.icon; btn.TextColor3=isFirst and T.White or T.TextMuted
    btn.TextSize=9; btn.Font=Enum.Font.GothamBold; btn.AutoButtonColor=false; btn.ZIndex=navPill.ZIndex+2; btn.Parent=navIcons; cr(btn,15)
    if isFirst then activeNavBtn=btn end
    local pd,cb=data.page,btn
    btn.MouseButton1Click:Connect(function() switchPage(pd,cb) end)
    btn.MouseEnter:Connect(function() if cb~=activeNavBtn then tw(cb,{BackgroundTransparency=0.7},0.1) end end)
    btn.MouseLeave:Connect(function() if cb~=activeNavBtn then tw(cb,{BackgroundTransparency=1},0.1) end end)
end

-- LOAD HOME
task.delay(0.1,function() pcall(pages["Home"].fn) end)
task.delay(0.7,function() notify("OS MENU","Script loaded!","success") end)
print("[OS MENU] Loaded!")
