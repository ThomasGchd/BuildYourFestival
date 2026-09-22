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
local stats=label(UDim2.new(1,-540,0,18),UDim2.fromOffset(520,44),"")
local now=label(UDim2.new(.5,-220,1,-58),UDim2.fromOffset(440,40),"MAINSTAGE • chargement...")
local cam=Instance.new("TextButton");cam.Position=UDim2.new(0,18,1,-58);cam.Size=UDim2.fromOffset(185,40);cam.BackgroundColor3=Color3.fromRGB(12,15,22);cam.TextColor3=Color3.new(1,1,1);cam.Font=Enum.Font.GothamBold;cam.TextSize=13;cam.Text="CAMÉRA MUSICALE : OFF";cam.Parent=gui;corner(cam);stroke(cam)

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
navButton("MA BASE",Color3.fromRGB(70,210,255),function()
 local world=workspace:FindFirstChild("FestivalWorld");local plots=world and world:FindFirstChild("Plots");local i=p:GetAttribute("PlotIndex");local plot=i and plots and plots:FindFirstChild("Plot"..i);if plot and plot:FindFirstChild("Floor")then teleport(plot.Floor.Position+Vector3.new(0,0,38))end
end)
navButton("MAINSTAGE",Color3.fromRGB(190,90,255),function()teleport(Vector3.new(0,1,-345))end)
navButton("BOUTIQUES",Color3.fromRGB(255,175,65),function()teleport(Vector3.new(145,1,-375))end)
navButton("RENAISSANCE",Color3.fromRGB(80,225,155),function()
 local world=workspace:FindFirstChild("FestivalWorld");local plots=world and world:FindFirstChild("Plots");local i=p:GetAttribute("PlotIndex");local plot=i and plots and plots:FindFirstChild("Plot"..i);local pad=plot and plot:FindFirstChild("PrestigePad");if pad then teleport(pad.Position)end
end)
navButton("AMELIORATIONS",Color3.fromRGB(255,95,130),function()
 local world=workspace:FindFirstChild("FestivalWorld");local plots=world and world:FindFirstChild("Plots");local i=p:GetAttribute("PlotIndex");local plot=i and plots and plots:FindFirstChild("Plot"..i);if plot and plot:FindFirstChild("Floor")then teleport(plot.Floor.Position+Vector3.new(0,0,40))end
end)

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
