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
  [4]="SUPER ! • Maintenant, agrandis ton festival comme tu veux"
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
local cam=Instance.new("TextButton");cam.Position=UDim2.new(0,18,1,-58);cam.Size=UDim2.fromOffset(185,40);cam.BackgroundColor3=Color3.fromRGB(12,15,22);cam.TextColor3=Color3.new(1,1,1);cam.Font=Enum.Font.GothamBold;cam.TextSize=13;cam.Text="CAMÉRA MUSICALE : OFF";cam.Parent=gui;corner(cam);stroke(cam)
local gfxLevel=2
local gfx=Instance.new("TextButton");gfx.Position=UDim2.new(0,213,1,-58);gfx.Size=UDim2.fromOffset(170,40);gfx.BackgroundColor3=Color3.fromRGB(12,15,22);gfx.TextColor3=Color3.new(1,1,1);gfx.Font=Enum.Font.GothamBold;gfx.TextSize=13;gfx.Parent=gui;corner(gfx);stroke(gfx)
local function applyGraphics()
 local names={"FAIBLE","MOYEN","ÉLEVÉ"};gfx.Text="GRAPHISMES : "..names[gfxLevel]
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

local upgradeRemote=ReplicatedStorage:WaitForChild("FestivalUpgrade")
local djGui=nil;local djRunning=false;local target=.5;local dir=1;local cursorPos=0
local function closeDJ()djRunning=false;if djGui then djGui:Destroy();djGui=nil end end
local function openDJ()
 if djGui or not p:GetAttribute("EventActive") then return end
 djRunning=true;cursorPos=0;dir=1;target=.2+math.random()*.6
 djGui=Instance.new("Frame");djGui.Size=UDim2.fromOffset(560,190);djGui.Position=UDim2.new(.5,-280,1,-285);djGui.BackgroundColor3=Color3.fromRGB(12,15,22);djGui.Parent=gui;corner(djGui,16);stroke(djGui)
 local title=Instance.new("TextLabel");title.Size=UDim2.new(1,-24,0,42);title.Position=UDim2.fromOffset(12,4);title.BackgroundTransparency=1;title.Text="TRANSITION DJ  •  SPACE / CLIC AU BON MOMENT";title.TextColor3=Color3.new(1,1,1);title.Font=Enum.Font.GothamBold;title.TextSize=15;title.Parent=djGui
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

local launch=Instance.new("TextButton");launch.Size=UDim2.fromOffset(300,64);launch.Position=UDim2.new(.5,-150,1,-132);launch.BackgroundColor3=Color3.fromRGB(92,64,220);launch.TextColor3=Color3.new(1,1,1);launch.Font=Enum.Font.GothamBlack;launch.TextSize=18;launch.Text="▶ OUVRIR MON FESTIVAL";launch.Parent=gui;corner(launch,14);stroke(launch)
local eventBar=Instance.new("Frame");eventBar.Size=UDim2.fromOffset(360,70);eventBar.Position=UDim2.new(.5,-180,0,142);eventBar.BackgroundColor3=Color3.fromRGB(13,16,23);eventBar.Visible=false;eventBar.Parent=gui;corner(eventBar,14);stroke(eventBar)
local eventText=Instance.new("TextLabel");eventText.Size=UDim2.new(1,-20,0,30);eventText.Position=UDim2.fromOffset(10,5);eventText.BackgroundTransparency=1;eventText.TextColor3=Color3.new(1,1,1);eventText.Font=Enum.Font.GothamBold;eventText.TextSize=14;eventText.Parent=eventBar
local hypeBack=Instance.new("Frame");hypeBack.Size=UDim2.new(1,-24,0,16);hypeBack.Position=UDim2.fromOffset(12,43);hypeBack.BackgroundColor3=Color3.fromRGB(35,39,50);hypeBack.Parent=eventBar;corner(hypeBack,8)
local hypeFill=Instance.new("Frame");hypeFill.Size=UDim2.fromScale(.2,1);hypeFill.BackgroundColor3=Color3.fromRGB(105,90,235);hypeFill.Parent=hypeBack;corner(hypeFill,8)
launch.MouseButton1Click:Connect(function()upgradeRemote:FireServer("START_EVENT")end)
local function refreshEvent()
 local active=p:GetAttribute("EventActive")==true;local hype=p:GetAttribute("EventHype")or 0;local time=p:GetAttribute("EventTime")or 0
 eventBar.Visible=active;launch.Visible=not active
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
  redraw();p:GetAttributeChangedSignal(key.."Level"):Connect(redraw);b.MouseButton1Click:Connect(function()upgradeRemote:FireServer("BUY",key)end)
 end
end
upgradesButton.MouseButton1Click:Connect(openUpgrades)
local music=ReplicatedStorage:WaitForChild("FestivalMusic");local panel
local function open(items,productId)
 if panel then panel:Destroy()end
 panel=Instance.new("Frame");panel.Size=UDim2.fromOffset(440,420);panel.Position=UDim2.new(.5,-220,.5,-210);panel.BackgroundColor3=Color3.fromRGB(12,15,22);panel.Parent=gui;corner(panel,16);stroke(panel)
 local list2=Instance.new("UIListLayout");list2.Padding=UDim.new(0,6);list2.Parent=panel
 for i,e in ipairs(items)do local b=Instance.new("TextButton");b.Size=UDim2.new(1,-16,0,40);b.Text=e.name.."  •  "..e.genre..(productId==0 and "  •  TEST" or "  •  ROBUX");b.BackgroundColor3=Color3.fromRGB(25,30,42);b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.GothamBold;b.TextSize=13;b.Parent=panel;corner(b,8);b.MouseButton1Click:Connect(function()music:FireServer("SELECT",i);panel:Destroy();panel=nil end)end
end
music.OnClientEvent:Connect(function(action,a,b,c)if action=="OPEN"then open(a,b)elseif action=="NOW"then now.Text="MAINSTAGE  •  "..a.."  •  "..b.."  •  file "..c end end)
local function refresh()stats.Text="$"..tostring(p:GetAttribute("Cash")or 0).."   •   "..tostring(p:GetAttribute("Fans")or 0).." FANS   •   "..totalProgress().." AMELIORATIONS   •   R"..tostring(p:GetAttribute("Prestige")or 0).."   •   TOKENS "..tostring(p:GetAttribute("RebirthTokens")or 0)end
for _,a in ipairs({"Cash","Fans","Prestige","RebirthTokens","StageLevel","SoundLevel","LightsLevel","FXLevel","CrowdLevel","StandsLevel","MarketingLevel","StaffLevel"})do p:GetAttributeChangedSignal(a):Connect(refresh)end;refresh()
local enabled=false;cam.MouseButton1Click:Connect(function()enabled=not enabled;cam.Text="CAMÉRA MUSICALE : "..(enabled and "ON"or"OFF")end)
RunService:BindToRenderStep("MusicCam",Enum.RenderPriority.Camera.Value+1,function(dt)
 local world=workspace:FindFirstChild("FestivalWorld");local stage=world and world:FindFirstChild("Mainstage");local screen=stage and stage:FindFirstChild("Screen");local sound=screen and screen:FindFirstChild("Music");local root=p.Character and p.Character:FindFirstChild("HumanoidRootPart");local camera=workspace.CurrentCamera
 if enabled and sound and root and (root.Position-screen.Position).Magnitude<280 then local e=math.clamp(sound.PlaybackLoudness/550,0,1);camera.FieldOfView=70+e*5;camera.CFrame*=CFrame.new(math.sin(os.clock()*17)*e*.08,math.cos(os.clock()*14)*e*.08,0)elseif camera then camera.FieldOfView+=(70-camera.FieldOfView)*math.min(dt*7,1)end
end)
