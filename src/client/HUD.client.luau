local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local p=Players.LocalPlayer
local gui=Instance.new("ScreenGui");gui.Name="FestivalHUD";gui.ResetOnSpawn=false;gui.Parent=p:WaitForChild("PlayerGui")
local function label(pos,size,text)
 local x=Instance.new("TextLabel");x.Position=pos;x.Size=size;x.BackgroundColor3=Color3.fromRGB(18,21,28);x.BackgroundTransparency=.08;x.TextColor3=Color3.new(1,1,1);x.Font=Enum.Font.GothamBold;x.TextSize=15;x.Text=text;x.BorderSizePixel=0;x.Parent=gui
 local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,9);c.Parent=x;return x
end
local stats=label(UDim2.new(1,-285,0,18),UDim2.fromOffset(265,46),"")
local now=label(UDim2.new(.5,-220,1,-58),UDim2.fromOffset(440,40),"MAINSTAGE • chargement...")
local cam=Instance.new("TextButton");cam.Position=UDim2.new(0,18,1,-58);cam.Size=UDim2.fromOffset(185,40);cam.BackgroundColor3=Color3.fromRGB(18,21,28);cam.TextColor3=Color3.new(1,1,1);cam.Font=Enum.Font.GothamBold;cam.TextSize=13;cam.Text="CAMÉRA MUSICALE : OFF";cam.Parent=gui
local cc=Instance.new("UICorner");cc.CornerRadius=UDim.new(0,9);cc.Parent=cam
local music=ReplicatedStorage:WaitForChild("FestivalMusic")
local panel
local function open(items,productId)
 if panel then panel:Destroy() end
 panel=Instance.new("Frame");panel.Size=UDim2.fromOffset(420,300);panel.Position=UDim2.new(.5,-210,.5,-150);panel.BackgroundColor3=Color3.fromRGB(18,21,28);panel.Parent=gui
 local l=Instance.new("UIListLayout");l.Padding=UDim.new(0,8);l.Parent=panel
 for i,e in ipairs(items) do local b=Instance.new("TextButton");b.Size=UDim2.new(1,0,0,55);b.Text=e.name.." • "..e.genre..(productId==0 and " • TEST" or " • ROBUX");b.Font=Enum.Font.GothamBold;b.TextSize=15;b.Parent=panel;b.MouseButton1Click:Connect(function()music:FireServer("SELECT",i);panel:Destroy();panel=nil end) end
end
music.OnClientEvent:Connect(function(action,a,b,c)if action=="OPEN" then open(a,b)elseif action=="NOW" then now.Text="MAINSTAGE • "..a.." • choisi par "..b.." • file "..c end end)
local function refresh()stats.Text="💵 $"..tostring(player:GetAttribute("Cash")or 0).."   👥 "..tostring(player:GetAttribute("Fans")or 0).."   ⭐ "..tostring(totalProgress()).." upgrades   ♻ "..tostring(player:GetAttribute("Prestige")or 0).." renaissances   ♦ "..tostring(player:GetAttribute("RebirthTokens")or 0).." tokens"
 -- legacy assignment disabled
 -- stats.Text="$"..tostring(p:GetAttribute("Cash") or 0).."  •  "..tostring(p:GetAttribute("Fans") or 0).." FANS  •  NIV."..tostring(p:GetAttribute("StageLevel") or 0)end
for _,a in ipairs({"Cash","Fans","StageLevel"})do p:GetAttributeChangedSignal(a):Connect(refresh)end;refresh()
local enabled=false;cam.MouseButton1Click:Connect(function()enabled=not enabled;cam.Text="CAMÉRA MUSICALE : "..(enabled and "ON" or "OFF")end)
RunService:BindToRenderStep("MusicCam",Enum.RenderPriority.Camera.Value+1,function(dt)
 local world=workspace:FindFirstChild("FestivalWorld");local stage=world and world:FindFirstChild("Mainstage");local sound=stage and stage.Screen:FindFirstChild("Music");local root=p.Character and p.Character:FindFirstChild("HumanoidRootPart");local camera=workspace.CurrentCamera
 if enabled and sound and root and (root.Position-stage.Screen.Position).Magnitude<280 then local e=math.clamp(sound.PlaybackLoudness/550,0,1);camera.FieldOfView=70+e*5;camera.CFrame*=CFrame.new(math.sin(os.clock()*17)*e*.08,math.cos(os.clock()*14)*e*.08,0)elseif camera then camera.FieldOfView+=(70-camera.FieldOfView)*math.min(dt*7,1)end
end)