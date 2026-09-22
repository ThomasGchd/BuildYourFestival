local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local TweenService=game:GetService("TweenService")
local p=Players.LocalPlayer
local gui=Instance.new("ScreenGui");gui.Name="FestivalHUD";gui.ResetOnSpawn=false;gui.IgnoreGuiInset=true;gui.Parent=p:WaitForChild("PlayerGui")

local function corner(x,r)local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 12);c.Parent=x end
local function stroke(x)local s=Instance.new("UIStroke");s.Color=Color3.fromRGB(80,95,125);s.Transparency=.45;s.Thickness=1;s.Parent=x end
local function label(pos,size,text)
 local x=Instance.new("TextLabel");x.Position=pos;x.Size=size;x.BackgroundColor3=Color3.fromRGB(12,15,22);x.BackgroundTransparency=.08;x.TextColor3=Color3.new(1,1,1);x.Font=Enum.Font.GothamBold;x.TextSize=14;x.Text=text;x.BorderSizePixel=0;x.Parent=gui;corner(x);stroke(x);return x
end
local function totalProgress()local t=0;for _,k in ipairs({"Stage","Sound","Lights","FX","Crowd","Stands","Marketing","Staff"})do t+=p:GetAttribute(k.."Level")or 0 end;return t end
local stats=label(UDim2.new(1,-500,0,18),UDim2.fromOffset(480,40),"")
local now=label(UDim2.new(.5,-220,1,-58),UDim2.fromOffset(440,40),"MAINSTAGE • chargement...")
local objective=label(UDim2.new(.5,-230,0,18),UDim2.fromOffset(460,62),"")
objective.TextWrapped=true;objective.TextSize=14;objective.BackgroundTransparency=.18
local function refreshObjective()
 local step=p:GetAttribute("TutorialStep")or 1
 local messages={
  [1]="1 • OUVRE TON FESTIVAL avec le gros bouton violet",
  [2]="2 • ACHÈTE UNE SCÈNE dans CONSTRUIRE",
  [3]="3 • ACHÈTE DU PUBLIC pour faire venir plus de monde",
  [4]="4 • OUVRE TON FESTIVAL UNE 2e FOIS et regarde la différence !"
 }
 objective.Text=messages[step]or messages[5]
 objective.Visible=step<=4
end
p:GetAttributeChangedSignal("TutorialStep"):Connect(refreshObjective);refreshObjective()
local phase=label(UDim2.new(.5,-190,0,88),UDim2.fromOffset(380,36),"")
phase.TextSize=13
local function refreshPhase()
 local name=p:GetAttribute("FestivalPhase")or"DEPART";local need=p:GetAttribute("NextPhaseNeed")or-1;local total=totalProgress()
 phase.Text=name..(need>0 and ("   •   "..total.."/"..need.." POUR GRANDIR")or"   •   FESTIVAL MAX")
end
for _,a in ipairs({"FestivalPhase","IncomePerTick","NextPhaseNeed","StageLevel","SoundLevel","LightsLevel","FXLevel","CrowdLevel","StandsLevel","MarketingLevel","StaffLevel"})do p:GetAttributeChangedSignal(a):Connect(refreshPhase)end;refreshPhase()
local cam=Instance.new("TextButton");cam.Position=UDim2.new(0,18,1,-58);cam.Size=UDim2.fromOffset(118,36);cam.BackgroundColor3=Color3.fromRGB(12,15,22);cam.TextColor3=Color3.new(1,1,1);cam.Font=Enum.Font.GothamBold;cam.TextSize=13;cam.Text="CAM : OFF";cam.Parent=gui;corner(cam);stroke(cam)
local gfxLevel=2
local gfx=Instance.new("TextButton");gfx.Position=UDim2.new(0,146,1,-58);gfx.Size=UDim2.fromOffset(120,36);gfx.BackgroundColor3=Color3.fromRGB(12,15,22);gfx.TextColor3=Color3.new(1,1,1);gfx.Font=Enum.Font.GothamBold;gfx.TextSize=13;gfx.Parent=gui;corner(gfx);stroke(gfx)
local function applyGraphics()
 local names={"FAIBLE","MOYEN","ÉLEVÉ"};gfx.Text="QUALITÉ : "..names[gfxLevel]
 local lighting=game:GetService("Lighting");local bloom=lighting:FindFirstChild("FestivalBloom");local rays=lighting:FindFirstChild("FestivalRays");local atmosphere=lighting:FindFirstChild("FestivalAtmosphere")
 if bloom then bloom.Enabled=gfxLevel>=2 end;if rays then rays.Enabled=gfxLevel>=3 end
 if atmosphere then atmosphere.Density=gfxLevel==1 and .04 or (gfxLevel==2 and .08 or .10) end
 for _,v in workspace:GetDescendants()do
  if v:IsA("Beam")then v.Enabled=gfxLevel>=2 elseif v:IsA("PointLight")or v:IsA("SpotLight")then v.Enabled=gfxLevel>=2 end
 end
end
gfx.MouseButton1Click:Connect(function()gfxLevel=gfxLevel%3+1;applyGraphics()end);task.defer(applyGraphics)

-- Familiar tycoon navigation rail
local rail=Instance.new("Frame");rail.Position=UDim2.new(0,18,.5,-145);rail.Size=UDim2.fromOffset(190,310);rail.BackgroundColor3=Color3.fromRGB(10,13,20);rail.BackgroundTransparency=.12;rail.Parent=gui;corner(rail,16);stroke(rail)
local title=Instance.new("TextLabel");title.Size=UDim2.new(1,0,0,42);title.BackgroundTransparency=1;title.Text="BUILD YOUR FESTIVAL";title.TextColor3=Color3.fromRGB(235,238,245);title.Font=Enum.Font.GothamBold;title.TextSize=14;title.Parent=rail
local list=Instance.new("UIListLayout");list.Padding=UDim.new(0,8);list.HorizontalAlignment=Enum.HorizontalAlignment.Center;list.VerticalAlignment=Enum.VerticalAlignment.Center;list.Parent=rail
local function teleport(target)
 local root=p.Character and p.Character:FindFirstChild("HumanoidRootPart");if root and target then root.CFrame=CFrame.new(target+Vector3.new(0,4,0)) end
end
local function navButton(text,accent,callback)
 local b=Instance.new("TextButton");b.Size=UDim2.new(1,-20,0,48);b.BackgroundColor3=Color3.fromRGB(22,27,38);b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.GothamBold;b.TextSize=13;b.Text=text;b.AutoButtonColor=false;b.Parent=rail;corner(b,11)
 local bar=Instance.new("Frame");bar.Size=UDim2.fromOffset(4,26);bar.Position=UDim2.new(0,7,.5,-13);bar.BackgroundColor3=accent;bar.BorderSizePixel=0;bar.Parent=b;corner(bar,3)
 b.MouseEnter:Connect(function()TweenService:Create(b,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(34,41,56)}):Play()end)
 b.MouseLeave:Connect(function()TweenService:Create(b,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(22,27,38)}):Play()end)
 b.MouseButton1Click:Connect(callback);return b
end
navButton("MON FESTIVAL",Color3.fromRGB(70,210,255),function()
 local world=workspace:FindFirstChild("FestivalWorld");local plots=world and world:FindFirstChild("Plots");local i=p:GetAttribute("PlotIndex");local plot=i and plots and plots:FindFirstChild("Plot"..i);if plot and plot:FindFirstChild("Floor")then teleport(plot.Floor.Position+Vector3.new(0,0,38))end
end)
navButton("MAINSTAGE",Color3.fromRGB(190,90,255),function()teleport(Vector3.new(0,1,-345))end)
navButton("BOUTIQUES",Color3.fromRGB(255,175,65),function()teleport(Vector3.new(145,1,-375))end)
local rebirthButton=navButton("RECOMMENCER +",Color3.fromRGB(80,225,155),function() end)
local upgradesButton
upgradesButton=navButton("CONSTRUIRE",Color3.fromRGB(255,95,130),function() end)
local customizeButton=navButton("PERSONNALISER",Color3.fromRGB(120,100,245),function() end)

local upgradeRemote=ReplicatedStorage:WaitForChild("FestivalUpgrade")
local styleBar=Instance.new("Frame");styleBar.Size=UDim2.fromOffset(780,92);styleBar.Position=UDim2.new(.5,-390,0,190);styleBar.BackgroundTransparency=1;styleBar.Visible=false;styleBar.Parent=gui
local styleLayout=Instance.new("UIListLayout");styleLayout.FillDirection=Enum.FillDirection.Horizontal;styleLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center;styleLayout.Padding=UDim.new(0,8);styleLayout.Wraps=true;styleLayout.Parent=styleBar
for _,info in ipairs({{"MAIN STAGE","Mainstage"},{"CAVE","Cave"},{"BOILER 360°","Boiler"},{"WAREHOUSE","Warehouse"},{"OPEN AIR","OpenAir"},{"HARD STAGE","Hard"},{"BEACH","Beach"}})do
 local b=Instance.new("TextButton");b.Size=UDim2.fromOffset(102,40);b.BackgroundColor3=Color3.fromRGB(22,27,38);b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.GothamBold;b.TextSize=12;b.Text=info[1];b.Parent=styleBar;corner(b,10);stroke(b)
 b.MouseButton1Click:Connect(function()if not p:GetAttribute("EventActive")then ReplicatedStorage:WaitForChild("FestivalUpgrade"):FireServer("STYLE",info[2])end end)
end

local customizePanel
local function openCustomize()
 if customizePanel then customizePanel:Destroy();customizePanel=nil;return end
 customizePanel=Instance.new("Frame");customizePanel.Size=UDim2.fromOffset(610,470);customizePanel.Position=UDim2.new(.5,-305,.5,-235);customizePanel.BackgroundColor3=Color3.fromRGB(13,16,23);customizePanel.Parent=gui;corner(customizePanel,18);stroke(customizePanel)
 local head=Instance.new("TextLabel");head.Size=UDim2.new(1,-70,0,55);head.Position=UDim2.fromOffset(20,0);head.BackgroundTransparency=1;head.Text="PERSONNALISE TON FESTIVAL";head.TextXAlignment=Enum.TextXAlignment.Left;head.TextColor3=Color3.new(1,1,1);head.Font=Enum.Font.GothamBlack;head.TextSize=19;head.Parent=customizePanel
 local close=Instance.new("TextButton");close.Size=UDim2.fromOffset(40,40);close.Position=UDim2.new(1,-50,0,8);close.Text="X";close.BackgroundColor3=Color3.fromRGB(32,36,47);close.TextColor3=Color3.new(1,1,1);close.Parent=customizePanel;corner(close,9);close.MouseButton1Click:Connect(function()customizePanel:Destroy();customizePanel=nil end)
 local body=Instance.new("Frame");body.BackgroundTransparency=1;body.Position=UDim2.fromOffset(18,62);body.Size=UDim2.new(1,-36,1,-78);body.Parent=customizePanel
 local lay=Instance.new("UIListLayout");lay.Padding=UDim.new(0,10);lay.Parent=body
 local function row(title,options,kind)
  local r=Instance.new("Frame");r.Size=UDim2.new(1,0,0,82);r.BackgroundColor3=Color3.fromRGB(22,27,38);r.Parent=body;corner(r,12)
  local l=Instance.new("TextLabel");l.Size=UDim2.new(1,-16,0,28);l.Position=UDim2.fromOffset(10,3);l.BackgroundTransparency=1;l.Text=title;l.TextXAlignment=Enum.TextXAlignment.Left;l.TextColor3=Color3.fromRGB(220,225,235);l.Font=Enum.Font.GothamBold;l.TextSize=12;l.Parent=r
  local x=8
  for _,o in ipairs(options)do local b=Instance.new("TextButton");b.Size=UDim2.fromOffset(math.max(70,#o*8+22),38);b.Position=UDim2.fromOffset(x,35);b.BackgroundColor3=Color3.fromRGB(38,44,58);b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.GothamBold;b.TextSize=11;b.Text=o;b.Parent=r;corner(b,9);b.MouseButton1Click:Connect(function()if not p:GetAttribute("EventActive")then upgradeRemote:FireServer("CUSTOMIZE",kind,o)end end);x+=b.Size.X.Offset+7 end
 end
 local sr=Instance.new("Frame");sr.Size=UDim2.new(1,0,0,82);sr.BackgroundColor3=Color3.fromRGB(22,27,38);sr.Parent=body;corner(sr,12)
 local sl=Instance.new("TextLabel");sl.Size=UDim2.new(1,-16,0,28);sl.Position=UDim2.fromOffset(10,3);sl.BackgroundTransparency=1;sl.Text="STYLE DE SCÈNE";sl.TextXAlignment=Enum.TextXAlignment.Left;sl.TextColor3=Color3.fromRGB(220,225,235);sl.Font=Enum.Font.GothamBold;sl.TextSize=12;sl.Parent=sr
 local sx=8
 for _,o in ipairs({{"MAIN","Mainstage"},{"CAVE","Cave"},{"BOILER","Boiler"},{"WAREHOUSE","Warehouse"},{"OPEN AIR","OpenAir"},{"HARD","Hard"},{"BEACH","Beach"}})do local b=Instance.new("TextButton");b.Size=UDim2.fromOffset(73,38);b.Position=UDim2.fromOffset(sx,35);b.BackgroundColor3=Color3.fromRGB(38,44,58);b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.GothamBold;b.TextSize=9;b.Text=o[1];b.Parent=sr;corner(b,9);b.MouseButton1Click:Connect(function()if not p:GetAttribute("EventActive")then upgradeRemote:FireServer("STYLE",o[2])end end);sx+=79 end
  row("NOM DU FESTIVAL",{"NOVA","PULSE","ECLIPSE","RAVE","IMPACT","HORIZON","VOID","UNITY"},"NAME")
 row("COULEURS",{"Purple","Red","Green","Blue","Pink","Mono"},"PALETTE")
 row("AMBIANCE / DÉCOR",{"Festive","Industrial","Clean"},"DECOR")
 local hint=Instance.new("TextLabel");hint.Size=UDim2.new(1,0,0,50);hint.BackgroundTransparency=1;hint.Text="Tout s'applique directement sur ton slot. Plus de choix seront débloqués avec la progression.";hint.TextWrapped=true;hint.TextColor3=Color3.fromRGB(165,175,195);hint.Font=Enum.Font.Gotham;hint.TextSize=12;hint.Parent=body
end
customizeButton.MouseButton1Click:Connect(openCustomize)

local djGui=nil;local djRunning=false;local target=.5;local dir=1;local cursorPos=0
local function closeDJ()djRunning=false;if djGui then djGui:Destroy();djGui=nil end end
local function openDJ()
 if djGui or not p:GetAttribute("EventActive") then return end
 djRunning=true;cursorPos=0;dir=1;target=.2+math.random()*.6
 djGui=Instance.new("Frame");djGui.Size=UDim2.fromOffset(560,190);djGui.Position=UDim2.new(.5,-280,1,-285);djGui.BackgroundColor3=Color3.fromRGB(12,15,22);djGui.Parent=gui;corner(djGui,16);stroke(djGui)
 local title=Instance.new("TextLabel");title.Size=UDim2.new(1,-24,0,42);title.Position=UDim2.fromOffset(12,4);title.BackgroundTransparency=1;title.Text="TRANSITION DJ  •  SPACE / CLIC AU BON MOMENT";title.TextColor3=Color3.new(1,1,1);title.Font=Enum.Font.GothamBold;title.TextSize=15;title.Parent=djGui
 local leave=Instance.new("TextButton");leave.Size=UDim2.fromOffset(38,32);leave.Position=UDim2.new(1,-46,0,8);leave.Text="X";leave.BackgroundColor3=Color3.fromRGB(38,42,54);leave.TextColor3=Color3.new(1,1,1);leave.Font=Enum.Font.GothamBold;leave.Parent=djGui;corner(leave,8);leave.MouseButton1Click:Connect(closeDJ)
 local track=Instance.new("Frame");track.Size=UDim2.new(1,-48,0,38);track.Position=UDim2.fromOffset(24,58);track.BackgroundColor3=Color3.fromRGB(34,39,52);track.Parent=djGui;corner(track,10)
 local zone=Instance.new("Frame");zone.Size=UDim2.new(.16,0,1,0);zone.Position=UDim2.new(target-.08,0,0,0);zone.BackgroundColor3=Color3.fromRGB(70,190,125);zone.Parent=track;corner(zone,8)
 local perfect=Instance.new("Frame");perfect.Size=UDim2.new(.055,0,1,0);perfect.Position=UDim2.new(.4725,0,0,0);perfect.BackgroundColor3=Color3.fromRGB(245,205,75);perfect.Parent=zone;corner(perfect,6)
 local cursor=Instance.new("Frame");cursor.Size=UDim2.fromOffset(8,50);cursor.AnchorPoint=Vector2.new(.5,.5);cursor.Position=UDim2.new(0,0,.5,0);cursor.BackgroundColor3=Color3.new(1,1,1);cursor.Parent=track;corner(cursor,4)
 local result=Instance.new("TextLabel");result.Size=UDim2.new(1,-24,0,35);result.Position=UDim2.fromOffset(12,108);result.BackgroundTransparency=1;result.Text="Synchronise la transition";result.TextColor3=Color3.fromRGB(210,215,225);result.Font=Enum.Font.GothamBold;result.TextSize=14;result.Parent=djGui
 local hit=Instance.new("TextButton");hit.Size=UDim2.new(1,-48,0,34);hit.Position=UDim2.fromOffset(24,146);hit.Text="DROP / TRANSITION";hit.BackgroundColor3=Color3.fromRGB(92,64,220);hit.TextColor3=Color3.new(1,1,1);hit.Font=Enum.Font.GothamBold;hit.Parent=djGui;corner(hit,9)
 local locked=false
 local function attempt()
  if locked then return end;locked=true
  local d=math.abs(cursorPos-target);local rating=0
  if d<=.035 then rating=3;result.Text="PERFECT  •  HYPE +12"
  elseif d<=.08 then rating=2;result.Text="GOOD  •  HYPE +7"
  elseif d<=.15 then rating=1;result.Text="OK  •  HYPE +3"
  else result.Text="RATE  •  COMBO PERDU" end
  upgradeRemote:FireServer("DJ_HIT",rating)
  task.delay(.55,function()if not djGui then return end;target=.16+math.random()*.68;zone.Position=UDim2.new(target-.08,0,0,0);locked=false end)
 end
 hit.MouseButton1Click:Connect(attempt)
 local UIS=game:GetService("UserInputService");local conn
 conn=UIS.InputBegan:Connect(function(input,gp)if not gp and input.KeyCode==Enum.KeyCode.Space and djGui then attempt()end end)
 djGui.Destroying:Connect(function()if conn then conn:Disconnect()end end)
 task.spawn(function()while djRunning and djGui do cursorPos+=dir*.012;if cursorPos>=1 then cursorPos=1;dir=-1 elseif cursorPos<=0 then cursorPos=0;dir=1 end;cursor.Position=UDim2.new(cursorPos,0,.5,0);RunService.RenderStepped:Wait()end end)
end

local activities=Instance.new("Frame");activities.Size=UDim2.fromOffset(430,48);activities.Position=UDim2.new(.5,-215,1,-190);activities.BackgroundTransparency=1;activities.Visible=false;activities.Parent=gui
local actLayout=Instance.new("UIListLayout");actLayout.FillDirection=Enum.FillDirection.Horizontal;actLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center;actLayout.Padding=UDim.new(0,8);actLayout.Parent=activities
local activityCooldown=false
local function activityButton(label,key)
 local b=Instance.new("TextButton");b.Size=UDim2.fromOffset(132,44);b.BackgroundColor3=Color3.fromRGB(22,27,38);b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.GothamBold;b.TextSize=12;b.Text=label;b.Parent=activities;corner(b,10)
 b.MouseButton1Click:Connect(function()if activityCooldown or not p:GetAttribute("EventActive")then return end;activityCooldown=true;upgradeRemote:FireServer("ACTIVITY",key);b.Text="✓ BONUS !";task.delay(4,function()if b.Parent then b.Text=label end;activityCooldown=false end)end)
end
activityButton("🙌 CHAUFFER PUBLIC","CROWD");activityButton("✨ LANCER EFFETS","FX");activityButton("🥤 AIDER STANDS","SERVICE")
local actionsToggle=Instance.new("TextButton");actionsToggle.Size=UDim2.fromOffset(155,42);actionsToggle.Position=UDim2.new(.5,-77,1,-188);actionsToggle.BackgroundColor3=Color3.fromRGB(22,27,38);actionsToggle.TextColor3=Color3.new(1,1,1);actionsToggle.Font=Enum.Font.GothamBold;actionsToggle.TextSize=12;actionsToggle.Text="ACTIONS FESTIVAL";actionsToggle.Visible=false;actionsToggle.Parent=gui;corner(actionsToggle,10);stroke(actionsToggle)
actionsToggle.MouseButton1Click:Connect(function()activities.Visible=not activities.Visible;actionsToggle.Text=activities.Visible and "FERMER ACTIONS"or"ACTIONS FESTIVAL"end)
local launch=Instance.new("TextButton");launch.Size=UDim2.fromOffset(300,64);launch.Position=UDim2.new(.5,-150,1,-132);launch.BackgroundColor3=Color3.fromRGB(92,64,220);launch.TextColor3=Color3.new(1,1,1);launch.Font=Enum.Font.GothamBlack;launch.TextSize=18;launch.Text="▶ OUVRIR MON FESTIVAL";launch.Parent=gui;corner(launch,14);stroke(launch)
local eventBar=Instance.new("Frame");eventBar.Size=UDim2.fromOffset(360,70);eventBar.Position=UDim2.new(.5,-180,0,142);eventBar.BackgroundColor3=Color3.fromRGB(13,16,23);eventBar.Visible=false;eventBar.Parent=gui;corner(eventBar,14);stroke(eventBar)
local eventText=Instance.new("TextLabel");eventText.Size=UDim2.new(1,-20,0,30);eventText.Position=UDim2.fromOffset(10,5);eventText.BackgroundTransparency=1;eventText.TextColor3=Color3.new(1,1,1);eventText.Font=Enum.Font.GothamBold;eventText.TextSize=14;eventText.Parent=eventBar
local hypeBack=Instance.new("Frame");hypeBack.Size=UDim2.new(1,-24,0,16);hypeBack.Position=UDim2.fromOffset(12,43);hypeBack.BackgroundColor3=Color3.fromRGB(35,39,50);hypeBack.Parent=eventBar;corner(hypeBack,8)
local hypeFill=Instance.new("Frame");hypeFill.Size=UDim2.fromScale(.2,1);hypeFill.BackgroundColor3=Color3.fromRGB(105,90,235);hypeFill.Parent=hypeBack;corner(hypeFill,8)
launch.MouseButton1Click:Connect(function()upgradeRemote:FireServer("START_EVENT")end)
local function refreshEvent()
 local active=p:GetAttribute("EventActive")==true;local hype=p:GetAttribute("EventHype")or 0;local time=p:GetAttribute("EventTime")or 0
 eventBar.Visible=active;launch.Visible=not active;actionsToggle.Visible=active;if not active then activities.Visible=false;actionsToggle.Text="ACTIONS FESTIVAL"end
 eventText.Text="FESTIVAL OUVERT  •  "..time.."s  •  AMBIANCE "..hype.."%  •  "..tostring(p:GetAttribute("EventVisitors")or 0).." VISITEURS"
 hypeFill.Size=UDim2.fromScale(math.clamp(hype/100,0,1),1)
 if active then objective.Text="TON FESTIVAL EST OUVERT ! • Regarde les visiteurs arriver • DJ = bonus facultatif" end
end
for _,a in ipairs({"EventActive","EventHype","EventTime","EventVisitors"})do p:GetAttributeChangedSignal(a):Connect(refreshEvent)end;refreshEvent()
local wasEventActive=p:GetAttribute("EventActive")==true
p:GetAttributeChangedSignal("EventActive"):Connect(function()
 local active=p:GetAttribute("EventActive")==true
 if wasEventActive and not active then
  local card=Instance.new("Frame");card.Size=UDim2.fromOffset(390,150);card.Position=UDim2.new(.5,-195,.5,-75);card.BackgroundColor3=Color3.fromRGB(15,19,28);card.Parent=gui;corner(card,18);stroke(card)
  local big=Instance.new("TextLabel");big.Size=UDim2.new(1,-24,0,52);big.Position=UDim2.fromOffset(12,12);big.BackgroundTransparency=1;big.Text="FESTIVAL TERMINÉ !";big.TextColor3=Color3.new(1,1,1);big.Font=Enum.Font.GothamBlack;big.TextSize=23;big.Parent=card
  local reward=Instance.new("TextLabel");reward.Size=UDim2.new(1,-24,0,42);reward.Position=UDim2.fromOffset(12,62);reward.BackgroundTransparency=1;reward.Text="+ $"..tostring(p:GetAttribute("LastEventPayout")or 0).."   •   +"..tostring(p:GetAttribute("LastEventFans")or 0).." FANS";reward.TextColor3=Color3.fromRGB(105,225,155);reward.Font=Enum.Font.GothamBold;reward.TextSize=20;reward.Parent=card
  local hint=Instance.new("TextLabel");hint.Size=UDim2.new(1,-24,0,28);hint.Position=UDim2.fromOffset(12,108);hint.BackgroundTransparency=1;hint.Text="CONSTRUIS → puis ouvre un festival encore plus gros !";hint.TextColor3=Color3.fromRGB(210,215,225);hint.Font=Enum.Font.GothamBold;hint.TextSize=13;hint.Parent=card
  card.BackgroundTransparency=1;big.TextTransparency=1;reward.TextTransparency=1;hint.TextTransparency=1
  TweenService:Create(card,TweenInfo.new(.2),{BackgroundTransparency=.04}):Play();TweenService:Create(big,TweenInfo.new(.2),{TextTransparency=0}):Play();TweenService:Create(reward,TweenInfo.new(.2),{TextTransparency=0}):Play();TweenService:Create(hint,TweenInfo.new(.2),{TextTransparency=0}):Play()
  task.delay(3.8,function()if card.Parent then TweenService:Create(card,TweenInfo.new(.25),{BackgroundTransparency=1}):Play();task.wait(.3);card:Destroy()end end)
 end
 wasEventActive=active
end)
rebirthButton.MouseButton1Click:Connect(function()
 local prestige=p:GetAttribute("Prestige")or 0;local price=250000*((prestige+1)^2)
 if (p:GetAttribute("Cash")or 0)>=price then upgradeRemote:FireServer("REBIRTH") else objective.Text="RENAISSANCE • Il faut $"..price end
end)
upgradeRemote.OnClientEvent:Connect(function(action)if action=="DJ_OPEN" then openDJ()end end)
p:GetAttributeChangedSignal("EventActive"):Connect(function()if not p:GetAttribute("EventActive") then closeDJ()end end)
local upgradePanel
local branchNames={Stage="SCENE",Sound="SON",Lights="ECLAIRAGE",FX="EFFETS",Crowd="PUBLIC",Stands="STANDS",Marketing="MARKETING",Staff="EQUIPE"}
local branchOrder={"Stage","Sound","Lights","FX","Crowd","Stands","Marketing","Staff"}
local branchBase={Stage=100,Sound=80,Lights=90,FX=130,Crowd=75,Stands=110,Marketing=120,Staff=105}
local branchGrowth={Stage=1.34,Sound=1.32,Lights=1.33,FX=1.35,Crowd=1.30,Stands=1.34,Marketing=1.34,Staff=1.33}
local branchMax={Stage=40,Sound=40,Lights=40,FX=35,Crowd=50,Stands=40,Marketing=45,Staff=45}
local branchEffect={Stage="une scène plus grande",Sound="un meilleur son",Lights="de belles lumières",FX="un show plus impressionnant",Crowd="plus de visiteurs",Stands="plus d'argent",Marketing="attire plus de monde",Staff="aide ton festival"}
local function upgradeCost(key,lv)return math.floor(branchBase[key]*(branchGrowth[key]^lv))end
local function openUpgrades()
 if upgradePanel then upgradePanel:Destroy();upgradePanel=nil;return end
 upgradePanel=Instance.new("Frame");upgradePanel.Size=UDim2.fromOffset(520,520);upgradePanel.Position=UDim2.new(.5,-260,.5,-260);upgradePanel.BackgroundColor3=Color3.fromRGB(13,16,23);upgradePanel.BorderSizePixel=0;upgradePanel.Parent=gui;corner(upgradePanel,16);stroke(upgradePanel)
 local head=Instance.new("TextLabel");head.Size=UDim2.new(1,-70,0,58);head.Position=UDim2.fromOffset(22,0);head.BackgroundTransparency=1;head.Text="QUE VEUX-TU CONSTRUIRE ?";head.TextXAlignment=Enum.TextXAlignment.Left;head.TextColor3=Color3.new(1,1,1);head.Font=Enum.Font.GothamBold;head.TextSize=20;head.Parent=upgradePanel
 local close=Instance.new("TextButton");close.Size=UDim2.fromOffset(42,42);close.Position=UDim2.new(1,-52,0,8);close.Text="X";close.BackgroundColor3=Color3.fromRGB(30,34,45);close.TextColor3=Color3.new(1,1,1);close.Font=Enum.Font.GothamBold;close.Parent=upgradePanel;corner(close,10);close.MouseButton1Click:Connect(function()upgradePanel:Destroy();upgradePanel=nil end)
 local grid=Instance.new("Frame");grid.BackgroundTransparency=1;grid.Position=UDim2.fromOffset(18,64);grid.Size=UDim2.new(1,-36,1,-82);grid.Parent=upgradePanel
 local layout=Instance.new("UIGridLayout");layout.CellSize=UDim2.new(.5,-7,0,92);layout.CellPadding=UDim2.fromOffset(12,12);layout.Parent=grid
 for _,key in ipairs(branchOrder)do
  local b=Instance.new("TextButton");b.BackgroundColor3=Color3.fromRGB(24,28,38);b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.GothamBold;b.TextSize=14;b.TextWrapped=true;b.Parent=grid;corner(b,12);stroke(b)
  local function redraw()
   local lv=p:GetAttribute(key.."Level")or 0
   if lv>=branchMax[key] then b.Text=branchNames[key].."\nNIVEAU "..lv.." • MAX"
   else b.Text=branchNames[key].."  •  NIV. "..lv.."\n"..branchEffect[key].."\nACHETER  $"..upgradeCost(key,lv) end
  end
  redraw();p:GetAttributeChangedSignal(key.."Level"):Connect(redraw);b.MouseButton1Click:Connect(function()if p:GetAttribute("EventActive")then objective.Text="LE FESTIVAL EST OUVERT • Construis après le show !" else upgradeRemote:FireServer("BUY",key)end end)
 end
end
upgradesButton.MouseButton1Click:Connect(openUpgrades)
local music=ReplicatedStorage:WaitForChild("FestivalMusic");local panel
local function openMusic(items,productId,styles)
 if panel then panel:Destroy()end
 panel=Instance.new("Frame");panel.Size=UDim2.fromOffset(560,430);panel.Position=UDim2.new(.5,-280,.5,-215);panel.BackgroundColor3=Color3.fromRGB(12,15,22);panel.Parent=gui;corner(panel,16);stroke(panel)
 local head=Instance.new("TextLabel");head.Size=UDim2.new(1,-70,0,48);head.Position=UDim2.fromOffset(18,0);head.BackgroundTransparency=1;head.Text="MUSIQUE DU MAINSTAGE";head.TextXAlignment=Enum.TextXAlignment.Left;head.TextColor3=Color3.new(1,1,1);head.Font=Enum.Font.GothamBlack;head.TextSize=18;head.Parent=panel
 local close=Instance.new("TextButton");close.Size=UDim2.fromOffset(38,34);close.Position=UDim2.new(1,-48,0,8);close.Text="X";close.BackgroundColor3=Color3.fromRGB(32,36,47);close.TextColor3=Color3.new(1,1,1);close.Parent=panel;corner(close,9);close.MouseButton1Click:Connect(function()panel:Destroy();panel=nil end)
 local tabs=Instance.new("ScrollingFrame");tabs.Size=UDim2.new(1,-24,0,50);tabs.Position=UDim2.fromOffset(12,52);tabs.BackgroundTransparency=1;tabs.BorderSizePixel=0;tabs.ScrollBarThickness=3;tabs.ScrollingDirection=Enum.ScrollingDirection.X;tabs.CanvasSize=UDim2.fromOffset(math.max(520,#styles*112),0);tabs.Parent=panel
 local tl=Instance.new("UIListLayout");tl.FillDirection=Enum.FillDirection.Horizontal;tl.Padding=UDim.new(0,7);tl.Parent=tabs
 local songs=Instance.new("ScrollingFrame");songs.Size=UDim2.new(1,-24,1,-116);songs.Position=UDim2.fromOffset(12,108);songs.BackgroundTransparency=1;songs.BorderSizePixel=0;songs.ScrollBarThickness=5;songs.AutomaticCanvasSize=Enum.AutomaticSize.Y;songs.CanvasSize=UDim2.new();songs.Parent=panel
 local sl=Instance.new("UIListLayout");sl.Padding=UDim.new(0,7);sl.Parent=songs
 local function showStyle(style)
  for _,v in ipairs(songs:GetChildren())do if v:IsA("GuiButton")then v:Destroy()end end
  for i,e in ipairs(items)do if (e.style or e.genre)==style then local b=Instance.new("TextButton");b.Size=UDim2.new(1,-8,0,48);b.BackgroundColor3=Color3.fromRGB(25,30,42);b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.GothamBold;b.TextSize=13;b.Text=e.name.."  •  "..e.genre;b.Parent=songs;corner(b,9);b.MouseButton1Click:Connect(function()music:FireServer("SELECT",i)end)end end
 end
 for _,style in ipairs(styles)do local b=Instance.new("TextButton");b.Size=UDim2.fromOffset(105,40);b.BackgroundColor3=Color3.fromRGB(31,36,49);b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.GothamBold;b.TextSize=10;b.Text=style;b.Parent=tabs;corner(b,9);b.MouseButton1Click:Connect(function()showStyle(style);music:FireServer("STYLE",style)end)end
 if styles[1]then showStyle(styles[1])end
end
music.OnClientEvent:Connect(function(action,a,b,c)
 if action=="OPEN"then openMusic(a,b,c or{})elseif action=="NOW"then now.Text="MAINSTAGE  •  "..a.."  •  "..b.."  •  file "..c elseif action=="STYLE_NOW"then now.Text="MAINSTAGE  •  RADIO "..a.."  •  "..b.." TITRES"end
end)
local function refresh()stats.Text="$"..tostring(p:GetAttribute("Cash")or 0).."   •   "..tostring(p:GetAttribute("Fans")or 0).." FANS   •   "..totalProgress().." AMELIORATIONS   •   R"..tostring(p:GetAttribute("Prestige")or 0).."   •   TOKENS "..tostring(p:GetAttribute("RebirthTokens")or 0)end
for _,a in ipairs({"Cash","Fans","Prestige","RebirthTokens","StageLevel","SoundLevel","LightsLevel","FXLevel","CrowdLevel","StandsLevel","MarketingLevel","StaffLevel"})do p:GetAttributeChangedSignal(a):Connect(refresh)end;refresh()
-- Social dances. Use Motor6D C0 poses because Roblox's default Animator overwrites Transform every frame.
local freeDance=Instance.new("TextButton");freeDance.Name="FreeDanceButton";freeDance.Size=UDim2.fromOffset(122,42);freeDance.Position=UDim2.new(1,-140,1,-62);freeDance.BackgroundColor3=Color3.fromRGB(22,27,38);freeDance.TextColor3=Color3.new(1,1,1);freeDance.Font=Enum.Font.GothamBold;freeDance.TextSize=13;freeDance.Text="DANSER";freeDance.Parent=gui;corner(freeDance,11);stroke(freeDance)
local danceMenu=nil;local dancing=false;local danceConn=nil;local joints={};local bases={}
local danceStyles={"RAVE","JUMPSTYLE","HARDSTYLE","GABBER","SHUFFLE","TEKK"}
local function motor(char,names)for _,d in ipairs(char:GetDescendants())do if d:IsA("Motor6D")then for _,n in ipairs(names)do if d.Name==n then return d end end end end end
local function stopDance()
 if danceConn then danceConn:Disconnect();danceConn=nil end
 for k,j in pairs(joints)do if j and j.Parent and bases[k]then j.C0=bases[k]end end
 joints={};bases={};dancing=false;freeDance.Text="DANSER"
end
local function startDance(style)
 stopDance();local char=p.Character;local hum=char and char:FindFirstChildOfClass("Humanoid");if not hum then return end
 joints={root=motor(char,{"Root","RootJoint"}),waist=motor(char,{"Waist"}),neck=motor(char,{"Neck"}),rs=motor(char,{"RightShoulder","Right Shoulder"}),ls=motor(char,{"LeftShoulder","Left Shoulder"}),rh=motor(char,{"RightHip","Right Hip"}),lh=motor(char,{"LeftHip","Left Hip"})}
 for k,j in pairs(joints)do if j then bases[k]=j.C0 end end
 if not next(bases)then freeDance.Text="AVATAR NON COMPATIBLE";task.delay(1.5,function()freeDance.Text="DANSER"end);return end
 dancing=true;freeDance.Text=style.."  X";local t=0
 danceConn=RunService.RenderStepped:Connect(function(dt)
  if not dancing or not char.Parent then stopDance();return end;if hum.MoveDirection.Magnitude>.12 then stopDance();return end;t+=dt;local s=math.sin
  local pose={root=CFrame.identity,waist=CFrame.identity,neck=CFrame.identity,rs=CFrame.identity,ls=CFrame.identity,rh=CFrame.identity,lh=CFrame.identity}
  if style=="RAVE"then pose.waist=CFrame.Angles(0,s(t*3)*.2,s(t*6)*.12);pose.rs=CFrame.Angles(-1+s(t*6)*.5,0,.6);pose.ls=CFrame.Angles(-1-s(t*6)*.5,0,-.6);pose.rh=CFrame.Angles(s(t*6)*.3,0,0);pose.lh=CFrame.Angles(-s(t*6)*.3,0,0)
  elseif style=="JUMPSTYLE"then pose.root=CFrame.new(0,math.abs(s(t*8))*.1,0);pose.rs=CFrame.Angles(.2+s(t*8)*.25,0,.2);pose.ls=CFrame.Angles(.2-s(t*8)*.25,0,-.2);pose.rh=CFrame.Angles(s(t*8)*1.15,0,0);pose.lh=CFrame.Angles(-s(t*8)*1.15,0,0)
  elseif style=="HARDSTYLE"then pose.waist=CFrame.Angles(s(t*7)*.12,s(t*3.5)*.2,0);pose.rs=CFrame.Angles(-1.35+s(t*7)*.6,0,.35);pose.ls=CFrame.Angles(-.3-s(t*7)*.65,0,-.4);pose.rh=CFrame.Angles(s(t*7)*.75,0,0);pose.lh=CFrame.Angles(-s(t*7)*.75,0,0)
  elseif style=="GABBER"then pose.root=CFrame.Angles(.14,0,s(t*5.5)*.1);pose.rs=CFrame.Angles(-.5+s(t*11)*.7,0,.6);pose.ls=CFrame.Angles(-.5-s(t*11)*.7,0,-.6);pose.rh=CFrame.Angles(s(t*11)*1.0,0,.14);pose.lh=CFrame.Angles(-s(t*11)*1.0,0,-.14)
  elseif style=="SHUFFLE"then pose.waist=CFrame.Angles(0,s(t*4)*.42,s(t*8)*.1);pose.rs=CFrame.Angles(-.6,0,.7+s(t*4)*.28);pose.ls=CFrame.Angles(-.6,0,-.7-s(t*4)*.28);pose.rh=CFrame.Angles(s(t*8)*.65,s(t*4)*.28,0);pose.lh=CFrame.Angles(-s(t*8)*.65,-s(t*4)*.28,0)
  else pose.root=CFrame.Angles(.2,s(t*4.5)*.1,s(t*9)*.08);pose.neck=CFrame.Angles(-.12+s(t*4.5)*.1,0,0);pose.rs=CFrame.Angles(-1.5+s(t*9)*.7,0,.5);pose.ls=CFrame.Angles(-.7-s(t*9)*.5,0,-.75);pose.rh=CFrame.Angles(s(t*9)*1.1,0,.16);pose.lh=CFrame.Angles(-s(t*9)*1.1,0,-.16)end
  for k,v in pairs(pose)do local j=joints[k];if j and bases[k]then j.C0=bases[k]*v end end
 end)
end
local function toggleDanceMenu()
 if dancing then stopDance();return end;if danceMenu then danceMenu:Destroy();danceMenu=nil;return end
 danceMenu=Instance.new("Frame");danceMenu.Size=UDim2.fromOffset(260,156);danceMenu.Position=UDim2.new(1,-278,1,-224);danceMenu.BackgroundColor3=Color3.fromRGB(13,16,23);danceMenu.Parent=gui;corner(danceMenu,14);stroke(danceMenu)
 local grid=Instance.new("UIGridLayout");grid.CellSize=UDim2.fromOffset(116,40);grid.CellPadding=UDim2.fromOffset(8,8);grid.HorizontalAlignment=Enum.HorizontalAlignment.Center;grid.VerticalAlignment=Enum.VerticalAlignment.Center;grid.Parent=danceMenu
 for _,style in ipairs(danceStyles)do local bt=Instance.new("TextButton");bt.BackgroundColor3=Color3.fromRGB(29,34,46);bt.TextColor3=Color3.new(1,1,1);bt.Font=Enum.Font.GothamBold;bt.TextSize=11;bt.Text=style;bt.Parent=danceMenu;corner(bt,9);bt.MouseButton1Click:Connect(function()danceMenu:Destroy();danceMenu=nil;startDance(style)end)end
end
freeDance.MouseButton1Click:Connect(toggleDanceMenu);p.CharacterAdded:Connect(stopDance)

local danceRemote=ReplicatedStorage:WaitForChild("DanceBattleRemote")
local danceGui=nil;local danceRun=false
local function closeDance()danceRun=false;if danceGui then danceGui:Destroy();danceGui=nil end end
danceRemote.OnClientEvent:Connect(function(action,a,b,c)
 if action=="START"then
  closeDance();danceRun=true
  danceGui=Instance.new("Frame");danceGui.Size=UDim2.fromOffset(520,170);danceGui.Position=UDim2.new(.5,-260,1,-250);danceGui.BackgroundColor3=Color3.fromRGB(12,15,22);danceGui.Parent=gui;corner(danceGui,16);stroke(danceGui)
  local title=Instance.new("TextLabel");title.Size=UDim2.new(1,-24,0,38);title.Position=UDim2.fromOffset(12,5);title.BackgroundTransparency=1;title.Text="DANCE BATTLE  •  VS "..tostring(a);title.TextColor3=Color3.new(1,1,1);title.Font=Enum.Font.GothamBlack;title.TextSize=17;title.Parent=danceGui
  local track=Instance.new("Frame");track.Size=UDim2.new(1,-44,0,40);track.Position=UDim2.fromOffset(22,55);track.BackgroundColor3=Color3.fromRGB(35,40,52);track.Parent=danceGui;corner(track,10)
  local zone=Instance.new("Frame");zone.Size=UDim2.new(.14,0,1,0);zone.BackgroundColor3=Color3.fromRGB(80,205,145);zone.Parent=track;corner(zone,8)
  local cursor=Instance.new("Frame");cursor.Size=UDim2.fromOffset(8,52);cursor.AnchorPoint=Vector2.new(.5,.5);cursor.BackgroundColor3=Color3.new(1,1,1);cursor.Parent=track;corner(cursor,4)
  local info=Instance.new("TextLabel");info.Size=UDim2.new(1,-24,0,42);info.Position=UDim2.fromOffset(12,108);info.BackgroundTransparency=1;info.Text="SPACE / CLIC • fais le meilleur score en 25 secondes";info.TextColor3=Color3.fromRGB(215,220,230);info.Font=Enum.Font.GothamBold;info.TextSize=13;info.Parent=danceGui
  local target=.2+math.random()*.6;local pos=0;local dir=1;local locked=false;zone.Position=UDim2.new(target-.07,0,0,0)
  local function hit()if locked then return end;locked=true;local d=math.abs(pos-target);local rating=d<.035 and 3 or(d<.075 and 2 or(d<.14 and 1 or 0));danceRemote:FireServer("HIT",rating);info.Text=rating==3 and "PERFECT +50"or rating==2 and "GOOD +25"or rating==1 and "OK +10"or "RATÉ";task.delay(.38,function()if danceGui then target=.15+math.random()*.7;zone.Position=UDim2.new(target-.07,0,0,0);locked=false end end)end
  local UIS=game:GetService("UserInputService");local conn;conn=UIS.InputBegan:Connect(function(inp,gp)if not gp and inp.KeyCode==Enum.KeyCode.Space and danceGui then hit()end end);track.InputBegan:Connect(function(inp)if inp.UserInputType==Enum.UserInputType.MouseButton1 then hit()end end);danceGui.Destroying:Connect(function()if conn then conn:Disconnect()end end)
  task.spawn(function()while danceRun and danceGui do pos+=dir*.014;if pos>=1 then pos=1;dir=-1 elseif pos<=0 then pos=0;dir=1 end;cursor.Position=UDim2.new(pos,0,.5,0);RunService.RenderStepped:Wait()end end)
 elseif action=="END"then
  closeDance();objective.Text=(c and "DANCE BATTLE GAGNÉ !  +"or"DANCE BATTLE TERMINÉ  +")..(c and "90"or"45").."$  •  "..tostring(a).." - "..tostring(b)
 end
end)
local enabled=false;cam.MouseButton1Click:Connect(function()enabled=not enabled;cam.Text="CAM : "..(enabled and "ON"or"OFF")end)
RunService:BindToRenderStep("MusicCam",Enum.RenderPriority.Camera.Value+1,function(dt)
 local world=workspace:FindFirstChild("FestivalWorld");local stage=world and world:FindFirstChild("Mainstage");local screen=stage and stage:FindFirstChild("Screen");local mainSound=screen and screen:FindFirstChild("Music");local root=p.Character and p.Character:FindFirstChild("HumanoidRootPart");local camera=workspace.CurrentCamera
 local sound=mainSound;local source=screen
 local plots=world and world:FindFirstChild("Plots");local pi=p:GetAttribute("PlotIndex");local plot=pi and plots and plots:FindFirstChild("Plot"..pi);local slotSound=plot and plot:FindFirstChild("SlotMusic",true)
 if slotSound and root then local sp=slotSound.Parent;if sp and sp:IsA("BasePart")and(root.Position-sp.Position).Magnitude<125 then sound=slotSound;source=sp end end
 if enabled and sound and root and source and(root.Position-source.Position).Magnitude<300 then local e=math.clamp(sound.PlaybackLoudness/500,0,1);local beat=e*e;camera.FieldOfView=70+beat*6;camera.CFrame*=CFrame.new(math.sin(os.clock()*18)*beat*.1,math.cos(os.clock()*15)*beat*.075,0)*CFrame.Angles(0,0,math.rad(math.sin(os.clock()*9)*beat*.32)) elseif camera then camera.FieldOfView+=(70-camera.FieldOfView)*math.min(dt*7,1)end
end)
